// Cap. 13: por que los String de Swift no se indexan con enteros.
// Un Character de Swift es un "grapheme cluster": lo que una persona
// llama "una letra", aunque por dentro sean varios valores Unicode.

let saludo = "Hola"
let conAcento = "Adopción"
let emoji = "Familia: 👨‍👩‍👧‍👦"
let bandera = "🇲🇽"

print("Lo que cuenta Swift frente a lo que cuentan otros:")
for texto in [saludo, conAcento, emoji, bandera] {
    print("   \(texto)")
    print("      characters (lo que ve una persona): \(texto.count)")
    print("      unicodeScalars                    : \(texto.unicodeScalars.count)")
    print("      utf8 (bytes en disco o en la red)  : \(texto.utf8.count)")
}

print("")
print("La misma palabra escrita de dos formas distintas:")
// e con acento como un solo escalar, y como e + acento combinante.
let precompuesta = "\u{00E9}"        // é
let compuesta = "\u{0065}\u{0301}"   // e + acento
print("   precompuesta: \(precompuesta)  escalares=\(precompuesta.unicodeScalars.count) count=\(precompuesta.count)")
print("   compuesta   : \(compuesta)  escalares=\(compuesta.unicodeScalars.count) count=\(compuesta.count)")
print("   son iguales? \(precompuesta == compuesta)   <- Swift las compara por significado")

print("")
print("Por eso no hay texto[0]. Se navega con indices:")
let nombre = "Kira"
print("   primera letra: \(nombre[nombre.startIndex])")
let segunda = nombre.index(after: nombre.startIndex)
print("   segunda letra: \(nombre[segunda])")
print("   ultima letra : \(nombre[nombre.index(before: nombre.endIndex)])")

print("")
print("Y por eso contar mal rompe una validacion:")
let nombreConEmoji = "Ana 👩‍⚕️"
print("   \"\(nombreConEmoji)\" tiene \(nombreConEmoji.count) caracteres")
print("   pero ocupa \(nombreConEmoji.utf8.count) bytes en la base de datos")
