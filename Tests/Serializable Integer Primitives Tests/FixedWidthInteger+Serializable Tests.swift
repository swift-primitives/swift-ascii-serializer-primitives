import Testing
import Serializable_Integer_Primitives

@Suite("Serializable Integer Conformances")
struct SerializableIntegerTests {
    @Test
    func `Int serializes via Serializable`() {
        let bytes = Int(42).asciiBytes
        #expect(bytes == Array("42".utf8))
    }

    @Test
    func `UInt serializes via Serializable`() {
        let bytes = UInt(100).asciiBytes
        #expect(bytes == Array("100".utf8))
    }

    @Test
    func `Int8 serializes via Serializable`() {
        let bytes = Int8(-128).asciiBytes
        #expect(bytes == Array("-128".utf8))
    }

    @Test
    func `UInt8 serializes via Serializable`() {
        let bytes = UInt8(255).asciiBytes
        #expect(bytes == Array("255".utf8))
    }

    @Test
    func `Int16 serializes via Serializable`() {
        let bytes = Int16(-1).asciiBytes
        #expect(bytes == Array("-1".utf8))
    }

    @Test
    func `UInt16 serializes via Serializable`() {
        let bytes = UInt16(8080).asciiBytes
        #expect(bytes == Array("8080".utf8))
    }

    @Test
    func `Int32 serializes via Serializable`() {
        let bytes = Int32(0).asciiBytes
        #expect(bytes == Array("0".utf8))
    }

    @Test
    func `UInt32 serializes via Serializable`() {
        let bytes = UInt32(1_000_000).asciiBytes
        #expect(bytes == Array("1000000".utf8))
    }

    @Test
    func `Int64 serializes via Serializable`() {
        let bytes = Int64.min.asciiBytes
        #expect(bytes == Array("-9223372036854775808".utf8))
    }

    @Test
    func `UInt64 serializes via Serializable`() {
        let bytes = UInt64.max.asciiBytes
        #expect(bytes == Array("18446744073709551615".utf8))
    }
}
