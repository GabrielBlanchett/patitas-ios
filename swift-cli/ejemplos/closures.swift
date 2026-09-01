let edades = [14, 1, 36, 8, 24]

let duplicarCompleto: (Int) -> Int = { (n: Int) -> Int in
    return n * 2
}
print("Completo:  \(duplicarCompleto(7))")

let duplicarCorto: (Int) -> Int = { $0 * 2 }
print("Corto:     \(duplicarCorto(7))")

print("map:       \(edades.map { $0 * 2 })")
print("filter:    \(edades.filter { $0 < 12 })")
print("reduce:    \(edades.reduce(0) { $0 + $1 })")
print("sorted:    \(edades.sorted())")
print("sorted >:  \(edades.sorted(by: >))")

struct Mascota {
    let nombre: String
    let edadEnMeses: Int
    let adoptada: Bool
}

let refugio = [
    Mascota(nombre: "Kira", edadEnMeses: 14, adoptada: false),
    Mascota(nombre: "Balto", edadEnMeses: 1, adoptada: false),
    Mascota(nombre: "Nube", edadEnMeses: 36, adoptada: true),
]

print("nombres:      \(refugio.map(\.nombre))")
print("disponibles:  \(refugio.filter { !$0.adoptada }.map(\.nombre))")
print("suma meses:   \(refugio.reduce(0) { $0 + $1.edadEnMeses })")
print("por edad:     \(refugio.sorted { $0.edadEnMeses < $1.edadEnMeses }.map(\.nombre))")

func hacerContador() -> () -> Int {
    var cuenta = 0
    return {
        cuenta += 1
        return cuenta
    }
}
let contar = hacerContador()
print("captura: \(contar()) \(contar()) \(contar())")
