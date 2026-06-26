// Binary.ASCII.Serializable.swift
// swift-ascii-serializer-primitives
//
// ASCII Serializable Protocol (deprecated — use Binary.Serializable / Parser.Protocol witnesses directly)
//
// Substrate: `Buffer.Element == Byte` and `Bytes.Element == Byte` (byte-domain typed
// per the ASCII-domain retyping arc, 2026-05-19). The `Binary.Serializable` parent
// is now Byte-typed too (per broader L2/L3 byte-typing gap W2 retype, 2026-05-19),
// so the parent-bridge is direct delegation; no BSLI `Sequence<Byte>.underlying`
// translation needed.

public import Binary_Serializable_Primitives

extension Binary.ASCII {
    /// A type that serializes to, and is reconstructable from, ASCII bytes.
    @available(*, deprecated, message: "Use Binary.Serializable / Parser.Protocol conformances directly; legacy Serialization namespace was removed in W4.")
    public protocol Serializable: Binary.Serializable {
        /// Serializes `serializable` as ASCII bytes into `buffer`.
        static func serialize<Buffer: RangeReplaceableCollection>(
            ascii serializable: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == Byte

        /// The error thrown when decoding ASCII bytes fails.
        associatedtype Error: Swift.Error

        /// Out-of-band information required to decode the ASCII bytes.
        associatedtype Context: Sendable = Void

        /// Creates a value by decoding ASCII `bytes` using the given `context`.
        init<Bytes: Collection>(
            ascii bytes: Bytes,
            in context: Context
        ) throws(Error) where Bytes.Element == Byte
    }
}

// MARK: - Binary.Serializable Conformance (direct delegation; parent is now Byte-typed)

extension Binary.ASCII.Serializable {
    /// Serializes `serializable` into `buffer`, satisfying `Binary.Serializable` by delegating to the ASCII serializer.
    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ serializable: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        Self.serialize(ascii: serializable, into: &buffer)
    }
}

// MARK: - Static Returning Convenience

extension Binary.ASCII.Serializable {
    /// Returns the ASCII serialization of `serializable` as a freshly created buffer.
    @inlinable
    public static func serialize<Bytes: RangeReplaceableCollection>(
        ascii serializable: Self
    ) -> Bytes where Bytes.Element == Byte {
        var buffer = Bytes()
        Self.serialize(ascii: serializable, into: &buffer)
        return buffer
    }
}

// MARK: - Collection Initializers

extension Array where Element == Byte {
    /// Creates a byte array holding the ASCII serialization of `serializable`.
    @inlinable
    public init<S: Binary.ASCII.Serializable>(ascii serializable: S) {
        self = []
        S.serialize(ascii: serializable, into: &self)
    }
}

extension Binary.ASCII.Serializable where Self: Swift.RawRepresentable, Self.RawValue == [Byte] {
    /// Serializes `serializable` by appending its `[Byte]` raw value to `buffer`.
    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        ascii serializable: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: serializable.rawValue)
    }
}

// MARK: - Context-Free Convenience

extension Binary.ASCII.Serializable where Context == Void {
    /// Creates a value by decoding ASCII `bytes` with the default (`Void`) context.
    @inlinable
    public init<Bytes: Collection>(ascii bytes: Bytes) throws(Self.Error) where Bytes.Element == Byte {
        try self.init(ascii: bytes, in: ())
    }
}

extension Binary.ASCII.Serializable where Context == Void {
    /// Creates a value by decoding the UTF-8 bytes of `string` as ASCII.
    @inlinable
    public init(_ string: some StringProtocol) throws(Self.Error) {
        try self.init(ascii: [Byte](string.utf8))
    }
}

// MARK: - String Conversion

extension String {
    /// Creates a string by decoding the ASCII serialization of `value` as UTF-8.
    @inlinable
    public init<T: Binary.ASCII.Serializable>(ascii value: T) {
        let bytes: [Byte] = T.serialize(ascii: value)
        self.init(decoding: bytes, as: UTF8.self)
    }
}

// MARK: - CustomStringConvertible

extension Binary.ASCII.Serializable where Self: CustomStringConvertible {
    /// The value's ASCII serialization decoded as a `String`.
    @_disfavoredOverload
    @inlinable
    public var description: String {
        String(ascii: self)
    }
}

extension Binary.ASCII.Serializable
where Self: RawRepresentable, Self: CustomStringConvertible, Self.RawValue: CustomStringConvertible {
    /// The textual description of the underlying raw value.
    @inlinable
    public var description: String {
        rawValue.description
    }
}

extension Binary.ASCII.Serializable
where Self: RawRepresentable, Self: CustomStringConvertible, Self.RawValue == [Byte] {
    /// The raw `[Byte]` value decoded as a UTF-8 `String`.
    @inlinable
    public var description: String {
        String(decoding: rawValue, as: UTF8.self)
    }
}

// MARK: - ExpressibleBy*Literal Support

extension Binary.ASCII.Serializable
where Self: ExpressibleByStringLiteral, Context == Void {
    /// Creates a value from a string literal by decoding it as ASCII.
    @inlinable
    public init(stringLiteral value: String) {
        do throws(Self.Error) {
            try self.init(value)
        } catch {
            preconditionFailure("Invalid ASCII string literal: \(error)")
        }
    }
}

extension Binary.ASCII.Serializable where Self: ExpressibleByIntegerLiteral, Context == Void {
    /// Creates a value from an integer literal by decoding its decimal text as ASCII.
    @inlinable
    public init(integerLiteral value: Int) {
        do throws(Self.Error) {
            try self.init(String(value))
        } catch {
            preconditionFailure("Invalid ASCII integer literal: \(error)")
        }
    }
}

extension Binary.ASCII.Serializable where Self: ExpressibleByFloatLiteral, Context == Void {
    /// Creates a value from a floating-point literal by decoding its text as ASCII.
    @inlinable
    public init(floatLiteral value: Double) {
        do throws(Self.Error) {
            try self.init(String(value))
        } catch {
            preconditionFailure("Invalid ASCII float literal: \(error)")
        }
    }
}

extension RangeReplaceableCollection where Element == Byte {
    /// Appends the ASCII serialization of `serializable` to this collection.
    @inlinable
    public mutating func append<Serializable: Binary.ASCII.Serializable>(
        ascii serializable: Serializable
    ) {
        Serializable.serialize(ascii: serializable, into: &self)
    }
}
