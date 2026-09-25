# k-nucleotide / pascal / best

Not a Benchmarks Game program: the Benchmarks Game has no Free Pascal
k-nucleotide entry.

This is a tuned version of the st cell. It uses the same algorithm and the same
hash table (`Generics.Collections.TDictionary`, 2-bit packed QWord keys), with
these changes:
- The dictionary maps key -> index into a count array, so a hit is one lookup
  instead of TryGetValue plus a store.
- A cheap multiplicative hash is supplied through an IEqualityComparer.
- Each dictionary is pre-sized.
- The seven frames are counted concurrently, one TThread each, largest first.

Build: `fpc -XXs -O3 -Ci- -Cr- -g- -CpCOREAVX -CfAVX -Tlinux` (the Benchmarks
Game Free Pascal flags). Ignores argv.
