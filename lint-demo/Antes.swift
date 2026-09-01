// Archivo de demostracion del capitulo 36.
// Esta escrito MAL a proposito: cada linea rompe al menos una regla.
// SwiftLint lo revisa en el CI y su salida va al libro tal cual.

import Foundation

struct mascota {
    var nombre :String
    var meses: Int
    var duenio: String? = nil
}

func Calcular(_ a: Int, _ b: Int) -> Int
{
    var t = 0
    t = t + a
    t = t + b
    return t
}

func revisar(_ lista: [mascota]) -> [String] {
    var r: [String] = []
    for m in lista {
        if m.meses > 12 {
            r.append(m.nombre)
        }
    }
    if (r.count == 0) {
        return ["ninguna"]
    }
    else {
        return r
    }
}

func primerAdulto(_ lista: [mascota]) -> mascota? {
    return lista.filter { $0.meses > 12 }.first
}

func cargar(_ texto: String) -> [String: Any] {
    let datos = texto.data(using: .utf8)!
    let objeto = try! JSONSerialization.jsonObject(with: datos)
    return objeto as! [String: Any]
}

let PetName = "Kira"   
let x2 = mascota(nombre: PetName, meses: 14, duenio: nil)



let resultado = revisar([x2 , mascota(nombre: "Balto", meses: 1, duenio: nil)])
print("Este comentario y esta linea juntos pasan de los ciento veinte caracteres que pusimos como limite en el archivo de configuracion", resultado)
