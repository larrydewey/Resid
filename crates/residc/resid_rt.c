/*
 * resid_rt.c — minimal bootstrap runtime linked into every native Resid
 * binary produced by `residc build|run`.
 *
 * This is bootstrap glue: it lets Resid programs observe the outside world.
 * Providers, standard-library types, and a full runtime will replace these as
 * the compiler self-hosts.
 *
 * Note: `print`/`println` may eventually move behind a capability, but for the
 * bootstrap stage the kernel allows them unconditionally.
 */
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

bool print(const char* s) {
    if (fputs(s, stdout) == EOF) return false;
    if (fflush(stdout) == EOF) return false;
    return true;
}

bool println(const char* s) {
    if (fputs(s, stdout) == EOF) return false;
    if (putchar('\n') == EOF) return false;
    if (fflush(stdout) == EOF) return false;
    return true;
}

/* Abort with a message: `todo(...)`/`unimplemented(...)` trap here. */
_Noreturn void resid_abort(const char* msg) {
    if (msg && msg[0]) {
        fprintf(stderr, "resid: abort: %s\n", msg);
    } else {
        fprintf(stderr, "resid: abort\n");
    }
    abort();
}

static char* resid_box_str(const char* s) {
    size_t n = strlen(s);
    char* p = (char*)malloc(n + 1);
    memcpy(p, s, n + 1);
    return p;
}

/*
 * Boxed value objects.
 *
 * Every composite Resid value (list, product struct, sum variant) is a
 * `ResidVal*` with a tag, a slot count, an array of slots, and a type name.
 * A slot for a scalar operand is a heap box (created by resid_box_*); a slot
 * for a string / nested composite is the raw pointer.
 */
typedef struct {
    int64_t tag;
    int64_t count;
    void** slots;
    const char* type;
} ResidVal;

void* resid_box_new(int64_t tag, int64_t count, void** src, const char* type) {
    ResidVal* v = (ResidVal*)malloc(sizeof(ResidVal));
    v->tag = tag;
    v->count = count;
    v->type = type;
    v->slots = NULL;
    if (count > 0) {
        v->slots = (void**)malloc((size_t)count * sizeof(void*));
        for (int64_t i = 0; i < count; i++) v->slots[i] = src[i];
    }
    return v;
}

int64_t resid_box_tag(void* b) { return ((ResidVal*)b)->tag; }

int64_t resid_box_count(void* b) { return ((ResidVal*)b)->count; }

void** resid_box_slots(void* b) { return ((ResidVal*)b)->slots; }

/* The i-th slot of a boxed object. */
void* resid_box_slot(void* b, int64_t i) { return ((ResidVal*)b)->slots[i]; }

/* Length of a list = its slot count. */
int64_t resid_list_len(void* b) { return ((ResidVal*)b)->count; }

/* Scalar boxes: ResidVal with tag=-1 and one slot holding the value. */
void* resid_box_i64(int64_t v) {
    ResidVal* r = (ResidVal*)malloc(sizeof(ResidVal));
    r->tag = -1;
    r->count = 1;
    r->type = "i64";
    int64_t* slot = (int64_t*)malloc(sizeof(int64_t));
    *slot = v;
    r->slots = (void**)malloc(1 * sizeof(void*));
    r->slots[0] = slot;
    return r;
}
int64_t resid_unbox_i64(void* p) {
    ResidVal* r = (ResidVal*)p;
    return *(int64_t*)r->slots[0];
}

void* resid_box_f64(double v) {
    ResidVal* r = (ResidVal*)malloc(sizeof(ResidVal));
    r->tag = -1;
    r->count = 1;
    r->type = "f64";
    double* slot = (double*)malloc(sizeof(double));
    *slot = v;
    r->slots = (void**)malloc(1 * sizeof(void*));
    r->slots[0] = slot;
    return r;
}
double resid_unbox_f64(void* p) {
    ResidVal* r = (ResidVal*)p;
    return *(double*)r->slots[0];
}

void* resid_box_bool(int8_t v) {
    ResidVal* r = (ResidVal*)malloc(sizeof(ResidVal));
    r->tag = -1;
    r->count = 1;
    r->type = "bool";
    int8_t* slot = (int8_t*)malloc(sizeof(int8_t));
    *slot = v;
    r->slots = (void**)malloc(1 * sizeof(void*));
    r->slots[0] = slot;
    return r;
}
int8_t resid_unbox_bool(void* p) {
    ResidVal* r = (ResidVal*)p;
    return *(int8_t*)r->slots[0];
}

/*
 * Debug/diagnostics helpers so a program can talk about its own values before
 * the standard library's `Show` exists.
 */
char* IntToString(int64_t v) {
    char buf[32];
    snprintf(buf, sizeof(buf), "%lld", (long long)v);
    return resid_box_str(buf);
}

char* UIntToString(uint64_t v) {
    char buf[32];
    snprintf(buf, sizeof(buf), "%llu", (unsigned long long)v);
    return resid_box_str(buf);
}

char* FloatToString(double v) {
    char buf[64];
    snprintf(buf, sizeof(buf), "%.17g", v);
    return resid_box_str(buf);
}

