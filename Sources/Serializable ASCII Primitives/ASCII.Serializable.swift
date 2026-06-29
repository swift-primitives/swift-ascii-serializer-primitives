//
//  ASCII.Serializable.swift
//  swift-ascii-serializer-primitives
//
//  ASCII-substrate sibling protocol in the family-Codable convention.
//

public import ASCII_Primitives

extension ASCII {
    /// A type whose canonical serializer emits ASCII-substrate byte content.
    ///
    /// Top-level format-specific sibling protocol per family-Codable
    /// convention [FAM-001/006]: flat, no associated types, no refinement
    /// of canonical-attachment protocols. The **write peer of**
    /// ``ASCII/Parseable`` — both are non-refining peers of the canonical
    /// `Serializable` / `Parseable` attachment protocols.
    ///
    /// Generic algorithms dispatching on ASCII-substrate serialization can
    /// require `T: ASCII.Serializable`. The canonical serializer instance is
    /// supplied by the conformer as a static accessor, by convention
    /// (no protocol requirement carries the associated-type slot, per
    /// [FAM-001]).
    ///
    /// ## Symmetry with `ASCII.Parseable`
    ///
    /// A type may conform to both `ASCII.Serializable` (write) and
    /// ``ASCII/Parseable`` (read) — per the family-Codable convention's
    /// byte-stream split-pair shape. Serialization is reached via the
    /// canonical `Serializable` accessor (`Self.serializer`) and the
    /// `.serialized` / `asciiCodes` conveniences in this module; an
    /// ASCII-serializable value is additionally usable as
    /// `Binary.Serializable` — ASCII bytes are bytes — via the bridge in
    /// this module.
    public protocol Serializable {}
}
