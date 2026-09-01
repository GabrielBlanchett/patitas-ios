// Capitulo 33 - Patrones de diseño en Swift
//
// Cinco patrones clasicos escritos como se escriben HOY en Swift.
// Tres de ellos casi desaparecen: el lenguaje ya trae la solucion dentro.

struct Mascota {
    let nombre: String
    let meses: Int
    var adoptada = false
}

let censo = [
    Mascota(nombre: "Kira", meses: 14),
    Mascota(nombre: "Balto", meses: 1),
    Mascota(nombre: "Nube", meses: 36, adoptada: true),
]

// ============================================ 1. Strategy con una funcion

// El patron clasico pide un protocolo y una clase por estrategia.
// En Swift la estrategia ES una funcion, y se pasa como cualquier valor.
typealias Criterio = (Mascota) -> Bool

func listar(_ mascotas: [Mascota], donde criterio: Criterio) -> [String] {
    mascotas.filter(criterio).map(\.nombre)
}

let disponibles: Criterio = { !$0.adoptada }
let cachorros: Criterio = { $0.meses < 12 }

// ==================================================== 2. Adapter

// Lo que manda un servidor viejo que no podemos cambiar.
struct RegistroLegado {
    let pet_name: String
    let age_months: Int
    let status: String
}

// El adaptador traduce en la frontera. El resto de la app no se entera.
extension Mascota {
    init(legado: RegistroLegado) {
        self.init(nombre: legado.pet_name,
                  meses: legado.age_months,
                  adoptada: legado.status == "ADOPTED")
    }
}

// ============================================ 3. Repository con protocolo

protocol RepositorioDeMascotas {
    func todas() -> [Mascota]
}

struct RepositorioEnMemoria: RepositorioDeMascotas {
    let datos: [Mascota]
    func todas() -> [Mascota] { datos }
}

struct RepositorioVacio: RepositorioDeMascotas {
    func todas() -> [Mascota] { [] }
}

// La pantalla depende del protocolo, no de quien lo cumple.
func resumenDePantalla(_ repo: RepositorioDeMascotas) -> String {
    let m = repo.todas()
    return m.isEmpty ? "No hay mascotas todavia" : "\(m.count) mascotas: \(m.map(\.nombre).joined(separator: ", "))"
}

// ============================================ 4. Observer con AsyncStream

enum EventoDeRefugio {
    case ingreso(String)
    case adopcion(String)
}

func canalDeEventos() -> AsyncStream<EventoDeRefugio> {
    AsyncStream { continuacion in
        continuacion.yield(.ingreso("Kira"))
        continuacion.yield(.ingreso("Balto"))
        continuacion.yield(.adopcion("Nube"))
        continuacion.finish()
    }
}

// ============================================ 5. Singleton y su precio

final class ContadorGlobal {
    static let compartido = ContadorGlobal()
    private init() {}
    var visitas = 0
}

func abrirPantalla() {
    ContadorGlobal.compartido.visitas += 1
}

// Sin singleton: el contador se pasa, y cada prueba tiene el suyo.
final class Contador {
    var visitas = 0
}
func abrirPantalla(contando contador: Contador) {
    contador.visitas += 1
}

// ============================================================== SALIDA

print("=== 1. Strategy: la estrategia es una funcion ===")
print("Disponibles: \(listar(censo, donde: disponibles))")
print("Cachorros:   \(listar(censo, donde: cachorros))")
print("Mayores:     \(listar(censo, donde: { $0.meses >= 24 }))")

print("=== 2. Adapter ===")
let legado = RegistroLegado(pet_name: "Kira", age_months: 14, status: "AVAILABLE")
let adaptada = Mascota(legado: legado)
print("Del servidor: \(legado.pet_name) / \(legado.age_months) / \(legado.status)")
print("En la app:    \(adaptada.nombre), \(adaptada.meses) meses, adoptada=\(adaptada.adoptada)")

print("=== 3. Repository ===")
print("Con datos: \(resumenDePantalla(RepositorioEnMemoria(datos: censo)))")
print("Vacio:     \(resumenDePantalla(RepositorioVacio()))")

print("=== 4. Observer ===")
for await evento in canalDeEventos() {
    switch evento {
    case .ingreso(let n):  print("ingreso  -> \(n)")
    case .adopcion(let n): print("adopcion -> \(n)")
    }
}

print("=== 5. Singleton: el estado que sobrevive ===")
abrirPantalla()
abrirPantalla()
print("Singleton tras dos pantallas: \(ContadorGlobal.compartido.visitas)")
let contadorDePrueba = Contador()
abrirPantalla(contando: contadorDePrueba)
print("Inyectado, en una prueba:     \(contadorDePrueba.visitas)")
