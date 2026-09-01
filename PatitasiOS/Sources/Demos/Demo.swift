import SwiftUI
import UIKit

/// Qué pantalla se muestra al arrancar.
///
/// Se elige con un argumento de lanzamiento. iOS convierte cualquier argumento
/// con la forma `-clave valor` en una entrada de `UserDefaults`, así que basta:
///
///     xcrun simctl launch <udid> mx.gabrielblanchet.patitas -demo layout
///
/// Sirve para que el CI fotografíe cada pantalla del libro sin navegar por la
/// interfaz, y para abrir una pantalla concreta al depurar sin dar seis toques.
enum Demo: String, CaseIterable, Sendable {
    case catalogo
    case layout
    case estado
    case listas
    case formulario
    case animacionAntes
    case animacionDespues
    case adaptativo
    case sistema
    case rendimiento
    case uikit
    case interop

    /// La que pidió el argumento de lanzamiento, o el catálogo si no hay.
    static var seleccionada: Demo {
        guard let bruto = UserDefaults.standard.string(forKey: "demo"),
              let demo = Demo(rawValue: bruto)
        else { return .catalogo }
        return demo
    }
}

/// Decide qué vista construir. Es el único sitio de la app que conoce `Demo`.
struct RaizDemo: View {
    let demo: Demo

    var body: some View {
        switch demo {
        case .catalogo:
            ListaMascotasView(mascotas: Mascota.refugioDeEjemplo)
        case .layout:
            DemoLayoutView()
        case .estado:
            DemoEstadoView()
        case .listas:
            DemoListasView()
        case .formulario:
            DemoFormularioView()
        case .animacionAntes:
            DemoAnimacionView(expandida: false)
        case .animacionDespues:
            DemoAnimacionView(expandida: true)
        case .adaptativo:
            DemoAdaptativoView()
        case .sistema:
            DemoSistemaView()
        case .rendimiento:
            DemoRendimientoView()
        case .uikit:
            EnvoltorioUIKit().ignoresSafeArea()
        case .interop:
            DemoInteropView()
        }
    }
}

/// Deja ver el controlador de UIKit dentro del enrutador de SwiftUI, que es de
/// por sí una demostración del capítulo 69.
struct EnvoltorioUIKit: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DemoUIKitController {
        DemoUIKitController()
    }

    func updateUIViewController(_ controlador: DemoUIKitController, context: Context) { }
}
