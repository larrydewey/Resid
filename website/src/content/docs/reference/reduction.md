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

Budgets count evaluation steps, calls and allocations, never time, so a
compiler reduces a program the same way every time. A budget never changes
meaning; it only decides how much work stays residual, and each exhausted
budget is reported as `note: reduce: ...`. Reduced and unreduced programs
behave identically, including their failures: an overflowing operation is
never folded; it stays residual and traps at run time.

Specialization has two budgets: 400 attempts per program and 8 per
function. An attempt counts even when it is then dropped for not
shrinking the callee, so a large program reports `note: reduce:
specialization attempt limit (400) reached`. The calls past it stay
general and clang still optimizes them. Measured on the compiler itself
(2026-10-05), removing the limit keeps 485 specializations instead of 52
(1,805 with no per-function limit) and costs up to 3.5x the compile
memory, but the compiler it builds is no faster; with no specialization
at all it is about 2.5% slower. The budgets sit where the gain stops.

## rt and known

`rt e` and `@residual` make a value residual on purpose. `known(x)`
fails the build (`E0901`) if `x` is residual; `rt_known(x)` checks at run
time. `comptime_print(e)` prints `e`'s reduced value during the build.
