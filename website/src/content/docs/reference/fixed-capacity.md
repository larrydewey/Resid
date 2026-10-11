---
title: Fixed-capacity types
description: Str(N), Bytes(N) and List(T, N), their literals, casts and access rules.
---

`Str(N)`, `Bytes(N)` and `List(T, N)` have a statically known extent, so
they are stored inline: in the activation frame, or inside the record or
list that holds them. They never need a heap allocation of their own; a
result or a value carried to a loop's next step is copied when its frame
ends. Every `N` is a distinct nominal type.

| Type | Holds | Storage |
|---|---|---|
| `Str(N)` | a UTF-8 string of at most N bytes | N + 1 bytes, NUL-terminated |
| `Bytes(N)` | at most N bytes | N bytes |
| `List(T, N)` | exactly N elements | N × size of T |

## Literals

```resid
Int main() {
    Str(8) s = "abc";
    List(Int, 5) xs = [10, 20, 30];       // slots 3 and 4 are zero
    println(f"{s} {xs.len()} {xs[1]} {xs[4]}");
    return 0;
}
```

```text title="Output"
abc 5 20 0
```

A literal larger than the capacity is a compile-time error; nothing is
ever silently truncated except by an explicit cast.

## Casts

- `Str(N)` → `Str` and `Bytes(N)` → `Bytes`: a heap copy of the text, since the
  result may outlive the frame the fixed value lives in. A heap `Bytes` ends
  at its first zero byte, so a `Bytes(N)` converts only when nothing but
  zero padding follows its first zero; otherwise (`b"ab\0cd"`) the
  conversion aborts rather than drop `cd`. The same holds for `Bytes(N)` →
  `Str` and `Str(M)`.
- `Str` → `Str(N)`, `Str(N)` → `Str(M)`, and `Bytes` → `Bytes(N)`: a
  bounded copy that keeps the longest prefix of whole code points that fits.
  `Bytes(N)` → `Bytes(M)` copies the first min(N, M) bytes, zeros included.
- `List(T, N)` → `List(T)`: copies all N elements.

## Access

Indexing is bounds-checked against the capacity (`Str(N)` against its
content) and aborts when out of range. `.len()` of a `List(T, N)` is N. `xs.with(i, x)` is a `List(T, N)` equal to `xs` but for element `i`, with `i` checked against N.
Fixed strings and byte arrays can be passed to the built-in functions that
take `Str` or `Bytes`; a user function needs the exact type, so convert
with a cast. `Eq`, `Ord` and `Hash` do not extend to fixed-capacity types.
