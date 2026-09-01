import Foundation
import SwiftData

/// El mismo modelo del resto del paquete, ahora en SwiftData.
///
/// Compárese con `Mascota` (GRDB) y con `MascotaCD` (Core Data): aquí no hay
/// protocolos que conformar, ni entidad que declarar, ni subclase. Una macro
/// y ya.
@Model
public final class MascotaSD {
    public var nombre: String
    public var especie: String
    public var edadEnMeses: Int
    public var adoptada: Bool

    public init(nombre: String, especie: String, edadEnMeses: Int, adoptada: Bool = false) {
        self.nombre = nombre
        self.especie = especie
        self.edadEnMeses = edadEnMeses
        self.adoptada = adoptada
    }

    /// La misma regla del dominio que en los otros dos, para poder comparar.
    public var edadLegible: String {
        if edadEnMeses >= 12 {
            let años = edadEnMeses / 12
            return años == 1 ? "1 año" : "\(años) años"
        }
        return edadEnMeses == 1 ? "1 mes" : "\(edadEnMeses) meses"
    }
}

public enum ContenedorSwiftData {
    /// Contenedor en memoria, el que se usa en pruebas y en las vistas previas
    /// de Xcode. En la app de verdad se quita `isStoredInMemoryOnly`.
    public static func enMemoria() throws -> ModelContainer {
        let configuracion = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: MascotaSD.self, configurations: configuracion)
    }
}
