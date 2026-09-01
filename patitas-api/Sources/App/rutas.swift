import Vapor

/// Lo que viaja por la red. Es un tipo aparte del modelo de la app a
/// proposito: el capitulo de la capa de red explica por que no se debe
/// mandar el modelo de dominio tal cual por HTTP.
struct MascotaDTO: Content, Sendable {
    let id: UUID
    let nombre: String
    let edadEnMeses: Int
    let adoptada: Bool
}

/// Datos fijos por ahora. Los capitulos de la Parte VII los mueven a
/// PostgreSQL; aqui viven en memoria para que el servidor arranque sin
/// depender de nada.
let refugio: [MascotaDTO] = [
    MascotaDTO(
        id: UUID(uuidString: "6D3F1C7A-0001-4000-8000-000000000001")!,
        nombre: "Kira", edadEnMeses: 14, adoptada: false
    ),
    MascotaDTO(
        id: UUID(uuidString: "6D3F1C7A-0002-4000-8000-000000000002")!,
        nombre: "Balto", edadEnMeses: 1, adoptada: false
    ),
    MascotaDTO(
        id: UUID(uuidString: "6D3F1C7A-0003-4000-8000-000000000003")!,
        nombre: "Nube", edadEnMeses: 36, adoptada: true
    ),
]

func rutas(_ app: Application) throws {
    // Sirve para comprobar que el contenedor esta vivo sin tocar datos.
    app.get("salud") { _ in "ok" }

    app.get("mascotas") { _ in refugio }

    app.get("mascotas", ":id") { req -> MascotaDTO in
        guard let id = req.parameters.get("id", as: UUID.self),
              let mascota = refugio.first(where: { $0.id == id })
        else {
            throw Abort(.notFound, reason: "No hay ninguna mascota con ese id")
        }
        return mascota
    }
}
