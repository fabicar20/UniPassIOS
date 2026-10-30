import SwiftUI

struct EditarPerfilView: View {

    @Environment(PerfilViewModel.self) private var perfilVM
    @Environment(\.dismiss) private var dismiss

    @State private var universidad = ""
    @State private var carrera = ""
    @State private var semestre = 0          // 0 = sin indicar
    @State private var habilidades = ""
    @State private var idiomas = ""
    @State private var sobreMi = ""
    @State private var cargado = false

    var body: some View {
        Form {
            Section("Datos académicos") {
                TextField("Universidad", text: $universidad)
                TextField("Carrera", text: $carrera)

                Stepper(value: $semestre, in: 0...12) {
                    Text(semestre == 0 ? "Semestre: sin indicar" : "Semestre: \(semestre)")
                }
            }

            Section("Habilidades (separadas por comas)") {
                TextField("Swift, Redes, Excel", text: $habilidades, axis: .vertical)
                    .lineLimit(1...4)
            }

            Section("Idiomas (uno por línea)") {
                TextField("Español — Nativo", text: $idiomas, axis: .vertical)
                    .lineLimit(2...6)
            }

            Section("Sobre mí") {
                TextField("Cuéntanos sobre ti", text: $sobreMi, axis: .vertical)
                    .lineLimit(3...8)
            }

            Section {
                Button("Guardar") {
                    perfilVM.guardar(
                        universidad: universidad,
                        carrera: carrera,
                        semestre: semestre == 0 ? "" : String(semestre),
                        habilidades: habilidades,
                        idiomas: idiomas,
                        sobreMi: sobreMi
                    )
                    dismiss()
                }
                .frame(maxWidth: .infinity)

                Button("Cancelar", role: .cancel) {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Editar perfil")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: cargarDatos)
    }

    /// Rellena el formulario con el perfil guardado (solo la primera vez que aparece).
    private func cargarDatos() {
        guard !cargado else { return }
        cargado = true
        guard let perfil = perfilVM.perfil else { return }
        universidad = perfil.universidad
        carrera = perfil.carrera
        semestre = Int(perfil.semestre) ?? 0
        habilidades = perfil.habilidades
        idiomas = perfil.idiomas
        sobreMi = perfil.sobreMi
    }
}
