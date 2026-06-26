// Binary.ASCII.Wrapper.swift
// swift-ascii-serializer-primitives
//
// Wrapper for ASCII serializable types providing instance-level access.

extension Binary.ASCII {
    /// An instance-level handle that exposes ASCII serialization for a wrapped value.
    public struct Wrapper<Wrapped: Binary.ASCII.Serializable>: Sendable where Wrapped: Sendable {
        /// The wrapped serializable value.
        public let wrapped: Wrapped

        @inlinable
        init(_ wrapped: Wrapped) {
            self.wrapped = wrapped
        }
    }
}

// MARK: - Wrapper Serialization Methods

extension Binary.ASCII.Wrapper {
    /// Serializes the wrapped value as ASCII bytes into `buffer`.
    ///
    /// - Parameter buffer: The byte buffer to append the serialized bytes to.
    @inlinable
    public func serialize<Buffer: RangeReplaceableCollection>(
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        Wrapped.serialize(ascii: wrapped, into: &buffer)
    }

    /// The wrapped value's ASCII serialization as a `[Byte]` array.
    @inlinable
    public var bytes: [Byte] {
        var buffer: [Byte] = []
        serialize(into: &buffer)
        return buffer
    }

    /// Serializes the wrapped value and passes its bytes to `body` as a borrowed `Span`.
    ///
    /// The span is valid only for the duration of `body`.
    ///
    /// - Parameter body: A closure receiving the serialized bytes as a borrowed `Span`.
    /// - Throws: Any error thrown by `body`.
    /// - Returns: The value returned by `body`.
    @inlinable
    public func withSerializedBytes<R, E: Swift.Error>(
        _ body: (borrowing Swift.Span<Byte>) throws(E) -> R
    ) throws(E) -> R {
        var buffer: ContiguousArray<Byte> = []
        Wrapped.serialize(ascii: wrapped, into: &buffer)
        let result: Result<R, E> = unsafe buffer.withUnsafeBufferPointer { bufferPointer in
            let span = unsafe Span(_unsafeElements: bufferPointer)
            do throws(E) {
                return .success(try body(span))
            } catch {
                return .failure(error)
            }
        }
        return try result.get()
    }
}

extension Binary.ASCII.Wrapper: CustomStringConvertible {
    /// The wrapped value's ASCII serialization decoded as a UTF-8 `String`.
    @inlinable
    public var description: String {
        String(decoding: bytes, as: UTF8.self)
    }
}

// MARK: - Serializable Extension

extension Binary.ASCII.Serializable where Self: Sendable {
    /// An ASCII serialization handle wrapping this value.
    @inlinable
    public var ascii: Binary.ASCII.Wrapper<Self> {
        Binary.ASCII.Wrapper(self)
    }
}
