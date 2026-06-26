# ASCII Serializer Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

ASCII serializers that write `FixedWidthInteger` values as decimal or lowercase-hexadecimal digits into `ASCII.Code` buffers, with `Serializable` conformances for the standard-library integer types.

---

## Quick Start

The serializers turn an integer into its ASCII digit codes directly — no `String` allocation and no intermediate base-10 string. Every standard-library integer is made `Serializable`, so `asciiCodes` and a buffer-appending `append(contentsOf:)` are available out of the box.

```swift
import ASCII_Serializer_Primitives

// Write an integer's decimal digits straight into an ASCII-code buffer.
var buffer: [ASCII.Code] = []
buffer.append(contentsOf: 8080)        // [0x38, 0x30, 0x38, 0x30]   "8080"
buffer.append(contentsOf: -7)          // appends 0x2D, 0x37          "-7"

// `asciiCodes` is the canonical ASCII form of any Serializable integer.
let codes: [ASCII.Code] = 255.asciiCodes   // [0x32, 0x35, 0x35]      "255"
```

Reach for a serializer directly when you want to choose the radix:

```swift
import ASCII_Serializer_Primitives

let hex = ASCII.Hexadecimal.Serializer<UInt32>()
var out: [ASCII.Code] = []
hex.serialize(0xDEAD, into: &out)      // [0x64, 0x65, 0x61, 0x64]   "dead"

let decimal = ASCII.Decimal.Serializer<Int16>()
out.removeAll(keepingCapacity: true)
decimal.serialize(-32_768, into: &out) // serializes the magnitude with a leading '-'
```

`0` serializes to the single digit `'0'`; negative signed values are prefixed with `'-'` and their magnitude is written, matching Swift's `String(_:radix:)` convention. Both serializers report `Failure == Never`, so serialization cannot fail.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-ascii-serializer-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "ASCII Serializer Primitives", package: "swift-ascii-serializer-primitives"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Six library products plus a test-support target, composed over the `ASCII.Code`, `Serializer`, and `Binary` primitives. Import the umbrella `ASCII Serializer Primitives` for the whole surface, or a single sub-product to keep the dependency narrow.

| Product | Target | Purpose |
|---------|--------|---------|
| `ASCII Serializer Primitives` | `Sources/ASCII Serializer Primitives/` | Umbrella that re-exports every sub-target below. |
| `ASCII Decimal Serializer Primitives` | `Sources/ASCII Decimal Serializer Primitives/` | `ASCII.Decimal.Serializer<T>` — writes the decimal ASCII digits of a `FixedWidthInteger`. |
| `ASCII Hexadecimal Serializer Primitives` | `Sources/ASCII Hexadecimal Serializer Primitives/` | `ASCII.Hexadecimal.Serializer<T>` — writes the lowercase hexadecimal ASCII digits of a `FixedWidthInteger`. |
| `Serializable ASCII Primitives` | `Sources/Serializable ASCII Primitives/` | The `asciiCodes` accessor on any `Serializable` whose buffer is `[ASCII.Code]`. |
| `Serializable Integer Primitives` | `Sources/Serializable Integer Primitives/` | `Serializable` conformances for the standard-library integers, plus `RangeReplaceableCollection.append(contentsOf:)` for integers into an `[ASCII.Code]` buffer. |
| `Binary ASCII Serializable Primitives` | `Sources/Binary ASCII Serializable Primitives/` | The deprecated `Binary.ASCII.Serializable` shim with its `RawRepresentable` and `Wrapper` helpers. |
| `ASCII Serializer Primitives Test Support` | `Tests/Support/` | Re-exports the umbrella for test consumers. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
