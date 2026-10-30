import Foundation
import SwiftData
import CryptoKit
import Observation

/// Registro e inicio de sesión contra la tabla de usuarios (SwiftData).
/// Solo entra quien se haya registrado antes con ese correo y esa contraseña.
@Observable
@MainActor
final class AuthViewModel {

    private let context: ModelContext

    /// Sesión actual. `nil` = nadie ha iniciado sesión.
    private(set) var sesion: Sesion?
    var error: String?

    init(context: ModelContext) {
        self.context = context
    }

    func limpiarError() {
        error = nil
    }

    @discardableResult
    func iniciarSesion(correo: String, clave: String) -> Bool {
        error = nil
        let correoLimpio = correo.trimmed.lowercased()

        guard let usuario = buscarUsuario(correo: correoLimpio),
              usuario.claveHash == Self.hash(correo: correoLimpio, clave: clave)
        else {
            error = "Correo o contraseña incorrectos."
            return false
        }

        sesion = Sesion(id: usuario.id, nombre: usuario.nombre, correo: usuario.correo)
        return true
    }

    @discardableResult
    func registrar(nombre: String, correo: String, clave: String) -> Bool {
        error = nil
        let correoLimpio = correo.trimmed.lowercased()
        let nombreLimpio = nombre.trimmed

        if buscarUsuario(correo: correoLimpio) != nil {
            error = "Ya existe una cuenta con ese correo."
            return false
        }

        let nuevoId = siguienteId()
        let usuario = Usuario(
            id: nuevoId,
            nombre: nombreLimpio,
            correo: correoLimpio,
            claveHash: Self.hash(correo: correoLimpio, clave: clave)
        )
        context.insert(usuario)

        do {
            try context.save()
        } catch {
            self.error = "No se pudo crear la cuenta. Inténtalo de nuevo."
            return false
        }

        sesion = Sesion(id: nuevoId, nombre: nombreLimpio, correo: correoLimpio)
        return true
    }

    func cerrarSesion() {
        sesion = nil
        error = nil
    }

    // MARK: - Privado

    private func buscarUsuario(correo: String) -> Usuario? {
        var descriptor = FetchDescriptor<Usuario>(
            predicate: #Predicate { $0.correo == correo }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private func siguienteId() -> Int {
        var descriptor = FetchDescriptor<Usuario>(
            sortBy: [SortDescriptor(\.id, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        let mayor = (try? context.fetch(descriptor).first?.id) ?? 0
        return mayor + 1
    }

    private static func hash(correo: String, clave: String) -> String {
        let digest = SHA256.hash(data: Data("\(correo):\(clave)".utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
