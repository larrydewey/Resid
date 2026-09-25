# binary-trees: single-threaded, pure CPython (Benchmarks Game algorithm:
# allocate full trees of nodes, walk them to count nodes).
import sys


class Node:
    __slots__ = ("left", "right")

    def __init__(self, left, right):
        self.left = left
        self.right = right


def bottom_up(depth):
    if depth > 0:
        return Node(bottom_up(depth - 1), bottom_up(depth - 1))
    return Node(None, None)


def check(t):
    if t.left is None:
        return 1
    return 1 + check(t.left) + check(t.right)


def main():
    max_depth = max(6, int(sys.argv[1]) if len(sys.argv) > 1 else 10)
    stretch = max_depth + 1
    out = ["stretch tree of depth %d\t check: %d" % (stretch, check(bottom_up(stretch)))]
    long_lived = bottom_up(max_depth)
    for d in range(4, max_depth + 1, 2):
        iterations = 1 << (max_depth - d + 4)
        c = 0
        for _ in range(iterations):
            c += check(bottom_up(d))
        out.append("%d\t trees of depth %d\t check: %d" % (iterations, d, c))
    out.append("long lived tree of depth %d\t check: %d" % (max_depth, check(long_lived)))
    print("\n".join(out))


main()
