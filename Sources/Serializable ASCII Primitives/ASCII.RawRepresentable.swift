// ASCII.RawRepresentable.swift
// swift-ascii-serializer-primitives
//
// Namespace for the RawRepresentable-backed ASCII serialization family. The
// subject-first home ([API-NAME-001b]) for ASCII serializers keyed off a
// conformer's `Swift.RawRepresentable` rawValue — a sibling of `ASCII.Decimal`,
// `ASCII.Hexadecimal`, etc. Hosts `ASCII.RawRepresentable.Serializer`.

public import ASCII_Primitives

extension ASCII {
    /// Namespace for ASCII serialization driven by a value's
    /// `Swift.RawRepresentable` `rawValue`.
    ///
    /// The subject-first sibling of `ASCII.Decimal`, `ASCII.Hexadecimal`, … —
    /// the ASCII domain owns the serializer specialization, the role is the
    /// leaf. Hosts ``ASCII/RawRepresentable/Serializer``, the generic witness
    /// that projects a `String`- or `[Byte]`-backed `rawValue` into
    /// `[ASCII.Code]`.
    public enum RawRepresentable {}
}
