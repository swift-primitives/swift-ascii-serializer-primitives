// Serializable+ASCII.swift
// swift-ascii-serializer-primitives
//
// ASCII-domain convenience accessors derived from the `ASCII.Serializable`
// static verb ([FAM-012]): `.asciiCodes` materialises the ASCII-code form,
// `.serialized` projects it to raw `[Byte]`. Additive sugar — not load-bearing
// (a conformer may omit them; they exist only for ergonomic call sites).

public import ASCII_Primitives

extension ASCII.Serializable {
    /// The ASCII-code representation of this value, via its `ASCII.Serializable` verb.
    @inlinable
    public var asciiCodes: [ASCII.Code] {
        var buffer: [ASCII.Code] = []
        Self.serialize(self, into: &buffer)
        return buffer
    }

    /// The ASCII serialization of this value as raw bytes.
    ///
    /// Projects each `ASCII.Code` to its `Byte`; stays in the byte domain
    /// ([PRIM-FOUND-004]-clean — never reaches `Swift.String`).
    @inlinable
    public var serialized: [Byte] {
        asciiCodes.map(\.byte)
    }
}
