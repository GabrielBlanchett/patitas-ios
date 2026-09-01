import Foundation

/// Una mascota del refugio.
///
/// Es el tipo que recorre todo el libro: aparece aquí, en la app de iOS y en la
/// API. Se define como `struct` a propósito —semántica de valor— y el capítulo
/// sobre `struct` frente a `class` explica por qué.
public struct Mascota: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let nombre: String
    public let edadEnMeses: Int
    public var adoptada: Bool

    public init(id: UUID = UUID(), nombre: String, edadEnMeses: Int, adoptada: Bool = false) {
        self.id = id
        self.nombre = nombre
        self.edadEnMeses = edadEnMeses
        self.adoptada = adoptada
    }

    /// Una mascota está disponible mientras nadie la haya adoptado.
    public var estaDisponible: Bool { !adoptada }

    /// Nombre y edad en lenguaje natural: «Kira, 1 año y 2 meses».
    public var descripcionCorta: String {
        "\(nombre), \(Self.edadEnPalabras(meses: edadEnMeses))"
    }

    /// Convierte meses en una frase con el singular y el plural correctos.
    ///
    /// Es más código del que parece necesario, y ése es justo el punto: el
    /// singular de «1 mes» y «1 año» es el tipo de detalle que separa una app
    /// que se siente bien hecha de una que no.
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
    /// El refugio que usan los ejemplos del libro, aquí y en la app de iOS.
    public static let refugioDeEjemplo: [Mascota] = [
        Mascota(nombre: "Kira", edadEnMeses: 14),
        Mascota(nombre: "Balto", edadEnMeses: 1),
        Mascota(nombre: "Nube", edadEnMeses: 36, adoptada: true),
    ]
}
