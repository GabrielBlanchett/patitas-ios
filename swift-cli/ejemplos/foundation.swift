import Foundation

let ahora = Date()
let calendario = Calendar(identifier: .gregorian)
let nacimiento = calendario.date(from: DateComponents(year: 2025, month: 7, day: 15))!

let componentes = calendario.dateComponents([.year, .month, .day], from: nacimiento, to: ahora)
print("Edad: \(componentes.year ?? 0) anios, \(componentes.month ?? 0) meses, \(componentes.day ?? 0) dias")

let formato = Date.FormatStyle(date: .abbreviated, time: .omitted).locale(Locale(identifier: "es_MX"))
print("Nacimiento: \(nacimiento.formatted(formato))")
print("ISO 8601:   \(nacimiento.ISO8601Format())")

let mx = Locale(identifier: "es_MX")
print("\nMoneda MX:  \(1234.5.formatted(.currency(code: "MXN").locale(mx)))")
print("Numero MX:  \(1234567.89.formatted(.number.locale(mx)))")
print("Porcentaje: \(0.42.formatted(.percent.locale(mx)))")

// OJO: Measurement.formatted() solo existe en la Foundation de Apple.
// En Windows y Linux hay que componer el texto a mano.
let medida = Measurement(value: 8.4, unit: UnitMass.kilograms)
let enLibras = medida.converted(to: .pounds)
print("\nPeso: \(medida.value) \(medida.unit.symbol)")
print("En libras: \(String(format: "%.2f", enLibras.value)) \(enLibras.unit.symbol)")

let uuid = UUID()
print("\nUUID valido: \(uuid.uuidString.count == 36)")

let texto = "Contacto: ana@refugio.mx y luis@refugio.mx"
let regex = try Regex(#"[a-z]+@[a-z]+\.[a-z]+"#)
let correos = texto.matches(of: regex).map { String(texto[$0.range]) }
print("\nCorreos encontrados: \(correos)")

let desordenado = ["Nandu", "avestruz", "Zorro", "ardilla"]
print("\nOrden simple: \(desordenado.sorted())")
let ordenLocal = desordenado.sorted {
    $0.compare($1, options: [.caseInsensitive], range: nil, locale: mx) == .orderedAscending
}
print("Orden es_MX:  \(ordenLocal)")
