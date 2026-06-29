// Serializable+ASCII.RawRepresentable.swift
// swift-ascii-serializer-primitives
//
// The option-(B) RawRepresentable-backed default ASCII serializer. Default
// `serializer` accessors that give any `Serializable` + `ASCII.Serializable`
// conformer whose `Swift.RawRepresentable` `RawValue` is `String` or `[Byte]`
// a canonical ASCII serializer for free. Net effect: such a conformer needs
// only the conformance declarations (~3 lines) and inherits `.serialized`,
// `asciiCodes`, and the `Binary.Serializable` bridge.
//
// [PRIM-FOUND-004]-clean: a conformer's existing `String` / `[Byte]` rawValue
// is consumed as serialize INPUT (`String → .utf8`, `[Byte]` directly); no
// `Swift.String`-producing accessor is exposed at L1.

public import ASCII_Primitives
public import Serializer_Primitives

// MARK: - String RawValue

extension Serializable
where
    Self: ASCII.Serializable,
    Self: Swift.RawRepresentable,
    Self.RawValue == String
{
    /// The canonical ASCII serializer for a `String`-backed `RawRepresentable`
    /// value: projects the rawValue's UTF-8 bytes to `[ASCII.Code]`.
    @inlinable
    public static var serializer: ASCII.RawRepresentable.Serializer<Self> {
        ASCII.RawRepresentable.Serializer { value, buffer in
            for byte in value.rawValue.utf8 {
                buffer.append(ASCII.Code(byte))
            }
        }
    }
}

// MARK: - [Byte] RawValue

extension Serializable
where
    Self: ASCII.Serializable,
    Self: Swift.RawRepresentable,
    Self.RawValue == [Byte]
{
    /// The canonical ASCII serializer for a `[Byte]`-backed `RawRepresentable`
    /// value: projects each rawValue byte to its `ASCII.Code`.
    ///
    /// Bytes are projected unchecked — the serializer is infallible
    /// (`Failure == Never`) and uses `ASCII.Code` purely as the byte-substrate
    /// buffer ("ASCII bytes are bytes"); `.serialized` recovers the exact bytes.
    @inlinable
    public static var serializer: ASCII.RawRepresentable.Serializer<Self> {
        ASCII.RawRepresentable.Serializer { value, buffer in
            for byte in value.rawValue {
                buffer.append(ASCII.Code(unchecked: byte))
            }
        }
    }
}
