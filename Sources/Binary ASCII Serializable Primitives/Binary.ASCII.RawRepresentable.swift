// Binary.ASCII.RawRepresentable.swift
// swift-ascii-serializer-primitives
//
// Protocol for ASCII serializable types that synthesize RawRepresentable.

extension Binary.ASCII {
    /// An ASCII-serializable type whose `RawRepresentable` conformance is derived from its ASCII form.
    public protocol RawRepresentable: Binary.ASCII.Serializable, Swift.RawRepresentable {}
}

// MARK: - String RawValue

extension Binary.ASCII.RawRepresentable where Self.RawValue == String, Context == Void {
    /// Creates a value by decoding the ASCII bytes of `rawValue`, or `nil` if decoding fails.
    @_disfavoredOverload
    @inlinable
    public init?(rawValue: String) {
        do throws(Self.Error) {
            try self.init(ascii: [Byte](rawValue.utf8))
        } catch {
            return nil
        }
    }

    /// The value's ASCII serialization as a `String`.
    @_disfavoredOverload
    @inlinable
    public var rawValue: String {
        String(ascii: self)
    }
}

// MARK: - [Byte] RawValue

extension Binary.ASCII.RawRepresentable where Self.RawValue == [Byte], Context == Void {
    /// Creates a value by decoding the ASCII bytes `rawValue`, or `nil` if decoding fails.
    @_disfavoredOverload
    @inlinable
    public init?(rawValue: [Byte]) {
        do throws(Self.Error) {
            try self.init(ascii: rawValue)
        } catch {
            return nil
        }
    }

    /// The value's ASCII serialization as a `[Byte]` array.
    @_disfavoredOverload
    @inlinable
    public var rawValue: [Byte] {
        Self.serialize(ascii: self)
    }
}

// MARK: - LosslessStringConvertible RawValue

extension Binary.ASCII.RawRepresentable where Self.RawValue: LosslessStringConvertible, Context == Void {
    /// Creates a value by decoding the ASCII text of `rawValue`, or `nil` if decoding fails.
    @_disfavoredOverload
    @inlinable
    public init?(rawValue: RawValue) {
        do throws(Self.Error) {
            try self.init(ascii: [Byte](String(rawValue).utf8))
        } catch {
            return nil
        }
    }

    /// The value's ASCII serialization parsed back into its `RawValue`.
    @_disfavoredOverload
    @inlinable
    public var rawValue: RawValue {
        let string = String(ascii: self)
        guard let value = RawValue(string) else {
            preconditionFailure("ASCII serialization is not round-trippable through \(RawValue.self): \(string)")
        }
        return value
    }
}
