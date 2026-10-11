---
title: Layout types
description: Record types with a fixed byte layout, and the parsers and serializers the compiler writes for them.
---

A **layout type** is an ordinary record type marked `@layout(c_abi)`,
`@layout(le)` or `@layout(be)`. The compiler writes its parser and its
serializer; nothing else needs to read its bytes. The design is
`PLAN-labels.md` §7 in the repository; layout types are how bytes from
outside the program (device replies, wire formats, signed reports) are
read.

```text
import "dev/device.resid";            // DeviceError

@layout(c_abi)
pub type DemoResp = {
    @check(status == 0, Kernel(status)) UInt(32) status;
    @check(report_size <= 4000) UInt(32) report_size;
    @reserved(24);
    @len(report_size) List(UInt(8)) report;
};
```

## Layouts

- `c_abi`: the target's C layout. Every field is aligned to its size, the
  type to its largest field, and the type is padded at the end; integers
  are little-endian (both targets are). Only the last field may have a
  variable length (a flexible array member). The offsets are checked
  against clang for x86-64 and AArch64 (`tests/labels`).
- `le`, `be`: packed, in that byte order. Variable lengths may appear
  anywhere, and a parse must consume its bytes exactly.

## Fields and annotations

Fields are `UInt(8|16|32|64)`, `Int(8|16|32|64)`, `List(UInt(8))` with a
`@len`, or another layout type of the same layout (of fixed size under
`c_abi`).

| Annotation | Meaning |
|---|---|
| `@check(e)` | a condition over this and earlier fields: checked while parsing (else `BadReply(type, "field: e")`) and before serializing (else `BadInput`) |
| `@check(e, Ctor(args))` | as above, failing with that `DeviceError` constructor, the type's name first and each argument as an `Int`: `Kernel(status)` gives `Kernel("DemoResp", status)` |
| `@len(f)` / `@len(n)` | the byte length of a `List(UInt(8))` field: an earlier integer field, or a constant |
| `@reserved(n)` | n bytes no ABI defines: written as zero, ignored when read, never named in a literal |

Bits inside a word are a single integer field whose rules are `@check`s
written with `& | << >>`.

## What the compiler writes

For `DemoResp` (snake case `demo_resp`):

```text
Result(DemoResp, DeviceError) demo_resp_parse(List(UInt(8)) b)
Result(DemoResp__At, DeviceError) demo_resp_parse_at(List(UInt(8)) b, Int at)   // { DemoResp v; Int end; }
Result(List(UInt(8)), DeviceError) demo_resp_bytes(DemoResp r)
Int demo_resp_size()                       // the fixed part, padding included
Int demo_resp__status_at()                 // each field's offset (c_abi)
```

Every parser is total: it checks each length against the bytes it was
given before it reads or slices, so any input yields a value or an error,
never an abort; it reads each byte once and never backtracks. A failure is
`BadReply(type, "field: truncated")`, a failed check, or `trailing bytes`
(`le`/`be`). The serializer checks every `@check` and every `@len` against
the list it is given.

## Rules

A layout field may not hold a type only the runtime builds
(`ChallengeRecord` and the like, `E0274`), and a `Secret` field takes no
`@check` (`E0273`). Everything else that is malformed is `E0272`.
`Secret` fields and `Challenge(N)` request fields arrive with channels
(phase 3 of the plan).
