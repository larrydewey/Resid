---
title: Behavior reference
description: Declaration syntax, instances, resolution, coherence, authority and diagnostics for behaviors and generics.
---

## Declaring a behavior

```text
behavior Name(T, ...) {
    Ret verb(Param p, ...);
    ...
}
```

- `Name` starts uppercase; its parameters are single uppercase letters.
- Each prototype declares a verb (lowercase) with no body. Prototypes may
  mix the behavior's parameters with concrete types
  (`Str render(T x, Int width);`).
- A function of your own with a verb's name wins over the verb.

## Declaring an instance

```text
Name(Type, ...) = function;                       // one verb
Name(Type, ...) = { .verb = function, ... };      // several verbs
```

- The types may be concrete (`Task`), partly concrete (`Pair(Int)`) or
  generic (`Pair(T)`).
- Each function must have its verb's prototype with the behavior's
  parameters replaced by the instance's types. A generic function fits
  when it specializes to that signature.
- A bundle names every verb exactly once.
- `Show` cannot be given for numbers, `Bool` or `Str`, whose display is
  fixed.

## The core behaviors

| Behavior | Verb | Instance signature |
|---|---|---|
| `Eq(T)` | `eq` | `Bool f(T a, T b)` |
| `Ord(T)` | `compare` | `Int f(T a, T b)`: negative, zero or positive |
| `Hash(T)` | `hash` | `Int f(T x)` |
| `Show(T)` | `show` | `Str f(T x)` |
| `Serialize(T)` | `serialize` | `Str f(T x)` |
| `Allocator(T)` | `allocate` | `T f()` |

## Resolution

- A verb call fixes the behavior's types from its arguments, else from the
  expected type of the call, and calls the instance's function for them.
- `sort(xs)` uses the built-in ordering of numeric and `Str` elements, or
  the element type's `Ord` instance.
- `sort(xs, using = B)` and `verb(args, using = B)`, where `B` is:
  - `Name(T)`: that instance (or a built-in `Ord` of a numeric or `Str`
    `T`);
  - `f`: a function used directly;
  - `Reverse(B)`: `B` with its two arguments swapped, which reverses an
    ordering.
- A generic call `g(args, using = B)` makes its copy use `B` for the need
  `B` names (or, for a plain function, the function's only need).
- An f-string hole of type `T`, including a record field, a list element or
  an `Option` / `Result` payload of type `T`, calls `Show(T)` when it
  exists.
- `==` / `!=` call `Eq(T)` and `<` `<=` `>` `>=` call `Ord(T)` for a type
  without a built-in comparison.

## Generic functions

- A single uppercase letter in a signature is a type parameter; in a width
  position (`Int(N)`) it ranges over widths.
- `@needs(B(T), ...)` lists the behaviors the body uses on its parameters.
- Each call's type parameters come from the arguments or the expected type;
  each concrete call calls a copy made before reduction.

## Coherence

- At most one instance per behavior and type. Identical instances at one
  level are an error; overlapping ones (`Pair(T)` and `Pair(Int)`) are
  `E0225`.
- Levels: application over library over prelude. A higher level's
  instance replaces a lower one for its type program-wide.
- A library declares instances only of its own behaviors or types
  (`E0224`).

## Authority

A behavior's function is called where the behavior is used, so its
capabilities flow to the caller: a function that sorts with a comparator
needing `process` must itself be granted `process` (`E0219`). This includes
an instance that `sort(xs)` inserts implicitly, and instances reached
through a generic function's copy: the concrete caller must hold them. A
copy of a generic declared in a `sandbox` stays under that ceiling.

## Diagnostics

| Message | Cause |
|---|---|
| `behavior B(T): impl must have signature (...) -> R` | an instance function of the wrong shape (for a bundle, `verb must have signature`) |
| `B(T) is declared more than once` | a second instance for the same type at the same level |
| `E0224` | a library's instance of a behavior and type it owns neither of |
| `E0225 overlapping instances` | two instances at one level cover some type |
| `E0226 ... needs B(T): add @needs(B(T))` | a generic body uses a behavior it does not list |
| `E0226 ... no behavior instance B(X)` | a call's need, or a verb call, has no instance |
| `E0227 cannot infer ...` | a type parameter fixed by neither arguments, expected type nor one fitting instance |
| `E0228` | polymorphic recursion |
| `sort(xs) of T needs a behavior` | no built-in order and no instance |
| `E0219 ... (through f(T))` | an instance needs a capability the caller lacks |
