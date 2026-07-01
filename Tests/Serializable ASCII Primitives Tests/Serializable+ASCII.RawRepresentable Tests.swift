// Serializable+ASCII.RawRepresentable Tests.swift
// swift-ascii-serializer-primitives
//
// Exercises the FLAT RawRepresentable-backed default for `ASCII.Serializable`.
// A `Swift.RawRepresentable` conformer whose RawValue is `String` or `[Byte]`
// needs only the conformance declarations (~2–3 lines) to inherit the format
// verb `serialize(_:into:)` — and through it the `.serialized: [Byte]` and
// `asciiCodes: [ASCII.Code]` accessors — with no `serialize` written.
//
// Byte-equivalence: the flat default's output is asserted to equal the direct
// rawValue projection (`String → .utf8`, `[Byte]` directly) that the retired
// `ASCII.RawRepresentable.Serializer` bridge produced — proving the re-cut did
// not change any output byte.
//
// NOTE — the `Binary.Serializable` bridge for these RawRepresentable conformers
// is NOT exercised here: declaring `Binary.Serializable` on a RawRepresentable +
// ASCII.Serializable type collides with binary-serializer-primitives' own
// pre-existing RawRepresentable `Binary.Serializable` defaults. Both supply
// `serialize(_:into:)` and produce identical bytes, so Swift reports a witness
// ambiguity — surfaced for a design decision rather than resolved by guessing.

import Testing

import ASCII_Primitives
import Serializable_ASCII_Primitives

// MARK: - Fixtures
//
// `Command` is the headline ~3-line conformer: a String-raw-value enum that
// gains the full ASCII write-side surface from its conformance declarations
// (`ASCII.Serializable` on a `RawRepresentable` type) — the flat default
// provides `serialize`, none is written here.

enum Command: String, ASCII.Serializable {
    case ok = "OK"
}

// `Frame` exercises the `[Byte]` RawValue default — a struct wrapping raw bytes.

struct Frame: Swift.RawRepresentable, ASCII.Serializable {
    let rawValue: [Byte]
    init(rawValue: [Byte]) { self.rawValue = rawValue }
}

// MARK: - Demonstration (String RawValue)

extension Command {
    @Suite struct Test {
        @Suite struct Unit {}
    }
}

extension Command.Test.Unit {
    @Test
    func `serialized projects the String rawValue's UTF-8 bytes`() {
        #expect(Command.ok.serialized == [0x4F, 0x4B])  // "OK"
    }

    @Test
    func `asciiCodes projects the String rawValue to ASCII codes`() {
        #expect(Command.ok.asciiCodes == [0x4F, 0x4B])
    }

    @Test
    func `flat default output equals the rawValue UTF-8 projection`() {
        let value = Command.ok
        // The retired serializer bridge's projection: rawValue.utf8 -> ASCII.Code.
        let expected = value.rawValue.utf8.map { ASCII.Code($0) }
        #expect(value.asciiCodes == expected)
    }
}

// MARK: - Demonstration ([Byte] RawValue)

extension Frame {
    @Suite struct Test {
        @Suite struct Unit {}
    }
}

extension Frame.Test.Unit {
    @Test
    func `serialized projects the [Byte] rawValue`() {
        #expect(Frame(rawValue: [0x3E, 0x4F, 0x4B]).serialized == [0x3E, 0x4F, 0x4B])
    }

    @Test
    func `asciiCodes projects the [Byte] rawValue to ASCII codes`() {
        #expect(Frame(rawValue: [0x3E, 0x4F, 0x4B]).asciiCodes == [0x3E, 0x4F, 0x4B])
    }

    @Test
    func `flat default output equals the rawValue byte projection`() {
        let value = Frame(rawValue: [0x3E, 0x4F, 0x4B])
        // The retired serializer bridge's projection: each [Byte] -> ASCII.Code.
        let expected = value.rawValue.map { ASCII.Code(unchecked: $0) }
        #expect(value.asciiCodes == expected)
    }
}
