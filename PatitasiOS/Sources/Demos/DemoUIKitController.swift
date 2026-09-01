import UIKit

/// Capítulos 65 a 67: la misma lista, escrita en UIKit.
///
/// Está construida **en código**, sin guion gráfico, por dos razones: un
/// `.storyboard` es un XML generado que da conflictos ilegibles —el mismo
/// problema del `.pbxproj` del capítulo 49— y porque escribir las
/// restricciones a mano es la única forma de entender Auto Layout.
final class DemoUIKitController: UIViewController {

    // MARK: - Datos

    /// El origen de datos por instantáneas. Sustituye a los métodos
    /// `numberOfRowsInSection` y `cellForRowAt` de toda la vida.
    private enum Seccion: Int, CaseIterable {
        case disponibles
        case adoptadas

        var titulo: String {
            switch self {
            case .disponibles: "Disponibles"
            case .adoptadas: "Ya adoptadas"
            }
        }
    }

    private var origenDeDatos: UITableViewDiffableDataSource<Seccion, Mascota>?

    // MARK: - Vistas

    private let encabezado: UILabel = {
        let etiqueta = UILabel()
        etiqueta.text = "Catálogo en UIKit"
        // El estilo del sistema, no un tamaño fijo: crece con el ajuste del
        // usuario igual que en SwiftUI (cap. 62).
        etiqueta.font = .preferredFont(forTextStyle: .largeTitle)
        etiqueta.adjustsFontForContentSizeCategory = true
        etiqueta.numberOfLines = 0
        return etiqueta
    }()

    private let resumen: UILabel = {
        let etiqueta = UILabel()
        etiqueta.font = .preferredFont(forTextStyle: .subheadline)
        etiqueta.adjustsFontForContentSizeCategory = true
        etiqueta.textColor = .secondaryLabel
        etiqueta.numberOfLines = 0
        return etiqueta
    }()

    private let tabla = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        montarJerarquia()
        montarRestricciones()
        montarTabla()
        aplicarDatos()
    }

    private func montarJerarquia() {
        for vista in [encabezado, resumen, tabla] {
            // Sin esto, UIKit sigue usando marcos calculados y las
            // restricciones no sirven de nada. Es el olvido numero uno.
            vista.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(vista)
        }
    }

    private func montarRestricciones() {
        // La guía de márgenes respeta el notch y la barra de inicio sin que
        // haya que saber cuánto miden en cada modelo.
        let guia = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            encabezado.topAnchor.constraint(equalTo: guia.topAnchor, constant: 16),
            encabezado.leadingAnchor.constraint(equalTo: guia.leadingAnchor, constant: 20),
            encabezado.trailingAnchor.constraint(equalTo: guia.trailingAnchor, constant: -20),

            resumen.topAnchor.constraint(equalTo: encabezado.bottomAnchor, constant: 4),
            resumen.leadingAnchor.constraint(equalTo: encabezado.leadingAnchor),
            resumen.trailingAnchor.constraint(equalTo: encabezado.trailingAnchor),

            tabla.topAnchor.constraint(equalTo: resumen.bottomAnchor, constant: 12),
            tabla.leadingAnchor.constraint(equalTo: guia.leadingAnchor),
            tabla.trailingAnchor.constraint(equalTo: guia.trailingAnchor),
            tabla.bottomAnchor.constraint(equalTo: guia.bottomAnchor),
        ])
    }

    private func montarTabla() {
        tabla.register(UITableViewCell.self, forCellReuseIdentifier: "mascota")
        tabla.delegate = self

        origenDeDatos = UITableViewDiffableDataSource<Seccion, Mascota>(
            tableView: tabla
        ) { tabla, indice, mascota in
            let celda = tabla.dequeueReusableCell(withIdentifier: "mascota", for: indice)

            // La configuración de contenido sustituye a tocar
            // `celda.textLabel` a mano, que está obsoleto desde iOS 14.
            var contenido = celda.defaultContentConfiguration()
            contenido.text = mascota.nombre
            contenido.secondaryText = Mascota.edadEnPalabras(meses: mascota.edadEnMeses)
            contenido.image = UIImage(systemName: "pawprint.fill")
            celda.contentConfiguration = contenido

            celda.accessoryType = mascota.estaDisponible ? .disclosureIndicator : .none
            return celda
        }
    }

    private func aplicarDatos() {
        let todas = Mascota.refugioDeEjemplo
        let disponibles = todas.filter(\.estaDisponible)
        let adoptadas = todas.filter { !$0.estaDisponible }

        resumen.text = "\(disponibles.count) disponibles y \(adoptadas.count) adoptada"
            + (adoptadas.count == 1 ? "" : "s")

        var instantanea = NSDiffableDataSourceSnapshot<Seccion, Mascota>()
        instantanea.appendSections(Seccion.allCases)
        instantanea.appendItems(disponibles, toSection: .disponibles)
        instantanea.appendItems(adoptadas, toSection: .adoptadas)

        // `apply` calcula la diferencia y anima solo lo que cambió. Antes esto
        // era `reloadData()`, que redibujaba todo, o `beginUpdates` a mano con
        // el riesgo de que los números no cuadraran y la app se cerrara.
        origenDeDatos?.apply(instantanea, animatingDifferences: false)
    }
}

// MARK: - Delegado

extension DemoUIKitController: UITableViewDelegate {
    func tableView(_ tabla: UITableView, titleForHeaderInSection seccion: Int) -> String? {
        Seccion(rawValue: seccion)?.titulo
    }

    func tableView(_ tabla: UITableView, didSelectRowAt indice: IndexPath) {
        tabla.deselectRow(at: indice, animated: true)
    }
}
