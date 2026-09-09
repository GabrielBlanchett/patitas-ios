// Mediciones del capitulo 118: que coleccion elegir y que cuesta.
// Todas las cifras que aparecen en ese capitulo salen de ejecutar este archivo.
import Collections
import Foundation

func medir(_ etiqueta: String, repeticiones: Int = 1, _ bloque: () -> Void) -> Double {
    let inicio = DispatchTime.now().uptimeNanoseconds
    for _ in 0 ..< repeticiones { bloque() }
    let fin = DispatchTime.now().uptimeNanoseconds
    let ms = Double(fin - inicio) / 1_000_000.0
    let pad = etiqueta.padding(toLength: max(46, etiqueta.count), withPad: " ", startingAt: 0)
    print(pad + String(format: " %10.3f ms", ms))
    return ms
}

print("== 1. Buscar: Array vs Set vs Dictionary ==")
print("   contains() sobre N elementos, 1000 busquedas de valores que SI estan")
for n in [1_000, 10_000, 100_000] {
    let arreglo = Array(0 ..< n)
    let conjunto = Set(arreglo)
    let diccionario = Dictionary(uniqueKeysWithValues: arreglo.map { ($0, true) })
    let buscados = (0 ..< 1_000).map { _ in Int.random(in: 0 ..< n) }

    print("  N = \(n)")
    let a = medir("Array.contains") {
        var golpes = 0
        for v in buscados where arreglo.contains(v) { golpes += 1 }
        precondition(golpes == 1_000)
    }
    let s = medir("Set.contains") {
        var golpes = 0
        for v in buscados where conjunto.contains(v) { golpes += 1 }
        precondition(golpes == 1_000)
    }
    let d = medir("Dictionary[clave] != nil") {
        var golpes = 0
        for v in buscados where diccionario[v] != nil { golpes += 1 }
        precondition(golpes == 1_000)
    }
    print(String(format: "  -> el Set fue %.0f veces mas rapido que el Array", a / max(s, 0.0001)))
    print(String(format: "  -> el Dictionary fue %.0f veces mas rapido que el Array", a / max(d, 0.0001)))
    print("")
}

print("== 2. Insertar al principio: Array vs Deque ==")
let cuantas = 50_000
let ap = medir("Array.append \(cuantas) veces (al final)") {
    var a: [Int] = []
    for i in 0 ..< cuantas { a.append(i) }
    precondition(a.count == cuantas)
}
let ins = medir("Array.insert(at: 0) \(cuantas) veces") {
    var a: [Int] = []
    for i in 0 ..< cuantas { a.insert(i, at: 0) }
    precondition(a.count == cuantas)
}
let deq = medir("Deque.prepend \(cuantas) veces") {
    var d: Deque<Int> = []
    for i in 0 ..< cuantas { d.prepend(i) }
    precondition(d.count == cuantas)
}
print(String(format: "  -> insert(at: 0) fue %.0f veces mas lento que append", ins / max(ap, 0.0001)))
print(String(format: "  -> Deque.prepend fue %.0f veces mas rapido que insert(at: 0)", ins / max(deq, 0.0001)))
print("")

print("== 3. reserveCapacity: 1 millon de append ==")
let sinReserva = medir("sin reserveCapacity") {
    var a: [Int] = []
    for i in 0 ..< 1_000_000 { a.append(i) }
    precondition(a.count == 1_000_000)
}
let conReserva = medir("con reserveCapacity(1_000_000)") {
    var a: [Int] = []
    a.reserveCapacity(1_000_000)
    for i in 0 ..< 1_000_000 { a.append(i) }
    precondition(a.count == 1_000_000)
}
print(String(format: "  -> reservar ahorro un %.0f%% del tiempo",
             (1 - conReserva / max(sinReserva, 0.0001)) * 100))
var crecimiento: [Int] = []
var capacidades: [Int] = []
for i in 0 ..< 100_000 {
    let antes = crecimiento.capacity
    crecimiento.append(i)
    if crecimiento.capacity != antes { capacidades.append(crecimiento.capacity) }
}
print("  -> el Array realoco \(capacidades.count) veces para llegar a 100 000 elementos")
print("  -> capacidades por las que paso: \(capacidades.prefix(12).map(String.init).joined(separator: ", ")), ...")
print("")

print("== 4. Los 10 mayores de 1 millon: ordenar todo vs Heap ==")
let datos = (0 ..< 1_000_000).map { _ in Int.random(in: 0 ..< 10_000_000) }
var top1: [Int] = []
var top2: [Int] = []
let ordenar = medir("sort() completo y tomar los 10 ultimos") {
    top1 = Array(datos.sorted().suffix(10))
}
let monticulo = medir("Heap de tamano 10 (swift-collections)") {
    var h = Heap<Int>()
    for v in datos {
        h.insert(v)
        if h.count > 10 { _ = h.popMin() }
    }
    top2 = h.unordered.sorted()
}
precondition(top1 == top2, "los dos metodos deben dar el mismo resultado")
print("  -> los dos dieron el mismo top-10: \(top1 == top2)")
print(String(format: "  -> el Heap fue %.1f veces mas rapido", ordenar / max(monticulo, 0.0001)))
print("")

print("== 5. Quitar duplicados conservando el orden ==")
let conRepetidos = (0 ..< 200_000).map { _ in Int.random(in: 0 ..< 20_000) }
var r1: [Int] = []
var r2: [Int] = []
let ingenuo = medir("Array + contains (el que todos escriben)") {
    var vistos: [Int] = []
    for v in conRepetidos where !vistos.contains(v) { vistos.append(v) }
    r1 = vistos
}
let ordenado = medir("OrderedSet (swift-collections)") {
    var s = OrderedSet<Int>()
    for v in conRepetidos { s.append(v) }
    r2 = Array(s)
}
precondition(r1 == r2, "los dos metodos deben dar el mismo resultado, en el mismo orden")
print("  -> mismo resultado y mismo orden: \(r1 == r2), \(r1.count) unicos")
print(String(format: "  -> OrderedSet fue %.0f veces mas rapido", ingenuo / max(ordenado, 0.0001)))
print("")

print("== 6. El coste de copiar: value semantics y COW ==")
let grande = Array(0 ..< 1_000_000)
_ = medir("copiar el arreglo 1000 veces SIN tocarlo", repeticiones: 1) {
    for _ in 0 ..< 1_000 {
        let copia = grande
        precondition(copia.count == 1_000_000)
    }
}
_ = medir("copiar y tocar un elemento 1000 veces", repeticiones: 1) {
    for _ in 0 ..< 1_000 {
        var copia = grande
        copia[0] = 1
        precondition(copia.count == 1_000_000)
    }
}
print("  -> copiar sin tocar es casi gratis: la copia real solo ocurre al escribir")
