import Foundation
import GRDB

/// Una mascota tal y como se guarda en la base local del teléfono.
///
/// Es un `struct` normal: GRDB no obliga a heredar de nada ni a marcar las
/// propiedades. Lo único que pide es conformar a tres protocolos, y los tres
/// tienen implementación automática.
public struct Mascota: Codable, Identifiable, Equatable, Sendable {
    public var id: Int64?
    public var nombre: String
    public var especie: String
    public var edadEnMeses: Int
    public var adoptada: Bool

    public init(
        id: Int64? = nil,
        nombre: String,
        especie: String,
        edadEnMeses: Int,
        adoptada: Bool = false
    ) {
        self.id = id
        self.nombre = nombre
        self.especie = especie
        self.edadEnMeses = edadEnMeses
        self.adoptada = adoptada
    }
}

// MARK: - Persistencia

extension Mascota: FetchableRecord, MutablePersistableRecord {
    /// Los nombres de las columnas. Escribirlos así evita las cadenas sueltas
    /// en las consultas: si cambia una columna, el compilador avisa.
    public enum Columnas {
        public static let id = Column(CodingKeys.id)
        public static let nombre = Column(CodingKeys.nombre)
        public static let especie = Column(CodingKeys.especie)
        public static let edadEnMeses = Column(CodingKeys.edadEnMeses)
        public static let adoptada = Column(CodingKeys.adoptada)
    }

    /// GRDB llama a esto después de insertar, para guardar el id que asignó
    /// SQLite. Por eso `id` es var y opcional.
    public mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}

// MARK: - Reglas del dominio

extension Mascota {
    /// La edad como la diría una persona, en singular o plural.
    public var edadLegible: String {
        if edadEnMeses >= 12 {
            let años = edadEnMeses / 12
            return años == 1 ? "1 año" : "\(años) años"
        }
        return edadEnMeses == 1 ? "1 mes" : "\(edadEnMeses) meses"
    }

    public var estaDisponible: Bool { !adoptada }
}
