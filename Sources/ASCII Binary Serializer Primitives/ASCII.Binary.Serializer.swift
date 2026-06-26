//
//  ASCII.Binary.Serializer.swift
//  swift-ascii-serializer-primitives
//
//  Serializes a FixedWidthInteger as ASCII binary bytes.
//

extension ASCII.Binary {
    /// A serializer that writes the binary ASCII representation of a
    /// `FixedWidthInteger` into a byte buffer.
    ///
    /// Inverse of `ASCII.Binary.Parser`.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let serializer = ASCII.Binary.Serializer<UInt8>()
    /// let bytes = serializer.serialize(11)  // [0x31, 0x30, 0x31, 0x31]  "1011"
    /// ```
    public struct Serializer<T: FixedWidthInteger>: Sendable {
        /// Creates a binary serializer for `T`.
        @inlinable
        public init() {}
    }
}

extension ASCII.Binary.Serializer: Serializer.`Protocol` {
    /// The integer type whose binary representation is written.
    public typealias Output = T

    /// The `ASCII.Code` buffer the binary digits are appended to.
    public typealias Buffer = [ASCII.Code]

    /// The failure type; binary serialization never fails.
    public typealias Failure = Never

    /// Appends the binary ASCII digits of `output` to `buffer`.
    ///
    /// `0` is written as the single digit `'0'`; negative signed values are
    /// prefixed with `'-'` and their magnitude is written.
    ///
    /// - Parameters:
    ///   - output: The integer to serialize as binary digits.
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
                buffer.append(ASCII.Code(UInt8(truncatingIfNeeded: magnitude % 2) &+ 0x30))
                magnitude /= 2
            }
            buffer.append(ASCII.Code(0x2D))  // '-'
        } else {
            while value > 0 {
                buffer.append(ASCII.Code(UInt8(truncatingIfNeeded: value % 2) &+ 0x30))
                value /= 2
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
