# The Computer Language Benchmarks Game
# https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
#
# contributed by Joerg Baumann

from contextlib import closing
from itertools import islice
from os import cpu_count
from sys import argv, stdout

def pixels(y, n, abs):
    range7 = bytearray(range(7))
    pixel_bits = bytearray(128 >> pos for pos in range(8))
    # Adapted: c computed per pixel as 2x/n-1.5, 2y/n-1 (no accumulated
    # c += c1 drift) and escape test |z| > 2, so output matches the
    # reference C program byte-for-byte.
    ci = 2.0 * y / n - 1.0
    x = 0
    while True:
        pixel = 0
        for pos, pixel_bit in enumerate(pixel_bits):
            c = complex(2.0 * (x + pos) / n - 1.5, ci)
            z = c
            for _ in range7:
                for _ in range7:
                    z = z * z + c
                if abs(z) > 2.: break
            else:
                pixel += pixel_bit
        yield pixel
        x += 8

def compute_row(p):
    y, n = p

    result = bytearray(islice(pixels(y, n, abs), (n + 7) // 8))
    if n % 8:  # adapted: original masked the last byte to 0 when n % 8 == 0
        result[-1] &= 0xff << (8 - n % 8)
    return y, result

def ordered_rows(rows, n):
    order = [None] * n
    i = 0
    j = n
    while i < len(order):
        if j > 0:
            row = next(rows)
            order[row[0]] = row
            j -= 1

        if order[i]:
            yield order[i]
            order[i] = None
            i += 1

def compute_rows(n, f):
    row_jobs = ((y, n) for y in range(n))

    if cpu_count() < 2:
        yield from map(f, row_jobs)
    else:
        from multiprocessing import Pool
        with Pool() as pool:
            unordered_rows = pool.imap_unordered(f, row_jobs)
            yield from ordered_rows(unordered_rows, n)

def mandelbrot(n):
    write = stdout.buffer.write

    with closing(compute_rows(n, compute_row)) as rows:
        write("P4\n{0} {0}\n".format(n).encode())
        for row in rows:
            write(row[1])

if __name__ == '__main__':
    # Python 3.14 defaults to 'forkserver' on Linux; BG ran 3.13 (fork).
    import multiprocessing; multiprocessing.set_start_method('fork')
    mandelbrot(int(argv[1]))
    