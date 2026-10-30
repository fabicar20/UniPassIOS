import SwiftUI

/// Mensaje que se muestra cuando una lista está vacía.
struct EstadoVacioView: View {
    let icono: String
    let mensaje: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icono)
                .font(.largeTitle)
                .foregroundStyle(Color.unipassPrimary.opacity(0.6))
            Text(mensaje)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.unipassTextoSecundario)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
}
