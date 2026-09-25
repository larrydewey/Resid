# k-nucleotide (Resid, st)

Port of the k-nucleotide description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/knucleotide.html):
read the FASTA input, take the ">THREE" sequence, count every k-nucleotide
for k = 1, 2, 3, 4, 6, 12, 18 in a hashtable (one table per k), print the
1- and 2-mer frequencies sorted by descending frequency (ties
alphabetical) and the counts of the five given fragments.

How it is written:

- One `Map(Int, Int)` per k, keyed by the k-mer's 2-bit-per-base code
  (A=0, C=1, T=2, G=3, computed branch-free as `(c >> 1) & 3`; k <= 18
  fits in 36 bits). Frequency ties are broken by alphabetical rank
  (`alpha_rank`), so the output order matches the reference.
- `count` walks the sequence text with `str_char_at`, skipping line
  breaks, and threads the table through a self tail call, consuming it only
  with `m.insert(..)`. The compiler proves that shape (a linear
  accumulator) and runs the loop over one privately owned table that is
  updated in place and frozen when returned; the caller only ever sees an
  immutable map. `m.get(k) else { 0 }` on an Int-keyed map is a single
  probe with no allocation, and the following insert reuses that probe.
- The input is read whole with `filesystem.read_all("/dev/stdin")`, which
  is why peak memory includes the full input text (the C program keeps only
  the sequence).

History: the first port could not use `Map` at all (every update copied a
trie path and nothing was freed, ~100 GB at the official size) and counted
k >= 3 by matching only the requested fragment. Measured on this host at the
official size: that version 57.6 s / 688 MB; this one 4.85 s / 268 MB
(C `-O2`: 4.18 s / 132 MB). Output byte-identical to the C program.
