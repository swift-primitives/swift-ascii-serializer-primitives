import ASCII_Octal_Serializer_Primitives
import ASCII_Primitives
import Testing

@Suite
struct `ASCII.Octal.Serializer Tests` {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
}

// MARK: - Unit Tests

extension `ASCII.Octal.Serializer Tests`.Unit {
    @Test
    func `serializes zero`() {
        let serializer = ASCII.Octal.Serializer<UInt8>()
        let codes = serializer.serialize(0)
        #expect(codes == [ASCII.Code(0x30)])
    }

    @Test
    func `serializes single digit`() {
        let serializer = ASCII.Octal.Serializer<UInt8>()
        let codes = serializer.serialize(7)
        #expect(codes == [ASCII.Code(0x37)])  // "7"
    }

    @Test
    func `serializes multi-digit`() {
        let serializer = ASCII.Octal.Serializer<UInt8>()
        let codes = serializer.serialize(15)
        #expect(codes == "17".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes into existing buffer`() {
        let serializer = ASCII.Octal.Serializer<UInt8>()
        var buffer: [ASCII.Code] = [ASCII.Code(0x41), ASCII.Code(0x42)]  // "AB"
        serializer.serialize(15, into: &buffer)
        #expect(buffer == "AB17".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes negative`() {
        let serializer = ASCII.Octal.Serializer<Int8>()
        let codes = serializer.serialize(-1)
        #expect(codes == [ASCII.Code(0x2D), ASCII.Code(0x31)])  // "-1"
    }
}

// MARK: - Edge Cases

extension `ASCII.Octal.Serializer Tests`.EdgeCase {
    @Test
    func `serializes UInt8 max`() {
        let serializer = ASCII.Octal.Serializer<UInt8>()
        let codes = serializer.serialize(.max)
        #expect(codes == "377".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes UInt64 max`() {
        let serializer = ASCII.Octal.Serializer<UInt64>()
        let codes = serializer.serialize(.max)
        #expect(codes == "1777777777777777777777".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes Int8 min`() {
        let serializer = ASCII.Octal.Serializer<Int8>()
        let codes = serializer.serialize(.min)
        #expect(codes == "-200".utf8.map(ASCII.Code.init))
    }
}
