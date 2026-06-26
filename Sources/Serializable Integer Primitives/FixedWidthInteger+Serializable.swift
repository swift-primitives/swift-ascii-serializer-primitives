//
//  FixedWidthInteger+Serializable.swift
//  swift-ascii-serializer-primitives
//
//  Serializable conformances for standard library integer types.
//

extension Int: @retroactive Serializable {
    /// The canonical ASCII decimal serializer for `Int` values.
    public static var serializer: ASCII.Decimal.Serializer<Int> { .init() }
}

extension UInt: @retroactive Serializable {
    /// The canonical ASCII decimal serializer for `UInt` values.
    public static var serializer: ASCII.Decimal.Serializer<UInt> { .init() }
}

extension Int8: @retroactive Serializable {
    /// The canonical ASCII decimal serializer for `Int8` values.
    public static var serializer: ASCII.Decimal.Serializer<Int8> { .init() }
}

extension Int16: @retroactive Serializable {
    /// The canonical ASCII decimal serializer for `Int16` values.
    public static var serializer: ASCII.Decimal.Serializer<Int16> { .init() }
}

extension Int32: @retroactive Serializable {
    /// The canonical ASCII decimal serializer for `Int32` values.
    public static var serializer: ASCII.Decimal.Serializer<Int32> { .init() }
}

extension Int64: @retroactive Serializable {
    /// The canonical ASCII decimal serializer for `Int64` values.
    public static var serializer: ASCII.Decimal.Serializer<Int64> { .init() }
}

extension UInt8: @retroactive Serializable {
    /// The canonical ASCII decimal serializer for `UInt8` values.
    public static var serializer: ASCII.Decimal.Serializer<UInt8> { .init() }
}

extension UInt16: @retroactive Serializable {
    /// The canonical ASCII decimal serializer for `UInt16` values.
    public static var serializer: ASCII.Decimal.Serializer<UInt16> { .init() }
}

extension UInt32: @retroactive Serializable {
    /// The canonical ASCII decimal serializer for `UInt32` values.
    public static var serializer: ASCII.Decimal.Serializer<UInt32> { .init() }
}

extension UInt64: @retroactive Serializable {
    /// The canonical ASCII decimal serializer for `UInt64` values.
    public static var serializer: ASCII.Decimal.Serializer<UInt64> { .init() }
}
