// ASCII.Serializable+TransitionalDefault.swift
// swift-ascii-serializer-primitives
//
// TRANSITIONAL — delete at the end of the [FAM-012] conformer cascade (Phase D).
//
// Bridges conformers that still attach their ASCII serialization via the
// canonical `static var serializer` (with `Serializer.Buffer == [ASCII.Code]`)
// so they satisfy the new `ASCII.Serializable` static verb WITHOUT a
// per-conformer edit until they are re-cut. Each re-cut conformer provides its
// own `serialize(_:into:)` verb, which overrides this default. Once every
// conformer carries its own verb and the canonical operational tier is retired,
// this file is removed.

public import ASCII_Primitives
public import Serializer_Primitives

extension ASCII.Serializable
where
    Self: Serializable,
    Self.Serializer.Buffer == [ASCII.Code],
    Self.Serializer.Output == Self
{
    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ serializable: borrowing Self,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        var codes: [ASCII.Code] = []
        do throws(Self.Serializer.Failure) {
            try Self.serializer.serialize(serializable, into: &codes)
        } catch {
            preconditionFailure("ASCII serialization unexpectedly failed: \(error)")
        }
        buffer.append(contentsOf: codes)
    }
}
