import Foundation

// MARK: - Modelos de la respuesta (Codable)

/// Respuesta de https://remotive.com/api/remote-jobs
struct RemotiveRespuesta: Codable {
    let jobs: [RemotiveJob]
}

/// Un empleo tal como lo devuelve la API de Remotive.
/// Los campos opcionales evitan que la app falle si la API omite alguno.
struct RemotiveJob: Codable {
    let id: Int
    let url: String?
    let title: String
    let companyName: String?
    let category: String?
    let jobType: String?
    let publicationDate: String?
    let candidateRequiredLocation: String?
    let salary: String?
    let description: String?
}

// MARK: - Errores

enum ErrorAPI: LocalizedError {
    case urlInvalida
    case sinConexion
    case respuestaInvalida(codigo: Int)
    case decodificacion

    var errorDescription: String? {
        switch self {
        case .urlInvalida:
            return "La dirección del servicio no es válida."
        case .sinConexion:
            return "No se pudo conectar con el servicio. Revisa tu conexión a Internet."
        case .respuestaInvalida(let codigo):
            return "El servicio respondió con un error (código \(codigo))."
        case .decodificacion:
            return "No se pudo leer la respuesta del servicio."
        }
    }
}

// MARK: - Servicio de red

/// Capa de RED: pide las ofertas a una API pública en Internet usando URLSession
/// y convierte el JSON a objetos Swift con Codable.
///
/// API usada: Remotive (https://remotive.com/api/remote-jobs) - pública, sin llave.
struct OfertaAPIService {

    private let sesion: URLSession

    init(sesion: URLSession = .shared) {
        self.sesion = sesion
    }

    func obtenerOfertas(limite: Int = 20) async throws -> [RemotiveJob] {
        guard var componentes = URLComponents(string: "https://remotive.com/api/remote-jobs") else {
            throw ErrorAPI.urlInvalida
        }
        componentes.queryItems = [
            URLQueryItem(name: "category", value: "software-dev"),
            URLQueryItem(name: "limit", value: String(limite))
        ]
        guard let url = componentes.url else {
            throw ErrorAPI.urlInvalida
        }

        var peticion = URLRequest(url: url)
        peticion.timeoutInterval = 20
        peticion.setValue("application/json", forHTTPHeaderField: "Accept")

        let datos: Data
        let respuesta: URLResponse
        do {
            (datos, respuesta) = try await sesion.data(for: peticion)
        } catch {
            throw ErrorAPI.sinConexion
        }

        guard let http = respuesta as? HTTPURLResponse else {
            throw ErrorAPI.respuestaInvalida(codigo: -1)
        }
        guard (200..<300).contains(http.statusCode) else {
            throw ErrorAPI.respuestaInvalida(codigo: http.statusCode)
        }

        do {
            let decodificador = JSONDecoder()
            decodificador.keyDecodingStrategy = .convertFromSnakeCase
            return try decodificador.decode(RemotiveRespuesta.self, from: datos).jobs
        } catch {
            throw ErrorAPI.decodificacion
        }
    }
}

// MARK: - De la API al modelo local

extension RemotiveJob {


    /// Fecha de publicación ya convertida a `Date` (o `nil` si la API no la envía o viene rara).
    var fecha: Date? { FechaAPI.convertir(publicationDate) }

    /// Convierte un empleo de la API en una `Oferta` que se guarda en SwiftData.
    func aOferta() -> Oferta {
        let esPasantia = (jobType ?? "").lowercased() == "internship"

        let horario: String
        switch (jobType ?? "").lowercased() {
        case "full_time": horario = "Tiempo completo"
        case "part_time": horario = "Medio tiempo"
        case "contract": horario = "Por contrato"
        case "freelance": horario = "Freelance"
        case "internship": horario = "Pasantía"
        default: horario = "No especificado"
        }

        var requisitos = ""
        if let lugar = candidateRequiredLocation, !lugar.trimmed.isEmpty {
            requisitos = "Disponible para: \(lugar.trimmed)"
        }
        if let categoria = category, !categoria.trimmed.isEmpty {
            requisitos += (requisitos.isEmpty ? "" : "\n") + "Categoría: \(categoria.trimmed)"
        }

        let sueldo = (salary ?? "").trimmed

        return Oferta(
            id: Oferta.idBaseAPI + id,
            titulo: title.trimmed,
            empresa: (companyName ?? "Empresa no indicada").trimmed,
            ubicacion: "Remoto",
            modalidad: "Remoto",
            tipo: esPasantia ? "Pasantía" : "Empleo",
            remuneracion: sueldo.isEmpty ? "No especificada" : sueldo,
            duracion: "No especificada",
            horario: horario,
            responsabilidades: "",
            requisitos: requisitos,
            validaRequisitoGrado: esPasantia,
            descripcion: TextoLimpio.desdeHTML(description ?? ""),
            urlOriginal: url ?? "",
             origen: "Remotive",
                      fechaPublicacion: fecha
        )
    }
}
