/* Secret mode set lazily (runtime/rt/malloc.resid): a compiled program's
 * main calls resid_secret_mode_lazy, and each function whose own code
 * handles a secret calls resid_secret_arm on entry (the compiler's
 * sec_arm_ir). Before the first arm no secret can exist, and freed memory
 * is left as it is (the control shows the mode really is lazy); from the
 * arm on, it is zeroed as under resid_secret_mode_set: small blocks, big
 * blocks, region pages and runs. A second arm changes nothing. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

int8_t resid_secret_mode_lazy(void);
void resid_secret_arm(void);
void* resid_gmalloc(int64_t n);
void resid_gfree(void* p);
int64_t resid_scope_push(void);
void resid_scope_pop(int64_t d);
void* resid_rt_scope_alloc(int64_t n);

static int64_t left(const unsigned char* p, int64_t from, int64_t n) {
    int64_t k = 0;
    for (int64_t i = from; i < n; i++) k += p[i] == 0xA5;
    return k;
}

static int64_t cycle(int64_t n) {
    unsigned char* p = resid_gmalloc(n);
    memset(p, 0xA5, n);
    resid_gfree(p);
    return left(p, 8, n);
}

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
    resid_secret_mode_lazy();
    /* Set, not armed: nothing is wiped yet. */
    if (cycle(100) == 0) { printf("lazy: small block cleared before the arm\n"); fails++; }
    int64_t one[1] = {4000};
    if (region_cycle(one, 1) == 0) { printf("lazy: region page cleared before the arm\n"); fails++; }
    resid_secret_arm();
    resid_secret_arm();
    int64_t s = cycle(100);
    if (s != 0) { printf("small block: %lld bytes survived free\n", (long long)s); fails++; }
    int64_t b = cycle(300000);
    if (b != 0) { printf("big block: %lld bytes survived free\n", (long long)b); fails++; }
    int64_t r1 = region_cycle(one, 1);
    if (r1 != 0) { printf("region page: %lld bytes survived pop\n", (long long)r1); fails++; }
    int64_t many[3] = {400000, 400000, 400000};
    int64_t r2 = region_cycle(many, 3);
    if (r2 != 0) { printf("region pages: %lld bytes survived pop\n", (long long)r2); fails++; }
    int64_t big[1] = {3000000};
    int64_t r3 = region_cycle(big, 1);
    if (r3 != 0) { printf("region run: %lld bytes survived pop\n", (long long)r3); fails++; }
    if (fails == 0) printf("secret_lazy ok\n");
    return fails != 0;
}