char* BoolToString(int8_t v) {
    char buf[16];
    snprintf(buf, sizeof(buf), "%s", v ? "true" : "false");
    return resid_box_str(buf);
}

/*
 * Format a boxed composite value (Option/Some/None/List/Struct) as a
 * human-readable string: `[Some 42]`, `42`, `[1, 2, 3]`, etc.
 *
 * Tag conventions (must match resid-codegen build_constructor):
 *   0 = list or anonymous struct,
 *   1 = Some, 2 = None, etc.
 *
 * This is a bootstrap helper — the real stdlib will use a Show typeclass.
 */
char* ToString(void* boxed) {
    ResidVal* val = (ResidVal*)boxed;
    if (!val || !val->slots) {
        return resid_box_str("null");
    }

    /* Tag 1 = Some, tag 2 = None (built-in Option). */
    if (val->tag == 1 && val->count == 1 && val->slots[0]) {
        /* Some(x) — unbox the inner value and format it. */
        int64_t inner_tag = resid_box_tag(val->slots[0]);
        if (inner_tag == -1) {
            ResidVal* sv = (ResidVal*)val->slots[0];
            char inner_buf[64];
            if (sv->type[0] == 'f') {
                double dv = resid_unbox_f64(val->slots[0]);
                snprintf(inner_buf, sizeof(inner_buf), "%.17g", dv);
            } else if (sv->type[0] == 'b') {
                int8_t bv = resid_unbox_bool(val->slots[0]);
                snprintf(inner_buf, sizeof(inner_buf), "%s", bv ? "true" : "false");
            } else {
                int64_t iv = resid_unbox_i64(val->slots[0]);
                snprintf(inner_buf, sizeof(inner_buf), "%lld", (long long)iv);
            }
            char* out = (char*)malloc(strlen(inner_buf) + 10);
            sprintf(out, "Some(%s)", inner_buf);
            return out;
        }
        /* Nested composite — just print the tag. */
        char* out = (char*)malloc(strlen(val->type) + 20);
        sprintf(out, "Some<%s>", val->type);
        return out;
    }
    if (val->tag == 2) {
        /* None */
        return resid_box_str("None");
    }

    /* List or struct: iterate slots. */
    size_t len = strlen(val->type);
    size_t buf_size = len + 64 + (val->count * 48);
    char* buf = (char*)malloc(buf_size);
    snprintf(buf, buf_size, "%s(", val->type);
    for (int64_t i = 0; i < val->count; i++) {
        if (i > 0) strcat(buf, ", ");
        void* slot = val->slots[i];
        if (!slot) {
            strcat(buf, "null");
            continue;
        }
        int64_t tag = resid_box_tag(slot);
        if (tag == -1) {
            ResidVal* sv = (ResidVal*)slot;
            if (sv->type[0] == 'f') {
                double dv = resid_unbox_f64(slot);
                char s[64];
                snprintf(s, sizeof(s), "%.17g", dv);
                strcat(buf, s);
            } else if (sv->type[0] == 'b') {
                int8_t bv = resid_unbox_bool(slot);
                strcat(buf, bv ? "true" : "false");
            } else {
                int64_t iv = resid_unbox_i64(slot);
                char s[32];
                snprintf(s, sizeof(s), "%lld", (long long)iv);
                strcat(buf, s);
            }
        } else {
            strcat(buf, "…");
        }
    }
    strcat(buf, ")");
    return buf;
}

/*
 * Conversion helpers (spec §6.7): cast to target width, then back to the
 * default scalar width (i64 for integers, double for floats) for the return.
 * The LLVM type of the return matches the target width so the caller's
 * widening logic can handle any subsequent widening correctly.
 *
 * Wide types (128+ bit) are software-emulated; for now they are not
 * directly callable — the codegen raises an error.
 */

/* ── Signed integer helpers ────────────────────────────────────── */
int8_t i8(int64_t v) { return (int8_t)v; }
int16_t i16(int64_t v) { return (int16_t)v; }
int32_t i32(int64_t v) { return (int32_t)v; }
int64_t i64(int64_t v) { return v; }
/* i128 — __int128 is a GCC/Clang extension. i256, i512 not supported. */
#ifdef __SIZEOF_INT128__
__int128 i128(int64_t v) { return (__int128)v; }
#else
__int128 i128(int64_t v) { return v; }
#endif

/* ── Unsigned integer helpers ──────────────────────────────────── */
uint8_t u8(uint64_t v) { return (uint8_t)v; }
uint16_t u16(uint64_t v) { return (uint16_t)v; }
uint32_t u32(uint64_t v) { return (uint32_t)v; }
uint64_t u64(uint64_t v) { return v; }
/* u128, u256, u512 — not supported in C natively (software-emulated). */

/* ── Float helpers (receive double, return target-width float) ─── */
_Float16 f16(double v) { return (_Float16)(float)v; }
float f32(double v) { return (float)v; }
double f64(double v) { return v; }

/* ── Pointer-sized helpers ─────────────────────────────────────── */
int64_t isize(int64_t v) { return v; }
uint64_t usize(uint64_t v) { return v; }