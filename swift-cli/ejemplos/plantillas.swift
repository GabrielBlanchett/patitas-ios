// Tomo 2, caps. 6 y 7: recursion, programacion dinamica y las cinco
// plantillas que resuelven la mayoria de los problemas de entrevista.

import Foundation

func titulo(_ t: String) { print(""); print("--- \(t) ---") }

// ============ RECURSION INGENUA FRENTE A MEMOIZADA ============
titulo("Fibonacci: el coste de no recordar")

var llamadasIngenuo = 0
@MainActor func fibIngenuo(_ n: Int) -> Int {
    llamadasIngenuo += 1
    if n <= 1 { return n }
    return fibIngenuo(n - 1) + fibIngenuo(n - 2)
}

var llamadasMemo = 0
var memo: [Int: Int] = [:]
@MainActor func fibMemo(_ n: Int) -> Int {
    llamadasMemo += 1
    if n <= 1 { return n }
    if let y = memo[n] { return y }
    let r = fibMemo(n - 1) + fibMemo(n - 2)
    memo[n] = r
    return r
}

func fibIterativo(_ n: Int) -> Int {
    guard n > 1 else { return n }
    var a = 0, b = 1
    for _ in 2...n { (a, b) = (b, a + b) }
    return b
}

let n = 30
_ = fibIngenuo(n)
_ = fibMemo(n)
print("   fib(\(n)) = \(fibIterativo(n))")
print("   llamadas sin memoizar : \(llamadasIngenuo)")
print("   llamadas memoizando   : \(llamadasMemo)")
print("   iterativo             : 0 llamadas recursivas, O(1) de espacio")

// ============ PLANTILLA 1: DOS PUNTEROS ============
titulo("Plantilla 1 - Dos punteros: palindromo ignorando lo que no es letra")

func esPalindromo(_ s: String) -> Bool {
    let c = Array(s.lowercased())
    var i = 0, j = c.count - 1
    while i < j {
        while i < j, !c[i].isLetter { i += 1 }
        while i < j, !c[j].isLetter { j -= 1 }
        if c[i] != c[j] { return false }
        i += 1; j -= 1
    }
    return true
}
for caso in ["Anita lava la tina", "Kira, la mascota"] {
    print("   \"\(caso)\" -> \(esPalindromo(caso))")
}

// ============ PLANTILLA 2: VENTANA DESLIZANTE ============
titulo("Plantilla 2 - Ventana deslizante: subcadena mas larga sin repetir")

func masLargaSinRepetir(_ s: String) -> Int {
    let c = Array(s)
    var ultima: [Character: Int] = [:], inicio = 0, mejor = 0
    for (i, ch) in c.enumerated() {
        if let visto = ultima[ch], visto >= inicio { inicio = visto + 1 }
        ultima[ch] = i
        mejor = max(mejor, i - inicio + 1)
    }
    return mejor
}
for caso in ["abcabcbb", "bbbbb", "pwwkew"] {
    print("   \"\(caso)\" -> \(masLargaSinRepetir(caso))")
}

// ============ PLANTILLA 3: BUSQUEDA BINARIA ============
titulo("Plantilla 3 - Busqueda binaria: cuantos pasos con un millon")

var pasos = 0
@MainActor func binaria(_ a: [Int], _ objetivo: Int) -> Int? {
    var lo = 0, hi = a.count - 1
    while lo <= hi {
        pasos += 1
        let mid = lo + (hi - lo) / 2      // asi no desborda
        if a[mid] == objetivo { return mid }
        if a[mid] < objetivo { lo = mid + 1 } else { hi = mid - 1 }
    }
    return nil
}
let millon = Array(0..<1_000_000)
let idx = binaria(millon, 999_999)
print("   buscar 999999 en un array de 1000000")
print("   encontrado en indice \(idx!) tras \(pasos) pasos")
print("   una busqueda lineal habria hecho 1000000")

// ============ PLANTILLA 4: BFS ============
titulo("Plantilla 4 - BFS: camino mas corto en una rejilla con obstaculos")

func caminoMasCorto(_ rejilla: [[Int]]) -> Int {
    let f = rejilla.count, c = rejilla[0].count
    guard rejilla[0][0] == 0 else { return -1 }
    var visitados = Array(repeating: Array(repeating: false, count: c), count: f)
    var cola = [(0, 0, 1)], i = 0
    visitados[0][0] = true
    while i < cola.count {
        let (x, y, d) = cola[i]; i += 1
        if x == f - 1 && y == c - 1 { return d }
        for (dx, dy) in [(0,1),(1,0),(0,-1),(-1,0)] {
            let nx = x + dx, ny = y + dy
            if nx >= 0, nx < f, ny >= 0, ny < c,
               !visitados[nx][ny], rejilla[nx][ny] == 0 {
                visitados[nx][ny] = true
                cola.append((nx, ny, d + 1))
            }
        }
    }
    return -1
}
let rejilla = [[0,0,1,0],
               [1,0,1,0],
               [0,0,0,0],
               [0,1,1,0]]
print("   rejilla 4x4 con obstaculos (1 = muro)")
print("   camino mas corto de esquina a esquina -> \(caminoMasCorto(rejilla)) casillas")

// ============ PLANTILLA 5: MONTICULO / TOP K ============
titulo("Plantilla 5 - Top K: las 3 palabras mas frecuentes")

func topK(_ palabras: [String], _ k: Int) -> [(String, Int)] {
    var cuenta: [String: Int] = [:]
    for p in palabras { cuenta[p, default: 0] += 1 }
    return cuenta.sorted { $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key }
                 .prefix(k).map { ($0.key, $0.value) }
}
let texto = "kira balto kira nube kira balto sol"
print("   \"\(texto)\"")
print("   top 3 -> \(topK(texto.split(separator: " ").map(String.init), 3))")

// ============ PROGRAMACION DINAMICA ============
titulo("Programacion dinamica: subir escaleras de 1 o 2 en 2")

func formasDeSubir(_ escalones: Int) -> Int {
    guard escalones > 1 else { return 1 }
    var previo = 1, actual = 1
    for _ in 2...escalones { (previo, actual) = (actual, previo + actual) }
    return actual
}
for e in [3, 5, 10, 45] {
    print("   \(e) escalones -> \(formasDeSubir(e)) formas")
}
