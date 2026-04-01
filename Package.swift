// swift-tools-version: 6.3

import PackageDescription

// ASCII Serializer Primitives - Tier 18
//
// Subject-first ASCII serialization types: ASCII.Decimal.Serializer, ASCII.Hexadecimal.Serializer.
// Bridges ascii-primitives (Tier 0) with serializer-primitives.

let package = Package(
    name: "swift-ascii-serializer-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "ASCII Decimal Serializer Primitives",
            targets: ["ASCII Decimal Serializer Primitives"]
        ),
        .library(
            name: "ASCII Hexadecimal Serializer Primitives",
            targets: ["ASCII Hexadecimal Serializer Primitives"]
        ),
        .library(
            name: "Serializable Integer Primitives",
            targets: ["Serializable Integer Primitives"]
        ),
        .library(
            name: "ASCII Serializer Primitives",
            targets: ["ASCII Serializer Primitives"]
        ),
        .library(
            name: "ASCII Serializer Primitives Test Support",
            targets: ["ASCII Serializer Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-ascii-primitives"),
        .package(path: "../swift-serializer-primitives"),
    ],
    targets: [
        // MARK: - Core

        .target(
            name: "ASCII Serializer Primitives Core",
            dependencies: [
                .product(name: "Serializer Primitives Core", package: "swift-serializer-primitives"),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
            ]
        ),

        // MARK: - Subject Domains

        .target(
            name: "ASCII Decimal Serializer Primitives",
            dependencies: [
                "ASCII Serializer Primitives Core",
            ]
        ),
        .target(
            name: "ASCII Hexadecimal Serializer Primitives",
            dependencies: [
                "ASCII Serializer Primitives Core",
            ]
        ),

        // MARK: - Conformances

        .target(
            name: "Serializable Integer Primitives",
            dependencies: [
                "ASCII Decimal Serializer Primitives",
            ]
        ),

        // MARK: - Umbrella

        .target(
            name: "ASCII Serializer Primitives",
            dependencies: [
                "ASCII Decimal Serializer Primitives",
                "ASCII Hexadecimal Serializer Primitives",
                "Serializable Integer Primitives",
            ]
        ),

        // MARK: - Tests

        .testTarget(
            name: "ASCII Decimal Serializer Primitives Tests",
            dependencies: [
                "ASCII Decimal Serializer Primitives",
            ]
        ),
        .testTarget(
            name: "ASCII Hexadecimal Serializer Primitives Tests",
            dependencies: [
                "ASCII Hexadecimal Serializer Primitives",
            ]
        ),
        .testTarget(
            name: "Serializable Integer Primitives Tests",
            dependencies: [
                "Serializable Integer Primitives",
            ]
        ),

        // MARK: - Test Support
        .target(
            name: "ASCII Serializer Primitives Test Support",
            dependencies: [
                "ASCII Serializer Primitives",
            ],
            path: "Tests/Support"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
