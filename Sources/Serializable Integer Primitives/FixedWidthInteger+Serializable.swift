//
//  FixedWidthInteger+Serializable.swift
//  swift-ascii-serializer-primitives
//
//  Serializable conformances for standard library integer types.
//

extension Int: Serializable {
    public static var serializer: ASCII.Decimal.Serializer<Int> { .init() }
}

extension UInt: Serializable {
    public static var serializer: ASCII.Decimal.Serializer<UInt> { .init() }
}

extension Int8: Serializable {
    public static var serializer: ASCII.Decimal.Serializer<Int8> { .init() }
}

extension Int16: Serializable {
    public static var serializer: ASCII.Decimal.Serializer<Int16> { .init() }
}

extension Int32: Serializable {
    public static var serializer: ASCII.Decimal.Serializer<Int32> { .init() }
}

extension Int64: Serializable {
    public static var serializer: ASCII.Decimal.Serializer<Int64> { .init() }
}

extension UInt8: Serializable {
    public static var serializer: ASCII.Decimal.Serializer<UInt8> { .init() }
}

extension UInt16: Serializable {
    public static var serializer: ASCII.Decimal.Serializer<UInt16> { .init() }
}

extension UInt32: Serializable {
    public static var serializer: ASCII.Decimal.Serializer<UInt32> { .init() }
}

extension UInt64: Serializable {
    public static var serializer: ASCII.Decimal.Serializer<UInt64> { .init() }
}
