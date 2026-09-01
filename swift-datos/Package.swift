// swift-tools-version: 6.0
// Paquete de acompañamiento de los capítulos de datos locales (44).
//
// No se puede compilar en Windows: GRDB contiene un enlace simbólico dentro de
// sus pruebas y el checkout falla con "unable to create symlink ... Permission
// denied" salvo que Windows tenga activado el modo desarrollador. Por eso este
// paquete se verifica en el CI de macOS y no en la máquina donde se escribe el
// libro. Está declarado así en el anexo A5.

import PackageDescription

let package = Package(
    name: "swift-datos",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "7.0.0"),
    ],
    targets: [
        .target(
            name: "Datos",
            dependencies: [.product(name: "GRDB", package: "GRDB.swift")]
        ),
        .testTarget(name: "DatosTests", dependencies: ["Datos"]),
    ],
    swiftLanguageModes: [.v6]
)
