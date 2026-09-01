func promedioEdad(_ edades: [Int]) -> Int {
    assert(!edades.isEmpty, "La lista de edades no puede estar vacia")
    var suma = 0
    for edad in edades { suma += edad }
    return suma / edades.count
}

print("Promedio: \(promedioEdad([12, 24, 36]))")
print("Ahora con lista vacia:")
print(promedioEdad([]))
