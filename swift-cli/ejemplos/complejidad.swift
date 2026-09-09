// Tomo 2, cap. 2: la complejidad, medida en vez de explicada.
// Mide operaciones reales sobre Array, Set y Dictionary al crecer el tamano.

import Foundation

func medir(_ etiqueta: String, _ bloque: () -> Void) -> Double {
    let inicio = DispatchTime.now().uptimeNanoseconds
    bloque()
    let fin = DispatchTime.now().uptimeNanoseconds
    return Double(fin - inicio) / 1_000_000.0    // milisegundos
}

print("Buscar 1000 elementos en una coleccion de N")
print("")
print("      N |  Array (ms) |  Set (ms) |  cuantas veces mas lento")
print("--------|-------------|-----------|-------------------------")

for n in [1_000, 10_000, 100_000] {
    let arreglo = Array(0..<n)
    let conjunto = Set(arreglo)
    let buscados = (0..<1_000).map { _ in Int.random(in: 0..<n) }

    let tA = medir("array") {
        var encontrados = 0
        for b in buscados where arreglo.contains(b) { encontrados += 1 }
        if encontrados < 0 { print("imposible") }
    }
    let tS = medir("set") {
        var encontrados = 0
        for b in buscados where conjunto.contains(b) { encontrados += 1 }
        if encontrados < 0 { print("imposible") }
    }

    let veces = tS > 0 ? tA / tS : 0
    print(String(format: "%7d | %11.2f | %9.2f | %22.0fx", n, tA, tS, veces))
}

print("")
print("Insertar 10000 elementos AL PRINCIPIO frente a AL FINAL de un Array")
let alFinal = medir("final") {
    var a: [Int] = []
    for i in 0..<10_000 { a.append(i) }
}
let alPrincipio = medir("principio") {
    var a: [Int] = []
    for i in 0..<10_000 { a.insert(i, at: 0) }
}
print(String(format: "   al final     : %7.2f ms", alFinal))
print(String(format: "   al principio : %7.2f ms", alPrincipio))
print(String(format: "   %.0f veces mas lento", alPrincipio / alFinal))

print("")
print("reserveCapacity: evitar que el array se copie al crecer")
let sinReservar = medir("sin") {
    var a: [Int] = []
    for i in 0..<1_000_000 { a.append(i) }
}
let reservando = medir("con") {
    var a: [Int] = []
    a.reserveCapacity(1_000_000)
    for i in 0..<1_000_000 { a.append(i) }
}
print(String(format: "   sin reservar : %7.2f ms", sinReservar))
print(String(format: "   reservando   : %7.2f ms", reservando))
