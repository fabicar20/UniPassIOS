import Foundation
import SwiftData

/// Capa de PERSISTENCIA: configura la base de datos local (SwiftData).
/// Equivale a `UniPassDatabase` (Room) de la versión Android.
enum UniPassModelContainer {

    static let esquema = Schema([
        Oferta.self,
        Usuario.self,
        PerfilUsuario.self,
        OfertaUsuario.self
    ])

    static func crear(enMemoria: Bool = false) -> ModelContainer {
        let configuracion = ModelConfiguration(
            "unipass",
            schema: esquema,
            isStoredInMemoryOnly: enMemoria,
            cloudKitDatabase: .none
        )
        do {
            return try ModelContainer(for: esquema, configurations: configuracion)
        } catch {
            fatalError("No se pudo crear la base de datos local: \(error)")
        }
    }
}
