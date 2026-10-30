import SwiftUI
import UIKit

// Paleta tomada del tema Material 3 de la versión Android (Color.kt),
// con su variante clara y oscura.
extension Color {

    static let unipassPrimary = Color(claro: 0x4C5C92, oscuro: 0xB5C4FF)
    static let unipassPrimaryContainer = Color(claro: 0xDCE1FF, oscuro: 0x344479)
    static let unipassTertiary = Color(claro: 0x006B5F, oscuro: 0x82D5C7)
    static let unipassFondo = Color(claro: 0xFAF8FF, oscuro: 0x121318)
    static let unipassTarjeta = Color(claro: 0xEEEDF4, oscuro: 0x1E1F25)
    static let unipassTextoSecundario = Color(claro: 0x45464F, oscuro: 0xC6C6D0)
    static let unipassError = Color(claro: 0xBA1A1A, oscuro: 0xFFB4AB)

    /// Color que cambia solo entre modo claro y oscuro.
    init(claro: UInt32, oscuro: UInt32) {
        self.init(uiColor: UIColor { rasgos in
            let valor = rasgos.userInterfaceStyle == .dark ? oscuro : claro
            return UIColor(
                red: CGFloat((valor >> 16) & 0xFF) / 255,
                green: CGFloat((valor >> 8) & 0xFF) / 255,
                blue: CGFloat(valor & 0xFF) / 255,
                alpha: 1
            )
        })
    }
}

// MARK: - Estilos reutilizables

/// Tarjeta con el fondo y las esquinas de UniPass.
struct TarjetaUniPass: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.unipassTarjeta)
            )
    }
}

extension View {
    func tarjetaUniPass() -> some View {
        modifier(TarjetaUniPass())
    }
}

/// Etiqueta redondeada (equivale a los AssistChip de Compose).
struct EtiquetaChip: View {
    let texto: String
    var resaltada: Bool = false

    var body: some View {
        Text(texto)
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(resaltada ? Color.unipassPrimaryContainer : Color.unipassTarjeta)
            )
            .overlay(
                Capsule().stroke(Color.unipassPrimary.opacity(0.25), lineWidth: 1)
            )
    }
}
