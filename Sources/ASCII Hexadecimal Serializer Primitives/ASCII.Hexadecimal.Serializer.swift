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
        /// Creates a hexadecimal serializer for `T`.
        @inlinable
        public init() {}
    }
}

extension ASCII.Hexadecimal.Serializer: Serializer.`Protocol` {
    /// The integer type whose hexadecimal representation is written.
    public typealias Output = T

    /// The `ASCII.Code` buffer the hexadecimal digits are appended to.
    public typealias Buffer = [ASCII.Code]

    /// The failure type; hexadecimal serialization never fails.
    public typealias Failure = Never

    /// Appends the lowercase hexadecimal ASCII digits of `output` to `buffer`.
    ///
    /// `0` is written as the single digit `'0'`; negative signed values are
    /// prefixed with `'-'` and their magnitude is written.
    ///
    /// - Parameters:
    ///   - output: The integer to serialize as hexadecimal digits.
    ///   - buffer: The `ASCII.Code` buffer to append the digits to.
    @inlinable
    public func serialize(_ output: T, into buffer: inout [ASCII.Code]) {
        guard output != 0 else {
            buffer.append(ASCII.Code(0x30))
            return
        }

        let start = buffer.count
        let negative = T.isSigned && output < 0

        if negative {
            var magnitude = UInt64(bitPattern: Int64(truncatingIfNeeded: output))
            magnitude = ~magnitude &+ 1
            while magnitude > 0 {
                buffer.append(Self._hexCode(UInt8(truncatingIfNeeded: magnitude & 0xF)))
                magnitude >>= 4
            }
            buffer.append(ASCII.Code(0x2D))  // '-'
        } else {
            var value = output
            while value > 0 {
                buffer.append(Self._hexCode(UInt8(truncatingIfNeeded: value & 0xF)))
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

    /// Maps a nibble value (0–15) to its lowercase ASCII hex code.
    @inlinable
    package static func _hexCode(_ nibble: UInt8) -> ASCII.Code {
        ASCII.Code(nibble < 10 ? nibble &+ 0x30 : nibble &+ 0x57)
    }
}
