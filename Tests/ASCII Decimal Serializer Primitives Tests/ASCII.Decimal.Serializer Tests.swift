import ASCII_Decimal_Serializer_Primitives
import ASCII_Primitives
import Testing

@Suite("ASCII.Decimal.Serializer")
struct ASCIIDecimalSerializerTests {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
}

// MARK: - Unit Tests

extension ASCIIDecimalSerializerTests.Unit {
    @Test
    func `serializes zero`() {
        let serializer = ASCII.Decimal.Serializer<UInt8>()
        let codes = serializer.serialize(0)
        #expect(codes == [ASCII.Code(0x30)])
    }

    @Test
    func `serializes single digit`() {
        let serializer = ASCII.Decimal.Serializer<UInt8>()
        let codes = serializer.serialize(7)
        #expect(codes == [ASCII.Code(0x37)])
    }

    @Test
    func `serializes multi-digit`() {
        let serializer = ASCII.Decimal.Serializer<UInt16>()
        let codes = serializer.serialize(8080)
        #expect(codes == [ASCII.Code(0x38), ASCII.Code(0x30), ASCII.Code(0x38), ASCII.Code(0x30)])
    }

    @Test
    func `serializes into existing buffer`() {
        let serializer = ASCII.Decimal.Serializer<UInt8>()
        var buffer: [ASCII.Code] = [ASCII.Code(0x41), ASCII.Code(0x42)]  // "AB"
        serializer.serialize(42, into: &buffer)
        #expect(buffer == [ASCII.Code(0x41), ASCII.Code(0x42), ASCII.Code(0x34), ASCII.Code(0x32)])
    }

    @Test
    func `serializes negative`() {
        let serializer = ASCII.Decimal.Serializer<Int8>()
        let codes = serializer.serialize(-1)
        #expect(codes == [ASCII.Code(0x2D), ASCII.Code(0x31)])  // "-1"
    }
}

// MARK: - Edge Cases

extension ASCIIDecimalSerializerTests.EdgeCase {
    @Test
    func `serializes UInt8 max`() {
        let serializer = ASCII.Decimal.Serializer<UInt8>()
        let codes = serializer.serialize(.max)
        #expect(codes == "255".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes UInt64 max`() {
        let serializer = ASCII.Decimal.Serializer<UInt64>()
        let codes = serializer.serialize(.max)
        #expect(codes == "18446744073709551615".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes Int64 min`() {
        let serializer = ASCII.Decimal.Serializer<Int64>()
        let codes = serializer.serialize(.min)
        #expect(codes == "-9223372036854775808".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes Int8 min`() {
        let serializer = ASCII.Decimal.Serializer<Int8>()
        let codes = serializer.serialize(.min)
        #expect(codes == "-128".utf8.map(ASCII.Code.init))
    }
}
