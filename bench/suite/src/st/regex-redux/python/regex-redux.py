# regex-redux: single-threaded, pure CPython re (Benchmarks Game algorithm).
# Reads stdin, ignores argv.
import re
import sys


def main():
    seq = sys.stdin.buffer.read().decode("latin-1")
    initial_length = len(seq)
    seq = re.sub(">.*\n|\n", "", seq)
    clean_length = len(seq)

    variants = (
        "agggtaaa|tttaccct",
        "[cgt]gggtaaa|tttaccc[acg]",
        "a[act]ggtaaa|tttacc[agt]t",
        "ag[act]gtaaa|tttac[agt]ct",
        "agg[act]taaa|ttta[agt]cct",
        "aggg[acg]aaa|ttt[cgt]ccct",
        "agggt[cgt]aa|tt[acg]accct",
        "agggta[cgt]a|t[acg]taccct",
        "agggtaa[cgt]|[acg]ttaccct",
    )
    out = []
    for v in variants:
        out.append("%s %d\n" % (v, len(re.findall(v, seq))))

    subst = (
        ("tHa[Nt]", "<4>"),
        ("aND|caN|Ha[DS]|WaS", "<3>"),
        ("a[NSt]|BY", "<2>"),
        ("<[^>]*>", "|"),
        ("\\|[^|][^|]*\\|", "-"),
    )
    for pattern, rep in subst:
        seq = re.sub(pattern, rep, seq)

    out.append("\n%d\n%d\n%d\n" % (initial_length, clean_length, len(seq)))
    sys.stdout.write("".join(out))


main()
