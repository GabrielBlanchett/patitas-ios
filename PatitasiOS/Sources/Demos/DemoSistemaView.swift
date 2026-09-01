import SwiftUI
import Dominio

/// El sistema de diseño de Patitas, del capítulo 63.
///
/// La idea entera cabe en una frase: **ningún color ni ningún espaciado se
/// escribe suelto en una vista**. Se declaran aquí una vez, con nombre de
/// intención —`peligro`, no `rojo`— para que cambiar la marca sea editar un
/// archivo y no cazar literales por toda la app.
enum Estilo {
    enum Colores {
        static let acento = Color.pink
        static let exito = Color.green
        static let peligro = Color.red
        static let aviso = Color.orange
        /// Los del sistema se adaptan solos a claro y oscuro: no se sustituyen.
        static let fondo = Color(.systemGroupedBackground)
        static let superficie = Color(.secondarySystemGroupedBackground)
    }

    enum Espacio {
        static let chico: CGFloat = 4
        static let medio: CGFloat = 12
        static let grande: CGFloat = 20
    }

    enum Radio {
        static let tarjeta: CGFloat = 12
    }
}

/// Un componente reutilizable. La app no dibuja pastillas a mano: usa ésta.
struct Insignia: View {
    enum Tono { case exito, aviso, peligro, neutro }

    let texto: String
    var tono: Tono = .neutro

    private var color: Color {
        switch tono {
        case .exito: Estilo.Colores.exito
        case .aviso: Estilo.Colores.aviso
        case .peligro: Estilo.Colores.peligro
        case .neutro: .secondary
        }
    }

    var body: some View {
        Text(texto)
            .font(.caption.weight(.medium))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15), in: Capsule())
    }
}

/// Un modificador propio: se aplica con `.tarjeta()` y encapsula la decisión.
struct EstiloTarjeta: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Estilo.Espacio.medio)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Estilo.Colores.superficie,
                        in: RoundedRectangle(cornerRadius: Estilo.Radio.tarjeta))
    }
}

extension View {
    func tarjeta() -> some View { modifier(EstiloTarjeta()) }
}

/// Capítulo 63: el catálogo del sistema de diseño.
///
/// Una pantalla así, dentro de la propia app, es lo que evita que cada
/// desarrollador invente su propia versión del mismo botón.
struct DemoSistemaView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Estilo.Espacio.grande) {
                    grupo("Tipografía: estilos, nunca tamaños") {
                        VStack(alignment: .leading, spacing: Estilo.Espacio.chico) {
                            Text("largeTitle").font(.largeTitle)
                            Text("title2").font(.title2)
                            Text("headline").font(.headline)
                            Text("body").font(.body)
                            Text("caption").font(.caption).foregroundStyle(.secondary)
                        }
                        .tarjeta()
                    }

                    grupo("Color por intención, no por tono") {
                        HStack(spacing: Estilo.Espacio.medio) {
                            Insignia(texto: "Disponible", tono: .exito)
                            Insignia(texto: "En revisión", tono: .aviso)
                            Insignia(texto: "Rechazada", tono: .peligro)
                        }
                        .tarjeta()
                    }

                    grupo("Espaciado con nombre") {
                        VStack(alignment: .leading, spacing: Estilo.Espacio.chico) {
                            barra("chico", Estilo.Espacio.chico)
                            barra("medio", Estilo.Espacio.medio)
                            barra("grande", Estilo.Espacio.grande)
                        }
                        .tarjeta()
                    }

                    grupo("Un componente, un solo sitio que cambiar") {
                        VStack(alignment: .leading, spacing: Estilo.Espacio.medio) {
                            ForEach(Mascota.refugioDeEjemplo) { mascota in
                                HStack {
                                    Text(mascota.nombre).font(.headline)
                                    Spacer()
                                    Insignia(
                                        texto: mascota.estaDisponible ? "Disponible" : "Adoptada",
                                        tono: mascota.estaDisponible ? .exito : .neutro
                                    )
                                }
                            }
                        }
                        .tarjeta()
                    }
                }
                .padding(Estilo.Espacio.medio)
            }
            .background(Estilo.Colores.fondo)
            .navigationTitle("Sistema de diseño")
        }
    }

    private func grupo<Contenido: View>(
        _ titulo: String,
        @ViewBuilder contenido: () -> Contenido
    ) -> some View {
        VStack(alignment: .leading, spacing: Estilo.Espacio.chico) {
            Text(titulo)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            contenido()
        }
    }

    private func barra(_ nombre: String, _ ancho: CGFloat) -> some View {
        HStack(spacing: Estilo.Espacio.medio) {
            Rectangle()
                .fill(Estilo.Colores.acento.opacity(0.5))
                .frame(width: ancho * 4, height: 14)
            Text("\(nombre): \(Int(ancho)) pt").font(.caption)
        }
    }
}

#Preview {
    DemoSistemaView()
}
