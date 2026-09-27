# reverse-complement (Resid, best)

The single-threaded program's per-character loop
(`../../../st/reverse-complement/resid/`, see its NOTES.md), made parallel
inside each sequence:

- The body of each sequence is cut into 16 byte ranges. Concurrent
  `spawn` regions slice their range and count its bases (`str_len` minus
  `str_count` of newlines).
- The bases after a range fix the output column it starts at, so a second
  wave of 16 regions builds each range's reverse complement with its line
  breaks independently; the ranges are printed last to first.
- A spawned region inherits the parent's known lengths of all-ASCII
  strings (runtime `str_fast_save`/`str_fast_load`), so slicing the shared
  254 MB input does not rescan it in every thread.

Compiled with `-O3 -march=native`, like the other languages' best cells
(Resid has no SIMD types or intrinsics). Output identical to C (official
and small inputs).

Measured on this host (2026-09-27): 0.23 s on the official input (was
0.40 s with one region per sequence); about 0.10 s of it is the serial
read and first index of the input.
