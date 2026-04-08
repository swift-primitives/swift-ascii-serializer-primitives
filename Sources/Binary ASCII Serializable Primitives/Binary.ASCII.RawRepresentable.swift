// Binary.ASCII.RawRepresentable.swift
// swift-ascii-serializer-primitives
//
// Protocol for ASCII serializable types that synthesize RawRepresentable.

extension Binary.ASCII {
    public protocol RawRepresentable: Binary.ASCII.Serializable, Swift.RawRepresentable {}
}

// MARK: - String RawValue

extension Binary.ASCII.RawRepresentable where Self.RawValue == String, Context == Void {
    @_disfavoredOverload
    @inlinable
    public init?(rawValue: String) {
        try? self.init(ascii: Array(rawValue.utf8))
    }

    @_disfavoredOverload
    @inlinable
    public var rawValue: String {
        String(ascii: self)
    }
}

// MARK: - [UInt8] RawValue

extension Binary.ASCII.RawRepresentable where Self.RawValue == [UInt8], Context == Void {
    @_disfavoredOverload
    @inlinable
    public init?(rawValue: [UInt8]) {
        try? self.init(ascii: rawValue)
    }

    @_disfavoredOverload
    @inlinable
    public var rawValue: [UInt8] {
        self.bytes
    }
}

// MARK: - LosslessStringConvertible RawValue

extension Binary.ASCII.RawRepresentable where Self.RawValue: LosslessStringConvertible, Context == Void {
    @_disfavoredOverload
    @inlinable
    public init?(rawValue: RawValue) {
        try? self.init(ascii: Array(String(rawValue).utf8))
    }

    @_disfavoredOverload
    @inlinable
    public var rawValue: RawValue {
        let string = String(ascii: self)
        return RawValue(string)!
    }
}
