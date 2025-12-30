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
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.0"),
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
        // New Target: The Scraper "Hands"
        .executableTarget(
            name: "Scraper",
            dependencies: ["Models", "Logic", "SwiftSoup"],
            path: "Sources/Scraper"
        ),
        .testTarget(
            name: "ModelsTests",
            dependencies: ["Models", "Logic"],
            path: "Tests/ModelTests"
        )
    ]
)
