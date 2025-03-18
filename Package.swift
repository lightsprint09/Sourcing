// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Sourcing",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
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
