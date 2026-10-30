import Foundation
import SwiftData
import Observation

/// Carga y guarda el perfil del usuario que tiene la sesión abierta.
@Observable
@MainActor
final class PerfilViewModel {

    private let context: ModelContext
    private var usuarioId: Int?

    private(set) var perfil: PerfilUsuario?

    init(context: ModelContext) {
        self.context = context
    }

    /// Se llama cada vez que cambia la sesión (inicio o cierre).
    func fijarUsuario(_ id: Int?) {
        usuarioId = id
        cargar()
    }

    func guardar(
        universidad: String,
        carrera: String,
        semestre: String,
        habilidades: String,
        idiomas: String,
        sobreMi: String
    ) {
        guard let usuarioId else { return }

        let actual: PerfilUsuario
        if let existente = perfil {
            actual = existente
        } else {
            actual = PerfilUsuario(usuarioId: usuarioId)
            context.insert(actual)
        }

        actual.universidad = universidad.trimmed
        actual.carrera = carrera.trimmed
        actual.semestre = semestre.trimmed
        actual.habilidades = habilidades.trimmed
        actual.idiomas = idiomas.trimmed
        actual.sobreMi = sobreMi.trimmed

        try? context.save()
        perfil = actual
    }

    // MARK: - Datos derivados para la pantalla de perfil

    /// Porcentaje de campos que el usuario ya llenó.
    var porcentajeCompletado: Int {
        guard let perfil else { return 0 }
        let campos = [
            perfil.universidad, perfil.carrera, perfil.semestre,
            perfil.habilidades, perfil.idiomas, perfil.sobreMi
        ]
        let llenos = campos.filter { !$0.trimmed.isEmpty }.count
        return llenos * 100 / campos.count
    }

    var listaHabilidades: [String] {
        (perfil?.habilidades ?? "")
            .split(separator: ",")
            .map { String($0).trimmed }
            .filter { !$0.isEmpty }
    }

    var listaIdiomas: [String] {
        (perfil?.idiomas ?? "")
            .components(separatedBy: .newlines)
            .map { $0.trimmed }
            .filter { !$0.isEmpty }
    }

    // MARK: - Privado

    private func cargar() {
        guard let usuarioId else {
            perfil = nil
            return
        }
        var descriptor = FetchDescriptor<PerfilUsuario>(
            predicate: #Predicate { $0.usuarioId == usuarioId }
        )
        descriptor.fetchLimit = 1
        perfil = try? context.fetch(descriptor).first
    }
}
