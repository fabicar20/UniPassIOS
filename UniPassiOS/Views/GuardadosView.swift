import SwiftUI

struct GuardadosView: View {

    @Environment(OfertasViewModel.self) private var vm

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {

                Text("Aquí encontrarás las oportunidades que guardaste.")
                    .foregroundStyle(Color.unipassTextoSecundario)

                if vm.guardadas.isEmpty {
                    EstadoVacioView(
                        icono: "bookmark",
                        mensaje: "Aún no has guardado ninguna oferta.\nAbre una oferta y toca \"Guardar oferta\"."
                    )
                }

                ForEach(vm.guardadas, id: \.id) { oferta in
                    ZStack(alignment: .bottomTrailing) {
                        NavigationLink(value: oferta.id) {
                            OfertaCardView(oferta: oferta) {
                                Label("Oferta guardada", systemImage: "bookmark.fill")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.unipassPrimary)
                            }
                        }
                        .buttonStyle(.plain)

                        Button("Quitar") {
                            vm.alternarGuardada(oferta)
                        }
                        .font(.subheadline)
                        .padding(.trailing, 14)
                        .padding(.bottom, 10)
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle("Ofertas guardadas")
    }
}
