/* Secret mode (spec §48, runtime/rt/malloc.resid): once
 * resid_secret_mode_set(1) runs, freed heap memory is zeroed before it can
 * be reused -- small blocks on their size-class free list and big blocks in
 * the per-thread cache. The control shows that without the mode the bytes
 * stay, so the check can fail. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

int8_t resid_secret_mode_set(int on);
void* resid_gmalloc(int64_t n);
void resid_gfree(void* p);

/* How many of bytes [from, n) still hold the pattern. */
static int64_t left(const unsigned char* p, int64_t from, int64_t n) {
    int64_t k = 0;
    for (int64_t i = from; i < n; i++) k += p[i] == 0xA5;
    return k;
}

static int64_t cycle(int64_t n) {
    unsigned char* p = resid_gmalloc(n);
    memset(p, 0xA5, n);
    resid_gfree(p);
    /* The first word of a freed small block becomes its free-list link. */
    return left(p, 8, n);
}

int main(void) {
    int fails = 0;
    /* Control: without secret mode a freed block keeps its bytes. */
    if (cycle(100) == 0) { printf("control: small block was cleared without secret mode\n"); fails++; }
    resid_secret_mode_set(1);
    int64_t s = cycle(100);
    if (s != 0) { printf("small block: %lld bytes survived free\n", (long long)s); fails++; }
    int64_t b = cycle(300000);
    if (b != 0) { printf("big block: %lld bytes survived free\n", (long long)b); fails++; }
    if (fails == 0) printf("secret_zero ok\n");
    return fails != 0;
}
