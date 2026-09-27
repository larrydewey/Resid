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
pub as with spawn sandbox test rt lambda true false`. Built-in type names
(`Int`, `Str`, `List`, `Option`, …) are ordinary identifiers.

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

String escapes are `\n`, `\t`, `\r`, `\\` and `\"`; write any other
character directly (source files are UTF-8). A string cannot contain a
NUL character. There is no `null` literal.
