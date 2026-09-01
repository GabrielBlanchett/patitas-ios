func saludar(a nombre: String) {
    print("Hola, \(nombre)")
}
saludar(a: "Kira")

func edadEnPalabras(meses: Int) -> String {
    let anios = meses / 12
    let resto = meses % 12
    if anios == 0 { return "\(resto) meses" }
    if resto == 0 { return "\(anios) anios" }
    return "\(anios) anios y \(resto) meses"
}
print(edadEnPalabras(meses: 14))

func registrar(_ nombre: String, edadEnMeses: Int = 0, adoptada: Bool = false) {
    print("\(nombre) | \(edadEnMeses) meses | adoptada: \(adoptada)")
}
registrar("Kira")
registrar("Nube", edadEnMeses: 36, adoptada: true)

func aplicarVacuna(a contador: inout Int) {
    contador += 1
}
var vacunas = 2
aplicarVacuna(a: &vacunas)
print("Vacunas: \(vacunas)")

func describir(_ valor: Int) -> String { "entero \(valor)" }
func describir(_ valor: String) -> String { "texto \(valor)" }
print(describir(7))
print(describir("Kira"))

func estadisticas(de edades: [Int]) -> (minimo: Int, maximo: Int) {
    var minimo = edades[0], maximo = edades[0]
    for e in edades {
        if e < minimo { minimo = e }
        if e > maximo { maximo = e }
    }
    return (minimo, maximo)
}
let r = estadisticas(de: [14, 1, 36])
print("min \(r.minimo), max \(r.maximo)")
