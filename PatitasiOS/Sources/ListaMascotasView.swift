import SwiftUI
import Dominio

/// La pantalla principal: el catálogo del refugio.
struct ListaMascotasView: View {
    let mascotas: [Mascota]

    var body: some View {
        NavigationStack {
            List(mascotas) { mascota in
                FilaMascota(mascota: mascota)
            }
            .navigationTitle("Patitas Seguras")
        }
    }
}

/// Una fila del catálogo. Se separa de la lista para poder verla sola en la
/// vista previa y para que la lista no crezca sin control.
struct FilaMascota: View {
    let mascota: Mascota

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(mascota.nombre)
                    .font(.headline)
                Text(Mascota.edadEnPalabras(meses: mascota.edadEnMeses))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if !mascota.estaDisponible {
                Text("Adoptada")
                    .font(.caption.weight(.medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.quaternary, in: Capsule())
            }
        }
        .padding(.vertical, 4)
        // Sin esto, VoiceOver lee la fila como tres elementos sueltos.
        .accessibilityElement(children: .combine)
    }
}

#Preview("Catálogo") {
    ListaMascotasView(mascotas: Mascota.refugioDeEjemplo)
}

#Preview("Una fila adoptada") {
    FilaMascota(mascota: Mascota(nombre: "Nube", edadEnMeses: 36, adoptada: true))
        .padding()
}
