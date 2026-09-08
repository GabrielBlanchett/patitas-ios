// Cap. 5 y 6: por que 0.1 + 0.2 no da 0.3, y que hacer con el dinero.
// No es un fallo de Swift: es como funciona el formato binario IEEE 754.

import Foundation

print("Lo que todo el mundo espera:")
print("   0.1 + 0.2 == 0.3  ->  \(0.1 + 0.2 == 0.3)")
print("   0.1 + 0.2         =  \(0.1 + 0.2)")

print("")
print("Por que: 0.1 no existe en binario, se guarda el mas cercano")
print("   0.1 con 20 decimales = \(String(format: "%.20f", 0.1))")
print("   0.2 con 20 decimales = \(String(format: "%.20f", 0.2))")
print("   0.5 con 20 decimales = \(String(format: "%.20f", 0.5))   <- esta si es exacta")

print("")
print("El error se acumula. Sumar 0.1 diez veces:")
var suma = 0.0
for _ in 1...10 { suma += 0.1 }
print("   resultado = \(suma)")
print("   == 1.0    ? \(suma == 1.0)")

print("")
print("Con dinero eso son centavos que aparecen o desaparecen:")
let precio = 19.99
let total = precio * 3
print("   19.99 * 3 = \(total)")
print("   redondeado a dos decimales = \(String(format: "%.2f", total))")

print("")
print("La solucion: contar en la unidad minima, con enteros")
let precioEnCentavos = 1999
let totalEnCentavos = precioEnCentavos * 3
print("   1999 centavos * 3 = \(totalEnCentavos) centavos")
print("   que son \(totalEnCentavos / 100).\(totalEnCentavos % 100) pesos, exacto")

print("")
print("Comparar flotantes: nunca con ==, siempre con una tolerancia")
let tolerancia = 0.000001
print("   abs((0.1+0.2) - 0.3) < tolerancia  ->  \(abs((0.1 + 0.2) - 0.3) < tolerancia)")
