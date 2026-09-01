import Foundation
import GRDB

/// La base local de Patitas Seguras.
///
/// Envuelve una `DatabaseQueue` de GRDB para que el resto de la app no tenga
/// que conocer los detalles: el resto pide operaciones, no consultas.
public struct BaseDeDatos: Sendable {
    private let cola: DatabaseQueue

    /// Base en memoria. Es la que usan las pruebas: nace vacía en cada una,
    /// así que ninguna prueba contamina a la siguiente.
    public static func enMemoria() throws -> BaseDeDatos {
        try BaseDeDatos(cola: DatabaseQueue())
    }

    /// Base en disco, la de la app de verdad.
    public static func enArchivo(_ ruta: String) throws -> BaseDeDatos {
        try BaseDeDatos(cola: DatabaseQueue(path: ruta))
    }

    private init(cola: DatabaseQueue) throws {
        self.cola = cola
        try Self.migrador.migrate(cola)
    }

    // MARK: - Migraciones

    /// El esquema se construye por pasos con nombre, y GRDB recuerda cuáles ya
    /// aplicó. Un paso que ya corrió NUNCA se edita: se agrega otro detrás.
    private static var migrador: DatabaseMigrator {
        var migrador = DatabaseMigrator()

        migrador.registerMigration("v1_crea_mascotas") { db in
            try db.create(table: "mascota") { tabla in
                tabla.autoIncrementedPrimaryKey("id")
                tabla.column("nombre", .text).notNull()
                tabla.column("especie", .text).notNull()
                tabla.column("edadEnMeses", .integer).notNull()
                tabla.column("adoptada", .boolean).notNull().defaults(to: false)
            }
        }

        migrador.registerMigration("v2_indice_por_especie") { db in
            try db.create(index: "idx_mascota_especie", on: "mascota", columns: ["especie"])
        }

        return migrador
    }

    // MARK: - Operaciones

    @discardableResult
    public func guardar(_ mascota: Mascota) throws -> Mascota {
        try cola.write { db in
            var copia = mascota
            try copia.save(db)
            return copia
        }
    }

    public func todas() throws -> [Mascota] {
        try cola.read { db in
            try Mascota.order(Mascota.Columnas.nombre).fetchAll(db)
        }
    }

    public func disponibles() throws -> [Mascota] {
        try cola.read { db in
            try Mascota
                .filter(Mascota.Columnas.adoptada == false)
                .order(Mascota.Columnas.edadEnMeses)
                .fetchAll(db)
        }
    }

    public func buscar(id: Int64) throws -> Mascota? {
        try cola.read { db in try Mascota.fetchOne(db, key: id) }
    }

    public func contar() throws -> Int {
        try cola.read { db in try Mascota.fetchCount(db) }
    }

    /// Adopta una mascota y devuelve si hubo cambio. Va en una transacción
    /// porque son dos operaciones que tienen que pasar juntas.
    public func adoptar(id: Int64) throws -> Bool {
        try cola.write { db in
            guard var mascota = try Mascota.fetchOne(db, key: id),
                  mascota.estaDisponible
            else { return false }
            mascota.adoptada = true
            try mascota.update(db)
            return true
        }
    }

    /// Demuestra que una transacción es atómica: si el bloque lanza, no queda
    /// nada de lo que hizo antes.
    public func insertarLoteAtomico(_ mascotas: [Mascota], fallarAlFinal: Bool) throws {
        try cola.write { db in
            for mascota in mascotas {
                var copia = mascota
                try copia.insert(db)
            }
            if fallarAlFinal {
                throw ErrorDeDatos.loteRechazado
            }
        }
    }
}

public enum ErrorDeDatos: Error {
    case loteRechazado
}
