import Foundation

/// Datos de ejemplo (los mismos 8 de la versión Android).
/// Se insertan solo la primera vez, cuando la base de datos está vacía.
/// Son ofertas LOCALES de ejemplo; las ofertas reales de Internet llegan por la API (ver `OfertaAPIService`).
enum DatosIniciales {

    static func ofertas() -> [Oferta] {
        [
            Oferta(
                id: 1,
                titulo: "Practicante de Desarrollo de Software",
                empresa: "Empresa Tech",
                ubicacion: "Popayán, Cauca",
                modalidad: "Presencial",
                tipo: "Pasantía",
                remuneracion: "$1.200.000",
                duracion: "6 meses",
                horario: "Tiempo completo",
                responsabilidades: "Desarrollar funcionalidades\nProbar y depurar código\nApoyar al equipo",
                requisitos: "Estudiante universitario\nConocimientos de Kotlin o Java\nGit básico"
            ),
            Oferta(
                id: 2,
                titulo: "Practicante de Redes y Telecomunicaciones",
                empresa: "Telecomunicaciones del Cauca",
                ubicacion: "Popayán, Cauca",
                modalidad: "Presencial",
                tipo: "Pasantía",
                remuneracion: "$1.100.000",
                duracion: "6 meses",
                horario: "Medio tiempo",
                responsabilidades: "Configurar equipos de red\nMonitorear la red\nSoporte técnico",
                requisitos: "Estudiante de Telemática o afines\nConocimientos de redes"
            ),
            Oferta(
                id: 3,
                titulo: "Analista de Datos Junior",
                empresa: "Data Solutions",
                ubicacion: "Remoto",
                modalidad: "Remoto",
                tipo: "Pasantía",
                remuneracion: "$1.300.000",
                duracion: "6 meses",
                horario: "Medio tiempo",
                responsabilidades: "Analizar datos\nCrear reportes\nApoyar al equipo",
                requisitos: "Estudiante universitario\nConocimientos de Excel\nManejo básico de Python"
            ),
            Oferta(
                id: 4,
                titulo: "Desarrollador Android Junior",
                empresa: "App Studio",
                ubicacion: "Remoto",
                modalidad: "Remoto",
                tipo: "Pasantía",
                remuneracion: "$1.400.000",
                duracion: "4 meses",
                horario: "Medio tiempo",
                responsabilidades: "Construir pantallas con Jetpack Compose\nConsumir servicios web\nEscribir pruebas",
                requisitos: "Kotlin básico\nConocimientos de Compose"
            ),
            Oferta(
                id: 5,
                titulo: "Auxiliar de Soporte Técnico TI",
                empresa: "Cauca Soluciones",
                ubicacion: "Popayán, Cauca",
                modalidad: "Híbrido",
                tipo: "Empleo",
                remuneracion: "$1.500.000",
                duracion: "Indefinido",
                horario: "Tiempo completo",
                responsabilidades: "Atender solicitudes de soporte\nMantener equipos de cómputo",
                requisitos: "Tecnólogo o estudiante de últimos semestres\nBuena atención al cliente",
                validaRequisitoGrado: false
            ),
            Oferta(
                id: 6,
                titulo: "Practicante de Diseño UX/UI",
                empresa: "Estudio Creativo Cauca",
                ubicacion: "Remoto",
                modalidad: "Remoto",
                tipo: "Pasantía",
                remuneracion: "$1.000.000",
                duracion: "4 meses",
                horario: "Medio tiempo",
                responsabilidades: "Diseñar prototipos de pantallas\nApoyar en pruebas de usabilidad\nDocumentar la guía de estilos",
                requisitos: "Estudiante universitario\nConocimientos de Figma\nPortafolio básico"
            ),
            Oferta(
                id: 7,
                titulo: "Desarrollador Web Junior",
                empresa: "Soluciones Digitales SAS",
                ubicacion: "Remoto",
                modalidad: "Remoto",
                tipo: "Empleo",
                remuneracion: "$2.200.000",
                duracion: "Indefinido",
                horario: "Tiempo completo",
                responsabilidades: "Mantener sitios web de clientes\nCorregir errores reportados\nParticipar en reuniones del equipo",
                requisitos: "HTML, CSS y JavaScript\nGit básico\nBuena comunicación"
            ),
            Oferta(
                id: 8,
                titulo: "Practicante de Ingeniería Electrónica",
                empresa: "Industrias del Valle",
                ubicacion: "Popayán, Cauca",
                modalidad: "Híbrido",
                tipo: "Pasantía",
                remuneracion: "$1.300.000",
                duracion: "6 meses",
                horario: "Tiempo completo",
                responsabilidades: "Apoyar el mantenimiento de equipos\nElaborar informes técnicos",
                requisitos: "Estudiante de últimos semestres\nConocimientos de circuitos"
            )
        ]
    }
}
