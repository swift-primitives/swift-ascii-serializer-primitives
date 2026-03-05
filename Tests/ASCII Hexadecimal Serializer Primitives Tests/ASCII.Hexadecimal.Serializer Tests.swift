import Testing
import ASCII_Hexadecimal_Serializer_Primitives

@Suite("ASCII.Hexadecimal.Serializer")
struct ASCIIHexadecimalSerializerTests {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
}

// MARK: - Unit Tests

extension ASCIIHexadecimalSerializerTests.Unit {
    @Test
    func `serializes zero`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let bytes = serializer.serialize(0)
        #expect(bytes == [0x30])
    }

    @Test
    func `serializes single digit`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let bytes = serializer.serialize(0xA)
        #expect(bytes == [0x61]) // "a"
    }

    @Test
    func `serializes multi-digit`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt32>()
        let bytes = serializer.serialize(0xDEAD)
        #expect(bytes == Array("dead".utf8))
    }

    @Test
    func `serializes into existing buffer`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        var buffer: [UInt8] = [0x41, 0x42] // "AB"
        serializer.serialize(0xFF, into: &buffer)
        #expect(buffer == [0x41, 0x42, 0x66, 0x66]) // "AB" + "ff"
    }

    @Test
    func `serializes negative`() {
        let serializer = ASCII.Hexadecimal.Serializer<Int8>()
        let bytes = serializer.serialize(-1)
        #expect(bytes == [0x2D, 0x31]) // "-1"
    }

    @Test
    func `uses lowercase letters`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let bytes = serializer.serialize(0xAB)
        #expect(bytes == Array("ab".utf8))
    }
}

// MARK: - Edge Cases

extension ASCIIHexadecimalSerializerTests.EdgeCase {
    @Test
    func `serializes UInt8 max`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let bytes = serializer.serialize(.max)
        #expect(bytes == Array("ff".utf8))
    }

    @Test
    func `serializes UInt64 max`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt64>()
        let bytes = serializer.serialize(.max)
        #expect(bytes == Array("ffffffffffffffff".utf8))
    }

    @Test
    func `serializes Int64 min`() {
        let serializer = ASCII.Hexadecimal.Serializer<Int64>()
        let bytes = serializer.serialize(.min)
        #expect(bytes == Array("-8000000000000000".utf8))
    }

    @Test
    func `serializes Int8 min`() {
        let serializer = ASCII.Hexadecimal.Serializer<Int8>()
        let bytes = serializer.serialize(.min)
        #expect(bytes == Array("-80".utf8))
    }

    @Test
    func `serializes power of 16`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt32>()
        let bytes = serializer.serialize(256) // 0x100
        #expect(bytes == Array("100".utf8))
    }
}
