import SwiftUI

/// Decide qué se ve: el flujo de acceso (login / registro) o la app principal.
struct RaizView: View {

    @Environment(AuthViewModel.self) private var auth
    @Environment(OfertasViewModel.self) private var ofertasVM
    @Environment(PerfilViewModel.self) private var perfilVM

    var body: some View {
        Group {
            if auth.sesion == nil {
                NavigationStack {
                    LoginView()
                }
            } else {
                PrincipalView()
            }
        }
        .animation(.default, value: auth.sesion?.id)
        // Cada vez que cambia la sesión, los ViewModels cambian de usuario.
        .onChange(of: auth.sesion?.id, initial: true) { _, nuevoId in
            ofertasVM.fijarUsuario(nuevoId)
            perfilVM.fijarUsuario(nuevoId)
        }
    }
}
