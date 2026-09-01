let edadEnMeses = 14

let etapa = switch edadEnMeses {
case 0: "recien nacida"
case 1..<12: "cachorro"
case 12..<84: "adulto"
default: "senior"
}
print("Etapa: \(etapa)")

func mostrarFicha(nombre: String, edadEnMeses: Int) {
    guard edadEnMeses >= 0 else {
        print("Edad invalida")
        return
    }
    guard !nombre.isEmpty else {
        print("Falta el nombre")
        return
    }
    print("\(nombre), \(edadEnMeses) meses")
}

mostrarFicha(nombre: "Kira", edadEnMeses: 14)
mostrarFicha(nombre: "", edadEnMeses: 14)
mostrarFicha(nombre: "Balto", edadEnMeses: -1)
