// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIBaseSPM",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "APIBaseSPM",
            targets: ["APIBaseSPM"]),
    ],
    targets: [
        .target(
            name: "APIBaseSPM"),
        .testTarget(
            name: "APIBaseSPMTests",
            dependencies: ["APIBaseSPM"]),
    ]
)
