// RangeReplaceableCollection+ASCII.Serializable.swift
// swift-ascii-serializer-primitives
//
// Byte-substrate append convenience for ASCII-serializable values. Replacement
// for the deprecated `RangeReplaceableCollection.append(ascii:)` — keyed off
// the canonical `Serializable` accessor (`[ASCII.Code]` buffer) and projecting
// each ASCII code to its `Byte`. [PRIM-FOUND-004]-clean (byte domain only).

public import ASCII_Primitives
public import Serializer_Primitives

extension RangeReplaceableCollection where Element == Byte {
    /// Appends the ASCII serialization of `value` to this byte collection.
    ///
    /// Serializes `value` via its canonical `[ASCII.Code]` serializer and
    /// appends the projected bytes. Mirrors ``Serializer_Primitives/Serializable``'s
    /// `asciiCodes` accessor, on the byte substrate.
    @inlinable
    public mutating func append<Value: Serializable>(
        serialized value: Value
    ) where Value.Serializer.Buffer == [ASCII.Code], Value.Serializer.Output == Value {
        self.append(contentsOf: value.serialized)
    }
}
