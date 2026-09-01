import SwiftUI
import Dominio

/// Capítulo 58: listas con secciones y navegación con ruta.
struct DemoListasView: View {
    /// La ruta de navegación como **dato**. Poder leerla y escribirla es lo
    /// que permite volver a la raíz, restaurar el estado o abrir un enlace
    /// profundo sin simular toques.
    @State private var ruta: [Mascota] = []

    private var porDisponibilidad: [(String, [Mascota])] {
        let todas = Mascota.refugioDeEjemplo
        return [
            ("Disponibles", todas.filter(\.estaDisponible)),
            ("Ya adoptadas", todas.filter { !$0.estaDisponible }),
        ]
    }

    var body: some View {
        NavigationStack(path: $ruta) {
            List {
                ForEach(porDisponibilidad, id: \.0) { titulo, mascotas in
                    Section {
                        ForEach(mascotas) { mascota in
                            NavigationLink(value: mascota) {
                                FilaMascota(mascota: mascota)
                            }
                        }
                    } header: {
                        Text(titulo)
                    } footer: {
                        Text(mascotas.count == 1
                             ? "1 mascota en esta sección"
                             : "\(mascotas.count) mascotas en esta sección")
                    }
                }
            }
            .navigationTitle("Catálogo")
            .navigationDestination(for: Mascota.self) { mascota in
                DetalleMascotaView(mascota: mascota, ruta: $ruta)
            }
        }
    }
}

/// El destino. Recibe la ruta para poder manipularla, que es la ventaja de
/// que sea un dato y no una pila oculta.
struct DetalleMascotaView: View {
    let mascota: Mascota
    @Binding var ruta: [Mascota]

    var body: some View {
        List {
            Section("Ficha") {
                LabeledContent("Nombre", value: mascota.nombre)
                LabeledContent("Edad", value: Mascota.edadEnPalabras(meses: mascota.edadEnMeses))
                LabeledContent("Estado", value: mascota.estaDisponible ? "Disponible" : "Adoptada")
            }
            Section {
                Button("Volver al inicio") { ruta.removeAll() }
            } footer: {
                Text("Vaciar la ruta equivale a tocar «atrás» tantas veces como haga falta.")
            }
        }
        .navigationTitle(mascota.nombre)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DemoListasView()
}
