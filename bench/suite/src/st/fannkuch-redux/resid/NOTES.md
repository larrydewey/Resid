# fannkuch-redux (Resid, st)

Port of the fannkuch-redux description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/fannkuchredux.html):
permutations generated in the reference order (count[] rotation scheme),
checksum with alternating sign by permutation index, output
`checksum\nPfannkuchen(n) = maxflips`.

Deviations and workarounds:

- No mutable arrays: the permutation (n <= 16) and the count[] array are
  each packed 4 bits per element into one `Int`. A pancake flip of the
  first k+1 elements is done in O(1) with a full 16-nibble reversal
  (shift/mask swaps) and a shift, rather than an element-by-element swap
  loop; rotating perm1's prefix is also O(1). The algorithm (which
  permutations are visited, in which order, and how flips are counted) is
  unchanged.
- The two nested loops of the reference are two mutually tail-calling
  functions with identical signatures (`run`/`next_perm`), which the
  compiler emits as `musttail` calls; nothing is allocated in the main loop.
- The final (checksum, maxflips) pair is returned packed as one `Int`
  (`checksum * 256 + maxflips`) to avoid a record allocation.

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

Measured (this host): size 10 0.11 s, 7.9 MB peak RSS; size 12
17.7 s, 7.9 MB (checksum 3968050, maxflips 65).
