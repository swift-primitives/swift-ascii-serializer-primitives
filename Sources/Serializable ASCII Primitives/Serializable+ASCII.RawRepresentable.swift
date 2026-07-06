// Serializable+ASCII.RawRepresentable.swift
// swift-ascii-serializer-primitives
//
// The RawRepresentable-backed default for `ASCII.Serializable`. Any conformer
// whose `Swift.RawRepresentable` `RawValue` is `String` or `[Byte]` inherits the
// `ASCII.Serializable` format verb — `serialize(_:into:)` — for free, emitting
// the rawValue's ASCII codes directly into the sink. Net effect: such a
// conformer needs only the conformance declarations (~2–3 lines) and inherits
// `.serialized`, `asciiCodes`, and the `Binary.Serializable` bridge.
//
// This is a permanent, FLAT default: it provides the `ASCII.Serializable` verb
// itself, not a `static var serializer` routed through a transitional bridge.
//
// [PRIM-FOUND-004]-clean: a conformer's existing `String` / `[Byte]` rawValue
// is consumed as serialize INPUT (`String → .utf8`, `[Byte]` directly); no
// `Swift.String`-producing accessor is exposed at L1.

public import ASCII_Primitives

// MARK: - String RawValue

extension ASCII.Serializable
where
    Self: Swift.RawRepresentable,
    Self.RawValue == String
{
    /// The canonical ASCII serialization for a `String`-backed
    /// `RawRepresentable` value: appends the rawValue's UTF-8 bytes, projected
    /// to `ASCII.Code`, to the sink.
    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Self,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        // reason: this IS the bottom-out implementation — the String rawValue's
        // UTF-8 view is the canonical byte source for the flat serialize default;
        // no retag()/map() path exists from Swift.RawRepresentable.rawValue.
        // swiftlint:disable:next chained_rawvalue_access_anti_pattern
        for byte in value.rawValue.utf8 {
            buffer.append(ASCII.Code(byte))
        }
    }
}

// MARK: - [Byte] RawValue

extension ASCII.Serializable
where
    Self: Swift.RawRepresentable,
    Self.RawValue == [Byte]
{
    /// The canonical ASCII serialization for a `[Byte]`-backed
    /// `RawRepresentable` value: appends each rawValue byte, projected to its
    /// `ASCII.Code`, to the sink.
    ///
    /// Bytes are projected unchecked — `ASCII.Code` is used purely as the
    /// byte-substrate ("ASCII bytes are bytes"); `.serialized` recovers the
    /// exact bytes.
    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Self,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        for byte in value.rawValue {
            buffer.append(ASCII.Code(unchecked: byte))
        }
    }
}
