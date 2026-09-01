import Testing
@testable import Dominio

@Test("Una mascota recién creada está disponible para adopción")
func mascotaNuevaEstaDisponible() {
    let kira = Mascota(nombre: "Kira", edadEnMeses: 14)
    #expect(kira.estaDisponible)
}

@Test("Una mascota adoptada deja de estar disponible")
func mascotaAdoptadaNoEstaDisponible() {
    let nube = Mascota(nombre: "Nube", edadEnMeses: 36, adoptada: true)
    #expect(!nube.estaDisponible)
}

@Test("La edad se escribe en singular o en plural según corresponda", arguments: [
    (1, "Kira, 1 mes"),
    (11, "Kira, 11 meses"),
    (12, "Kira, 1 año"),
    (14, "Kira, 1 año y 2 meses"),
    (25, "Kira, 2 años y 1 mes"),
    (36, "Kira, 3 años"),
])
func edadSeFormateaBien(meses: Int, esperado: String) {
    let kira = Mascota(nombre: "Kira", edadEnMeses: meses)
    #expect(kira.descripcionCorta == esperado)
}

@Test("El refugio de ejemplo trae dos mascotas disponibles")
func refugioDeEjemploTieneDosDisponibles() {
    let disponibles = Mascota.refugioDeEjemplo.filter(\.estaDisponible)
    #expect(disponibles.count == 2)
    #expect(disponibles.map(\.nombre) == ["Kira", "Balto"])
}
