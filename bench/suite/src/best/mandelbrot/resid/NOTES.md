# mandelbrot (Resid, best)

The st program's algorithm (`../../../st/mandelbrot/resid/`, see its
NOTES.md for the output workarounds), made data-parallel and parallel:

- **32 pixels in lockstep.** `iterv` iterates 32 pixels of a row as four
  `Vec(Float, 8)` (spec §46), AVX-512 registers with `-march=native`; the
  inside/outside byte comes from a lane mask (`bits()`, bit-reversed).
- **No per-step escape test.** For |c| < 2 an orbit with |z| > 2 grows
  without bound, so "escaped at some step" equals "not |z_50|^2 <= 4"
  (an overflow to inf or NaN compares false), the test of the fastest C
  programs. Every 5 steps the block stops once all 16 pixels have
  escaped. Results are identical to the per-step test.
- **Bands in parallel.** The image is cut into bands of 16 rows, computed
  in waves of 64 concurrent `spawn` regions, started through a recursion
  that waits for each band on the way back so the bands print in order.

Output is byte-identical to the C st program (checked at 17, 40, 203, 1000
and 16000). Measured on this host (2026-09-27): 0.18 s at 16000 (0.25 s
with 16 scalar lanes, 1.37 s with the scalar per-pixel loop).
