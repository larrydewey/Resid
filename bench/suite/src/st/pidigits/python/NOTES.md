# st / pidigits / python

Written for this suite. It follows the Benchmarks Game description of pidigits, single-threaded (CPython, stdlib only, no multiprocessing or native extensions).

Algorithm: Step-by-step unbounded spigot (the Gibbons/Ledrug algorithm from the reference C/GMP program), using the language bignum. Bignum: built-in int.

No deviations from the reference algorithm.
