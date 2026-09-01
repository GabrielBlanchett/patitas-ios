import SwiftUI

/// Capítulo 62: la misma pantalla en cualquier condición.
///
/// Enseña las tres herramientas que hacen que una vista sobreviva a un iPhone
/// chico, a un iPad, y al ajuste de texto accesible: `ViewThatFits`, las
/// clases de tamaño y `dynamicTypeSize`.
struct DemoAdaptativoView: View {
    @Environment(\.dynamicTypeSize) private var tamañoTexto
    @Environment(\.horizontalSizeClass) private var claseAncho

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    seccion("Lo que el sistema dice ahora mismo") {
                        LabeledContent("Tamaño de texto", value: "\(tamañoTexto)")
                        LabeledContent(
                            "Clase de ancho",
                            value: claseAncho == .compact ? "compacta" : "amplia"
                        )
                        LabeledContent(
                            "¿Es tamaño accesible?",
                            value: tamañoTexto.isAccessibilitySize ? "sí" : "no"
                        )
                    }

                    seccion("ViewThatFits: prueba en orden y usa la primera que quepa") {
                        ViewThatFits(in: .horizontal) {
                            HStack {
                                Text("Solicitud de adopción")
                                Spacer()
                                Text("Pendiente").foregroundStyle(.secondary)
                            }
                            VStack(alignment: .leading) {
                                Text("Solicitud de adopción")
                                Text("Pendiente").foregroundStyle(.secondary)
                            }
                        }
                        .padding(10)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
                    }

                    seccion("La fila del catálogo, adaptada") {
                        ForEach(Mascota.refugioDeEjemplo) { mascota in
                            FilaAdaptativa(mascota: mascota)
                            Divider()
                        }
                    }

                    seccion("Área táctil mínima: 44 puntos") {
                        HStack(spacing: 14) {
                            Button("Chico") { }
                                .frame(width: 60, height: 28)
                                .background(.red.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
                            Button("Correcto") { }
                                .frame(minWidth: 60, minHeight: 44)
                                .background(.green.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Adaptativo")
        }
    }

    private func seccion<Contenido: View>(
        _ titulo: String,
        @ViewBuilder contenido: () -> Contenido
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            contenido()
        }
    }
}

/// La fila que arregla el defecto que las capturas del capítulo 50 dejaron a
/// la vista: con texto accesible pasa de fila a columna, así que la insignia
/// ya no se parte por la mitad.
struct FilaAdaptativa: View {
    @Environment(\.dynamicTypeSize) private var tamaño
    let mascota: Mascota

    var body: some View {
        if tamaño.isAccessibilitySize {
            VStack(alignment: .leading, spacing: 6) {
                identidad
                insignia
            }
        } else {
            HStack {
                identidad
                Spacer()
                insignia
            }
        }
    }

    private var identidad: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(mascota.nombre).font(.headline)
            Text(Mascota.edadEnPalabras(meses: mascota.edadEnMeses))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var insignia: some View {
        if !mascota.estaDisponible {
            Text("Adoptada")
                .font(.caption.weight(.medium))
                .lineLimit(1)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.quaternary, in: Capsule())
        }
    }
}

#Preview {
    DemoAdaptativoView()
}
