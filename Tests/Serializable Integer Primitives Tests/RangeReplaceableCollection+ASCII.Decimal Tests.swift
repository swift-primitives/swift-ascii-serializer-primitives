import ASCII_Primitives
import Serializable_Integer_Primitives
import Testing

// Coverage for the `append(contentsOf: FixedWidthInteger)` convenience over
// `ASCII.Decimal.Serializer` (relocated from swift-byte-primitives' Numeric+Byte).

@Suite
struct `RangeReplaceableCollection+ASCII.Decimal Tests` {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
}

extension `RangeReplaceableCollection+ASCII.Decimal Tests`.Unit {
    @Test
    func `appends small positive integer as ASCII decimal digits`() {
        var buffer: [ASCII.Code] = []
        buffer.append(contentsOf: 42)
        #expect(buffer == "42".utf8.map(ASCII.Code.init))
    }

    @Test
    func `appends multi-digit integer`() {
        var buffer: [ASCII.Code] = []
        buffer.append(contentsOf: 1024)
        #expect(buffer == "1024".utf8.map(ASCII.Code.init))
    }

    @Test
    func `appends negative integer with leading minus`() {
        var buffer: [ASCII.Code] = []
        buffer.append(contentsOf: -7)
        #expect(buffer == "-7".utf8.map(ASCII.Code.init))
    }

    @Test
    func `appends onto an existing buffer without clobbering`() {
        var buffer: [ASCII.Code] = [ASCII.Code(0x41)]  // "A"
        buffer.append(contentsOf: 5)
        #expect(buffer == "A5".utf8.map(ASCII.Code.init))
    }
}

extension `RangeReplaceableCollection+ASCII.Decimal Tests`.EdgeCase {
    @Test
    func `appends zero as a single '0'`() {
        var buffer: [ASCII.Code] = []
        buffer.append(contentsOf: 0)
        #expect(buffer == [ASCII.Code(0x30)])
    }

    @Test
    func `appends Int64 min`() {
        var buffer: [ASCII.Code] = []
        buffer.append(contentsOf: Int64.min)
        #expect(buffer == "-9223372036854775808".utf8.map(ASCII.Code.init))
    }

    @Test
    func `appends UInt64 max`() {
        var buffer: [ASCII.Code] = []
        buffer.append(contentsOf: UInt64.max)
        #expect(buffer == "18446744073709551615".utf8.map(ASCII.Code.init))
    }
}
