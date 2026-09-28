# reverse-complement (Resid, st)

Port of the reverse-complement description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/revcomp.html):
read the FASTA file from stdin; for each sequence write its header line and
then the reverse complement (IUPAC table, upper- and lower-case input,
upper-case output), 60 bases per line.

Notes:

- The file is read whole with `filesystem.read_all("/dev/stdin")` (a
  regular file is read at its stat size; a pipe is read to end of file).
- The text is never split into lines. Sequence boundaries come from
  `str_index_of` (headers are found as `"\n>"`), and each body is walked
  backwards in place with `str_char_at`, skipping its newlines. On an
  all-ASCII string `str_char_at` is a compare and a byte load, and it
  inlines into the loop under the default LTO build.
- The complement is a lookup string over the printable ASCII codes
  (`comp_table`, the table of `complement` spelled out); other codes go
  through `complement`.
- Output goes to one `StrBuf`. The compiler keeps a StrBuf in registers
  ({cur, lim}; it is linear, so it needs no handle), so an ASCII
  `push_char` is a bounds test and a byte store; `print(sb.finish())`
  writes the buffer without measuring it again. The whole output is
  printed once (`print` flushes on every call).
- In the tail-recursive loop the text is a parameter passed back
  unchanged, so the compiler reads its all-ASCII length once at entry and
  each `str_char_at` is a bounds test and a byte load.
- Peak memory is the input text plus the output text, the same as the C
  program.

Measured on this host (2026-09-27), 254 MB input (fasta 25000000,
official): 0.32 s pinned to CPU 2 (C: 0.19 s; 0.44 s before StrBuf in
registers and loop string views). Output byte-identical to the C cell.
