/*
 * Minimal stand-in for the five Apache Portable Runtime (APR) pool calls
 * used by binarytrees.f90 (apr_initialize, apr_pool_create_unmanaged_ex,
 * apr_palloc, apr_pool_clear, apr_pool_destroy).  libapr is not installed
 * on the benchmark host, so this provides the same semantics: a region
 * allocator made of large blocks, where clear() rewinds to the first block
 * without returning memory and destroy() frees everything.
 */
#include <stdlib.h>
#include <stddef.h>

#define BLOCK_SIZE (1u << 20)

typedef struct block {
    struct block *next;
    size_t used, cap;
    /* data follows */
} block;

typedef struct pool {
    block *first, *cur;
} pool;

static block *new_block(size_t need)
{
    size_t cap = need > BLOCK_SIZE ? need : BLOCK_SIZE;
    block *b = malloc(sizeof(block) + cap);
    if (!b) abort();
    b->next = NULL;
    b->used = 0;
    b->cap = cap;
    return b;
}

int apr_initialize(void) { return 0; }

int apr_pool_create_unmanaged_ex(pool **newpool, void *abort_fn, void *allocator)
{
    (void)abort_fn; (void)allocator;
    pool *p = malloc(sizeof(pool));
    if (!p) abort();
    p->first = p->cur = new_block(0);
    *newpool = p;
    return 0;
}

void *apr_palloc(pool *p, size_t size)
{
    size = (size + 7) & ~(size_t)7;
    block *b = p->cur;
    while (b->used + size > b->cap) {
        if (!b->next) b->next = new_block(size);
        b = b->next;
        b->used = 0;
        p->cur = b;
    }
    void *r = (char *)(b + 1) + b->used;
    b->used += size;
    return r;
}

void apr_pool_clear(pool *p)
{
    p->cur = p->first;
    p->first->used = 0;
}

void apr_pool_destroy(pool *p)
{
    block *b = p->first;
    while (b) {
        block *n = b->next;
        free(b);
        b = n;
    }
    free(p);
}
