# regex-redux / java (best)

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/regexredux-javavm-2.html
(Benchmarks Game, revised BSD license — https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html).
Chosen as the fastest Java (HotSpot, "javavm") program by elapsed time on the
Benchmarks Game "fastest" page. Program text copied verbatim unless noted.

- Build: `javac -d out` (OpenJDK 26; Benchmarks Game used JDK 23).
- Run flags (as on the Benchmarks Game): `--enable-native-access=ALL-UNNAMED`. Multithreaded, PCRE2 (JIT) via the FFM API.
- Deviation: the program is compiled against jextract-generated PCRE2 bindings
  (`jextract_pcre2.pcre2_h`, Benchmarks Game Include/java, not published). jextract is not
  installed, so `jextract_pcre2/pcre2_h.java` is a small hand-written stand-in exposing
  just the symbols the program uses via java.lang.foreign downcalls to libpcre2-8.so.0.
  The program source is verbatim.
