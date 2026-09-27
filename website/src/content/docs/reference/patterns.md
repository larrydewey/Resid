---
title: Patterns
description: match arms, destructuring, if-let and while-let.
---

Patterns take apart sum types and records.

| Where | Form |
|---|---|
| `match` arm | `Variant(x) => e`, `Variant => e`, `_ => e` |
| if-let | `if (Some(x) = e) { ... } else { ... }` |
| while-let | `while (Some(x) = e) { ... }` |
| destructuring binding | `Point { x, y } = p;`, `Some(v) = opt;` |

- A variant pattern binds the payload to a new name; payload-less variants
  are written by name.
- Patterns are one level deep: match on the outer variant, then match or
  read the payload.
- A destructuring binding must be irrefutable: a pattern that could fail
  to match is a compile-time error.
- Every name a pattern binds is new; it cannot shadow a name in scope.
