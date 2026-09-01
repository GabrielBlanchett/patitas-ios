// swift-tools-version: 6.0
// Backend del libro. Corre en Linux dentro de un contenedor, porque SwiftNIO
// —la base de Vapor— solo soporta macOS y Linux, nunca Windows.

import PackageDescription

let package = Package(
    name: "patitas-api",
    platforms: [.macOS(.v13)],
    dependencies: [
        // 4.122.1 es la ultima estable (25 ago 2026). La 5.0 esta en alfa.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.122.1"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [.product(name: "Vapor", package: "vapor")]
        ),
    ],
    // El codigo propio del libro va en modo Swift 6; este servidor se queda en
    // 5 a proposito, porque Vapor 4 todavia no esta limpio bajo concurrencia
    // estricta. Es una restriccion real de dependencia, no una preferencia.
    swiftLanguageModes: [.v5]
)
