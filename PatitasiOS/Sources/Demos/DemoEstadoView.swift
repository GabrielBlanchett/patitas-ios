import SwiftUI

/// El modelo observable del capítulo 57.
///
/// `@Observable` sustituye a `ObservableObject`, `@Published` y
/// `@StateObject`. Y hace algo que aquéllos no hacían: la vista solo se
/// redibuja si cambió una propiedad que **esa vista lee**.
@Observable
final class ContadorDeVisitas {
    var visitas = 0
    /// Nadie la lee en la vista, así que cambiarla no redibuja nada.
    var ultimaActualizacion = Date()

    func registrarVisita() {
        visitas += 1
        ultimaActualizacion = .now
    }
}

/// Capítulo 57: las tres formas de tener estado.
struct DemoEstadoView: View {
    /// Estado propio de esta vista. Nace con ella y muere con ella.
    @State private var contador = 0
    @State private var filtroTexto = ""
    @State private var soloDisponibles = false

    /// Un objeto de referencia, creado una vez y observado.
    @State private var visitas = ContadorDeVisitas()

    private var mascotasFiltradas: [Mascota] {
        Mascota.refugioDeEjemplo.filter { mascota in
            let coincide = filtroTexto.isEmpty
                || mascota.nombre.localizedCaseInsensitiveContains(filtroTexto)
            return coincide && (!soloDisponibles || mascota.estaDisponible)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("@State: un valor de esta vista") {
                    Stepper("Contador: \(contador)", value: $contador, in: 0...20)
                    Text(contador == 0 ? "Sin toques todavía" : "Tocaste \(contador) veces")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("@Binding: la sub-vista escribe en el padre") {
                    InterruptorEtiquetado(
                        titulo: "Solo disponibles",
                        activo: $soloDisponibles
                    )
                    TextField("Filtrar por nombre", text: $filtroTexto)
                    Text(mascotasFiltradas.count == 1
                         ? "1 resultado"
                         : "\(mascotasFiltradas.count) resultados")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("El resultado") {
                    if mascotasFiltradas.isEmpty {
                        Text("Ninguna mascota coincide")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(mascotasFiltradas) { mascota in
                            FilaMascota(mascota: mascota)
                        }
                    }
                }

                Section("@Observable: un objeto compartido") {
                    LabeledContent("Visitas", value: "\(visitas.visitas)")
                    Button("Registrar visita") { visitas.registrarVisita() }
                }
            }
            .navigationTitle("Estado")
        }
    }
}

/// Recibe un `Binding`: puede leer **y escribir** el valor del padre sin
/// conocerlo. Es la diferencia con pasar el valor a secas.
struct InterruptorEtiquetado: View {
    let titulo: String
    @Binding var activo: Bool

    var body: some View {
        Toggle(titulo, isOn: $activo)
    }
}

#Preview {
    DemoEstadoView()
}
