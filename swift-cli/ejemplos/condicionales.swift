let edadEnMeses = 14
let adoptada = false

if edadEnMeses < 12 {
    print("Cachorro")
} else if edadEnMeses < 84 {
    print("Adulto")
} else {
    print("Senior")
}

let etapa: String
switch edadEnMeses {
case 0:
    etapa = "recien nacida"
case 1..<12:
    etapa = "cachorro"
case 12..<84:
    etapa = "adulto"
default:
    etapa = "senior"
}
print("Etapa: \(etapa)")

switch (edadEnMeses, adoptada) {
case (_, true):
    print("Ya tiene familia")
case let (m, false) where m < 12:
    print("Cachorro disponible: prioridad alta")
case (_, false):
    print("Disponible")
}

let nombre = "Kira"
switch nombre {
case "Kira", "Balto":
    print("\(nombre) esta en el refugio norte")
default:
    print("\(nombre) esta en el refugio sur")
}
