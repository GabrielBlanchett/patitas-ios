// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "verificaciones-e4",
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "verificaciones-e4",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
