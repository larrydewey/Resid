# st / k-nucleotide / python

Written for this suite. It follows the Benchmarks Game description of k-nucleotide, single-threaded (CPython, stdlib only, no multiprocessing or native extensions).

Algorithm: Hash table (Map/dict) keyed by k-length substrings of sequence THREE, uppercased. Sorted by count descending, then key.

No deviations from the reference algorithm.
