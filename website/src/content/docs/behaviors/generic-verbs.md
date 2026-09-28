---
title: Generic verbs
description: The built-in operations that work across element and numeric types.
---

Some operations that make sense for many types are built in, and resolved
for each concrete type at compile time. For your own, write a
[generic function](/Resid/behaviors/generics/) or
[declare a behavior](/Resid/behaviors/defining/).

## List verbs

| Verb | Works on | Result |
|---|---|---|
| `xs.len()` | any list | `Int` |
| `xs.contains(v)` | integers, floats, `Str` | `Bool` |
| `xs.reverse()` | any list | the list reversed |
| `xs.sum()` | `List(Int)`, `List(Float)` | the sum |
| `xs.concat(ys)` | any list | a new list |
| `xs[a..b]` | any list | a slice |
| `sort(xs)` | numbers, `Str`, or a type with an `Ord` instance | a sorted list |

```resid
Int main() {
    List(Int) xs = [3, 1, 2];
    List(Str) ss = ["pear", "fig"];
    List(Float) fs = [2.5, 0.5];
    println(f"{xs.contains(2)} {ss.contains("fig")} {fs.contains(9.0)}");
    println(f"{xs.sum()} {fs.sum()} {xs.reverse()} {sort(ss)}");
    return 0;
}
```

```text title="Output"
true true false
6 3 [2, 1, 3] ["fig", "pear"]
```

A function of your own with the same name, taking the list as its first
parameter, takes precedence over the built-in verb.

## Numeric verbs

`abs(x)`, `min(a, b)`, `max(a, b)` and `clamp(x, lo, hi)` take arguments of
one numeric type, any width, and return that type:

```resid
Int main() {
    Int(32) a = -9;
    UInt(8) b = 250;
    println(f"{abs(a)} {min(b, 3)} {max(1.25, 0.75)} {clamp(a, -5, 5)}");
    return 0;
}
```

```text title="Output"
9 3 1.25 -5
```

They are checked like any arithmetic: `abs` of the most negative integer
traps.

`sqrt(x)` takes a `Float` (or a `Float` vector, lane by lane; see
[Vector types](/Resid/reference/vectors/)) and returns its correctly rounded
IEEE 754 square root, one machine instruction; `sqrt` of a negative number
is NaN.

## Built-in behaviors of numbers

Every width of `Int`, `UInt`, `Float` and `Dec` has built-in `Eq`, `Ord`
and `Hash`, instantiated by the compiler for the concrete width. You never
declare per-width instances.
