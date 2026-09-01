// Capitulo 31 - Codigo limpio
//
// La misma funcionalidad escrita tres veces:
//   1. ANTES     - como sale cuando se escribe con prisa
//   2. DESPUES   - refactorizada, con EXACTAMENTE el mismo comportamiento
//   3. ARREGLADA - ya con el bug de los plurales corregido, en un paso aparte
//
// La leccion esta en el paso 2: refactorizar NO cambia el comportamiento,
// ni siquiera el que esta mal. Arreglar es otro cambio, y va aparte.

import Foundation

// Los datos crudos, tal y como llegarian de un JSON sin tipar.
let crudo: [[String: Any]] = [
    ["nombre": "Kira",  "meses": 14, "estado": 1],
    ["nombre": "Balto", "meses": 1,  "estado": 1],
    ["nombre": "Nube",  "meses": 36, "estado": 2],
    ["nombre": "Luna",  "meses": 24, "estado": 1],
]

// ---------------------------------------------------------------- 1. ANTES

func proc(_ a: [[String: Any]], _ f: Int) -> String {
    var r = ""
    var c = 0
    for x in a {
        if let e = x["estado"] as? Int {
            if e == f {
                if let n = x["nombre"] as? String {
                    if let m = x["meses"] as? Int {
                        if m > 12 {
                            r += "- " + n + " (" + String(m / 12) + " años)\n"
                        } else {
                            r += "- " + n + " (" + String(m) + " meses)\n"
                        }
                        c += 1
                    }
                }
            }
        }
    }
    return "Disponibles: " + String(c) + "\n" + r
}

// ------------------------------------------------------------- 2. DESPUES

enum EstadoAdopcion: Int {
    case disponible = 1
    case adoptada = 2
}

struct Mascota {
    let nombre: String
    let edadEnMeses: Int
    let estado: EstadoAdopcion

    /// La edad como la diria una persona. Conserva el bug de los plurales
    /// a proposito: este paso solo mueve codigo, no lo arregla.
    var edadLegible: String {
        edadEnMeses > 12 ? "\(edadEnMeses / 12) años" : "\(edadEnMeses) meses"
    }
}

func mascota(desde diccionario: [String: Any]) -> Mascota? {
    guard let nombre = diccionario["nombre"] as? String,
          let meses = diccionario["meses"] as? Int,
          let codigo = diccionario["estado"] as? Int,
          let estado = EstadoAdopcion(rawValue: codigo) else { return nil }
    return Mascota(nombre: nombre, edadEnMeses: meses, estado: estado)
}

func reporte(de mascotas: [Mascota], con estado: EstadoAdopcion) -> String {
    let filtradas = mascotas.filter { $0.estado == estado }
    let lineas = filtradas.map { "- \($0.nombre) (\($0.edadLegible))" }
    return (["Disponibles: \(filtradas.count)"] + lineas).joined(separator: "\n") + "\n"
}

// ------------------------------------------------------------ 3. ARREGLADA

func edadLegibleCorrecta(_ meses: Int) -> String {
    if meses > 12 {
        let años = meses / 12
        return años == 1 ? "1 año" : "\(años) años"
    }
    return meses == 1 ? "1 mes" : "\(meses) meses"
}

// ------------------------------------------------------------------ SALIDA

let mascotas = crudo.compactMap(mascota(desde:))

print("=== 1. ANTES ===")
print(proc(crudo, 1), terminator: "")

print("=== 2. DESPUES (mismo comportamiento) ===")
print(reporte(de: mascotas, con: .disponible), terminator: "")

print("=== ¿Son identicas? ===")
print(proc(crudo, 1) == reporte(de: mascotas, con: .disponible))

print("=== 3. ARREGLADA (cambio deliberado) ===")
for m in mascotas where m.estado == .disponible {
    print("- \(m.nombre) (\(edadLegibleCorrecta(m.edadEnMeses)))")
}
