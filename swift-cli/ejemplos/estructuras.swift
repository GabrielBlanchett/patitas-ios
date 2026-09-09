// Tomo 2, caps. 3 a 5: las estructuras de datos, implementadas y ejecutadas.
// Swift no trae pila, cola, arbol ni grafo: se escriben, y en una entrevista
// se espera que sepas hacerlo en cinco minutos.

import Foundation

func titulo(_ t: String) { print(""); print("--- \(t) ---") }

// ============ HASHING: el patron que resuelve media entrevista ============
titulo("Dos numeros que suman objetivo, en una sola pasada")

func dosSuman(_ nums: [Int], objetivo: Int) -> (Int, Int)? {
    var vistos: [Int: Int] = [:]              // valor -> indice
    for (i, n) in nums.enumerated() {
        if let j = vistos[objetivo - n] { return (j, i) }
        vistos[n] = i
    }
    return nil
}
print("   [2,7,11,15] objetivo 9 -> \(dosSuman([2,7,11,15], objetivo: 9)!)")
print("   [3,2,4]     objetivo 6 -> \(dosSuman([3,2,4], objetivo: 6)!)")

titulo("Agrupar anagramas con una clave normalizada")
func agruparAnagramas(_ palabras: [String]) -> [[String]] {
    var grupos: [String: [String]] = [:]
    for p in palabras { grupos[String(p.sorted()), default: []].append(p) }
    return grupos.values.map { $0.sorted() }.sorted { $0[0] < $1[0] }
}
print("   \(agruparAnagramas(["roma","amor","mora","gato","toga"]))")

// ============ PILA ============
titulo("Pila: parentesis balanceados")

struct Pila<T> {
    private var items: [T] = []
    var estaVacia: Bool { items.isEmpty }
    var cima: T? { items.last }
    mutating func meter(_ x: T) { items.append(x) }
    mutating func sacar() -> T? { items.popLast() }
}

func balanceado(_ s: String) -> Bool {
    let pares: [Character: Character] = [")": "(", "]": "[", "}": "{"]
    var pila = Pila<Character>()
    for c in s {
        if "([{".contains(c) { pila.meter(c) }
        else if let esperado = pares[c] {
            if pila.sacar() != esperado { return false }
        }
    }
    return pila.estaVacia
}
for caso in ["([]{})", "([)]", "((("] {
    print("   \"\(caso)\" -> \(balanceado(caso))")
}

// ============ COLA ============
titulo("Cola con dos pilas: sacar en O(1) amortizado")

struct Cola<T> {
    private var entrada: [T] = []
    private var salida: [T] = []
    var estaVacia: Bool { entrada.isEmpty && salida.isEmpty }
    mutating func encolar(_ x: T) { entrada.append(x) }
    mutating func desencolar() -> T? {
        if salida.isEmpty { salida = entrada.reversed(); entrada.removeAll() }
        return salida.popLast()
    }
}
var cola = Cola<String>()
for m in ["Kira", "Balto", "Nube"] { cola.encolar(m) }
var salida: [String] = []
while let x = cola.desencolar() { salida.append(x) }
print("   entraron Kira, Balto, Nube -> salieron \(salida)")

// ============ ARBOL BINARIO DE BUSQUEDA ============
titulo("Arbol binario de busqueda: insertar y recorrer")

final class Nodo {
    let valor: Int
    var izq: Nodo?
    var der: Nodo?
    init(_ v: Int) { valor = v }
}

func insertar(_ raiz: Nodo?, _ v: Int) -> Nodo {
    guard let r = raiz else { return Nodo(v) }
    if v < r.valor { r.izq = insertar(r.izq, v) } else { r.der = insertar(r.der, v) }
    return r
}

func enOrden(_ n: Nodo?, _ acc: inout [Int]) {
    guard let n = n else { return }
    enOrden(n.izq, &acc); acc.append(n.valor); enOrden(n.der, &acc)
}

func altura(_ n: Nodo?) -> Int {
    guard let n = n else { return 0 }
    return 1 + max(altura(n.izq), altura(n.der))
}

var raiz: Nodo? = nil
for v in [50, 30, 70, 20, 40, 60, 80] { raiz = insertar(raiz, v) }
var orden: [Int] = []
enOrden(raiz, &orden)
print("   insertados  50 30 70 20 40 60 80")
print("   en orden -> \(orden)")
print("   altura   -> \(altura(raiz))")

// Un arbol degenerado: insertar ya ordenado
var degenerado: Nodo? = nil
for v in 1...7 { degenerado = insertar(degenerado, v) }
print("   si se insertan ya ordenados (1..7), altura -> \(altura(degenerado))")

// ============ GRAFO: BFS y DFS ============
titulo("Grafo: recorrido en anchura y en profundidad")

let grafo: [String: [String]] = [
    "Refugio":  ["Kira", "Balto"],
    "Kira":     ["Ana"],
    "Balto":    ["Luis", "Ana"],
    "Ana":      [],
    "Luis":     ["Sara"],
    "Sara":     [],
]

func bfs(_ g: [String: [String]], desde: String) -> [String] {
    var visitados: Set<String> = [desde]
    var cola = [desde], orden: [String] = [], i = 0
    while i < cola.count {
        let actual = cola[i]; i += 1
        orden.append(actual)
        for vecino in g[actual] ?? [] where !visitados.contains(vecino) {
            visitados.insert(vecino); cola.append(vecino)
        }
    }
    return orden
}

func dfs(_ g: [String: [String]], desde: String,
         _ visitados: inout Set<String>, _ orden: inout [String]) {
    guard !visitados.contains(desde) else { return }
    visitados.insert(desde); orden.append(desde)
    for vecino in g[desde] ?? [] { dfs(g, desde: vecino, &visitados, &orden) }
}

print("   BFS desde Refugio -> \(bfs(grafo, desde: "Refugio"))")
var v: Set<String> = []; var o: [String] = []
dfs(grafo, desde: "Refugio", &v, &o)
print("   DFS desde Refugio -> \(o)")

// ============ MONTICULO ============
titulo("Monticulo minimo: los 3 mas cercanos de 10 refugios")

struct MonticuloMin {
    private var a: [Int] = []
    var estaVacio: Bool { a.isEmpty }
    mutating func meter(_ x: Int) {
        a.append(x)
        var i = a.count - 1
        while i > 0, a[(i-1)/2] > a[i] { a.swapAt(i, (i-1)/2); i = (i-1)/2 }
    }
    mutating func sacarMin() -> Int? {
        guard !a.isEmpty else { return nil }
        a.swapAt(0, a.count - 1)
        let m = a.removeLast()
        var i = 0
        while true {
            let iz = 2*i+1, de = 2*i+2
            var menor = i
            if iz < a.count, a[iz] < a[menor] { menor = iz }
            if de < a.count, a[de] < a[menor] { menor = de }
            if menor == i { break }
            a.swapAt(i, menor); i = menor
        }
        return m
    }
}

var monticulo = MonticuloMin()
let distancias = [12, 3, 47, 8, 25, 1, 33, 19, 6, 40]
for d in distancias { monticulo.meter(d) }
var tresMasCerca: [Int] = []
for _ in 0..<3 { if let m = monticulo.sacarMin() { tresMasCerca.append(m) } }
print("   distancias \(distancias)")
print("   los 3 mas cercanos -> \(tresMasCerca)")
