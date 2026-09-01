# Patitas iOS

Código de acompañamiento de una guía de Swift e iOS: una app de refugio de mascotas
(catálogo, adopciones y reportes) construida de punta a punta, con su backend y su
integración continua.

Todo lo que aparece en la guía se compila y se ejecuta de verdad. Las salidas de consola
y las capturas de pantalla no están escritas a mano: salen de este repositorio.

## Qué hay aquí

| Carpeta | Qué es | Dónde se ejecuta |
|---|---|---|
| `swift-cli/` | Paquete SwiftPM con el modelo del dominio y sus pruebas | Windows, Linux o macOS |
| `PatitasiOS/` | La app de iOS en SwiftUI | Simulador de iOS |
| `patitas-api/` | Backend en Vapor con PostgreSQL | Docker |

## Cómo se ejecuta

### El paquete de consola

```sh
cd swift-cli
swift test
swift run swift-cli
```

En **Windows** hace falta preparar el entorno primero, porque Swift necesita el enlazador
de MSVC y saber dónde está su biblioteca estándar. Para eso está `entorno.cmd`:

```bat
entorno.cmd swift test
entorno.cmd swift run swift-cli
```

Sin argumentos abre una consola ya preparada. Requiere Visual Studio 2022 con el toolchain
de C++ y el toolchain de Swift (`winget install --id Swift.Toolchain -e`).

### La app de iOS

El repositorio **no guarda el `.xcodeproj`**. Se genera desde `project.yml`, que es un
archivo legible y que no da conflictos de merge:

```sh
brew install xcodegen
cd PatitasiOS
xcodegen generate
open PatitasiOS.xcodeproj
```

### El backend

```sh
cd patitas-api
docker compose up --build
curl http://localhost:8080/mascotas
```

## Integración continua

Cada empujón compila la app, corre las pruebas en el simulador y captura la pantalla en un
runner de macOS. Ahí es donde se verifica todo lo que en Windows no se puede compilar.

## Licencia

MIT. Ver [LICENSE](LICENSE).
