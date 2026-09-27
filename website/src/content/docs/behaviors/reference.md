---
title: Behavior reference
description: Declaration syntax, signatures, resolution rules and diagnostics for behaviors.
---

## Declaring an instance

```text
Behavior(Type) = function;
```

- `Behavior` is one of `Ord`, `Show`, `Eq`, `Hash`, `Serialize`,
  `Allocator`.
- `Type` is any type: a name (`Point`), a parameterized type (`Int(32)`,
  `List(Str)`).
- `function` names a top-level function whose signature matches the
  behavior:

| Behavior | Signature |
|---|---|
| `Ord(T)` | `Int f(T a, T b)` |
| `Show(T)` | `Str f(T v)` |
| `Eq(T)` | `Bool f(T a, T b)` |
| `Hash(T)` | `Int f(T v)` |
| `Serialize(T)` | `Str f(T v)` |
| `Allocator(T)` | `T f()` |

A type has **at most one instance per behavior**. Instances are visible
across imports.

## Resolution

- `sort(xs)` uses the built-in ordering of numeric and `Str` elements, or
  the element type's unique `Ord` instance. Otherwise it is an error that
  asks for `using =`.
- `sort(xs, using = B)` where `B` is:
  - `Ord(T)`: the instance for `T`, or the built-in ordering of a numeric
    or `Str` `T`; `T` must be the element type;
  - `f`: a function `Int f(T, T)`;
  - `Reverse(B)`: `B` reversed. Comparator results are normalized to
    -1, 0 or 1 before negation.
- An f-string hole of type `T`, including a record field, a list element or
  an `Option` / `Result` payload of type `T`, calls `Show(T)` when it
  exists.

## Authority

A behavior's function is called where the behavior is used, so its
capabilities flow to the caller: a function that sorts with a comparator
needing `process` must itself be granted `process` (`E0219`). This includes
an instance that `sort(xs)` inserts implicitly.

## Diagnostics

| Message | Cause |
|---|---|
| `behavior Ord(T): impl must have signature (T, T) -> Int` | wrong comparator signature (similarly for the other behaviors) |
| `Ord(T) is already defined as f` | a second instance for the same type |
| `sort(xs) of T needs a behavior` | no built-in order and no instance |
| `behavior Ord(A) orders A, but the list holds B` | instance for the wrong type |
| `comparator f must have signature (T, T) -> Int` | a `using = f` with the wrong shape |
| `E0219 ... (through f)` | a comparator needs a capability its caller lacks |
