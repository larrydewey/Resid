# k-nucleotide: single-threaded, pure CPython (Benchmarks Game algorithm:
# extract sequence THREE, count every k-nucleotide with a dict keyed by the
# k-length substring). Reads stdin, ignores argv.
import sys


def read_sequence():
    data = sys.stdin.buffer.read()
    start = data.index(b">THREE")
    body_start = data.index(b"\n", start) + 1
    end = data.find(b">", body_start)
    if end < 0:
        end = len(data)
    return data[body_start:end].replace(b"\n", b"").upper().decode("latin-1")


def frequencies(seq, k):
    counts = {}
    get = counts.get
    for i in range(len(seq) - k + 1):
        key = seq[i:i + k]
        counts[key] = get(key, 0) + 1
    return counts


def sorted_frequencies(seq, k):
    counts = frequencies(seq, k)
    total = len(seq) - k + 1
    items = sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))
    return "".join("%s %.3f\n" % (key, c * 100.0 / total) for key, c in items) + "\n"


def main():
    seq = read_sequence()
    out = [sorted_frequencies(seq, 1), sorted_frequencies(seq, 2)]
    for frag in ("GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"):
        out.append("%d\t%s\n" % (frequencies(seq, len(frag)).get(frag, 0), frag))
    sys.stdout.write("".join(out))


main()
