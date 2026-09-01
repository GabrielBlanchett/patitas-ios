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

    /// **Una sola instancia del modelo para todo el proceso.**
    ///
    /// Esto no es una optimización: es obligatorio. Core Data resuelve
    /// `MascotaCD(context:)` buscando qué entidad corresponde a la clase, y si
    /// hay dos modelos cargados que declaran `MascotaCD`, la búsqueda es
    /// ambigua y falla en tiempo de ejecución con
    /// `Failed to find a unique match for an NSEntityDescription`.
    /// Se descubrió al correr las pruebas en paralelo, cada una con su
    /// contenedor.
    ///
    /// El `nonisolated(unsafe)` tampoco es capricho. Swift 6 rechaza una
    /// propiedad estática de un tipo que no sea `Sendable`, y
    /// `NSManagedObjectModel` no lo es porque viene de la época de
    /// Objective-C. La anotación desactiva esa comprobación y la
    /// justificación es concreta: este modelo se construye una vez y a partir
    /// de ahí **solo se lee**; nadie lo muta. Apple documenta que un modelo
    /// ya usado por un coordinador es inmutable en la práctica.
    public nonisolated(unsafe) static let modeloCompartido: NSManagedObjectModel = modelo()

    /// Un contenedor aislado, con su propio archivo temporal.
    ///
    /// Cada llamada crea un archivo distinto a propósito: las pruebas de
    /// Swift Testing corren en paralelo y dos contenedores sobre el mismo
    /// archivo se estorban. En la app de verdad hay un solo contenedor y su
    /// URL es la de siempre, dentro del contenedor de la app.
    public static func contenedorAislado() throws -> NSPersistentContainer {
        let contenedor = NSPersistentContainer(
            name: "Patitas",
            managedObjectModel: modeloCompartido
        )
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("patitas-\(UUID().uuidString).sqlite")

        let descripcion = NSPersistentStoreDescription(url: url)
        descripcion.type = NSSQLiteStoreType
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
