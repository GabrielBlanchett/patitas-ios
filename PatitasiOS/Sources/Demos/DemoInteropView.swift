import SwiftUI
import UIKit

/// Capítulo 69: las dos direcciones de la interoperabilidad, en una pantalla.
///
/// Arriba, una vista de UIKit metida dentro de SwiftUI. Abajo, una vista de
/// SwiftUI metida dentro de UIKit. En una app que migra, las dos ocurren a la
/// vez y durante meses.
struct DemoInteropView: View {
    @State private var valor = 0.35

    var body: some View {
        NavigationStack {
            List {
                Section {
                    // Un control de UIKit que SwiftUI no tiene equivalente
                    // exacto, con su valor enlazado a un @State normal.
                    DeslizadorUIKit(valor: $valor)
                        .frame(height: 34)
                    LabeledContent("Valor", value: valor.formatted(.percent.precision(.fractionLength(0))))
                } header: {
                    Text("UIKit dentro de SwiftUI")
                } footer: {
                    Text("Un UISlider envuelto con UIViewRepresentable. El valor viaja "
                         + "a un @State por medio de un Coordinator.")
                }

                Section {
                    VistaDeUIKitConSwiftUIDentro()
                        .frame(height: 120)
                } header: {
                    Text("SwiftUI dentro de UIKit")
                } footer: {
                    Text("Un UIViewController que aloja una vista de SwiftUI con "
                         + "UIHostingController. Es el camino de una migración gradual.")
                }
            }
            .navigationTitle("Interoperar")
        }
    }
}

// MARK: - UIKit dentro de SwiftUI

/// Envuelve una vista de UIKit para usarla como si fuera de SwiftUI.
///
/// Son siempre las mismas tres piezas: crear, actualizar y —cuando hay que
/// escuchar eventos— un coordinador que haga de destinatario.
struct DeslizadorUIKit: UIViewRepresentable {
    @Binding var valor: Double

    func makeUIView(context: Context) -> UISlider {
        let deslizador = UISlider()
        deslizador.minimumTrackTintColor = .systemPink
        deslizador.addTarget(
            context.coordinator,
            action: #selector(Coordinador.cambio(_:)),
            for: .valueChanged
        )
        return deslizador
    }

    /// Se llama cada vez que el estado de SwiftUI cambia. Aquí se empuja el
    /// valor hacia UIKit, nunca al revés.
    func updateUIView(_ deslizador: UISlider, context: Context) {
        deslizador.value = Float(valor)
    }

    func makeCoordinator() -> Coordinador { Coordinador(valor: $valor) }

    /// UIKit avisa con selectores y delegados, que necesitan un objeto. El
    /// coordinador es ese objeto, y el puente hacia el `Binding`.
    final class Coordinador: NSObject {
        private let valor: Binding<Double>

        init(valor: Binding<Double>) { self.valor = valor }

        @objc func cambio(_ deslizador: UISlider) {
            valor.wrappedValue = Double(deslizador.value)
        }
    }
}

// MARK: - SwiftUI dentro de UIKit

/// Un controlador de UIKit que aloja una vista de SwiftUI, envuelto a su vez
/// para poder enseñarlo aquí. Suena retorcido y es exactamente lo que pasa en
/// una app a medio migrar.
struct VistaDeUIKitConSwiftUIDentro: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        ControladorAnfitrion()
    }

    func updateUIViewController(_ controlador: UIViewController, context: Context) { }
}

final class ControladorAnfitrion: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        let dentro = UIHostingController(rootView: TarjetaSwiftUI())
        dentro.view.backgroundColor = .clear

        // Los tres pasos que hay que hacer SIEMPRE al alojar un hijo. Saltarse
        // el primero o el tercero deja un controlador huérfano que no recibe
        // eventos de ciclo de vida.
        addChild(dentro)
        view.addSubview(dentro.view)
        dentro.didMove(toParent: self)

        dentro.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dentro.view.topAnchor.constraint(equalTo: view.topAnchor),
            dentro.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dentro.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dentro.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

struct TarjetaSwiftUI: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "swift")
                .font(.largeTitle)
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 2) {
                Text("Esto es SwiftUI").font(.headline)
                Text("dibujado dentro de un UIViewController")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    DemoInteropView()
}
