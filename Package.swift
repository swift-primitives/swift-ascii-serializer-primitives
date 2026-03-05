// swift-tools-version: 6.2

import PackageDescription

// ASCII Serializer Primitives - Tier 18
//
// Subject-first ASCII serialization types: ASCII.Decimal.Serializer.
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
            name: "Serializable Integer Primitives",
            targets: ["Serializable Integer Primitives"]
        ),
        .library(
            name: "ASCII Serializer Primitives",
            targets: ["ASCII Serializer Primitives"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-ascii-primitives"),
        .package(path: "../swift-serializer-primitives"),
    ],
    targets: [
        // MARK: - Subject Domains

        .target(
            name: "ASCII Decimal Serializer Primitives",
            dependencies: [
                .product(name: "Serializer Primitives Core", package: "swift-serializer-primitives"),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
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
        .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
