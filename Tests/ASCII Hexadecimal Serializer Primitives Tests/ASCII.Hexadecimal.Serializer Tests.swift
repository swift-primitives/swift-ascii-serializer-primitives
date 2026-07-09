import ASCII_Hexadecimal_Serializer_Primitives
import ASCII_Primitives
import Testing

@Suite
struct `ASCII.Hexadecimal.Serializer Tests` {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
}

// MARK: - Unit Tests

extension `ASCII.Hexadecimal.Serializer Tests`.Unit {
    @Test
    func `serializes zero`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let codes = serializer.serialize(0)
        #expect(codes == [ASCII.Code(0x30)])
    }

    @Test
    func `serializes single digit`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let codes = serializer.serialize(0xA)
        #expect(codes == [ASCII.Code(0x61)])  // "a"
    }

    @Test
    func `serializes multi-digit`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt32>()
        let codes = serializer.serialize(0xDEAD)
        #expect(codes == "dead".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes into existing buffer`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        var buffer: [ASCII.Code] = [ASCII.Code(0x41), ASCII.Code(0x42)]  // "AB"
        serializer.serialize(0xFF, into: &buffer)
        #expect(buffer == [ASCII.Code(0x41), ASCII.Code(0x42), ASCII.Code(0x66), ASCII.Code(0x66)])  // "AB" + "ff"
    }

    @Test
    func `serializes negative`() {
        let serializer = ASCII.Hexadecimal.Serializer<Int8>()
        let codes = serializer.serialize(-1)
        #expect(codes == [ASCII.Code(0x2D), ASCII.Code(0x31)])  // "-1"
    }

    @Test
    func `uses lowercase letters`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let codes = serializer.serialize(0xAB)
        #expect(codes == "ab".utf8.map(ASCII.Code.init))
    }
}

// MARK: - Edge Cases

extension `ASCII.Hexadecimal.Serializer Tests`.EdgeCase {
    @Test
    func `serializes UInt8 max`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let codes = serializer.serialize(.max)
        #expect(codes == "ff".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes UInt64 max`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt64>()
        let codes = serializer.serialize(.max)
        #expect(codes == "ffffffffffffffff".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes Int64 min`() {
        let serializer = ASCII.Hexadecimal.Serializer<Int64>()
        let codes = serializer.serialize(.min)
        #expect(codes == "-8000000000000000".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes Int8 min`() {
        let serializer = ASCII.Hexadecimal.Serializer<Int8>()
        let codes = serializer.serialize(.min)
        #expect(codes == "-80".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes power of 16`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt32>()
        let codes = serializer.serialize(256)  // 0x100
        #expect(codes == "100".utf8.map(ASCII.Code.init))
    }
}
