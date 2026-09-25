# st / regex-redux / python

Written for this suite. It follows the Benchmarks Game description of regex-redux, single-threaded (CPython, stdlib only, no multiprocessing or native extensions).

Algorithm: Strips headers and newlines, counts 9 variant patterns, then applies the 5 IUB substitutions in order. Regex: `re` module.

No deviations from the reference algorithm.
