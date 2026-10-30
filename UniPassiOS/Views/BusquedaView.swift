import SwiftUI

struct BusquedaView: View {

    @Environment(OfertasViewModel.self) private var viewModel

    var body: some View {
        @Bindable var vm = viewModel

        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {

                Text("Filtros")
                    .font(.title3)

                FiltrosOfertaView()

                Text("\(vm.ofertasFiltradas.count) oportunidades encontradas")
                    .font(.headline)
                    .padding(.top, 4)

                if vm.hayFiltrosActivos {
                    Button("Limpiar filtros") {
                        vm.limpiarFiltros()
                    }
                    .font(.subheadline)
                }

                ForEach(vm.ofertasFiltradas, id: \.id) { oferta in
                    NavigationLink(value: oferta.id) {
                        OfertaCardView(oferta: oferta) {
                            if oferta.validaRequisitoGrado {
                                Text("✓ Requisito de grado")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.unipassPrimary)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Buscar oportunidades")
        .searchable(
            text: $vm.consulta,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Buscar una oportunidad"
        )
        .textInputAutocapitalization(.never)
    }
}
