# spectral-norm / pascal / st

Own implementation of the reference algorithm. Note: FPC gives untyped float constants the smallest exact type, so `1.0 / int` would be evaluated in single precision; the divisor is cast to `double` explicitly.

Free Pascal 3.2.2 stands in for Delphi/Object Pascal. Single-threaded, no SIMD intrinsics. Build: `fpc -O2`.
