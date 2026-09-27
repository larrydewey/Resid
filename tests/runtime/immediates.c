/* Immediate Int and Float words (runtime IMM_* / FIMM_*): every value
 * round-trips through box/unbox, hashing and key equality agree with the
 * heap-box path (checked through sets, runtime/rt/map.resid), and no
 * pointer is ever read as an immediate. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* The box layout and the scalar boxes (runtime/rt/alloc.resid). */
typedef struct { int32_t tag; int32_t count; const char* type; } ResidVal;
#define IMM_LO ((uint64_t)1 << 48)
#define FIMM_LO ((uint64_t)1 << 56)
#define IMM_MIN (-((int64_t)1 << 54))
#define IMM_MAX (((int64_t)1 << 54) - 1)
static int box_imm(const void* p) { return (uint64_t)(uintptr_t)p - IMM_LO < ((uint64_t)1 << 55); }
static int box_fimm(const void* p) { return (uint64_t)(uintptr_t)p >= FIMM_LO; }
void* resid_box_i64(int64_t v);
int64_t resid_unbox_i64(void* p);
void* resid_box_f64(double v);
double resid_unbox_f64(void* p);
__int128 resid_unbox_i128(void* p);

void* resid_set_new(void);
void* resid_set_insert(void* set, void* elem);
int8_t resid_set_contains(void* set, void* elem);
void* resid_map_put(void* map, int8_t owned, int8_t kk, int64_t kb, int8_t vk, int64_t vb);

static const char* stype(void* p) {
    if (box_imm(p)) return "i64";
    if (box_fimm(p)) return "f64";
    return ((ResidVal*)p)->type;
}
#include <float.h>
#include <math.h>

static uint64_t rs = 88172645463325252ULL;
static uint64_t xr(void) { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return rs; }

int main(void) {
    long bad = 0;
    int64_t edge[] = {0, 1, -1, IMM_MAX, IMM_MIN, IMM_MAX + 1, IMM_MIN - 1, INT64_MAX, INT64_MIN, 4096, -257};
    for (int i = 0; i < 11; i++) {
        void* p = resid_box_i64(edge[i]);
        if (resid_unbox_i64(p) != edge[i]) { bad++; printf("int %lld\n", (long long)edge[i]); }
        if (box_imm(p) && resid_unbox_i128(p) != (__int128)edge[i]) bad++;
        if (box_imm(p) != (edge[i] >= IMM_MIN && edge[i] <= IMM_MAX)) bad++;
    }
    for (long i = 0; i < 2000000; i++) {
        int64_t v = (int64_t)xr();
        if (i & 1) v >>= (xr() % 64);
        void* p = resid_box_i64(v);
        void* q = resid_box_i64(v);
        if (resid_unbox_i64(p) != v || strcmp(stype(p), "i64") != 0) bad++;
        if ((i & 1023) == 0) {
            /* Equal boxes match; a raw Int key and its box hash alike. */
            if (!resid_set_contains(resid_set_insert(resid_set_new(), p), q)) bad++;
            if (!resid_set_contains(resid_map_put(resid_set_new(), 0, 1, v, 0, 1), q)) bad++;
        }
    }
    double fe[] = {0.0, -0.0, 1.0, -1.0, 0.5, 2.0, 1e300, -1e300, 1e-300, 5e-324, INFINITY, -INFINITY, NAN, DBL_MAX, DBL_MIN, 3.141592653589793};
    for (int i = 0; i < 16; i++) {
        void* p = resid_box_f64(fe[i]);
        double d = resid_unbox_f64(p);
        if (memcmp(&d, &fe[i], 8) != 0) { bad++; printf("float %g\n", fe[i]); }
        if (box_imm(p)) bad++;
    }
    for (long i = 0; i < 2000000; i++) {
        uint64_t b = xr();
        double v;
        memcpy(&v, &b, 8);
        void* p = resid_box_f64(v);
        double d = resid_unbox_f64(p);
        if (memcmp(&d, &v, 8) != 0 || box_imm(p) || strcmp(stype(p), "f64") != 0) bad++;
    }
    /* A NaN key never equals itself; equal Floats hash alike. */
    void* nan = resid_box_f64(NAN);
    if (resid_set_contains(resid_set_insert(resid_set_new(), nan), nan)) bad++;
    if (!resid_set_contains(resid_set_insert(resid_set_new(), resid_box_f64(2.5)), resid_box_f64(2.5))) bad++;
    /* Pointers the program can hold are never immediates. */
    char local = 0;
    char* heap = malloc(1);
    const char* lit = "x" + 1;
    if (box_imm(&local) || box_fimm(&local) || box_imm(heap) || box_fimm(heap) || box_imm(lit) || box_fimm(lit)) bad++;
    free(heap);
    printf("immediates: %s\n", bad ? "FAIL" : "ok");
    return bad != 0;
}
