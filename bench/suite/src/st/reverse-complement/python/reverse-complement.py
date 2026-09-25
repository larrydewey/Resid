# reverse-complement: single-threaded, pure CPython (Benchmarks Game
# algorithm: read FASTA from stdin, write each sequence's reverse complement
# in 60-column lines). Ignores argv.
import sys

TABLE = bytes.maketrans(
    b"ACGTUMRWSYKVHDBNacgtumrwsykvhdbn",
    b"TGCAAKYWSRMBDHVNTGCAAKYWSRMBDHVN",
)


def emit(write, header, lines):
    write(header)
    seq = b"".join(lines).translate(TABLE)[::-1]
    write(b"".join(seq[i:i + 60] + b"\n" for i in range(0, len(seq), 60)))


def main():
    write = sys.stdout.buffer.write
    header = None
    lines = []
    for line in sys.stdin.buffer:
        if line[:1] == b">":
            if header is not None:
                emit(write, header, lines)
            header = line if line.endswith(b"\n") else line + b"\n"
            lines = []
        else:
            lines.append(line.rstrip(b"\n"))
    if header is not None:
        emit(write, header, lines)
    sys.stdout.buffer.flush()


main()
