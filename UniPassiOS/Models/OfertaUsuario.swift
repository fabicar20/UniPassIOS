import Foundation
import SwiftData

/// Lo que cada usuario hizo con cada oferta: si la guardó y/o se postuló.
/// Una fila por pareja (usuarioId, ofertaId).
@Model
final class OfertaUsuario {
    var usuarioId: Int
    var ofertaId: Int
    var guardada: Bool
    var estadoPostulacion: String?   // nil = no se ha postulado

    init(usuarioId: Int, ofertaId: Int, guardada: Bool = false, estadoPostulacion: String? = nil) {
        self.usuarioId = usuarioId
        self.ofertaId = ofertaId
        self.guardada = guardada
        self.estadoPostulacion = estadoPostulacion
    }
}
