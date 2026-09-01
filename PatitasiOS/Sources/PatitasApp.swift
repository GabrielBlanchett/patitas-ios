import SwiftUI

@main
struct PatitasApp: App {
    var body: some Scene {
        WindowGroup {
            ListaMascotasView(mascotas: Mascota.refugioDeEjemplo)
        }
    }
}
