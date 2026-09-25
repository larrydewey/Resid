# pidigits / java (st)

Written for this suite from the Benchmarks Game description of the algorithm:
single-threaded, no SIMD (no jdk.incubator.vector), no JNI/FFM.
Bignum: java.math.BigInteger (the standard library).

- Toolchain: OpenJDK 26 `javac -d out`, run with default HotSpot flags (`java -cp out ...`).
- Verified byte-identical against the Benchmarks Game expected output at its
  reference size, and against the `best` java/csharp cells at the contract small size.
