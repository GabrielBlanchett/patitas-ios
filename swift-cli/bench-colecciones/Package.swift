// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "bench-colecciones",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "bench-colecciones",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
