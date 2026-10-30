import SwiftUI

struct InicioView: View {

    @Environment(AuthViewModel.self) private var auth
    @Environment(OfertasViewModel.self) private var viewModel

    var body: some View {
        @Bindable var vm = viewModel

        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {

                // ---------- Encabezado ----------
                VStack(alignment: .leading, spacing: 2) {
                    Text(saludo)
                        .font(.title.bold())
                    Text("Encuentra oportunidades para tu carrera")
                        .font(.body)
                        .foregroundStyle(Color.unipassTextoSecundario)
                }

                // ---------- Búsqueda ----------
                BarraBusquedaView(
                    texto: $vm.consulta,
                    placeholder: "¿Qué oportunidad estás buscando?"
                )

                // ---------- Filtros ----------
                Text("Filtros rápidos")
                    .font(.title3)
                    .padding(.top, 4)

                FiltrosOfertaView()

                if vm.hayFiltrosActivos {
                    Button("Limpiar filtros") {
                        vm.limpiarFiltros()
                    }
                    .font(.subheadline)
                }

                // ---------- Ofertas desde la API ----------
                EstadoAPIView()

                // ---------- Ofertas ----------
                Text("Oportunidades para ti")
                    .font(.title2)
                    .padding(.top, 6)

                if vm.ofertasFiltradas.isEmpty {
                    EstadoVacioView(
                        icono: "magnifyingglass",
                        mensaje: "No se encontraron ofertas."
                    )
                }

                ForEach(vm.ofertasFiltradas, id: \.id) { oferta in
                    NavigationLink(value: oferta.id) {
                        OfertaCardView(oferta: oferta) {
                            if oferta.validaRequisitoGrado {
                                Text("✓ Compatible con tu requisito de grado")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.unipassPrimary)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("UniPass")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.sincronizarSiHaceFalta()
        }
    }

    private var saludo: String {
        let nombre = auth.sesion?.nombre.trimmed ?? ""
        if nombre.isEmpty { return "Hola" }
        let primero = nombre.split(separator: " ").first.map(String.init) ?? nombre
        return "Hola, \(primero)"
    }
}

/// Tarjeta con el botón para traer ofertas de Internet y el resultado de la petición.
struct EstadoAPIView: View {

    @Environment(OfertasViewModel.self) private var vm

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Ofertas en línea", systemImage: "globe")
                    .font(.headline)
                Spacer()
                if vm.cargandoAPI {
                    ProgressView()
                } else {
                    Button {
                        Task { await vm.sincronizarDesdeAPI() }
                    } label: {
                        Label("Actualizar", systemImage: "arrow.clockwise")
                            .font(.subheadline)
                    }
                    .buttonStyle(.bordered)
                }
            }

            Text(vm.cantidadEnLinea == 0
                 ? "Aún no hay ofertas descargadas de Internet."
                 : "\(vm.cantidadEnLinea) ofertas descargadas desde Remotive.")
                .font(.footnote)
                .foregroundStyle(Color.unipassTextoSecundario)

            if let mensaje = vm.mensajeAPI {
                Text(mensaje)
                    .font(.footnote)
                    .foregroundStyle(Color.unipassTertiary)
            }
        }
        .tarjetaUniPass()
    }
}
