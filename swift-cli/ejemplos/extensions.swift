extension Int {
    var esPar: Bool { self % 2 == 0 }
    var enMeses: String { self == 1 ? "1 mes" : "\(self) meses" }
    func veces(_ accion: () -> Void) {
        for _ in 0..<self { accion() }
    }
}
print("14 es par: \(14.esPar)")
print("1 -> \(1.enMeses), 14 -> \(14.enMeses)")
3.veces { print("  repetido") }

extension String {
    var primeraMayuscula: String {
        guard let primera = first else { return self }
        return primera.uppercased() + dropFirst()
    }
    var sinEspacios: String {
        split(separator: " ").joined()
    }
}
print("\n'kira' -> '\("kira".primeraMayuscula)'")
print("'  a b c ' -> '\("  a b c ".sinEspacios)'")

extension Array where Element == Int {
    var promedio: Double {
        isEmpty ? 0 : Double(reduce(0, +)) / Double(count)
    }
}
print("\nPromedio [14,1,36]: \([14, 1, 36].promedio)")

struct Mascota { let nombre: String; let edadEnMeses: Int }
extension Mascota {
    init(nombre: String) { self.init(nombre: nombre, edadEnMeses: 0) }
}
let recienLlegada = Mascota(nombre: "Luna")
print("\nInit en extension: \(recienLlegada.nombre), \(recienLlegada.edadEnMeses) meses")

extension Mascota: CustomStringConvertible {
    var description: String { "\(nombre) (\(edadEnMeses)m)" }
}
print("Conformidad en extension: \(recienLlegada)")
