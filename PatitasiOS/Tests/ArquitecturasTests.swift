import Foundation
import Testing
@testable import PatitasiOS

/// Las pruebas de las dos arquitecturas, escritas en paralelo a propósito.
///
/// Comprueban lo mismo con las mismas condiciones, para que el capítulo 78
/// pueda comparar cuánto cuesta probar cada una. Ninguna necesita simulador ni
/// red: las dos inyectan un repositorio en memoria.

private let sinRetraso = Duration.zero

// MARK: - MVVM

@Test("MVVM: carga y muestra las tres mascotas")
@MainActor
func mvvmCarga() async {
    let modelo = CatalogoViewModel(
        repositorio: RepositorioEnMemoria(retraso: sinRetraso))
    await modelo.cargar()
    #expect(modelo.estado == .listo(Mascota.refugioDeEjemplo))
}

@Test("MVVM: el filtro deja solo las disponibles")
@MainActor
func mvvmFiltra() async {
    let modelo = CatalogoViewModel(
        repositorio: RepositorioEnMemoria(retraso: sinRetraso))
    await modelo.cargar()
    modelo.soloDisponibles = true

    guard case .listo(let visibles) = modelo.estado else {
        Issue.record("Se esperaba .listo")
        return
    }
    // `allSatisfy` es rethrowing, y dentro de `#expect` eso obliga a un `try`
    // que la prueba no necesita. Se saca fuera y queda más legible.
    let todasDisponibles = visibles.allSatisfy(\.estaDisponible)
    #expect(visibles.count == 2)
    #expect(todasDisponibles)
}

@Test("MVVM: un fallo del repositorio se traduce a un mensaje legible")
@MainActor
func mvvmFalla() async {
    let modelo = CatalogoViewModel(repositorio: RepositorioEnMemoria(
        retraso: sinRetraso, falla: .sinConexion))
    await modelo.cargar()
    #expect(modelo.estado == .fallo(ErrorDeCatalogo.sinConexion.mensaje))
}

@Test("MVVM: sin mascotas, el estado es vacio y no una lista vacia")
@MainActor
func mvvmVacio() async {
    let modelo = CatalogoViewModel(repositorio: RepositorioEnMemoria(
        mascotas: [], retraso: sinRetraso))
    await modelo.cargar()
    #expect(modelo.estado == .vacio)
}

// MARK: - VIPER

/// La vista falsa: en VIPER hay que escribirla porque el presentador habla con
/// un protocolo, no con un objeto observable.
@MainActor
final class VistaEspia: CatalogoVistaEntrante {
    private(set) var recibidos: [EstadoDeVista] = []
    func mostrar(_ estado: EstadoDeVista) { recibidos.append(estado) }
}

@Test("VIPER: carga y presenta las tres mascotas ya formateadas")
@MainActor
func viperCarga() async {
    let espia = VistaEspia()
    let presentador = CatalogoPresentador(interactor: CatalogoInteractor(
        repositorio: RepositorioEnMemoria(retraso: sinRetraso)))
    presentador.vista = espia

    await presentador.alAparecer()

    #expect(espia.recibidos.first == .cargando)
    guard case .listo(let vistas) = espia.recibidos.last else {
        Issue.record("Se esperaba .listo")
        return
    }
    #expect(vistas.count == 3)
    // La entidad de vista llega ya formateada: la vista no calcula nada.
    #expect(vistas.first?.edad == "1 año y 2 meses")
    #expect(vistas.last?.insignia == "Adoptada")
}

@Test("VIPER: el filtro deja solo las disponibles")
@MainActor
func viperFiltra() async {
    let espia = VistaEspia()
    let presentador = CatalogoPresentador(interactor: CatalogoInteractor(
        repositorio: RepositorioEnMemoria(retraso: sinRetraso)))
    presentador.vista = espia

    await presentador.alAparecer()
    presentador.alCambiarFiltro(soloDisponibles: true)

    guard case .listo(let vistas) = espia.recibidos.last else {
        Issue.record("Se esperaba .listo")
        return
    }
    let ningunaAdoptada = vistas.allSatisfy { $0.insignia == nil }
    #expect(vistas.count == 2)
    #expect(ningunaAdoptada)
}

@Test("VIPER: un fallo del interactor se traduce a un mensaje legible")
@MainActor
func viperFalla() async {
    let espia = VistaEspia()
    let presentador = CatalogoPresentador(interactor: CatalogoInteractor(
        repositorio: RepositorioEnMemoria(retraso: sinRetraso, falla: .servidor)))
    presentador.vista = espia

    await presentador.alAparecer()

    #expect(espia.recibidos.last == .fallo(ErrorDeCatalogo.servidor.mensaje))
}

@Test("VIPER: el enrutador recibe el aviso al elegir")
@MainActor
func viperNavega() {
    let enrutador = CatalogoRouter()
    var recibido: UUID?
    enrutador.alNavegar = { recibido = $0 }

    let presentador = CatalogoPresentador(
        interactor: CatalogoInteractor(repositorio: RepositorioEnMemoria()),
        enrutador: enrutador)

    let id = UUID()
    presentador.alElegir(id: id)

    // Probar la navegacion sin simulador: eso es lo que compra el enrutador.
    #expect(recibido == id)
}
