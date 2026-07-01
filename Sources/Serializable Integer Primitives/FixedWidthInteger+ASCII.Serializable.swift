//
//  FixedWidthInteger+ASCII.Serializable.swift
//  swift-ascii-serializer-primitives
//
//  `ASCII.Serializable` conformances for the standard-library integer types.
//
//  Each integer carries a DIRECT `ASCII.Serializable` format verb —
//  `serialize(_:into:)` keyed on the `ASCII.Code` sink — routed through the
//  canonical `ASCII.Decimal.Serializer`. This is the flat write peer of the
//  Step-A parse-lift: no `static var serializer` + transitional bridge (that
//  path is retired in [FAM-012] Phase B). It restores `.asciiCodes` /
//  `.serialized` on the integer types, which the Phase-C re-homing of those
//  accessors onto `ASCII.Serializable` (d8f2a0b) had orphaned.
//
//  An integer has exactly one ASCII form — decimal digits — so it conforms
//  `ASCII.Serializable` as an ordinary format sibling ([FAM-012]).
//

extension Int: ASCII.Serializable {
    /// Serializes this `Int` as ASCII decimal digits into the sink.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Int,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        var codes: [ASCII.Code] = []
        ASCII.Decimal.Serializer<Int>().serialize(value, into: &codes)
        buffer.append(contentsOf: codes)
    }
}

extension UInt: ASCII.Serializable {
    /// Serializes this `UInt` as ASCII decimal digits into the sink.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing UInt,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        var codes: [ASCII.Code] = []
        ASCII.Decimal.Serializer<UInt>().serialize(value, into: &codes)
        buffer.append(contentsOf: codes)
    }
}

extension Int8: ASCII.Serializable {
    /// Serializes this `Int8` as ASCII decimal digits into the sink.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Int8,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        var codes: [ASCII.Code] = []
        ASCII.Decimal.Serializer<Int8>().serialize(value, into: &codes)
        buffer.append(contentsOf: codes)
    }
}

extension Int16: ASCII.Serializable {
    /// Serializes this `Int16` as ASCII decimal digits into the sink.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Int16,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        var codes: [ASCII.Code] = []
        ASCII.Decimal.Serializer<Int16>().serialize(value, into: &codes)
        buffer.append(contentsOf: codes)
    }
}

extension Int32: ASCII.Serializable {
    /// Serializes this `Int32` as ASCII decimal digits into the sink.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Int32,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        var codes: [ASCII.Code] = []
        ASCII.Decimal.Serializer<Int32>().serialize(value, into: &codes)
        buffer.append(contentsOf: codes)
    }
}

extension Int64: ASCII.Serializable {
    /// Serializes this `Int64` as ASCII decimal digits into the sink.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Int64,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        var codes: [ASCII.Code] = []
        ASCII.Decimal.Serializer<Int64>().serialize(value, into: &codes)
        buffer.append(contentsOf: codes)
    }
}

extension UInt8: ASCII.Serializable {
    /// Serializes this `UInt8` as ASCII decimal digits into the sink.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing UInt8,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        var codes: [ASCII.Code] = []
        ASCII.Decimal.Serializer<UInt8>().serialize(value, into: &codes)
        buffer.append(contentsOf: codes)
    }
}

extension UInt16: ASCII.Serializable {
    /// Serializes this `UInt16` as ASCII decimal digits into the sink.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing UInt16,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        var codes: [ASCII.Code] = []
        ASCII.Decimal.Serializer<UInt16>().serialize(value, into: &codes)
        buffer.append(contentsOf: codes)
    }
}

extension UInt32: ASCII.Serializable {
    /// Serializes this `UInt32` as ASCII decimal digits into the sink.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing UInt32,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        var codes: [ASCII.Code] = []
        ASCII.Decimal.Serializer<UInt32>().serialize(value, into: &codes)
        buffer.append(contentsOf: codes)
    }
}

extension UInt64: ASCII.Serializable {
    /// Serializes this `UInt64` as ASCII decimal digits into the sink.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing UInt64,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        var codes: [ASCII.Code] = []
        ASCII.Decimal.Serializer<UInt64>().serialize(value, into: &codes)
        buffer.append(contentsOf: codes)
    }
}
