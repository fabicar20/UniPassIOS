import SwiftUI

/// NavigationStack que sabe abrir el detalle de una oferta a partir de su id.
/// Las cuatro pestañas de ofertas la reutilizan.
struct PilaConDetalle<Contenido: View>: View {

    private let contenido: () -> Contenido

    init(@ViewBuilder contenido: @escaping () -> Contenido) {
        self.contenido = contenido
    }

    var body: some View {
        NavigationStack {
            contenido()
                .background(Color.unipassFondo)
                .navigationDestination(for: Int.self) { ofertaId in
                    DetalleView(ofertaId: ofertaId)
                }
        }
    }
}
