# mandelbrot (Resid, st)

Port of the mandelbrot description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/mandelbrot.html):
plain scalar escape-time loop, 50 iterations, escape when
`Zr^2 + Zi^2 > 4`, `Cr = 2x/w - 1.5`, `Ci = 2y/h - 1`, binary PBM output
(`P4`), rows padded to whole bytes.

Deviations and workarounds:

- Raw output: `print`/`println` are `fputs` of a NUL-terminated string that
  Resid always UTF-8 encodes, so they cannot emit byte 0 or bytes >= 128.
  The only raw-byte path is `filesystem.write_bytes(path, List(Int))`
  (needs `@requires(filesystem)`), which `fopen`s the path `"wb"`. The whole
  file, header included, is collected into one `List(Int)` and written with
  a single `write_bytes("/dev/stdout", ...)`. Calling it more than once
  would reopen stdout and, when stdout is a regular file, truncate it
  (O_TRUNC, offset 0), losing earlier output; a pipe would be fine but the
  program does not rely on that.
- Memory: `List(Int)` is a persistent 32-way trie with no in-place append.
  The in-place "growable accumulator" optimisation for `f(..., acc.concat([x]))`
  exists in the runtime (`resid_growbuf_*`) but is disabled in the
  self-hosted compiler (`check_growable_shape` in `examples/driver.resid`
  always returns false), so every one-element `concat` copies the tail leaf
  and the root-to-leaf path and leaks the old ones. A first version that
  appended one byte at a time used 1.4 GB at size 4000 and ran out of
  memory (16 GB cap) at 16000. This version packs the byte stream into four
  `Int` words (32 bytes) held in loop parameters and appends each full
  chunk as one 32-element list literal (one leaf-aligned trie leaf), which
  cuts garbage to roughly 35 bytes per output byte.
- The output list is boxed (bytes 0..255 are interned boxes, so only the
  8-byte slot pointers and trie nodes cost memory); `write_bytes` copies it
  into a byte buffer once at the end.

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

Measured (this host): size 4000 0.81 s, 70 MB peak RSS; size 16000
13.6 s, 1.2 GB (output md5 identical to C).
