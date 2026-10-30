import SwiftUI

struct LoginView: View {

    @Environment(AuthViewModel.self) private var auth

    @State private var correo = ""
    @State private var clave = ""
    @State private var errorLocal: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(.white)
                    .frame(width: 88, height: 88)
                    .background(Circle().fill(Color.unipassPrimary))
                    .padding(.top, 40)

                Text("UniPass")
                    .font(.largeTitle.bold())

                Text("Tu primer paso profesional")
                    .font(.body)
                    .foregroundStyle(Color.unipassTextoSecundario)

                Spacer().frame(height: 16)

                TextField("Correo institucional", text: $correo)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                SecureField("Contraseña", text: $clave)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.password)

                if let mensaje = errorLocal ?? auth.error {
                    Text(mensaje)
                        .font(.subheadline)
                        .foregroundStyle(Color.unipassError)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button {
                    iniciarSesion()
                } label: {
                    Text("Iniciar sesión")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                NavigationLink {
                    RegistroView()
                } label: {
                    Text("Crear una cuenta")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding(24)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.unipassFondo.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { auth.limpiarError() }
    }

    private func iniciarSesion() {
        if !correo.trimmed.esCorreoValido {
            errorLocal = "Escribe un correo válido."
        } else if clave.isEmpty {
            errorLocal = "Escribe tu contraseña."
        } else {
            errorLocal = nil
            auth.iniciarSesion(correo: correo, clave: clave)
        }
    }
}
