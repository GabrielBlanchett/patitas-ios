import Foundation

/// Una mascota del refugio.
///
/// Nota deliberada: este tipo está duplicado respecto a `swift-cli/Sources/Refugio`.
/// No es un descuido. La guía llega a esta duplicación a propósito para que el
/// capítulo de modularización con Swift Package Manager la resuelva extrayendo un
/// módulo compartido, con el problema ya sentido en vez de explicado en abstracto.
struct Mascota: Identifiable, Hashable, Sendable {
    let id: UUID
    let nombre: String
    let edadEnMeses: Int
    var adoptada: Bool

    init(id: UUID = UUID(), nombre: String, edadEnMeses: Int, adoptada: Bool = false) {
        self.id = id
        self.nombre = nombre
        self.edadEnMeses = edadEnMeses
        self.adoptada = adoptada
    }

    var estaDisponible: Bool { !adoptada }

    var descripcionCorta: String {
        "\(nombre), \(Self.edadEnPalabras(meses: edadEnMeses))"
    }

    static func edadEnPalabras(meses: Int) -> String {
        let años = meses / 12
        let resto = meses % 12

        let parteAños = switch años {
        case 0: ""
        case 1: "1 año"
        default: "\(años) años"
        }

        let parteMeses = switch resto {
        case 0: ""
        case 1: "1 mes"
        default: "\(resto) meses"
        }

        return switch (parteAños.isEmpty, parteMeses.isEmpty) {
        case (false, false): "\(parteAños) y \(parteMeses)"
        case (false, true): parteAños
        case (true, false): parteMeses
        case (true, true): "recién nacida"
        }
    }
}

extension Mascota {
    static let refugioDeEjemplo: [Mascota] = [
        Mascota(nombre: "Kira", edadEnMeses: 14),
        Mascota(nombre: "Balto", edadEnMeses: 1),
        Mascota(nombre: "Nube", edadEnMeses: 36, adoptada: true),
    ]
}
