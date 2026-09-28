---
title: Vector types
description: Vec(T, N) lanes in registers, lanewise operations, lane masks, shuffles and the rules E0410 to E0412.
---

`Vec(T, N)` holds `N` lanes of a number type `T` in registers, and its
operators work on every lane at once, which the compiler maps to the
machine's vector instructions. `T` is `Int(8)`, `Int(16)`, `Int(32)`,
`Int`, the same `UInt` widths, `Float(32)` or `Float`; `N` is 2, 4, 8, 16,
32 or 64. Comparisons give lane masks, `Vec(Bool, N)`. `Vec` is a builtin
type name.

```resid
Vec(Float, 4) scale(Vec(Float, 4) v, Float k) { return v * k; }

Int main() {
    Vec(Float, 4) v = [1.0, 2.0, 3.0, 4.0];
    Vec(Float, 4) h = splat(0.5);
    Vec(Float, 4) w = scale(v, 2.0) + h;
    Vec(Bool, 4) m = w > 4.0;
    println(f"{w.to_list()} {m.bits()} {select(m, w, h).sum()}");
    Vec(Int(32), 8) k = lanes();
    println(f"{(k * 3 - 1).to_list()} {k.shuffle(k.wrapping_add(1)).to_list()}");
    return 0;
}
```

```text title="Output"
[2.5, 4.5, 6.5, 8.5] 14 20
[-1, 2, 5, 8, 11, 14, 17, 20] [1, 2, 3, 4, 5, 6, 7, 0]
```

## Building vectors

A list literal of exactly `N` elements, `splat(x)` (every lane `x`) and
`lanes()` (0, 1, …, N−1) build a vector. They take the vector type from
where they are written: a binding's value, a return value, an argument of
a user function, or an operand of `select`. Elsewhere, bind the vector
first (`E0412`). Numeric literals adopt the lane type and must fit it; an
integer literal operand of an operator also meets `Float` lanes (`v * 2`).

## Operations

| Operation | |
|---|---|
| `a + b`, `a - b`, `a * b` | lanewise; `a / b` for `Float` lanes |
| `a & b`, `a \| b`, `a ^ b` | integer lanes and masks |
| `==` `!=` `<` `<=` `>` `>=` | lanewise, giving a `Vec(Bool, N)` |
| `-v`, `~v`, `!m` | negation, integer complement, mask not |
| `v[i]`, `v.with(i, x)` | read or replace lane `i` (checked like a list index) |
| `v.sum()` | the lanes added in lane order |
| `v.shuffle(idx)` | lane `j` of the result is `v[idx[j] mod N]` (floor modulo: -1 is N-1) |
| `v.wrapping_add(w)`, `wrapping_sub`, `wrapping_mul` | integer lanes, wrapping |
| `m.any()`, `m.all()`, `m.bits()` | some lane, every lane, the lanes as bits of an `Int` (with 64 lanes, lane 63 is the sign bit) |
| `select(m, a, b)` | `a` where the mask is true, else `b` |
| `sqrt(v)`, `min(a, b)`, `max(a, b)` | lanewise |
| `v.to_list()` | the lanes as a `List(T)` |
| `(Vec(U, N))v` | integers to `Float`, `Float` to `Float`, or a widening integer conversion |

The operands of a binary operator have the same vector type, or one is a
scalar of the lane type, used in every lane. Integer lanes are checked
like integers: `+`, `-` and `*` abort when any lane overflows, and the
`wrapping_*` methods wrap instead. A `Float` sum adds from lane 0 upward,
so it rounds exactly like the loop it replaces.

## Rules

| Code | |
|---|---|
| `E0410` | the lane type is not a number width up to 64 bits, or `N` is not 2, 4, 8, 16, 32 or 64 |
| `E0411` | a vector type appears inside another type (a list, map, option, result, field, variant payload or closure type, written or inferred), or a lambda or `spawn` captures a vector |
| `E0412` | a vector literal, `splat` or `lanes` is not in a place that gives its type |

An f-string does not show a vector directly; interpolate `v.to_list()`.
A user function named `splat`, `lanes`, `select`, `sqrt`, `min` or `max`
replaces the builtin everywhere in the program.
