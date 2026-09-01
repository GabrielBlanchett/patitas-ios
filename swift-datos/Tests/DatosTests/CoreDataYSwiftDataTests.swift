import CoreData
import Foundation
import SwiftData
import Testing
@testable import Datos

// MARK: - Core Data

@Test("Core Data guarda y recupera con un contenedor aislado")
func coreDataGuardaYRecupera() throws {
    let contenedor = try PilaCoreData.contenedorAislado()
    let contexto = contenedor.viewContext

    let kira = MascotaCD(context: contexto)
    kira.nombre = "Kira"
    kira.especie = "perro"
    kira.edadEnMeses = 14
    kira.adoptada = false
    try contexto.save()

    let peticion = MascotaCD.peticion()
    peticion.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
    let encontradas = try contexto.fetch(peticion)

    #expect(encontradas.count == 1)
    #expect(encontradas.first?.nombre == "Kira")
}

@Test("Core Data no guarda nada hasta que se llama a save")
func coreDataNecesitaSave() throws {
    let contenedor = try PilaCoreData.contenedorAislado()
    let contexto = contenedor.viewContext

    let balto = MascotaCD(context: contexto)
    balto.nombre = "Balto"
    balto.especie = "perro"
    balto.edadEnMeses = 1
    balto.adoptada = false

    // El objeto ya existe en el contexto, pero no en el almacen.
    #expect(contexto.hasChanges == true)
    #expect(contexto.insertedObjects.count == 1)

    contexto.rollback()

    #expect(contexto.hasChanges == false)
    #expect(try contexto.count(for: MascotaCD.peticion()) == 0)
}

@Test("Un predicado de Core Data filtra en el almacen, no en memoria")
func coreDataFiltraConPredicado() throws {
    let contenedor = try PilaCoreData.contenedorAislado()
    let contexto = contenedor.viewContext

    for (nombre, meses, adoptada) in [("Kira", 14, false), ("Balto", 1, false), ("Nube", 36, true)] {
        let mascota = MascotaCD(context: contexto)
        mascota.nombre = nombre
        mascota.especie = "perro"
        mascota.edadEnMeses = Int64(meses)
        mascota.adoptada = adoptada
    }
    try contexto.save()

    let peticion = MascotaCD.peticion()
    peticion.predicate = NSPredicate(format: "adoptada == NO")
    peticion.sortDescriptors = [NSSortDescriptor(key: "edadEnMeses", ascending: true)]

    #expect(try contexto.fetch(peticion).map(\.nombre) == ["Balto", "Kira"])
}

// MARK: - SwiftData

@Test("SwiftData guarda y consulta con un descriptor")
@MainActor
func swiftDataGuardaYConsulta() throws {
    let contenedor = try ContenedorSwiftData.enMemoria()
    let contexto = contenedor.mainContext

    contexto.insert(MascotaSD(nombre: "Kira", especie: "perro", edadEnMeses: 14))
    contexto.insert(MascotaSD(nombre: "Balto", especie: "perro", edadEnMeses: 1))
    contexto.insert(MascotaSD(nombre: "Nube", especie: "gato", edadEnMeses: 36, adoptada: true))
    try contexto.save()

    let descriptor = FetchDescriptor<MascotaSD>(
        sortBy: [SortDescriptor(\.nombre)]
    )
    #expect(try contexto.fetch(descriptor).map(\.nombre) == ["Balto", "Kira", "Nube"])
}

@Test("El predicado de SwiftData se comprueba al compilar, no con cadenas")
@MainActor
func swiftDataFiltraConPredicadoTipado() throws {
    let contenedor = try ContenedorSwiftData.enMemoria()
    let contexto = contenedor.mainContext

    contexto.insert(MascotaSD(nombre: "Kira", especie: "perro", edadEnMeses: 14))
    contexto.insert(MascotaSD(nombre: "Balto", especie: "perro", edadEnMeses: 1))
    contexto.insert(MascotaSD(nombre: "Nube", especie: "gato", edadEnMeses: 36, adoptada: true))
    try contexto.save()

    let descriptor = FetchDescriptor<MascotaSD>(
        predicate: #Predicate { $0.adoptada == false },
        sortBy: [SortDescriptor(\.edadEnMeses)]
    )
    #expect(try contexto.fetch(descriptor).map(\.nombre) == ["Balto", "Kira"])
}

@Test("Borrar en SwiftData quita la fila del almacen")
@MainActor
func swiftDataBorra() throws {
    let contenedor = try ContenedorSwiftData.enMemoria()
    let contexto = contenedor.mainContext

    let kira = MascotaSD(nombre: "Kira", especie: "perro", edadEnMeses: 14)
    contexto.insert(kira)
    try contexto.save()
    #expect(try contexto.fetchCount(FetchDescriptor<MascotaSD>()) == 1)

    contexto.delete(kira)
    try contexto.save()
    #expect(try contexto.fetchCount(FetchDescriptor<MascotaSD>()) == 0)
}

@Test("Los tres modelos dan la misma edad legible",
      arguments: [(1, "1 mes"), (12, "1 año"), (36, "3 años")])
func losTresCoinciden(meses: Int, esperado: String) {
    let conGRDB = Mascota(nombre: "X", especie: "perro", edadEnMeses: meses)
    let conSwiftData = MascotaSD(nombre: "X", especie: "perro", edadEnMeses: meses)
    #expect(conGRDB.edadLegible == esperado)
    #expect(conSwiftData.edadLegible == esperado)
}
