import SwiftUI

/// Capítulo 60: una animación no se dibuja, se declara.
///
/// La vista tiene un solo booleano. No hay código de animación: se describe
/// cómo se ve en cada estado y SwiftUI interpola entre los dos.
///
/// Recibe el estado inicial para que el CI pueda fotografiar los dos extremos
/// —una animación no se puede capturar a media transición de forma fiable—.
struct DemoAnimacionView: View {
    @State private var expandida: Bool

    init(expandida: Bool = false) {
        _expandida = State(initialValue: expandida)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 26) {
                tarjeta

                Button(expandida ? "Contraer" : "Expandir") {
                    // Todo lo que cambie aquí dentro se anima.
                    withAnimation(.spring(duration: 0.4, bounce: 0.3)) {
                        expandida.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)

                Divider()

                VStack(spacing: 10) {
                    Text("Transiciones: aparecer y desaparecer")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    if expandida {
                        Label("Solicitud enviada", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(height: 44)

                Spacer()
            }
            .padding()
            .navigationTitle("Animación")
        }
    }

    private var tarjeta: some View {
        VStack(alignment: .leading, spacing: expandida ? 10 : 4) {
            HStack {
                Text("Kira")
                    .font(expandida ? .largeTitle.bold() : .headline)
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundStyle(.pink)
                    .rotationEffect(.degrees(expandida ? 0 : -20))
                    .scaleEffect(expandida ? 1.6 : 1)
            }
            Text("1 año y 2 meses")
                .font(expandida ? .body : .caption)
                .foregroundStyle(.secondary)

            if expandida {
                Text("Kira es tranquila, convive con otros perros y ya está esterilizada. "
                     + "Busca una casa con patio o paseos diarios.")
                    .font(.callout)
                    .transition(.opacity)
            }
        }
        .padding(expandida ? 20 : 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: expandida ? 20 : 10)
                .fill(expandida ? Color.pink.opacity(0.12) : Color.gray.opacity(0.12))
        )
    }
}

#Preview("Contraída") { DemoAnimacionView(expandida: false) }
#Preview("Expandida") { DemoAnimacionView(expandida: true) }
