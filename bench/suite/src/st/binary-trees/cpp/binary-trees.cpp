// binary-trees, single-threaded C++ implementation.
// Nodes are individually allocated with new/delete, as described by the
// Computer Language Benchmarks Game.
#include <cstdio>
#include <cstdlib>

namespace {

struct Node {
    Node *left = nullptr;
    Node *right = nullptr;

    Node() = default;
    Node(Node *l, Node *r) : left(l), right(r) {}
    ~Node() {
        delete left;
        delete right;
    }

    long check() const { return left ? 1 + left->check() + right->check() : 1; }
};

Node *bottom_up_tree(int depth) {
    if (depth > 0)
        return new Node(bottom_up_tree(depth - 1), bottom_up_tree(depth - 1));
    return new Node();
}

} // namespace

int main(int argc, char **argv) {
    const int n = argc > 1 ? std::atoi(argv[1]) : 10;
    const int min_depth = 4;
    const int max_depth = n > min_depth + 2 ? n : min_depth + 2;
    const int stretch_depth = max_depth + 1;

    {
        Node *stretch = bottom_up_tree(stretch_depth);
        std::printf("stretch tree of depth %d\t check: %ld\n", stretch_depth, stretch->check());
        delete stretch;
    }

    Node *long_lived = bottom_up_tree(max_depth);

    for (int d = min_depth; d <= max_depth; d += 2) {
        const long iterations = 1L << (max_depth - d + min_depth);
        long check = 0;
        for (long i = 0; i < iterations; ++i) {
            Node *t = bottom_up_tree(d);
            check += t->check();
            delete t;
        }
        std::printf("%ld\t trees of depth %d\t check: %ld\n", iterations, d, check);
    }

    std::printf("long lived tree of depth %d\t check: %ld\n", max_depth, long_lived->check());
    delete long_lived;
}
