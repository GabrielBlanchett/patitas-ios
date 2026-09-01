import Foundation
import Testing
@testable import Datos

@Test("Una clave que nunca se escribio devuelve el valor cero del tipo")
func clavesSinEscribirDevuelvenElValorCero() {
    let preferencias = Preferencias.paraPruebas()
    #expect(preferencias.texto(.ultimoFiltro) == nil)
    #expect(preferencias.entero(.vecesAbierta) == 0)
    #expect(preferencias.bandera(.aceptoTerminos) == false)
}

@Test("Guardar y leer conserva el valor")
func guardarYLeer() {
    let preferencias = Preferencias.paraPruebas()

    preferencias.guardar("cachorros", en: .ultimoFiltro)
    preferencias.guardar(3, en: .vecesAbierta)
    preferencias.guardar(true, en: .aceptoTerminos)

    #expect(preferencias.texto(.ultimoFiltro) == "cachorros")
    #expect(preferencias.entero(.vecesAbierta) == 3)
    #expect(preferencias.bandera(.aceptoTerminos) == true)
}

@Test("Borrar deja la clave como si nunca se hubiera escrito")
func borrarVuelveAlValorCero() {
    let preferencias = Preferencias.paraPruebas()
    preferencias.guardar("cachorros", en: .ultimoFiltro)
    preferencias.borrar(.ultimoFiltro)
    #expect(preferencias.texto(.ultimoFiltro) == nil)
}

@Test("No se puede distinguir un false guardado de una clave que no existe")
func elFalsoYElVacioSeConfunden() {
    let preferencias = Preferencias.paraPruebas()

    // Nadie ha escrito nada.
    #expect(preferencias.bandera(.aceptoTerminos) == false)

    // Ahora si, y explicitamente false.
    preferencias.guardar(false, en: .aceptoTerminos)
    #expect(preferencias.bandera(.aceptoTerminos) == false)

    // Los dos casos son indistinguibles desde `bool(forKey:)`, y por eso
    // "el usuario no ha decidido" no se puede representar con un Bool.
}

@Test("Cada suite de pruebas esta aislada de las demas")
func suitesAisladas() {
    let una = Preferencias.paraPruebas()
    let otra = Preferencias.paraPruebas()

    una.guardar("cachorros", en: .ultimoFiltro)

    #expect(una.texto(.ultimoFiltro) == "cachorros")
    #expect(otra.texto(.ultimoFiltro) == nil)
}
