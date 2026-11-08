import Foundation
import SwiftData

/// Oferta de pasantía o empleo.
/// En Android era la entidad `Oferta` de Room; aquí es un modelo de SwiftData.
/// Lo que cada usuario hace con la oferta (guardar / postularse) vive en `OfertaUsuario`.
@Model
final class Oferta {

    /// Las ofertas que vienen de la API usan `idBaseAPI + id remoto`
    /// para no chocar con los ids de las ofertas locales (1, 2, 3...).
    static let idBaseAPI = 1_000_000

    @Attribute(.unique) var id: Int
    var titulo: String
    var empresa: String
    var ubicacion: String
    var modalidad: String          // Presencial, Remoto, Híbrido
    var tipo: String               // Pasantía, Empleo
    var remuneracion: String

    // Datos para la pantalla de detalle
    var duracion: String
    var horario: String
    var responsabilidades: String  // una por línea
    var requisitos: String         // uno por línea
    var validaRequisitoGrado: Bool

    // Datos nuevos de la versión iOS (ofertas que llegan desde la API)
    var descripcion: String
    var urlOriginal: String
    var origen: String             // "Local" o "Remotive"

    /// Fecha en que se publicó la oferta (solo las que vienen de la API).
    /// Es opcional para que las ofertas locales y la base de datos ya creada sigan funcionando.
    var fechaPublicacion: Date?


    init(
        id: Int,
        titulo: String,
        empresa: String,
        ubicacion: String,
        modalidad: String,
        tipo: String,
        remuneracion: String,
        duracion: String = "",
        horario: String = "",
        responsabilidades: String = "",
        requisitos: String = "",
        validaRequisitoGrado: Bool = true,
        descripcion: String = "",
        urlOriginal: String = "",
        origen: String = "Local",
               fechaPublicacion: Date? = nil
    ) {
        self.id = id
        self.titulo = titulo
        self.empresa = empresa
        self.ubicacion = ubicacion
        self.modalidad = modalidad
        self.tipo = tipo
        self.remuneracion = remuneracion
        self.duracion = duracion
        self.horario = horario
        self.responsabilidades = responsabilidades
        self.requisitos = requisitos
        self.validaRequisitoGrado = validaRequisitoGrado
        self.descripcion = descripcion
        self.urlOriginal = urlOriginal
      self.origen = origen
              self.fechaPublicacion = fechaPublicacion
    }

    var listaResponsabilidades: [String] { Oferta.lineas(responsabilidades) }
    var listaRequisitos: [String] { Oferta.lineas(requisitos) }
    var vieneDeAPI: Bool { origen != "Local" }


    /// Ejemplo: "Publicada hace 3 días". `nil` si la oferta no tiene fecha.
    var textoPublicacion: String? {
        fechaPublicacion.map { "Publicada " + $0.haceCuanto }
    }

    private static func lineas(_ texto: String) -> [String] {
        texto
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}
