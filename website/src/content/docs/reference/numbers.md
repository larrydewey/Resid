---
title: Numbers
description: The numeric family, literal typing, checked arithmetic, conversions, decimals and floats.
---

## Types

| | Types | Aliases |
|---|---|---|
| signed integers | `Int(8)` `Int(16)` `Int(32)` `Int(64)` `Int(128)` `Int(256)` `Int(512)` | `Int` = `Int(64)` |
| unsigned integers | `UInt(8)` … `UInt(512)` | `UInt` = `UInt(64)` |
| pointer-sized | `ISize`, `USize` | |
| binary floats | `Float(16)` `Float(32)` `Float(64)` `Float(128)` | `Float` = `Float(64)` |
| decimals | `Dec(N)`, N ≥ 1 significant digits | `Dec` = `Dec(34)` |

Every width is a distinct nominal type. There is no subtyping among
numeric types.

## Integer literals

A literal takes its type from its position:

- as an operand whose other operand has a concrete integer type, it adopts
  that type;
- as the whole initializer, argument, return value or field, it adopts the
  declared type;
- otherwise (`1000000 * 1000000`), the smallest signed width of 64, 128,
  256 or 512 bits that holds it.

A literal that does not fit its adopted type is a compile-time error.
Adoption does not reach into `if` / `match` arms: arms must agree, so write
`i128(0)` in an arm that must match an `Int(128)` arm.

## Arithmetic

- `+ - * / % & | ^` yield the **widest operand width**, after widening the
  narrower operand. Signed and unsigned operands never mix without an
  explicit conversion.
- `+ - * / %` are **checked** at every width: overflow, division or
  remainder by zero, and `MIN / -1` abort. `MIN % -1` is 0.
- Shifts yield the left operand's width and are not checked. `<<` fills
  with zeros; `>>` is arithmetic for signed and logical for unsigned
  operands. A shift count that is negative or at least the bit width gives
  0, or -1 for `>>` of a negative signed value.
- Headroom must be requested explicitly: `(Int(512))a * b`.
- Integer with float yields the float type; two floats yield the wider.
- Comparisons follow the same widening; a signed/unsigned mix is an error.
  Unsigned values compare, divide and take remainders as unsigned.

The compiler may drop a check it can prove unnecessary from the operands'
ranges (see [Reduction](/Resid/reference/reduction/)), and never folds an
overflowing operation at compile time: it stays residual so it traps at
run time.

## Conversions

- Implicit: value-preserving widening at bindings, returns and fields
  (same signedness and no narrower, or unsigned into a strictly wider
  signed type). Never narrowing, never signed into unsigned.
- Explicit and checked: `i8` … `i512`, `u8` … `u512`, `f16` … `f128`,
  `dN`, `isize`, `usize`, and the cast `(Type)expr`. A value the target
  cannot represent (too large, negative into unsigned, NaN or out of range
  into an integer) aborts.
- Bit-level: `wrapping_i8` … `wrapping_u512` keep the low bits.
- `wrapping_add`, `wrapping_mul`, `saturating_add`, … exist for every
  width; `abs`, `min`, `max` and `clamp` take one numeric type.

Argument expressions must match parameter types exactly after literal
adoption.

## Decimals

`Dec(N)` holds an exact decimal with N significant digits, an exponent in
[-1,000,000, +1,000,000], and no NaN or infinity.

- Results are rounded once, half away from zero, to N digits; division
  computes N + 2 guard digits first.
- `Dec(N) op Dec(M)` is `Dec(max(N, M))`. Mixing `Dec` with integers or
  floats is an error.
- Converting a `Dec` to an integer requires an integral value.
- Division by zero, exponent overflow and a fractional value converted to
  an integer are errors: at compile time when provable, else at run time.
- A `Dec` prints all N digits; `f"{x:.}"` trims trailing zeros.

## Floats

IEEE binary floats of 16, 32, 64 and 128 bits. `Float(128)` is the widest;
arbitrary precision is `Dec`. A float prints as the shortest text that
reads back as the same value at its width.
