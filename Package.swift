// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Sourcing",
    platforms: [
        .iOS(.v12),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Sourcing",
            targets: ["Sourcing"]),
    ],
    targets: [
        .target(
            name: "Sourcing",
            path: "Source"),
        .testTarget(
            name: "SourcingTests",
            dependencies: ["Sourcing"],
            path: "Tests"),
    ]
)
