/* Immediate Int and Float words (runtime IMM_* / FIMM_*): every value
 * round-trips through box/unbox, hashing and key equality agree with the
 * heap-box path, and no pointer is ever read as an immediate. */
#include "../../runtime/resid_rt.c"
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
        if (resid_unbox_i64(p) != v || !resid_key_eq(p, q) || resid_hash(p) != fnv1a_i64(v)) bad++;
        if (strcmp(scalar_type(p), "i64") != 0) bad++;
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
        if (memcmp(&d, &v, 8) != 0 || box_imm(p) || strcmp(scalar_type(p), "f64") != 0) bad++;
    }
    /* A NaN key never equals itself; equal Floats hash alike. */
    void* nan = resid_box_f64(NAN);
    if (resid_key_eq(nan, nan)) bad++;
    if (resid_hash(resid_box_f64(2.5)) != resid_hash(resid_box_f64(2.5))) bad++;
    /* Pointers the program can hold are never immediates. */
    char local = 0;
    char* heap = malloc(1);
    const char* lit = "x" + 1;
    if (box_imm(&local) || box_fimm(&local) || box_imm(heap) || box_fimm(heap) || box_imm(lit) || box_fimm(lit)) bad++;
    free(heap);
    printf("immediates: %s\n", bad ? "FAIL" : "ok");
    return bad != 0;
}
