// Capitulo 32 - Programar por contrato
//
// assert       -> solo vive en compilacion de depuracion. En release DESAPARECE.
// precondition -> vive tambien en release. Es una condicion que no se negocia.
//
// Uso: contratos.exe [ok | assert | precondition]

func edadEnAños(meses: Int) -> Int {
    assert(meses >= 0, "assert: los meses no pueden ser negativos")
    return meses / 12
}

func aplicarDescuento(precio: Double, porcentaje: Double) -> Double {
    precondition(porcentaje >= 0 && porcentaje <= 1,
                 "precondition: el porcentaje debe ir de 0 a 1")
    return precio * (1 - porcentaje)
}

let caso = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "ok"

switch caso {
case "assert":
    print("edadEnAños(meses: -12) = \(edadEnAños(meses: -12))")
case "precondition":
    print("aplicarDescuento(100, 1.5) = \(aplicarDescuento(precio: 100, porcentaje: 1.5))")
default:
    print("edadEnAños(meses: 30)  = \(edadEnAños(meses: 30))")
    print("aplicarDescuento(100, 0.25) = \(aplicarDescuento(precio: 100, porcentaje: 0.25))")
}
