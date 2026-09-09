// Tomo 2, cap. 8: los problemas resueltos, con sus casos de prueba.
// Cada uno imprime entrada y salida para que el libro cite lo ejecutado.

import Foundation

func caso(_ n: Int, _ titulo: String) { print(""); print("\(n). \(titulo)") }

// 1
caso(1, "Dos numeros que suman [dos punteros, array ordenado]")
func dosSumanOrdenado(_ a: [Int], _ obj: Int) -> (Int, Int)? {
    var i = 0, j = a.count - 1
    while i < j {
        let s = a[i] + a[j]
        if s == obj { return (i, j) }
        if s < obj { i += 1 } else { j -= 1 }
    }
    return nil
}
print("   [1,3,5,8,12] obj 13 -> \(dosSumanOrdenado([1,3,5,8,12], 13)!)")

// 2
caso(2, "El numero que aparece una sola vez [XOR]")
func unico(_ a: [Int]) -> Int { a.reduce(0, ^) }
print("   [4,1,2,1,2] -> \(unico([4,1,2,1,2]))")

// 3
caso(3, "Mover los ceros al final, en sitio")
func moverCeros(_ a: inout [Int]) {
    var escribe = 0
    for lee in a.indices where a[lee] != 0 { a[escribe] = a[lee]; escribe += 1 }
    while escribe < a.count { a[escribe] = 0; escribe += 1 }
}
var ceros = [0, 1, 0, 3, 12]
moverCeros(&ceros)
print("   [0,1,0,3,12] -> \(ceros)")

// 4
caso(4, "Subarray de suma maxima [Kadane]")
func sumaMaxima(_ a: [Int]) -> Int {
    var mejor = a[0], actual = a[0]
    for x in a.dropFirst() { actual = max(x, actual + x); mejor = max(mejor, actual) }
    return mejor
}
print("   [-2,1,-3,4,-1,2,1,-5,4] -> \(sumaMaxima([-2,1,-3,4,-1,2,1,-5,4]))")

// 5
caso(5, "Primer caracter que no se repite")
func primerUnico(_ s: String) -> Character? {
    var cuenta: [Character: Int] = [:]
    for c in s { cuenta[c, default: 0] += 1 }
    return s.first { cuenta[$0] == 1 }
}
for t in ["swift", "aabbcc"] {
    print("   \"\(t)\" -> \(primerUnico(t).map(String.init) ?? "ninguno")")
}

// 6
caso(6, "Fusionar intervalos solapados")
func fusionar(_ iv: [(Int, Int)]) -> [(Int, Int)] {
    let orden = iv.sorted { $0.0 < $1.0 }
    var r: [(Int, Int)] = []
    for i in orden {
        if let ultimo = r.last, i.0 <= ultimo.1 {
            r[r.count - 1].1 = max(ultimo.1, i.1)
        } else { r.append(i) }
    }
    return r
}
print("   [(1,3),(2,6),(8,10),(15,18)] -> \(fusionar([(1,3),(2,6),(8,10),(15,18)]))")

// 7
caso(7, "Producto de todos menos el propio, sin division")
func productoExcepto(_ a: [Int]) -> [Int] {
    var r = Array(repeating: 1, count: a.count)
    var acc = 1
    for i in a.indices { r[i] = acc; acc *= a[i] }
    acc = 1
    for i in a.indices.reversed() { r[i] *= acc; acc *= a[i] }
    return r
}
print("   [1,2,3,4] -> \(productoExcepto([1,2,3,4]))")

// 8
caso(8, "Niveles de un arbol [BFS]")
final class N { let v: Int; var i: N?; var d: N?; init(_ v: Int) { self.v = v } }
func porNiveles(_ raiz: N?) -> [[Int]] {
    guard let raiz = raiz else { return [] }
    var r: [[Int]] = [], nivel = [raiz]
    while !nivel.isEmpty {
        r.append(nivel.map(\.v))
        nivel = nivel.flatMap { [$0.i, $0.d].compactMap { $0 } }
    }
    return r
}
let a = N(3); a.i = N(9); a.d = N(20); a.d?.i = N(15); a.d?.d = N(7)
print("   arbol 3/(9,20)/(-,-,15,7) -> \(porNiveles(a))")

// 9
caso(9, "Islas en una rejilla [DFS]")
func contarIslas(_ g: [[Int]]) -> Int {
    var m = g, n = 0
    func hundir(_ x: Int, _ y: Int) {
        guard x >= 0, x < m.count, y >= 0, y < m[0].count, m[x][y] == 1 else { return }
        m[x][y] = 0
        hundir(x+1, y); hundir(x-1, y); hundir(x, y+1); hundir(x, y-1)
    }
    for x in m.indices { for y in m[0].indices where m[x][y] == 1 { n += 1; hundir(x, y) } }
    return n
}
let mapa = [[1,1,0,0],
            [1,0,0,1],
            [0,0,1,1],
            [0,0,0,0]]
print("   rejilla 4x4 -> \(contarIslas(mapa)) islas")

// 10
caso(10, "Ordenar por frecuencia y despues alfabeticamente")
func porFrecuencia(_ p: [String]) -> [String] {
    var c: [String: Int] = [:]
    for x in p { c[x, default: 0] += 1 }
    return c.sorted { $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key }
            .map { "\($0.key)(\($0.value))" }
}
print("   [kira,sol,kira,luna,sol,kira] -> \(porFrecuencia(["kira","sol","kira","luna","sol","kira"]))")
