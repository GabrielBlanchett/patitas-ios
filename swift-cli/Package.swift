// swift-tools-version: 6.0
// Paquete de acompañamiento de los capítulos de lenguaje.
//
// La lógica vive en la biblioteca `Refugio` para que se pueda probar; el
// ejecutable `swift-cli` es solo la cáscara que la imprime. Se separan porque
// un objetivo ejecutable con código de nivel superior en `main.swift` no se
// deja importar con `@testable` de forma limpia.

import PackageDescription

let package = Package(
    name: "swift-cli",
    targets: [
        .target(name: "Refugio"),
        .executableTarget(name: "swift-cli", dependencies: ["Refugio"]),
        .testTarget(name: "RefugioTests", dependencies: ["Refugio"]),
    ],
    swiftLanguageModes: [.v6]
)
