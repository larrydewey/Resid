---
title: Functions and closures
description: Declarations, parameters, defaults, named arguments, recursion, closure types and lambdas.
---

```text
Ret name(Type1 p1, Type2 p2 = default) { body }
```

- The return type comes first. `Void` functions return nothing.
- Parameters are immutable bindings. Defaults must be pure compile-time
  expressions; callers may pass arguments by name (`f(1, p2 = 3)`).
- Arguments must match parameter types exactly after literal adoption.
- `pub` exports a function from its module.
- `@requires(caps)` before a function grants it capabilities
  ([Capabilities](/Resid/reference/capabilities/)).
- `Int main()` is the program's entry point; its result is the exit status.

A call in tail position compiles to a jump, so tail recursion runs in
constant stack space.

## Closures

A closure type is written `R closure(P1, P2)`, where `R` may be any type
(`List(Str) closure(Str)`); a lambda builds one:

```text
Int closure(Int, Int) add = lambda(a, b) { a + b };
```

- A lambda's parameter types come from the expected closure type: a typed
  binding, a parameter, or the enclosing function's return type.
- A lambda captures the values it names (numbers, strings, lists, maps,
  records, sums and other closures). Values are immutable, so a capture is
  a copy of a value, never a shared variable.
- A `Void` closure runs its body for effect and discards its value.
- The capabilities a lambda's body needs belong to the function that
  writes the lambda.
