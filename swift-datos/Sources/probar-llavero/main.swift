// Comprueba si el llavero del sistema funciona en el entorno donde corre.
//
// No es una prueba: es una sonda. En un runner de CI el proceso no está
// firmado y el llavero puede negarse, así que este programa informa del
// código exacto que devuelve en vez de fallar el build. Su salida es la que
// el capítulo 47 del libro cita, y la que decide si el Keychain aparece como
// verificado o como no verificado en el anexo A5.

import Datos
import Foundation

let cuenta = "sonda-\(UUID().uuidString)"

print("=== Sonda del llavero ===")

do {
    try Llavero.guardar("token-secreto-123", cuenta: cuenta)
    print("guardar: OK")

    let leido = try Llavero.leer(cuenta: cuenta)
    print("leer:    OK -> \(leido)")

    try Llavero.borrar(cuenta: cuenta)
    print("borrar:  OK")

    print("RESULTADO: el llavero funciona en este entorno")
} catch let Llavero.ErrorLlavero.fallo(estado) {
    let mensaje = SecCopyErrorMessageString(estado, nil) as String? ?? "sin descripción"
    print("RESULTADO: el llavero NO funciona aqui")
    print("OSStatus: \(estado)")
    print("Mensaje:  \(mensaje)")
} catch {
    print("RESULTADO: fallo inesperado -> \(error)")
}
