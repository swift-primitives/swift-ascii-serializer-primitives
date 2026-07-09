// Greeting Tests.swift
// swift-ascii-serializer-primitives
//
// Wave-0 demonstration of the ASCII.Serializable write-side surface, exercised
// through a synthetic `Greeting` fixture (a value that serializes to a fixed
// run of ASCII codes). Demonstrates: the flat `ASCII.Serializable` verb, the
// `.serialized: [Byte]` accessor, `RangeReplaceableCollection.append(serialized:)`,
// and an explicit `Binary.Serializable` peer verb (ASCII+Binary peer model).

import ASCII_Primitives
import Binary_Serializable_Primitives
import Serializable_ASCII_Primitives
import Serializer_Primitives
import Testing

// MARK: - Fixture

struct Greeting: Sendable {
    let codes: [ASCII.Code]
}

extension Greeting {
    struct Serializer: Sendable {
        @inlinable
        package init() {}
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

// Greeting is NOT `RawRepresentable`, so the flat RawRepresentable default does
// not auto-cover it — it carries its own flat `ASCII.Serializable` verb,
// inlining the serializer body (append the fixed run of codes).
extension Greeting: ASCII.Serializable {
    static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Greeting,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        buffer.append(contentsOf: value.codes)
    }
}

// Greeting also has a wire (binary) form: it conforms `Binary.Serializable` as
// an ordinary peer of `ASCII.Serializable` (explicit ASCII+Binary peer model —
// no ASCII→binary derivation bridge; that wire-from-text bridge was retired in
// d8f2a0b as the correctness bug for multi-representation types). The verb is a
// direct clause-9 composition: project each `ASCII.Code` to its `Byte`.
extension Greeting: Binary.Serializable {
    static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Greeting,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: value.codes.map(\.byte))
    }
}

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
