// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SyntaxHighlight",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SyntaxHighlight",
            targets: ["SyntaxHighlight"]),
    ],
    dependencies: [
        .package(url: "https://github.com/maoyama/TMSyntax", .upToNextMajor(from: "0.1.0")),
        .package(url: "https://github.com/yannickl/DynamicColor", .upToNextMajor(from: "5.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SyntaxHighlight",
            dependencies: ["TMSyntax", "DynamicColor"]),
        .testTarget(
            name: "SyntaxHighlightTests",
            dependencies: ["SyntaxHighlight"],
            exclude: ["Dependencies"],
            resources: [.process("Resources")]
        )
    ]
)
