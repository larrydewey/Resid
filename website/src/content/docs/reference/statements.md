---
title: Statements
description: Bindings, discards, destructuring, loops, return, with and sandbox.
---

## Bindings

```text
Type x = expression;          // immutable
@residual Type y = expression; // treated as unknown while compiling
_ = expression;               // evaluate, discard
Point { x, y } = p;           // destructure a record
Some(v) = opt;                // irrefutable only: an error if it can fail
```

A name is bound once in its scope and never shadowed, including by nested
blocks, parameters and pattern bindings.

## Control

- `if (c) stmt else stmt`, `if (Pattern = e) { ... }` (if-let)
- `while (c) { ... }`, `while (Pattern = e) { ... }` (while-let)
- `for (Type x in e) { ... }` over a range or a list
- `break;`, `continue;`, `return e;`

Every path through a function that returns a value must end in `return`
(or abort through `todo` / `unimplemented`); the compiler rejects a
function that can fall off its end.

## Handles

```text
with (File f = filesystem.open(path)) {
    Str text = filesystem.read_handle(f);
}
```

`with` binds one or more handles and closes them at the end of the block.

## Assertions and debugging

`assert(c, "msg")`, `rt_assert(c, "msg")`, `known(x)`, `rt_known(x)`,
`comptime_print(e)`, `todo("msg")`, `unimplemented("msg")`.
`SourceLoc here = #location;` captures the current source location.
