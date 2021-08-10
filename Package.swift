// swift-tools-version:5.3

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
            path: "Source"),
        .testTarget(
            name: "Tests",
            dependencies: ["Sourcing"],
            path: "Tests"),
    ]
)
