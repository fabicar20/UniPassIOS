import Foundation
import SwiftData
import Observation

/// ViewModel de las ofertas (MVVM). Une las tres capas:
///  - Persistencia: lee y escribe en SwiftData (ofertas, guardadas, postulaciones).
///  - Red: pide ofertas nuevas a la API con `OfertaAPIService`.
///  - Estado de la UI: búsqueda, filtros, cargando, mensajes.
@Observable
@MainActor
final class OfertasViewModel {

    private let context: ModelContext
    private let api: OfertaAPIService

    // MARK: - Usuario actual
    // Guardadas y postulaciones son de cada usuario, no de todo el dispositivo.

    private var usuarioId: Int?

    // MARK: - Datos leídos de la base de datos

    private(set) var ofertas: [Oferta] = []
    private var interacciones: [Int: OfertaUsuario] = [:]   // ofertaId -> lo que hizo el usuario

    // MARK: - Estado de búsqueda y filtros (se combinan entre sí)

    var consulta = ""
    var ubicacion: String?
    var modalidad: String?
    var tipo: String?
    var soloRequisitoGrado = false

    // MARK: - Estado de la red

    private(set) var cargandoAPI = false
    private(set) var mensajeAPI: String?
    private var intentoAutomatico = false

    init(context: ModelContext, api: OfertaAPIService = OfertaAPIService()) {
        self.context = context
        self.api = api
        sembrarSiVacia()
        recargar()
    }

    // MARK: - Listas derivadas

    var ofertasFiltradas: [Oferta] {
        let texto = consulta.trimmed
        return ofertas.filter { oferta in
            if !texto.isEmpty {
                let coincide = oferta.titulo.localizedCaseInsensitiveContains(texto)
                    || oferta.empresa.localizedCaseInsensitiveContains(texto)
                    || oferta.ubicacion.localizedCaseInsensitiveContains(texto)
                if !coincide { return false }
            }
            if let ubicacion, oferta.ubicacion != ubicacion { return false }
            if let modalidad, oferta.modalidad != modalidad { return false }
            if let tipo, oferta.tipo != tipo { return false }
            if soloRequisitoGrado && !oferta.validaRequisitoGrado { return false }
            return true
        }
    }

    var guardadas: [Oferta] {
        ofertas.filter { estaGuardada($0) }
    }

    var postuladas: [Oferta] {
        ofertas.filter { estadoPostulacion(de: $0) != nil }
    }

    var cantidadEnLinea: Int {
        ofertas.filter { $0.vieneDeAPI }.count
    }

    func oferta(id: Int) -> Oferta? {
        ofertas.first { $0.id == id }
    }

    func estaGuardada(_ oferta: Oferta) -> Bool {
        interacciones[oferta.id]?.guardada ?? false
    }

    func estadoPostulacion(de oferta: Oferta) -> String? {
        interacciones[oferta.id]?.estadoPostulacion
    }

    // MARK: - Usuario

    func fijarUsuario(_ id: Int?) {
        usuarioId = id
        if id == nil { limpiarFiltros() }
        recargar()
    }

    // MARK: - Filtros

    func limpiarFiltros() {
        consulta = ""
        ubicacion = nil
        modalidad = nil
        tipo = nil
        soloRequisitoGrado = false
    }

    var hayFiltrosActivos: Bool {
        !consulta.trimmed.isEmpty || ubicacion != nil || modalidad != nil
            || tipo != nil || soloRequisitoGrado
    }

    // MARK: - Acciones del usuario

    func alternarGuardada(_ oferta: Oferta) {
        guard let item = interaccion(para: oferta.id) else { return }
        item.guardada.toggle()
        guardarCambios()
        recargar()
    }

    func postular(_ oferta: Oferta) {
        guard let item = interaccion(para: oferta.id) else { return }
        item.estadoPostulacion = "Postulación enviada"
        guardarCambios()
        recargar()
    }

    // MARK: - Red: ofertas desde la API

    /// Pide las ofertas a la API y las guarda en la base de datos local.
    func sincronizarDesdeAPI() async {
        guard !cargandoAPI else { return }
        cargandoAPI = true
        mensajeAPI = nil
        defer { cargandoAPI = false }

        do {
            let trabajos = try await api.obtenerOfertas(limite: 20)
            var nuevas = 0

            for trabajo in trabajos {
                let idLocal = Oferta.idBaseAPI + trabajo.id
                if ofertas.contains(where: { $0.id == idLocal }) { continue }
                context.insert(trabajo.aOferta())
                nuevas += 1
            }

            guardarCambios()
            recargar()
            mensajeAPI = "Se recibieron \(trabajos.count) ofertas de Remotive (\(nuevas) nuevas)."
        } catch {
            mensajeAPI = error.localizedDescription
        }
    }

    /// Primera carga automática: solo si todavía no hay ofertas de la API guardadas.
    func sincronizarSiHaceFalta() async {
        guard !intentoAutomatico, cantidadEnLinea == 0 else { return }
        intentoAutomatico = true
        await sincronizarDesdeAPI()
    }

    // MARK: - Privado (persistencia)

    private func sembrarSiVacia() {
        let cantidad = (try? context.fetchCount(FetchDescriptor<Oferta>())) ?? 0
        guard cantidad == 0 else { return }
        for oferta in DatosIniciales.ofertas() {
            context.insert(oferta)
        }
        guardarCambios()
    }

    private func recargar() {
        let descriptor = FetchDescriptor<Oferta>(sortBy: [SortDescriptor(\.id)])
        ofertas = (try? context.fetch(descriptor)) ?? []

        guard let usuarioId else {
            interacciones = [:]
            return
        }
        let porUsuario = FetchDescriptor<OfertaUsuario>(
            predicate: #Predicate { $0.usuarioId == usuarioId }
        )
        let lista = (try? context.fetch(porUsuario)) ?? []
        interacciones = Dictionary(
            lista.map { ($0.ofertaId, $0) },
            uniquingKeysWith: { primero, _ in primero }
        )
    }

    /// Devuelve lo que el usuario actual ha hecho con la oferta; si no hay nada, lo crea.
    private func interaccion(para ofertaId: Int) -> OfertaUsuario? {
        guard let usuarioId else { return nil }
        if let existente = interacciones[ofertaId] { return existente }
        let nueva = OfertaUsuario(usuarioId: usuarioId, ofertaId: ofertaId)
        context.insert(nueva)
        interacciones[ofertaId] = nueva
        return nueva
    }

    private func guardarCambios() {
        try? context.save()
    }
}
