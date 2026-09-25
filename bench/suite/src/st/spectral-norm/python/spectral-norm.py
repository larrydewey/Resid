# spectral-norm: single-threaded, pure CPython (Benchmarks Game algorithm).
# Plain accumulation loops (not sum(), which is compensated since 3.12) so
# the arithmetic matches the reference program.
import sys
from math import sqrt


def mul_av(u, v, n):
    for i in range(n):
        s = 0.0
        for j in range(n):
            s += 1.0 / ((i + j) * (i + j + 1) // 2 + i + 1) * u[j]
        v[i] = s


def mul_atv(u, v, n):
    for i in range(n):
        s = 0.0
        for j in range(n):
            s += 1.0 / ((i + j) * (i + j + 1) // 2 + j + 1) * u[j]
        v[i] = s


def mul_atav(u, v, w, n):
    mul_av(u, w, n)
    mul_atv(w, v, n)


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 100
    u = [1.0] * n
    v = [0.0] * n
    w = [0.0] * n
    for _ in range(10):
        mul_atav(u, v, w, n)
        mul_atav(v, u, w, n)
    vbv = 0.0
    vv = 0.0
    for i in range(n):
        vbv += u[i] * v[i]
        vv += v[i] * v[i]
    print("%0.9f" % sqrt(vbv / vv))


main()
