// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "swift-infra-package",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.58.5"),
        .package(url: "https://github.com/realm/SwiftLint", exact: "0.62.1")
    ],
    targets: [
        .target(name: "SwiftInfraPackage", path: "Sources")
    ]
)
