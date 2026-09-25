# pidigits / java (best)

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/pidigits-javavm-3.html
(Benchmarks Game, revised BSD license — https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html).
Chosen as the fastest Java (HotSpot, "javavm") program by elapsed time on the
Benchmarks Game "fastest" page. Program text copied verbatim unless noted.

- Build: `javac -d out` (OpenJDK 26; Benchmarks Game used JDK 23).
- Run flags (as on the Benchmarks Game): `--enable-native-access=ALL-UNNAMED -Djava.library.path=out`. Single-threaded, GMP via JNI.
- Deviation: the program's JNI glue (Include/java Java_GMP_Wrapper C source) is not
  published by the Benchmarks Game, so `Java_GMP_Wrapper.c` here is a minimal
  re-implementation: each native method forwards straight to the GMP function of the
  same name. `build` compiles it with `gcc -O2 -fPIC -shared ... -lgmp` into
  out/libJava_GMP_Wrapper.so. The Java source is verbatim. Like upstream, output is only
  correct for N that are multiples of 10 (no trailing-line padding); 2000/10000 are fine.
