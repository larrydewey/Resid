# pidigits: single-threaded, pure CPython int (Benchmarks Game step-by-step
# unbounded spigot, as in the reference C/GMP program).
import sys


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 30
    acc, den, num = 0, 1, 1
    out = []
    line = []
    i = k = 0
    while i < n:
        k += 1
        k2 = k * 2 + 1
        acc = (acc + num * 2) * k2
        den *= k2
        num *= k
        if num > acc:
            continue
        d = (num * 3 + acc) // den
        if d != (num * 4 + acc) // den:
            continue
        line.append(chr(48 + d))
        i += 1
        if i % 10 == 0:
            out.append("%s\t:%d\n" % ("".join(line), i))
            line = []
        acc = (acc - den * d) * 10
        num *= 10
    if line:
        out.append("%s\t:%d\n" % ("".join(line).ljust(10), i))
    sys.stdout.write("".join(out))


main()
