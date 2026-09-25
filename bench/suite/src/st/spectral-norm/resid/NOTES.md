# spectral-norm (Resid, st)

Port of the spectral-norm description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/spectralnorm.html):
10 rounds of `v = AtA u; u = AtA v`, then `sqrt(u.v / v.v)`, summations in
the same order as the reference C program.

Deviations and workarounds:

- Vectors are `List(Float)` built by tail-recursive `acc.concat([x])`
  loops. Since the flat-list runtime change, such a list is one contiguous
  buffer that the accumulator appends to in place (it is always the
  buffer's tip), and an element read is an indexed load plus an unbox at a
  fixed offset, both inlined into the loop by the LTO link. Each element is
  still a heap-boxed `Float`, and each of the 40 matrix-vector products
  allocates a fresh vector that is never freed.
- No `sqrt` builtin: correctly rounded Newton + Dekker residual correction
  in pure Resid (`sqrt_fix`, same helper as nbody).
- No `printf`: `fmt9` formats `%.9f` exactly via `Float(128)`.

General Resid constraints that shape this port (see the source header too):

- No mutation or reassignment; every loop is a self tail call (or a tail
  call between functions of identical signature), which the compiler turns
  into a jump/`musttail`, so loops do not grow the stack.
- No `free` and no garbage collector. The compiler releases everything a
  scalar binding's initializer allocates (`Int x = f(...)` runs in a
  scalar scope, see `runtime/resid_rt.c`); anything else allocated per
  iteration stays live for the rest of the run, so hot loops keep their
  state in scalar parameters.
- `Int * Int` widens to `Int(128)`; products are narrowed with `i64(...)`.
- `&&`/`||` evaluate both operands, so short-circuit conditions are
  written as nested `if`s.
- Compiled with the default `-O2` (`build/boot/stage2.bin`, which links the
  runtime with `clang -O2`).

Measured (this host), size 5500: 5.40 s and 116 MB peak RSS with the
original trie-backed lists and a non-LTO link; 1.08 s and 47 MB after the
LTO link and flat lists (C `-O2`: 0.78 s). The remaining gap is mostly
that gcc vectorises the C inner loop's division (`divpd`) over a flat
`double[]`, while Resid's loop reads boxed elements one at a time.
