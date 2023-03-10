// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WonderAppDomain",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WonderAppDomain",
            targets: ["WonderAppDomain"]
        ),
    ],
    dependencies: [
        .package(path: "../WonderAppExtensions"),
        .package(url: "https://github.com/valentinradu/swift-any-codable.git", from: .init(0, 0, 1))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WonderAppDomain",
            dependencies: [
                .byName(name: "WonderAppExtensions"),
                .product(name: "AnyCodable", package: "swift-any-codable")
            ]
        ),
        .testTarget(
            name: "WonderAppDomainTests",
            dependencies: ["WonderAppDomain"]
        ),
    ]
)
