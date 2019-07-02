// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Sourcing",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "Sourcing",
            targets: ["Sourcing"]),
    ],
    targets: [
        .target(
            name: "Sourcing",
            dependencies: [],
            path: "Source"),
        .testTarget(
            name: "SourcingTests",
            dependencies: ["Sourcing"]),
    ]
)
