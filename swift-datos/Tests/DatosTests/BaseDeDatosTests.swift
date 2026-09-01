import Foundation
import Testing
@testable import Datos

/// Cada prueba crea su propia base en memoria. Nace vacía y muere con la
/// prueba, así que no hay orden que importe ni estado que se contagie.
private func baseConTresMascotas() throws -> BaseDeDatos {
    let base = try BaseDeDatos.enMemoria()
    try base.guardar(Mascota(nombre: "Kira", especie: "perro", edadEnMeses: 14))
    try base.guardar(Mascota(nombre: "Balto", especie: "perro", edadEnMeses: 1))
    try base.guardar(Mascota(nombre: "Nube", especie: "gato", edadEnMeses: 36, adoptada: true))
    return base
}

@Test("Una base recién creada aplica las migraciones y queda vacía")
func baseNuevaEstaVacia() throws {
    let base = try BaseDeDatos.enMemoria()
    #expect(try base.contar() == 0)
}

@Test("Al guardar, SQLite asigna el identificador")
func guardarAsignaIdentificador() throws {
    let base = try BaseDeDatos.enMemoria()
    let guardada = try base.guardar(Mascota(nombre: "Kira", especie: "perro", edadEnMeses: 14))
    #expect(guardada.id != nil)
    #expect(try base.contar() == 1)
}

@Test("Las consultas respetan el orden y el filtro que se les pide")
func consultasOrdenanYFiltran() throws {
    let base = try baseConTresMascotas()
    #expect(try base.todas().map(\.nombre) == ["Balto", "Kira", "Nube"])
    #expect(try base.disponibles().map(\.nombre) == ["Balto", "Kira"])
}

@Test("Adoptar cambia el estado una sola vez")
func adoptarEsIdempotente() throws {
    let base = try baseConTresMascotas()
    let kira = try #require(try base.todas().first { $0.nombre == "Kira" })
    let id = try #require(kira.id)

    #expect(try base.adoptar(id: id) == true)
    #expect(try base.adoptar(id: id) == false)
    #expect(try base.disponibles().map(\.nombre) == ["Balto"])
}

@Test("Una transacción que falla no deja nada a medias")
func transaccionEsAtomica() throws {
    let base = try BaseDeDatos.enMemoria()
    let lote = [
        Mascota(nombre: "Luna", especie: "gato", edadEnMeses: 24),
        Mascota(nombre: "Copo", especie: "conejo", edadEnMeses: 8),
    ]

    #expect(throws: ErrorDeDatos.self) {
        try base.insertarLoteAtomico(lote, fallarAlFinal: true)
    }
    #expect(try base.contar() == 0)

    try base.insertarLoteAtomico(lote, fallarAlFinal: false)
    #expect(try base.contar() == 2)
}

@Test("La edad se escribe en singular o en plural según corresponda",
      arguments: [
          (1, "1 mes"),
          (11, "11 meses"),
          (12, "1 año"),
          (14, "1 año"),
          (25, "2 años"),
          (36, "3 años"),
      ])
func edadLegible(meses: Int, esperado: String) {
    let mascota = Mascota(nombre: "X", especie: "perro", edadEnMeses: meses)
    #expect(mascota.edadLegible == esperado)
}
