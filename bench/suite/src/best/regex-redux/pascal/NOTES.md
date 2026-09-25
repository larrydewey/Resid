# regex-redux / pascal / best

Source: regex-redux Free Pascal (Vitaly Trifonov, Peter Blackman, Michal Stransky), binds PCRE (v1) with JIT study
https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/regexredux-fpascal-1.html

Benchmarks Game programs are distributed under the revised BSD license (3-clause BSD), https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html.

Unmodified source. It links the legacy PCRE1 library (`libpcre.so.1`), which is present on this host; no other Free Pascal regex-redux entry exists.

Build: Benchmarks Game flags, `fpc -XXs -O3 -Ci- -Cr- -g- -CpCOREAVX -CfAVX -Tlinux` (Free Pascal 3.2.2, the same version the Benchmarks Game uses; it stands in for Delphi/Object Pascal).
