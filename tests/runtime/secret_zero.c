/* Secret mode (spec §48, runtime/rt/malloc.resid): once
 * resid_secret_mode_set(1) runs, freed heap memory is zeroed before it can
 * be reused -- small blocks on their size-class free list, big blocks in
 * the per-thread cache, and region pages when their region is popped
 * (runtime/rt/region.resid: a page kept for reuse is zeroed up to where
 * its region allocated, one handed back is zero-filled by the kernel). The
 * controls show that without the mode the bytes stay, so the checks can
 * fail. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

int8_t resid_secret_mode_set(int on);
void* resid_gmalloc(int64_t n);
void resid_gfree(void* p);
int64_t resid_scope_push(void);
void resid_scope_pop(int64_t d);
void* resid_rt_scope_alloc(int64_t n);

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

/* Region blocks of the given sizes, filled, then the region popped: how
 * many pattern bytes survive. A block's first 16 bytes may be a page
 * header, so they are not counted. */
static int64_t region_cycle(const int64_t* sizes, int k) {
    unsigned char* ps[8];
    int64_t d = resid_scope_push();
    for (int i = 0; i < k; i++) {
        ps[i] = resid_rt_scope_alloc(sizes[i]);
        memset(ps[i], 0xA5, sizes[i]);
    }
    resid_scope_pop(d);
    int64_t n = 0;
    for (int i = 0; i < k; i++) n += left(ps[i], 16, sizes[i]);
    return n;
}

int main(void) {
    int fails = 0;
    /* Control: without secret mode a freed block keeps its bytes. */
    if (cycle(100) == 0) { printf("control: small block was cleared without secret mode\n"); fails++; }
    int64_t one[1] = {4000};
    if (region_cycle(one, 1) == 0) { printf("control: region page was cleared without secret mode\n"); fails++; }
    resid_secret_mode_set(1);
    int64_t s = cycle(100);
    if (s != 0) { printf("small block: %lld bytes survived free\n", (long long)s); fails++; }
    int64_t b = cycle(300000);
    if (b != 0) { printf("big block: %lld bytes survived free\n", (long long)b); fails++; }
    /* One small block (the page holding the region's bump), several that
     * fill more than one page (pages behind the bump), and one larger than
     * a page (a run of pages, not cached). */
    int64_t r1 = region_cycle(one, 1);
    if (r1 != 0) { printf("region page: %lld bytes survived pop\n", (long long)r1); fails++; }
    int64_t many[3] = {400000, 400000, 400000};
    int64_t r2 = region_cycle(many, 3);
    if (r2 != 0) { printf("region pages: %lld bytes survived pop\n", (long long)r2); fails++; }
    int64_t big[1] = {3000000};
    int64_t r3 = region_cycle(big, 1);
    if (r3 != 0) { printf("region run: %lld bytes survived pop\n", (long long)r3); fails++; }
    if (fails == 0) printf("secret_zero ok\n");
    return fails != 0;
}
