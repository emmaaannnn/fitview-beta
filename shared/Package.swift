// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "shared",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Logic", targets: ["Logic"]),
    ],
    targets: [
        .target(
            name: "Models",
            path: "Sources/Models"
        ),
        .target(
            name: "Logic",
            dependencies: ["Models"],
            path: "Sources/Logic"
        ),
        .testTarget(
            name: "ModelsTests",
            dependencies: ["Models", "Logic"],
            path: "Tests/ModelTests"
        )
    ]
)
