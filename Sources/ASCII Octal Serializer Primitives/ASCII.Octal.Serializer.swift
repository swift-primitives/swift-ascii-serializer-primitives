//
//  ASCII.Octal.Serializer.swift
//  swift-ascii-serializer-primitives
//
//  Serializes a FixedWidthInteger as ASCII octal bytes.
//

extension ASCII.Octal {
    /// A serializer that writes the octal ASCII representation of a
    /// `FixedWidthInteger` into a byte buffer.
    ///
    /// Inverse of `ASCII.Octal.Parser`.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let serializer = ASCII.Octal.Serializer<UInt8>()
    /// let bytes = serializer.serialize(15)  // [0x31, 0x37]  "17"
    /// ```
    public struct Serializer<T: FixedWidthInteger>: Sendable {
        /// Creates an octal serializer for `T`.
        @inlinable
        public init() {}
    }
}

extension ASCII.Octal.Serializer: Serializer.`Protocol` {
    /// The integer type whose octal representation is written.
    public typealias Output = T

    /// The `ASCII.Code` buffer the octal digits are appended to.
    public typealias Buffer = [ASCII.Code]

    /// The failure type; octal serialization never fails.
    public typealias Failure = Never

    /// Appends the octal ASCII digits of `output` to `buffer`.
    ///
    /// `0` is written as the single digit `'0'`; negative signed values are
    /// prefixed with `'-'` and their magnitude is written.
    ///
    /// - Parameters:
    ///   - output: The integer to serialize as octal digits.
    ///   - buffer: The `ASCII.Code` buffer to append the digits to.
    @inlinable
    public func serialize(_ output: T, into buffer: inout [ASCII.Code]) {
        guard output != 0 else {
            buffer.append(ASCII.Code(0x30))
            return
        }

        var value = output
        let negative = T.isSigned && output < 0

        let start = buffer.count

        if negative {
            // Work with magnitude to avoid overflow on T.min
            var magnitude = UInt64(bitPattern: Int64(truncatingIfNeeded: output))
            magnitude = ~magnitude &+ 1
            while magnitude > 0 {
                buffer.append(ASCII.Code(UInt8(truncatingIfNeeded: magnitude % 8) &+ 0x30))
                magnitude /= 8
            }
            buffer.append(ASCII.Code(0x2D))  // '-'
        } else {
            while value > 0 {
                buffer.append(ASCII.Code(UInt8(truncatingIfNeeded: value % 8) &+ 0x30))
                value /= 8
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
