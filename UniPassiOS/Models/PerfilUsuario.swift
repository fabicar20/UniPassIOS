import Foundation
import SwiftData

/// Datos del perfil que cada usuario llena. Una fila por usuario.
@Model
final class PerfilUsuario {
    @Attribute(.unique) var usuarioId: Int
    var universidad: String
    var carrera: String
    var semestre: String
    var habilidades: String   // separadas por comas
    var idiomas: String       // uno por línea
    var sobreMi: String

    init(
        usuarioId: Int,
        universidad: String = "",
        carrera: String = "",
        semestre: String = "",
        habilidades: String = "",
        idiomas: String = "",
        sobreMi: String = ""
    ) {
        self.usuarioId = usuarioId
        self.universidad = universidad
        self.carrera = carrera
        self.semestre = semestre
        self.habilidades = habilidades
        self.idiomas = idiomas
        self.sobreMi = sobreMi
    }
}
