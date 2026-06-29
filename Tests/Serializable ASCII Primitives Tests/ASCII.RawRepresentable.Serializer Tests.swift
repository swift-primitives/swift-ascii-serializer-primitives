// ASCII.RawRepresentable.Serializer Tests.swift
// swift-ascii-serializer-primitives
//
// Wave-0 demonstration of the option-(B) RawRepresentable-backed default ASCII
// serializer. A `Swift.RawRepresentable` conformer whose RawValue is `String`
// or `[Byte]` needs only the conformance declarations (~2–3 lines) to inherit
// the canonical `serializer` — and through it the `.serialized: [Byte]` and
// `asciiCodes: [ASCII.Code]` accessors — with no `serialize` written.
//
// NOTE — the `Binary.Serializable` bridge for these RawRepresentable conformers
// is NOT exercised here: declaring `Binary.Serializable` on a RawRepresentable +
// ASCII.Serializable type collides with binary-serializer-primitives' own
// pre-existing RawRepresentable `Binary.Serializable` defaults
// (Binary.Serializable.swift:195/208/220). Both supply `serialize(_:into:)` and
// produce identical bytes, so Swift reports a witness ambiguity. Surfaced for a
// design decision (see the Wave-0 return) rather than resolved by guessing.

import Testing

import ASCII_Primitives
import Serializable_ASCII_Primitives
import Serializer_Primitives

// MARK: - Fixtures
//
// `Command` is the headline ~3-line conformer: a String-raw-value enum that
// gains the full ASCII write-side surface from its conformance declarations
// (`Serializable`, `ASCII.Serializable`) — the default `serializer` is
// inherited, no `serialize` is written here.

enum Command: String, Serializable, ASCII.Serializable {
    case ok = "OK"
}

// `Frame` exercises the `[Byte]` RawValue default — a struct wrapping raw bytes.

struct Frame: Swift.RawRepresentable, Serializable, ASCII.Serializable {
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
}
