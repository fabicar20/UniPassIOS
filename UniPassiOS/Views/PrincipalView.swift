import SwiftUI

/// Barra inferior con las 5 pestañas (igual que la de Android).
/// Cada pestaña tiene su propio NavigationStack.
struct PrincipalView: View {

    var body: some View {
        TabView {
            PilaConDetalle {
                InicioView()
            }
            .tabItem { Label("Inicio", systemImage: "house.fill") }

            PilaConDetalle {
                BusquedaView()
            }
            .tabItem { Label("Buscar", systemImage: "magnifyingglass") }

            PilaConDetalle {
                PostulacionesView()
            }
            .tabItem { Label("Postulaciones", systemImage: "doc.text.fill") }

            PilaConDetalle {
                GuardadosView()
            }
            .tabItem { Label("Guardados", systemImage: "bookmark.fill") }

            PerfilTabView()
                .tabItem { Label("Perfil", systemImage: "person.fill") }
        }
    }
}
