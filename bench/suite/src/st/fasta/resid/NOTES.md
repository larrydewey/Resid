# fasta (Resid, st)

Port of the fasta description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/fasta.html):
ALU repeated for 2n characters, then 3n IUB and 5n Homo sapiens characters
from the benchmark LCG (IM = 139968, IA = 3877, IC = 29573, seed 42),
cumulative-probability lookup (first entry with `r < cumulative p`), 60
characters per line.

Deviations and workarounds:

- `print` flushes stdout on every call, so output is accumulated in the
  runtime string builder (`str_sb_new`/`str_sb_append_cp`/`str_sb_finish`)
  and printed in blocks of 16384 lines (~1 MB).
- The cumulative tables are passed as `Float` scalar parameters and the
  lookup is an unrolled chain of `if`s (no list lookups, no allocation in
  the inner loop).
- `print(str_sb_finish(sb))` is compiled to one runtime call that writes
  the builder's buffer and frees it (the finished string is a temporary no
  other expression can see), so each ~1 MB block is released after it is
  written and peak memory stays at one block.

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

Measured (this host, 2026-09-25): size 25000000 2.26 s, 3.2 MB peak RSS
(C: 2.36 s, 1.7 MB); size 2500000 0.23 s. Output identical to C.
