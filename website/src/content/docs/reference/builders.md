---
title: Linear builders
description: StrBuf and ListBuf(T), in-place appends, and the linearity rules E0401 to E0404.
---

A builder appends in place into one growing buffer. To keep that
invisible, **each builder value is used exactly once**: every operation
consumes its builder and `push` returns the builder to use next.

| Operation | |
|---|---|
| `StrBuf()` | an empty string builder |
| `ListBuf()` | an empty `ListBuf(T)`; `T` comes from the expected type |
| `b.push(s)` | `StrBuf`: append a `Str` |
| `b.push_char(c)` | `StrBuf`: append the code point `c` |
| `b.push(x)` | `ListBuf(T)`: append an element |
| `b.finish()` | the finished `Str` or `List(T)` |

`push` is amortized O(1) and `finish` hands over the buffer without
copying.

```resid
StrBuf digits(Int i, Int n, StrBuf acc) {
    if (i >= n) { return acc; }
    return digits(i + 1, n, acc.push(f"{i}"));
}

Int main() {
    ListBuf(Str) l0 = ListBuf();
    List(Str) words = l0.push("a").push("b").finish();
    println(f"{digits(0, 10, StrBuf()).finish()} {words}");
    return 0;
}
```

```text title="Output"
0123456789 ["a", "b"]
```

## Rules

| Code | Violation |
|---|---|
| `E0401` | a builder is not consumed on some path (including a `return` that drops it) |
| `E0402` | a builder is used twice, or after it was consumed |
| `E0403` | a builder bound outside a loop is used inside it, or captured by a lambda |
| `E0404` | a builder type appears inside another type (a field, a list element, an option, a closure type) |

Branches must consume the same builders, except a branch that leaves by
`return`, `break` or `continue`. The right operand of `&&` / `||` must
not consume a builder bound outside it. Passing a builder along
(`return b;`, or as an argument) counts as its one use.
