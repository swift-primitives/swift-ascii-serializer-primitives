//
//  ASCII.Serializer.swift
//  swift-ascii-serializer-primitives
//
//  Capability umbrella namespace for ASCII serialization.
//

extension ASCII {
    /// Capability umbrella for ASCII serialization.
    ///
    /// This namespace exists for future composed/convenience access patterns.
    /// Concrete serializers live in their subject domains:
    /// - ``ASCII/Decimal/Serializer``
    /// - ``ASCII/Hexadecimal/Serializer``
    public enum Serializer {}
}
