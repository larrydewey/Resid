# k-nucleotide / pascal / st

Own implementation. The hash table is the RTL's `Generics.Collections.TDictionary<QWord, LongInt>` (rtl-generics ships with FPC), with keys packed 2 bits per base. Frames are counted one after the other. Stdin is read with `ReadLn` and a 64 KiB text buffer. Ignores argv.

Free Pascal 3.2.2 stands in for Delphi/Object Pascal. Single-threaded, no SIMD intrinsics. Build: `fpc -O2`.
