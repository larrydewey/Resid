---
title: Expressions
description: Operators and precedence, if and match expressions, calls, access, ranges, f-strings.
---

## Precedence

| Level | Operators |
|---|---|
| 1 (tightest) | primary: names, literals, `(e)`, `rt e`, calls, `x[i]`, `x.f`, methods, ranges, slices |
| 2 | unary `+ - ! ~`, cast `(Type)e` |
| 3 | `* / %` |
| 4 | `+ -` |
| 5 | `<< >>` |
| 6 | `< <= > >=` |
| 7 | `== !=` |
| 8 | `&` |
| 9 | `^` |
| 10 | <code>&#124;</code> |
| 11 | `&&` |
| 12 | <code>&#124;&#124;</code> |
| 13 | `c ? a : b` |
| 14 (loosest) | `using =` in a call |

`a | b & c` is `a | (b & c)`, and `a || b && c` is `a || (b && c)`.
`&&` and `||` short-circuit: the right operand is not evaluated (with its
effects and aborts) when the left decides the result. There are no
assignment operators and no pipeline or method chaining on plain values.

## Conditional expressions

`if (c) { a } else { b }` and `c ? a : b` yield a value; both branches
must have the same type, and an `if` expression must have an `else`. A
block used as a value may contain bindings before its final expression.

## match

```text
match e {
    Variant(x) => expression,
    Other => expression,
}
```

Arms are tried in order; each binds the variant's payload. All arms must
have the same type. The scrutinee is an `Option`, a `Result` or a declared
sum type.

## Access

`p.x` reads a field, `xs[i]` a list element (bounds-checked; out of range
aborts with the index and length), `m[k]` a map entry as an `Option`.
`xs[a..b]` is a slice (a new list). `a..b` is half-open, `a..=b` closed.

## Calls and methods

`f(a, b)`; `f(a, name = v)` with named arguments; `xs.len()`,
`m.insert(k, v)` and the other built-in methods of lists, maps, sets and
builders. For handles only, `h.m(args)` means `m(h, args)`.

## Option and Result sugar

`e?` unwraps `Some` / `Ok`, or returns `None` / `Err` from the enclosing
function (which must return an `Option` or `Result`). `e else { d }`
unwraps, or evaluates the block.

## f-strings

`f"text {expr} text"`: each hole takes any value (see
[Show](/Resid/behaviors/show/)). `{{` and `}}` are a literal brace.

A hole may carry a **format spec** after `:`. The spec is a list of flags
in any order, and every flag names one thing:

```resid
Int main() {
    Int n = 1234567;
    Float pi = 3.14159265;
    println(f"{n:group}");            // 1,234,567
    println(f"{n:12}");               //    1234567
    println(f"{n:12, left}");         // 1234567
    println(f"{n:hex, width 8}");     // 12d687
    println(f"{-42:zero, width 6}");  // -00042
    println(f"{pi:precision 2}");     // 3.14
    return 0;
}
```

```text
1,234,567
     1234567
1234567     
  12d687
-00042
3.14
```

| Flag | Meaning |
|---|---|
| `8` / `width 8` | minimum field width, in characters |
| `left` `right` `center` | alignment; `right` by default for numbers, `left` otherwise |
| `fill '.'` / `zero` | the pad character; `zero` pads after any sign |
| `plus` `space` `minus` | the sign of a non-negative value |
| `hex` `oct` `bin` | the radix of an integer |
| `upper` `lower` | the case of the letters |
| `group` | a `,` every three digits (decimal only) |
| `precision 2` / `.2` | digits after the point, for a Float |
| `decimal` `scientific` `percent` `auto` | how a Float is written out |
| `trim` | drop a Dec's trailing zeros |

A flag a value's type cannot mean is a compile error, never a silent
no-op: `f"{s:hex}"` on a `Str`, `f"{n:precision 2}"` on an `Int`, and
`f"{n:trim}"` on an `Int` are all rejected. An unknown flag is rejected
too, and the message lists the ones that are accepted.

A spec only changes how text is written, never how a value is computed, so
a spec'd hole whose value is known reduces at compile time:
`f"{n:group}"` with a known `n` is a literal, with no runtime call.

## rt

`rt e` makes `e`'s value residual: the compiler treats it as unknown.
