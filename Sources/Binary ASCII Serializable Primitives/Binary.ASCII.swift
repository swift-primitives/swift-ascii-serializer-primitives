// Binary.ASCII.swift
// swift-ascii-serializer-primitives
//
// ASCII operations namespace for UInt8.

extension Binary {
    /// ASCII operations namespace for UInt8
    ///
    /// Provides all ASCII character classification, manipulation, and constant access methods
    /// for byte-level operations per INCITS 4-1986 (US-ASCII standard).
    ///
    /// ## Access Patterns
    ///
    /// - **Static**: `UInt8.ascii.A` - For constants and static methods
    /// - **Instance**: `byte.ascii.isLetter` - For instance classification
    public struct ASCII {
        /// The wrapped byte value
        public let byte: UInt8
    }
}
