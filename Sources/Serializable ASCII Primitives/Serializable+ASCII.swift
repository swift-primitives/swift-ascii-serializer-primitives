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
