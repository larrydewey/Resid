# mandelbrot / pascal / st

Own implementation of the reference algorithm (50 iterations, escape |z|^2 > 4, rows padded to whole bytes). The header goes through `Write`, and the pixel buffer goes out with `FileWrite(StdOutputHandle, ...)`.

Free Pascal 3.2.2 stands in for Delphi/Object Pascal. Single-threaded, no SIMD intrinsics. Build: `fpc -O2`.
