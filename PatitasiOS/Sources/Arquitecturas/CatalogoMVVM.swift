import SwiftUI

// MARK: - Modelo de vista

/// El catálogo en MVVM. Dos archivos en total: éste y la vista, que está abajo.
///
/// El modelo de vista **no importa SwiftUI**: no conoce vistas, no dibuja y no
/// navega. Eso es lo que permite probarlo sin simulador.
@Observable
@MainActor
final class CatalogoViewModel {
    private(set) var estado: EstadoDelCatalogo = .cargando
    var soloDisponibles = false {
        didSet { recalcular() }
    }

    private var todas: [Mascota] = []
    private let repositorio: RepositorioDeMascotas

    init(repositorio: RepositorioDeMascotas) {
        self.repositorio = repositorio
    }

    func cargar() async {
        estado = .cargando
        do {
            todas = try await repositorio.todas()
            recalcular()
        } catch let error as ErrorDeCatalogo {
            estado = .fallo(error.mensaje)
        } catch {
            estado = .fallo(ErrorDeCatalogo.servidor.mensaje)
        }
    }

    private func recalcular() {
        let visibles = soloDisponibles ? todas.filter(\.estaDisponible) : todas
        estado = visibles.isEmpty ? .vacio : .listo(visibles)
    }
}

// MARK: - Vista

struct CatalogoMVVMView: View {
    @State private var modelo: CatalogoViewModel

    init(repositorio: RepositorioDeMascotas = RepositorioEnMemoria()) {
        _modelo = State(initialValue: CatalogoViewModel(repositorio: repositorio))
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Solo disponibles", isOn: Binding(
                        get: { modelo.soloDisponibles },
                        set: { modelo.soloDisponibles = $0 }
                    ))
                }
                contenido
            }
            .navigationTitle("Catálogo (MVVM)")
            .task { await modelo.cargar() }
        }
    }

    @ViewBuilder
    private var contenido: some View {
        switch modelo.estado {
        case .cargando:
            HStack { Spacer(); ProgressView(); Spacer() }
        case .listo(let mascotas):
            ForEach(mascotas) { FilaMascota(mascota: $0) }
        case .vacio:
            ContentUnavailableView("Ninguna mascota", systemImage: "pawprint",
                                   description: Text("Prueba quitando el filtro."))
        case .fallo(let mensaje):
            ContentUnavailableView("No se pudo cargar", systemImage: "wifi.slash",
                                   description: Text(mensaje))
        }
    }
}

#Preview("MVVM") { CatalogoMVVMView() }
