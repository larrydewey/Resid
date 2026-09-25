# st / spectral-norm / python

Written for this suite. It follows the Benchmarks Game description of spectral-norm, single-threaded (CPython, stdlib only, no multiprocessing or native extensions).

Algorithm: Power method with 10 iterations of AtA*u, A(i,j)=1/((i+j)(i+j+1)/2+i+1). Uses explicit accumulation loops rather than `sum()`, because `sum()` has used compensated summation since 3.12.

No deviations from the reference algorithm.
