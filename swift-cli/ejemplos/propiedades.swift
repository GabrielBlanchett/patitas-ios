struct Mascota {
    let nombre: String
    var edadEnMeses: Int {
        didSet { print("  didSet: cambio de \(oldValue) a \(edadEnMeses)") }
        willSet { print("  willSet: va a cambiar a \(newValue)") }
    }
    var edadEnAnios: Double { Double(edadEnMeses) / 12.0 }
    var etiqueta: String {
        get { "\(nombre) (\(edadEnMeses)m)" }
    }
    lazy var expediente: String = {
        print("  calculando expediente (solo una vez)")
        return "EXP-\(nombre.uppercased())"
    }()

    static let especie = "Canis familiaris"
    static var registradas = 0
}

var kira = Mascota(nombre: "Kira", edadEnMeses: 14)
print("Calculada: \(kira.edadEnAnios)")
print("Get:       \(kira.etiqueta)")
print("Cambiando edad:")
kira.edadEnMeses = 15
print("Lazy, primera vez: \(kira.expediente)")
print("Lazy, segunda vez: \(kira.expediente)")
Mascota.registradas += 1
print("Estatica: \(Mascota.especie), registradas: \(Mascota.registradas)")
