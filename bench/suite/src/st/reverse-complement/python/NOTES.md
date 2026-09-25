# st / reverse-complement / python

Written for this suite. It follows the Benchmarks Game description of reverse-complement, single-threaded (CPython, stdlib only, no multiprocessing or native extensions).

Algorithm: Reads all of stdin, then per sequence complements through a lookup table, reverses, and writes 60-column lines.

No deviations from the reference algorithm.
