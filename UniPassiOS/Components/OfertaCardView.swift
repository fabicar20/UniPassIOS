import SwiftUI

/// Tarjeta reutilizable de una oferta (equivale a `OfertaCard` de Compose).
/// El parámetro `pie` permite poner contenido distinto al final en cada pantalla.
struct OfertaCardView<Pie: View>: View {

    let oferta: Oferta
    private let pie: () -> Pie

    init(oferta: Oferta, @ViewBuilder pie: @escaping () -> Pie) {
        self.oferta = oferta
        self.pie = pie
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(oferta.titulo)
                .font(.headline)
                .multilineTextAlignment(.leading)

            Text(oferta.empresa)
                .font(.subheadline)

            Label(oferta.ubicacion, systemImage: "mappin.and.ellipse")
                .font(.subheadline)
                .foregroundStyle(Color.unipassTextoSecundario)

            Label("\(oferta.tipo) · \(oferta.modalidad)", systemImage: "briefcase")
                .font(.subheadline)
                .foregroundStyle(Color.unipassTextoSecundario)

   if let publicada = oferta.textoPublicacion {
                Label(publicada, systemImage: "clock")
                    .font(.subheadline)
                    .foregroundStyle(Color.unipassTextoSecundario)
            }

            if oferta.vieneDeAPI {
                Label("Oferta en línea · \(oferta.origen)", systemImage: "globe")
                    .font(.caption)
                    .foregroundStyle(Color.unipassTertiary)
            }

            pie()
                .padding(.top, 4)
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .tarjetaUniPass()
    }
}

extension OfertaCardView where Pie == EmptyView {
    init(oferta: Oferta) {
        self.init(oferta: oferta) { EmptyView() }
    }
}
