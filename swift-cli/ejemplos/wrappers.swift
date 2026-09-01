import Foundation

@propertyWrapper
struct Recortado {
    private var valor = ""
    var wrappedValue: String {
        get { valor }
        set { valor = newValue.trimmingCharacters(in: .whitespaces) }
    }
    init(wrappedValue: String) { self.wrappedValue = wrappedValue }
}

@propertyWrapper
struct EnRango {
    private var valor: Int
    private let rango: ClosedRange<Int>
    var wrappedValue: Int {
        get { valor }
        set { valor = min(max(newValue, rango.lowerBound), rango.upperBound) }
    }
    init(wrappedValue: Int, _ rango: ClosedRange<Int>) {
        self.rango = rango
        self.valor = min(max(wrappedValue, rango.lowerBound), rango.upperBound)
    }
}

struct Ficha {
    @Recortado var nombre: String
    @EnRango(0...300) var edadEnMeses: Int = 0
}

var f = Ficha(nombre: "   Kira   ", edadEnMeses: 14)
print("Nombre recortado: '\(f.nombre)'")
f.edadEnMeses = 5000
print("Edad limitada:    \(f.edadEnMeses)")
f.edadEnMeses = -10
print("Edad limitada:    \(f.edadEnMeses)")

@resultBuilder
struct ListaBuilder {
    static func buildBlock(_ partes: String...) -> String {
        partes.joined(separator: "\n")
    }
}

func informe(@ListaBuilder _ contenido: () -> String) -> String { contenido() }

let texto = informe {
    "Refugio Patitas Seguras"
    "Mascotas: 3"
    "Disponibles: 2"
}
print("\nresultBuilder:\n\(texto)")
