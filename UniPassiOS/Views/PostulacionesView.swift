import SwiftUI

struct PostulacionesView: View {

    @Environment(OfertasViewModel.self) private var vm

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {

                Text("Aquí puedes consultar el estado de tus postulaciones.")
                    .foregroundStyle(Color.unipassTextoSecundario)

                if vm.postuladas.isEmpty {
                    EstadoVacioView(
                        icono: "doc.text",
                        mensaje: "Aún no te has postulado a ninguna oferta.\nAbre una oferta y toca \"Postularme ahora\"."
                    )
                }

                ForEach(vm.postuladas, id: \.id) { oferta in
                    NavigationLink(value: oferta.id) {
                        OfertaCardView(oferta: oferta) {
                            Text("Estado: \(vm.estadoPostulacion(de: oferta) ?? "")")
                                .font(.subheadline)
                                .foregroundStyle(Color.unipassPrimary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .navigationTitle("Mis postulaciones")
    }
}
