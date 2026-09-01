let mascotas = 7
let jaulas = 3

print("Suma:      \(mascotas + jaulas)")
print("Resta:     \(mascotas - jaulas)")
print("Producto:  \(mascotas * jaulas)")
print("Division:  \(mascotas / jaulas)")
print("Residuo:   \(mascotas % jaulas)")

var disponibles = 10
disponibles += 3
disponibles -= 1
print("Disponibles: \(disponibles)")

let a = 14, b = 14
print("a == b: \(a == b)   a != b: \(a != b)   a < b: \(a < b)")

let tieneVacunas = true
let esCachorro = false
print("&&: \(tieneVacunas && esCachorro)")
print("||: \(tieneVacunas || esCachorro)")
print("!:  \(!tieneVacunas)")

let edad = 14
let etapa = edad < 12 ? "cachorro" : "adulto"
print("Etapa: \(etapa)")

print("Rango cerrado 1...5:  \(Array(1...5))")
print("Rango abierto 1..<5:  \(Array(1..<5))")

print("Precedencia 2 + 3 * 4 = \(2 + 3 * 4)")
print("Con parentesis (2 + 3) * 4 = \((2 + 3) * 4)")
