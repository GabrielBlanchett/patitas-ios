// Capitulo 32 - El programador pragmatico
//
// Tres principios, cada uno con su version rota y su version sana:
//   A. DRY          - una regla de negocio en dos sitios, que se separan
//   B. Ortogonalidad - un tipo que hace dos trabajos y por eso rompe dos veces
//   C. Ley de Demeter - hablar con el vecino, no con el vecino del vecino

// ============================================================ A. DRY

// --- Roto: el 16 % de IVA vive en dos archivos distintos.
enum PantallaResumen {
    static func total(base: Double) -> Double { base * 1.16 }
}
enum GeneradorDeRecibo {
    // Alguien subio el IVA en la pantalla y aqui no. Nadie lo noto.
    static func total(base: Double) -> Double { base * 1.15 }
}

// --- Sano: una sola definicion, un solo sitio que cambiar.
enum Cuotas {
    static let iva = 0.16
    static func total(base: Double) -> Double { base * (1 + iva) }
}

// =================================================== B. Ortogonalidad

// --- Roto: formatea Y guarda. Cambiar el formato del texto obliga a tocar
//     el codigo que escribe en disco, y al reves.
struct AdopcionAcoplada {
    let mascota: String
    let adoptante: String

    func guardarYFormatear() -> String {
        let linea = "\(mascota) -> \(adoptante)"
        // Aqui iria la escritura en disco, mezclada con el formato.
        return "[GUARDADO] " + linea
    }
}

// --- Sano: dos piezas que no se conocen.
struct Adopcion {
    let mascota: String
    let adoptante: String
}
enum FormatoTexto {
    static func linea(_ a: Adopcion) -> String { "\(a.mascota) -> \(a.adoptante)" }
}
enum FormatoCSV {
    static func linea(_ a: Adopcion) -> String { "\(a.mascota),\(a.adoptante)" }
}

// ================================================= C. Ley de Demeter

struct Ciudad { let nombre: String }
struct Direccion { let ciudad: Ciudad }
struct Refugio {
    let nombre: String
    let direccion: Direccion
    // El refugio contesta por si mismo en vez de dejar que le abran las tripas.
    var ciudad: String { direccion.ciudad.nombre }
}

// ============================================================== SALIDA

print("=== A. DRY ===")
let base = 500.0
print("Pantalla:  \(PantallaResumen.total(base: base))")
print("Recibo:    \(GeneradorDeRecibo.total(base: base))")
print("Diferencia: \(PantallaResumen.total(base: base) - GeneradorDeRecibo.total(base: base))")
print("Una sola fuente: \(Cuotas.total(base: base))")

print("=== B. Ortogonalidad ===")
let adopcion = Adopcion(mascota: "Kira", adoptante: "Ana")
print("Acoplado: \(AdopcionAcoplada(mascota: "Kira", adoptante: "Ana").guardarYFormatear())")
print("Texto:    \(FormatoTexto.linea(adopcion))")
print("CSV:      \(FormatoCSV.linea(adopcion))")

print("=== C. Ley de Demeter ===")
let refugio = Refugio(nombre: "Patitas Norte", direccion: Direccion(ciudad: Ciudad(nombre: "Monterrey")))
print("Encadenado: \(refugio.direccion.ciudad.nombre)")
print("Preguntando: \(refugio.ciudad)")
