---
title: Reduction
description: The reduction obligation, specialization, dead-binding elision, facts, budgets and termination.
---

**Compilation is maximal authorized reduction of first-class knowledge.**
The compiler must reduce every computation it can prove under the granted
capabilities; what remains is the residual program, lowered through LLVM.

## The reduction relation

It covers β-reduction, constant folding, constraint discharge, provider
substitution, behavior insertion, method desugaring for handles, pattern
matching, destructuring, checked arithmetic, numeric widening, string
interpolation, range and slice construction, dead-binding elision, and
check discharge from facts.

- **Evaluation.** A call whose arguments are all known is evaluated. A pure
  call that re-enters itself with identical arguments is left residual.
- **Specialization.** A call whose arguments are partly known is replaced by
  a call to a copy of the callee reduced under the known arguments. Known
  fields of a partly known record count as known.
- **Termination.** Specializations of the same function are compared with
  a homeomorphic-embedding test (integers by sign and magnitude, strings by
  length, other values by equality); when an ancestor embeds in a new
  call, the changed positions are generalized. A specialization is kept
  only when it shrinks the callee.
- **Dead bindings.** A binding whose value is fully known and unused is
  removed. A binding whose evaluation could perform an effect, abort or not
  terminate is kept even when unused.

## Facts

A residual value may carry facts that hold on every execution: `range`,
`bits`, `nonzero`, `length`, `fields`, `tag`, `unreachable`, `path`. They
come from literals, types, operators, conversions, dominating conditions,
asserts and known fields, and they are used to discharge overflow,
division, bounds, conversion, capacity and capability checks, to select
branches under a residual scrutinee, and to fold known fields out of
residual composites. A discharged check is recorded, so a debugger can
show why it is absent.

## Determinism and budgets

Reduction is bounded only by budgets, and every budget counts work: steps,
calls, nesting and the size of the values the evaluator builds. None reads
the clock or the compiler's own memory, so every implementation of the
compiler reduces a program the same way. A budget never changes meaning;
it only decides how much work stays residual, and each exhausted budget is
reported as `note: reduce: ...`. Reduced and unreduced programs behave
identically, including their failures: an overflowing operation is never
folded; it stays residual and traps at run time.

| Budget | Default | What it bounds |
|---|---|---|
| fuel | 16,000,000 steps | evaluation over the whole program |
| steps | 65,536, doubling | one top-level call's attempt; a call that runs out is tried again with twice the steps, up to an eighth of the fuel left |
| memory | ¼ of `RESID_MEM_LIMIT` | what one attempt holds: each step and non-tail call, and the bytes of each value built or read |
| depth | 20,000 | non-tail nesting |
| specs | 400 per program, 8 per function | specialization attempts |

How far it goes scales with what the program asks for, not with one fixed
cutoff:

- **Tail calls loop.** A call in tail position (`return f(...)`, also
  through parentheses and an `if` whose condition is known) is evaluated
  in a loop, not nested. It costs no depth and no memo entry, and each
  iteration's garbage is dropped, so a loop of millions of steps folds in
  constant memory.
- **Only the taken arm.** An `if`, `?:` or `match` with a known condition
  reduces only the arm it selects, so a recursion's base case does not run
  the other arm on.
- **Doubling.** Cheap calls finish in the first attempt; an expensive one
  is retried with twice the steps, so it wastes at most what it finally
  needs, and the per-call cap shrinks as the fuel goes, so one call cannot
  starve the rest of the program.

To go further, raise the budget for a build, a package or a function:

- `residc app.resid --reduce-budget 200000000`, or `--reduce-budget
  unbounded`: no step or depth limit, only the memory meter (half the
  compiler's memory budget). A long evaluation reports itself as it goes.
- `[reduce] budget = ...` in `resid.toml` does the same for a package's
  build and tests.
- `@reduce(steps = N)` (or `steps = unbounded`) on a function gives each of
  its top-level calls `N` steps of its own, outside the fuel.
- `@fold` on a function requires every call of it to reduce, with no step
  limit: a call with an argument that is not known, or one that does not
  reduce, fails the build (`E0903`).

```resid
@fold
Int tri(Int n, Int acc) {
    if (n == 0) { return acc; }
    return tri(n - 1, acc + n);
}

Int main() {
    println(f"{tri(1000000, 0)}");
    return 0;
}
```

The budget is part of the build: a budget other than the default is
recorded in the binary's provenance (`attestation: reduction budget ...`).

The compiler's own resources can still run out first. Compile-time
evaluation recurses on the compiler's stack, and past its end the build
fails (`E0902`; raise `RESID_STACK_MB`) instead of leaving the call
residual, since how much stack there is is not a budget. Past
`RESID_MEM_LIMIT` the compiler aborts.

Specialization has two budgets: 400 attempts per program and 8 per
function. An attempt counts even when it is then dropped for not
shrinking the callee, so a large program reports `note: reduce:
specialization attempt limit (400) reached`. The calls past it stay
general and clang still optimizes them. Measured on the compiler itself
(2026-10-09), one attempt per function (2,819) adds 8% to its IR and its
compile memory, and the compiler it builds is no faster; the benchmark
suite never reaches 400. The budgets sit where the gain stops.

## rt and known

`rt e` and `@residual` make a value residual on purpose. `known(x)`
fails the build (`E0901`) if `x` is residual; `rt_known(x)` checks at run
time. `comptime_print(e)` prints `e`'s reduced value during the build.
