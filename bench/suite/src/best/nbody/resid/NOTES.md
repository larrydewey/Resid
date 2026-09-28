# nbody (Resid, best)

The st program (`../../../st/nbody/resid/`, see its NOTES.md for the
algorithm and every workaround), with each step's ten pair distances,
square roots and magnitudes computed in vectors (spec §46): pairs 0-3 and
4-7 in two `Vec(Float, 4)` and pairs 8-9 in a `Vec(Float, 2)`, each lane
the reference's `dx*dx + dy*dy + dz*dz`, `sqrt` and `0.01 / (d2 * dist)`.
The velocity and position updates stay scalar, in the reference's order,
so the output is identical to C. Compiled with `-O3 -march=native`, like
the other languages' best cells.

Layouts measured on this host (2026-09-27), n = 50000000:

| layout | time |
| --- | ---: |
| scalar (the st program) | 1.18 s |
| pair math in 4 + 4 + 2 lanes (this cell) | 1.08 s |
| pair math in 2 x 5 lanes / 8 + 2 lanes | 1.16 s / 1.29 s |
| a Vec(Float, 4) per body (x, y, z, 0) | 1.53 s |
| structure of arrays, bodies in Vec(Float, 8) lanes | 1.26 s |

The time step is one dependency chain through a square root and a
division, so the whole-vector layouts pay the 512-bit latencies of this
CPU; the 256-bit groups keep the rest in scalar registers.
