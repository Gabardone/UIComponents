// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [
        // We require Combine so that limits what we support.
        .iOS(.v14),
        .macCatalyst(.v14),
        .tvOS(.v14)
    ],
    products: [
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Gabardone/AutoLayoutHelpers", .upToNextMajor(from: "1.1.2")),
        .package(url: "https://github.com/Gabardone/SwiftUX", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "UIComponents",
            dependencies: ["AutoLayoutHelpers", "SwiftUX"]
        ),
        .testTarget(
            name: "UIComponentsTests",
            dependencies: ["UIComponents"]
        )
    ]
)
