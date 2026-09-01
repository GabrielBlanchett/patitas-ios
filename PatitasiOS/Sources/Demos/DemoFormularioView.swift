import SwiftUI

/// Capítulo 59: un formulario de solicitud de adopción.
///
/// Tiene lo que tiene un formulario de verdad y casi nunca tienen los
/// ejemplos: validación por campo, un mensaje que solo aparece cuando toca, y
/// un botón de enviar que se desactiva hasta que todo está bien.
struct DemoFormularioView: View {
    @State private var nombre = ""
    @State private var correo = "ana@correo"
    @State private var telefono = ""
    @State private var vivienda = Vivienda.departamento
    @State private var tieneOtrasMascotas = true
    @State private var horasSolo = 4.0
    @State private var aceptaVisita = false
    @State private var campoTocado: Set<Campo> = [.correo]

    enum Vivienda: String, CaseIterable, Identifiable {
        case casa = "Casa"
        case departamento = "Departamento"
        case rancho = "Rancho"
        var id: String { rawValue }
    }

    enum Campo: Hashable { case nombre, correo }

    private var correoEsValido: Bool {
        correo.contains("@") && correo.contains(".")
    }

    private var puedeEnviar: Bool {
        !nombre.isEmpty && correoEsValido && aceptaVisita
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Quién solicita") {
                    TextField("Nombre completo", text: $nombre)
                        .textContentType(.name)

                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Correo electrónico", text: $correo)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        // El error solo aparece si el campo ya se tocó: nadie
                        // quiere ver "correo inválido" antes de escribir nada.
                        if campoTocado.contains(.correo) && !correoEsValido {
                            Label("Falta un punto después de la arroba", systemImage: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                    }

                    TextField("Teléfono (opcional)", text: $telefono)
                        .keyboardType(.phonePad)
                }

                Section("Dónde viviría") {
                    Picker("Tipo de vivienda", selection: $vivienda) {
                        ForEach(Vivienda.allCases) { opcion in
                            Text(opcion.rawValue).tag(opcion)
                        }
                    }
                    Toggle("Ya tengo otras mascotas", isOn: $tieneOtrasMascotas)
                    VStack(alignment: .leading) {
                        Text("Horas sola al día: \(Int(horasSolo))")
                        Slider(value: $horasSolo, in: 0...12, step: 1)
                    }
                }

                Section {
                    Toggle("Acepto una visita del refugio", isOn: $aceptaVisita)
                } footer: {
                    Text("La visita es obligatoria y no compromete a nada.")
                }

                Section {
                    Button("Enviar solicitud") { }
                        .disabled(!puedeEnviar)
                } footer: {
                    if !puedeEnviar {
                        Text("Faltan datos: el nombre, un correo válido y aceptar la visita.")
                    }
                }
            }
            .navigationTitle("Solicitud")
        }
    }
}

#Preview {
    DemoFormularioView()
}
