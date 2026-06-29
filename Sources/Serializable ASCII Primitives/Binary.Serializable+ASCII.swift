// Binary.Serializable+ASCII.swift
// swift-ascii-serializer-primitives
//
// The `Binary.Serializable` bridge for ASCII-serializable values: an
// ASCII-serializable value is usable as `Binary.Serializable` — ASCII bytes
// are bytes. Derives the byte-stream serialize witness from the canonical
// `[ASCII.Code]` serializer by projecting each code to its `Byte`.
// [PRIM-FOUND-004]-clean (byte domain only; never reaches Swift.String).
//
// Conformers opt in by declaring `: Binary.Serializable` alongside
// `: Serializable` + `: ASCII.Serializable`; this constrained default supplies
// the witness. Replaces the deprecated `Binary.ASCII.Serializable:
// Binary.Serializable` refinement with a non-refining family-Codable bridge.

public import ASCII_Primitives
public import Binary_Serializable_Primitives
public import Serializer_Primitives

extension Binary.Serializable
where
    Self: Serializable,
    Self: ASCII.Serializable,
    Self.Serializer.Buffer == [ASCII.Code],
    Self.Serializer.Output == Self
{
    /// Serializes an ASCII-serializable value as bytes, satisfying
    /// `Binary.Serializable` by projecting the canonical `[ASCII.Code]`
    /// serialization to the byte domain.
    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ serializable: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: serializable.serialized)
    }
}
