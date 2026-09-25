# fasta / pascal / st

Own implementation of the reference algorithm (LCG seed 42, double-precision cumulative probabilities, 60-column lines). Output is buffered in 64 KiB and flushed with `FileWrite`.

Free Pascal 3.2.2 stands in for Delphi/Object Pascal. Single-threaded, no SIMD intrinsics. Build: `fpc -O2`.
