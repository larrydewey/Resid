---
title: Values and bindings
description: Immutable bindings, the numeric family, Bool, Str and conversions.
---

## Bindings

A binding names a value. It has a type, and it never changes:

```resid
Int main() {
    Int answer = 42;
    Float ratio = 0.75;
    Bool ready = true;
    Str name = "Rezzi";
    println(f"{name}: {answer} {ratio} {ready}");
    return 0;
}
```

```text title="Output"
Rezzi: 42 0.75 true
```

There is no assignment and no `var`. You cannot bind the same name twice
in a scope, not even in a nested block (shadowing is an error), so a name
always means one thing:

```resid
Int main() {
    Int x = 1;
    Int x = 2;      // error: shadowing
    return x;
    // expect-error: E0001
}
```

To ignore a value, discard it: `_ = expr;`. The expression still runs.

## Numbers

Every width is its own type, and there is no subtyping between them:

| Family | Types | Alias |
|---|---|---|
| signed | `Int(8)` `Int(16)` `Int(32)` `Int(64)` `Int(128)` `Int(256)` `Int(512)` | `Int` = `Int(64)` |
| unsigned | `UInt(8)` … `UInt(512)` | `UInt` = `UInt(64)` |
| pointer-sized | `ISize` `USize` | |
| binary float | `Float(16)` `Float(32)` `Float(64)` `Float(128)` | `Float` = `Float(64)` |
| exact decimal | `Dec(N)`, any N ≥ 1 significant digits | `Dec` = `Dec(34)` |

**Arithmetic is checked.** `+ - * / %` abort the program on overflow,
division by zero or `MIN / -1`, at every width. Bits are never silently
dropped.

```resid
Int main() {
    Int(8) a = 100;
    Int(8) b = 27;
    println(f"{a + b}");       // 127 fits
    Int(8) c = a + b + 1;      // 128 does not: the program aborts here
    println(f"{c}");
    return 0;
    // expect-abort
}
```

Integer operators yield the **widest operand's width**; a narrower operand
is widened first. Signed and unsigned never mix without a conversion, and
narrowing is never implicit:

```resid
Int main() {
    UInt(8) small = u8(200);
    UInt(16) wide = small + u16(1000);   // UInt(16) + UInt(8) -> UInt(16)
    UInt(8) back = u8(wide - u16(1000)); // explicit, checked narrowing
    println(f"{wide} {back}");
    return 0;
}
```

```text title="Output"
1200 200
```

The conversion helpers are `i8` … `i512`, `u8` … `u512`, `f16` … `f128`,
`dN` (for example `d10`), `isize` and `usize`, plus the cast `(Type)expr`.
All of them are checked: a value the target cannot hold aborts. For bit-level
code, `wrapping_u8(300)` keeps the low bits (44), and `wrapping_add`,
`saturating_mul` and friends exist for every width.

Wide integers are ordinary values:

```resid
Int main() {
    Int(256) big = (Int(256))1 << 200;
    println(f"{big}");
    return 0;
}
```

```text title="Output"
1606938044258990275541962092341162602522202993782792835301376
```

## Decimals

`Dec(N)` is exact decimal arithmetic with N significant digits: no binary
rounding, no NaN, no infinity. Literals end in `m`:

```resid
Int main() {
    Dec price = 19.99m;
    Dec total = price * 3m;
    println(f"{total:.}");          // :. trims trailing zeros
    Dec(4) x = d4(15) / d4(10);
    println(f"{x}");                // all 4 digits are printed
    return 0;
}
```

```text title="Output"
59.97
1.500
```

Mixing `Dec` with `Int` or `Float` is an error; convert explicitly.

## Literals

```text
42   0x2A   0b101010   3.14   1.5m   'a'   "text"   true   false
r"C:\raw\string"   b"bytes"   f"interpolated {x}"
```

An integer literal takes the type its position asks for (`Int(8) a = 100;`),
and a literal that does not fit is a compile-time error. There is no `null`:
absence is `Option`'s `None` (see [Errors and absence](/Resid/learn/errors/)).
