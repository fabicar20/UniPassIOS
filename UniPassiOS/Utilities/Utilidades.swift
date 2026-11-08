import Foundation

extension String {
    /// Quita espacios y saltos de línea al inicio y al final.
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }

    /// Validación sencilla de correo (equivale a `Patterns.EMAIL_ADDRESS` de Android).
    var esCorreoValido: Bool {
        let patron = "^[A-Za-z0-9._%+\\-]+@[A-Za-z0-9.\\-]+\\.[A-Za-z]{2,}$"
        return range(of: patron, options: .regularExpression) != nil
    }
}


extension Date {
    /// Texto relativo en español: "hace 3 días", "hace 2 horas"...
    var haceCuanto: String {
        let ahora = Date()
        // Si el reloj del servidor va adelantado, no mostramos fechas "del futuro".
        let fecha = Swift.min(self, ahora)
        if ahora.timeIntervalSince(fecha) < 3600 {
            return "hace menos de una hora"
        }
        let formateador = RelativeDateTimeFormatter()
        formateador.locale = Locale(identifier: "es")
        formateador.unitsStyle = .full
        return formateador.localizedString(for: fecha, relativeTo: ahora)
    }
}

/// Lee la fecha de publicación que envía la API (texto ISO 8601, normalmente sin zona horaria).
enum FechaAPI {

    private static let formatos = [
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd'T'HH:mm:ss.SSS",
        "yyyy-MM-dd'T'HH:mm:ssXXXXX",
        "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    ]

    static func convertir(_ texto: String?) -> Date? {
        guard let texto = texto?.trimmed, !texto.isEmpty else { return nil }
        let lector = DateFormatter()
        lector.locale = Locale(identifier: "en_US_POSIX")
        lector.timeZone = TimeZone(identifier: "UTC")
        for formato in formatos {
            lector.dateFormat = formato
            if let fecha = lector.date(from: texto) { return fecha }
        }
        return nil
    }
}


/// Convierte el HTML que devuelve la API en texto plano legible.
enum TextoLimpio {

    static func desdeHTML(_ html: String, maximo: Int = 1500) -> String {
        var texto = html

        // Saltos de línea para etiquetas de bloque
        texto = texto.replacingOccurrences(
            of: "<br\\s*/?>|</p>|</li>|</h[1-6]>|</div>",
            with: "\n",
            options: [.regularExpression, .caseInsensitive]
        )
        texto = texto.replacingOccurrences(
            of: "<li[^>]*>",
            with: "• ",
            options: [.regularExpression, .caseInsensitive]
        )
        // Quitar el resto de etiquetas
        texto = texto.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)

        // Entidades HTML más comunes
        let entidades: [String: String] = [
            "&nbsp;": " ", "&amp;": "&", "&lt;": "<", "&gt;": ">",
            "&quot;": "\"", "&#39;": "'", "&apos;": "'",
            "&rsquo;": "'", "&lsquo;": "'", "&ldquo;": "\"", "&rdquo;": "\"",
            "&ndash;": "-", "&mdash;": "-", "&hellip;": "..."
        ]
        for (entidad, reemplazo) in entidades {
            texto = texto.replacingOccurrences(of: entidad, with: reemplazo)
        }

        // Limpiar espacios y líneas en blanco repetidas
        texto = texto.replacingOccurrences(of: "[ \\t]+", with: " ", options: .regularExpression)
        texto = texto.replacingOccurrences(of: "\\n\\s*\\n(\\s*\\n)+", with: "\n\n", options: .regularExpression)
        texto = texto.trimmed

        if texto.count > maximo {
            texto = String(texto.prefix(maximo)).trimmed + "…"
        }
        return texto
    }
}
