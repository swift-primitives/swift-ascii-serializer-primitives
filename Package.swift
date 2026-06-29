// swift-tools-version: 6.3.1

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
            name: "Serializable ASCII Primitives",
            targets: ["Serializable ASCII Primitives"]
        ),
        .library(
            name: "ASCII Decimal Serializer Primitives",
            targets: ["ASCII Decimal Serializer Primitives"]
        ),
        .library(
            name: "ASCII Hexadecimal Serializer Primitives",
            targets: ["ASCII Hexadecimal Serializer Primitives"]
        ),
        .library(
            name: "ASCII Binary Serializer Primitives",
            targets: ["ASCII Binary Serializer Primitives"]
        ),
        .library(
            name: "ASCII Octal Serializer Primitives",
            targets: ["ASCII Octal Serializer Primitives"]
        ),
        .library(
            name: "Serializable Integer Primitives",
            targets: ["Serializable Integer Primitives"]
        ),
        .library(
            name: "Binary ASCII Serializable Primitives",
            targets: ["Binary ASCII Serializable Primitives"]
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
        .package(url: "https://github.com/swift-primitives/swift-ascii-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-serializer-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-binary-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-binary-serializer-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-byte-primitives.git", branch: "main"),
    ],
    targets: [
        // MARK: - Serializable extension (ASCII-codes accessor)

        .target(
            name: "Serializable ASCII Primitives",
            dependencies: [
                .product(name: "Serializer Primitives", package: "swift-serializer-primitives"),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
                .product(name: "Binary Serializable Primitives", package: "swift-binary-serializer-primitives"),
            ]
        ),

        // MARK: - Subject Domains

        .target(
            name: "ASCII Decimal Serializer Primitives",
            dependencies: [
                .product(name: "Serializer Primitives", package: "swift-serializer-primitives"),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
            ]
        ),
        .target(
            name: "ASCII Hexadecimal Serializer Primitives",
            dependencies: [
                .product(name: "Serializer Primitives", package: "swift-serializer-primitives"),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
            ]
        ),
        .target(
            name: "ASCII Binary Serializer Primitives",
            dependencies: [
                .product(name: "Serializer Primitives", package: "swift-serializer-primitives"),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
            ]
        ),
        .target(
            name: "ASCII Octal Serializer Primitives",
            dependencies: [
                .product(name: "Serializer Primitives", package: "swift-serializer-primitives"),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
            ]
        ),

        // MARK: - Conformances

        .target(
            name: "Serializable Integer Primitives",
            dependencies: [
                "ASCII Decimal Serializer Primitives",
                "Serializable ASCII Primitives",
            ]
        ),

        // MARK: - Binary.ASCII.Serializable (deprecated, release-readiness shim)

        .target(
            name: "Binary ASCII Serializable Primitives",
            dependencies: [
                .product(name: "Binary Primitives", package: "swift-binary-primitives"),
                .product(name: "Binary Serializable Primitives", package: "swift-binary-serializer-primitives"),
                .product(name: "Byte Primitives", package: "swift-byte-primitives"),
                .product(name: "Byte Primitives Standard Library Integration", package: "swift-byte-primitives"),
            ]
        ),

        // MARK: - Umbrella

        .target(
            name: "ASCII Serializer Primitives",
            dependencies: [
                "Serializable ASCII Primitives",
                "ASCII Decimal Serializer Primitives",
                "ASCII Hexadecimal Serializer Primitives",
                "ASCII Binary Serializer Primitives",
                "ASCII Octal Serializer Primitives",
                "Serializable Integer Primitives",
                "Binary ASCII Serializable Primitives",
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
            name: "ASCII Binary Serializer Primitives Tests",
            dependencies: [
                "ASCII Binary Serializer Primitives",
            ]
        ),
        .testTarget(
            name: "ASCII Octal Serializer Primitives Tests",
            dependencies: [
                "ASCII Octal Serializer Primitives",
            ]
        ),
        .testTarget(
            name: "Serializable Integer Primitives Tests",
            dependencies: [
                "Serializable Integer Primitives",
            ]
        ),
        .testTarget(
            name: "Serializable ASCII Primitives Tests",
            dependencies: [
                "Serializable ASCII Primitives",
                .product(name: "Serializer Primitives", package: "swift-serializer-primitives"),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
                .product(name: "Binary Serializable Primitives", package: "swift-binary-serializer-primitives"),
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
