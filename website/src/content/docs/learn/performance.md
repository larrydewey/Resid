---
title: Performance
description: How immutable Resid code runs fast, and the few patterns to avoid.
---

Resid code is written with immutable values, but it does not run like a
persistent-data-structure interpreter. The compiler recovers mutation
wherever it is safe:

- **Tail calls are loops.** A recursive call in tail position compiles to a
  jump.
- **Owned collections update in place.** When the compiler proves a map,
  list or string builder has exactly one owner (its old version is never
  read again), `insert`, `push` and friends write into the existing
  buffer. This is how a `Map` built in a loop runs as fast as a hash table.
- **Builders are linear.** `StrBuf` and `ListBuf(T)` append in amortized
  O(1), and the type checker guarantees nothing observes them while they
  grow.
- **Facts remove checks.** Ranges known from literals, loop bounds and
  conditions let the compiler drop overflow and bounds checks it can prove
  unnecessary.
- **Scalars need no allocation.** Integers and floats live in registers;
  temporary garbage from computing a scalar is freed when the computation
  ends.
- **Known work is gone.** Anything computable at compile time is computed
  at compile time.

## Patterns to avoid

**Growing a string with `+` in a loop.** Each `s + piece` copies `s`, so
building an n-piece string that way is O(n²). Use `StrBuf`, or collect pieces
in a `ListBuf(Str)` and `str_join` them once.

**Appending to an old version of a list.** `xs.concat([x])` is cheap when
`xs` is not used afterwards. Appending to a version you keep using forces
a copy.

**Re-reading an accumulator you are building.** Pass it along, finish it
once.

**Merging many maps into one.** Build one map through the loop instead of
creating a map per step and merging.

The [benchmarks](/Resid/tools/benchmarks/) compare Resid with other
languages on standard programs, with the reasons for each result.
