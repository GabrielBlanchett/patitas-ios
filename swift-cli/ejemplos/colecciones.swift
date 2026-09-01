var refugio = ["Kira", "Balto", "Nube"]
print("Lista:      \(refugio)")
print("Cantidad:   \(refugio.count)")
print("Vacia:      \(refugio.isEmpty)")
print("Primera:    \(refugio[0])")

refugio.append("Luna")
refugio.insert("Rocky", at: 0)
print("Tras anadir: \(refugio)")
refugio.remove(at: 1)
print("Tras quitar: \(refugio)")
print("Contiene Nube: \(refugio.contains("Nube"))")

var edades: [String: Int] = ["Kira": 14, "Balto": 1, "Nube": 36]
print("\nDiccionario: \(edades.count) entradas")
edades["Luna"] = 5
print("Edad de Kira: \(edades["Kira"] ?? -1)")
print("Edad de Rex:  \(edades["Rex"] ?? -1)")
for (nombre, edad) in edades.sorted(by: { $0.key < $1.key }) {
    print("  \(nombre): \(edad)")
}

var refugios: Set<String> = ["norte", "sur", "norte", "centro"]
print("\nSet: \(refugios.count) elementos unicos")
print("Ordenado: \(refugios.sorted())")
refugios.insert("norte")
print("Tras insertar repetido: \(refugios.count)")

let conVacunas: Set = ["Kira", "Nube"]
let disponibles: Set = ["Kira", "Balto"]
print("Interseccion: \(conVacunas.intersection(disponibles).sorted())")
print("Union:        \(conVacunas.union(disponibles).sorted())")
print("Diferencia:   \(conVacunas.subtracting(disponibles).sorted())")
