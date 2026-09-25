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
- The complement is a chain of `if`s over code points (LLVM turns it into
  a bit test plus table load); output goes to one string builder
  (`str_sb_append_cp`, a flat growable buffer), and `str_sb_finish` hands
  that buffer back without copying. The whole output is printed once
  (`print` flushes on every call).
- Peak memory is the input text plus the output text, the same as the C
  program.

Measured on this host (2026-09-25), 254 MB input (fasta 25000000,
official): 0.37 s task-clock / 487 MB peak RSS (C: 0.14 s / 487 MB).
Output byte-identical to the C cell.
