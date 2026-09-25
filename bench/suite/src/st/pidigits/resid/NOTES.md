# pidigits (Resid, st)

Port of the pidigits description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/pidigits.html):
the streaming spigot of the reference programs (numer/accum/denom;
next_term, digit when extract_digit(3) == extract_digit(4), eliminate_digit),
printed 10 digits per line with `\t:N`, the last line space-padded.

Deviations and workarounds:

- **Bignum.** Resid has no arbitrary-precision integers, but `Dec(N)` is
  an exact decimal for any N (spec §6.6a), and the runtime stores a value
  as a base-10^19 coefficient sized by the digits it actually has, so
  `Dec(1000000)` integers act as bignums (the numbers reach about 146000
  digits at N = 10000, far below the 1000000-digit precision, so nothing
  is ever rounded). Multiplying by a small integer, adding and comparing
  are single linear passes.
- **Fewer passes, same arithmetic.** numer is carried doubled
  (`n2 = 2*numer`) so `accum + 2*numer` is one add, and eliminate_digit's
  `accum *= 10; numer *= 10` is left pending and folded into the next
  next_term's multipliers. Both are exact rewrites of the reference steps.
- **Digit extraction.** `(3*numer + accum) / denom` and the same with 4
  are estimated from 34-digit roundings of the three numbers (`d34`, O(1)
  on the runtime representation) and a `Dec(34)` division, and verified
  exactly with full-width multiply/compare when the estimate is within
  1e-9 of an integer; `numer > accum` is decided the same way. This
  replaces GMP's `mpz_tdiv_q`; results are exact.
- **Memory.** Resid never frees, so iterations run in blocks of 16 inside
  runtime arena scopes (`resid_bulk_push`/`resid_bulk_pop`), 32 blocks per
  outer scope. `resid_dec_persist` copies the three live numbers into the
  enclosing scope before each pop.

Measured on this host (2026-09-25), N = 10000 (official): 0.41 s / 23 MB
peak RSS (C/GMP: 0.40 s / 15 MB); N = 2000: 0.02 s. Output byte-identical to
the C cell at N = 1, 27, 30, 1234, 2000, 9999 and 10000.
