import Foundation
import Dominio

/// Lo que comparten las tres versiones de la misma pantalla.
///
/// El capítulo 76 a 78 escriben el **mismo** catálogo tres veces —MVC, MVVM y
/// VIPER— para poder compararlas con números en vez de con opiniones. Para que
/// la comparación signifique algo, las tres parten de aquí: el mismo
/// repositorio, el mismo error y los mismos datos.

/// De dónde salen las mascotas. Las tres arquitecturas dependen de este
/// protocolo, nunca de la red: es la inversión de dependencias del capítulo 34.
protocol RepositorioDeMascotas: Sendable {
    func todas() async throws -> [Mascota]
}

enum ErrorDeCatalogo: Error, Equatable {
    case sinConexion
    case servidor
}

/// El repositorio que usan las demostraciones: responde al instante y sin red.
struct RepositorioEnMemoria: RepositorioDeMascotas {
    var mascotas: [Mascota] = Mascota.refugioDeEjemplo
    var retraso: Duration = .milliseconds(300)
    var falla: ErrorDeCatalogo?

    func todas() async throws -> [Mascota] {
        try? await Task.sleep(for: retraso)
        if let falla { throw falla }
        return mascotas
    }
}

/// El estado de la pantalla, modelado como un enum para que los estados
/// imposibles no se puedan escribir (capítulo 55).
enum EstadoDelCatalogo: Equatable {
    case cargando
    case listo([Mascota])
    case vacio
    case fallo(String)
}

extension ErrorDeCatalogo {
    /// La traducción a algo que una persona pueda leer. Vive aquí y no en la
    /// vista para que las tres arquitecturas den exactamente el mismo texto.
    var mensaje: String {
        switch self {
        case .sinConexion: "No hay conexión. Revisa tu red e intenta de nuevo."
        case .servidor: "El servidor no respondió. Intenta más tarde."
        }
    }
}
