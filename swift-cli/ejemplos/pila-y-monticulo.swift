// Cap. 16 y 23: la pila y el monticulo, y por que un struct y una class
// se comportan distinto al copiarlos.

struct MascotaValor { var nombre: String; var edad: Int }
final class MascotaReferencia { var nombre: String; var edad: Int
    init(nombre: String, edad: Int) { self.nombre = nombre; self.edad = edad } }

print("Cuanto ocupa cada cosa:")
print("   Int                 \(MemoryLayout<Int>.size) bytes")
print("   Double              \(MemoryLayout<Double>.size) bytes")
print("   Bool                \(MemoryLayout<Bool>.size) bytes")
print("   MascotaValor        \(MemoryLayout<MascotaValor>.size) bytes  (String 16 + Int 8)")
print("   MascotaReferencia   \(MemoryLayout<MascotaReferencia>.size) bytes  <- solo el puntero")

print("")
print("El struct se copia. Cada copia es suya:")
var a = MascotaValor(nombre: "Kira", edad: 3)
var b = a
b.nombre = "Balto"
print("   a.nombre = \(a.nombre)")
print("   b.nombre = \(b.nombre)")

print("")
print("La class no se copia. Las dos variables miran al mismo objeto:")
let c = MascotaReferencia(nombre: "Kira", edad: 3)
let d = c
d.nombre = "Balto"
print("   c.nombre = \(c.nombre)")
print("   d.nombre = \(d.nombre)")
print("   c === d  ? \(c === d)")

print("")
print("Por eso el tamano de la class no crece con sus datos:")
final class Gorda { var a = 0; var b = 0.0; var c = ""; var d = [Int]()
    var e = ""; var f = ""; var g = 0 }
struct Gordo { var a = 0; var b = 0.0; var c = ""; var d = [Int]()
    var e = ""; var f = ""; var g = 0 }
print("   Gordo  (struct, va en la pila) \(MemoryLayout<Gordo>.size) bytes")
print("   Gorda  (class, va al monticulo) \(MemoryLayout<Gorda>.size) bytes")
print("   La class siempre mide lo mismo: es una direccion, no los datos.")
