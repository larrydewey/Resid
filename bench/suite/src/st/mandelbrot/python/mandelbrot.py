# mandelbrot: single-threaded, pure CPython (Benchmarks Game algorithm:
# 50 iterations, escape when |z|^2 > 4, binary PBM on stdout).
import sys


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 200
    out = bytearray(b"P4\n%d %d\n" % (n, n))
    for y in range(n):
        ci = 2.0 * y / n - 1.0
        bits = 0
        bit_num = 0
        for x in range(n):
            cr = 2.0 * x / n - 1.5
            zr = zi = tr = ti = 0.0
            i = 0
            while i < 50 and tr + ti <= 4.0:
                zi = 2.0 * zr * zi + ci
                zr = tr - ti + cr
                tr = zr * zr
                ti = zi * zi
                i += 1
            bits = (bits << 1) | (1 if tr + ti <= 4.0 else 0)
            bit_num += 1
            if bit_num == 8:
                out.append(bits)
                bits = 0
                bit_num = 0
        if bit_num:
            out.append((bits << (8 - bit_num)) & 0xFF)
    sys.stdout.buffer.write(out)


main()
