---
title: Functions
description: Declarations, defaults and named arguments, recursion, closures.
---

```resid
Int square(Int x) {
    return x * x;
}

Int main() {
    println(f"{square(12)}");
    return 0;
}
```

```text title="Output"
144
```

The return type comes first, then the name and typed parameters. Arguments
must match parameter types exactly; a computed argument is never widened or
narrowed to fit.

## Defaults and named arguments

Parameters may have defaults (pure, compile-time expressions), and calls
may name arguments:

```resid
Str greet(Str name, Str greeting = "Hello", Str end = "!") {
    return f"{greeting}, {name}{end}";
}

Int main() {
    println(greet("Rezzi"));
    println(greet("Rezzi", end = "?"));
    println(greet(greeting = "Hi", name = "you"));
    return 0;
}
```

```text title="Output"
Hello, Rezzi!
Hello, Rezzi?
Hi, you!
```

## Expressions everywhere

`if` and `match` are expressions, so a function body is often a single
`return`:

```resid
Int sign(Int x) {
    return if (x > 0) { 1 } else if (x < 0) { -1 } else { 0 };
}

Int main() {
    println(f"{sign(-5)} {sign(0)} {sign(9)}");
    return 0;
}
```

```text title="Output"
-1 0 1
```

The C conditional `c ? a : b` works too.

## Recursion is iteration

Resid has no mutable loop counters, so repetition is recursion. A call in
tail position compiles to a jump, so tail recursion runs in constant stack
and is as fast as a loop:

```resid
Int sum_to(Int n, Int acc) {
    if (n == 0) { return acc; }
    return sum_to(n - 1, acc + n);
}

@requires(args)
Int main() {
    Int n = 10000000 + args.count();   // unknown at compile time
    println(f"{sum_to(n, 0)}");
    return 0;
}
```

```text title="Output"
50000015000001
```

`for` loops over ranges and lists cover most other cases; see
[Control flow](/Resid/learn/control-flow/).

## Closures

A closure type is written `Ret closure(Params)`; `lambda(params) { expr }`
makes one, capturing the values it uses:

```resid
Int apply_twice(Int closure(Int) f, Int x) {
    return f(f(x));
}

Int main() {
    Int step = 10;
    Int closure(Int) add_step = lambda(v) { v + step };
    println(f"{apply_twice(add_step, 1)}");
    return 0;
}
```

```text title="Output"
21
```

Whatever authority a closure's body needs belongs to the function that
writes it (see [Capabilities](/Resid/learn/capabilities/)).

## Generic functions

A single uppercase letter in a signature is a type parameter, so one
function works for every type:

```resid
T last(List(T) xs) { return xs[xs.len() - 1]; }

Int main() {
    println(f"{last([1, 2, 3])} {last(["a", "b"])}");
    return 0;
}
```

```text title="Output"
3 b
```

A generic function that sorts, shows or compares its `T` says so with
`@needs(Ord(T))`; see [Generic functions and records](/Resid/behaviors/generics/).

## Entry point

`Int main()` is the program. Its return value is the exit status.
