# UniPass iOS (SwiftUI)

Versión iOS de UniPass, migrada desde Kotlin / Jetpack Compose.
Proyecto del Taller 2 – Microproyecto SwiftUI (Electiva Desarrollo de Aplicaciones Móviles, Universidad del Cauca).

## Cómo abrirlo

1. Necesitas un Mac con **Xcode 15 o superior** (la app usa SwiftData, que requiere iOS 17).
2. Abre `iOS/UniPassiOS.xcodeproj` con doble clic.
3. Arriba elige un simulador (por ejemplo *iPhone 15*) y pulsa ▶ (`Cmd + R`).
4. Si quieres correrlo en tu iPhone: selecciona el proyecto → pestaña *Signing & Capabilities* → elige tu *Team*.

## Arquitectura (MVVM)

| Capa | Carpeta | Qué hay |
|---|---|---|
| Vista | `Views/`, `Components/` | Pantallas SwiftUI y componentes reutilizables |
| ViewModel | `ViewModels/` | `AuthViewModel`, `OfertasViewModel`, `PerfilViewModel` (`@Observable`) |
| Modelo | `Models/` | `Oferta`, `Usuario`, `PerfilUsuario`, `OfertaUsuario` (`@Model` de SwiftData) |
| Red | `Services/` | `OfertaAPIService` (URLSession + Codable) |
| Persistencia | `Persistence/` | `UniPassModelContainer` (SwiftData) |

## Equivalencias con la versión Android

| Android | iOS |
|---|---|
| Jetpack Compose | SwiftUI |
| NavHost / NavController | `NavigationStack` + `TabView` |
| ViewModel + StateFlow | `@Observable` + `@Environment` |
| Room (DAO, Entity) | SwiftData (`@Model`, `FetchDescriptor`) |
| `OutlinedTextField` | `TextField` / `SecureField` |
| `LazyColumn` | `ScrollView` + `LazyVStack` |
| `NavigationBar` | `TabView` |

## API web

Las ofertas en línea vienen de la API pública de **Remotive**:
`https://remotive.com/api/remote-jobs?category=software-dev&limit=20`

- No necesita llave.
- La app la consulta automáticamente la primera vez que se abre Inicio y cuando se pulsa *Actualizar*.
- Remotive pide no consultarla con demasiada frecuencia, por eso no se llama en cada pantalla.
- Cada oferta enlaza a su publicación original.

Las 8 ofertas "locales" son datos de ejemplo que vienen de la versión Android.

## Trabajo en equipo (lo que pide el taller)

- Repositorio **público**.
- Cada integrante trabaja en **su propia rama** y hace commits propios.
