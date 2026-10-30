import SwiftUI

/// Filtros compartidos por Inicio y Buscar (mismo componente = mismos filtros).
/// Se combinan entre sí y con el texto de búsqueda.
struct FiltrosOfertaView: View {

    @Environment(OfertasViewModel.self) private var viewModel

    var body: some View {
        @Bindable var vm = viewModel

        VStack(alignment: .leading, spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FiltroMenuView(
                        titulo: "Ubicación",
                        seleccion: $vm.ubicacion,
                        opciones: ["Popayán, Cauca", "Remoto"]
                    )
                    FiltroMenuView(
                        titulo: "Modalidad",
                        seleccion: $vm.modalidad,
                        opciones: ["Presencial", "Remoto", "Híbrido"]
                    )
                    FiltroMenuView(
                        titulo: "Tipo",
                        seleccion: $vm.tipo,
                        opciones: ["Pasantía", "Empleo"]
                    )
                }
            }

            Toggle("Solo ofertas válidas para requisito de grado", isOn: $vm.soloRequisitoGrado)
                .font(.subheadline)
                .tint(Color.unipassPrimary)
        }
    }
}

/// Un chip que abre un menú desplegable. Cuando hay una opción elegida se resalta.
struct FiltroMenuView: View {

    let titulo: String
    @Binding var seleccion: String?
    let opciones: [String]

    var body: some View {
        Menu {
            Button("Cualquiera") {
                seleccion = nil
            }
            ForEach(opciones, id: \.self) { opcion in
                Button {
                    seleccion = opcion
                } label: {
                    if seleccion == opcion {
                        Label(opcion, systemImage: "checkmark")
                    } else {
                        Text(opcion)
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(seleccion ?? titulo)
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }
            .font(.subheadline)
            .foregroundStyle(.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule().fill(seleccion != nil ? Color.unipassPrimaryContainer : Color.unipassTarjeta)
            )
            .overlay(
                Capsule().stroke(Color.unipassPrimary.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
