// El gemelo en Swift de comparacion.dart. Mismo orden, mismas cuatro cosas.
// Lo que interesa es comparar las dos salidas lado a lado.
//
// Se ejecuta con `swiftc -O Comparacion.swift -o comparacion && ./comparacion`.

import Foundation

// ---------------------------------------------------------------- 1. Copias

struct PuntoSwift: CustomStringConvertible {
    var x: Double
    var y: Double
    var description: String { "(\(x), \(y))" }
}

func copias() {
    print("--- 1. Que pasa al copiar ---")
    let a = PuntoSwift(x: 1, y: 2)
    var b = a          // SI es una copia: dos valores independientes.
    b.x = 99
    print("a = \(a)")
    print("b = \(b)")
    print("son el mismo objeto = false (los structs no tienen identidad)")
}

// ------------------------------------------------------------- 2. Enums

enum EstadoSwift: String {
    case cargando, listo, fallo
    var descripcion: String { rawValue }
}

// Un solo enum. Cada caso lleva los datos que necesita, y ninguno mas.
enum ResultadoSwift {
    case exito([String])
    case error(codigo: Int, mensaje: String)
    case vacio
}

func describir(_ r: ResultadoSwift) -> String {
    switch r {
    case .exito(let mascotas):
        "exito con \(mascotas.count) mascotas"
    case .error(let codigo, let mensaje):
        "error \(codigo): \(mensaje)"
    case .vacio:
        "sin resultados"
    }
}

func enums() {
    print("")
    print("--- 2. Enums y datos por caso ---")
    print("enum simple: \(EstadoSwift.listo.descripcion)")
    print(describir(.exito(["Kira", "Firulais"])))
    print(describir(.error(codigo: 404, mensaje: "no encontrado")))
    print(describir(.vacio))
    print("cuantos tipos hizo falta declarar: 1")
}

// ------------------------------------------------------------ 3. Nulos

func nulos() {
    print("")
    print("--- 3. Nulos ---")
    var nombre: String?
    print("sin valor: \(nombre ?? "(sin nombre)")")
    nombre = "Kira"
    print("largo con ?. = \(String(describing: nombre?.count))")

    // Swift no tiene `late`. Lo mas parecido es un Optional implicito,
    // y el compilador te empuja a no usarlo.
    print("Swift no tiene late: o hay valor, o el tipo es Optional")
}

// ------------------------------------------------- 4. Cascada y constantes

struct Refugio: CustomStringConvertible {
    var nombre = ""
    var ciudad = ""
    var cupo = 0
    var description: String { "\(nombre) (\(ciudad)), cupo \(cupo)" }
}

func cascadaYConstantes() {
    print("")
    print("--- 4. Cascada y constantes ---")
    // Swift no tiene operador de cascada. El inicializador por miembros
    // hace el mismo trabajo y ademas obliga a nombrar cada cosa.
    let r = Refugio(nombre: "Patitas", ciudad: "Guadalajara", cupo: 40)
    print("sin cascada, con inicializador: \(r)")

    let enCompilacion = 3 * 14
    let enEjecucion = Calendar.current.component(.year, from: Date())
    print("let = \(enCompilacion), let = \(enEjecucion)")
    print("Swift no distingue const de final: un let es un let")

    let lista = [1, 2, 3]
    print("una lista let no tiene append: es un error de COMPILACION")
    print("elementos: \(lista.count)")
}

print("=== SWIFT \(swiftVersion()) ===")
copias()
enums()
nulos()
cascadaYConstantes()

func swiftVersion() -> String {
    #if swift(>=6.0)
    return "6.x"
    #else
    return "5.x"
    #endif
}
