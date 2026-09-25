# fasta: single-threaded, pure CPython (Benchmarks Game algorithm:
# LCG IM=139968 IA=3877 IC=29573 seed 42, cumulative-probability lookup,
# 60-column lines).
import sys

IM = 139968
IA = 3877
IC = 29573
WIDTH = 60

ALU = (
    "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG"
    "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA"
    "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT"
    "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA"
    "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG"
    "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC"
    "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"
)

IUB = [
    ("a", 0.27), ("c", 0.12), ("g", 0.12), ("t", 0.27),
    ("B", 0.02), ("D", 0.02), ("H", 0.02), ("K", 0.02),
    ("M", 0.02), ("N", 0.02), ("R", 0.02), ("S", 0.02),
    ("V", 0.02), ("W", 0.02), ("Y", 0.02),
]

HOMO_SAPIENS = [
    ("a", 0.3029549426680), ("c", 0.1979883004921),
    ("g", 0.1975473066391), ("t", 0.3015094502008),
]

last = 42


def repeat_fasta(write, header, src, n):
    write(header)
    s = (src * (WIDTH // len(src) + 2)).encode()
    length = len(src)
    k = 0
    out = bytearray()
    while n > 0:
        m = WIDTH if n > WIDTH else n
        out += s[k:k + m]
        out += b"\n"
        k = (k + m) % length
        n -= m
        if len(out) > 1 << 16:
            write(bytes(out))
            out.clear()
    write(bytes(out))


def random_fasta(write, header, table, n):
    global last
    write(header)
    chars = [ord(c) for c, _ in table]
    probs = []
    acc = 0.0
    for _, p in table:
        acc += p
        probs.append(acc)
    probs[-1] = 1.0
    seed = last
    out = bytearray()
    while n > 0:
        line = WIDTH if n > WIDTH else n
        for _ in range(line):
            seed = (seed * IA + IC) % IM
            r = seed / IM
            j = 0
            while r >= probs[j]:
                j += 1
            out.append(chars[j])
        out.append(10)
        n -= line
        if len(out) > 1 << 16:
            write(bytes(out))
            out.clear()
    write(bytes(out))
    last = seed


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 1000
    write = sys.stdout.buffer.write
    repeat_fasta(write, b">ONE Homo sapiens alu\n", ALU, 2 * n)
    random_fasta(write, b">TWO IUB ambiguity codes\n", IUB, 3 * n)
    random_fasta(write, b">THREE Homo sapiens frequency\n", HOMO_SAPIENS, 5 * n)
    sys.stdout.buffer.flush()


main()
