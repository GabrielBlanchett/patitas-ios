protocol Adoptable {
    var nombre: String { get }
    var edadEnMeses: Int { get }
    func puedeAdoptarse() -> Bool
}

extension Adoptable {
    func puedeAdoptarse() -> Bool { edadEnMeses >= 2 }
    var resumen: String { "\(nombre), \(edadEnMeses) meses" }
}

struct Perro: Adoptable {
    let nombre: String
    let edadEnMeses: Int
}

struct Gato: Adoptable {
    let nombre: String
    let edadEnMeses: Int
    func puedeAdoptarse() -> Bool { edadEnMeses >= 3 }
}

let animales: [Adoptable] = [
    Perro(nombre: "Kira", edadEnMeses: 14),
    Perro(nombre: "Balto", edadEnMeses: 1),
    Gato(nombre: "Nube", edadEnMeses: 2),
]

for a in animales {
    print("\(a.resumen) -> adoptable: \(a.puedeAdoptarse())")
}

struct Refugio: CustomStringConvertible, Equatable, Comparable {
    let nombre: String
    let capacidad: Int
    var description: String { "Refugio \(nombre) (\(capacidad))" }
    static func < (a: Refugio, b: Refugio) -> Bool { a.capacidad < b.capacidad }
}

let refugios = [
    Refugio(nombre: "Norte", capacidad: 30),
    Refugio(nombre: "Sur", capacidad: 12),
    Refugio(nombre: "Centro", capacidad: 45),
]
print("\nOrdenados: \(refugios.sorted().map(\.nombre))")
print("Descripcion: \(refugios[0])")
print("Iguales?: \(refugios[0] == refugios[1])")

protocol Identificable { var id: String { get } }
extension Identificable {
    func describir() -> String { "id=\(id)" }
}
struct Etiqueta: Identificable { let id: String }
print("\nProtocolo con extension: \(Etiqueta(id: "M-07").describir())")
