# mandelbrot (Resid, best)

The st program's algorithm (`../../../st/mandelbrot/resid/`, see its
NOTES.md for the output workarounds), made data-parallel and parallel:

- **16 pixels in lockstep.** `iterk` iterates 16 pixels of a row as 16
  independent scalar chains in one tail-recursive loop; clang's SLP
  vectorizer packs them into AVX-512/AVX2 registers (`-march=native`).
  Resid has no SIMD types; the program only lays the work out so the
  vectorizer can find it.
- **No per-step escape test.** For |c| < 2 an orbit with |z| > 2 grows
  without bound, so "escaped at some step" equals "not |z_50|^2 <= 4"
  (an overflow to inf or NaN compares false), the test of the fastest C
  programs. Every 5 steps the block stops once all 16 pixels have
  escaped. Results are identical to the per-step test.
- **Bands in parallel.** The image is cut into bands of 16 rows, computed
  in waves of 64 concurrent `spawn` regions, started through a recursion
  that waits for each band on the way back so the bands print in order.

Output is byte-identical to the C st program (checked at 17, 203, 1000
and 16000). Measured on this host (2026-09-27): 0.25 s at 16000 (was
1.37 s with the scalar per-pixel loop).
