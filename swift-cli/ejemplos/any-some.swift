protocol Adoptable {
    var nombre: String { get }
    func puedeAdoptarse() -> Bool
}
struct Perro: Adoptable {
    let nombre: String
    func puedeAdoptarse() -> Bool { true }
}
struct Gato: Adoptable {
    let nombre: String
    func puedeAdoptarse() -> Bool { false }
}

func describirAny(_ a: any Adoptable) -> String {
    "\(a.nombre): \(a.puedeAdoptarse())"
}
func describirSome(_ a: some Adoptable) -> String {
    "\(a.nombre): \(a.puedeAdoptarse())"
}

print("any:  \(describirAny(Perro(nombre: "Kira")))")
print("some: \(describirSome(Gato(nombre: "Nube")))")

let mezcla: [any Adoptable] = [Perro(nombre: "Kira"), Gato(nombre: "Nube")]
print("\nLista heterogenea:")
for a in mezcla { print("  \(a.nombre)") }

func crearPerro() -> some Adoptable { Perro(nombre: "Balto") }
print("\nRetorno opaco: \(crearPerro().nombre)")

protocol Contenedor {
    associatedtype Item
    var items: [Item] { get }
}
struct Caja<T>: Contenedor { let items: [T] }

func contarSome(_ c: some Contenedor) -> Int { c.items.count }
print("\nsome con associatedtype: \(contarSome(Caja(items: [1,2,3])))")
