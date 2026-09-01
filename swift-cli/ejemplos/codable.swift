import Foundation

struct Mascota: Codable {
    let id: Int
    let nombre: String
    let edadEnMeses: Int
    let adoptada: Bool
}

let kira = Mascota(id: 1, nombre: "Kira", edadEnMeses: 14, adoptada: false)

let codificador = JSONEncoder()
codificador.outputFormatting = [.prettyPrinted, .sortedKeys]
let datos = try codificador.encode(kira)
print("Codificado:")
print(String(data: datos, encoding: .utf8)!)

let json = """
{"id": 2, "nombre": "Nube", "edadEnMeses": 36, "adoptada": true}
"""
let decodificada = try JSONDecoder().decode(Mascota.self, from: Data(json.utf8))
print("\nDecodificado: \(decodificada.nombre), \(decodificada.edadEnMeses) meses")

struct MascotaAPI: Codable {
    let id: Int
    let nombre: String
    let edadEnMeses: Int

    enum CodingKeys: String, CodingKey {
        case id
        case nombre = "pet_name"
        case edadEnMeses = "age_in_months"
    }
}
let jsonAPI = """
{"id": 3, "pet_name": "Balto", "age_in_months": 1}
"""
let api = try JSONDecoder().decode(MascotaAPI.self, from: Data(jsonAPI.utf8))
print("Con CodingKeys: \(api.nombre), \(api.edadEnMeses) meses")

let lista = """
[{"id":1,"nombre":"Kira","edadEnMeses":14,"adoptada":false},
 {"id":2,"nombre":"Nube","edadEnMeses":36,"adoptada":true}]
"""
let mascotas = try JSONDecoder().decode([Mascota].self, from: Data(lista.utf8))
print("\nLista decodificada: \(mascotas.map(\.nombre))")

let jsonMalo = """
{"id": "cuatro", "nombre": "Luna", "edadEnMeses": 5, "adoptada": false}
"""
do {
    _ = try JSONDecoder().decode(Mascota.self, from: Data(jsonMalo.utf8))
} catch let DecodingError.typeMismatch(tipo, contexto) {
    print("\nError de tipo: esperaba \(tipo) en '\(contexto.codingPath.map(\.stringValue).joined(separator: "."))'")
} catch {
    print("\nOtro error: \(error)")
}

let jsonFalta = """
{"id": 5, "nombre": "Rex"}
"""
do {
    _ = try JSONDecoder().decode(Mascota.self, from: Data(jsonFalta.utf8))
} catch let DecodingError.keyNotFound(clave, _) {
    print("Falta la clave: \(clave.stringValue)")
} catch {
    print("Otro error: \(error)")
}
