import SwiftUI

/// Destinos a los que se puede ir desde el perfil.
enum DestinoPerfil: Hashable {
    case editar
    case acerca
}

/// Pestaña de perfil: su propia pila de navegación (perfil → editar / acerca de).
struct PerfilTabView: View {

    var body: some View {
        NavigationStack {
            PerfilView()
                .background(Color.unipassFondo)
                .navigationDestination(for: DestinoPerfil.self) { destino in
                    switch destino {
                    case .editar:
                        EditarPerfilView()
                    case .acerca:
                        AcercaView()
                    }
                }
        }
    }
}
