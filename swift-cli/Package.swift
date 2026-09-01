// swift-tools-version: 6.0
// Paquete de acompañamiento de los capítulos de lenguaje.
//
// Desde el capítulo 80, el tipo `Mascota` ya no vive aquí: está en el paquete
// `Dominio`, que este ejecutable y la app de iOS comparten. Antes estaba
// escrito dos veces, y esa duplicación era deliberada para poder resolverla
// con el problema ya sentido.
//
// La dependencia se declara por ruta relativa. Es un paquete local: no hay
// repositorio que publicar ni versión que fijar, y un cambio en el dominio
// rompe la compilación de los dos consumidores al instante.

import PackageDescription

let package = Package(
    name: "swift-cli",
    dependencies: [
        .package(path: "../Dominio"),
    ],
    targets: [
        .executableTarget(
            name: "swift-cli",
            dependencies: [.product(name: "Dominio", package: "Dominio")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
