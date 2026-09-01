// swift-tools-version: 6.0
// El dominio de Patitas Seguras, en su propio paquete.
//
// Es el módulo más interno de la app: no importa SwiftUI, ni UIKit, ni
// URLSession, ni ninguna base de datos. Solo Foundation. Esa restricción es el
// punto entero del capítulo 80: al vivir en un paquete aparte, **el compilador
// impide** romperla, y la regla de Clean deja de depender de que nadie la
// rompa por descuido.
//
// Lo usan el ejecutable de consola y la app de iOS. Antes estaba duplicado en
// los dos, a propósito, para poder llegar aquí con el problema ya sentido.

import PackageDescription

let package = Package(
    name: "Dominio",
    platforms: [.macOS(.v14), .iOS(.v18)],
    products: [
        .library(name: "Dominio", targets: ["Dominio"]),
    ],
    targets: [
        .target(name: "Dominio"),
        .testTarget(name: "DominioTests", dependencies: ["Dominio"]),
    ],
    swiftLanguageModes: [.v6]
)
