# fasta / java (best)

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fasta-javavm-6.html
(Benchmarks Game, revised BSD license — https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html).
Chosen as the fastest Java (HotSpot, "javavm") program by elapsed time on the
Benchmarks Game "fastest" page. Program text copied verbatim unless noted.

- Build: `javac -d out` (OpenJDK 26; Benchmarks Game used JDK 23).
- Run flags (as on the Benchmarks Game): none (`java -cp out fasta`). Multithreaded.
- Deviation: this program's output is wrong at the tiny Benchmarks Game reference size
  (n=1000: it emits extra ALU lines), a property of the upstream program. At the
  contract small size (2500000) and official size (25000000) it is byte-identical to
  the st cell.
