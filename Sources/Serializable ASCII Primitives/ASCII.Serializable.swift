//
//  ASCII.Serializable.swift
//  swift-ascii-serializer-primitives
//
//  ASCII-substrate sibling protocol in the family-Codable convention.
//

public import ASCII_Primitives

extension ASCII {
    /// A type that serializes itself to ASCII-code output ([FAM-012]).
    ///
    /// Self-contained format sibling per the serialize/parse codec-attachment
    /// model: `ASCII.Serializable` carries its OWN static serialize verb, keyed
    /// by the sink's element type (`ASCII.Code` ⇒ text). It is flat — no
    /// associated types ([FAM-001]) — and refines nothing. The write peer of
    /// ``ASCII/Parseable``.
    ///
    /// A type conforms to exactly the format siblings it has: a text-only value
    /// conforms `ASCII.Serializable` alone; a value with both a wire and a text
    /// form (e.g. an IP address) conforms `Binary.Serializable` and
    /// `ASCII.Serializable` as ordinary peers — there is no canonical tier to
    /// decline and no wire-from-text bridge.
    ///
    /// The format is chosen by the buffer's element type at the call site:
    ///
    /// ```swift
    /// var text: [ASCII.Code] = []
    /// RFC_791.IPv4.Address.serialize(address, into: &text)   // "192.168.1.1"
    /// ```
    ///
    /// The `.asciiCodes` / `.serialized` conveniences in this module derive from
    /// this verb.
    public protocol Serializable {
        /// Serializes a value into an ASCII-code buffer.
        ///
        /// Appends the ASCII-code representation to `buffer` without clearing
        /// existing content. Implementations must be deterministic and
        /// infallible for valid values.
        ///
        /// - Parameters:
        ///   - serializable: The value to serialize.
        ///   - buffer: The buffer to append ASCII codes to.
        static func serialize<Buffer: RangeReplaceableCollection>(
            _ serializable: borrowing Self,
            into buffer: inout Buffer
        ) where Buffer.Element == ASCII.Code
    }
}
