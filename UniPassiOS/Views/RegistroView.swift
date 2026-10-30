import SwiftUI

struct RegistroView: View {

    @Environment(AuthViewModel.self) private var auth
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
    @State private var correo = ""
    @State private var clave = ""
    @State private var confirmacion = ""
    @State private var errorLocal: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {

                Text("Crear cuenta")
                    .font(.largeTitle.bold())
                    .padding(.top, 16)

                Text("Empieza a buscar tu pasantía o práctica profesional")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.unipassTextoSecundario)

                Spacer().frame(height: 12)

                TextField("Nombre completo", text: $nombre)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.name)

                TextField("Correo institucional", text: $correo)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                SecureField("Contraseña (mínimo 6 caracteres)", text: $clave)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.newPassword)

                SecureField("Confirmar contraseña", text: $confirmacion)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.newPassword)

                if let mensaje = errorLocal ?? auth.error {
                    Text(mensaje)
                        .font(.subheadline)
                        .foregroundStyle(Color.unipassError)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button {
                    registrar()
                } label: {
                    Text("Registrarme")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 8)

                Button {
                    auth.limpiarError()
                    dismiss()
                } label: {
                    Text("Ya tengo cuenta")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding(24)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.unipassFondo.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { auth.limpiarError() }
    }

    private func registrar() {
        if nombre.trimmed.isEmpty {
            errorLocal = "Escribe tu nombre."
        } else if !correo.trimmed.esCorreoValido {
            errorLocal = "Escribe un correo válido."
        } else if clave.count < 6 {
            errorLocal = "La contraseña debe tener mínimo 6 caracteres."
        } else if clave != confirmacion {
            errorLocal = "Las contraseñas no coinciden."
        } else {
            errorLocal = nil
            // Si todo sale bien, la sesión se abre y RaizView muestra la app.
            auth.registrar(nombre: nombre, correo: correo, clave: clave)
        }
    }
}
