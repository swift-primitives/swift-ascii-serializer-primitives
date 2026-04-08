// Binary.ASCII.Serializable.swift
// swift-ascii-serializer-primitives
//
// ASCII Serialization Protocol (deprecated — use Parseable/Serializable witnesses)

extension Binary.ASCII {
    @available(*, deprecated, message: "Use static witness properties instead: static var ascii: Serialization.Serializing.Buffer and parser.ascii.whole/prefix accessors")
    public protocol Serializable: Binary.Serializable {
        static func serialize<Buffer: RangeReplaceableCollection>(
            ascii serializable: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8

        associatedtype Error: Swift.Error
        associatedtype Context: Sendable = Void

        init<Bytes: Collection>(
            ascii bytes: Bytes,
            in context: Context
        ) throws(Error) where Bytes.Element == UInt8
    }
}

// MARK: - Binary.Serializable Conformance

extension Binary.ASCII.Serializable {
    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ serializable: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        Self.serialize(ascii: serializable, into: &buffer)
    }
}

// MARK: - Static Returning Convenience

extension Binary.ASCII.Serializable {
    @inlinable
    public static func serialize<Bytes: RangeReplaceableCollection>(
        ascii serializable: Self
    ) -> Bytes where Bytes.Element == UInt8 {
        var buffer = Bytes()
        Self.serialize(ascii: serializable, into: &buffer)
        return buffer
    }
}

// MARK: - Collection Initializers

extension Array where Element == UInt8 {
    @inlinable
    public init<S: Binary.ASCII.Serializable>(ascii serializable: S) {
        self = []
        S.serialize(ascii: serializable, into: &self)
    }
}

extension Binary.ASCII.Serializable where Self: Swift.RawRepresentable, Self.RawValue == [UInt8] {
    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        ascii serializable: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(contentsOf: serializable.rawValue)
    }
}

// MARK: - Context-Free Convenience

extension Binary.ASCII.Serializable where Context == Void {
    @inlinable
    public init<Bytes: Collection>(ascii bytes: Bytes) throws(Error) where Bytes.Element == UInt8 {
        try self.init(ascii: bytes, in: ())
    }
}

extension Binary.ASCII.Serializable where Context == Void {
    @inlinable
    public init(_ string: some StringProtocol) throws(Error) {
        try self.init(ascii: Array(string.utf8))
    }
}

// MARK: - String Conversion

extension StringProtocol {
    @inlinable
    public init<T: Binary.ASCII.Serializable>(ascii value: T) {
        let bytes: [UInt8] = T.serialize(ascii: value)
        self = .init(decoding: bytes, as: UTF8.self)
    }
}

// MARK: - CustomStringConvertible

extension Binary.ASCII.Serializable where Self: CustomStringConvertible {
    @_disfavoredOverload
    @inlinable
    public var description: String {
        String(ascii: self)
    }
}

extension Binary.ASCII.Serializable
where Self: RawRepresentable, Self: CustomStringConvertible, Self.RawValue: CustomStringConvertible {
    @inlinable
    public var description: String {
        rawValue.description
    }
}

extension Binary.ASCII.Serializable
where Self: RawRepresentable, Self: CustomStringConvertible, Self.RawValue == [UInt8] {
    @inlinable
    public var description: String {
        String(decoding: rawValue, as: UTF8.self)
    }
}

// MARK: - ExpressibleBy*Literal Support

extension Binary.ASCII.Serializable
where Self: ExpressibleByStringLiteral, Context == Void {
    @inlinable
    public init(stringLiteral value: String) {
        // swiftlint:disable:next force_try
        try! self.init(value)
    }
}

extension Binary.ASCII.Serializable where Self: ExpressibleByIntegerLiteral, Context == Void {
    @inlinable
    public init(integerLiteral value: Int) {
        // swiftlint:disable:next force_try
        try! self.init(String(value))
    }
}

extension Binary.ASCII.Serializable where Self: ExpressibleByFloatLiteral, Context == Void {
    @inlinable
    public init(floatLiteral value: Double) {
        // swiftlint:disable:next force_try
        try! self.init(String(value))
    }
}

extension RangeReplaceableCollection where Element == UInt8 {
    @inlinable
    public mutating func append<Serializable: Binary.ASCII.Serializable>(
        ascii serializable: Serializable
    ) {
        Serializable.serialize(ascii: serializable, into: &self)
    }
}
