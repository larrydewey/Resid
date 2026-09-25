# st / spectral-norm / javascript

Written for this suite. It follows the Benchmarks Game description of spectral-norm, single-threaded (node, no worker_threads).

Algorithm: Power method with 10 iterations of AtA*u, A(i,j)=1/((i+j)(i+j+1)/2+i+1).

No deviations from the reference algorithm.
