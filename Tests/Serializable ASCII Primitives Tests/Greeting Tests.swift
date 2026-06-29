// Greeting Tests.swift
// swift-ascii-serializer-primitives
//
// Wave-0 demonstration of the ASCII.Serializable write-side surface, exercised
// through a synthetic `Greeting` fixture (a value that serializes to a fixed
// run of ASCII codes). Demonstrates: the flat `ASCII.Serializable` marker, the
// `.serialized: [Byte]` accessor, `RangeReplaceableCollection.append(serialized:)`,
// and the `Binary.Serializable` bridge.

import Testing

import ASCII_Primitives
import Binary_Serializable_Primitives
import Serializable_ASCII_Primitives
import Serializer_Primitives

// MARK: - Fixture

struct Greeting: Sendable {
    let codes: [ASCII.Code]
}

extension Greeting {
    struct Serializer: Sendable {
        @inlinable
        init() {}
    }
}

extension Greeting.Serializer: Serializer.`Protocol` {
    typealias Output = Greeting
    typealias Buffer = [ASCII.Code]
    typealias Failure = Never
    typealias Body = Never

    func serialize(_ output: Greeting, into buffer: inout [ASCII.Code]) {
        buffer.append(contentsOf: output.codes)
    }
}

extension Greeting: Serializable {
    static var serializer: Serializer { Serializer() }
}

extension Greeting: ASCII.Serializable {}

// The witness comes from the Wave-0 `Binary.Serializable` bridge — no explicit
// `serialize(_:into:)` is written here.
extension Greeting: Binary.Serializable {}

// MARK: - Demonstration

extension Greeting {
    @Suite struct Test {
        @Suite struct Unit {}
    }
}

extension Greeting.Test.Unit {
    @Test
    func `serialized projects ascii codes to bytes`() {
        let greeting = Greeting(codes: [0x4F, 0x4B])  // "OK"
        #expect(greeting.serialized == [0x4F, 0x4B])
    }

    @Test
    func `append(serialized:) appends the serialized bytes`() {
        var buffer: [Byte] = [0x3E]  // ">"
        buffer.append(serialized: Greeting(codes: [0x4F, 0x4B]))
        #expect(buffer == [0x3E, 0x4F, 0x4B])
    }

    @Test
    func `binary serializable bridge yields ascii bytes`() {
        let greeting = Greeting(codes: [0x4F, 0x4B])
        #expect([Byte](greeting) == [0x4F, 0x4B])
    }
}
