func primero<T>(_ lista: [T]) -> T? { lista.first }
print("Int:    \(primero([3, 1, 4]) ?? -1)")
print("String: \(primero(["Kira", "Balto"]) ?? "?")")

struct Pila<Elemento> {
    private var elementos: [Elemento] = []
    var cantidad: Int { elementos.count }
    mutating func meter(_ e: Elemento) { elementos.append(e) }
    mutating func sacar() -> Elemento? { elementos.popLast() }
}
var pila = Pila<String>()
pila.meter("Kira"); pila.meter("Balto")
print("\nPila: \(pila.cantidad) elementos, saco \(pila.sacar() ?? "?")")

func mayor<T: Comparable>(_ a: T, _ b: T) -> T { a > b ? a : b }
print("\nMayor Int:    \(mayor(3, 7))")
print("Mayor String: \(mayor("Kira", "Balto"))")

func describirTodos<C: Collection>(_ c: C) -> String where C.Element: CustomStringConvertible {
    c.map(\.description).joined(separator: ", ")
}
print("\nColeccion: \(describirTodos([1, 2, 3]))")

protocol Contenedor {
    associatedtype Item
    var items: [Item] { get }
    mutating func agregar(_ item: Item)
}
struct Caja<T>: Contenedor {
    var items: [T] = []
    mutating func agregar(_ item: T) { items.append(item) }
}
var caja = Caja<Int>()
caja.agregar(7); caja.agregar(9)
print("\nassociatedtype: \(caja.items)")

extension Pila where Elemento: Equatable {
    func contiene(_ e: Elemento) -> Bool { elementos.contains(e) }
}
print("Extension condicionada: \(pila.contiene("Kira"))")
