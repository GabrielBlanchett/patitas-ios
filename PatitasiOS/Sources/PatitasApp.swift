import SwiftUI

@main
struct PatitasApp: App {
    /// El sistema avisa aquí cuando la app se activa, se vuelve inactiva o pasa
    /// a segundo plano. Es el punto donde se guarda lo pendiente: capítulo 61.
    @Environment(\.scenePhase) private var fase

    var body: some Scene {
        WindowGroup {
            // Qué pantalla se abre lo decide un argumento de lanzamiento, para
            // que el CI pueda fotografiarlas todas sin navegar. Sin argumento,
            // el catálogo de siempre.
            RaizDemo(demo: Demo.seleccionada)
        }
        .onChange(of: fase) { _, nueva in
            // En una app real, aquí se guarda el borrador y se paran las
            // tareas caras. Se deja explícito aunque no haga nada todavía:
            // es el gancho que el capítulo 61 explica.
            if nueva == .background {
                UserDefaults.standard.set(Date(), forKey: "patitas.ultimaSalida")
            }
        }
    }
}
