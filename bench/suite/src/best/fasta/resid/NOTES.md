# fasta (Resid, best)

The algorithm of the st cell (`../../../st/fasta/resid/`), with the two
ideas of the fastest C programs:

- **Lookup tables.** The generator has IM = 139968 states, so the code
  picked for each state is precomputed once (a 139968-byte `Str` per
  table) with the reference's cumulative comparison (first entry with
  `r < cumulative p`, `r = state / IM`, the same Float operations as the
  st cell). The inner loop is the generator step, one byte load and one
  append.
- **Jump-ahead, in parallel.** The generator `s -> (IA*s + IC) mod IM` is
  affine, so its k-th iterate is computed in O(log k) by squaring the
  map. Each section is cut into blocks of 8192 lines; each block starts
  from its own generator state and is built by its own concurrent
  `spawn` region (waves of 16, the host's hardware threads), and the
  blocks are printed in order. The repeated ALU section is split the
  same way (block offset mod 287).

Output is byte-identical to the C st program (checked at N = 0, 7, 1000,
2500000 and 25000000). Compiled with `-O3 -march=native`.

Measured on this host (2026-09-27), N = 25000000: 0.13 s wall (0.80 s
CPU).
