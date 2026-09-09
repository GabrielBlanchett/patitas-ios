// Verificaciones de la entrega 4 que SI se pueden ejecutar sin Xcode.
// Cap. 115 (memoria de imagenes), 124 (estructura de un JWT), 128 (swift-algorithms).
import Algorithms
import Foundation

func titulo(_ s: String) { print(""); print("== " + s + " ==") }

// ---------------------------------------------------------------
titulo("Cap. 115. Lo que ocupa una foto en memoria")
// La regla es ancho x alto x 4 bytes. El archivo comprimido no dice nada
// de esto, y es la causa numero uno de que una app se cierre en un movil viejo.

struct Foto {
    let nombre: String
    let ancho: Int
    let alto: Int
    let archivoMB: Double

    var pixeles: Int { ancho * alto }
    var memoriaMB: Double { Double(pixeles * 4) / 1_048_576 }
    var factor: Double { memoriaMB / archivoMB }
}

let fotos = [
    Foto(nombre: "iPhone 12 Mpx", ancho: 4032, alto: 3024, archivoMB: 2.1),
    Foto(nombre: "iPhone 48 Mpx", ancho: 8064, alto: 6048, archivoMB: 25.0),
    Foto(nombre: "Subida (1200 px)", ancho: 1200, alto: 900, archivoMB: 0.187),
    Foto(nombre: "Miniatura 300 px", ancho: 300, alto: 300, archivoMB: 0.03),
]

print("  nombre               pixeles      archivo     en memoria   factor")
for f in fotos {
    let n = f.nombre.padding(toLength: 20, withPad: " ", startingAt: 0)
    print(n + String(format: " %10d  %8.2f MB  %9.2f MB    %5.0fx",
                     f.pixeles, f.archivoMB, f.memoriaMB, f.factor))
}

let lista = Array(repeating: fotos[0], count: 20).reduce(0.0) { $0 + $1.memoriaMB }
print(String(format: "  -> una lista con 20 fotos a tamano completo: %.0f MB de memoria", lista))
let listaMini = Array(repeating: fotos[3], count: 20).reduce(0.0) { $0 + $1.memoriaMB }
print(String(format: "  -> las mismas 20 como miniatura de 300 px:   %.1f MB", listaMini))
print(String(format: "  -> la miniatura usa %.0f veces menos memoria", lista / listaMini))

// ---------------------------------------------------------------
titulo("Cap. 124. Que hay dentro del identityToken de Sign in with Apple")
// Un JWT son tres partes separadas por puntos, en base64url. Las dos primeras
// son JSON legible: cualquiera puede leerlas. La tercera es la FIRMA, y es lo
// unico que impide falsificarlo. Por eso la verifica el servidor, no la app.

func base64url(_ s: String) -> Data? {
    var t = s.replacingOccurrences(of: "-", with: "+")
             .replacingOccurrences(of: "_", with: "/")
    while t.count % 4 != 0 { t += "=" }
    return Data(base64Encoded: t)
}

// Un token de ejemplo con la MISMA forma que uno real de Apple. La firma es
// falsa a proposito: sirve para ver la estructura, no para autenticar nada.
let cabeceraJSON = #"{"kid":"W6RH/BY44UA=","alg":"RS256"}"#
let cuerpoJSON = """
{"iss":"https://appleid.apple.com","aud":"mx.gabrielblanchet.adopcion",\
"exp":1789000000,"iat":1788996400,"sub":"001234.abcd5678efgh.1234",\
"email":"k7x9q2@privaterelay.appleid.com","email_verified":"true",\
"is_private_email":"true","auth_time":1788996400}
"""

func aBase64url(_ s: String) -> String {
    Data(s.utf8).base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
}

let jwt = aBase64url(cabeceraJSON) + "." + aBase64url(cuerpoJSON) + ".FIRMA_FALSA"
let partes = jwt.split(separator: ".")
print("  el token tiene \(partes.count) partes separadas por puntos")
print("  longitudes: " + partes.map { String($0.count) }.joined(separator: ", "))

for (i, etiqueta) in ["cabecera", "cuerpo"].enumerated() {
    guard let d = base64url(String(partes[i])),
          let texto = String(data: d, encoding: .utf8) else { continue }
    print("  [\(etiqueta)] " + texto)
}
print("  [firma]   no es texto: son bytes. Es lo unico que hay que verificar.")
print("  -> el correo del ejemplo termina en @privaterelay.appleid.com:")
print("     es la direccion de reenvio de 'Ocultar mi correo'. No es su correo real.")
print("  -> el identificador estable es 'sub', no el correo.")

// ---------------------------------------------------------------
titulo("Cap. 128. swift-algorithms: lo que le falta a la biblioteca estandar")

let solicitudes = ["ana", "luis", "ana", "sofia", "luis", "ana", "beto"]

print("  uniqued()  -> " + Array(solicitudes.uniqued()).joined(separator: ", "))
print("     (conserva el orden de aparicion, a diferencia de Set)")

let paginas = solicitudes.chunks(ofCount: 3).map { Array($0) }
print("  chunks(ofCount: 3) -> \(paginas.count) paginas")
for (i, p) in paginas.enumerated() {
    print("     pagina \(i + 1): " + p.joined(separator: ", "))
}

let temperaturas = [21, 23, 28, 31, 30, 26, 22]
let medias3 = temperaturas.windows(ofCount: 3).map { v in
    Double(v.reduce(0, +)) / 3.0
}
print("  windows(ofCount: 3) -> media movil de 3 dias:")
print("     " + medias3.map { String(format: "%.1f", $0) }.joined(separator: ", "))

let porEspecie = ["perro", "gato", "perro", "perro", "gato"]
let conteo = porEspecie.reduce(into: [:]) { $0[$1, default: 0] += 1 }
print("  agrupado a mano con reduce(into:) -> \(conteo.sorted { $0.key < $1.key })")

let dosMayores = temperaturas.max(count: 2)
print("  max(count: 2) -> \(dosMayores)  (sin ordenar el arreglo entero)")

print("")
print("Todas las cifras de arriba salieron de ejecutar este archivo.")
