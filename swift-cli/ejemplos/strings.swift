import Foundation

let nombre = "Kira"
print("Longitud:    \(nombre.count)")
print("Mayusculas:  \(nombre.uppercased())")
print("Minusculas:  \(nombre.lowercased())")
print("Empieza:     \(nombre.hasPrefix("Ki"))")
print("Termina:     \(nombre.hasSuffix("ra"))")
print("Contiene:    \(nombre.contains("ir"))")
print("Vacio:       \(nombre.isEmpty)")

let frase = "Kira, Balto, Nube"
let partes = frase.split(separator: ", ")
print("Partes: \(partes)")
print("Unidas: \(partes.joined(separator: " | "))")

let conEspacios = "   Kira   "
print("Recortado: '\(conEspacios.trimmingCharacters(in: .whitespaces))'")

let emoji = "Perro 🐕"
print("Emoji count: \(emoji.count)")
print("UTF-8 count: \(emoji.utf8.count)")

for caracter in "Kira" {
    print("caracter: \(caracter)")
}

let primera = nombre.first
let ultima = nombre.last
print("Primera: \(primera ?? "?"), ultima: \(ultima ?? "?")")

let multilinea = """
Refugio Patitas Seguras
Mascotas: 3
Disponibles: 2
"""
print(multilinea)
