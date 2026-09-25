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
- Resid has no `sqrt`. `sqrt_fix` computes a correctly rounded square root
  in pure Resid: Newton iteration to within ~1 ulp, then an exact residual
  `d - x*x` via Dekker's two-product (Veltkamp split) and one final
  correction. Verified bit-identical to C `sqrt` on 20000 random inputs.
  In the hot loop Newton starts from the same pair's distance one step
  earlier (carried as 10 extra scalar parameters), so two iterations
  suffice; the setup and the energy reports use a general range-reduced
  version.
- Resid has no `printf`; `fmt9` formats `%.9f` exactly (fraction scaled by
  1e9 in `Float(128)`, round half to even on the exact binary value).

General Resid constraints that shape this port (see the source header too):

- No mutation or reassignment; every loop is a self tail call (or a tail
  call between functions of identical signature), which the compiler turns
  into a jump/`musttail`, so loops do not grow the stack.
- No `free`: anything allocated per iteration is leaked for the rest of the
  run, so hot loops keep their state in scalar parameters.
- `Int * Int` widens to `Int(128)`; products are narrowed with `i64(...)`.
- `&&`/`||` evaluate both operands, so short-circuit conditions are
  written as nested `if`s.
- Compiled with the default `-O2` (`build/boot/stage2.bin`, which links the
  runtime with `clang -O2`).

Measured (this host): size 5000000 0.32 s, 7.8 MB peak RSS; size
50000000 3.06 s, 8.1 MB (output identical to C).
