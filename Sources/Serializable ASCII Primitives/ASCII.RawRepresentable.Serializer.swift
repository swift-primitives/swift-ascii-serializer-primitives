// ASCII.RawRepresentable.Serializer.swift
// swift-ascii-serializer-primitives
//
// Generic ASCII serializer witness for `Swift.RawRepresentable` conformers
// whose `RawValue` is `String` or `[Byte]`. Closure-backed leaf witness
// (mirrors `Serializer.Witness`): the stored projection appends the rawValue's
// bytes to an `[ASCII.Code]` buffer. The default `serializer` accessors in
// `Serializable+ASCII.RawRepresentable.swift` construct it with the right
// projection per RawValue kind. [PRIM-FOUND-004]-clean (byte domain only).

public import ASCII_Primitives
public import Serializer_Primitives

extension ASCII.RawRepresentable {
    /// A serializer that writes a `Swift.RawRepresentable` value's `rawValue`
    /// bytes into an `[ASCII.Code]` buffer.
    ///
    /// Closure-backed leaf witness: the stored projection knows how to turn the
    /// conformer's `rawValue` (`String` via `.utf8`, or `[Byte]` directly) into
    /// appended `ASCII.Code` values. Obtain it via the `static var serializer`
    /// default on `Serializable` — conformers do not construct it directly.
    public struct Serializer<Output> {
        /// The stored projection — appends `output`'s ASCII codes to the buffer.
        ///
        /// The underscore signals an implementation hatch — call
        /// ``serialize(_:into:)`` instead of invoking the closure directly.
        @usableFromInline
        let _serialize: (Output, inout [ASCII.Code]) -> Void

        /// Creates a serializer from a rawValue-to-`[ASCII.Code]` projection.
        @inlinable
        public init(_ serialize: @escaping (Output, inout [ASCII.Code]) -> Void) {
            self._serialize = serialize
        }
    }
}

extension ASCII.RawRepresentable.Serializer: Serializer.`Protocol` {
    /// The `ASCII.Code` buffer the projected rawValue bytes are appended to.
    public typealias Buffer = [ASCII.Code]

    /// The failure type; rawValue projection never fails.
    public typealias Failure = Never

    /// Leaf serializer — no composed body.
    public typealias Body = Never

    /// Appends `output`'s rawValue, projected to `ASCII.Code`, to `buffer`.
    @inlinable
    public func serialize(_ output: Output, into buffer: inout [ASCII.Code]) {
        _serialize(output, &buffer)
    }
}
