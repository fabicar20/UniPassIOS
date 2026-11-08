import SwiftUI

struct DetalleView: View {

    let ofertaId: Int

    @Environment(OfertasViewModel.self) private var vm

    var body: some View {
        ScrollView {
            if let oferta = vm.oferta(id: ofertaId) {
                contenido(oferta)
            } else {
                EstadoVacioView(icono: "questionmark.circle", mensaje: "Esta oferta ya no está disponible.")
            }
        }
        .background(Color.unipassFondo)
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func contenido(_ o: Oferta) -> some View {
        let yaPostulado = vm.estadoPostulacion(de: o) != nil
        let guardada = vm.estaGuardada(o)

        VStack(alignment: .leading, spacing: 12) {

            Text(o.titulo)
                .font(.title.bold())

            Text(o.empresa)
                .font(.title3)

            HStack(spacing: 8) {
                EtiquetaChip(texto: o.tipo)
                EtiquetaChip(texto: o.modalidad)
                if o.vieneDeAPI {
                    EtiquetaChip(texto: o.origen, resaltada: true)
                }
            }

            // ---------- Datos principales ----------
            VStack(alignment: .leading, spacing: 10) {
                Text(o.validaRequisitoGrado
                     ? "✓ Válida para requisito de grado"
                     : "No válida para requisito de grado")
                    .font(.callout)
                    .foregroundStyle(Color.unipassPrimary)

                DatoView(icono: "mappin.and.ellipse", titulo: "Ubicación", valor: o.ubicacion)
                DatoView(icono: "clock", titulo: "Duración", valor: o.duracion)
                DatoView(icono: "calendar", titulo: "Horario", valor: o.horario)
                DatoView(icono: "banknote", titulo: "Remuneración", valor: o.remuneracion)
                                if let publicada = o.textoPublicacion {
                                    DatoView(icono: "clock.arrow.circlepath", titulo: "Publicación", valor: publicada)
                                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .tarjetaUniPass()

            // ---------- Listas ----------
            if !o.listaResponsabilidades.isEmpty {
                SeccionLista(titulo: "Responsabilidades", elementos: o.listaResponsabilidades)
            }

            if !o.listaRequisitos.isEmpty {
                SeccionLista(titulo: "Requisitos", elementos: o.listaRequisitos)
            }

            if !o.descripcion.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descripción")
                        .font(.title3.bold())
                    Text(o.descripcion)
                        .font(.body)
                }
                .padding(.top, 8)
            }

            if let enlace = URL(string: o.urlOriginal), !o.urlOriginal.isEmpty {
                Link(destination: enlace) {
                    Label("Ver oferta original", systemImage: "arrow.up.right.square")
                }
                .padding(.top, 4)
            }

            // ---------- Postularme ----------
            Button {
                vm.postular(o)
            } label: {
                Text(yaPostulado
                     ? "✓ Ya te postulaste (\(vm.estadoPostulacion(de: o) ?? ""))"
                     : "Postularme ahora")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(yaPostulado)
            .padding(.top, 12)

            // ---------- Guardar ----------
            Button {
                vm.alternarGuardada(o)
            } label: {
                Label(
                    guardada ? "Quitar de guardados" : "Guardar oferta",
                    systemImage: guardada ? "bookmark.fill" : "bookmark"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .padding(16)
    }
}

private struct DatoView: View {
    let icono: String
    let titulo: String
    let valor: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Label(titulo, systemImage: icono)
                .font(.callout.weight(.semibold))
            Text(valor.isEmpty ? "No especificado" : valor)
                .foregroundStyle(Color.unipassTextoSecundario)
        }
    }
}

private struct SeccionLista: View {
    let titulo: String
    let elementos: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.title3.bold())
            ForEach(elementos, id: \.self) { elemento in
                Text("• \(elemento)")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }
}
