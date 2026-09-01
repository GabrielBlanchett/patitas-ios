import CoreData
import Foundation

/// Pila de Core Data construida **en código**, sin archivo `.xcdatamodeld`.
///
/// En una app real el modelo se dibuja en el editor de Xcode. Aquí se declara
/// a mano por dos razones: se puede compilar y probar en un paquete de
/// SwiftPM, y sobre todo deja ver qué es de verdad un modelo de Core Data
/// —tres objetos: la entidad, sus atributos y el contenedor— en vez de un
/// editor gráfico que lo esconde.
public enum PilaCoreData {

    /// El modelo: una entidad `Mascota` con cuatro atributos.
    public static func modelo() -> NSManagedObjectModel {
        let entidad = NSEntityDescription()
        entidad.name = "MascotaCD"
        entidad.managedObjectClassName = NSStringFromClass(MascotaCD.self)

        let nombre = NSAttributeDescription()
        nombre.name = "nombre"
        nombre.attributeType = .stringAttributeType
        nombre.isOptional = false

        let especie = NSAttributeDescription()
        especie.name = "especie"
        especie.attributeType = .stringAttributeType
        especie.isOptional = false

        let edad = NSAttributeDescription()
        edad.name = "edadEnMeses"
        edad.attributeType = .integer64AttributeType
        edad.isOptional = false
        edad.defaultValue = 0

        let adoptada = NSAttributeDescription()
        adoptada.name = "adoptada"
        adoptada.attributeType = .booleanAttributeType
        adoptada.isOptional = false
        adoptada.defaultValue = false

        entidad.properties = [nombre, especie, edad, adoptada]

        let modelo = NSManagedObjectModel()
        modelo.entities = [entidad]
        return modelo
    }

    /// Un contenedor en memoria: no toca el disco y muere con la prueba.
    /// En la app de verdad se quita la línea de `/dev/null` y Core Data
    /// escribe en un SQLite dentro del contenedor de la app.
    public static func contenedorEnMemoria() throws -> NSPersistentContainer {
        let contenedor = NSPersistentContainer(name: "Patitas", managedObjectModel: modelo())
        let descripcion = NSPersistentStoreDescription()
        descripcion.type = NSSQLiteStoreType
        descripcion.url = URL(fileURLWithPath: "/dev/null")
        contenedor.persistentStoreDescriptions = [descripcion]

        var errorAlCargar: Error?
        contenedor.loadPersistentStores { _, error in errorAlCargar = error }
        if let errorAlCargar { throw errorAlCargar }
        return contenedor
    }
}

/// La subclase que representa una fila. En una app la genera Xcode a partir
/// del modelo; aquí se escribe para que se vea que no tiene nada mágico.
@objc(MascotaCD)
public final class MascotaCD: NSManagedObject {
    @NSManaged public var nombre: String
    @NSManaged public var especie: String
    @NSManaged public var edadEnMeses: Int64
    @NSManaged public var adoptada: Bool

    public static func peticion() -> NSFetchRequest<MascotaCD> {
        NSFetchRequest<MascotaCD>(entityName: "MascotaCD")
    }
}
