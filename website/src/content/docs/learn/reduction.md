---
title: Compile-time reduction
description: What the compiler computes for you, how runtime work enters with rt, and how to see what remained.
---

The Resid compiler must **reduce every computation it can prove** before it
emits code. This is not an optimization you can turn off; it is what
compiling means in Resid.

- A call whose arguments are all known is **evaluated**.
- A call with some known arguments is **specialized**: the compiler makes a
  copy of the function with those arguments filled in.
- A binding whose value is known and no longer needed is **elided**.
- Checks the compiler can prove unnecessary (overflow, division by zero,
  bounds) are **discharged** and not emitted.

What cannot be reduced is *residual*, and only that is lowered to machine
code.

## Seeing reduction

`comptime_print(e)` reports `e`'s reduced value while compiling:

```resid
Int fib(Int n) {
    return if (n < 2) { n } else { fib(n - 1) + fib(n - 2) };
}

Int main() {
    comptime_print(fib(20));
    println(f"{fib(20)}");
    return 0;
}
```

```text title="Output"
6765
```

The compiler prints `[comptime_print] 6765` during the build, and the binary
just prints a constant.

## Runtime work enters explicitly

Values from outside the program (arguments, files, the environment, stdin)
are unknown by nature. To make a value residual on purpose, mark it with
`rt`:

```resid
Int main() {
    Int a = 20;
    Int b = rt 22;        // treated as unknown while compiling
    known(a);             // a compile-time check: a must be known
    rt_known(b);          // accepted: b is residual on purpose
    println(f"{a + b}");
    return 0;
}
```

```text title="Output"
42
```

`@residual Type x = e;` does the same for a whole binding. `known(x)`
fails the build if `x` is not known at compile time.

## What remained, and why

Every build writes the **knowledge graph**
(`<binary>.resid-graph.cbor`): every node of the program, what was
reduced (and by which rule), and for everything that stayed residual, the
reason. It also writes **residual notes**
(`<binary>.resid-notes.cbor`), the runtime work you could still remove.
`resid-why` answers questions about them:

```text
$ resid-why hello --summary
$ resid-why hello --at hello.resid:12
```

See [resid-why, resid-graph and resid-debug](/Resid/tools/why-graph-debug/).

## Guarantees

Reduction never changes meaning: reduced and unreduced programs behave
identically, including when they fail. An overflow is never folded
away; it is left residual so it traps at run time, exactly as the
unreduced program would. Budgets on steps and specializations keep compile
times bounded; when one runs out, the compiler says so with a
`note: reduce: ...` and leaves the rest residual.
