## API web

Las ofertas en línea vienen de la API pública de **Remotive**:
`https://remotive.com/api/remote-jobs?category=software-dev&limit=20`

## Descripción

UniPass es una app para iOS (SwiftUI) que ayuda a estudiantes a buscar pasantías y prácticas profesionales. Permite registrarse, iniciar sesión, buscar y filtrar ofertas, guardarlas y postularse.

## Requisitos

- Xcode con soporte para iOS 17 o superior
- Swift 5 y SwiftUI
- SwiftData para guardar usuarios y ofertas en el dispositivo

## Cómo ejecutarla

1. Clonar el repositorio.
2. Abrir `UniPassiOS.xcodeproj` en Xcode.
3. Elegir un simulador de iPhone con iOS 17 o superior.
4. Presionar **Run** (Cmd + R).

## Estructura del proyecto

- `Models`: modelos de datos (usuario, oferta, perfil).
- `Views`: pantallas de la app.
- `ViewModels`: lógica de cada pantalla (autenticación, ofertas, perfil).
- `Services`: acceso a la API de ofertas.
- `Persistence`: configuración de SwiftData.
- `Components`: vistas reutilizables.
- `Theme`: colores y estilos.
- `Utilities`: funciones de ayuda.
