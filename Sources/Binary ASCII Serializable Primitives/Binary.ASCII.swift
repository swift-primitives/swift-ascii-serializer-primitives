// Binary.ASCII.swift
// swift-ascii-serializer-primitives
//
// ASCII operations namespace.

extension Binary {
    /// ASCII operations namespace.
    ///
    /// Hosts the ASCII serialization, parsing, equality, and access facilities
    /// declared in extensions across this package and `swift-ascii` (L3), per
    /// INCITS 4-1986 (US-ASCII standard).
    ///
    /// This is a pure namespace and carries no stored value. The byte-domain
    /// value substrate is `ASCII.Code` (`swift-ascii-primitives`); a raw byte is
    /// `Byte` / `UInt8`.
    public enum ASCII {}
}
