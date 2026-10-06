# regex-redux (Resid, best)

The st cell's program made parallel, as the fastest C and Rust programs
are: headers and line breaks are stripped first (one pass), then nine
`spawn` regions count the variant patterns and a tenth runs the five IUB
substitutions alongside them, all reading the shared, immutable sequence.
The engine is the standard library's `lib/regex.resid`: every pattern here
compiles to a whole DFA, so counting and replacing are loops over a flat
transition table with no per-character allocation.

Build: `-O3 -march=native` (see `build`). Output byte-identical to the C
program.
