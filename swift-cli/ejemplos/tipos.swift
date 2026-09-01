let nombre = "Kira"
var edadEnMeses = 14
edadEnMeses = 15

let pesoEnKilos = 8.4
let estaAdoptada = false
let inicial: Character = "K"

print("Nombre:", nombre, "->", type(of: nombre))
print("Edad:", edadEnMeses, "->", type(of: edadEnMeses))
print("Peso:", pesoEnKilos, "->", type(of: pesoEnKilos))
print("Adoptada:", estaAdoptada, "->", type(of: estaAdoptada))
print("Inicial:", inicial, "->", type(of: inicial))

let edadEnAnios = Double(edadEnMeses) / 12.0
print("Edad en anios: \(edadEnAnios)")

let entero: Int = 7
let flotante: Double = 2.0
print("Suma: \(Double(entero) + flotante)")

print("Int va de \(Int.min) a \(Int.max)")
