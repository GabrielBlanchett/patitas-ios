// Cap. 79: el caso de uso AprobarSolicitud corriendo con dobles inyectados.
// Ni red, ni base de datos, ni reloj: por eso la prueba es instantanea y no falla
// por causas ajenas. Compilar con -swift-version 6.

import Foundation

// --- El dominio ---

struct Mascota: Sendable { let id: UUID; var adoptada: Bool }
enum EstadoSolicitud: Sendable, Equatable { case pendiente, aprobada, rechazada }
struct Solicitud: Sendable { let id: UUID; let mascotaId: UUID; var estado: EstadoSolicitud }
enum ErrorDeAdopcion: Error { case yaResuelta }

// --- Las fronteras: el caso de uso solo conoce estos contratos ---

protocol RepositorioDeSolicitudes: Sendable {
    func buscar(id: UUID) async throws -> Solicitud
    func guardar(_ solicitud: Solicitud) async throws
    func rechazarLasDemas(de mascotaId: UUID) async
    func estado(de id: UUID) async -> EstadoSolicitud
}

protocol RepositorioDeMascotas: Sendable {
    func marcarAdoptada(_ id: UUID) async throws
    func estaAdoptada(_ id: UUID) async -> Bool
}

protocol Notificador: Sendable {
    func avisar(_ mensaje: String)
}

// --- El caso de uso: la regla de negocio, sin una sola linea de infraestructura ---

struct AprobarSolicitud: Sendable {
    let solicitudes: RepositorioDeSolicitudes
    let mascotas: RepositorioDeMascotas
    let notificador: Notificador

    func ejecutar(id: UUID) async throws {
        var solicitud = try await solicitudes.buscar(id: id)
        guard solicitud.estado == .pendiente else { throw ErrorDeAdopcion.yaResuelta }
        solicitud.estado = .aprobada
        try await solicitudes.guardar(solicitud)
        try await mascotas.marcarAdoptada(solicitud.mascotaId)
        await solicitudes.rechazarLasDemas(de: solicitud.mascotaId)
        notificador.avisar("Tu solicitud fue aprobada")
    }
}

// --- Los dobles: todo en memoria ---

actor SolicitudesEnMemoria: RepositorioDeSolicitudes {
    private var almacen: [UUID: Solicitud] = [:]
    init(_ iniciales: [Solicitud]) { for s in iniciales { almacen[s.id] = s } }
    func buscar(id: UUID) async throws -> Solicitud { almacen[id]! }
    func guardar(_ solicitud: Solicitud) async throws { almacen[solicitud.id] = solicitud }
    func estado(de id: UUID) async -> EstadoSolicitud { almacen[id]!.estado }
    func rechazarLasDemas(de mascotaId: UUID) async {
        for (k, v) in almacen where v.mascotaId == mascotaId && v.estado == .pendiente {
            almacen[k]!.estado = .rechazada
        }
    }
}

actor MascotasEnMemoria: RepositorioDeMascotas {
    private var adoptadas: Set<UUID> = []
    func marcarAdoptada(_ id: UUID) async throws { adoptadas.insert(id) }
    func estaAdoptada(_ id: UUID) async -> Bool { adoptadas.contains(id) }
}

struct NotificadorDeConsola: Notificador {
    func avisar(_ mensaje: String) { print("   notificado: \(mensaje)") }
}

// --- La demostracion ---

let kira = UUID(), balto = UUID()
let deAna = Solicitud(id: UUID(), mascotaId: kira, estado: .pendiente)
let deLuis = Solicitud(id: UUID(), mascotaId: kira, estado: .pendiente)
let deSara = Solicitud(id: UUID(), mascotaId: balto, estado: .pendiente)

let solicitudes = SolicitudesEnMemoria([deAna, deLuis, deSara])
let mascotas = MascotasEnMemoria()
let caso = AprobarSolicitud(solicitudes: solicitudes,
                            mascotas: mascotas,
                            notificador: NotificadorDeConsola())

print("Aprobando la solicitud de Ana sobre Kira")
try await caso.ejecutar(id: deAna.id)
print("   Ana:  \(await solicitudes.estado(de: deAna.id))")
print("   Luis: \(await solicitudes.estado(de: deLuis.id))  (competia por Kira)")
print("   Sara: \(await solicitudes.estado(de: deSara.id))  (pedia a Balto)")
print("   Kira adoptada: \(await mascotas.estaAdoptada(kira))")

print("")
print("Aprobando otra vez la misma solicitud")
do {
    try await caso.ejecutar(id: deAna.id)
    print("   no deberia llegar aqui")
} catch {
    print("   rechazado: \(error)")
}
