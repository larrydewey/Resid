/* binary-trees, single-threaded reference implementation.
 * Nodes are individually allocated with malloc and freed, as described by
 * the Computer Language Benchmarks Game. */
#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    struct node *left, *right;
} node;

static node *bottom_up_tree(int depth) {
    node *t = malloc(sizeof(node));
    if (depth > 0) {
        t->left = bottom_up_tree(depth - 1);
        t->right = bottom_up_tree(depth - 1);
    } else {
        t->left = t->right = NULL;
    }
    return t;
}

static long item_check(const node *t) {
    if (t->left == NULL)
        return 1;
    return 1 + item_check(t->left) + item_check(t->right);
}

static void delete_tree(node *t) {
    if (t->left != NULL) {
        delete_tree(t->left);
        delete_tree(t->right);
    }
    free(t);
}

int main(int argc, char **argv) {
    int n = argc > 1 ? atoi(argv[1]) : 10;
    int min_depth = 4;
    int max_depth = n > min_depth + 2 ? n : min_depth + 2;
    int stretch_depth = max_depth + 1;

    node *stretch = bottom_up_tree(stretch_depth);
    printf("stretch tree of depth %d\t check: %ld\n", stretch_depth, item_check(stretch));
    delete_tree(stretch);

    node *long_lived = bottom_up_tree(max_depth);

    for (int d = min_depth; d <= max_depth; d += 2) {
        long iterations = 1L << (max_depth - d + min_depth);
        long check = 0;
        for (long i = 0; i < iterations; i++) {
            node *t = bottom_up_tree(d);
            check += item_check(t);
            delete_tree(t);
        }
        printf("%ld\t trees of depth %d\t check: %ld\n", iterations, d, check);
    }

    printf("long lived tree of depth %d\t check: %ld\n", max_depth, item_check(long_lived));
    delete_tree(long_lived);
    return 0;
}
