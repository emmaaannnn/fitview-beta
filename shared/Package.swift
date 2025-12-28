// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedModels",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "SharedModels", targets: ["SharedModels"]),
    ],
    targets: [
        .target(name: "SharedModels", dependencies: [])
    ]
)
