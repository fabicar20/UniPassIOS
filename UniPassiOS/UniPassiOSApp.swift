import SwiftUI
import SwiftData

/// Punto de entrada de la aplicación.
/// Crea la base de datos (SwiftData) y los tres ViewModels, y los reparte
/// a todas las pantallas con `.environment(...)`.
@main
@MainActor
struct UniPassiOSApp: App {

    private let contenedor: ModelContainer

    @State private var authVM: AuthViewModel
    @State private var ofertasVM: OfertasViewModel
    @State private var perfilVM: PerfilViewModel

    init() {
        let contenedor = UniPassModelContainer.crear()
        self.contenedor = contenedor

        let contexto = contenedor.mainContext
        _authVM = State(initialValue: AuthViewModel(context: contexto))
        _ofertasVM = State(initialValue: OfertasViewModel(context: contexto))
        _perfilVM = State(initialValue: PerfilViewModel(context: contexto))
    }

    var body: some Scene {
        WindowGroup {
            RaizView()
                .environment(authVM)
                .environment(ofertasVM)
                .environment(perfilVM)
                .modelContainer(contenedor)
                .tint(Color.unipassPrimary)
        }
    }
}
