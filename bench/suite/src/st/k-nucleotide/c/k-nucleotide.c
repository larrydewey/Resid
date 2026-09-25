/* k-nucleotide, single-threaded reference implementation.
 * Reads a FASTA file on stdin, extracts sequence THREE and counts k-mers
 * with a hash table (open addressing, keys packed 2 bits per nucleotide),
 * as described by the Computer Language Benchmarks Game. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    uint64_t *keys; /* key + 1; 0 marks an empty slot */
    uint32_t *vals;
    size_t cap, size;
} table;

static inline size_t hash64(uint64_t k) {
    k ^= k >> 33;
    k *= 0xff51afd7ed558ccdULL;
    k ^= k >> 33;
    return (size_t)k;
}

static void table_init(table *t, size_t cap) {
    t->cap = cap;
    t->size = 0;
    t->keys = calloc(cap, sizeof(uint64_t));
    t->vals = calloc(cap, sizeof(uint32_t));
}

static void table_free(table *t) {
    free(t->keys);
    free(t->vals);
}

static uint32_t *table_slot(table *t, uint64_t key);

static void table_grow(table *t) {
    table old = *t;
    table_init(t, old.cap * 2);
    for (size_t i = 0; i < old.cap; i++)
        if (old.keys[i])
            *table_slot(t, old.keys[i] - 1) = old.vals[i];
    table_free(&old);
}

/* Returns the counter for key, inserting a zero counter if absent. */
static uint32_t *table_slot(table *t, uint64_t key) {
    if ((t->size + 1) * 2 > t->cap)
        table_grow(t);
    size_t mask = t->cap - 1;
    size_t i = hash64(key) & mask;
    uint64_t stored = key + 1;
    while (t->keys[i] != 0) {
        if (t->keys[i] == stored)
            return &t->vals[i];
        i = (i + 1) & mask;
    }
    t->keys[i] = stored;
    t->size++;
    return &t->vals[i];
}

static uint32_t table_get(const table *t, uint64_t key) {
    size_t mask = t->cap - 1;
    size_t i = hash64(key) & mask;
    uint64_t stored = key + 1;
    while (t->keys[i] != 0) {
        if (t->keys[i] == stored)
            return t->vals[i];
        i = (i + 1) & mask;
    }
    return 0;
}

static int code_of(char c) {
    switch (c) {
    case 'A': return 0;
    case 'C': return 1;
    case 'G': return 2;
    default: return 3; /* 'T' */
    }
}

static const char letters[4] = {'A', 'C', 'G', 'T'};

static void count_kmers(const char *seq, size_t len, int k, table *t) {
    uint64_t mask = (k == 32) ? ~0ULL : ((1ULL << (2 * k)) - 1);
    uint64_t key = 0;
    for (int i = 0; i < k - 1; i++)
        key = (key << 2) | code_of(seq[i]);
    for (size_t i = k - 1; i < len; i++) {
        key = ((key << 2) | code_of(seq[i])) & mask;
        (*table_slot(t, key))++;
    }
}

static uint64_t encode(const char *s, int k) {
    uint64_t key = 0;
    for (int i = 0; i < k; i++)
        key = (key << 2) | code_of(s[i]);
    return key;
}

typedef struct {
    uint64_t key;
    uint32_t count;
} entry;

static int cmp_entry(const void *a, const void *b) {
    const entry *x = a, *y = b;
    if (x->count != y->count)
        return x->count > y->count ? -1 : 1;
    return x->key < y->key ? -1 : (x->key > y->key);
}

static void write_frequencies(const char *seq, size_t len, int k) {
    table t;
    table_init(&t, 64);
    count_kmers(seq, len, k, &t);
    entry *e = malloc(t.size * sizeof(entry));
    size_t n = 0;
    uint64_t total = 0;
    for (size_t i = 0; i < t.cap; i++) {
        if (t.keys[i]) {
            e[n].key = t.keys[i] - 1;
            e[n].count = t.vals[i];
            total += t.vals[i];
            n++;
        }
    }
    qsort(e, n, sizeof(entry), cmp_entry);
    for (size_t i = 0; i < n; i++) {
        char name[33];
        for (int j = 0; j < k; j++)
            name[j] = letters[(e[i].key >> (2 * (k - 1 - j))) & 3];
        name[k] = '\0';
        printf("%s %.3f\n", name, 100.0 * e[i].count / total);
    }
    printf("\n");
    free(e);
    table_free(&t);
}

static void write_count(const char *seq, size_t len, const char *frag) {
    int k = (int)strlen(frag);
    table t;
    table_init(&t, 64);
    count_kmers(seq, len, k, &t);
    printf("%u\t%s\n", table_get(&t, encode(frag, k)), frag);
    table_free(&t);
}

int main(void) {
    char line[4096];
    /* skip to sequence THREE */
    while (fgets(line, sizeof line, stdin))
        if (strncmp(line, ">THREE", 6) == 0)
            break;

    size_t cap = 1 << 16, len = 0;
    char *seq = malloc(cap);
    while (fgets(line, sizeof line, stdin)) {
        if (line[0] == '>')
            break;
        for (char *p = line; *p; p++) {
            char c = *p;
            if (c == '\n' || c == '\r')
                continue;
            if (c >= 'a' && c <= 'z')
                c -= 'a' - 'A';
            if (len == cap) {
                cap *= 2;
                seq = realloc(seq, cap);
            }
            seq[len++] = c;
        }
    }

    write_frequencies(seq, len, 1);
    write_frequencies(seq, len, 2);
    write_count(seq, len, "GGT");
    write_count(seq, len, "GGTA");
    write_count(seq, len, "GGTATT");
    write_count(seq, len, "GGTATTTTAATT");
    write_count(seq, len, "GGTATTTTAATTTATAGT");
    free(seq);
    return 0;
}
