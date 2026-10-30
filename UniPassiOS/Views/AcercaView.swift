import SwiftUI

/// Pantalla de descripción de la aplicación y créditos.
struct AcercaView: View {

    private let integrantes = [
        "Fabiana Zuleima Cárdenas",
        "Karol Dayana Ocoro Natez",
        "Leiner Santiago Claros"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {

                TarjetaTexto(titulo: "¿Qué es UniPass?") {
                    Text("UniPass es una aplicación para estudiantes universitarios que necesitan encontrar una pasantía o práctica profesional (requisito de grado en muchas universidades) y todavía no tienen experiencia laboral. Reúne las ofertas en un solo lugar, indica cuáles sirven como requisito de grado y permite buscar, guardar y postularse en pocos pasos.")
                }

                TarjetaTexto(titulo: "Qué puedes hacer") {
                    Text("• Crear una cuenta e iniciar sesión")
                    Text("• Buscar ofertas y filtrarlas por ubicación, modalidad y tipo")
                    Text("• Ver el detalle de cada oferta y sus requisitos")
                    Text("• Guardar ofertas para verlas después")
                    Text("• Postularte y seguir el estado de tus postulaciones")
                    Text("• Descargar ofertas reales desde Internet")
                }

                TarjetaTexto(titulo: "Tecnologías") {
                    Text("• Swift y SwiftUI")
                    Text("• NavigationStack y TabView")
                    Text("• @Observable (MVVM) y @Environment")
                    Text("• SwiftData (base de datos local)")
                    Text("• URLSession y Codable (red)")
                }

                TarjetaTexto(titulo: "Fuente de datos en línea") {
                    Text("Las ofertas en línea se obtienen de la API pública de Remotive (remotive.com). Cada oferta enlaza a su publicación original.")
                }

                TarjetaTexto(titulo: "Créditos") {
                    ForEach(integrantes, id: \.self) { nombre in
                        Text(nombre)
                    }
                    Text("Electiva Desarrollo de Aplicaciones Móviles")
                        .font(.subheadline)
                        .padding(.top, 8)
                    Text("Departamento de Telemática — Universidad del Cauca")
                        .font(.subheadline)
                    Text("Versión 1.0 (SwiftUI)")
                        .font(.footnote)
                        .foregroundStyle(Color.unipassTextoSecundario)
                        .padding(.top, 4)
                }
            }
            .padding(16)
        }
        .background(Color.unipassFondo)
        .navigationTitle("Acerca de UniPass")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TarjetaTexto<Contenido: View>: View {
    let titulo: String
    @ViewBuilder let contenido: () -> Contenido

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.title3.bold())
                .padding(.bottom, 2)
            contenido()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .tarjetaUniPass()
    }
}
