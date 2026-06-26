import ASCII_Primitives
import Serializable_Integer_Primitives
import Testing

@Suite("Serializable Integer Conformances")
struct SerializableIntegerTests {
    @Test
    func `Int serializes via Serializable`() {
        let codes = Int(42).asciiCodes
        #expect(codes == "42".utf8.map(ASCII.Code.init))
    }

    @Test
    func `UInt serializes via Serializable`() {
        let codes = UInt(100).asciiCodes
        #expect(codes == "100".utf8.map(ASCII.Code.init))
    }

    @Test
    func `Int8 serializes via Serializable`() {
        let codes = Int8(-128).asciiCodes
        #expect(codes == "-128".utf8.map(ASCII.Code.init))
    }

    @Test
    func `UInt8 serializes via Serializable`() {
        let codes = UInt8(255).asciiCodes
        #expect(codes == "255".utf8.map(ASCII.Code.init))
    }

    @Test
    func `Int16 serializes via Serializable`() {
        let codes = Int16(-1).asciiCodes
        #expect(codes == "-1".utf8.map(ASCII.Code.init))
    }

    @Test
    func `UInt16 serializes via Serializable`() {
        let codes = UInt16(8080).asciiCodes
        #expect(codes == "8080".utf8.map(ASCII.Code.init))
    }

    @Test
    func `Int32 serializes via Serializable`() {
        let codes = Int32(0).asciiCodes
        #expect(codes == "0".utf8.map(ASCII.Code.init))
    }

    @Test
    func `UInt32 serializes via Serializable`() {
        let codes = UInt32(1_000_000).asciiCodes
        #expect(codes == "1000000".utf8.map(ASCII.Code.init))
    }

    @Test
    func `Int64 serializes via Serializable`() {
        let codes = Int64.min.asciiCodes
        #expect(codes == "-9223372036854775808".utf8.map(ASCII.Code.init))
    }

    @Test
    func `UInt64 serializes via Serializable`() {
        let codes = UInt64.max.asciiCodes
        #expect(codes == "18446744073709551615".utf8.map(ASCII.Code.init))
    }
}
