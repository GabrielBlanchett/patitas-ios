struct MascotaValor { var nombre: String; var adoptada: Bool }
class MascotaRef { var nombre: String; var adoptada: Bool
    init(nombre: String, adoptada: Bool) { self.nombre = nombre; self.adoptada = adoptada } }

var a = MascotaValor(nombre: "Kira", adoptada: false)
var b = a
b.nombre = "Balto"
print("STRUCT  -> a: \(a.nombre), b: \(b.nombre)")

let c = MascotaRef(nombre: "Kira", adoptada: false)
let d = c
d.nombre = "Balto"
print("CLASS   -> c: \(c.nombre), d: \(d.nombre)")

print("Misma instancia?: \(c === d)")

struct Contador { var valor = 0
    mutating func incrementar() { valor += 1 } }
var contador = Contador()
contador.incrementar()
contador.incrementar()
print("mutating: \(contador.valor)")

class Animal {
    var nombre: String
    init(nombre: String) { self.nombre = nombre }
    func sonido() -> String { "..." }
    deinit { print("deinit de \(nombre)") }
}
class Perro: Animal {
    override func sonido() -> String { "Guau" }
}
func alcance() {
    let p = Perro(nombre: "Kira")
    print("herencia: \(p.nombre) dice \(p.sonido())")
}
alcance()

let mascotas = [MascotaValor(nombre: "Kira", adoptada: false)]
var copia = mascotas
copia[0].nombre = "Cambiado"
print("array de structs -> original: \(mascotas[0].nombre), copia: \(copia[0].nombre)")
