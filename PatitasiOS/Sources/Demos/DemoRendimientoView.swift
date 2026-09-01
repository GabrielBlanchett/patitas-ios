import SwiftUI

/// Cuenta cuántas veces se ha construido cada vista.
///
/// No es código de producción: es un instrumento para que el capítulo 64
/// pueda **enseñar** el número de reconstrucciones en vez de afirmarlo.
///
/// Dos avisos deliberados. Uno: contar dentro de un `body` es exactamente el
/// efecto secundario que este capítulo dice que no se haga; se hace aquí a
/// propósito porque es la única forma de medirlo desde dentro. Dos: por eso
/// la clase **no** es `@Observable`. Si lo fuera, mutarla mientras SwiftUI
/// construye la vista provocaría el aviso «Modifying state during view
/// update» y un bucle de redibujos.
final class ContadorDeDibujos {
    private(set) var cuentas: [String: Int] = [:]

    func registrar(_ etiqueta: String) {
        cuentas[etiqueta, default: 0] += 1
    }

    func cuenta(_ etiqueta: String) -> Int { cuentas[etiqueta] ?? 0 }
}

/// Capítulo 64: qué hace que un `body` se vuelva a ejecutar.
struct DemoRendimientoView: View {
    @State private var contador = 0
    @State private var dibujos = ContadorDeDibujos()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Stepper("Toques: \(contador)", value: $contador, in: 0...99)
                } footer: {
                    Text("Cada toque cambia el estado del padre. Abajo se ve a quién afecta.")
                }

                Section("Quién se reconstruye") {
                    HijoQueLee(valor: contador, dibujos: dibujos)
                    HijoConstante(dibujos: dibujos)
                }

                Section("Listas: perezosa o no") {
                    LabeledContent("List y LazyVStack", value: "crean filas al aparecer")
                    LabeledContent("VStack dentro de ScrollView", value: "las crea todas")
                    Text("Con 10.000 elementos, la diferencia es entre abrir al instante "
                         + "y esperar segundos con la memoria llena.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Reglas") {
                    regla("Un `body` debe ser barato y sin efectos")
                    regla("Nada de trabajo pesado dentro de `body`")
                    regla("Extraer sub-vistas acota lo que se redibuja")
                    regla("Medir con Instruments antes de tocar nada")
                }
            }
            .navigationTitle("Rendimiento")
        }
    }

    private func regla(_ texto: String) -> some View {
        Label(texto, systemImage: "checkmark.circle")
            .font(.callout)
    }
}

/// Lee el valor, así que se reconstruye con cada cambio. Es lo correcto.
struct HijoQueLee: View {
    let valor: Int
    let dibujos: ContadorDeDibujos

    var body: some View {
        dibujos.registrar("lee")
        return LabeledContent("Hijo que lee el valor") {
            Text("\(valor) · \(dibujos.cuenta("lee")) dibujos")
                .monospacedDigit()
        }
    }
}

/// No depende de nada que cambie. SwiftUI compara sus entradas y, al ser
/// iguales, se salta su `body`.
struct HijoConstante: View {
    let dibujos: ContadorDeDibujos

    var body: some View {
        dibujos.registrar("constante")
        return LabeledContent("Hijo que no lee nada") {
            Text("\(dibujos.cuenta("constante")) dibujos")
                .monospacedDigit()
        }
    }
}

#Preview {
    DemoRendimientoView()
}
