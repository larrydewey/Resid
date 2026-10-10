---
title: Lexical structure
description: Comments, identifiers, keywords and literals.
---

## Comments

```text
// line comment
/* block comment */
/// documentation for the next declaration
/** block documentation */
```

Documentation comments attach to the declaration that follows; the
language server shows them on hover and the knowledge graph records them.

## Identifiers and keywords

Identifiers are letters, digits and `_`, not starting with a digit.
Keywords: `if else match for in while break continue return type import
pub as with spawn sandbox test rt lambda true false behavior`. Built-in type names
(`Int`, `Str`, `List`, `Option`, …) are ordinary identifiers.

## Names

A name's case says what it is (`E0222`):

- values, functions, parameters, fields and behavior verbs start with a
  lowercase letter or `_`;
- types, behaviors and sum variants start with an uppercase letter;
- a single uppercase letter (`T`, `K`, `V`, `N`) is a type parameter and
  never names a declared type.

So a value never collides with a type, and `(T)x` is always a cast.

## Literals

| Literal | Examples | Type |
|---|---|---|
| integer | `42`, `0x2A`, `0o52`, `0b101010` | adopts its context, else `Int` (§ numbers) |
| float | `3.14`, `2.0` | `Float` |
| decimal | `1.5m`, `5m` | `Dec` (`Dec(34)`) |
| character | `'a'`, `'\n'` | `Int` (the code point) |
| string | `"text\n"` | `Str` |
| raw string | `r"C:\path"` | `Str`, no escapes |
| byte string | `b"bytes"` | `Bytes` |
| f-string | `f"x = {x}"` | `Str` |
| boolean | `true`, `false` | `Bool` |
| list | `[1, 2, 3]` | `List(T)` |
| map | `{"a": 1}` | `Map(K, V)` |
| set | `{1, 2}` | `Set(T)` |
| record | `Point {.x = 1, .y = 2}`, `Point { x = 1, y = 2 }` | the record type |
| location | `#location` | `SourceLoc` |

String escapes are `\n`, `\t`, `\r`, `\\`, `\"`, `\'` and `\xHH` (two
hex digits, ASCII through `\x7f`); any other escape is a compile error.
Write any other character directly (source files are UTF-8). A string
cannot contain a NUL character, so `\0` and `\x00` are refused there. A
byte string `b"..."` takes `\xHH` for any byte, and `\0`; a zero byte
(`\0`, `\x00`) is accepted only where the literal is a `Bytes(N)`, since a
heap `Bytes` ends at its first zero byte. There is no `null` literal.
