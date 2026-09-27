# nbody (Resid, st)

Port of the n-body description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/nbody.html),
following the operation order of the reference C program (Benchmarks Game,
3-clause BSD) so every floating-point rounding matches.

Deviations and workarounds:

- The five bodies (positions, velocities, masses) are 35 `Float` scalar
  parameters of the tail-recursive `advance` loop instead of an array of
  structs: Resid has no mutable records/arrays and a list or record per
  step would be allocated and never freed (50M steps). The ten pair
  interactions are unrolled mechanically in reference order (i < j).
- `sqrt` is the builtin correctly rounded IEEE square root (one
  `sqrtsd`), as in the C program.
- Resid has no `printf`; `fmt9` formats `%.9f` exactly (fraction scaled by
  1e9 in `Float(128)`, round half to even on the exact binary value).

General Resid constraints that shape this port (see the source header too):

- No mutation or reassignment; every loop is a self tail call (or a tail
  call between functions of identical signature), which the compiler turns
  into a jump/`musttail`, so loops do not grow the stack.
- No `free` and no garbage collector. The compiler releases everything a
  scalar binding's initializer allocates (`Int x = f(...)` runs in a
  scalar scope; the runtime's scope regions are in `runtime/rt/alloc.resid`); anything else allocated per
  iteration stays live for the rest of the run, so hot loops keep their
  state in scalar parameters.
- (Written when `Int * Int` widened to `Int(128)`; the `i64(...)` narrowings
  it needed are now no-ops: every operator keeps the operand width, spec §6.1.)
- (Written when `&&`/`||` evaluated both operands; they short-circuit now,
  spec §30, so the nested `if`s are only a style.)
- Compiled with the default `-O2` (`build/boot/stage2.bin`, which links the
  runtime with `clang -O2`).

Measured (this host, 2026-09-27): size 50000000 1.45 s pinned to CPU 2
(C: 1.87 s), output identical to C. Before the `sqrt` builtin the program
computed the root with Newton iterations and a Dekker correction: 2.81 s.
