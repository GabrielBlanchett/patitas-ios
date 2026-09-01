import Testing
@testable import PatitasiOS

@Test("El refugio de ejemplo trae dos mascotas disponibles")
func refugioDeEjemploTieneDosDisponibles() {
    let disponibles = Mascota.refugioDeEjemplo.filter(\.estaDisponible)
    #expect(disponibles.count == 2)
    #expect(disponibles.map(\.nombre) == ["Kira", "Balto"])
}

@Test("Una mascota adoptada deja de estar disponible")
func mascotaAdoptadaNoEstaDisponible() {
    var nube = Mascota(nombre: "Nube", edadEnMeses: 36)
    #expect(nube.estaDisponible)
    nube.adoptada = true
    #expect(!nube.estaDisponible)
}

@Test("La edad se escribe en singular o en plural según corresponda", arguments: [
    (1, "1 mes"),
    (11, "11 meses"),
    (12, "1 año"),
    (14, "1 año y 2 meses"),
    (25, "2 años y 1 mes"),
    (36, "3 años"),
])
func edadSeFormateaBien(meses: Int, esperado: String) {
    #expect(Mascota.edadEnPalabras(meses: meses) == esperado)
}
