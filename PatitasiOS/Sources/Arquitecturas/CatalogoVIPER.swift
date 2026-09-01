import SwiftUI
import Dominio

// El mismo catálogo, en VIPER. Cinco piezas con nombre y responsabilidad
// separadas: View, Interactor, Presenter, Entity y Router.
//
// Se escribe entero para que el capítulo 78 pueda comparar con números en vez
// de con opiniones. Es más código que la versión MVVM y hace exactamente lo
// mismo; el capítulo explica cuándo eso se paga y cuándo no.

// MARK: - Entity

/// En VIPER, la entidad de presentación es propia y distinta del modelo de
/// dominio: la vista solo recibe lo que va a dibujar, ya formateado.
struct MascotaVista: Identifiable, Equatable {
    let id: UUID
    let nombre: String
    let edad: String
    let insignia: String?
}

// MARK: - Contratos

/// Lo que el presentador le pide a la vista. Que sea un protocolo es lo que
/// permite probar el presentador con una vista falsa.
@MainActor
protocol CatalogoVistaEntrante: AnyObject {
    func mostrar(_ estado: EstadoDeVista)
}

enum EstadoDeVista: Equatable {
    case cargando
    case listo([MascotaVista])
    case vacio
    case fallo(String)
}

/// Lo que la vista le pide al presentador.
@MainActor
protocol CatalogoPresentadorEntrante: AnyObject {
    func alAparecer() async
    func alCambiarFiltro(soloDisponibles: Bool)
    func alElegir(id: UUID)
}

/// Lo que el presentador le pide al interactor.
protocol CatalogoInteractorEntrante: Sendable {
    func obtenerMascotas() async throws -> [Mascota]
}

/// A dónde puede llevar la pantalla.
@MainActor
protocol CatalogoEnrutador: AnyObject {
    func irAlDetalle(id: UUID)
}

// MARK: - Interactor

/// La lógica de negocio y el acceso a datos. No conoce a la vista.
struct CatalogoInteractor: CatalogoInteractorEntrante {
    let repositorio: RepositorioDeMascotas

    func obtenerMascotas() async throws -> [Mascota] {
        try await repositorio.todas()
    }
}

// MARK: - Presenter

/// El que decide qué se ve. Traduce del dominio a la entidad de vista y no
/// conoce SwiftUI.
@MainActor
final class CatalogoPresentador: CatalogoPresentadorEntrante {
    weak var vista: (any CatalogoVistaEntrante)?
    private let interactor: any CatalogoInteractorEntrante
    private let enrutador: (any CatalogoEnrutador)?

    private var todas: [Mascota] = []
    private var soloDisponibles = false

    init(interactor: any CatalogoInteractorEntrante,
         enrutador: (any CatalogoEnrutador)? = nil) {
        self.interactor = interactor
        self.enrutador = enrutador
    }

    func alAparecer() async {
        vista?.mostrar(.cargando)
        do {
            todas = try await interactor.obtenerMascotas()
            presentar()
        } catch let error as ErrorDeCatalogo {
            vista?.mostrar(.fallo(error.mensaje))
        } catch {
            vista?.mostrar(.fallo(ErrorDeCatalogo.servidor.mensaje))
        }
    }

    func alCambiarFiltro(soloDisponibles nuevo: Bool) {
        soloDisponibles = nuevo
        presentar()
    }

    func alElegir(id: UUID) {
        enrutador?.irAlDetalle(id: id)
    }

    private func presentar() {
        let visibles = soloDisponibles ? todas.filter(\.estaDisponible) : todas
        guard !visibles.isEmpty else { return vista?.mostrar(.vacio) ?? () }
        vista?.mostrar(.listo(visibles.map(Self.aVista)))
    }

    /// La traducción del dominio a lo que se dibuja. En MVVM esto lo hacía la
    /// vista leyendo el modelo; aquí es explícito y comprobable.
    private static func aVista(_ mascota: Mascota) -> MascotaVista {
        MascotaVista(
            id: mascota.id,
            nombre: mascota.nombre,
            edad: Mascota.edadEnPalabras(meses: mascota.edadEnMeses),
            insignia: mascota.estaDisponible ? nil : "Adoptada"
        )
    }
}

// MARK: - Router

@MainActor
final class CatalogoRouter: CatalogoEnrutador {
    var alNavegar: ((UUID) -> Void)?

    func irAlDetalle(id: UUID) {
        alNavegar?(id)
    }
}

// MARK: - View

/// En SwiftUI la vista es un `struct`, así que el objeto que conforma
/// `CatalogoVistaEntrante` es un adaptador que guarda el estado.
@Observable
@MainActor
final class CatalogoVistaModelo: CatalogoVistaEntrante {
    var estado: EstadoDeVista = .cargando
    func mostrar(_ nuevo: EstadoDeVista) { estado = nuevo }
}

struct CatalogoVIPERView: View {
    @State private var vista = CatalogoVistaModelo()
    @State private var presentador: CatalogoPresentador
    @State private var soloDisponibles = false

    init(repositorio: RepositorioDeMascotas = RepositorioEnMemoria()) {
        let interactor = CatalogoInteractor(repositorio: repositorio)
        _presentador = State(initialValue: CatalogoPresentador(
            interactor: interactor, enrutador: CatalogoRouter()))
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Solo disponibles", isOn: $soloDisponibles)
                        .onChange(of: soloDisponibles) { _, nuevo in
                            presentador.alCambiarFiltro(soloDisponibles: nuevo)
                        }
                }
                contenido
            }
            .navigationTitle("Catálogo (VIPER)")
            .task {
                presentador.vista = vista
                await presentador.alAparecer()
            }
        }
    }

    @ViewBuilder
    private var contenido: some View {
        switch vista.estado {
        case .cargando:
            HStack { Spacer(); ProgressView(); Spacer() }
        case .listo(let mascotas):
            ForEach(mascotas) { mascota in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(mascota.nombre).font(.headline)
                        Text(mascota.edad).font(.subheadline).foregroundStyle(.secondary)
                    }
                    Spacer()
                    if let insignia = mascota.insignia {
                        Text(insignia)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.quaternary, in: Capsule())
                    }
                }
                .accessibilityElement(children: .combine)
            }
        case .vacio:
            ContentUnavailableView("Ninguna mascota", systemImage: "pawprint",
                                   description: Text("Prueba quitando el filtro."))
        case .fallo(let mensaje):
            ContentUnavailableView("No se pudo cargar", systemImage: "wifi.slash",
                                   description: Text(mensaje))
        }
    }
}

#Preview("VIPER") { CatalogoVIPERView() }
