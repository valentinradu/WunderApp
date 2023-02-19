// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WonderAppOnboarding",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WonderAppOnboarding",
            targets: ["WonderAppOnboarding"]
        ),
    ],
    dependencies: [
        .package(path: "../WonderAppExtensions"),
        .package(path: "../WonderAppDesignSystem"),
        .package(path: "../WonderAppService"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: "3.3.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WonderAppOnboarding",
            dependencies: [
                .byName(name: "WonderAppExtensions"),
                .byName(name: "WonderAppDesignSystem"),
                .byName(name: "WonderAppService"),
                .product(name: "SFSafeSymbols", package: "sfsafesymbols")
            ]
        ),
        .testTarget(
            name: "WonderAppOnboardingTests",
            dependencies: ["WonderAppOnboarding"]
        ),
    ]
)
