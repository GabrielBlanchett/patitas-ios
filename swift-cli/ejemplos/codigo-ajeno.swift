// Capitulo 35 - Trabajar con codigo ajeno
//
// Una funcion heredada sin pruebas, y las cuatro maniobras para domarla:
//   1. Leerla ejecutandola, no adivinando
//   2. Fijar su comportamiento con pruebas de caracterizacion
//   3. Brotar (sprout) lo nuevo en una funcion nueva, probada
//   4. Abrir una costura (seam) para poder probar lo que dependia del mundo

import Foundation

// ============================== 1. La funcion tal como la encontramos

// Sin comentarios, sin pruebas, usada en tres pantallas. No se toca todavia.
func calcularCuota(_ b: Double, _ d: Int) -> Double {
    var r = b
    if d > 30 {
        r = 0
    } else if d > 7 {
        r = r * 0.9
    }
    return r * 1.16
}

let sondas: [(Double, Int)] = [(500, 0), (500, 10), (500, 31), (0, 5), (-100, 5)]

// ============================== 2. Pruebas de caracterizacion

// No dicen lo que la funcion DEBERIA hacer. Dicen lo que HACE hoy.
// Si un cambio las rompe, es que cambio el comportamiento. Eso es todo lo que
// necesitamos para movernos sin miedo.
func fijar(_ etiqueta: String, _ obtenido: Double, esperado: Double) -> Bool {
    let ok = abs(obtenido - esperado) < 0.0001
    print("  [\(ok ? "fijado" : "ROTO  ")] \(etiqueta) -> \(obtenido)")
    return ok
}

// ============================== 3. Sprout: lo nuevo, aparte y probado

/// Regla nueva: una cuota nunca puede ser negativa.
/// No se mete dentro de `calcularCuota`: se envuelve.
func cuotaConTopeMinimo(base: Double, dias: Int) -> Double {
    max(0, calcularCuota(base, dias))
}

// ============================== 4. Costura: sacar el reloj de dentro

// Antes: la funcion consulta el reloj del sistema por su cuenta.
// No hay forma de probar "que pasa el 1 de enero" sin cambiar la hora de la maquina.
func estaVencidaSinCostura(_ limite: Date) -> Bool {
    Date() > limite
}

// Despues: el reloj entra por la puerta. La costura es el protocolo.
protocol Reloj {
    var ahora: Date { get }
}
struct RelojDelSistema: Reloj {
    var ahora: Date { Date() }
}
struct RelojFijo: Reloj {
    let ahora: Date
}
func estaVencida(_ limite: Date, segun reloj: Reloj) -> Bool {
    reloj.ahora > limite
}

// ============================================================== SALIDA

print("=== 1. Que hace de verdad ===")
for (base, dias) in sondas {
    print("calcularCuota(\(base), \(dias)) = \(calcularCuota(base, dias))")
}

print("=== 2. Pruebas de caracterizacion ===")
var fijadas = 0
if fijar("base 500, dias 0",   calcularCuota(500, 0),   esperado: 580.0)  { fijadas += 1 }
if fijar("base 500, dias 10",  calcularCuota(500, 10),  esperado: 522.0)  { fijadas += 1 }
if fijar("base 500, dias 31",  calcularCuota(500, 31),  esperado: 0.0)    { fijadas += 1 }
if fijar("base 0,   dias 5",   calcularCuota(0, 5),     esperado: 0.0)    { fijadas += 1 }
if fijar("base -100, dias 5",  calcularCuota(-100, 5),  esperado: -116.0) { fijadas += 1 }
print("\(fijadas) de 5 comportamientos fijados")

print("=== 3. Sprout: la regla nueva no toca la vieja ===")
print("calcularCuota(-100, 5)       = \(calcularCuota(-100, 5))")
print("cuotaConTopeMinimo(-100, 5)  = \(cuotaConTopeMinimo(base: -100, dias: 5))")
print("cuotaConTopeMinimo(500, 10)  = \(cuotaConTopeMinimo(base: 500, dias: 10))")

print("=== 4. Costura: el reloj entra por la puerta ===")
let calendario = Calendar(identifier: .gregorian)
let limite = calendario.date(from: DateComponents(year: 2026, month: 6, day: 1))!
let antes = RelojFijo(ahora: calendario.date(from: DateComponents(year: 2026, month: 1, day: 15))!)
let despues = RelojFijo(ahora: calendario.date(from: DateComponents(year: 2026, month: 12, day: 15))!)
print("Limite: \(limite.ISO8601Format())")
print("Reloj en enero    -> vencida: \(estaVencida(limite, segun: antes))")
print("Reloj en diciembre -> vencida: \(estaVencida(limite, segun: despues))")
print("Reloj del sistema  -> vencida: \(estaVencida(limite, segun: RelojDelSistema()))")
