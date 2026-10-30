import Foundation
import SwiftData

/// Cuenta de usuario guardada en SwiftData.
/// La contraseña se guarda como hash (SHA-256), nunca en texto plano.
@Model
final class Usuario {
    @Attribute(.unique) var id: Int
    var nombre: String
    @Attribute(.unique) var correo: String
    var claveHash: String

    init(id: Int, nombre: String, correo: String, claveHash: String) {
        self.id = id
        self.nombre = nombre
        self.correo = correo
        self.claveHash = claveHash
    }
}

/// Datos de la persona que inició sesión (equivale a `Sesion` en Android).
struct Sesion: Equatable, Hashable {
    let id: Int
    let nombre: String
    let correo: String
}
