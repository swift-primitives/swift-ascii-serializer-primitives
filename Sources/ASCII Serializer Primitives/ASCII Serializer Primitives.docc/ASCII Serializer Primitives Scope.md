# ASCII Serializer Primitives Scope

The identity surface of `swift-ascii-serializer-primitives`, and what is
deliberately out of it.

## Identity

`swift-ascii-serializer-primitives` is a **discipline package over the
upstream `ASCII` namespace** (owned by `swift-ascii-primitives`,
`ASCII.swift`) and the upstream `Serializable` / `Serializer.Protocol`
substrate (owned by `swift-serializer-primitives`). It binds the policy-free
serializer substrate to the concrete ASCII output domain: integer →
ASCII-decimal-digit and integer → ASCII-hexadecimal-digit serialization into
an `[ASCII.Code]` buffer, plus the `Serializable` conformances and accessors
that make that domain ergonomic.

Because every declaration extends an upstream-owned namespace
(`extension ASCII.Decimal { … }`, `extension ASCII.Hexadecimal { … }`,
`extension Serializable { … }`, `extension Binary.ASCII { … }`) and imports
external modules (`ASCII_Primitives`, `Serializer_Primitives_Core`,
`Binary_Serializable_Primitives`, `Byte_Primitives`), the package has **no
zero-dependency `{Domain} Primitive` substrate root** of its own (per the
discipline-package rule, /modularization §7). It splits into sub-namespace
modules + an umbrella.

## Core targets

The package is decomposed by **output flavor / conformance subject**:

- **Serializable ASCII Primitives** — the `extension Serializable` accessor
  (`asciiCodes`) that materializes a value's canonical serializer output as
  `[ASCII.Code]`. Extends the upstream `Serializable` protocol; depends on
  `ASCII_Primitives` and `Serializer_Primitives_Core`.
- **ASCII Decimal Serializer Primitives** — `ASCII.Decimal.Serializer<T>`:
  `FixedWidthInteger` → ASCII decimal digits. Extends upstream
  `ASCII.Decimal`; depends on `ASCII_Primitives`, `Serializer_Primitives_Core`.
- **ASCII Hexadecimal Serializer Primitives** — `ASCII.Hexadecimal.Serializer<T>`:
  `FixedWidthInteger` → lowercase ASCII hexadecimal digits. Extends upstream
  `ASCII.Hexadecimal`; same dependencies as the decimal sub-namespace.
- **Serializable Integer Primitives** — the stdlib `FixedWidthInteger`
  `Serializable` conformances (routed through `ASCII.Decimal.Serializer`) and
  the `RangeReplaceableCollection where Element == ASCII.Code` append
  convenience. Depends on `ASCII Decimal Serializer Primitives`.
- **Binary ASCII Serializable Primitives** — the DEPRECATED
  `Binary.ASCII.Serializable` protocol and its `Binary.Serializable`
  delegation (`Binary_Serializable_Primitives`, `Byte_Primitives`).
- **ASCII Serializer Primitives** — the umbrella, re-exporting every
  sub-namespace above plus the `ASCII.Serializer` capability namespace shell.

## Out of scope

- A zero-dependency namespace root: this is a discipline package over upstream
  `ASCII` and `Serializable`; it mints no `ASCII Serializer Primitive` root.
- **`ASCII Serializer Primitives Core`** is a transitional DEPRECATED shim
  (L1 core-dissolution sweep 2026-06-23), exports-only, re-exporting the
  dissolved Core surface (`Serializable ASCII Primitives` + the `ASCII` and
  `Serializer` externals Core previously funneled). It is removed in the
  core-dissolution cleanup wave and is not part of the package's identity.
- **Parsing / deserialization** (ASCII bytes → integer): → the parser family
  (`swift-ascii-parser-primitives`). Serialization here is one-way.
- **The serializer combinator substrate** (map, filter, many, …): → upstream
  `swift-serializer-primitives`, which this package builds ON.

## Evaluation rule

Sub-target additions are evaluated against this scope. A proposed addition
that serializes a value into an ASCII-domain buffer, or conforms a type to
`Serializable` for the ASCII domain, lands as / within a sub-namespace target
per [MOD-031]; anything that parses ASCII, composes generic serializer
combinators, or pins a non-ASCII output domain extracts to a sibling package,
not into this one.
