let edades = [12, 24, 36, 48]
var suma = 0
for i in 0..<edades.count - 1 {
    suma += edades[i]
}
print("Promedio calculado: \(suma / edades.count)")
print("Promedio correcto:  \((12 + 24 + 36 + 48) / 4)")
