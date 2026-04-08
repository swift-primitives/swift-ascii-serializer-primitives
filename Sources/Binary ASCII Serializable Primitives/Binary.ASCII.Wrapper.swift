// Binary.ASCII.Wrapper.swift
// swift-ascii-serializer-primitives
//
// Wrapper for ASCII serializable types providing instance-level access.

extension Binary.ASCII {
    public struct Wrapper<Wrapped: Binary.ASCII.Serializable>: Sendable where Wrapped: Sendable {
        public let wrapped: Wrapped

        @inlinable
        init(_ wrapped: Wrapped) {
            self.wrapped = wrapped
        }
    }
}

// MARK: - Wrapper Serialization Methods

extension Binary.ASCII.Wrapper {
    @inlinable
    public func serialize<Buffer: RangeReplaceableCollection>(
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        Wrapped.serialize(ascii: wrapped, into: &buffer)
    }

    @inlinable
    public var bytes: [UInt8] {
        var buffer: [UInt8] = []
        serialize(into: &buffer)
        return buffer
    }

    @inlinable
    public func withSerializedBytes<R, E: Error>(
        _ body: (borrowing Span<UInt8>) throws(E) -> R
    ) throws(E) -> R {
        var buffer: ContiguousArray<UInt8> = []
        Wrapped.serialize(ascii: wrapped, into: &buffer)
        var result: Result<R, E>!
        unsafe buffer.withUnsafeBufferPointer { bufferPointer in
            let span = unsafe Span(_unsafeElements: bufferPointer)
            do throws(E) {
                result = .success(try body(span))
            } catch {
                result = .failure(error)
            }
        }
        return try result.get()
    }
}

extension Binary.ASCII.Wrapper: CustomStringConvertible {
    @inlinable
    public var description: String {
        String(decoding: bytes, as: UTF8.self)
    }
}

// MARK: - Serializable Extension

extension Binary.ASCII.Serializable where Self: Sendable {
    @inlinable
    public var ascii: Binary.ASCII.Wrapper<Self> {
        Binary.ASCII.Wrapper(self)
    }
}
