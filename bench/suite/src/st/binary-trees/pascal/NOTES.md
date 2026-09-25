# binary-trees / pascal / st

Own implementation of the reference algorithm. Each node is allocated with `New` and released with `Dispose` (default FPC heap manager); there is no pool.

Free Pascal 3.2.2 stands in for Delphi/Object Pascal. Single-threaded, no SIMD intrinsics. Build: `fpc -O2`.
