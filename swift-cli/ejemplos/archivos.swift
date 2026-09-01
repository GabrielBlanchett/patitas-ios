import Foundation

struct Mascota: Codable { let nombre: String; let edadEnMeses: Int }

let fm = FileManager.default
let carpeta = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("patitas-demo")
try? fm.createDirectory(at: carpeta, withIntermediateDirectories: true)
print("Carpeta creada: \(fm.fileExists(atPath: carpeta.path))")

let archivoTexto = carpeta.appendingPathComponent("notas.txt")
try "Refugio Patitas Seguras\nMascotas: 3".write(to: archivoTexto, atomically: true, encoding: .utf8)
let leido = try String(contentsOf: archivoTexto, encoding: .utf8)
print("\nTexto leido:\n\(leido)")

let archivoJSON = carpeta.appendingPathComponent("mascotas.json")
let mascotas = [Mascota(nombre: "Kira", edadEnMeses: 14), Mascota(nombre: "Nube", edadEnMeses: 36)]
let datos = try JSONEncoder().encode(mascotas)
try datos.write(to: archivoJSON)
let recuperadas = try JSONDecoder().decode([Mascota].self, from: Data(contentsOf: archivoJSON))
print("\nJSON en disco -> \(recuperadas.map(\.nombre))")

let contenido = try fm.contentsOfDirectory(atPath: carpeta.path).sorted()
print("\nArchivos en la carpeta: \(contenido)")

let atributos = try fm.attributesOfItem(atPath: archivoJSON.path)
print("Tamano de mascotas.json: \(atributos[.size] ?? 0) bytes")

print("\nExtension: \(archivoJSON.pathExtension)")
print("Nombre:    \(archivoJSON.lastPathComponent)")
print("Sin ext:   \(archivoJSON.deletingPathExtension().lastPathComponent)")

do {
    _ = try String(contentsOf: carpeta.appendingPathComponent("no-existe.txt"), encoding: .utf8)
} catch {
    print("\nArchivo inexistente -> error capturado")
}

try fm.removeItem(at: carpeta)
print("Carpeta borrada: \(!fm.fileExists(atPath: carpeta.path))")
