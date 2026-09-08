// Cap. 19 y 22: despacho estatico y dinamico. La trampa clasica de las
// extensiones de protocolo, y la pregunta senior de Swift por excelencia.

protocol Alimentable {
    func racion() -> String        // SI esta en el protocolo -> despacho dinamico
}

extension Alimentable {
    func racion() -> String { "racion estandar" }
    func horario() -> String { "horario estandar" }   // NO esta en el protocolo
}

struct Cachorro: Alimentable {
    func racion() -> String { "racion de cachorro" }
    func horario() -> String { "cuatro veces al dia" }
}

let cachorro = Cachorro()
let comoProtocolo: Alimentable = cachorro

print("Llamando al tipo concreto (Cachorro):")
print("   racion()  -> \(cachorro.racion())")
print("   horario() -> \(cachorro.horario())")

print("")
print("El MISMO objeto, visto como Alimentable:")
print("   racion()  -> \(comoProtocolo.racion())")
print("   horario() -> \(comoProtocolo.horario())   <- ¡cambio!")

print("")
print("racion() esta declarada en el protocolo: se busca en tiempo de")
print("ejecucion en la witness table y gana la del tipo concreto.")
print("horario() NO esta declarada: se resuelve al compilar, mirando solo")
print("el tipo de la variable, y gana la de la extension.")

print("")
print("La regla, en una linea:")
print("   si quieres que un tipo pueda sustituir el comportamiento,")
print("   DECLARALO en el protocolo, no solo en la extension.")

// Lo mismo con clases y herencia.
class Base { func saludar() -> String { "hola desde Base" } }
final class Derivada: Base { override func saludar() -> String { "hola desde Derivada" } }

let derivada: Base = Derivada()
print("")
print("Con clases el override SIEMPRE es dinamico:")
print("   (Base) Derivada().saludar() -> \(derivada.saludar())")
