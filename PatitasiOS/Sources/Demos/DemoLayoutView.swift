import SwiftUI

/// Capítulo 56: cómo se coloca todo.
///
/// Cada bloque enseña una regla del sistema de disposición, con marcos de
/// colores para que se vea el espacio que ocupa cada vista y no solo su
/// contenido. Es la diferencia entre creer que entiendes el layout y verlo.
struct DemoLayoutView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    bloque("HStack: reparte a lo ancho") {
                        HStack(spacing: 8) {
                            caja("A", .blue)
                            caja("B", .green)
                            caja("C", .orange)
                        }
                    }

                    bloque("Spacer: empuja lo demás") {
                        HStack(spacing: 8) {
                            caja("A", .blue)
                            Spacer()
                            caja("C", .orange)
                        }
                    }

                    bloque("frame: pide un tamaño, no lo impone") {
                        HStack(spacing: 8) {
                            caja("60", .blue).frame(width: 60)
                            caja("flexible", .green).frame(maxWidth: .infinity)
                            caja("40", .orange).frame(width: 40)
                        }
                    }

                    bloque("alignment: a qué se alinean entre sí") {
                        HStack(alignment: .bottom, spacing: 8) {
                            caja("alto", .blue).frame(height: 70)
                            caja("bajo", .green).frame(height: 34)
                            caja("medio", .orange).frame(height: 52)
                        }
                    }

                    bloque("ZStack: uno encima de otro") {
                        ZStack(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.blue.opacity(0.25))
                                .frame(height: 70)
                            Text("3")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                                .padding(6)
                                .background(.red, in: Circle())
                                .offset(x: 6, y: -6)
                        }
                    }

                    bloque("padding: por dentro; el orden importa") {
                        HStack(spacing: 12) {
                            Text("fondo\ndespués")
                                .padding(10)
                                .background(.green.opacity(0.3), in: RoundedRectangle(cornerRadius: 8))
                            Text("fondo\nantes")
                                .background(.orange.opacity(0.3), in: RoundedRectangle(cornerRadius: 8))
                                .padding(10)
                        }
                        .font(.caption)
                    }
                }
                .padding()
            }
            .navigationTitle("Disposición")
        }
    }

    private func bloque<Contenido: View>(
        _ titulo: String,
        @ViewBuilder contenido: () -> Contenido
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            contenido()
        }
    }

    private func caja(_ texto: String, _ color: Color) -> some View {
        Text(texto)
            .font(.caption2)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(color.opacity(0.3), in: RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(color, lineWidth: 1))
    }
}

#Preview {
    DemoLayoutView()
}
