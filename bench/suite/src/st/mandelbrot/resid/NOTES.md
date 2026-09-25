# mandelbrot (Resid, st)

Port of the mandelbrot description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/mandelbrot.html):
plain scalar escape-time loop, 50 iterations, escape when
`Zr^2 + Zi^2 > 4`, `Cr = 2x/w - 1.5`, `Ci = 2y/h - 1`, binary PBM output
(`P4`), rows padded to whole bytes.

Deviations and workarounds:

- Raw output: `print`/`println` write NUL-terminated UTF-8 strings, so they
  cannot emit byte 0 or bytes >= 128. The header is printed with `print`;
  each row's bytes are packed into a `List(Int)` and written with
  `print_bytes` (each element's low 8 bits, as raw bytes, to the same
  stdout stream).
- Memory: a row is built and written inside one scalar binding
  (`Bool ok = emit_row(y, w, fw);`), which the compiler evaluates in a
  scalar scope, so the row's list is released as soon as it has been
  written and peak memory stays at one row.

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

Measured (this host, 2026-09-25): size 16000 11.4 s, 2.3 MB peak RSS
(C: 11.0 s, 1.8 MB); size 4000 0.73 s. Output identical to C.
