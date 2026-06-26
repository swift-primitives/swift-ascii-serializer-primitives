//
//  ASCII.Decimal.Serializer.swift
//  swift-ascii-serializer-primitives
//
//  Serializes a FixedWidthInteger as ASCII decimal bytes.
//

extension ASCII.Decimal {
    /// A serializer that writes the decimal ASCII representation of a
    /// `FixedWidthInteger` into a byte buffer.
    ///
    /// Inverse of `ASCII.Decimal.Parser`.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let serializer = ASCII.Decimal.Serializer<UInt16>()
    /// let bytes = serializer.serialize(8080)  // [0x38, 0x30, 0x38, 0x30]
    /// ```
    public struct Serializer<T: FixedWidthInteger>: Sendable {
        /// Creates a decimal serializer for `T`.
        @inlinable
        public init() {}
    }
}

extension ASCII.Decimal.Serializer: Serializer.`Protocol` {
    /// The integer type whose decimal representation is written.
    public typealias Output = T

    /// The `ASCII.Code` buffer the decimal digits are appended to.
    public typealias Buffer = [ASCII.Code]

    /// The failure type; decimal serialization never fails.
    public typealias Failure = Never

    /// Appends the decimal ASCII digits of `output` to `buffer`.
    ///
    /// `0` is written as the single digit `'0'`; negative signed values are
    /// prefixed with `'-'` and their magnitude is written.
    ///
    /// - Parameters:
    ///   - output: The integer to serialize as decimal digits.
    ///   - buffer: The `ASCII.Code` buffer to append the digits to.
    @inlinable
    public func serialize(_ output: T, into buffer: inout [ASCII.Code]) {
        guard output != 0 else {
            buffer.append(ASCII.Code(0x30))
            return
        }

        var value = output
        let negative = T.isSigned && output < 0

        // Stack-allocated digit buffer: max 20 digits for Int64 + sign
        let start = buffer.count

        if negative {
            // Work with magnitude to avoid overflow on T.min
            var magnitude = UInt64(bitPattern: Int64(truncatingIfNeeded: output))
            magnitude = ~magnitude &+ 1
            while magnitude > 0 {
                buffer.append(ASCII.Code(UInt8(truncatingIfNeeded: magnitude % 10) &+ 0x30))
                magnitude /= 10
            }
            buffer.append(ASCII.Code(0x2D))  // '-'
        } else {
            while value > 0 {
                buffer.append(ASCII.Code(UInt8(truncatingIfNeeded: value % 10) &+ 0x30))
                value /= 10
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
}
