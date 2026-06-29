// Serializable+ASCII.swift
// swift-ascii-serializer-primitives
//
// ASCII-domain convenience accessor on Serializable. Relocated from
// canonical Serializable (was `.asciiBytes` returning [UInt8]) per the
// W2 byte cascade + family-codable-convention realignment: ASCII serializers
// now use [ASCII.Code] as their Buffer, so the accessor lives in the ASCII
// layer with the correct typed-collection return.

public import ASCII_Primitives
public import Serializer_Primitives

extension Serializable where Serializer.Buffer == [ASCII.Code], Serializer.Output == Self {
    /// The ASCII representation of this value using its canonical serializer.
    @inlinable
    public var asciiCodes: [ASCII.Code] {
        var buffer: [ASCII.Code] = []
        do throws(Serializer.Failure) {
            try Self.serializer.serialize(self, into: &buffer)
        } catch {
            preconditionFailure("ASCII serialization unexpectedly failed: \(error)")
        }
        return buffer
    }
}

extension Serializable
where
    Serializer.Buffer == [ASCII.Code],
    Serializer.Output == Self,
    Serializer.Failure == Never
{
    /// The ASCII representation of this value using its canonical serializer.
    ///
    /// Infallible version for serializers that cannot fail.
    @inlinable
    public var asciiCodes: [ASCII.Code] {
        var buffer: [ASCII.Code] = []
        Self.serializer.serialize(self, into: &buffer)
        return buffer
    }
}

// MARK: - Byte-Substrate Accessor (.serialized)
//
// Byte-substrate twin of `asciiCodes`. The canonical ASCII serializers write
// into `[ASCII.Code]`; `.serialized` projects each code to its `Byte` for
// callers that need a plain `[Byte]` (e.g. `String(decoding: x.serialized,
// as: UTF8.self)`). Replacement for the deprecated `Binary.ASCII.Serializable`
// `[Byte]` conveniences. [PRIM-FOUND-004]-clean — projection stays in the byte
// domain (`ASCII.Code.byte`), never reaching `Swift.String`.

extension Serializable where Serializer.Buffer == [ASCII.Code], Serializer.Output == Self {
    /// The ASCII serialization of this value as raw bytes.
    @inlinable
    public var serialized: [Byte] {
        asciiCodes.map(\.byte)
    }
}

extension Serializable
where
    Serializer.Buffer == [ASCII.Code],
    Serializer.Output == Self,
    Serializer.Failure == Never
{
    /// The ASCII serialization of this value as raw bytes.
    ///
    /// Infallible version for serializers that cannot fail.
    @inlinable
    public var serialized: [Byte] {
        asciiCodes.map(\.byte)
    }
}
