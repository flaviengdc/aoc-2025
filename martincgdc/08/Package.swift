// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AoC8",
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.62.2")
    ],
    targets: [
        .executableTarget(name: "AoC8"),

        .testTarget(name: "AoC8Tests", dependencies: ["AoC8"]),
    ]
)
