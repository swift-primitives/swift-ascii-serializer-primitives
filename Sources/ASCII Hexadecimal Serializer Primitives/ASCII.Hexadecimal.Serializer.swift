//
//  ASCII.Hexadecimal.Serializer.swift
//  swift-ascii-serializer-primitives
//
//  Serializes a FixedWidthInteger as lowercase ASCII hexadecimal bytes.
//

extension ASCII.Hexadecimal {
    /// A serializer that writes the lowercase hexadecimal ASCII representation
    /// of a `FixedWidthInteger` into a byte buffer.
    ///
    /// Inverse of `ASCII.Hexadecimal.Parser`.
    ///
    /// Negative signed values are prefixed with `-` and the magnitude is
    /// serialized, matching Swift's `String(_:radix:)` convention.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let serializer = ASCII.Hexadecimal.Serializer<UInt32>()
    /// let bytes = serializer.serialize(0xDEAD)  // [0x64, 0x65, 0x61, 0x64]
    /// ```
    public struct Serializer<T: FixedWidthInteger>: Sendable {
        @inlinable
        public init() {}
    }
}

extension ASCII.Hexadecimal.Serializer: Serializer.`Protocol` {
    public typealias Output = T
    public typealias Buffer = [UInt8]
    public typealias Failure = Never

    @inlinable
    public func serialize(_ output: T, into buffer: inout [UInt8]) {
        guard output != 0 else {
            buffer.append(0x30)
            return
        }

        let start = buffer.count
        let negative = T.isSigned && output < 0

        if negative {
            var magnitude = UInt64(bitPattern: Int64(truncatingIfNeeded: output))
            magnitude = ~magnitude &+ 1
            while magnitude > 0 {
                buffer.append(Self._hexByte(UInt8(truncatingIfNeeded: magnitude & 0xF)))
                magnitude >>= 4
            }
            buffer.append(0x2D) // '-'
        } else {
            var value = output
            while value > 0 {
                buffer.append(Self._hexByte(UInt8(truncatingIfNeeded: value & 0xF)))
                value >>= 4
            }
        }

        // Reverse the digits we just wrote
        var lo = start
        var hi = buffer.count &- 1
        while lo < hi {
            let tmp = buffer[lo]
            buffer[lo] = buffer[hi]
            buffer[hi] = tmp
            lo &+= 1
            hi &-= 1
        }
    }

    /// Maps a nibble value (0–15) to its lowercase ASCII hex byte.
    @inlinable
    static func _hexByte(_ nibble: UInt8) -> UInt8 {
        nibble < 10 ? nibble &+ 0x30 : nibble &+ 0x57
    }
}
