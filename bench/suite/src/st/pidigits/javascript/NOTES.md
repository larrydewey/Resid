# st / pidigits / javascript

Written for this suite. It follows the Benchmarks Game description of pidigits, single-threaded (node, no worker_threads).

Algorithm: Step-by-step unbounded spigot (the Gibbons/Ledrug algorithm from the reference C/GMP program), using the language bignum. Bignum: BigInt.

No deviations from the reference algorithm.
