// Cap. 68: probar un flujo de navegacion con un doble del protocolo, sin simulador.
// El coordinador no habla con UIKit: habla con Navegador. Esa costura es lo que
// permite ejecutar el flujo aqui, en una consola de Windows.

struct Mascota { let nombre: String }

// La costura. En la app real la implementa un UINavigationController.
protocol Navegador: AnyObject {
    func poner(_ pantalla: String)
    func apilar(_ pantalla: String)
    func presentar(_ pantalla: String)
}

protocol CoordinadorDeCatalogo: AnyObject {
    func seEligioMascota(_ mascota: Mascota)
    func seQuiereSolicitar(_ mascota: Mascota)
}

// El coordinador de verdad: identico al del capitulo, con Navegador en el
// lugar donde alli habia un UINavigationController.
final class CatalogoCoordinator: CoordinadorDeCatalogo {
    private let navegacion: Navegador
    init(navegacion: Navegador) { self.navegacion = navegacion }

    func empezar() { navegacion.poner("Lista") }

    func seEligioMascota(_ mascota: Mascota) {
        navegacion.apilar("Detalle(\(mascota.nombre))")
    }

    func seQuiereSolicitar(_ mascota: Mascota) {
        navegacion.presentar("Solicitud(\(mascota.nombre))")
    }
}

// Otro coordinador para la MISMA lista: elegir aqui no abre el detalle,
// devuelve la eleccion. Es la fila "reutilizar la lista" de la tabla.
final class CoordinadorDeFavoritos: CoordinadorDeCatalogo {
    private let navegacion: Navegador
    private(set) var elegida: String?
    init(navegacion: Navegador) { self.navegacion = navegacion }

    func empezar() { navegacion.poner("Lista") }
    func seEligioMascota(_ mascota: Mascota) {
        elegida = mascota.nombre
        navegacion.apilar("Favoritos")
    }
    func seQuiereSolicitar(_ mascota: Mascota) { /* aqui no aplica */ }
}

// El doble: en vez de mover pantallas, apunta lo que le piden.
final class NavegadorFalso: Navegador {
    private(set) var pila: [String] = []
    private(set) var presentadas: [String] = []
    func poner(_ pantalla: String) { pila = [pantalla] }
    func apilar(_ pantalla: String) { pila.append(pantalla) }
    func presentar(_ pantalla: String) { presentadas.append(pantalla) }
}

// --- El flujo completo, sin simulador ---

let kira = Mascota(nombre: "Kira")

let navA = NavegadorFalso()
let catalogo = CatalogoCoordinator(navegacion: navA)
catalogo.empezar()
catalogo.seEligioMascota(kira)
catalogo.seQuiereSolicitar(kira)

print("Flujo de catalogo")
print("   pila:        \(navA.pila)")
print("   presentadas: \(navA.presentadas)")

let navB = NavegadorFalso()
let favoritos = CoordinadorDeFavoritos(navegacion: navB)
favoritos.empezar()
favoritos.seEligioMascota(kira)

print("")
print("La MISMA lista, con otro coordinador")
print("   pila:        \(navB.pila)")
print("   elegida:     \(favoritos.elegida ?? "ninguna")")
