// swift-tools-version:6.4

import PackageDescription

let package = Package(
    name: "Sourcing",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
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
            path: "Source",
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]),
        .testTarget(
            name: "SourcingTests",
            dependencies: ["Sourcing"],
            path: "Tests"),
    ]
)
