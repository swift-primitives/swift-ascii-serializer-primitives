// RangeReplaceableCollection+ASCII.Decimal.swift
// swift-ascii-serializer-primitives
//
// Direct integer -> ASCII-decimal-digit append into an `ASCII.Code` buffer,
// routed through the canonical `ASCII.Decimal.Serializer`. Relocated from
// swift-byte-primitives' `Numeric+Byte` during the truly-primitive cleanup
// (2026-06-22): the int->decimal-digits algorithm has a single home --
// `ASCII.Decimal.Serializer` -- and this is the no-`String`-intermediate
// call-site convenience over it.
//
// Replaces patterns like:
//
//   buffer.append(contentsOf: String(value).utf8)
//
// with:
//
//   buffer.append(contentsOf: value)   // value: some FixedWidthInteger
//
// Buffer element is `ASCII.Code` -- the serializer's native output type and
// the correct substrate for ASCII text. (The byte-domain-generic form is a
// principled absence here: a `public` extension constrained to
// `Byte.`Protocol`` would force a `public import Byte_Primitives`, whose
// re-export collides `ASCII.Code`'s own integer-literal init with
// `Byte.`Protocol``'s default. Consumers building a raw `[Byte]` buffer map
// `ASCII.Code -> Byte` at their boundary.) Foundation-free per
// `[PRIM-FOUND-001]`; no `String` allocation.

extension RangeReplaceableCollection where Element == ASCII.Code {
    /// Appends the ASCII decimal-digit representation of a `FixedWidthInteger`,
    /// with no `String` intermediate -- routed through the canonical
    /// `ASCII.Decimal.Serializer`.
    ///
    /// Negative values are prefixed with `'-'` (0x2D); `0` produces the single
    /// digit `'0'` (0x30).
    ///
    /// ```swift
    /// var buffer: [ASCII.Code] = []
    /// buffer.append(contentsOf: 42)            // [0x34, 0x32]      "42"
    /// buffer.append(contentsOf: -7)            // [0x2D, 0x37]      "-7"
    /// ```
    ///
    /// - Parameter value: The integer to serialize as ASCII decimal digits.
    @_disfavoredOverload
    public mutating func append<T: FixedWidthInteger>(contentsOf value: T) {
        var codes: [ASCII.Code] = []
        ASCII.Decimal.Serializer<T>().serialize(value, into: &codes)
        self.append(contentsOf: codes)
    }
}
