import SwiftUI

struct PerfilView: View {

    @Environment(AuthViewModel.self) private var auth
    @Environment(PerfilViewModel.self) private var perfilVM

    var body: some View {
        let perfil = perfilVM.perfil
        let porcentaje = perfilVM.porcentajeCompletado

        ScrollView {
            VStack(alignment: .leading, spacing: 14) {

                // ---------- Datos principales ----------
                VStack(alignment: .leading, spacing: 4) {
                    let nombre = auth.sesion?.nombre ?? ""
                    Text(nombre.isEmpty ? "Estudiante" : nombre)
                        .font(.title2.bold())

                    if let correo = auth.sesion?.correo, !correo.isEmpty {
                        Text(correo)
                            .foregroundStyle(Color.unipassPrimary)
                    }
                    if let universidad = perfil?.universidad, !universidad.isEmpty {
                        Text(universidad)
                    }
                    if let carrera = perfil?.carrera, !carrera.isEmpty {
                        Text(carrera)
                    }
                    if let semestre = perfil?.semestre, !semestre.isEmpty {
                        Text("Semestre \(semestre)")
                    }
                }

                // ---------- Perfil completado ----------
                VStack(alignment: .leading, spacing: 8) {
                    Text("Perfil completado")
                        .font(.headline)

                    ProgressView(value: Double(porcentaje), total: 100)
                        .tint(Color.unipassPrimary)

                    Text("\(porcentaje)% completado")
                        .foregroundStyle(Color.unipassPrimary)

                    Text("Completa tu información para encontrar oportunidades más compatibles.")
                        .font(.subheadline)

                    NavigationLink(value: DestinoPerfil.editar) {
                        Text(porcentaje == 0 ? "Completar perfil" : "Editar perfil")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .tarjetaUniPass()

                // ---------- Sobre mí ----------
                if let sobreMi = perfil?.sobreMi, !sobreMi.isEmpty {
                    Text("Sobre mí")
                        .font(.title3.bold())
                    Text(sobreMi)
                }

                // ---------- Habilidades ----------
                Text("Habilidades")
                    .font(.title3.bold())

                if perfilVM.listaHabilidades.isEmpty {
                    Text("Aún no has agregado habilidades.")
                        .foregroundStyle(Color.unipassTextoSecundario)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(perfilVM.listaHabilidades, id: \.self) { habilidad in
                                EtiquetaChip(texto: habilidad)
                            }
                        }
                    }
                }

                // ---------- Idiomas ----------
                Text("Idiomas")
                    .font(.title3.bold())

                if perfilVM.listaIdiomas.isEmpty {
                    Text("Aún no has agregado idiomas.")
                        .foregroundStyle(Color.unipassTextoSecundario)
                } else {
                    ForEach(perfilVM.listaIdiomas, id: \.self) { idioma in
                        Text(idioma)
                    }
                }

                // ---------- Documentos ----------
                Text("Documentos")
                    .font(.title3.bold())

                Text("Próximamente podrás subir tus documentos para adjuntarlos a tus postulaciones.")
                    .font(.subheadline)
                    .foregroundStyle(Color.unipassTextoSecundario)

                DocumentoItemView(titulo: "Hoja de vida")
                DocumentoItemView(titulo: "Certificados")
                DocumentoItemView(titulo: "Diplomas")

                // ---------- Botones ----------
                NavigationLink(value: DestinoPerfil.acerca) {
                    Text("Acerca de UniPass y créditos")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding(.top, 8)

                Button {
                    auth.cerrarSesion()
                } label: {
                    Text("Cerrar sesión")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(16)
        }
        .navigationTitle("Mi Perfil")
    }
}

private struct DocumentoItemView: View {
    let titulo: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(titulo)
                    .font(.headline)
                Text("Sin archivo")
                    .font(.caption)
                    .foregroundStyle(Color.unipassTextoSecundario)
            }
            Spacer()
            Button {
                // Aún no funciona (igual que en la versión Android).
            } label: {
                Label("Subir", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.bordered)
            .disabled(true)
        }
        .tarjetaUniPass()
    }
}
