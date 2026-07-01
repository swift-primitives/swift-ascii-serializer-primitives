// String+ASCII.Serializable.swift
// swift-ascii-serializer-primitives
//
// Materialises any `ASCII.Serializable` value directly into a `Swift.String`
// ([FAM-012]). Decodes the value's ASCII-code bytes as UTF-8 — ASCII is a
// UTF-8 subset, so this is lossless for well-formed ASCII output. Foundation-free
// per [PRIM-FOUND-001].

public import ASCII_Primitives

extension Swift.String {
    /// Creates a string from an `ASCII.Serializable` value's ASCII output.
    ///
    /// - Parameter value: The value to serialize into ASCII codes.
    public init<Value: ASCII.Serializable>(ascii value: Value) {
        self.init(decoding: value.asciiCodes.map(\.underlying), as: Swift.UTF8.self)
    }
}
