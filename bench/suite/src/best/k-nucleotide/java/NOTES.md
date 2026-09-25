# k-nucleotide / java (best)

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/knucleotide-javavm-1.html
(Benchmarks Game, revised BSD license — https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html).
Chosen as the fastest Java (HotSpot, "javavm") program by elapsed time on the
Benchmarks Game "fastest" page. Program text copied verbatim unless noted.

- Build: `javac -d out` (OpenJDK 26; Benchmarks Game used JDK 23).
- Run flags (as on the Benchmarks Game): `-cp out:out/fastutil-8.3.1.jar` (the Benchmarks Game classpath). Multithreaded.
- Dependency: fastutil 8.3.1 (Apache-2.0), downloaded by `build` from Maven Central into
  out/ on first build (the Benchmarks Game uses the same jar from /opt/src/java-libs).
  All faster-than-next Java k-nucleotide programs (#1, #3, #6) use fastutil.
