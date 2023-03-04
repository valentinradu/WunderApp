// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WonderAppExtensions",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WonderAppExtensions",
            targets: ["WonderAppExtensions"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms.git", from: .init(0, 1, 0))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WonderAppExtensions",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
            ]
        ),
        .testTarget(
            name: "WonderAppExtensionsTests",
            dependencies: ["WonderAppExtensions"]
        ),
    ]
)
