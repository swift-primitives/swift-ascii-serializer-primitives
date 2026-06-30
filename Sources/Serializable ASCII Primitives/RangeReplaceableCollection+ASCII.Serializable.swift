// RangeReplaceableCollection+ASCII.Serializable.swift
// swift-ascii-serializer-primitives
//
// Byte-substrate append convenience for ASCII-serializable values: appends the
// value's ASCII serialization (each code projected to its `Byte`) to a byte
// collection. Keyed off the `ASCII.Serializable` verb via the `.serialized`
// accessor. [PRIM-FOUND-004]-clean (byte domain only).

public import ASCII_Primitives

extension RangeReplaceableCollection where Element == Byte {
    /// Appends the ASCII serialization of `value` to this byte collection.
    ///
    /// Serializes `value` via its `ASCII.Serializable` verb and appends the
    /// projected bytes (mirrors the `.serialized` accessor, on the byte substrate).
    @inlinable
    public mutating func append<Value: ASCII.Serializable>(serialized value: Value) {
        self.append(contentsOf: value.serialized)
    }
}
