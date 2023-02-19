// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WonderAppDesignSystem",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WonderAppDesignSystem",
            targets: ["WonderAppDesignSystem"]
        ),
    ],
    dependencies: [
        .package(path: "../WonderAppExtensions"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: "3.3.2"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WonderAppDesignSystem",
            dependencies: [
                .byName(name: "WonderAppExtensions"),
                .product(name: "SFSafeSymbols", package: "sfsafesymbols")
            ],
            resources: [
                .process("Support")
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin")
            ]
        ),
        .plugin(name: "SwiftGenPlugin",
                capability: .buildTool(),
                dependencies: [
                    .target(name: "swiftgen")
                ]),
        .testTarget(
            name: "WonderAppDesignSystemTests",
            dependencies: ["WonderAppDesignSystem"]
        ),
        .binaryTarget(
            name: "swiftgen",
            url: "https://github.com/SwiftGen/SwiftGen/releases/download/6.6.2/swiftgen-6.6.2.artifactbundle.zip",
            checksum: "7586363e24edcf18c2da3ef90f379e9559c1453f48ef5e8fbc0b818fbbc3a045"
        )
    ]
)
