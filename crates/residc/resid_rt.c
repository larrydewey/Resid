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
#include <time.h>
#include <execinfo.h>
#include <string.h>
#include <limits.h>
#include <pthread.h>
#include <sys/random.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>

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
 * Runtime string concatenation: f-string interpolation and `Str + Str`
 * (spec §32) build string values out of parts that aren't constant-foldable.
 */
char* resid_str_concat(const char* a, const char* b) {
    size_t la = strlen(a);
    size_t lb = strlen(b);
    char* p = (char*)malloc(la + lb + 1);
    memcpy(p, a, la);
    memcpy(p + la, b, lb + 1);
    return p;
}

/* Str == Str / Str != Str. Returns 1 when equal (C ABI Bool = i8). */
int8_t resid_str_eq(const char* a, const char* b) {
    return strcmp(a, b) == 0;
}

/* UTF-8 decoding helpers for the string introspection functions. */
static int utf8_seq_len(const unsigned char c) {
    if (c < 0x80) return 1;
    if ((c & 0xE0) == 0xC0) return 2;
    if ((c & 0xF0) == 0xE0) return 3;
    if ((c & 0xF8) == 0xF0) return 4;
    return 1; /* invalid continuation byte — treat as 1 */
}

static int64_t utf8_decode(const unsigned char* p, int len) {
    switch (len) {
        case 1: return p[0];
        case 2: return ((p[0] & 0x1F) << 6) | (p[1] & 0x3F);
        case 3: return ((p[0] & 0x0F) << 12) | ((p[1] & 0x3F) << 6) | (p[2] & 0x3F);
        default: return ((p[0] & 0x07) << 18) | ((p[1] & 0x3F) << 12)
                        | ((p[2] & 0x3F) << 6) | (p[3] & 0x3F);
    }
}

/* Number of Unicode codepoints in a UTF-8 string. */
int64_t str_len(const char* s) {
    int64_t n = 0;
    const unsigned char* p = (const unsigned char*)s;
    while (*p) {
        n++;
        p += utf8_seq_len(*p);
    }
    return n;
}

/* Codepoint at index `i` (0-based), or -1 when out of bounds. */
int64_t str_char_at(const char* s, int64_t i) {
    if (i < 0) return -1;
    int64_t n = 0;
    const unsigned char* p = (const unsigned char*)s;
    while (*p) {
        if (n == i) return utf8_decode(p, utf8_seq_len(*p));
        p += utf8_seq_len(*p);
        n++;
    }
    return -1;
}

/* Build a 1-codepoint string from a Unicode codepoint. */
char* str_from_code(int64_t cp) {
    char buf[5];
    int n = 0;
    if (cp < 0x80) {
        buf[n++] = (char)cp;
    } else if (cp < 0x800) {
        buf[n++] = (char)(0xC0 | (cp >> 6));
        buf[n++] = (char)(0x80 | (cp & 0x3F));
    } else if (cp < 0x10000) {
        buf[n++] = (char)(0xE0 | (cp >> 12));
        buf[n++] = (char)(0x80 | ((cp >> 6) & 0x3F));
        buf[n++] = (char)(0x80 | (cp & 0x3F));
    } else {
        buf[n++] = (char)(0xF0 | (cp >> 18));
        buf[n++] = (char)(0x80 | ((cp >> 12) & 0x3F));
        buf[n++] = (char)(0x80 | ((cp >> 6) & 0x3F));
        buf[n++] = (char)(0x80 | (cp & 0x3F));
    }
    buf[n] = '\0';
    char* p = (char*)malloc(n + 1);
    memcpy(p, buf, n + 1);
    return p;
}

/* Half-open substring `s[start..end]` by codepoint index (clamped). */
char* str_slice(const char* s, int64_t start, int64_t end) {
    if (start < 0) start = 0;
    if (end < start) end = start;
    const unsigned char* p = (const unsigned char*)s;
    const unsigned char* begin = p;
    int64_t i = 0;
    while (*p && i < start) {
        p += utf8_seq_len(*p);
        i++;
    }
    begin = p;
    while (*p && i < end) {
        p += utf8_seq_len(*p);
        i++;
    }
    size_t n = (size_t)(p - begin);
    char* out = (char*)malloc(n + 1);
    memcpy(out, begin, n);
    out[n] = '\0';
    return out;
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

/* Structured spawn (spec §19): run `worker(captures)` on a fresh thread and
 * join before returning the worker's result (a boxed `Ok(T)` for now; child
 * failure -> `Err(RegionError)` is the future abort-catchable path). */
void* resid_spawn(void* (*worker)(void*), void* captures) {
    pthread_t t;
    void* ret = NULL;
    if (pthread_create(&t, NULL, worker, captures) != 0) return NULL;
    pthread_join(t, &ret);
    return ret;
}

void* resid_malloc(size_t size) { return malloc(size); }

/* Length of a list = its slot count. */
int64_t resid_list_len(void* b) { return ((ResidVal*)b)->count; }

/* Convert a boxed ResidVal list into the length-first flat list layout used
 * by the stage-2 driver ({ i64 count, [count x ptr] elements }): slot array
 * at offset 8, count at offset 0. Used at the C-runtime boundary so lists
 * returned by resid_map_keys/values and resid_set_to_list match what the
 * driver's list ops (and e.lconcat) expect. */
void* resid_rt_list_to_flat(void* b) {
    ResidVal* v = (ResidVal*)b;
    int64_t n = v->count;
    void* out = malloc((size_t)n * 8 + 8);
    ((int64_t*)out)[0] = n;
    for (int64_t i = 0; i < n; i++) ((void**)out)[i + 1] = v->slots[i];
    return out;
}

/* Concatenate two lists: a new boxed list with a's slots then b's. */
void* resid_list_concat(void* a, void* b) {
    ResidVal* x = (ResidVal*)a;
    ResidVal* y = (ResidVal*)b;
    int64_t total = x->count + y->count;
    ResidVal* out = (ResidVal*)malloc(sizeof(ResidVal));
    out->tag = x->tag;
    out->count = total;
    out->type = x->type;
    out->slots = NULL;
    if (total > 0) {
        out->slots = (void**)malloc((size_t)total * sizeof(void*));
        for (int64_t i = 0; i < x->count; i++) out->slots[i] = x->slots[i];
        for (int64_t i = 0; i < y->count; i++) out->slots[x->count + i] = y->slots[i];
    }
    return out;
}

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

void* resid_box_i128(__int128 v) {
    ResidVal* r = (ResidVal*)malloc(sizeof(ResidVal));
    r->tag = -1;
    r->count = 1;
    r->type = "i128";
    __int128* slot = (__int128*)malloc(sizeof(__int128));
    *slot = v;
    r->slots = (void**)malloc(1 * sizeof(void*));
    r->slots[0] = slot;
    return r;
}
__int128 resid_unbox_i128(void* p) {
    ResidVal* r = (ResidVal*)p;
    return *(__int128*)r->slots[0];
}

void* resid_box_u128(unsigned __int128 v) {
    ResidVal* r = (ResidVal*)malloc(sizeof(ResidVal));
    r->tag = -1;
    r->count = 1;
    r->type = "u128";
    unsigned __int128* slot = (unsigned __int128*)malloc(sizeof(unsigned __int128));
    *slot = v;
    r->slots = (void**)malloc(1 * sizeof(void*));
    r->slots[0] = slot;
    return r;
}
unsigned __int128 resid_unbox_u128(void* p) {
    ResidVal* r = (ResidVal*)p;
    return *(unsigned __int128*)r->slots[0];
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

/* 128-bit integer stringification (wide numeric family, spec §6).
 * LLVM lowers Int(128)/UInt(128) to native i128; the C runtime takes
 * `__int128` / `unsigned __int128` directly (i128 is the C ABI for both). */
char* Int128ToString(__int128 v) {
    char buf[48];
    int neg = v < 0;
    unsigned __int128 u = neg ? (unsigned __int128)(-(v + 1)) + 1 : (unsigned __int128)v;
    char tmp[48];
    int i = 0;
    if (u == 0) {
        tmp[i++] = '0';
    } else {
        while (u > 0) {
            tmp[i++] = (char)('0' + (int)(u % 10));
            u /= 10;
        }
    }
    if (neg) tmp[i++] = '-';
    int j = 0;
    while (i > 0) buf[j++] = tmp[--i];
    buf[j] = '\0';
    return resid_box_str(buf);
}

char* UInt128ToString(unsigned __int128 u) {
    char buf[48];
    char tmp[48];
    int i = 0;
    if (u == 0) {
        tmp[i++] = '0';
    } else {
        while (u > 0) {
            tmp[i++] = (char)('0' + (int)(u % 10));
            u /= 10;
        }
    }
    int j = 0;
    while (i > 0) buf[j++] = tmp[--i];
    buf[j] = '\0';
    return resid_box_str(buf);
}

/* 256/512-bit decimal stringification via u64-limb long division.
 * LLVM lowers Int(256)/Int(512) to arbitrary-width integers; codegen
 * truncates the value into little-endian u64 limbs before calling these,
 * since the C ABI has no native 256-bit type. */
static char* u64_limbs_to_str(const uint64_t* limbs, int count, int neg) {
    char buf[200];
    uint64_t work[8];
    int k;
    for (k = 0; k < count; k++) work[k] = limbs[k];
    if (neg) {
        uint64_t carry = 1;
        for (k = 0; k < count; k++) {
            uint64_t inv = ~work[k];
            work[k] = inv + carry;
            carry = (carry && inv == UINT64_MAX) ? 1 : 0;
        }
    }
    int allzero = 1;
    for (k = 0; k < count; k++) {
        if (work[k]) { allzero = 0; break; }
    }
    char tmp[200];
    int i = 0;
    if (allzero) {
        tmp[i++] = '0';
    } else {
        while (!allzero) {
            uint64_t r = 0;
            for (k = count - 1; k >= 0; k--) {
                __uint128_t cur = ((__uint128_t)r << 64) | work[k];
                work[k] = (uint64_t)(cur / 10);
                r = (uint64_t)(cur % 10);
            }
            tmp[i++] = (char)('0' + (int)r);
            allzero = 1;
            for (k = 0; k < count; k++) {
                if (work[k]) { allzero = 0; break; }
            }
        }
    }
    if (neg) tmp[i++] = '-';
    int j = 0;
    while (i > 0) buf[j++] = tmp[--i];
    buf[j] = '\0';
    return resid_box_str(buf);
}

char* Int256ToString(uint64_t l0, uint64_t l1, uint64_t l2, uint64_t l3) {
    uint64_t limbs[4] = {l0, l1, l2, l3};
    return u64_limbs_to_str(limbs, 4, (int)(l3 >> 63));
}

char* UInt256ToString(uint64_t l0, uint64_t l1, uint64_t l2, uint64_t l3) {
    uint64_t limbs[4] = {l0, l1, l2, l3};
    return u64_limbs_to_str(limbs, 4, 0);
}

char* Int512ToString(uint64_t l0, uint64_t l1, uint64_t l2, uint64_t l3,
                     uint64_t l4, uint64_t l5, uint64_t l6, uint64_t l7) {
    uint64_t limbs[8] = {l0, l1, l2, l3, l4, l5, l6, l7};
    return u64_limbs_to_str(limbs, 8, (int)(l7 >> 63));
}

char* UInt512ToString(uint64_t l0, uint64_t l1, uint64_t l2, uint64_t l3,
                      uint64_t l4, uint64_t l5, uint64_t l6, uint64_t l7) {
    uint64_t limbs[8] = {l0, l1, l2, l3, l4, l5, l6, l7};
    return u64_limbs_to_str(limbs, 8, 0);
}

char* FloatToString(double v) {
    char buf[64];
    snprintf(buf, sizeof(buf), "%.17g", v);
    return resid_box_str(buf);
}

/* ── Float(128) stringification (spec §6.2 — Float(128) is the widest) ───
 * IEEE 754 quadruple: 1 sign + 15 exponent + 112 fraction. Printed as
 * %.36g-style decimal (round-trip for quad) via binary bignum — no
 * libquadmath dependency. */
#define F128_WORDS 260 /* >= 16384/64 + slack: covers the full exponent range */

static void f128_zero(uint64_t* w) { memset(w, 0, F128_WORDS * 8); }

static int f128_is_zero(uint64_t* w) {
    int i;
    for (i = 0; i < F128_WORDS; i++)
        if (w[i]) return 0;
    return 1;
}

static void f128_shl(uint64_t* w, int bits) {
    int ws = bits / 64, bs = bits % 64;
    int i;
    if (bs == 0) {
        for (i = F128_WORDS - 1; i >= ws; i--) w[i] = w[i - ws];
        for (i = 0; i < ws; i++) w[i] = 0;
    } else {
        for (i = F128_WORDS - 1; i >= ws; i--) {
            uint64_t hi = (i - ws - 1 >= 0) ? (w[i - ws - 1] >> (64 - bs)) : 0;
            w[i] = (w[i - ws] << bs) | hi;
        }
        for (i = 0; i < ws; i++) w[i] = 0;
    }
}

static void f128_shr(uint64_t* w, int bits) {
    int ws = bits / 64, bs = bits % 64;
    int i;
    if (bs == 0) {
        for (i = 0; i + ws < F128_WORDS; i++) w[i] = w[i + ws];
        for (i = F128_WORDS - ws; i < F128_WORDS; i++) w[i] = 0;
    } else {
        for (i = 0; i + ws < F128_WORDS; i++) {
            uint64_t lo = (i + ws + 1 < F128_WORDS) ? (w[i + ws + 1] << (64 - bs)) : 0;
            w[i] = (w[i + ws] >> bs) | lo;
        }
        for (i = F128_WORDS - ws; i < F128_WORDS; i++) w[i] = 0;
    }
}

/* w *= 10, keeping the low bits (top carry is dropped). */
static void f128_mul10(uint64_t* w) {
    uint64_t carry = 0;
    int i;
    for (i = 0; i < F128_WORDS; i++) {
        __uint128_t t = (__uint128_t)w[i] * 10 + carry;
        w[i] = (uint64_t)t;
        carry = (uint64_t)(t >> 64);
    }
}

/* Divide w by 10 in place, returning the remainder digit. */
static uint64_t f128_div10(uint64_t* w) {
    uint64_t r = 0;
    int i;
    for (i = F128_WORDS - 1; i >= 0; i--) {
        __uint128_t cur = ((__uint128_t)r << 64) | w[i];
        w[i] = (uint64_t)(cur / 10);
        r = (uint64_t)(cur % 10);
    }
    return r;
}

/* Copy a small (<= 128-bit) value into the bignum. */
static void f128_load(uint64_t* w, unsigned __int128 v) {
    f128_zero(w);
    w[0] = (uint64_t)v;
    w[1] = (uint64_t)(v >> 64);
}

char* Float128ToString(_Float128 v) {
    unsigned __int128 u;
    memcpy(&u, &v, 16);
    int neg = (int)(u >> 127);
    unsigned expf = (unsigned)((u >> 112) & 0x7FFF);
    unsigned __int128 mask = (((unsigned __int128)1) << 112) - 1;
    unsigned __int128 frac = u & mask;

    char buf[96];
    if (expf == 0x7FFF) {
        snprintf(buf, sizeof(buf), frac ? "nan" : (neg ? "-inf" : "inf"));
        return resid_box_str(buf);
    }

    unsigned __int128 M;
    int E;
    if (expf == 0) { /* zero or subnormal */
        M = frac;
        E = -16382 - 112;
    } else {
        M = (((unsigned __int128)1) << 112) | frac;
        E = (int)expf - 16383 - 112;
    }

    uint64_t m[F128_WORDS];
    f128_load(m, M);

    char ibuf[5000]; /* integer digits, reversed; 2^16384 ~= 10^4932 digits max */
    int ilen = 0;
    int dec_exp; /* decimal exponent of the leading digit (units = 0) */
    char fdig[64]; /* fraction digits */
    int flen = 0;

    if (E >= 0) {
        f128_shl(m, E);
        if (f128_is_zero(m)) {
            return resid_box_str("0");
        }
        while (!f128_is_zero(m) && ilen < 5000) {
            ibuf[ilen++] = (char)('0' + (int)f128_div10(m));
        }
        dec_exp = ilen - 1;
    } else {
        int nb = -E;
        uint64_t ipart[F128_WORDS];
        uint64_t rem[F128_WORDS];
        f128_zero(rem);
        f128_load(rem, M);
        f128_shr(rem, nb);
        if (f128_is_zero(rem)) {
            /* no integer part */
            dec_exp = -1;
            /* fraction = M mod 2^nb */
            f128_zero(m);
            f128_load(m, M);
            {
                int widx = nb / 64, rem = nb % 64;
                for (int i = widx + 1; i < F128_WORDS; i++) m[i] = 0;
                if (rem != 0) m[widx] &= ((((uint64_t)1) << rem) - 1);
            }
            /* else nb >= 128: M < 2^113 so the whole M is the fraction */
        } else {
            memcpy(ipart, rem, F128_WORDS * 8);
            while (!f128_is_zero(ipart) && ilen < 5000) {
                ibuf[ilen++] = (char)('0' + (int)f128_div10(ipart));
            }
            dec_exp = ilen - 1;
            /* fraction = M mod 2^nb */
            f128_zero(m);
            f128_load(m, M);
            {
                int widx = nb / 64, rem = nb % 64;
                for (int i = widx + 1; i < F128_WORDS; i++) m[i] = 0;
                if (rem != 0) m[widx] &= ((((uint64_t)1) << rem) - 1);
            }
        }
        /* generate fraction digits from m (remainder scaled by 2^nb) */
        if (!f128_is_zero(m)) {
            int widx = nb / 64, rem = nb % 64;
            for (int k = 0; k < 44; k++) {
                f128_mul10(m);
                /* digit = (m*10) >> nb  (top bits, in [0,9]) */
                uint64_t hi;
                if (rem == 0) hi = m[widx];
                else hi = (m[widx] >> rem) | (m[widx + 1] << (64 - rem));
                fdig[flen++] = (char)('0' + (int)(hi & 0xF));
                /* m &= (2^nb - 1) */
                {
                    int i;
                    for (i = widx + 1; i < F128_WORDS; i++) m[i] = 0;
                    if (rem != 0) m[widx] &= ((((uint64_t)1) << rem) - 1);
                }
                if (f128_is_zero(m)) break;
            }
        }
    }

    /* Now: ilen integer digits (reversed in ibuf), flen fraction digits.
     * For the no-integer-part case dec_exp was set to -1; if the fraction
     * starts with zeros, adjust dec_exp accordingly. */
    int i = ilen - 1;
    if (ilen == 0) {
        /* leading zeros in fraction */
        int lead = 0;
        while (lead < flen && fdig[lead] == '0') lead++;
        if (lead == flen) {
            return resid_box_str(neg ? "-0" : "0");
        }
        dec_exp = -lead - 1;
        /* shift fraction digits left by `lead` */
        for (int k = lead; k < flen; k++) fdig[k - lead] = fdig[k];
        flen -= lead;
    }

    /* Assemble up to 36 significant digits (round-trip for quad) with rounding
     * (half away from zero). */
    char digits[40];
    int ndig = 0;
    /* integer digits */
    for (int k = ilen - 1; k >= 0 && ndig < 37; k--) digits[ndig++] = ibuf[k];
    /* fraction digits */
    for (int k = 0; k < flen && ndig < 37; k++) digits[ndig++] = fdig[k];
    if (ndig > 36) {
        /* round 37th */
        if (digits[36] >= '5') {
            int k = 35;
            while (k >= 0) {
                if (digits[k] == '9') { digits[k] = '0'; k--; }
                else { digits[k]++; break; }
            }
            if (k < 0) {
                /* all 9s: 9.999... -> 1.000... with dec_exp+1 */
                digits[0] = '1';
                for (int j = 1; j < 36; j++) digits[j] = '0';
                dec_exp++;
            }
        }
        ndig = 36;
    }
    /* strip trailing zeros */
    while (ndig > 1 && digits[ndig - 1] == '0') ndig--;

    /* format like %.36g */
    char out[96];
    int o = 0;
    if (neg) out[o++] = '-';
    if (dec_exp >= -6 && dec_exp <= 36) {
        /* fixed notation */
        if (dec_exp < 0) {
            out[o++] = '0'; out[o++] = '.';
            for (int z = 0; z < -dec_exp - 1 && o < 90; z++) out[o++] = '0';
            for (int k = 0; k < ndig; k++) out[o++] = digits[k];
        } else {
            for (int k = 0; k <= dec_exp; k++) {
                out[o++] = (k < ndig) ? digits[k] : '0';
            }
            if (dec_exp + 1 < ndig) {
                out[o++] = '.';
                for (int k = dec_exp + 1; k < ndig; k++) out[o++] = digits[k];
            }
        }
    } else {
        /* scientific: d.ddd...E±ee */
        out[o++] = digits[0];
        if (ndig > 1) {
            out[o++] = '.';
            for (int k = 1; k < ndig; k++) out[o++] = digits[k];
        }
        out[o++] = 'E';
        if (dec_exp >= 0) out[o++] = '+';
        else { out[o++] = '-'; dec_exp = -dec_exp; }
        if (dec_exp < 10) out[o++] = '0';
        snprintf(out + o, sizeof(out) - o, "%d", dec_exp);
        o = (int)strlen(out);
    }
    out[o] = '\0';
    return resid_box_str(out);
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
_Float128 f128(double v) { return (_Float128)v; }

/* ── Pointer-sized helpers ─────────────────────────────────────── */
int64_t isize(int64_t v) { return v; }
uint64_t usize(uint64_t v) { return v; }

/*
 * Checked/wrapping/saturating arithmetic (spec §6.5).
 *
 * Checked arithmetic for the default operators (+, -, *, /, %) is handled
 * in LLVM codegen: overflow is detected with icmp + select/branch, and on
 * overflow the runtime calls resid_abort.
 *
 * Wrapping and saturating variants are exposed here as extern functions.
 * They are callable from Resid source (e.g. `wrapping_add(a, b)`).
 */

/* ── Wrapping operations (C integer overflow is well-defined: wrap) ─ */
int64_t wrapping_add(int64_t a, int64_t b) { return a + b; }
int64_t wrapping_sub(int64_t a, int64_t b) { return a - b; }
int64_t wrapping_mul(int64_t a, int64_t b) { return a * b; }
int64_t wrapping_div(int64_t a, int64_t b) {
    if (b == 0) resid_abort("wrapping_div: division by zero");
    return a / b;
}
uint64_t wrapping_uadd(uint64_t a, uint64_t b) { return a + b; }
uint64_t wrapping_usub(uint64_t a, uint64_t b) { return a - b; }
uint64_t wrapping_umul(uint64_t a, uint64_t b) { return a * b; }
uint64_t wrapping_udiv(uint64_t a, uint64_t b) {
    if (b == 0) resid_abort("wrapping_udiv: division by zero");
    return a / b;
}

/* ── Saturating operations ─────────────────────────────────────── */
int64_t saturating_add(int64_t a, int64_t b) {
    if (b > 0 && a > INT64_MAX - b) return INT64_MAX;
    if (b < 0 && a < INT64_MIN - b) return INT64_MIN;
    return a + b;
}
int64_t saturating_sub(int64_t a, int64_t b) {
    if (b < 0 && a > INT64_MAX + b) return INT64_MAX;
    if (b > 0 && a < INT64_MIN + b) return INT64_MIN;
    return a - b;
}
int64_t saturating_mul(int64_t a, int64_t b) {
    if (a == 0 || b == 0) return 0;
    int64_t r = a * b;
    /* Check overflow: if (a > 0 && b > 0 && r < 0) || (a < 0 && b < 0 && r > 0) ||
       (a > 0 && b < 0 && r > 0) || (a < 0 && b > 0 && r < 0) */
    if ((a > 0 && b > 0 && r < 0) || (a < 0 && b < 0 && r > 0) ||
        (a > 0 && b < 0 && r > 0) || (a < 0 && b > 0 && r < 0)) {
        return (a > 0) == (b > 0) ? INT64_MAX : INT64_MIN;
    }
    return r;
}
uint64_t saturating_uadd(uint64_t a, uint64_t b) {
    if (b > 0 && a > UINT64_MAX - b) return UINT64_MAX;
    return a + b;
}
uint64_t saturating_usub(uint64_t a, uint64_t b) {
    if (b > a) return 0;
    return a - b;
}
uint64_t saturating_umul(uint64_t a, uint64_t b) {
    if (a == 0 || b == 0) return 0;
    uint64_t r = a * b;
    if (a != 0 && r / a != b) return UINT64_MAX;
    return r;
}

/* ── Checked operations (returns result; caller checks via overflow flag) ─ */
/* These return the computation result; the caller must have emitted an
   overflow check before calling. For division by zero, resid_abort is called. */
int64_t checked_add(int64_t a, int64_t b) { return a + b; }
int64_t checked_sub(int64_t a, int64_t b) { return a - b; }
int64_t checked_mul(int64_t a, int64_t b) { return a * b; }
int64_t checked_div(int64_t a, int64_t b) {
    if (b == 0) resid_abort("checked_div: division by zero");
    return a / b;
}
uint64_t checked_uadd(uint64_t a, uint64_t b) { return a + b; }
uint64_t checked_usub(uint64_t a, uint64_t b) { return a - b; }
uint64_t checked_umul(uint64_t a, uint64_t b) { return a * b; }
uint64_t checked_udiv(uint64_t a, uint64_t b) {
    if (b == 0) resid_abort("checked_udiv: division by zero");
    return a / b;
}
/*
 * Range and Slice runtime support (spec §15).
 *
 * Range: a boxed value with start, end, and closed flag.
 * Slice: a boxed value pointing into a list's data with start/end indices.
 */
void* resid_range_new(int64_t start, int64_t end, int8_t closed) {
    int64_t* s = (int64_t*)malloc(sizeof(int64_t));
    *s = start;
    int64_t* e = (int64_t*)malloc(sizeof(int64_t));
    *e = end;
    int8_t* c = (int8_t*)malloc(sizeof(int8_t));
    *c = closed;
    void* slots[3] = { s, e, c };
    return resid_box_new(10, 3, slots, "Range");
}

void* resid_slice_new(void* target, int64_t start, int64_t end) {
    void* t = target;
    int64_t* s = (int64_t*)malloc(sizeof(int64_t));
    *s = start;
    int64_t* e = (int64_t*)malloc(sizeof(int64_t));
    *e = end;
    void* slots[3] = { t, s, e };
    return resid_box_new(11, 3, slots, "Slice");
}

/*
 * Trusted providers (spec §32): filesystem, environment, git.
 *
 * Bootstrap: the kernel allows these unconditionally (a real build will gate
 * them behind capability authorization). Verbaturn links backward to the
 * `PROVIDER_VERBS` table in resid-type; adding a verb here must be mirrored
 * there and in resid-codegen's `lower_provider_call`.
 */
int8_t resid_fs_exists(const char* path) {
    FILE* f = fopen(path, "rb");
    if (!f) return 0;
    fclose(f);
    return 1;
}

/* Read an entire file into a NUL-terminated Str (bootstrap lexer input).
 * On error, returns an empty string (mirrors the env/empty-string default). */
char* resid_fs_read_all(const char* path) {
    FILE* f = fopen(path, "rb");
    if (!f) return resid_box_str("");
    if (fseek(f, 0, SEEK_END) != 0) {
        fclose(f);
        return resid_box_str("");
    }
    long sz = ftell(f);
    if (sz < 0 || fseek(f, 0, SEEK_SET) != 0) {
        fclose(f);
        return resid_box_str("");
    }
    char* p = (char*)malloc((size_t)sz + 1);
    if (!p) {
        fclose(f);
        return resid_box_str("");
    }
    size_t n = fread(p, 1, (size_t)sz, f);
    fclose(f);
    p[n] = '\0';
    return p;
}

/* Write `contents` to `path`, truncating if it exists. Returns 1 on success,
 * 0 on failure (M6 P1 — the self-hosted compiler emits `.ll` files). */
int8_t resid_fs_write_all(const char* path, const char* contents) {
    FILE* f = fopen(path, "wb");
    if (!f) return 0;
    size_t n = fwrite(contents, 1, strlen(contents), f);
    int ok = (n == strlen(contents)) && (fclose(f) == 0);
    if (!ok) fclose(f);
    return ok ? 1 : 0;
}

void* resid_fs_list_dir(const char* path) {
    /* Shell out to `ls` since POSIX globbing/readdir adds surface; the
     * runtime is allowed to use libc, so this is a pragmatic bootstrap. */
    char cmd[4096];
    snprintf(cmd, sizeof(cmd), "ls -1 \"%s\" 2>/dev/null", path);
    FILE* p = popen(cmd, "r");
    if (!p) {
        void* slots[1] = { NULL };
        return resid_box_new(0, 0, slots, "List(Str)");
    }
    char line[4096];
    void* slots[4096];
    size_t n = 0;
    while (n < 4096 && fgets(line, sizeof(line), p)) {
        size_t len = strlen(line);
        if (len > 0 && line[len - 1] == '\n') line[len - 1] = '\0';
        slots[n++] = resid_box_str(line);
    }
    pclose(p);
    return resid_box_new(0, (int64_t)n, slots, "List(Str)");
}

/* ─────────────────────────────────────────────────────────────
 * Handles (spec §16).
 *
 * A handle is an identity-bearing resource box. A File handle (tag 12) wraps
 * a `FILE*` in slot 0. `with` blocks release their handles automatically via
 * `resid_handle_release` (reverse binding order); `filesystem.close` releases
 * one explicitly.
 * ───────────────────────────────────────────────────────────── */
#define FILE_HANDLE_TAG 12

void* resid_fs_open(const char* path) {
    FILE* f = fopen(path, "rb");
    void* slots[1] = { f };
    return resid_box_new(FILE_HANDLE_TAG, 1, slots, "File");
}

/* Read the whole file from a File handle (rewinding first). Returns a
 * NUL-terminated Str; empty on failure. Exercises the handle's identity: the
 * data is read through the handle, not by re-opening the path. */
char* resid_fs_read_handle(void* b) {
    if (!b) return resid_box_str("");
    ResidVal* v = (ResidVal*)b;
    if (v->tag != FILE_HANDLE_TAG || v->count < 1) return resid_box_str("");
    FILE* f = (FILE*)v->slots[0];
    if (!f) return resid_box_str("");
    if (fseek(f, 0, SEEK_END) != 0) return resid_box_str("");
    long sz = ftell(f);
    if (sz < 0 || fseek(f, 0, SEEK_SET) != 0) return resid_box_str("");
    char* p = (char*)malloc((size_t)sz + 1);
    if (!p) return resid_box_str("");
    size_t n = fread(p, 1, (size_t)sz, f);
    p[n] = '\0';
    return p;
}

/* Explicit close of one File handle. Returns 1 on success, 0 if the handle is
 * null or was already released. Frees the handle box. */
int8_t resid_fs_close(void* b) {
    if (!b) return 0;
    ResidVal* v = (ResidVal*)b;
    if (v->tag == FILE_HANDLE_TAG && v->count >= 1) {
        FILE* f = (FILE*)v->slots[0];
        if (f) fclose(f);
    }
    if (v->slots) free(v->slots);
    free(v);
    return 1;
}

/* RAII release: closes any wrapped FILE* (tag 12) and frees the handle box.
 * Called by `with` cleanup. Safe on null; does not recurse into slot payloads
 * (handles are identity-bearing, single-owner values). */
void resid_handle_release(void* b) {
    if (!b) return;
    ResidVal* v = (ResidVal*)b;
    if (v->tag == FILE_HANDLE_TAG && v->count >= 1) {
        FILE* f = (FILE*)v->slots[0];
        if (f) fclose(f);
    }
    if (v->slots) free(v->slots);
    free(v);
}

char* resid_env_get(const char* name) {
    const char* v = getenv(name);
    return v ? resid_box_str(v) : resid_box_str("");
}

int8_t resid_env_has(const char* name) {
    return getenv(name) != NULL ? 1 : 0;
}

/* Command-line arguments (`args` provider, spec §32). glibc passes
 * (argc, argv, envp) to ELF .init_array constructors, so a constructor
 * captures them without any change to the generated entry point. */
static int g_resid_argc = 0;
static char** g_resid_argv = 0;

__attribute__((constructor)) static void resid_capture_args(int argc, char** argv) {
    g_resid_argc = argc;
    g_resid_argv = argv;
}

int64_t resid_process_run(const char* cmd) {
    return (int64_t)system(cmd);
}

int64_t resid_args_count(void) { return g_resid_argc; }

char* resid_args_get(int64_t i) {
    if (i < 0 || i >= g_resid_argc) return resid_box_str("");
    return resid_box_str(g_resid_argv[i]);
}

char* resid_git_rev(const char* ref) {
    char cmd[4096];
    snprintf(cmd, sizeof(cmd), "git rev-parse %s 2>/dev/null", ref);
    FILE* p = popen(cmd, "r");
    if (!p) return resid_box_str("");
    char line[256];
    if (!fgets(line, sizeof(line), p)) {
        pclose(p);
        return resid_box_str("");
    }
    pclose(p);
    size_t len = strlen(line);
    if (len > 0 && line[len - 1] == '\n') line[len - 1] = '\0';
    return resid_box_str(line);
}

char* resid_git_branch(void) {
    FILE* p = popen("git rev-parse --abbrev-ref HEAD 2>/dev/null", "r");
    if (!p) return resid_box_str("");
    char line[256];
    if (!fgets(line, sizeof(line), p)) {
        pclose(p);
        return resid_box_str("");
    }
    pclose(p);
    size_t len = strlen(line);
    if (len > 0 && line[len - 1] == '\n') line[len - 1] = '\0';
    return resid_box_str(line);
}

/*
 * ─────────────────────────────────────────────────────────────
 * Dec(N) exact-decimal runtime (spec §6.6a).
 *
 * A resid_dec holds
 *
 *     value = sign * int(digits) * 10^exp
 *
 * where digits is an array of EXACTLY nd significant decimal digits
 * (big-endian: digits[0] = most significant, digits[0] != '0' unless
 * the value is zero). nd is the precision N of the value; every
 * Dec(N) value has nd == N, so narrowing happens on store (round half
 * away from zero, spec §6.6a). Zero is sign = 0, digits all '0',
 * exp = 0. There is no NaN and no Inf; division by zero and exponent
 * overflow are errors (resid_abort).
 *
 * Display is fixed notation with all N significant digits; trailing
 * zeros are preserved: `Dec(4) 1.5` prints as "1.500" (the v3.1 spec
 * example `"1.5000"` showed one extra zero and was corrected).
 */
#define RESID_DEC_MAX_DIGITS 512
#define RESID_DEC_WORK_DIGITS 2048
#define RESID_DEC_MAX_EXP 1000000

typedef struct {
    int8_t sign;                                  /* -1, 0, +1 */
    uint16_t nd;                                  /* precision N */
    uint8_t digits[RESID_DEC_MAX_DIGITS];         /* '0'..'9', big-endian */
    int32_t exp;                                  /* -MAX_EXP..MAX_EXP */
} resid_dec;

/* Little-endian scratch buffer: value = sum d[i] * 10^(exp+i). */
typedef struct {
    int32_t d[RESID_DEC_WORK_DIGITS];
    int32_t n;
    int32_t exp;
    int8_t sign;
} dec_work;

static void dec_zero(int32_t prec, resid_dec* out) {
    out->sign = 0;
    out->nd = (uint16_t)prec;
    memset(out->digits, '0', (size_t)prec);
    out->exp = 0;
}

static void dec_load(const resid_dec* v, dec_work* w) {
    memset(w, 0, sizeof(*w));
    w->sign = v->sign;
    w->n = v->nd;
    w->exp = v->exp;
    for (int32_t i = 0; i < v->nd; i++) w->d[v->nd - 1 - i] = v->digits[i] - '0';
}

/* Drop most-significant (leading, in little-endian terms) zeros. */
static void work_strip_msd(dec_work* w) {
    while (w->n > 1 && w->d[w->n - 1] == 0) w->n--;
}

/* Distribute decimal carries after digit-wise summation. */
static void work_carry(dec_work* w) {
    int32_t c = 0;
    for (int32_t i = 0; i < w->n; i++) {
        int32_t v = w->d[i] + c;
        w->d[i] = v % 10;
        c = v / 10;
    }
    while (c > 0) {
        if (w->n >= RESID_DEC_WORK_DIGITS) resid_abort("dec: overflow");
        w->d[w->n++] = c % 10;
        c /= 10;
    }
}

/* Round the little-endian value to `prec` significant digits (half away
 * from zero, spec §6.6a) and store big-endian into out with nd == prec. */
static void work_store(dec_work* w, int32_t prec, resid_dec* out) {
    work_strip_msd(w);
    if (w->sign == 0 || (w->n == 1 && w->d[0] == 0)) {
        dec_zero(prec, out);
        return;
    }
    int32_t exp = w->exp;
    int32_t n = w->n;
    if (n <= prec) {
        /* Exact: shift digits up to the top and drop exp so the stored
         * precision is exactly `prec` significant digits. Little-endian:
         * the MSD lives at index n-1 and must land at index prec-1. */
        int32_t gap = prec - n;
        for (int32_t i = n - 1; i >= 0; i--) w->d[i + gap] = w->d[i];
        for (int32_t i = 0; i < gap; i++) w->d[i] = 0;
        exp -= gap;
        n = prec;
    } else {
        int32_t base = exp + (n - prec); /* exponent of the kept integer */
        int32_t carry = 0;
        if (w->d[n - prec - 1] >= 5) {
            carry = 1;
            for (int32_t k = n - prec; k < n && carry; k++) {
                w->d[k] += 1;
                if (w->d[k] == 10) w->d[k] = 0;
                else carry = 0;
            }
            if (carry) {
                /* 99..9 -> 100..0: becomes 10^prec, so "1" + zeros, exp+1. */
                w->d[n - 1] = 1;
                for (int32_t k = n - prec; k < n - 1; k++) w->d[k] = 0;
                base += 1;
            }
        }
        for (int32_t k = 0; k < prec; k++) w->d[k] = w->d[n - prec + k];
        exp = base;
        n = prec;
    }
    if (exp > RESID_DEC_MAX_EXP || exp < -RESID_DEC_MAX_EXP)
        resid_abort("dec: exponent out of range");
    out->sign = w->sign;
    out->nd = (uint16_t)prec;
    out->exp = exp;
    for (int32_t k = 0; k < prec; k++) out->digits[k] = (uint8_t)('0' + w->d[prec - 1 - k]);
}

static int work_abs_cmp(const dec_work* x, const dec_work* y) {
    int64_t hx = (int64_t)x->exp + x->n;
    int64_t hy = (int64_t)y->exp + y->n;
    if (hx != hy) return hx > hy ? 1 : -1;
    for (int64_t p = hx - 1; p >= (int64_t)(x->exp < y->exp ? x->exp : y->exp); p--) {
        int32_t a = (p >= x->exp && p < x->exp + x->n) ? x->d[p - x->exp] : 0;
        int32_t b = (p >= y->exp && p < y->exp + y->n) ? y->d[p - y->exp] : 0;
        if (a != b) return a > b ? 1 : -1;
    }
    return 0;
}

/* |x| + |y|, rounded to `prec` significant digits. An operand is
 * negligible (skipped) when all its digits end strictly below the guard
 * digit of the prec-digit result, so huge exponent gaps can't overflow
 * the work buffer. */
static void work_add_mag(const dec_work* x, const dec_work* y, int32_t prec, resid_dec* out) {
    dec_work w;
    memset(&w, 0, sizeof(w));
    w.sign = x->sign;
    int32_t mx = x->exp + x->n;
    int32_t my = y->exp + y->n;
    int32_t maxmsd = (mx > my ? mx : my) - 1;
    int use_x = mx > maxmsd - prec;
    int use_y = my > maxmsd - prec;
    int32_t rexp = x->exp;
    if (use_y && y->exp < rexp) rexp = y->exp;
    w.exp = rexp;
    int32_t hi = 0;
    if (use_x) {
        for (int32_t i = 0; i < x->n; i++) {
            int32_t idx = x->exp + i - rexp;
            if (idx < 0 || idx >= RESID_DEC_WORK_DIGITS) resid_abort("dec: exponent overflow");
            w.d[idx] += x->d[i];
            if (x->exp + i + 1 - rexp > hi) hi = x->exp + i + 1 - rexp;
        }
    }
    if (use_y) {
        for (int32_t i = 0; i < y->n; i++) {
            int32_t idx = y->exp + i - rexp;
            if (idx < 0 || idx >= RESID_DEC_WORK_DIGITS) resid_abort("dec: exponent overflow");
            w.d[idx] += y->d[i];
            if (y->exp + i + 1 - rexp > hi) hi = y->exp + i + 1 - rexp;
        }
    }
    w.n = hi;
    work_carry(&w);
    work_store(&w, prec, out);
}

/* |x| - |y| (requires |x| >= |y|), rounded to `prec` digits. */
static void work_sub_mag(const dec_work* x, const dec_work* y, int32_t prec, resid_dec* out) {
    dec_work w;
    memset(&w, 0, sizeof(w));
    w.sign = x->sign;
    int32_t rexp = x->exp < y->exp ? x->exp : y->exp;
    w.exp = rexp;
    int32_t hi = 0;
    for (int32_t i = 0; i < x->n; i++) {
        int32_t idx = x->exp + i - rexp;
        if (idx < 0 || idx >= RESID_DEC_WORK_DIGITS) resid_abort("dec: exponent overflow");
        w.d[idx] += x->d[i];
        if (x->exp + i + 1 - rexp > hi) hi = x->exp + i + 1 - rexp;
    }
    for (int32_t i = 0; i < y->n; i++) {
        int32_t idx = y->exp + i - rexp;
        if (idx < 0 || idx >= RESID_DEC_WORK_DIGITS) resid_abort("dec: exponent overflow");
        w.d[idx] -= y->d[i];
    }
    w.n = hi;
    for (int32_t i = 0; i < w.n - 1; i++) {
        while (w.d[i] < 0) {
            w.d[i] += 10;
            w.d[i + 1]--;
        }
    }
    work_store(&w, prec, out);
}

/* |x| * |y|, rounded to `prec` digits. */
static void work_mul_mag(const dec_work* x, const dec_work* y, int32_t prec, resid_dec* out) {
    dec_work w;
    memset(&w, 0, sizeof(w));
    w.sign = x->sign;
    w.exp = x->exp + y->exp;
    for (int32_t i = 0; i < x->n; i++) {
        if (x->d[i] == 0) continue;
        for (int32_t j = 0; j < y->n; j++) {
            int32_t idx = i + j;
            if (idx >= RESID_DEC_WORK_DIGITS) resid_abort("dec: overflow");
            w.d[idx] += x->d[i] * y->d[j];
        }
    }
    w.n = x->n + y->n;
    work_carry(&w);
    work_store(&w, prec, out);
}

/* ── Big-endian big-int helpers for division ───────────────────── */
static int big_cmp(const uint8_t* a, int32_t an, const uint8_t* b, int32_t bn) {
    if (an != bn) return an > bn ? 1 : -1;
    for (int32_t i = 0; i < an; i++) {
        if (a[i] != b[i]) return a[i] > b[i] ? 1 : -1;
    }
    return 0;
}

/* In-place a -= b (big-endian, 0-9 digits); requires a >= b. Returns the
 * compacted digit count (leading zeros shifted away, so the returned digits
 * are exactly the significant ones starting at a[0]). */
static int32_t big_sub(uint8_t* a, int32_t an, const uint8_t* b, int32_t bn) {
    int32_t borrow = 0;
    for (int32_t i = 0; i < bn; i++) {
        int32_t v = a[an - 1 - i] - borrow - b[bn - 1 - i];
        if (v < 0) { v += 10; borrow = 1; } else { borrow = 0; }
        a[an - 1 - i] = (uint8_t)v;
    }
    for (int32_t i = bn; i < an && borrow; i++) {
        int32_t v = a[an - 1 - i] - 1;
        if (v < 0) { v += 10; borrow = 1; } else { borrow = 0; }
        a[an - 1 - i] = (uint8_t)v;
    }
    int32_t s = 0;
    while (s < an - 1 && a[s] == 0) s++;
    if (s > 0) {
        for (int32_t i = 0; i < an - s; i++) a[i] = a[i + s];
    }
    return an - s;
}

/* Integer quotient q = A / D (big-endian, D != 0, MSD of D nonzero).
 * q holds `an` digits; the significant quotient digits are q[0..qn).
 * Schoolbook long division: the remainder r stays < D after each step, so
 * each quotient digit is at most 9. */
static void big_div(const uint8_t* A, int32_t an, const uint8_t* D, int32_t dn, uint8_t* q) {
    uint8_t r[RESID_DEC_WORK_DIGITS];
    memset(r, 0, sizeof(r));
    int32_t rn = 0;
    for (int32_t i = 0; i < an; i++) {
        /* r = r*10 + A[i] (append the digit at the low end). */
        r[rn] = A[i];
        rn++;
        int32_t s = 0;
        while (s < rn - 1 && r[s] == 0) s++;
        if (s > 0) {
            for (int32_t j = 0; j < rn - s; j++) r[j] = r[j + s];
            rn -= s;
        }
        int32_t d = 0;
        while (d < 9 && big_cmp(r, rn, D, dn) >= 0) {
            rn = big_sub(r, rn, D, dn);
            d++;
        }
        q[i] = (uint8_t)d;
    }
}

/* value = int(a->digits) / int(b->digits) with the i32 exponents folded in,
 * computed to prec+2 guard digits then rounded once (spec §6.6a).
 *
 * All Dec values cross the LLVM boundary as pointers (an out-ptr for the
 * result, const ptrs for operands) so the aggregate ABI stays exactly in
 * sync between clang and the LLVM IR backend — clang and LLVM disagree on
 * by-value passing for this 520-byte struct. */
void resid_dec_div(resid_dec* out, const resid_dec* a, const resid_dec* b) {
    int32_t prec = a->nd > b->nd ? a->nd : b->nd;
    if (b->sign == 0) resid_abort("dec: division by zero");
    if (a->sign == 0) { dec_zero(prec, out); return; }
    int32_t nn = a->nd, dn = b->nd;
    uint8_t num[RESID_DEC_WORK_DIGITS], den[RESID_DEC_WORK_DIGITS];
    for (int32_t i = 0; i < nn; i++) num[i] = a->digits[i] - '0';
    for (int32_t i = 0; i < dn; i++) den[i] = b->digits[i] - '0';
    int32_t e = a->exp - b->exp;
    /* strip leading zeros (digit count must match int(num)) */
    while (nn > 1 && num[0] == 0) {
        for (int32_t i = 0; i < nn - 1; i++) num[i] = num[i + 1];
        nn--;
    }
    while (dn > 1 && den[0] == 0) {
        for (int32_t i = 0; i < dn - 1; i++) den[i] = den[i + 1];
        dn--;
    }
    /* strip trailing (least-significant) zeros so digit counts are exact */
    while (nn > 1 && num[nn - 1] == 0) { nn--; e++; }
    while (dn > 1 && den[dn - 1] == 0) { dn--; e--; }
    /* P = floor(log10(value)); compare num vs den padded to nn digits. */
    int32_t cmp = 0;
    if (nn < dn) {
        cmp = -1;
    } else {
        int32_t pad = nn - dn;
        for (int32_t i = 0; i < nn && cmp == 0; i++) {
            uint8_t na = num[i];
            uint8_t nb = (i < pad) ? 0 : den[i - pad];
            cmp = na > nb ? 1 : (na < nb ? -1 : 0);
        }
    }
    int32_t P = (cmp >= 0) ? (e + nn - dn) : (e + nn - dn - 1);
    int32_t K = prec + 2;
    int32_t exp_div = P - K + 1;
    int32_t shift = e + K - 1 - P;
    int32_t an;
    uint8_t anum[RESID_DEC_WORK_DIGITS];
    if (shift >= 0) {
        an = nn + shift;
        if (an > RESID_DEC_WORK_DIGITS) resid_abort("dec: exponent overflow");
        for (int32_t i = 0; i < nn; i++) anum[i] = num[i];
        for (int32_t i = nn; i < an; i++) anum[i] = 0;
    } else {
        an = nn + shift;
        if (an < 1) resid_abort("dec: internal");
        for (int32_t i = 0; i < an; i++) anum[i] = num[i];
    }
    uint8_t q[RESID_DEC_WORK_DIGITS];
    big_div(anum, an, den, dn, q);
    int32_t qn = an;
    int32_t s = 0;
    while (s < qn - 1 && q[s] == 0) s++;
    qn -= s;
    if (qn < K) resid_abort("dec: internal");
    if (qn > K) exp_div += qn - K; /* drop low (qn-K) digits: exp rises */
    dec_work w;
    memset(&w, 0, sizeof(w));
    w.sign = (a->sign == b->sign) ? 1 : -1;
    w.n = K;
    w.exp = exp_div;
    for (int32_t i = 0; i < K; i++) w.d[K - 1 - i] = q[s + i];
    work_store(&w, prec, out);
}

/* sign * int(digits) * 10^exp (digits verbatim, as from an `m` literal),
 * rounded to `prec` significant digits. */
void resid_dec_from_digits(resid_dec* out, const char* digits, int32_t exp, uint16_t prec) {
    while (*digits == '0') digits++;
    if (*digits == '\0') { dec_zero(prec, out); return; }
    int32_t len = (int32_t)strlen(digits);
    if (len > RESID_DEC_MAX_DIGITS) resid_abort("dec: literal too long");
    dec_work w;
    memset(&w, 0, sizeof(w));
    w.sign = 1;
    w.exp = exp;
    w.n = len;
    for (int32_t i = 0; i < len; i++) w.d[len - 1 - i] = digits[i] - '0';
    work_store(&w, prec, out);
}

void resid_dec_from_int(resid_dec* out, int64_t v, uint16_t prec) {
    if (v == 0) { dec_zero(prec, out); return; }
    int8_t sign = v < 0 ? -1 : 1;
    uint64_t u = v < 0 ? (uint64_t)(-(v + 1)) + 1 : (uint64_t)v;
    dec_work w;
    memset(&w, 0, sizeof(w));
    w.sign = sign;
    w.exp = 0;
    w.n = 0;
    while (u > 0) { w.d[w.n++] = (int32_t)(u % 10); u /= 10; }
    work_store(&w, prec, out);
}

void resid_dec_from_i128(resid_dec* out, __int128 v, uint16_t prec) {
    if (v == 0) { dec_zero(prec, out); return; }
    int8_t sign = v < 0 ? -1 : 1;
    unsigned __int128 u = v < 0 ? (unsigned __int128)(-(v + 1)) + 1 : (unsigned __int128)v;
    dec_work w;
    memset(&w, 0, sizeof(w));
    w.sign = sign;
    w.exp = 0;
    w.n = 0;
    while (u > 0) { w.d[w.n++] = (int32_t)(u % 10); u /= 10; }
    work_store(&w, prec, out);
}

/* Exact decimal parse of a plain or `e`-notation string (the latter from
 * binary-float %.17g casts). */
void resid_dec_from_str(resid_dec* out, const char* s, uint16_t prec) {
    const char* p = s;
    int8_t sign = 1;
    if (*p == '-') { sign = -1; p++; }
    else if (*p == '+') p++;
    uint8_t digs[RESID_DEC_MAX_DIGITS];
    int32_t dn = 0;
    while (*p >= '0' && *p <= '9') {
        if (dn >= RESID_DEC_MAX_DIGITS) resid_abort("dec: string too long");
        digs[dn++] = (uint8_t)(*p - '0');
        p++;
    }
    int32_t exp = 0;
    if (*p == '.') {
        p++;
        int32_t frac = 0;
        while (*p >= '0' && *p <= '9') {
            if (dn >= RESID_DEC_MAX_DIGITS) resid_abort("dec: string too long");
            digs[dn++] = (uint8_t)(*p - '0');
            p++;
            frac++;
        }
        exp = -frac;
    }
    if (*p == 'e' || *p == 'E') {
        p++;
        int32_t esign = 1;
        if (*p == '-') { esign = -1; p++; }
        else if (*p == '+') p++;
        int32_t ev = 0;
        while (*p >= '0' && *p <= '9') {
            if (ev > RESID_DEC_MAX_EXP / 10) resid_abort("dec: exponent out of range");
            ev = ev * 10 + (*p - '0');
            p++;
        }
        exp += esign * ev;
    }
    if (dn == 0 || *p != '\0') resid_abort("dec: bad decimal string");
    int32_t s2 = 0;
    int32_t nonzero = 0;
    for (int32_t i = 0; i < dn; i++) if (digs[i] != 0) nonzero = 1;
    if (!nonzero) { dec_zero(prec, out); return; }
    while (s2 < dn - 1 && digs[s2] == 0) s2++;
    dec_work w;
    memset(&w, 0, sizeof(w));
    w.sign = sign;
    w.exp = exp;
    w.n = dn - s2;
    for (int32_t i = 0; i < w.n; i++) w.d[w.n - 1 - i] = digs[s2 + i];
    work_store(&w, prec, out);
}

/* Fixed notation, all nd significant digits, trailing zeros preserved. */
char* resid_dec_to_string(const resid_dec* v) {
    int32_t N = v->nd;
    int32_t ipos = N + v->exp; /* integer digit count */
    int32_t len;
    if (v->sign == 0) {
        len = 2 + N; /* "0." + N zeros */
    } else {
        len = (v->sign < 0 ? 1 : 0);
        if (ipos > 0) {
            len += ipos;
            if (ipos < N) len += 1 + (N - ipos);
        } else {
            len += 2 + (-ipos) + N;
        }
    }
    char* tmp = (char*)malloc((size_t)len + 1);
    if (!tmp) resid_abort("dec: out of memory");
    int32_t k = 0;
    if (v->sign == 0) {
        tmp[k++] = '0';
        tmp[k++] = '.';
        for (int32_t i = 0; i < N; i++) tmp[k++] = '0';
    } else {
        if (v->sign < 0) tmp[k++] = '-';
        if (ipos > 0) {
            int32_t iint = ipos < N ? ipos : N;
            for (int32_t i = 0; i < iint; i++) tmp[k++] = (char)v->digits[i];
            for (int32_t i = iint; i < ipos; i++) tmp[k++] = '0';
            if (ipos < N) {
                tmp[k++] = '.';
                for (int32_t i = ipos; i < N; i++) tmp[k++] = (char)v->digits[i];
            }
        } else {
            tmp[k++] = '0';
            tmp[k++] = '.';
            for (int32_t i = 0; i < -ipos; i++) tmp[k++] = '0';
            for (int32_t i = 0; i < N; i++) tmp[k++] = (char)v->digits[i];
        }
    }
    tmp[k] = '\0';
    char* boxed = resid_box_str(tmp);
    free(tmp);
    return boxed;
}

void resid_dec_round(resid_dec* out, const resid_dec* v, uint16_t prec) {
    if (v->sign == 0) { dec_zero(prec, out); return; }
    dec_work w;
    dec_load(v, &w);
    work_store(&w, prec, out);
}

void resid_dec_neg(resid_dec* out, const resid_dec* v) {
    *out = *v;
    out->sign = (int8_t)-v->sign;
}

void resid_dec_add(resid_dec* out, const resid_dec* a, const resid_dec* b) {
    int32_t prec = a->nd > b->nd ? a->nd : b->nd;
    if (a->sign == 0) { resid_dec_round(out, b, (uint16_t)prec); return; }
    if (b->sign == 0) { resid_dec_round(out, a, (uint16_t)prec); return; }
    dec_work wa, wb;
    dec_load(a, &wa);
    dec_load(b, &wb);
    if (wa.sign == wb.sign) {
        work_add_mag(&wa, &wb, prec, out);
    } else {
        int c = work_abs_cmp(&wa, &wb);
        if (c == 0) { dec_zero(prec, out); }
        else if (c > 0) { work_sub_mag(&wa, &wb, prec, out); }
        else { work_sub_mag(&wb, &wa, prec, out); }
    }
}

void resid_dec_sub(resid_dec* out, const resid_dec* a, const resid_dec* b) {
    resid_dec nb = *b;
    nb.sign = (int8_t)-nb.sign;
    resid_dec_add(out, a, &nb);
}

void resid_dec_mul(resid_dec* out, const resid_dec* a, const resid_dec* b) {
    int32_t prec = a->nd > b->nd ? a->nd : b->nd;
    if (a->sign == 0 || b->sign == 0) { dec_zero(prec, out); return; }
    dec_work wa, wb;
    dec_load(a, &wa);
    dec_load(b, &wb);
    wa.sign = (wa.sign == wb.sign) ? 1 : -1;
    work_mul_mag(&wa, &wb, prec, out);
}

int32_t resid_dec_cmp(const resid_dec* a, const resid_dec* b) {
    if (a->sign == 0 && b->sign == 0) return 0;
    if (a->sign == 0) return b->sign > 0 ? -1 : 1;
    if (b->sign == 0) return a->sign > 0 ? 1 : -1;
    if (a->sign != b->sign) return a->sign > b->sign ? 1 : -1;
    dec_work wa, wb;
    dec_load(a, &wa);
    dec_load(b, &wb);
    int c = work_abs_cmp(&wa, &wb);
    if (a->sign < 0) c = -c;
    return c;
}

int64_t resid_dec_to_int(const resid_dec* v, int64_t lo, int64_t hi) {
    if (v->sign == 0) return 0;
    int32_t frac = -v->exp;
    if (frac > 0) {
        if (frac > v->nd) resid_abort("dec: non-integer to Int");
        for (int32_t i = v->nd - frac; i < v->nd; i++)
            if (v->digits[i] != '0') resid_abort("dec: non-integer to Int");
    }
    /* Integer digit count: nd significant digits at exponent exp; a negative
     * exp shifts that many digits into the fraction (already verified zero),
     * a positive exp appends that many trailing zeros. */
    int32_t int_digits = v->nd + v->exp;
    if (int_digits < 0) int_digits = 0;
    int64_t r = 0;
    for (int32_t i = 0; i < int_digits; i++) {
        int32_t d = (i < v->nd) ? (v->digits[i] - '0') : 0;
        if (r > (INT64_MAX - d) / 10) resid_abort("dec: value out of range for Int");
        r = r * 10 + d;
    }
    if (v->sign < 0) r = -r;
    if (r < lo || r > hi) resid_abort("dec: value out of range for Int");
    return r;
}

/* Lossy for wide Dec values (documented bootstrap limitation). */
double resid_dec_to_f64(const resid_dec* v) {
    /* Accumulate only significant digits; precision-padding trailing zeros
     * fold into the power-of-ten exponent so e.g. Dec(34) 12.5m → 12.5
     * exactly, not 1.25e31 / 1e32 (double rounding noise). */
    int32_t sig = v->nd;
    while (sig > 0 && v->digits[sig - 1] == '0') sig--;
    int32_t exp = v->exp + (v->nd - sig);
    double r = 0.0;
    for (int32_t i = 0; i < sig; i++) r = r * 10.0 + (double)(v->digits[i] - '0');
    if (exp != 0) {
        int32_t e = exp > 0 ? exp : -exp;
        double p = 1.0;
        for (int32_t i = 0; i < e && p < 1e308 && p > 1e-308; i++) p *= 10.0;
        if (exp > 0) r *= p;
        else r /= p;
    }
    if (v->sign < 0) r = -r;
    return r;
}

/* Binary float -> Dec via %.17g (exact decimal of the double). */
void resid_dec_from_f64(resid_dec* out, double v, uint16_t prec) {
    if (v == 0.0) { dec_zero(prec, out); return; }
    if (!(v > -1e308 && v < 1e308)) resid_abort("dec: value out of range");
    char buf[40];
    snprintf(buf, sizeof(buf), "%.17g", v);
    resid_dec_from_str(out, buf, prec);
}

/* ════════════════════════════════════════════════════════════════
   Stdlib v1: string verbs (spec §14 semantics, codepoint-based).
   Lists use the ResidVal box layout (see stdlib v1.3 below).
   ════════════════════════════════════════════════════════════════ */

static int str_is_space(unsigned char c) {
    return c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\v' || c == '\f';
}

/* Trim leading/trailing ASCII whitespace. */
char* str_trim(const char* s) {
    const char* b = s;
    const char* e = s + strlen(s);
    while (b < e && str_is_space((unsigned char)*b)) b++;
    while (e > b && str_is_space((unsigned char)e[-1])) e--;
    int64_t n = e - b;
    char* p = (char*)malloc(n + 1);
    memcpy(p, b, n);
    p[n] = '\0';
    return p;
}

/* Does `s` contain `needle`? Empty needle is always true. */
int8_t str_contains(const char* s, const char* needle) {
    return strstr(s, needle) != NULL;
}

int8_t str_starts_with(const char* s, const char* pre) {
    size_t lp = strlen(pre);
    return strncmp(s, pre, lp) == 0;
}

int8_t str_ends_with(const char* s, const char* suf) {
    size_t ls = strlen(s), lf = strlen(suf);
    if (lf > ls) return 0;
    return strcmp(s + ls - lf, suf) == 0;
}

/* ─── Unicode simple case mapping ───
   Covers ASCII, Latin-1 Supplement, Latin Extended-A, Greek, and Cyrillic —
   the algorithmic ranges of Unicode's simple case mapping. Scripts with
   irregular pairs (Latin Extended-B, deset letters, full SpecialCasing) are
   mapped through an explicit pair table below; anything else passes through.
   UTF-8 aware: operates per codepoint. */

// BEGIN CASE TABLES — generated by tools/gen_case_tables.py; do not edit
/* lower: 1459 pairs, upper: 1450 pairs, special-upper: 83 expansions. */
static const uint32_t CASE_TO_LOWER[] = {
    0x0041,0x0061, 0x0042,0x0062, 0x0043,0x0063, 0x0044,0x0064,
    0x0045,0x0065, 0x0046,0x0066, 0x0047,0x0067, 0x0048,0x0068,
    0x0049,0x0069, 0x004A,0x006A, 0x004B,0x006B, 0x004C,0x006C,
    0x004D,0x006D, 0x004E,0x006E, 0x004F,0x006F, 0x0050,0x0070,
    0x0051,0x0071, 0x0052,0x0072, 0x0053,0x0073, 0x0054,0x0074,
    0x0055,0x0075, 0x0056,0x0076, 0x0057,0x0077, 0x0058,0x0078,
    0x0059,0x0079, 0x005A,0x007A, 0x00C0,0x00E0, 0x00C1,0x00E1,
    0x00C2,0x00E2, 0x00C3,0x00E3, 0x00C4,0x00E4, 0x00C5,0x00E5,
    0x00C6,0x00E6, 0x00C7,0x00E7, 0x00C8,0x00E8, 0x00C9,0x00E9,
    0x00CA,0x00EA, 0x00CB,0x00EB, 0x00CC,0x00EC, 0x00CD,0x00ED,
    0x00CE,0x00EE, 0x00CF,0x00EF, 0x00D0,0x00F0, 0x00D1,0x00F1,
    0x00D2,0x00F2, 0x00D3,0x00F3, 0x00D4,0x00F4, 0x00D5,0x00F5,
    0x00D6,0x00F6, 0x00D8,0x00F8, 0x00D9,0x00F9, 0x00DA,0x00FA,
    0x00DB,0x00FB, 0x00DC,0x00FC, 0x00DD,0x00FD, 0x00DE,0x00FE,
    0x0100,0x0101, 0x0102,0x0103, 0x0104,0x0105, 0x0106,0x0107,
    0x0108,0x0109, 0x010A,0x010B, 0x010C,0x010D, 0x010E,0x010F,
    0x0110,0x0111, 0x0112,0x0113, 0x0114,0x0115, 0x0116,0x0117,
    0x0118,0x0119, 0x011A,0x011B, 0x011C,0x011D, 0x011E,0x011F,
    0x0120,0x0121, 0x0122,0x0123, 0x0124,0x0125, 0x0126,0x0127,
    0x0128,0x0129, 0x012A,0x012B, 0x012C,0x012D, 0x012E,0x012F,
    0x0132,0x0133, 0x0134,0x0135, 0x0136,0x0137, 0x0139,0x013A,
    0x013B,0x013C, 0x013D,0x013E, 0x013F,0x0140, 0x0141,0x0142,
    0x0143,0x0144, 0x0145,0x0146, 0x0147,0x0148, 0x014A,0x014B,
    0x014C,0x014D, 0x014E,0x014F, 0x0150,0x0151, 0x0152,0x0153,
    0x0154,0x0155, 0x0156,0x0157, 0x0158,0x0159, 0x015A,0x015B,
    0x015C,0x015D, 0x015E,0x015F, 0x0160,0x0161, 0x0162,0x0163,
    0x0164,0x0165, 0x0166,0x0167, 0x0168,0x0169, 0x016A,0x016B,
    0x016C,0x016D, 0x016E,0x016F, 0x0170,0x0171, 0x0172,0x0173,
    0x0174,0x0175, 0x0176,0x0177, 0x0178,0x00FF, 0x0179,0x017A,
    0x017B,0x017C, 0x017D,0x017E, 0x0181,0x0253, 0x0182,0x0183,
    0x0184,0x0185, 0x0186,0x0254, 0x0187,0x0188, 0x0189,0x0256,
    0x018A,0x0257, 0x018B,0x018C, 0x018E,0x01DD, 0x018F,0x0259,
    0x0190,0x025B, 0x0191,0x0192, 0x0193,0x0260, 0x0194,0x0263,
    0x0196,0x0269, 0x0197,0x0268, 0x0198,0x0199, 0x019C,0x026F,
    0x019D,0x0272, 0x019F,0x0275, 0x01A0,0x01A1, 0x01A2,0x01A3,
    0x01A4,0x01A5, 0x01A6,0x0280, 0x01A7,0x01A8, 0x01A9,0x0283,
    0x01AC,0x01AD, 0x01AE,0x0288, 0x01AF,0x01B0, 0x01B1,0x028A,
    0x01B2,0x028B, 0x01B3,0x01B4, 0x01B5,0x01B6, 0x01B7,0x0292,
    0x01B8,0x01B9, 0x01BC,0x01BD, 0x01C4,0x01C6, 0x01C5,0x01C6,
    0x01C7,0x01C9, 0x01C8,0x01C9, 0x01CA,0x01CC, 0x01CB,0x01CC,
    0x01CD,0x01CE, 0x01CF,0x01D0, 0x01D1,0x01D2, 0x01D3,0x01D4,
    0x01D5,0x01D6, 0x01D7,0x01D8, 0x01D9,0x01DA, 0x01DB,0x01DC,
    0x01DE,0x01DF, 0x01E0,0x01E1, 0x01E2,0x01E3, 0x01E4,0x01E5,
    0x01E6,0x01E7, 0x01E8,0x01E9, 0x01EA,0x01EB, 0x01EC,0x01ED,
    0x01EE,0x01EF, 0x01F1,0x01F3, 0x01F2,0x01F3, 0x01F4,0x01F5,
    0x01F6,0x0195, 0x01F7,0x01BF, 0x01F8,0x01F9, 0x01FA,0x01FB,
    0x01FC,0x01FD, 0x01FE,0x01FF, 0x0200,0x0201, 0x0202,0x0203,
    0x0204,0x0205, 0x0206,0x0207, 0x0208,0x0209, 0x020A,0x020B,
    0x020C,0x020D, 0x020E,0x020F, 0x0210,0x0211, 0x0212,0x0213,
    0x0214,0x0215, 0x0216,0x0217, 0x0218,0x0219, 0x021A,0x021B,
    0x021C,0x021D, 0x021E,0x021F, 0x0220,0x019E, 0x0222,0x0223,
    0x0224,0x0225, 0x0226,0x0227, 0x0228,0x0229, 0x022A,0x022B,
    0x022C,0x022D, 0x022E,0x022F, 0x0230,0x0231, 0x0232,0x0233,
    0x023A,0x2C65, 0x023B,0x023C, 0x023D,0x019A, 0x023E,0x2C66,
    0x0241,0x0242, 0x0243,0x0180, 0x0244,0x0289, 0x0245,0x028C,
    0x0246,0x0247, 0x0248,0x0249, 0x024A,0x024B, 0x024C,0x024D,
    0x024E,0x024F, 0x0370,0x0371, 0x0372,0x0373, 0x0376,0x0377,
    0x037F,0x03F3, 0x0386,0x03AC, 0x0388,0x03AD, 0x0389,0x03AE,
    0x038A,0x03AF, 0x038C,0x03CC, 0x038E,0x03CD, 0x038F,0x03CE,
    0x0391,0x03B1, 0x0392,0x03B2, 0x0393,0x03B3, 0x0394,0x03B4,
    0x0395,0x03B5, 0x0396,0x03B6, 0x0397,0x03B7, 0x0398,0x03B8,
    0x0399,0x03B9, 0x039A,0x03BA, 0x039B,0x03BB, 0x039C,0x03BC,
    0x039D,0x03BD, 0x039E,0x03BE, 0x039F,0x03BF, 0x03A0,0x03C0,
    0x03A1,0x03C1, 0x03A3,0x03C3, 0x03A4,0x03C4, 0x03A5,0x03C5,
    0x03A6,0x03C6, 0x03A7,0x03C7, 0x03A8,0x03C8, 0x03A9,0x03C9,
    0x03AA,0x03CA, 0x03AB,0x03CB, 0x03CF,0x03D7, 0x03D8,0x03D9,
    0x03DA,0x03DB, 0x03DC,0x03DD, 0x03DE,0x03DF, 0x03E0,0x03E1,
    0x03E2,0x03E3, 0x03E4,0x03E5, 0x03E6,0x03E7, 0x03E8,0x03E9,
    0x03EA,0x03EB, 0x03EC,0x03ED, 0x03EE,0x03EF, 0x03F4,0x03B8,
    0x03F7,0x03F8, 0x03F9,0x03F2, 0x03FA,0x03FB, 0x03FD,0x037B,
    0x03FE,0x037C, 0x03FF,0x037D, 0x0400,0x0450, 0x0401,0x0451,
    0x0402,0x0452, 0x0403,0x0453, 0x0404,0x0454, 0x0405,0x0455,
    0x0406,0x0456, 0x0407,0x0457, 0x0408,0x0458, 0x0409,0x0459,
    0x040A,0x045A, 0x040B,0x045B, 0x040C,0x045C, 0x040D,0x045D,
    0x040E,0x045E, 0x040F,0x045F, 0x0410,0x0430, 0x0411,0x0431,
    0x0412,0x0432, 0x0413,0x0433, 0x0414,0x0434, 0x0415,0x0435,
    0x0416,0x0436, 0x0417,0x0437, 0x0418,0x0438, 0x0419,0x0439,
    0x041A,0x043A, 0x041B,0x043B, 0x041C,0x043C, 0x041D,0x043D,
    0x041E,0x043E, 0x041F,0x043F, 0x0420,0x0440, 0x0421,0x0441,
    0x0422,0x0442, 0x0423,0x0443, 0x0424,0x0444, 0x0425,0x0445,
    0x0426,0x0446, 0x0427,0x0447, 0x0428,0x0448, 0x0429,0x0449,
    0x042A,0x044A, 0x042B,0x044B, 0x042C,0x044C, 0x042D,0x044D,
    0x042E,0x044E, 0x042F,0x044F, 0x0460,0x0461, 0x0462,0x0463,
    0x0464,0x0465, 0x0466,0x0467, 0x0468,0x0469, 0x046A,0x046B,
    0x046C,0x046D, 0x046E,0x046F, 0x0470,0x0471, 0x0472,0x0473,
    0x0474,0x0475, 0x0476,0x0477, 0x0478,0x0479, 0x047A,0x047B,
    0x047C,0x047D, 0x047E,0x047F, 0x0480,0x0481, 0x048A,0x048B,
    0x048C,0x048D, 0x048E,0x048F, 0x0490,0x0491, 0x0492,0x0493,
    0x0494,0x0495, 0x0496,0x0497, 0x0498,0x0499, 0x049A,0x049B,
    0x049C,0x049D, 0x049E,0x049F, 0x04A0,0x04A1, 0x04A2,0x04A3,
    0x04A4,0x04A5, 0x04A6,0x04A7, 0x04A8,0x04A9, 0x04AA,0x04AB,
    0x04AC,0x04AD, 0x04AE,0x04AF, 0x04B0,0x04B1, 0x04B2,0x04B3,
    0x04B4,0x04B5, 0x04B6,0x04B7, 0x04B8,0x04B9, 0x04BA,0x04BB,
    0x04BC,0x04BD, 0x04BE,0x04BF, 0x04C0,0x04CF, 0x04C1,0x04C2,
    0x04C3,0x04C4, 0x04C5,0x04C6, 0x04C7,0x04C8, 0x04C9,0x04CA,
    0x04CB,0x04CC, 0x04CD,0x04CE, 0x04D0,0x04D1, 0x04D2,0x04D3,
    0x04D4,0x04D5, 0x04D6,0x04D7, 0x04D8,0x04D9, 0x04DA,0x04DB,
    0x04DC,0x04DD, 0x04DE,0x04DF, 0x04E0,0x04E1, 0x04E2,0x04E3,
    0x04E4,0x04E5, 0x04E6,0x04E7, 0x04E8,0x04E9, 0x04EA,0x04EB,
    0x04EC,0x04ED, 0x04EE,0x04EF, 0x04F0,0x04F1, 0x04F2,0x04F3,
    0x04F4,0x04F5, 0x04F6,0x04F7, 0x04F8,0x04F9, 0x04FA,0x04FB,
    0x04FC,0x04FD, 0x04FE,0x04FF, 0x0500,0x0501, 0x0502,0x0503,
    0x0504,0x0505, 0x0506,0x0507, 0x0508,0x0509, 0x050A,0x050B,
    0x050C,0x050D, 0x050E,0x050F, 0x0510,0x0511, 0x0512,0x0513,
    0x0514,0x0515, 0x0516,0x0517, 0x0518,0x0519, 0x051A,0x051B,
    0x051C,0x051D, 0x051E,0x051F, 0x0520,0x0521, 0x0522,0x0523,
    0x0524,0x0525, 0x0526,0x0527, 0x0528,0x0529, 0x052A,0x052B,
    0x052C,0x052D, 0x052E,0x052F, 0x0531,0x0561, 0x0532,0x0562,
    0x0533,0x0563, 0x0534,0x0564, 0x0535,0x0565, 0x0536,0x0566,
    0x0537,0x0567, 0x0538,0x0568, 0x0539,0x0569, 0x053A,0x056A,
    0x053B,0x056B, 0x053C,0x056C, 0x053D,0x056D, 0x053E,0x056E,
    0x053F,0x056F, 0x0540,0x0570, 0x0541,0x0571, 0x0542,0x0572,
    0x0543,0x0573, 0x0544,0x0574, 0x0545,0x0575, 0x0546,0x0576,
    0x0547,0x0577, 0x0548,0x0578, 0x0549,0x0579, 0x054A,0x057A,
    0x054B,0x057B, 0x054C,0x057C, 0x054D,0x057D, 0x054E,0x057E,
    0x054F,0x057F, 0x0550,0x0580, 0x0551,0x0581, 0x0552,0x0582,
    0x0553,0x0583, 0x0554,0x0584, 0x0555,0x0585, 0x0556,0x0586,
    0x10A0,0x2D00, 0x10A1,0x2D01, 0x10A2,0x2D02, 0x10A3,0x2D03,
    0x10A4,0x2D04, 0x10A5,0x2D05, 0x10A6,0x2D06, 0x10A7,0x2D07,
    0x10A8,0x2D08, 0x10A9,0x2D09, 0x10AA,0x2D0A, 0x10AB,0x2D0B,
    0x10AC,0x2D0C, 0x10AD,0x2D0D, 0x10AE,0x2D0E, 0x10AF,0x2D0F,
    0x10B0,0x2D10, 0x10B1,0x2D11, 0x10B2,0x2D12, 0x10B3,0x2D13,
    0x10B4,0x2D14, 0x10B5,0x2D15, 0x10B6,0x2D16, 0x10B7,0x2D17,
    0x10B8,0x2D18, 0x10B9,0x2D19, 0x10BA,0x2D1A, 0x10BB,0x2D1B,
    0x10BC,0x2D1C, 0x10BD,0x2D1D, 0x10BE,0x2D1E, 0x10BF,0x2D1F,
    0x10C0,0x2D20, 0x10C1,0x2D21, 0x10C2,0x2D22, 0x10C3,0x2D23,
    0x10C4,0x2D24, 0x10C5,0x2D25, 0x10C7,0x2D27, 0x10CD,0x2D2D,
    0x13A0,0xAB70, 0x13A1,0xAB71, 0x13A2,0xAB72, 0x13A3,0xAB73,
    0x13A4,0xAB74, 0x13A5,0xAB75, 0x13A6,0xAB76, 0x13A7,0xAB77,
    0x13A8,0xAB78, 0x13A9,0xAB79, 0x13AA,0xAB7A, 0x13AB,0xAB7B,
    0x13AC,0xAB7C, 0x13AD,0xAB7D, 0x13AE,0xAB7E, 0x13AF,0xAB7F,
    0x13B0,0xAB80, 0x13B1,0xAB81, 0x13B2,0xAB82, 0x13B3,0xAB83,
    0x13B4,0xAB84, 0x13B5,0xAB85, 0x13B6,0xAB86, 0x13B7,0xAB87,
    0x13B8,0xAB88, 0x13B9,0xAB89, 0x13BA,0xAB8A, 0x13BB,0xAB8B,
    0x13BC,0xAB8C, 0x13BD,0xAB8D, 0x13BE,0xAB8E, 0x13BF,0xAB8F,
    0x13C0,0xAB90, 0x13C1,0xAB91, 0x13C2,0xAB92, 0x13C3,0xAB93,
    0x13C4,0xAB94, 0x13C5,0xAB95, 0x13C6,0xAB96, 0x13C7,0xAB97,
    0x13C8,0xAB98, 0x13C9,0xAB99, 0x13CA,0xAB9A, 0x13CB,0xAB9B,
    0x13CC,0xAB9C, 0x13CD,0xAB9D, 0x13CE,0xAB9E, 0x13CF,0xAB9F,
    0x13D0,0xABA0, 0x13D1,0xABA1, 0x13D2,0xABA2, 0x13D3,0xABA3,
    0x13D4,0xABA4, 0x13D5,0xABA5, 0x13D6,0xABA6, 0x13D7,0xABA7,
    0x13D8,0xABA8, 0x13D9,0xABA9, 0x13DA,0xABAA, 0x13DB,0xABAB,
    0x13DC,0xABAC, 0x13DD,0xABAD, 0x13DE,0xABAE, 0x13DF,0xABAF,
    0x13E0,0xABB0, 0x13E1,0xABB1, 0x13E2,0xABB2, 0x13E3,0xABB3,
    0x13E4,0xABB4, 0x13E5,0xABB5, 0x13E6,0xABB6, 0x13E7,0xABB7,
    0x13E8,0xABB8, 0x13E9,0xABB9, 0x13EA,0xABBA, 0x13EB,0xABBB,
    0x13EC,0xABBC, 0x13ED,0xABBD, 0x13EE,0xABBE, 0x13EF,0xABBF,
    0x13F0,0x13F8, 0x13F1,0x13F9, 0x13F2,0x13FA, 0x13F3,0x13FB,
    0x13F4,0x13FC, 0x13F5,0x13FD, 0x1C89,0x1C8A, 0x1C90,0x10D0,
    0x1C91,0x10D1, 0x1C92,0x10D2, 0x1C93,0x10D3, 0x1C94,0x10D4,
    0x1C95,0x10D5, 0x1C96,0x10D6, 0x1C97,0x10D7, 0x1C98,0x10D8,
    0x1C99,0x10D9, 0x1C9A,0x10DA, 0x1C9B,0x10DB, 0x1C9C,0x10DC,
    0x1C9D,0x10DD, 0x1C9E,0x10DE, 0x1C9F,0x10DF, 0x1CA0,0x10E0,
    0x1CA1,0x10E1, 0x1CA2,0x10E2, 0x1CA3,0x10E3, 0x1CA4,0x10E4,
    0x1CA5,0x10E5, 0x1CA6,0x10E6, 0x1CA7,0x10E7, 0x1CA8,0x10E8,
    0x1CA9,0x10E9, 0x1CAA,0x10EA, 0x1CAB,0x10EB, 0x1CAC,0x10EC,
    0x1CAD,0x10ED, 0x1CAE,0x10EE, 0x1CAF,0x10EF, 0x1CB0,0x10F0,
    0x1CB1,0x10F1, 0x1CB2,0x10F2, 0x1CB3,0x10F3, 0x1CB4,0x10F4,
    0x1CB5,0x10F5, 0x1CB6,0x10F6, 0x1CB7,0x10F7, 0x1CB8,0x10F8,
    0x1CB9,0x10F9, 0x1CBA,0x10FA, 0x1CBD,0x10FD, 0x1CBE,0x10FE,
    0x1CBF,0x10FF, 0x1E00,0x1E01, 0x1E02,0x1E03, 0x1E04,0x1E05,
    0x1E06,0x1E07, 0x1E08,0x1E09, 0x1E0A,0x1E0B, 0x1E0C,0x1E0D,
    0x1E0E,0x1E0F, 0x1E10,0x1E11, 0x1E12,0x1E13, 0x1E14,0x1E15,
    0x1E16,0x1E17, 0x1E18,0x1E19, 0x1E1A,0x1E1B, 0x1E1C,0x1E1D,
    0x1E1E,0x1E1F, 0x1E20,0x1E21, 0x1E22,0x1E23, 0x1E24,0x1E25,
    0x1E26,0x1E27, 0x1E28,0x1E29, 0x1E2A,0x1E2B, 0x1E2C,0x1E2D,
    0x1E2E,0x1E2F, 0x1E30,0x1E31, 0x1E32,0x1E33, 0x1E34,0x1E35,
    0x1E36,0x1E37, 0x1E38,0x1E39, 0x1E3A,0x1E3B, 0x1E3C,0x1E3D,
    0x1E3E,0x1E3F, 0x1E40,0x1E41, 0x1E42,0x1E43, 0x1E44,0x1E45,
    0x1E46,0x1E47, 0x1E48,0x1E49, 0x1E4A,0x1E4B, 0x1E4C,0x1E4D,
    0x1E4E,0x1E4F, 0x1E50,0x1E51, 0x1E52,0x1E53, 0x1E54,0x1E55,
    0x1E56,0x1E57, 0x1E58,0x1E59, 0x1E5A,0x1E5B, 0x1E5C,0x1E5D,
    0x1E5E,0x1E5F, 0x1E60,0x1E61, 0x1E62,0x1E63, 0x1E64,0x1E65,
    0x1E66,0x1E67, 0x1E68,0x1E69, 0x1E6A,0x1E6B, 0x1E6C,0x1E6D,
    0x1E6E,0x1E6F, 0x1E70,0x1E71, 0x1E72,0x1E73, 0x1E74,0x1E75,
    0x1E76,0x1E77, 0x1E78,0x1E79, 0x1E7A,0x1E7B, 0x1E7C,0x1E7D,
    0x1E7E,0x1E7F, 0x1E80,0x1E81, 0x1E82,0x1E83, 0x1E84,0x1E85,
    0x1E86,0x1E87, 0x1E88,0x1E89, 0x1E8A,0x1E8B, 0x1E8C,0x1E8D,
    0x1E8E,0x1E8F, 0x1E90,0x1E91, 0x1E92,0x1E93, 0x1E94,0x1E95,
    0x1E9E,0x00DF, 0x1EA0,0x1EA1, 0x1EA2,0x1EA3, 0x1EA4,0x1EA5,
    0x1EA6,0x1EA7, 0x1EA8,0x1EA9, 0x1EAA,0x1EAB, 0x1EAC,0x1EAD,
    0x1EAE,0x1EAF, 0x1EB0,0x1EB1, 0x1EB2,0x1EB3, 0x1EB4,0x1EB5,
    0x1EB6,0x1EB7, 0x1EB8,0x1EB9, 0x1EBA,0x1EBB, 0x1EBC,0x1EBD,
    0x1EBE,0x1EBF, 0x1EC0,0x1EC1, 0x1EC2,0x1EC3, 0x1EC4,0x1EC5,
    0x1EC6,0x1EC7, 0x1EC8,0x1EC9, 0x1ECA,0x1ECB, 0x1ECC,0x1ECD,
    0x1ECE,0x1ECF, 0x1ED0,0x1ED1, 0x1ED2,0x1ED3, 0x1ED4,0x1ED5,
    0x1ED6,0x1ED7, 0x1ED8,0x1ED9, 0x1EDA,0x1EDB, 0x1EDC,0x1EDD,
    0x1EDE,0x1EDF, 0x1EE0,0x1EE1, 0x1EE2,0x1EE3, 0x1EE4,0x1EE5,
    0x1EE6,0x1EE7, 0x1EE8,0x1EE9, 0x1EEA,0x1EEB, 0x1EEC,0x1EED,
    0x1EEE,0x1EEF, 0x1EF0,0x1EF1, 0x1EF2,0x1EF3, 0x1EF4,0x1EF5,
    0x1EF6,0x1EF7, 0x1EF8,0x1EF9, 0x1EFA,0x1EFB, 0x1EFC,0x1EFD,
    0x1EFE,0x1EFF, 0x1F08,0x1F00, 0x1F09,0x1F01, 0x1F0A,0x1F02,
    0x1F0B,0x1F03, 0x1F0C,0x1F04, 0x1F0D,0x1F05, 0x1F0E,0x1F06,
    0x1F0F,0x1F07, 0x1F18,0x1F10, 0x1F19,0x1F11, 0x1F1A,0x1F12,
    0x1F1B,0x1F13, 0x1F1C,0x1F14, 0x1F1D,0x1F15, 0x1F28,0x1F20,
    0x1F29,0x1F21, 0x1F2A,0x1F22, 0x1F2B,0x1F23, 0x1F2C,0x1F24,
    0x1F2D,0x1F25, 0x1F2E,0x1F26, 0x1F2F,0x1F27, 0x1F38,0x1F30,
    0x1F39,0x1F31, 0x1F3A,0x1F32, 0x1F3B,0x1F33, 0x1F3C,0x1F34,
    0x1F3D,0x1F35, 0x1F3E,0x1F36, 0x1F3F,0x1F37, 0x1F48,0x1F40,
    0x1F49,0x1F41, 0x1F4A,0x1F42, 0x1F4B,0x1F43, 0x1F4C,0x1F44,
    0x1F4D,0x1F45, 0x1F59,0x1F51, 0x1F5B,0x1F53, 0x1F5D,0x1F55,
    0x1F5F,0x1F57, 0x1F68,0x1F60, 0x1F69,0x1F61, 0x1F6A,0x1F62,
    0x1F6B,0x1F63, 0x1F6C,0x1F64, 0x1F6D,0x1F65, 0x1F6E,0x1F66,
    0x1F6F,0x1F67, 0x1F88,0x1F80, 0x1F89,0x1F81, 0x1F8A,0x1F82,
    0x1F8B,0x1F83, 0x1F8C,0x1F84, 0x1F8D,0x1F85, 0x1F8E,0x1F86,
    0x1F8F,0x1F87, 0x1F98,0x1F90, 0x1F99,0x1F91, 0x1F9A,0x1F92,
    0x1F9B,0x1F93, 0x1F9C,0x1F94, 0x1F9D,0x1F95, 0x1F9E,0x1F96,
    0x1F9F,0x1F97, 0x1FA8,0x1FA0, 0x1FA9,0x1FA1, 0x1FAA,0x1FA2,
    0x1FAB,0x1FA3, 0x1FAC,0x1FA4, 0x1FAD,0x1FA5, 0x1FAE,0x1FA6,
    0x1FAF,0x1FA7, 0x1FB8,0x1FB0, 0x1FB9,0x1FB1, 0x1FBA,0x1F70,
    0x1FBB,0x1F71, 0x1FBC,0x1FB3, 0x1FC8,0x1F72, 0x1FC9,0x1F73,
    0x1FCA,0x1F74, 0x1FCB,0x1F75, 0x1FCC,0x1FC3, 0x1FD8,0x1FD0,
    0x1FD9,0x1FD1, 0x1FDA,0x1F76, 0x1FDB,0x1F77, 0x1FE8,0x1FE0,
    0x1FE9,0x1FE1, 0x1FEA,0x1F7A, 0x1FEB,0x1F7B, 0x1FEC,0x1FE5,
    0x1FF8,0x1F78, 0x1FF9,0x1F79, 0x1FFA,0x1F7C, 0x1FFB,0x1F7D,
    0x1FFC,0x1FF3, 0x2126,0x03C9, 0x212A,0x006B, 0x212B,0x00E5,
    0x2132,0x214E, 0x2160,0x2170, 0x2161,0x2171, 0x2162,0x2172,
    0x2163,0x2173, 0x2164,0x2174, 0x2165,0x2175, 0x2166,0x2176,
    0x2167,0x2177, 0x2168,0x2178, 0x2169,0x2179, 0x216A,0x217A,
    0x216B,0x217B, 0x216C,0x217C, 0x216D,0x217D, 0x216E,0x217E,
    0x216F,0x217F, 0x2183,0x2184, 0x24B6,0x24D0, 0x24B7,0x24D1,
    0x24B8,0x24D2, 0x24B9,0x24D3, 0x24BA,0x24D4, 0x24BB,0x24D5,
    0x24BC,0x24D6, 0x24BD,0x24D7, 0x24BE,0x24D8, 0x24BF,0x24D9,
    0x24C0,0x24DA, 0x24C1,0x24DB, 0x24C2,0x24DC, 0x24C3,0x24DD,
    0x24C4,0x24DE, 0x24C5,0x24DF, 0x24C6,0x24E0, 0x24C7,0x24E1,
    0x24C8,0x24E2, 0x24C9,0x24E3, 0x24CA,0x24E4, 0x24CB,0x24E5,
    0x24CC,0x24E6, 0x24CD,0x24E7, 0x24CE,0x24E8, 0x24CF,0x24E9,
    0x2C00,0x2C30, 0x2C01,0x2C31, 0x2C02,0x2C32, 0x2C03,0x2C33,
    0x2C04,0x2C34, 0x2C05,0x2C35, 0x2C06,0x2C36, 0x2C07,0x2C37,
    0x2C08,0x2C38, 0x2C09,0x2C39, 0x2C0A,0x2C3A, 0x2C0B,0x2C3B,
    0x2C0C,0x2C3C, 0x2C0D,0x2C3D, 0x2C0E,0x2C3E, 0x2C0F,0x2C3F,
    0x2C10,0x2C40, 0x2C11,0x2C41, 0x2C12,0x2C42, 0x2C13,0x2C43,
    0x2C14,0x2C44, 0x2C15,0x2C45, 0x2C16,0x2C46, 0x2C17,0x2C47,
    0x2C18,0x2C48, 0x2C19,0x2C49, 0x2C1A,0x2C4A, 0x2C1B,0x2C4B,
    0x2C1C,0x2C4C, 0x2C1D,0x2C4D, 0x2C1E,0x2C4E, 0x2C1F,0x2C4F,
    0x2C20,0x2C50, 0x2C21,0x2C51, 0x2C22,0x2C52, 0x2C23,0x2C53,
    0x2C24,0x2C54, 0x2C25,0x2C55, 0x2C26,0x2C56, 0x2C27,0x2C57,
    0x2C28,0x2C58, 0x2C29,0x2C59, 0x2C2A,0x2C5A, 0x2C2B,0x2C5B,
    0x2C2C,0x2C5C, 0x2C2D,0x2C5D, 0x2C2E,0x2C5E, 0x2C2F,0x2C5F,
    0x2C60,0x2C61, 0x2C62,0x026B, 0x2C63,0x1D7D, 0x2C64,0x027D,
    0x2C67,0x2C68, 0x2C69,0x2C6A, 0x2C6B,0x2C6C, 0x2C6D,0x0251,
    0x2C6E,0x0271, 0x2C6F,0x0250, 0x2C70,0x0252, 0x2C72,0x2C73,
    0x2C75,0x2C76, 0x2C7E,0x023F, 0x2C7F,0x0240, 0x2C80,0x2C81,
    0x2C82,0x2C83, 0x2C84,0x2C85, 0x2C86,0x2C87, 0x2C88,0x2C89,
    0x2C8A,0x2C8B, 0x2C8C,0x2C8D, 0x2C8E,0x2C8F, 0x2C90,0x2C91,
    0x2C92,0x2C93, 0x2C94,0x2C95, 0x2C96,0x2C97, 0x2C98,0x2C99,
    0x2C9A,0x2C9B, 0x2C9C,0x2C9D, 0x2C9E,0x2C9F, 0x2CA0,0x2CA1,
    0x2CA2,0x2CA3, 0x2CA4,0x2CA5, 0x2CA6,0x2CA7, 0x2CA8,0x2CA9,
    0x2CAA,0x2CAB, 0x2CAC,0x2CAD, 0x2CAE,0x2CAF, 0x2CB0,0x2CB1,
    0x2CB2,0x2CB3, 0x2CB4,0x2CB5, 0x2CB6,0x2CB7, 0x2CB8,0x2CB9,
    0x2CBA,0x2CBB, 0x2CBC,0x2CBD, 0x2CBE,0x2CBF, 0x2CC0,0x2CC1,
    0x2CC2,0x2CC3, 0x2CC4,0x2CC5, 0x2CC6,0x2CC7, 0x2CC8,0x2CC9,
    0x2CCA,0x2CCB, 0x2CCC,0x2CCD, 0x2CCE,0x2CCF, 0x2CD0,0x2CD1,
    0x2CD2,0x2CD3, 0x2CD4,0x2CD5, 0x2CD6,0x2CD7, 0x2CD8,0x2CD9,
    0x2CDA,0x2CDB, 0x2CDC,0x2CDD, 0x2CDE,0x2CDF, 0x2CE0,0x2CE1,
    0x2CE2,0x2CE3, 0x2CEB,0x2CEC, 0x2CED,0x2CEE, 0x2CF2,0x2CF3,
    0xA640,0xA641, 0xA642,0xA643, 0xA644,0xA645, 0xA646,0xA647,
    0xA648,0xA649, 0xA64A,0xA64B, 0xA64C,0xA64D, 0xA64E,0xA64F,
    0xA650,0xA651, 0xA652,0xA653, 0xA654,0xA655, 0xA656,0xA657,
    0xA658,0xA659, 0xA65A,0xA65B, 0xA65C,0xA65D, 0xA65E,0xA65F,
    0xA660,0xA661, 0xA662,0xA663, 0xA664,0xA665, 0xA666,0xA667,
    0xA668,0xA669, 0xA66A,0xA66B, 0xA66C,0xA66D, 0xA680,0xA681,
    0xA682,0xA683, 0xA684,0xA685, 0xA686,0xA687, 0xA688,0xA689,
    0xA68A,0xA68B, 0xA68C,0xA68D, 0xA68E,0xA68F, 0xA690,0xA691,
    0xA692,0xA693, 0xA694,0xA695, 0xA696,0xA697, 0xA698,0xA699,
    0xA69A,0xA69B, 0xA722,0xA723, 0xA724,0xA725, 0xA726,0xA727,
    0xA728,0xA729, 0xA72A,0xA72B, 0xA72C,0xA72D, 0xA72E,0xA72F,
    0xA732,0xA733, 0xA734,0xA735, 0xA736,0xA737, 0xA738,0xA739,
    0xA73A,0xA73B, 0xA73C,0xA73D, 0xA73E,0xA73F, 0xA740,0xA741,
    0xA742,0xA743, 0xA744,0xA745, 0xA746,0xA747, 0xA748,0xA749,
    0xA74A,0xA74B, 0xA74C,0xA74D, 0xA74E,0xA74F, 0xA750,0xA751,
    0xA752,0xA753, 0xA754,0xA755, 0xA756,0xA757, 0xA758,0xA759,
    0xA75A,0xA75B, 0xA75C,0xA75D, 0xA75E,0xA75F, 0xA760,0xA761,
    0xA762,0xA763, 0xA764,0xA765, 0xA766,0xA767, 0xA768,0xA769,
    0xA76A,0xA76B, 0xA76C,0xA76D, 0xA76E,0xA76F, 0xA779,0xA77A,
    0xA77B,0xA77C, 0xA77D,0x1D79, 0xA77E,0xA77F, 0xA780,0xA781,
    0xA782,0xA783, 0xA784,0xA785, 0xA786,0xA787, 0xA78B,0xA78C,
    0xA78D,0x0265, 0xA790,0xA791, 0xA792,0xA793, 0xA796,0xA797,
    0xA798,0xA799, 0xA79A,0xA79B, 0xA79C,0xA79D, 0xA79E,0xA79F,
    0xA7A0,0xA7A1, 0xA7A2,0xA7A3, 0xA7A4,0xA7A5, 0xA7A6,0xA7A7,
    0xA7A8,0xA7A9, 0xA7AA,0x0266, 0xA7AB,0x025C, 0xA7AC,0x0261,
    0xA7AD,0x026C, 0xA7AE,0x026A, 0xA7B0,0x029E, 0xA7B1,0x0287,
    0xA7B2,0x029D, 0xA7B3,0xAB53, 0xA7B4,0xA7B5, 0xA7B6,0xA7B7,
    0xA7B8,0xA7B9, 0xA7BA,0xA7BB, 0xA7BC,0xA7BD, 0xA7BE,0xA7BF,
    0xA7C0,0xA7C1, 0xA7C2,0xA7C3, 0xA7C4,0xA794, 0xA7C5,0x0282,
    0xA7C6,0x1D8E, 0xA7C7,0xA7C8, 0xA7C9,0xA7CA, 0xA7CB,0x0264,
    0xA7CC,0xA7CD, 0xA7D0,0xA7D1, 0xA7D6,0xA7D7, 0xA7D8,0xA7D9,
    0xA7DA,0xA7DB, 0xA7DC,0x019B, 0xA7F5,0xA7F6, 0xFF21,0xFF41,
    0xFF22,0xFF42, 0xFF23,0xFF43, 0xFF24,0xFF44, 0xFF25,0xFF45,
    0xFF26,0xFF46, 0xFF27,0xFF47, 0xFF28,0xFF48, 0xFF29,0xFF49,
    0xFF2A,0xFF4A, 0xFF2B,0xFF4B, 0xFF2C,0xFF4C, 0xFF2D,0xFF4D,
    0xFF2E,0xFF4E, 0xFF2F,0xFF4F, 0xFF30,0xFF50, 0xFF31,0xFF51,
    0xFF32,0xFF52, 0xFF33,0xFF53, 0xFF34,0xFF54, 0xFF35,0xFF55,
    0xFF36,0xFF56, 0xFF37,0xFF57, 0xFF38,0xFF58, 0xFF39,0xFF59,
    0xFF3A,0xFF5A, 0x10400,0x10428, 0x10401,0x10429, 0x10402,0x1042A,
    0x10403,0x1042B, 0x10404,0x1042C, 0x10405,0x1042D, 0x10406,0x1042E,
    0x10407,0x1042F, 0x10408,0x10430, 0x10409,0x10431, 0x1040A,0x10432,
    0x1040B,0x10433, 0x1040C,0x10434, 0x1040D,0x10435, 0x1040E,0x10436,
    0x1040F,0x10437, 0x10410,0x10438, 0x10411,0x10439, 0x10412,0x1043A,
    0x10413,0x1043B, 0x10414,0x1043C, 0x10415,0x1043D, 0x10416,0x1043E,
    0x10417,0x1043F, 0x10418,0x10440, 0x10419,0x10441, 0x1041A,0x10442,
    0x1041B,0x10443, 0x1041C,0x10444, 0x1041D,0x10445, 0x1041E,0x10446,
    0x1041F,0x10447, 0x10420,0x10448, 0x10421,0x10449, 0x10422,0x1044A,
    0x10423,0x1044B, 0x10424,0x1044C, 0x10425,0x1044D, 0x10426,0x1044E,
    0x10427,0x1044F, 0x104B0,0x104D8, 0x104B1,0x104D9, 0x104B2,0x104DA,
    0x104B3,0x104DB, 0x104B4,0x104DC, 0x104B5,0x104DD, 0x104B6,0x104DE,
    0x104B7,0x104DF, 0x104B8,0x104E0, 0x104B9,0x104E1, 0x104BA,0x104E2,
    0x104BB,0x104E3, 0x104BC,0x104E4, 0x104BD,0x104E5, 0x104BE,0x104E6,
    0x104BF,0x104E7, 0x104C0,0x104E8, 0x104C1,0x104E9, 0x104C2,0x104EA,
    0x104C3,0x104EB, 0x104C4,0x104EC, 0x104C5,0x104ED, 0x104C6,0x104EE,
    0x104C7,0x104EF, 0x104C8,0x104F0, 0x104C9,0x104F1, 0x104CA,0x104F2,
    0x104CB,0x104F3, 0x104CC,0x104F4, 0x104CD,0x104F5, 0x104CE,0x104F6,
    0x104CF,0x104F7, 0x104D0,0x104F8, 0x104D1,0x104F9, 0x104D2,0x104FA,
    0x104D3,0x104FB, 0x10570,0x10597, 0x10571,0x10598, 0x10572,0x10599,
    0x10573,0x1059A, 0x10574,0x1059B, 0x10575,0x1059C, 0x10576,0x1059D,
    0x10577,0x1059E, 0x10578,0x1059F, 0x10579,0x105A0, 0x1057A,0x105A1,
    0x1057C,0x105A3, 0x1057D,0x105A4, 0x1057E,0x105A5, 0x1057F,0x105A6,
    0x10580,0x105A7, 0x10581,0x105A8, 0x10582,0x105A9, 0x10583,0x105AA,
    0x10584,0x105AB, 0x10585,0x105AC, 0x10586,0x105AD, 0x10587,0x105AE,
    0x10588,0x105AF, 0x10589,0x105B0, 0x1058A,0x105B1, 0x1058C,0x105B3,
    0x1058D,0x105B4, 0x1058E,0x105B5, 0x1058F,0x105B6, 0x10590,0x105B7,
    0x10591,0x105B8, 0x10592,0x105B9, 0x10594,0x105BB, 0x10595,0x105BC,
    0x10C80,0x10CC0, 0x10C81,0x10CC1, 0x10C82,0x10CC2, 0x10C83,0x10CC3,
    0x10C84,0x10CC4, 0x10C85,0x10CC5, 0x10C86,0x10CC6, 0x10C87,0x10CC7,
    0x10C88,0x10CC8, 0x10C89,0x10CC9, 0x10C8A,0x10CCA, 0x10C8B,0x10CCB,
    0x10C8C,0x10CCC, 0x10C8D,0x10CCD, 0x10C8E,0x10CCE, 0x10C8F,0x10CCF,
    0x10C90,0x10CD0, 0x10C91,0x10CD1, 0x10C92,0x10CD2, 0x10C93,0x10CD3,
    0x10C94,0x10CD4, 0x10C95,0x10CD5, 0x10C96,0x10CD6, 0x10C97,0x10CD7,
    0x10C98,0x10CD8, 0x10C99,0x10CD9, 0x10C9A,0x10CDA, 0x10C9B,0x10CDB,
    0x10C9C,0x10CDC, 0x10C9D,0x10CDD, 0x10C9E,0x10CDE, 0x10C9F,0x10CDF,
    0x10CA0,0x10CE0, 0x10CA1,0x10CE1, 0x10CA2,0x10CE2, 0x10CA3,0x10CE3,
    0x10CA4,0x10CE4, 0x10CA5,0x10CE5, 0x10CA6,0x10CE6, 0x10CA7,0x10CE7,
    0x10CA8,0x10CE8, 0x10CA9,0x10CE9, 0x10CAA,0x10CEA, 0x10CAB,0x10CEB,
    0x10CAC,0x10CEC, 0x10CAD,0x10CED, 0x10CAE,0x10CEE, 0x10CAF,0x10CEF,
    0x10CB0,0x10CF0, 0x10CB1,0x10CF1, 0x10CB2,0x10CF2, 0x10D50,0x10D70,
    0x10D51,0x10D71, 0x10D52,0x10D72, 0x10D53,0x10D73, 0x10D54,0x10D74,
    0x10D55,0x10D75, 0x10D56,0x10D76, 0x10D57,0x10D77, 0x10D58,0x10D78,
    0x10D59,0x10D79, 0x10D5A,0x10D7A, 0x10D5B,0x10D7B, 0x10D5C,0x10D7C,
    0x10D5D,0x10D7D, 0x10D5E,0x10D7E, 0x10D5F,0x10D7F, 0x10D60,0x10D80,
    0x10D61,0x10D81, 0x10D62,0x10D82, 0x10D63,0x10D83, 0x10D64,0x10D84,
    0x10D65,0x10D85, 0x118A0,0x118C0, 0x118A1,0x118C1, 0x118A2,0x118C2,
    0x118A3,0x118C3, 0x118A4,0x118C4, 0x118A5,0x118C5, 0x118A6,0x118C6,
    0x118A7,0x118C7, 0x118A8,0x118C8, 0x118A9,0x118C9, 0x118AA,0x118CA,
    0x118AB,0x118CB, 0x118AC,0x118CC, 0x118AD,0x118CD, 0x118AE,0x118CE,
    0x118AF,0x118CF, 0x118B0,0x118D0, 0x118B1,0x118D1, 0x118B2,0x118D2,
    0x118B3,0x118D3, 0x118B4,0x118D4, 0x118B5,0x118D5, 0x118B6,0x118D6,
    0x118B7,0x118D7, 0x118B8,0x118D8, 0x118B9,0x118D9, 0x118BA,0x118DA,
    0x118BB,0x118DB, 0x118BC,0x118DC, 0x118BD,0x118DD, 0x118BE,0x118DE,
    0x118BF,0x118DF, 0x16E40,0x16E60, 0x16E41,0x16E61, 0x16E42,0x16E62,
    0x16E43,0x16E63, 0x16E44,0x16E64, 0x16E45,0x16E65, 0x16E46,0x16E66,
    0x16E47,0x16E67, 0x16E48,0x16E68, 0x16E49,0x16E69, 0x16E4A,0x16E6A,
    0x16E4B,0x16E6B, 0x16E4C,0x16E6C, 0x16E4D,0x16E6D, 0x16E4E,0x16E6E,
    0x16E4F,0x16E6F, 0x16E50,0x16E70, 0x16E51,0x16E71, 0x16E52,0x16E72,
    0x16E53,0x16E73, 0x16E54,0x16E74, 0x16E55,0x16E75, 0x16E56,0x16E76,
    0x16E57,0x16E77, 0x16E58,0x16E78, 0x16E59,0x16E79, 0x16E5A,0x16E7A,
    0x16E5B,0x16E7B, 0x16E5C,0x16E7C, 0x16E5D,0x16E7D, 0x16E5E,0x16E7E,
    0x16E5F,0x16E7F, 0x1E900,0x1E922, 0x1E901,0x1E923, 0x1E902,0x1E924,
    0x1E903,0x1E925, 0x1E904,0x1E926, 0x1E905,0x1E927, 0x1E906,0x1E928,
    0x1E907,0x1E929, 0x1E908,0x1E92A, 0x1E909,0x1E92B, 0x1E90A,0x1E92C,
    0x1E90B,0x1E92D, 0x1E90C,0x1E92E, 0x1E90D,0x1E92F, 0x1E90E,0x1E930,
    0x1E90F,0x1E931, 0x1E910,0x1E932, 0x1E911,0x1E933, 0x1E912,0x1E934,
    0x1E913,0x1E935, 0x1E914,0x1E936, 0x1E915,0x1E937, 0x1E916,0x1E938,
    0x1E917,0x1E939, 0x1E918,0x1E93A, 0x1E919,0x1E93B, 0x1E91A,0x1E93C,
    0x1E91B,0x1E93D, 0x1E91C,0x1E93E, 0x1E91D,0x1E93F, 0x1E91E,0x1E940,
    0x1E91F,0x1E941, 0x1E920,0x1E942, 0x1E921,0x1E943,
};
#define CASE_TO_LOWER_N 1459  /* pairs */

static const uint32_t CASE_TO_UPPER[] = {
    0x0061,0x0041, 0x0062,0x0042, 0x0063,0x0043, 0x0064,0x0044,
    0x0065,0x0045, 0x0066,0x0046, 0x0067,0x0047, 0x0068,0x0048,
    0x0069,0x0049, 0x006A,0x004A, 0x006B,0x004B, 0x006C,0x004C,
    0x006D,0x004D, 0x006E,0x004E, 0x006F,0x004F, 0x0070,0x0050,
    0x0071,0x0051, 0x0072,0x0052, 0x0073,0x0053, 0x0074,0x0054,
    0x0075,0x0055, 0x0076,0x0056, 0x0077,0x0057, 0x0078,0x0058,
    0x0079,0x0059, 0x007A,0x005A, 0x00B5,0x039C, 0x00E0,0x00C0,
    0x00E1,0x00C1, 0x00E2,0x00C2, 0x00E3,0x00C3, 0x00E4,0x00C4,
    0x00E5,0x00C5, 0x00E6,0x00C6, 0x00E7,0x00C7, 0x00E8,0x00C8,
    0x00E9,0x00C9, 0x00EA,0x00CA, 0x00EB,0x00CB, 0x00EC,0x00CC,
    0x00ED,0x00CD, 0x00EE,0x00CE, 0x00EF,0x00CF, 0x00F0,0x00D0,
    0x00F1,0x00D1, 0x00F2,0x00D2, 0x00F3,0x00D3, 0x00F4,0x00D4,
    0x00F5,0x00D5, 0x00F6,0x00D6, 0x00F8,0x00D8, 0x00F9,0x00D9,
    0x00FA,0x00DA, 0x00FB,0x00DB, 0x00FC,0x00DC, 0x00FD,0x00DD,
    0x00FE,0x00DE, 0x00FF,0x0178, 0x0101,0x0100, 0x0103,0x0102,
    0x0105,0x0104, 0x0107,0x0106, 0x0109,0x0108, 0x010B,0x010A,
    0x010D,0x010C, 0x010F,0x010E, 0x0111,0x0110, 0x0113,0x0112,
    0x0115,0x0114, 0x0117,0x0116, 0x0119,0x0118, 0x011B,0x011A,
    0x011D,0x011C, 0x011F,0x011E, 0x0121,0x0120, 0x0123,0x0122,
    0x0125,0x0124, 0x0127,0x0126, 0x0129,0x0128, 0x012B,0x012A,
    0x012D,0x012C, 0x012F,0x012E, 0x0131,0x0049, 0x0133,0x0132,
    0x0135,0x0134, 0x0137,0x0136, 0x013A,0x0139, 0x013C,0x013B,
    0x013E,0x013D, 0x0140,0x013F, 0x0142,0x0141, 0x0144,0x0143,
    0x0146,0x0145, 0x0148,0x0147, 0x014B,0x014A, 0x014D,0x014C,
    0x014F,0x014E, 0x0151,0x0150, 0x0153,0x0152, 0x0155,0x0154,
    0x0157,0x0156, 0x0159,0x0158, 0x015B,0x015A, 0x015D,0x015C,
    0x015F,0x015E, 0x0161,0x0160, 0x0163,0x0162, 0x0165,0x0164,
    0x0167,0x0166, 0x0169,0x0168, 0x016B,0x016A, 0x016D,0x016C,
    0x016F,0x016E, 0x0171,0x0170, 0x0173,0x0172, 0x0175,0x0174,
    0x0177,0x0176, 0x017A,0x0179, 0x017C,0x017B, 0x017E,0x017D,
    0x017F,0x0053, 0x0180,0x0243, 0x0183,0x0182, 0x0185,0x0184,
    0x0188,0x0187, 0x018C,0x018B, 0x0192,0x0191, 0x0195,0x01F6,
    0x0199,0x0198, 0x019A,0x023D, 0x019B,0xA7DC, 0x019E,0x0220,
    0x01A1,0x01A0, 0x01A3,0x01A2, 0x01A5,0x01A4, 0x01A8,0x01A7,
    0x01AD,0x01AC, 0x01B0,0x01AF, 0x01B4,0x01B3, 0x01B6,0x01B5,
    0x01B9,0x01B8, 0x01BD,0x01BC, 0x01BF,0x01F7, 0x01C5,0x01C4,
    0x01C6,0x01C4, 0x01C8,0x01C7, 0x01C9,0x01C7, 0x01CB,0x01CA,
    0x01CC,0x01CA, 0x01CE,0x01CD, 0x01D0,0x01CF, 0x01D2,0x01D1,
    0x01D4,0x01D3, 0x01D6,0x01D5, 0x01D8,0x01D7, 0x01DA,0x01D9,
    0x01DC,0x01DB, 0x01DD,0x018E, 0x01DF,0x01DE, 0x01E1,0x01E0,
    0x01E3,0x01E2, 0x01E5,0x01E4, 0x01E7,0x01E6, 0x01E9,0x01E8,
    0x01EB,0x01EA, 0x01ED,0x01EC, 0x01EF,0x01EE, 0x01F2,0x01F1,
    0x01F3,0x01F1, 0x01F5,0x01F4, 0x01F9,0x01F8, 0x01FB,0x01FA,
    0x01FD,0x01FC, 0x01FF,0x01FE, 0x0201,0x0200, 0x0203,0x0202,
    0x0205,0x0204, 0x0207,0x0206, 0x0209,0x0208, 0x020B,0x020A,
    0x020D,0x020C, 0x020F,0x020E, 0x0211,0x0210, 0x0213,0x0212,
    0x0215,0x0214, 0x0217,0x0216, 0x0219,0x0218, 0x021B,0x021A,
    0x021D,0x021C, 0x021F,0x021E, 0x0223,0x0222, 0x0225,0x0224,
    0x0227,0x0226, 0x0229,0x0228, 0x022B,0x022A, 0x022D,0x022C,
    0x022F,0x022E, 0x0231,0x0230, 0x0233,0x0232, 0x023C,0x023B,
    0x023F,0x2C7E, 0x0240,0x2C7F, 0x0242,0x0241, 0x0247,0x0246,
    0x0249,0x0248, 0x024B,0x024A, 0x024D,0x024C, 0x024F,0x024E,
    0x0250,0x2C6F, 0x0251,0x2C6D, 0x0252,0x2C70, 0x0253,0x0181,
    0x0254,0x0186, 0x0256,0x0189, 0x0257,0x018A, 0x0259,0x018F,
    0x025B,0x0190, 0x025C,0xA7AB, 0x0260,0x0193, 0x0261,0xA7AC,
    0x0263,0x0194, 0x0264,0xA7CB, 0x0265,0xA78D, 0x0266,0xA7AA,
    0x0268,0x0197, 0x0269,0x0196, 0x026A,0xA7AE, 0x026B,0x2C62,
    0x026C,0xA7AD, 0x026F,0x019C, 0x0271,0x2C6E, 0x0272,0x019D,
    0x0275,0x019F, 0x027D,0x2C64, 0x0280,0x01A6, 0x0282,0xA7C5,
    0x0283,0x01A9, 0x0287,0xA7B1, 0x0288,0x01AE, 0x0289,0x0244,
    0x028A,0x01B1, 0x028B,0x01B2, 0x028C,0x0245, 0x0292,0x01B7,
    0x029D,0xA7B2, 0x029E,0xA7B0, 0x0345,0x0399, 0x0371,0x0370,
    0x0373,0x0372, 0x0377,0x0376, 0x037B,0x03FD, 0x037C,0x03FE,
    0x037D,0x03FF, 0x03AC,0x0386, 0x03AD,0x0388, 0x03AE,0x0389,
    0x03AF,0x038A, 0x03B1,0x0391, 0x03B2,0x0392, 0x03B3,0x0393,
    0x03B4,0x0394, 0x03B5,0x0395, 0x03B6,0x0396, 0x03B7,0x0397,
    0x03B8,0x0398, 0x03B9,0x0399, 0x03BA,0x039A, 0x03BB,0x039B,
    0x03BC,0x039C, 0x03BD,0x039D, 0x03BE,0x039E, 0x03BF,0x039F,
    0x03C0,0x03A0, 0x03C1,0x03A1, 0x03C2,0x03A3, 0x03C3,0x03A3,
    0x03C4,0x03A4, 0x03C5,0x03A5, 0x03C6,0x03A6, 0x03C7,0x03A7,
    0x03C8,0x03A8, 0x03C9,0x03A9, 0x03CA,0x03AA, 0x03CB,0x03AB,
    0x03CC,0x038C, 0x03CD,0x038E, 0x03CE,0x038F, 0x03D0,0x0392,
    0x03D1,0x0398, 0x03D5,0x03A6, 0x03D6,0x03A0, 0x03D7,0x03CF,
    0x03D9,0x03D8, 0x03DB,0x03DA, 0x03DD,0x03DC, 0x03DF,0x03DE,
    0x03E1,0x03E0, 0x03E3,0x03E2, 0x03E5,0x03E4, 0x03E7,0x03E6,
    0x03E9,0x03E8, 0x03EB,0x03EA, 0x03ED,0x03EC, 0x03EF,0x03EE,
    0x03F0,0x039A, 0x03F1,0x03A1, 0x03F2,0x03F9, 0x03F3,0x037F,
    0x03F5,0x0395, 0x03F8,0x03F7, 0x03FB,0x03FA, 0x0430,0x0410,
    0x0431,0x0411, 0x0432,0x0412, 0x0433,0x0413, 0x0434,0x0414,
    0x0435,0x0415, 0x0436,0x0416, 0x0437,0x0417, 0x0438,0x0418,
    0x0439,0x0419, 0x043A,0x041A, 0x043B,0x041B, 0x043C,0x041C,
    0x043D,0x041D, 0x043E,0x041E, 0x043F,0x041F, 0x0440,0x0420,
    0x0441,0x0421, 0x0442,0x0422, 0x0443,0x0423, 0x0444,0x0424,
    0x0445,0x0425, 0x0446,0x0426, 0x0447,0x0427, 0x0448,0x0428,
    0x0449,0x0429, 0x044A,0x042A, 0x044B,0x042B, 0x044C,0x042C,
    0x044D,0x042D, 0x044E,0x042E, 0x044F,0x042F, 0x0450,0x0400,
    0x0451,0x0401, 0x0452,0x0402, 0x0453,0x0403, 0x0454,0x0404,
    0x0455,0x0405, 0x0456,0x0406, 0x0457,0x0407, 0x0458,0x0408,
    0x0459,0x0409, 0x045A,0x040A, 0x045B,0x040B, 0x045C,0x040C,
    0x045D,0x040D, 0x045E,0x040E, 0x045F,0x040F, 0x0461,0x0460,
    0x0463,0x0462, 0x0465,0x0464, 0x0467,0x0466, 0x0469,0x0468,
    0x046B,0x046A, 0x046D,0x046C, 0x046F,0x046E, 0x0471,0x0470,
    0x0473,0x0472, 0x0475,0x0474, 0x0477,0x0476, 0x0479,0x0478,
    0x047B,0x047A, 0x047D,0x047C, 0x047F,0x047E, 0x0481,0x0480,
    0x048B,0x048A, 0x048D,0x048C, 0x048F,0x048E, 0x0491,0x0490,
    0x0493,0x0492, 0x0495,0x0494, 0x0497,0x0496, 0x0499,0x0498,
    0x049B,0x049A, 0x049D,0x049C, 0x049F,0x049E, 0x04A1,0x04A0,
    0x04A3,0x04A2, 0x04A5,0x04A4, 0x04A7,0x04A6, 0x04A9,0x04A8,
    0x04AB,0x04AA, 0x04AD,0x04AC, 0x04AF,0x04AE, 0x04B1,0x04B0,
    0x04B3,0x04B2, 0x04B5,0x04B4, 0x04B7,0x04B6, 0x04B9,0x04B8,
    0x04BB,0x04BA, 0x04BD,0x04BC, 0x04BF,0x04BE, 0x04C2,0x04C1,
    0x04C4,0x04C3, 0x04C6,0x04C5, 0x04C8,0x04C7, 0x04CA,0x04C9,
    0x04CC,0x04CB, 0x04CE,0x04CD, 0x04CF,0x04C0, 0x04D1,0x04D0,
    0x04D3,0x04D2, 0x04D5,0x04D4, 0x04D7,0x04D6, 0x04D9,0x04D8,
    0x04DB,0x04DA, 0x04DD,0x04DC, 0x04DF,0x04DE, 0x04E1,0x04E0,
    0x04E3,0x04E2, 0x04E5,0x04E4, 0x04E7,0x04E6, 0x04E9,0x04E8,
    0x04EB,0x04EA, 0x04ED,0x04EC, 0x04EF,0x04EE, 0x04F1,0x04F0,
    0x04F3,0x04F2, 0x04F5,0x04F4, 0x04F7,0x04F6, 0x04F9,0x04F8,
    0x04FB,0x04FA, 0x04FD,0x04FC, 0x04FF,0x04FE, 0x0501,0x0500,
    0x0503,0x0502, 0x0505,0x0504, 0x0507,0x0506, 0x0509,0x0508,
    0x050B,0x050A, 0x050D,0x050C, 0x050F,0x050E, 0x0511,0x0510,
    0x0513,0x0512, 0x0515,0x0514, 0x0517,0x0516, 0x0519,0x0518,
    0x051B,0x051A, 0x051D,0x051C, 0x051F,0x051E, 0x0521,0x0520,
    0x0523,0x0522, 0x0525,0x0524, 0x0527,0x0526, 0x0529,0x0528,
    0x052B,0x052A, 0x052D,0x052C, 0x052F,0x052E, 0x0561,0x0531,
    0x0562,0x0532, 0x0563,0x0533, 0x0564,0x0534, 0x0565,0x0535,
    0x0566,0x0536, 0x0567,0x0537, 0x0568,0x0538, 0x0569,0x0539,
    0x056A,0x053A, 0x056B,0x053B, 0x056C,0x053C, 0x056D,0x053D,
    0x056E,0x053E, 0x056F,0x053F, 0x0570,0x0540, 0x0571,0x0541,
    0x0572,0x0542, 0x0573,0x0543, 0x0574,0x0544, 0x0575,0x0545,
    0x0576,0x0546, 0x0577,0x0547, 0x0578,0x0548, 0x0579,0x0549,
    0x057A,0x054A, 0x057B,0x054B, 0x057C,0x054C, 0x057D,0x054D,
    0x057E,0x054E, 0x057F,0x054F, 0x0580,0x0550, 0x0581,0x0551,
    0x0582,0x0552, 0x0583,0x0553, 0x0584,0x0554, 0x0585,0x0555,
    0x0586,0x0556, 0x10D0,0x1C90, 0x10D1,0x1C91, 0x10D2,0x1C92,
    0x10D3,0x1C93, 0x10D4,0x1C94, 0x10D5,0x1C95, 0x10D6,0x1C96,
    0x10D7,0x1C97, 0x10D8,0x1C98, 0x10D9,0x1C99, 0x10DA,0x1C9A,
    0x10DB,0x1C9B, 0x10DC,0x1C9C, 0x10DD,0x1C9D, 0x10DE,0x1C9E,
    0x10DF,0x1C9F, 0x10E0,0x1CA0, 0x10E1,0x1CA1, 0x10E2,0x1CA2,
    0x10E3,0x1CA3, 0x10E4,0x1CA4, 0x10E5,0x1CA5, 0x10E6,0x1CA6,
    0x10E7,0x1CA7, 0x10E8,0x1CA8, 0x10E9,0x1CA9, 0x10EA,0x1CAA,
    0x10EB,0x1CAB, 0x10EC,0x1CAC, 0x10ED,0x1CAD, 0x10EE,0x1CAE,
    0x10EF,0x1CAF, 0x10F0,0x1CB0, 0x10F1,0x1CB1, 0x10F2,0x1CB2,
    0x10F3,0x1CB3, 0x10F4,0x1CB4, 0x10F5,0x1CB5, 0x10F6,0x1CB6,
    0x10F7,0x1CB7, 0x10F8,0x1CB8, 0x10F9,0x1CB9, 0x10FA,0x1CBA,
    0x10FD,0x1CBD, 0x10FE,0x1CBE, 0x10FF,0x1CBF, 0x13F8,0x13F0,
    0x13F9,0x13F1, 0x13FA,0x13F2, 0x13FB,0x13F3, 0x13FC,0x13F4,
    0x13FD,0x13F5, 0x1C80,0x0412, 0x1C81,0x0414, 0x1C82,0x041E,
    0x1C83,0x0421, 0x1C84,0x0422, 0x1C85,0x0422, 0x1C86,0x042A,
    0x1C87,0x0462, 0x1C88,0xA64A, 0x1C8A,0x1C89, 0x1D79,0xA77D,
    0x1D7D,0x2C63, 0x1D8E,0xA7C6, 0x1E01,0x1E00, 0x1E03,0x1E02,
    0x1E05,0x1E04, 0x1E07,0x1E06, 0x1E09,0x1E08, 0x1E0B,0x1E0A,
    0x1E0D,0x1E0C, 0x1E0F,0x1E0E, 0x1E11,0x1E10, 0x1E13,0x1E12,
    0x1E15,0x1E14, 0x1E17,0x1E16, 0x1E19,0x1E18, 0x1E1B,0x1E1A,
    0x1E1D,0x1E1C, 0x1E1F,0x1E1E, 0x1E21,0x1E20, 0x1E23,0x1E22,
    0x1E25,0x1E24, 0x1E27,0x1E26, 0x1E29,0x1E28, 0x1E2B,0x1E2A,
    0x1E2D,0x1E2C, 0x1E2F,0x1E2E, 0x1E31,0x1E30, 0x1E33,0x1E32,
    0x1E35,0x1E34, 0x1E37,0x1E36, 0x1E39,0x1E38, 0x1E3B,0x1E3A,
    0x1E3D,0x1E3C, 0x1E3F,0x1E3E, 0x1E41,0x1E40, 0x1E43,0x1E42,
    0x1E45,0x1E44, 0x1E47,0x1E46, 0x1E49,0x1E48, 0x1E4B,0x1E4A,
    0x1E4D,0x1E4C, 0x1E4F,0x1E4E, 0x1E51,0x1E50, 0x1E53,0x1E52,
    0x1E55,0x1E54, 0x1E57,0x1E56, 0x1E59,0x1E58, 0x1E5B,0x1E5A,
    0x1E5D,0x1E5C, 0x1E5F,0x1E5E, 0x1E61,0x1E60, 0x1E63,0x1E62,
    0x1E65,0x1E64, 0x1E67,0x1E66, 0x1E69,0x1E68, 0x1E6B,0x1E6A,
    0x1E6D,0x1E6C, 0x1E6F,0x1E6E, 0x1E71,0x1E70, 0x1E73,0x1E72,
    0x1E75,0x1E74, 0x1E77,0x1E76, 0x1E79,0x1E78, 0x1E7B,0x1E7A,
    0x1E7D,0x1E7C, 0x1E7F,0x1E7E, 0x1E81,0x1E80, 0x1E83,0x1E82,
    0x1E85,0x1E84, 0x1E87,0x1E86, 0x1E89,0x1E88, 0x1E8B,0x1E8A,
    0x1E8D,0x1E8C, 0x1E8F,0x1E8E, 0x1E91,0x1E90, 0x1E93,0x1E92,
    0x1E95,0x1E94, 0x1E9B,0x1E60, 0x1EA1,0x1EA0, 0x1EA3,0x1EA2,
    0x1EA5,0x1EA4, 0x1EA7,0x1EA6, 0x1EA9,0x1EA8, 0x1EAB,0x1EAA,
    0x1EAD,0x1EAC, 0x1EAF,0x1EAE, 0x1EB1,0x1EB0, 0x1EB3,0x1EB2,
    0x1EB5,0x1EB4, 0x1EB7,0x1EB6, 0x1EB9,0x1EB8, 0x1EBB,0x1EBA,
    0x1EBD,0x1EBC, 0x1EBF,0x1EBE, 0x1EC1,0x1EC0, 0x1EC3,0x1EC2,
    0x1EC5,0x1EC4, 0x1EC7,0x1EC6, 0x1EC9,0x1EC8, 0x1ECB,0x1ECA,
    0x1ECD,0x1ECC, 0x1ECF,0x1ECE, 0x1ED1,0x1ED0, 0x1ED3,0x1ED2,
    0x1ED5,0x1ED4, 0x1ED7,0x1ED6, 0x1ED9,0x1ED8, 0x1EDB,0x1EDA,
    0x1EDD,0x1EDC, 0x1EDF,0x1EDE, 0x1EE1,0x1EE0, 0x1EE3,0x1EE2,
    0x1EE5,0x1EE4, 0x1EE7,0x1EE6, 0x1EE9,0x1EE8, 0x1EEB,0x1EEA,
    0x1EED,0x1EEC, 0x1EEF,0x1EEE, 0x1EF1,0x1EF0, 0x1EF3,0x1EF2,
    0x1EF5,0x1EF4, 0x1EF7,0x1EF6, 0x1EF9,0x1EF8, 0x1EFB,0x1EFA,
    0x1EFD,0x1EFC, 0x1EFF,0x1EFE, 0x1F00,0x1F08, 0x1F01,0x1F09,
    0x1F02,0x1F0A, 0x1F03,0x1F0B, 0x1F04,0x1F0C, 0x1F05,0x1F0D,
    0x1F06,0x1F0E, 0x1F07,0x1F0F, 0x1F10,0x1F18, 0x1F11,0x1F19,
    0x1F12,0x1F1A, 0x1F13,0x1F1B, 0x1F14,0x1F1C, 0x1F15,0x1F1D,
    0x1F20,0x1F28, 0x1F21,0x1F29, 0x1F22,0x1F2A, 0x1F23,0x1F2B,
    0x1F24,0x1F2C, 0x1F25,0x1F2D, 0x1F26,0x1F2E, 0x1F27,0x1F2F,
    0x1F30,0x1F38, 0x1F31,0x1F39, 0x1F32,0x1F3A, 0x1F33,0x1F3B,
    0x1F34,0x1F3C, 0x1F35,0x1F3D, 0x1F36,0x1F3E, 0x1F37,0x1F3F,
    0x1F40,0x1F48, 0x1F41,0x1F49, 0x1F42,0x1F4A, 0x1F43,0x1F4B,
    0x1F44,0x1F4C, 0x1F45,0x1F4D, 0x1F51,0x1F59, 0x1F53,0x1F5B,
    0x1F55,0x1F5D, 0x1F57,0x1F5F, 0x1F60,0x1F68, 0x1F61,0x1F69,
    0x1F62,0x1F6A, 0x1F63,0x1F6B, 0x1F64,0x1F6C, 0x1F65,0x1F6D,
    0x1F66,0x1F6E, 0x1F67,0x1F6F, 0x1F70,0x1FBA, 0x1F71,0x1FBB,
    0x1F72,0x1FC8, 0x1F73,0x1FC9, 0x1F74,0x1FCA, 0x1F75,0x1FCB,
    0x1F76,0x1FDA, 0x1F77,0x1FDB, 0x1F78,0x1FF8, 0x1F79,0x1FF9,
    0x1F7A,0x1FEA, 0x1F7B,0x1FEB, 0x1F7C,0x1FFA, 0x1F7D,0x1FFB,
    0x1FB0,0x1FB8, 0x1FB1,0x1FB9, 0x1FBE,0x0399, 0x1FD0,0x1FD8,
    0x1FD1,0x1FD9, 0x1FE0,0x1FE8, 0x1FE1,0x1FE9, 0x1FE5,0x1FEC,
    0x214E,0x2132, 0x2170,0x2160, 0x2171,0x2161, 0x2172,0x2162,
    0x2173,0x2163, 0x2174,0x2164, 0x2175,0x2165, 0x2176,0x2166,
    0x2177,0x2167, 0x2178,0x2168, 0x2179,0x2169, 0x217A,0x216A,
    0x217B,0x216B, 0x217C,0x216C, 0x217D,0x216D, 0x217E,0x216E,
    0x217F,0x216F, 0x2184,0x2183, 0x24D0,0x24B6, 0x24D1,0x24B7,
    0x24D2,0x24B8, 0x24D3,0x24B9, 0x24D4,0x24BA, 0x24D5,0x24BB,
    0x24D6,0x24BC, 0x24D7,0x24BD, 0x24D8,0x24BE, 0x24D9,0x24BF,
    0x24DA,0x24C0, 0x24DB,0x24C1, 0x24DC,0x24C2, 0x24DD,0x24C3,
    0x24DE,0x24C4, 0x24DF,0x24C5, 0x24E0,0x24C6, 0x24E1,0x24C7,
    0x24E2,0x24C8, 0x24E3,0x24C9, 0x24E4,0x24CA, 0x24E5,0x24CB,
    0x24E6,0x24CC, 0x24E7,0x24CD, 0x24E8,0x24CE, 0x24E9,0x24CF,
    0x2C30,0x2C00, 0x2C31,0x2C01, 0x2C32,0x2C02, 0x2C33,0x2C03,
    0x2C34,0x2C04, 0x2C35,0x2C05, 0x2C36,0x2C06, 0x2C37,0x2C07,
    0x2C38,0x2C08, 0x2C39,0x2C09, 0x2C3A,0x2C0A, 0x2C3B,0x2C0B,
    0x2C3C,0x2C0C, 0x2C3D,0x2C0D, 0x2C3E,0x2C0E, 0x2C3F,0x2C0F,
    0x2C40,0x2C10, 0x2C41,0x2C11, 0x2C42,0x2C12, 0x2C43,0x2C13,
    0x2C44,0x2C14, 0x2C45,0x2C15, 0x2C46,0x2C16, 0x2C47,0x2C17,
    0x2C48,0x2C18, 0x2C49,0x2C19, 0x2C4A,0x2C1A, 0x2C4B,0x2C1B,
    0x2C4C,0x2C1C, 0x2C4D,0x2C1D, 0x2C4E,0x2C1E, 0x2C4F,0x2C1F,
    0x2C50,0x2C20, 0x2C51,0x2C21, 0x2C52,0x2C22, 0x2C53,0x2C23,
    0x2C54,0x2C24, 0x2C55,0x2C25, 0x2C56,0x2C26, 0x2C57,0x2C27,
    0x2C58,0x2C28, 0x2C59,0x2C29, 0x2C5A,0x2C2A, 0x2C5B,0x2C2B,
    0x2C5C,0x2C2C, 0x2C5D,0x2C2D, 0x2C5E,0x2C2E, 0x2C5F,0x2C2F,
    0x2C61,0x2C60, 0x2C65,0x023A, 0x2C66,0x023E, 0x2C68,0x2C67,
    0x2C6A,0x2C69, 0x2C6C,0x2C6B, 0x2C73,0x2C72, 0x2C76,0x2C75,
    0x2C81,0x2C80, 0x2C83,0x2C82, 0x2C85,0x2C84, 0x2C87,0x2C86,
    0x2C89,0x2C88, 0x2C8B,0x2C8A, 0x2C8D,0x2C8C, 0x2C8F,0x2C8E,
    0x2C91,0x2C90, 0x2C93,0x2C92, 0x2C95,0x2C94, 0x2C97,0x2C96,
    0x2C99,0x2C98, 0x2C9B,0x2C9A, 0x2C9D,0x2C9C, 0x2C9F,0x2C9E,
    0x2CA1,0x2CA0, 0x2CA3,0x2CA2, 0x2CA5,0x2CA4, 0x2CA7,0x2CA6,
    0x2CA9,0x2CA8, 0x2CAB,0x2CAA, 0x2CAD,0x2CAC, 0x2CAF,0x2CAE,
    0x2CB1,0x2CB0, 0x2CB3,0x2CB2, 0x2CB5,0x2CB4, 0x2CB7,0x2CB6,
    0x2CB9,0x2CB8, 0x2CBB,0x2CBA, 0x2CBD,0x2CBC, 0x2CBF,0x2CBE,
    0x2CC1,0x2CC0, 0x2CC3,0x2CC2, 0x2CC5,0x2CC4, 0x2CC7,0x2CC6,
    0x2CC9,0x2CC8, 0x2CCB,0x2CCA, 0x2CCD,0x2CCC, 0x2CCF,0x2CCE,
    0x2CD1,0x2CD0, 0x2CD3,0x2CD2, 0x2CD5,0x2CD4, 0x2CD7,0x2CD6,
    0x2CD9,0x2CD8, 0x2CDB,0x2CDA, 0x2CDD,0x2CDC, 0x2CDF,0x2CDE,
    0x2CE1,0x2CE0, 0x2CE3,0x2CE2, 0x2CEC,0x2CEB, 0x2CEE,0x2CED,
    0x2CF3,0x2CF2, 0x2D00,0x10A0, 0x2D01,0x10A1, 0x2D02,0x10A2,
    0x2D03,0x10A3, 0x2D04,0x10A4, 0x2D05,0x10A5, 0x2D06,0x10A6,
    0x2D07,0x10A7, 0x2D08,0x10A8, 0x2D09,0x10A9, 0x2D0A,0x10AA,
    0x2D0B,0x10AB, 0x2D0C,0x10AC, 0x2D0D,0x10AD, 0x2D0E,0x10AE,
    0x2D0F,0x10AF, 0x2D10,0x10B0, 0x2D11,0x10B1, 0x2D12,0x10B2,
    0x2D13,0x10B3, 0x2D14,0x10B4, 0x2D15,0x10B5, 0x2D16,0x10B6,
    0x2D17,0x10B7, 0x2D18,0x10B8, 0x2D19,0x10B9, 0x2D1A,0x10BA,
    0x2D1B,0x10BB, 0x2D1C,0x10BC, 0x2D1D,0x10BD, 0x2D1E,0x10BE,
    0x2D1F,0x10BF, 0x2D20,0x10C0, 0x2D21,0x10C1, 0x2D22,0x10C2,
    0x2D23,0x10C3, 0x2D24,0x10C4, 0x2D25,0x10C5, 0x2D27,0x10C7,
    0x2D2D,0x10CD, 0xA641,0xA640, 0xA643,0xA642, 0xA645,0xA644,
    0xA647,0xA646, 0xA649,0xA648, 0xA64B,0xA64A, 0xA64D,0xA64C,
    0xA64F,0xA64E, 0xA651,0xA650, 0xA653,0xA652, 0xA655,0xA654,
    0xA657,0xA656, 0xA659,0xA658, 0xA65B,0xA65A, 0xA65D,0xA65C,
    0xA65F,0xA65E, 0xA661,0xA660, 0xA663,0xA662, 0xA665,0xA664,
    0xA667,0xA666, 0xA669,0xA668, 0xA66B,0xA66A, 0xA66D,0xA66C,
    0xA681,0xA680, 0xA683,0xA682, 0xA685,0xA684, 0xA687,0xA686,
    0xA689,0xA688, 0xA68B,0xA68A, 0xA68D,0xA68C, 0xA68F,0xA68E,
    0xA691,0xA690, 0xA693,0xA692, 0xA695,0xA694, 0xA697,0xA696,
    0xA699,0xA698, 0xA69B,0xA69A, 0xA723,0xA722, 0xA725,0xA724,
    0xA727,0xA726, 0xA729,0xA728, 0xA72B,0xA72A, 0xA72D,0xA72C,
    0xA72F,0xA72E, 0xA733,0xA732, 0xA735,0xA734, 0xA737,0xA736,
    0xA739,0xA738, 0xA73B,0xA73A, 0xA73D,0xA73C, 0xA73F,0xA73E,
    0xA741,0xA740, 0xA743,0xA742, 0xA745,0xA744, 0xA747,0xA746,
    0xA749,0xA748, 0xA74B,0xA74A, 0xA74D,0xA74C, 0xA74F,0xA74E,
    0xA751,0xA750, 0xA753,0xA752, 0xA755,0xA754, 0xA757,0xA756,
    0xA759,0xA758, 0xA75B,0xA75A, 0xA75D,0xA75C, 0xA75F,0xA75E,
    0xA761,0xA760, 0xA763,0xA762, 0xA765,0xA764, 0xA767,0xA766,
    0xA769,0xA768, 0xA76B,0xA76A, 0xA76D,0xA76C, 0xA76F,0xA76E,
    0xA77A,0xA779, 0xA77C,0xA77B, 0xA77F,0xA77E, 0xA781,0xA780,
    0xA783,0xA782, 0xA785,0xA784, 0xA787,0xA786, 0xA78C,0xA78B,
    0xA791,0xA790, 0xA793,0xA792, 0xA794,0xA7C4, 0xA797,0xA796,
    0xA799,0xA798, 0xA79B,0xA79A, 0xA79D,0xA79C, 0xA79F,0xA79E,
    0xA7A1,0xA7A0, 0xA7A3,0xA7A2, 0xA7A5,0xA7A4, 0xA7A7,0xA7A6,
    0xA7A9,0xA7A8, 0xA7B5,0xA7B4, 0xA7B7,0xA7B6, 0xA7B9,0xA7B8,
    0xA7BB,0xA7BA, 0xA7BD,0xA7BC, 0xA7BF,0xA7BE, 0xA7C1,0xA7C0,
    0xA7C3,0xA7C2, 0xA7C8,0xA7C7, 0xA7CA,0xA7C9, 0xA7CD,0xA7CC,
    0xA7D1,0xA7D0, 0xA7D7,0xA7D6, 0xA7D9,0xA7D8, 0xA7DB,0xA7DA,
    0xA7F6,0xA7F5, 0xAB53,0xA7B3, 0xAB70,0x13A0, 0xAB71,0x13A1,
    0xAB72,0x13A2, 0xAB73,0x13A3, 0xAB74,0x13A4, 0xAB75,0x13A5,
    0xAB76,0x13A6, 0xAB77,0x13A7, 0xAB78,0x13A8, 0xAB79,0x13A9,
    0xAB7A,0x13AA, 0xAB7B,0x13AB, 0xAB7C,0x13AC, 0xAB7D,0x13AD,
    0xAB7E,0x13AE, 0xAB7F,0x13AF, 0xAB80,0x13B0, 0xAB81,0x13B1,
    0xAB82,0x13B2, 0xAB83,0x13B3, 0xAB84,0x13B4, 0xAB85,0x13B5,
    0xAB86,0x13B6, 0xAB87,0x13B7, 0xAB88,0x13B8, 0xAB89,0x13B9,
    0xAB8A,0x13BA, 0xAB8B,0x13BB, 0xAB8C,0x13BC, 0xAB8D,0x13BD,
    0xAB8E,0x13BE, 0xAB8F,0x13BF, 0xAB90,0x13C0, 0xAB91,0x13C1,
    0xAB92,0x13C2, 0xAB93,0x13C3, 0xAB94,0x13C4, 0xAB95,0x13C5,
    0xAB96,0x13C6, 0xAB97,0x13C7, 0xAB98,0x13C8, 0xAB99,0x13C9,
    0xAB9A,0x13CA, 0xAB9B,0x13CB, 0xAB9C,0x13CC, 0xAB9D,0x13CD,
    0xAB9E,0x13CE, 0xAB9F,0x13CF, 0xABA0,0x13D0, 0xABA1,0x13D1,
    0xABA2,0x13D2, 0xABA3,0x13D3, 0xABA4,0x13D4, 0xABA5,0x13D5,
    0xABA6,0x13D6, 0xABA7,0x13D7, 0xABA8,0x13D8, 0xABA9,0x13D9,
    0xABAA,0x13DA, 0xABAB,0x13DB, 0xABAC,0x13DC, 0xABAD,0x13DD,
    0xABAE,0x13DE, 0xABAF,0x13DF, 0xABB0,0x13E0, 0xABB1,0x13E1,
    0xABB2,0x13E2, 0xABB3,0x13E3, 0xABB4,0x13E4, 0xABB5,0x13E5,
    0xABB6,0x13E6, 0xABB7,0x13E7, 0xABB8,0x13E8, 0xABB9,0x13E9,
    0xABBA,0x13EA, 0xABBB,0x13EB, 0xABBC,0x13EC, 0xABBD,0x13ED,
    0xABBE,0x13EE, 0xABBF,0x13EF, 0xFF41,0xFF21, 0xFF42,0xFF22,
    0xFF43,0xFF23, 0xFF44,0xFF24, 0xFF45,0xFF25, 0xFF46,0xFF26,
    0xFF47,0xFF27, 0xFF48,0xFF28, 0xFF49,0xFF29, 0xFF4A,0xFF2A,
    0xFF4B,0xFF2B, 0xFF4C,0xFF2C, 0xFF4D,0xFF2D, 0xFF4E,0xFF2E,
    0xFF4F,0xFF2F, 0xFF50,0xFF30, 0xFF51,0xFF31, 0xFF52,0xFF32,
    0xFF53,0xFF33, 0xFF54,0xFF34, 0xFF55,0xFF35, 0xFF56,0xFF36,
    0xFF57,0xFF37, 0xFF58,0xFF38, 0xFF59,0xFF39, 0xFF5A,0xFF3A,
    0x10428,0x10400, 0x10429,0x10401, 0x1042A,0x10402, 0x1042B,0x10403,
    0x1042C,0x10404, 0x1042D,0x10405, 0x1042E,0x10406, 0x1042F,0x10407,
    0x10430,0x10408, 0x10431,0x10409, 0x10432,0x1040A, 0x10433,0x1040B,
    0x10434,0x1040C, 0x10435,0x1040D, 0x10436,0x1040E, 0x10437,0x1040F,
    0x10438,0x10410, 0x10439,0x10411, 0x1043A,0x10412, 0x1043B,0x10413,
    0x1043C,0x10414, 0x1043D,0x10415, 0x1043E,0x10416, 0x1043F,0x10417,
    0x10440,0x10418, 0x10441,0x10419, 0x10442,0x1041A, 0x10443,0x1041B,
    0x10444,0x1041C, 0x10445,0x1041D, 0x10446,0x1041E, 0x10447,0x1041F,
    0x10448,0x10420, 0x10449,0x10421, 0x1044A,0x10422, 0x1044B,0x10423,
    0x1044C,0x10424, 0x1044D,0x10425, 0x1044E,0x10426, 0x1044F,0x10427,
    0x104D8,0x104B0, 0x104D9,0x104B1, 0x104DA,0x104B2, 0x104DB,0x104B3,
    0x104DC,0x104B4, 0x104DD,0x104B5, 0x104DE,0x104B6, 0x104DF,0x104B7,
    0x104E0,0x104B8, 0x104E1,0x104B9, 0x104E2,0x104BA, 0x104E3,0x104BB,
    0x104E4,0x104BC, 0x104E5,0x104BD, 0x104E6,0x104BE, 0x104E7,0x104BF,
    0x104E8,0x104C0, 0x104E9,0x104C1, 0x104EA,0x104C2, 0x104EB,0x104C3,
    0x104EC,0x104C4, 0x104ED,0x104C5, 0x104EE,0x104C6, 0x104EF,0x104C7,
    0x104F0,0x104C8, 0x104F1,0x104C9, 0x104F2,0x104CA, 0x104F3,0x104CB,
    0x104F4,0x104CC, 0x104F5,0x104CD, 0x104F6,0x104CE, 0x104F7,0x104CF,
    0x104F8,0x104D0, 0x104F9,0x104D1, 0x104FA,0x104D2, 0x104FB,0x104D3,
    0x10597,0x10570, 0x10598,0x10571, 0x10599,0x10572, 0x1059A,0x10573,
    0x1059B,0x10574, 0x1059C,0x10575, 0x1059D,0x10576, 0x1059E,0x10577,
    0x1059F,0x10578, 0x105A0,0x10579, 0x105A1,0x1057A, 0x105A3,0x1057C,
    0x105A4,0x1057D, 0x105A5,0x1057E, 0x105A6,0x1057F, 0x105A7,0x10580,
    0x105A8,0x10581, 0x105A9,0x10582, 0x105AA,0x10583, 0x105AB,0x10584,
    0x105AC,0x10585, 0x105AD,0x10586, 0x105AE,0x10587, 0x105AF,0x10588,
    0x105B0,0x10589, 0x105B1,0x1058A, 0x105B3,0x1058C, 0x105B4,0x1058D,
    0x105B5,0x1058E, 0x105B6,0x1058F, 0x105B7,0x10590, 0x105B8,0x10591,
    0x105B9,0x10592, 0x105BB,0x10594, 0x105BC,0x10595, 0x10CC0,0x10C80,
    0x10CC1,0x10C81, 0x10CC2,0x10C82, 0x10CC3,0x10C83, 0x10CC4,0x10C84,
    0x10CC5,0x10C85, 0x10CC6,0x10C86, 0x10CC7,0x10C87, 0x10CC8,0x10C88,
    0x10CC9,0x10C89, 0x10CCA,0x10C8A, 0x10CCB,0x10C8B, 0x10CCC,0x10C8C,
    0x10CCD,0x10C8D, 0x10CCE,0x10C8E, 0x10CCF,0x10C8F, 0x10CD0,0x10C90,
    0x10CD1,0x10C91, 0x10CD2,0x10C92, 0x10CD3,0x10C93, 0x10CD4,0x10C94,
    0x10CD5,0x10C95, 0x10CD6,0x10C96, 0x10CD7,0x10C97, 0x10CD8,0x10C98,
    0x10CD9,0x10C99, 0x10CDA,0x10C9A, 0x10CDB,0x10C9B, 0x10CDC,0x10C9C,
    0x10CDD,0x10C9D, 0x10CDE,0x10C9E, 0x10CDF,0x10C9F, 0x10CE0,0x10CA0,
    0x10CE1,0x10CA1, 0x10CE2,0x10CA2, 0x10CE3,0x10CA3, 0x10CE4,0x10CA4,
    0x10CE5,0x10CA5, 0x10CE6,0x10CA6, 0x10CE7,0x10CA7, 0x10CE8,0x10CA8,
    0x10CE9,0x10CA9, 0x10CEA,0x10CAA, 0x10CEB,0x10CAB, 0x10CEC,0x10CAC,
    0x10CED,0x10CAD, 0x10CEE,0x10CAE, 0x10CEF,0x10CAF, 0x10CF0,0x10CB0,
    0x10CF1,0x10CB1, 0x10CF2,0x10CB2, 0x10D70,0x10D50, 0x10D71,0x10D51,
    0x10D72,0x10D52, 0x10D73,0x10D53, 0x10D74,0x10D54, 0x10D75,0x10D55,
    0x10D76,0x10D56, 0x10D77,0x10D57, 0x10D78,0x10D58, 0x10D79,0x10D59,
    0x10D7A,0x10D5A, 0x10D7B,0x10D5B, 0x10D7C,0x10D5C, 0x10D7D,0x10D5D,
    0x10D7E,0x10D5E, 0x10D7F,0x10D5F, 0x10D80,0x10D60, 0x10D81,0x10D61,
    0x10D82,0x10D62, 0x10D83,0x10D63, 0x10D84,0x10D64, 0x10D85,0x10D65,
    0x118C0,0x118A0, 0x118C1,0x118A1, 0x118C2,0x118A2, 0x118C3,0x118A3,
    0x118C4,0x118A4, 0x118C5,0x118A5, 0x118C6,0x118A6, 0x118C7,0x118A7,
    0x118C8,0x118A8, 0x118C9,0x118A9, 0x118CA,0x118AA, 0x118CB,0x118AB,
    0x118CC,0x118AC, 0x118CD,0x118AD, 0x118CE,0x118AE, 0x118CF,0x118AF,
    0x118D0,0x118B0, 0x118D1,0x118B1, 0x118D2,0x118B2, 0x118D3,0x118B3,
    0x118D4,0x118B4, 0x118D5,0x118B5, 0x118D6,0x118B6, 0x118D7,0x118B7,
    0x118D8,0x118B8, 0x118D9,0x118B9, 0x118DA,0x118BA, 0x118DB,0x118BB,
    0x118DC,0x118BC, 0x118DD,0x118BD, 0x118DE,0x118BE, 0x118DF,0x118BF,
    0x16E60,0x16E40, 0x16E61,0x16E41, 0x16E62,0x16E42, 0x16E63,0x16E43,
    0x16E64,0x16E44, 0x16E65,0x16E45, 0x16E66,0x16E46, 0x16E67,0x16E47,
    0x16E68,0x16E48, 0x16E69,0x16E49, 0x16E6A,0x16E4A, 0x16E6B,0x16E4B,
    0x16E6C,0x16E4C, 0x16E6D,0x16E4D, 0x16E6E,0x16E4E, 0x16E6F,0x16E4F,
    0x16E70,0x16E50, 0x16E71,0x16E51, 0x16E72,0x16E52, 0x16E73,0x16E53,
    0x16E74,0x16E54, 0x16E75,0x16E55, 0x16E76,0x16E56, 0x16E77,0x16E57,
    0x16E78,0x16E58, 0x16E79,0x16E59, 0x16E7A,0x16E5A, 0x16E7B,0x16E5B,
    0x16E7C,0x16E5C, 0x16E7D,0x16E5D, 0x16E7E,0x16E5E, 0x16E7F,0x16E5F,
    0x1E922,0x1E900, 0x1E923,0x1E901, 0x1E924,0x1E902, 0x1E925,0x1E903,
    0x1E926,0x1E904, 0x1E927,0x1E905, 0x1E928,0x1E906, 0x1E929,0x1E907,
    0x1E92A,0x1E908, 0x1E92B,0x1E909, 0x1E92C,0x1E90A, 0x1E92D,0x1E90B,
    0x1E92E,0x1E90C, 0x1E92F,0x1E90D, 0x1E930,0x1E90E, 0x1E931,0x1E90F,
    0x1E932,0x1E910, 0x1E933,0x1E911, 0x1E934,0x1E912, 0x1E935,0x1E913,
    0x1E936,0x1E914, 0x1E937,0x1E915, 0x1E938,0x1E916, 0x1E939,0x1E917,
    0x1E93A,0x1E918, 0x1E93B,0x1E919, 0x1E93C,0x1E91A, 0x1E93D,0x1E91B,
    0x1E93E,0x1E91C, 0x1E93F,0x1E91D, 0x1E940,0x1E91E, 0x1E941,0x1E91F,
    0x1E942,0x1E920, 0x1E943,0x1E921,
};
#define CASE_TO_UPPER_N 1450  /* pairs */

static const struct { uint32_t cp; const char* up; } SPECIAL_UPPER[] = {
    {0x00DF, "\x53""\x53"},
    {0x0149, "\xCA""\xBC""\x4E"},
    {0x01F0, "\x4A""\xCC""\x8C"},
    {0x0390, "\xCE""\x99""\xCC""\x88""\xCC""\x81"},
    {0x03B0, "\xCE""\xA5""\xCC""\x88""\xCC""\x81"},
    {0x1E96, "\x48""\xCC""\xB1"},
    {0x1E97, "\x54""\xCC""\x88"},
    {0x1E98, "\x57""\xCC""\x8A"},
    {0x1E99, "\x59""\xCC""\x8A"},
    {0x1E9A, "\x41""\xCA""\xBE"},
    {0x1F80, "\xE1""\xBC""\x88""\xCE""\x99"},
    {0x1F81, "\xE1""\xBC""\x89""\xCE""\x99"},
    {0x1F82, "\xE1""\xBC""\x8A""\xCE""\x99"},
    {0x1F83, "\xE1""\xBC""\x8B""\xCE""\x99"},
    {0x1F84, "\xE1""\xBC""\x8C""\xCE""\x99"},
    {0x1F85, "\xE1""\xBC""\x8D""\xCE""\x99"},
    {0x1F86, "\xE1""\xBC""\x8E""\xCE""\x99"},
    {0x1F87, "\xE1""\xBC""\x8F""\xCE""\x99"},
    {0x1F88, "\xE1""\xBC""\x88""\xCE""\x99"},
    {0x1F89, "\xE1""\xBC""\x89""\xCE""\x99"},
    {0x1F8A, "\xE1""\xBC""\x8A""\xCE""\x99"},
    {0x1F8B, "\xE1""\xBC""\x8B""\xCE""\x99"},
    {0x1F8C, "\xE1""\xBC""\x8C""\xCE""\x99"},
    {0x1F8D, "\xE1""\xBC""\x8D""\xCE""\x99"},
    {0x1F8E, "\xE1""\xBC""\x8E""\xCE""\x99"},
    {0x1F8F, "\xE1""\xBC""\x8F""\xCE""\x99"},
    {0x1F90, "\xE1""\xBE""\x98""\xCE""\x99"},
    {0x1F91, "\xE1""\xBE""\x99""\xCE""\x99"},
    {0x1F92, "\xE1""\xBE""\x9A""\xCE""\x99"},
    {0x1F93, "\xE1""\xBE""\x9B""\xCE""\x99"},
    {0x1F94, "\xE1""\xBE""\x9C""\xCE""\x99"},
    {0x1F95, "\xE1""\xBE""\x9D""\xCE""\x99"},
    {0x1F96, "\xE1""\xBE""\x9E""\xCE""\x99"},
    {0x1F97, "\xE1""\xBE""\x9F""\xCE""\x99"},
    {0x1F98, "\xE1""\xBE""\x98""\xCE""\x99"},
    {0x1F99, "\xE1""\xBE""\x99""\xCE""\x99"},
    {0x1F9A, "\xE1""\xBE""\x9A""\xCE""\x99"},
    {0x1F9B, "\xE1""\xBE""\x9B""\xCE""\x99"},
    {0x1F9C, "\xE1""\xBE""\x9C""\xCE""\x99"},
    {0x1F9D, "\xE1""\xBE""\x9D""\xCE""\x99"},
    {0x1F9E, "\xE1""\xBE""\x9E""\xCE""\x99"},
    {0x1F9F, "\xE1""\xBE""\x9F""\xCE""\x99"},
    {0x1FA0, "\xE1""\xBE""\xA8""\xCE""\x99"},
    {0x1FA1, "\xE1""\xBE""\xA9""\xCE""\x99"},
    {0x1FA2, "\xE1""\xBE""\xAA""\xCE""\x99"},
    {0x1FA3, "\xE1""\xBE""\xAB""\xCE""\x99"},
    {0x1FA4, "\xE1""\xBE""\xAC""\xCE""\x99"},
    {0x1FA5, "\xE1""\xBE""\xAD""\xCE""\x99"},
    {0x1FA6, "\xE1""\xBE""\xAE""\xCE""\x99"},
    {0x1FA7, "\xE1""\xBE""\xAF""\xCE""\x99"},
    {0x1FA8, "\xE1""\xBE""\xA8""\xCE""\x99"},
    {0x1FA9, "\xE1""\xBE""\xA9""\xCE""\x99"},
    {0x1FAA, "\xE1""\xBE""\xAA""\xCE""\x99"},
    {0x1FAB, "\xE1""\xBE""\xAB""\xCE""\x99"},
    {0x1FAC, "\xE1""\xBE""\xAC""\xCE""\x99"},
    {0x1FAD, "\xE1""\xBE""\xAD""\xCE""\x99"},
    {0x1FAE, "\xE1""\xBE""\xAE""\xCE""\x99"},
    {0x1FAF, "\xE1""\xBE""\xAF""\xCE""\x99"},
    {0x1FB2, "\xE1""\xBE""\xBA""\xCD""\x85"},
    {0x1FB3, "\xCE""\x91""\xCD""\x85"},
    {0x1FB4, "\xCE""\x86""\xCD""\x85"},
    {0x1FB6, "\xCE""\x91""\xCD""\x82"},
    {0x1FB7, "\xCE""\x91""\xCD""\x82""\xCD""\x85"},
    {0x1FBC, "\xCE""\x91""\xCE""\x99"},
    {0x1FC2, "\xE1""\xBF""\x8A""\xCD""\x85"},
    {0x1FC3, "\xCE""\x97""\xCD""\x85"},
    {0x1FC4, "\xCE""\x89""\xCD""\x85"},
    {0x1FC6, "\xCE""\x97""\xCD""\x82"},
    {0x1FC7, "\xCE""\x97""\xCD""\x82""\xCD""\x85"},
    {0x1FCC, "\xCE""\x97""\xCE""\x99"},
    {0x1FF2, "\xE1""\xBF""\xBA""\xCD""\x85"},
    {0x1FF3, "\xCE""\xA9""\xCD""\x85"},
    {0x1FF4, "\xCE""\x8F""\xCD""\x85"},
    {0x1FF6, "\xCE""\xA9""\xCD""\x82"},
    {0x1FF7, "\xCE""\xA9""\xCD""\x82""\xCD""\x85"},
    {0x1FFC, "\xCE""\xA9""\xCE""\x99"},
    {0xFB00, "\x46""\x46"},
    {0xFB01, "\x46""\x49"},
    {0xFB02, "\x46""\x4C"},
    {0xFB03, "\x46""\x46""\x49"},
    {0xFB04, "\x46""\x46""\x4C"},
    {0xFB05, "\x53""\x54"},
    {0xFB06, "\x53""\x54"},
};
#define SPECIAL_UPPER_N 83
// END CASE TABLES



/* Encode a codepoint as UTF-8; returns bytes written. */
static int utf8_encode(char* out, uint32_t cp) {
    if (cp < 0x80) {
        out[0] = (char)cp;
        return 1;
    }
    if (cp < 0x800) {
        out[0] = (char)(0xC0 | (cp >> 6));
        out[1] = (char)(0x80 | (cp & 0x3F));
        return 2;
    }
    if (cp < 0x10000) {
        out[0] = (char)(0xE0 | (cp >> 12));
        out[1] = (char)(0x80 | ((cp >> 6) & 0x3F));
        out[2] = (char)(0x80 | (cp & 0x3F));
        return 3;
    }
    out[0] = (char)(0xF0 | (cp >> 18));
    out[1] = (char)(0x80 | ((cp >> 12) & 0x3F));
    out[2] = (char)(0x80 | ((cp >> 6) & 0x3F));
    out[3] = (char)(0x80 | (cp & 0x3F));
    return 4;
}

/* Binary search a generated (from,to) pair table; 0 when absent. */
static uint32_t case_map_lookup(const uint32_t* tab, int n, uint32_t cp) {
    int lo = 0, hi = n - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        uint32_t from = tab[mid * 2];
        if (cp == from) return tab[mid * 2 + 1];
        if (cp < from) hi = mid - 1; else lo = mid + 1;
    }
    return 0;
}

uint32_t resid_case_simple(uint32_t cp, int to_lower) {
    if (to_lower) {
        uint32_t m = case_map_lookup(CASE_TO_LOWER, CASE_TO_LOWER_N, cp);
        if (m != 0) return m;
    } else {
        uint32_t m = case_map_lookup(CASE_TO_UPPER, CASE_TO_UPPER_N, cp);
        if (m != 0) return m;
    }
    /* Generated tables cover ASCII/Latin/Greek/Cyrillic and every other
       simple pair; anything absent is caseless. */
    return cp;
}

/* SpecialCasing uppercase expansion for cp, or NULL. */
static const char* special_upper_lookup(uint32_t cp) {
    int lo = 0, hi = SPECIAL_UPPER_N - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (cp == SPECIAL_UPPER[mid].cp) return SPECIAL_UPPER[mid].up;
        if (cp < SPECIAL_UPPER[mid].cp) hi = mid - 1; else lo = mid + 1;
    }
    return 0;
}

/* A codepoint is "cased" when it has a case mapping in either direction
   (SpecialCasing.txt's Cased property, approximated from the tables).
   ASCII letters are covered by the tables; digits/punct/space are not. */
static int resid_case_is_cased(uint32_t cp) {
    if (case_map_lookup(CASE_TO_LOWER, CASE_TO_LOWER_N, cp) != 0) return 1;
    if (case_map_lookup(CASE_TO_UPPER, CASE_TO_UPPER_N, cp) != 0) return 1;
    uint32_t up = case_map_lookup(CASE_TO_LOWER, CASE_TO_LOWER_N,
                                  case_map_lookup(CASE_TO_UPPER, CASE_TO_UPPER_N, cp));
    (void)up;
    return 0;
}

/* Case-ignorable: not itself cased but must be skipped when scanning for
   the preceding/following cased character (approximation: combining marks
   in the common ranges plus any non-cased, non-ASCII-letter char). */
static int resid_case_is_ignorable(uint32_t cp) {
    if (resid_case_is_cased(cp)) return 0;
    /* Combining marks (Mn/Mc/Me broad ranges): transparent. */
    if ((cp >= 0x0300 && cp <= 0x036F) || (cp >= 0x0483 && cp <= 0x0489) ||
        (cp >= 0x0591 && cp <= 0x05BD) || (cp >= 0x0610 && cp <= 0x061A) ||
        (cp >= 0x064B && cp <= 0x065F) || (cp >= 0x0E31 && cp <= 0x0E3A) ||
        (cp >= 0x200C && cp <= 0x200F) || (cp >= 0xFE00 && cp <= 0xFE0F))
        return 1;
    /* Everything else that is uncased is treated as a boundary instead of
       transparent — matches the common cases (digits, punctuation). */
    return 0;
}

char* str_to_lower(const char* s) {
    int64_t n = str_len(s);
    char* out = (char*)malloc((size_t)(n * 4 + 8));
    char* w = out;
    const unsigned char* p = (const unsigned char*)s;
    /* Final_Sigma context: walk a lookahead pointer past the current
       character to find the next cased char (skipping ignorables). */
    while (*p) {
        int len = utf8_seq_len(*p);
        uint32_t cp = utf8_decode(p, len);
        uint32_t mapped;
        if (cp == 0x03A3) { /* Σ */
            /* Preceded by cased? */
            const unsigned char* q = p;
            int prev_cased = 0, scanned = 0;
            while (q > (const unsigned char*)s && !scanned) {
                /* step back one UTF-8 char */
                const unsigned char* r = q - 1;
                int back = 1;
                if (*r & 0x80) {
                    while (r > (const unsigned char*)s && (*(r - 1) & 0xC0) == 0x80) { r--; back++; }
                    if (back < 4 && utf8_seq_len(*(q - back)) == back) { }
                }
                uint32_t pcp = utf8_decode(r, back);
                if (!resid_case_is_ignorable(pcp)) {
                    prev_cased = resid_case_is_cased(pcp);
                    scanned = 1;
                }
                q = r;
            }
            /* Followed by cased? */
            const unsigned char* nx = p + len;
            int next_cased = 0;
            scanned = 0;
            while (*nx && !scanned) {
                int nl = utf8_seq_len(*nx);
                uint32_t ncp = utf8_decode(nx, nl);
                if (!resid_case_is_ignorable(ncp)) {
                    next_cased = resid_case_is_cased(ncp);
                    scanned = 1;
                }
                nx += nl;
            }
            mapped = (prev_cased && !next_cased) ? 0x03C2 : 0x03C3;
        } else {
            mapped = resid_case_simple(cp, 1);
        }
        w += utf8_encode(w, mapped);
        p += len;
    }
    *w = '\0';
    return out;
}

char* str_to_upper(const char* s) {
    int64_t n = str_len(s);
    char* out = (char*)malloc((size_t)(n * 4 + 8));
    char* w = out;
    const unsigned char* p = (const unsigned char*)s;
    while (*p) {
        int len = utf8_seq_len(*p);
        uint32_t cp = utf8_decode(p, len);
        const char* sp = special_upper_lookup(cp);
        if (sp) {
            while (*sp) *w++ = *sp++;
        } else {
            uint32_t mapped = resid_case_simple(cp, 0);
            w += utf8_encode(w, mapped);
        }
        p += len;
    }
    *w = '\0';
    return out;
}

/* Concatenate `times` copies (`times <= 0` → empty string). */
char* str_repeat(const char* s, int64_t times) {
    if (times < 0) times = 0;
    size_t ls = strlen(s);
    char* p = (char*)malloc(ls * (size_t)times + 1);
    char* w = p;
    for (int64_t i = 0; i < times; i++) {
        memcpy(w, s, ls);
        w += ls;
    }
    *w = '\0';
    return p;
}

/* Replace all occurrences of `from` with `to` (empty `from` → unchanged). */
char* str_replace(const char* s, const char* from, const char* to) {
    size_t lf = strlen(from), lt = strlen(to);
    if (lf == 0) { size_t n = strlen(s); char* c = (char*)malloc(n + 1); memcpy(c, s, n + 1); return c; }
    /* count */
    int64_t hits = 0;
    const char* q = s;
    while ((q = strstr(q, from)) != NULL) { hits++; q += lf; }
    size_t ls = strlen(s);
    char* p = (char*)malloc(ls + (size_t)hits * (lt - lf) + 1);
    char* w = p;
    q = s;
    const char* hit;
    while ((hit = strstr(q, from)) != NULL) {
        memcpy(w, q, hit - q); w += hit - q;
        memcpy(w, to, lt); w += lt;
        q = hit + lf;
    }
    strcpy(w, q);
    return p;
}

static void* rt_list_from(const void** items, int64_t n, const char* type_str);

/* Build a boxed List(Str) from a C string array. */
static void* rt_str_list(const char** items, int64_t n) {
    return rt_list_from((const void**)items, n, "List(Str)");
}

/* Split `s` on `sep` into a boxed List(Str). Empty sep → [s]. */
void* str_split(const char* s, const char* sep) {
    size_t lsep = strlen(sep);
    if (lsep == 0) {
        const char* one[1] = { s };
        return rt_str_list(one, 1);
    }
    int64_t parts = 1;
    const char* q = s;
    while ((q = strstr(q, sep)) != NULL) { parts++; q += lsep; }
    char** parts_arr = (char**)malloc((size_t)parts * sizeof(char*));
    int64_t i = 0;
    q = s;
    const char* hit;
    while ((hit = strstr(q, sep)) != NULL) {
        int64_t len = hit - q;
        char* part = (char*)malloc(len + 1);
        memcpy(part, q, len);
        part[len] = '\0';
        parts_arr[i++] = part;
        q = hit + lsep;
    }
    parts_arr[i] = strdup(q);
    void* out = rt_str_list((const char**)parts_arr, parts);
    free(parts_arr);
    return out;
}

/* Join a boxed List(Str) with separator `sep`. */
char* str_join(void* list_box, const char* sep) {
    ResidVal* b = (ResidVal*)list_box;
    const char** items = (const char**)(b->slots ? b->slots : NULL);
    int64_t n = b->count;
    size_t lsep = strlen(sep), total = 0;
    for (int64_t i = 0; i < n; i++) total += strlen(items[i]);
    if (n > 0) total += lsep * (size_t)(n - 1);
    char* p = (char*)malloc(total + 1);
    char* w = p;
    for (int64_t i = 0; i < n; i++) {
        if (i > 0) { memcpy(w, sep, lsep); w += lsep; }
        size_t li = strlen(items[i]);
        memcpy(w, items[i], li); w += li;
    }
    *w = '\0';
    return p;
}

/* ─── Stdlib v1.3: list verbs ───
   Lists are ResidVal boxes: slots hold boxed scalars (resid_box_i64) for
   List(Int) and raw char* for List(Str). Verbs allocate fresh boxes. */

static void* rt_list_from(const void** items, int64_t n, const char* type_str) {
    ResidVal* out = (ResidVal*)malloc(sizeof(ResidVal));
    out->tag = 0;
    out->count = n;
    out->type = type_str;
    out->slots = n > 0 ? (void**)malloc((size_t)n * sizeof(void*)) : NULL;
    for (int64_t i = 0; i < n; i++) out->slots[i] = (void*)items[i];
    return out;
}

void* list_reverse_ints(void* box) {
    ResidVal* b = (ResidVal*)box;
    const void** items = (const void**)malloc((size_t)(b->count > 0 ? b->count : 1) * sizeof(void*));
    for (int64_t i = 0; i < b->count; i++) items[i] = b->slots[b->count - 1 - i];
    void* out = rt_list_from(items, b->count, b->type);
    free(items);
    return out;
}

void* list_reverse_strs(void* box) {
    return list_reverse_ints(box);
}

int8_t list_contains_int(void* box, int64_t v) {
    ResidVal* b = (ResidVal*)box;
    for (int64_t i = 0; i < b->count; i++)
        if (resid_unbox_i64(b->slots[i]) == v) return 1;
    return 0;
}

int8_t list_contains_str(void* box, const char* v) {
    ResidVal* b = (ResidVal*)box;
    for (int64_t i = 0; i < b->count; i++)
        if (strcmp((const char*)b->slots[i], v) == 0) return 1;
    return 0;
}

static int rt_cmp_i64(const void* a, const void* b) {
    int64_t x = *(const int64_t*)a, y = *(const int64_t*)b;
    return x < y ? -1 : x > y;
}

static int rt_cmp_boxed_i64(const void* a, const void* b) {
    int64_t x = resid_unbox_i64(*(void* const*)a);
    int64_t y = resid_unbox_i64(*(void* const*)b);
    return x < y ? -1 : x > y;
}

static int rt_cmp_str_slot(const void* a, const void* b) {
    return strcmp((const char*)*(void* const*)a, (const char*)*(void* const*)b);
}

void rt_stable_sort(void** items, int64_t n, int (*cmp)(const void*, const void*));

static void* rt_list_sorted_copy(void* box, int (*cmp)(const void*, const void*)) {    ResidVal* b = (ResidVal*)box;
    ResidVal* out = (ResidVal*)malloc(sizeof(ResidVal));
    out->tag = b->tag;
    out->count = b->count;
    out->type = b->type;
    out->slots = b->count > 0 ? (void**)malloc((size_t)b->count * sizeof(void*)) : NULL;
    for (int64_t i = 0; i < b->count; i++) out->slots[i] = b->slots[i];
    rt_stable_sort(out->slots, b->count, cmp);
    return out;
}

void* list_sort_ints(void* box) {
    return rt_list_sorted_copy(box, rt_cmp_boxed_i64);
}

void* list_sort_strs(void* box) {
    return rt_list_sorted_copy(box, rt_cmp_str_slot);
}

int64_t list_sum(void* box) {
    ResidVal* b = (ResidVal*)box;
    int64_t s = 0;
    for (int64_t i = 0; i < b->count; i++) s += resid_unbox_i64(b->slots[i]);
    return s;
}

/* ─── Stdlib v1.1: parsing + integer math ─── */

int8_t str_is_int(const char* s) {
    if (*s == '\0') return 0;
    const char* p = s;
    if (*p == '-' || *p == '+') p++;
    if (*p == '\0') return 0;
    while (*p) {
        if (*p < '0' || *p > '9') return 0;
        p++;
    }
    return 1;
}

int64_t str_parse_int(const char* s) {
    if (!str_is_int(s)) return 0;
    return (int64_t)strtoll(s, NULL, 10);
}

int64_t abs_i64(int64_t x) { return x < 0 ? -x : x; }
int64_t min_i64(int64_t a, int64_t b) { return a < b ? a : b; }
int64_t max_i64(int64_t a, int64_t b) { return a > b ? a : b; }

int64_t clamp_i64(int64_t x, int64_t lo, int64_t hi) {
    if (x < lo) return lo;
    if (x > hi) return hi;
    return x;
}

/* ─── Stdlib v1.2: float parsing + misc string helpers ─── */

int8_t str_is_float(const char* s) {
    if (*s == '\0') return 0;
    char* end = NULL;
    strtod(s, &end);
    while (*end == ' ' || *end == '\t') end++;
    return *end == '\0' && end != s;
}

double str_parse_float(const char* s) {
    if (!str_is_float(s)) return 0.0;
    return strtod(s, NULL);
}

int64_t str_count(const char* s, const char* needle) {
    size_t ln = strlen(needle);
    if (ln == 0) return 0;
    int64_t hits = 0;
    const char* q = s;
    while ((q = strstr(q, needle)) != NULL) { hits++; q += ln; }
    return hits;
}

char* str_reverse(const char* s) {
    int64_t n = str_len(s);
    const unsigned char* p = (const unsigned char*)s;
    int64_t* off = (int64_t*)malloc((n + 1) * sizeof(int64_t));
    int64_t i = 0;
    while (*p) {
        off[i++] = (int64_t)((const char*)p - s);
        p += utf8_seq_len(*p);
    }
    off[i] = (int64_t)strlen(s);
    char* out = (char*)malloc(off[n] + 1);
    int64_t w = 0;
    for (int64_t k = n - 1; k >= 0; k--) {
        int64_t len = off[k + 1] - off[k];
        memcpy(out + w, s + off[k], len);
        w += len;
    }
    out[w] = '\0';
    free(off);
    return out;
}

/* ─── Stdlib v1.4: List(Float) verbs (slots hold resid_box_f64 boxes) ─── */

void* list_reverse_floats(void* box) {
    return list_reverse_ints(box);
}

int8_t list_contains_float(void* box, double v) {
    ResidVal* b = (ResidVal*)box;
    for (int64_t i = 0; i < b->count; i++)
        if (resid_unbox_f64(b->slots[i]) == v) return 1;
    return 0;
}

static int rt_cmp_boxed_f64(const void* a, const void* b) {
    double x = resid_unbox_f64(*(void* const*)a);
    double y = resid_unbox_f64(*(void* const*)b);
    return x < y ? -1 : x > y;
}

void* list_sort_floats(void* box) {
    return rt_list_sorted_copy(box, rt_cmp_boxed_f64);
}

double list_sumf(void* box) {
    ResidVal* b = (ResidVal*)box;
    double s = 0.0;
    for (int64_t i = 0; i < b->count; i++) s += resid_unbox_f64(b->slots[i]);
    return s;
}

/* ─── Bootstrap-layout list verbs ───
   The bootstrap compilers build lists as { int64_t n; raw slots[n] } with
   unboxed elements (i64 / double / char*). These twins serve that layout;
   the Rust pipeline uses the ResidVal variants above. Names are prefixed
   bl_ so both conventions coexist. */

static void* bl_alloc(int64_t n) {
    int64_t* m = (int64_t*)malloc(8 + (size_t)n * 8);
    m[0] = n;
    return m;
}

void* bl_reverse_i64(void* box) {
    int64_t n = ((int64_t*)box)[0];
    int64_t* out = (int64_t*)bl_alloc(n);
    const int64_t* in = (const int64_t*)box + 1;
    for (int64_t i = 0; i < n; i++) out[1 + i] = in[n - 1 - i];
    return out;
}

void* bl_reverse_str(void* box) {
    int64_t n = ((int64_t*)box)[0];
    char** out = (char**)bl_alloc(n);
    const char** in = (const char**)((int64_t*)box + 1);
    for (int64_t i = 0; i < n; i++) out[1 + i] = (char*)in[n - 1 - i];
    return out;
}

void* bl_reverse_f64(void* box) {
    int64_t n = ((int64_t*)box)[0];
    double* out = (double*)bl_alloc(n);
    const double* in = (const double*)((int64_t*)box + 1);
    for (int64_t i = 0; i < n; i++) out[1 + i] = in[n - 1 - i];
    return out;
}

int8_t bl_contains_i64(void* box, int64_t v) {
    int64_t n = ((int64_t*)box)[0];
    const int64_t* a = (const int64_t*)box + 1;
    for (int64_t i = 0; i < n; i++)
        if (a[i] == v) return 1;
    return 0;
}

int8_t bl_contains_str(void* box, const char* v) {
    int64_t n = ((int64_t*)box)[0];
    const char** a = (const char**)((int64_t*)box + 1);
    for (int64_t i = 0; i < n; i++)
        if (strcmp(a[i], v) == 0) return 1;
    return 0;
}

int8_t bl_contains_f64(void* box, double v) {
    int64_t n = ((int64_t*)box)[0];
    const double* a = (const double*)((int64_t*)box + 1);
    for (int64_t i = 0; i < n; i++)
        if (a[i] == v) return 1;
    return 0;
}

static int bl_cmp_i64(const void* a, const void* b) {
    int64_t x = *(const int64_t*)a, y = *(const int64_t*)b;
    return x < y ? -1 : x > y;
}

static int bl_cmp_str(const void* a, const void* b) {
    return strcmp(*(const char* const*)a, *(const char* const*)b);
}

static int bl_cmp_f64(const void* a, const void* b) {
    double x = *(const double*)a, y = *(const double*)b;
    return x < y ? -1 : x > y;
}

static void* bl_sorted_copy(void* box, size_t nbytes, int (*cmp)(const void*, const void*)) {
    int64_t n = ((int64_t*)box)[0];
    int64_t* out = (int64_t*)malloc(8 + (size_t)n * 8);
    memcpy(out, box, 8 + (size_t)n * 8);
    rt_stable_sort((void**)(out + 1), n, cmp);
    return out;
}

/* Stable bottom-up mergesort over an array of n pointers. O(n log n),
 * stable: equal keys keep their original relative order. One scratch
 * buffer, no recursion. This is the single sort primitive for both
 * pipelines (boxed slots and flat buffers alike). */
void rt_stable_sort(void** items, int64_t n, int (*cmp)(const void*, const void*)) {
    if (n < 2) return;
    void** scratch = (void**)malloc((size_t)n * sizeof(void*));
    void** src = items;
    void** tmp = scratch;
    for (int64_t width = 1; width < n; width *= 2) {
        for (int64_t lo = 0; lo < n; lo += 2 * width) {
            int64_t mid = lo + width < n ? lo + width : n;
            int64_t hi = lo + 2 * width < n ? lo + 2 * width : n;
            int64_t i = lo, j = mid, k = lo;
            while (i < mid && j < hi) {
                /* <= keeps the left run first: stability. */
                if (cmp(&src[i], &src[j]) <= 0) tmp[k++] = src[i++];
                else tmp[k++] = src[j++];
            }
            while (i < mid) tmp[k++] = src[i++];
            while (j < hi) tmp[k++] = src[j++];
        }
        void** swap = src; src = tmp; tmp = swap;
    }
    if (src != items) memcpy(items, src, (size_t)n * sizeof(void*));
    free(scratch);
}

void* list_sort_by(void* box, int (*cmp)(const void*, const void*)) {
    ResidVal* b = (ResidVal*)box;
    ResidVal* out = rt_list_sorted_copy(box, cmp);
    (void)b;
    return out;
}

void* bl_sort_i64(void* box) { return bl_sorted_copy(box, 8, bl_cmp_i64); }
void* bl_sort_str(void* box) { return bl_sorted_copy(box, 8, bl_cmp_str); }
void* bl_sort_f64(void* box) { return bl_sorted_copy(box, 8, bl_cmp_f64); }

/* Behavior-dispatched stable sort over a flat [len:i64][elem×8] buffer
 * (stage-2 ABI). Elements are compared via cmp(&a, &b); a fresh sorted
 * copy is returned. */
void* bl_sort_by(void* box, int (*cmp)(const void*, const void*)) {
    return bl_sorted_copy(box, 8, cmp);
}

int64_t bl_sum(void* box) {
    int64_t n = ((int64_t*)box)[0];
    const int64_t* a = (const int64_t*)box + 1;
    int64_t s = 0;
    for (int64_t i = 0; i < n; i++) s += a[i];
    return s;
}

double bl_sumf(void* box) {
    int64_t n = ((int64_t*)box)[0];
    const double* a = (const double*)((int64_t*)box + 1);
    double s = 0.0;
    for (int64_t i = 0; i < n; i++) s += a[i];
    return s;
}

/* Split into a bootstrap-layout List(Str). */
void* bl_str_split(const char* s, const char* sep) {
    size_t lsep = strlen(sep);
    if (lsep == 0) {
        char** box = (char**)bl_alloc(1);
        box[1] = (char*)s;
        return box;
    }
    int64_t parts = 1;
    const char* q = s;
    while ((q = strstr(q, sep)) != NULL) { parts++; q += lsep; }
    char** box = (char**)bl_alloc(parts);
    int64_t i = 0;
    q = s;
    const char* hit;
    while ((hit = strstr(q, sep)) != NULL) {
        int64_t len = hit - q;
        char* part = (char*)malloc(len + 1);
        memcpy(part, q, len);
        part[len] = '\0';
        box[1 + i++] = part;
        q = hit + lsep;
    }
    box[1 + i] = strdup(q);
    return box;
}

/* Join a bootstrap-layout List(Str) with separator `sep`. */
char* bl_str_join(void* box, const char* sep) {
    int64_t n = ((int64_t*)box)[0];
    const char** items = (const char**)((int64_t*)box + 1);
    size_t lsep = strlen(sep), total = 0;
    for (int64_t i = 0; i < n; i++) total += strlen(items[i]);
    if (n > 0) total += lsep * (size_t)(n - 1);
    char* p = (char*)malloc(total + 1);
    char* w = p;
    for (int64_t i = 0; i < n; i++) {
        if (i > 0) { memcpy(w, sep, lsep); w += lsep; }
        size_t li = strlen(items[i]);
        memcpy(w, items[i], li); w += li;
    }
    *w = '\0';
    return p;
}


/* ─── Stdlib v1.6: OS entropy hook ───
   The only crypto piece allowed in C: entropy must come from the operating
   system. One byte per call; everything else is assembled in Resid. */
int64_t resid_crypto_random_byte(void) {
    unsigned char b = 0;
    if (getrandom(&b, 1, 0) != 1) {
        /* fallback: /dev/urandom */
        FILE* f = fopen("/dev/urandom", "rb");
        if (!f) resid_abort("crypto_random_byte: no entropy source");
        if (fread(&b, 1, 1, f) != 1) resid_abort("crypto_random_byte: read failed");
        fclose(f);
    }
    return (int64_t)b;
}

/* Bounds-check failure helper with diagnostics. */
_Noreturn void resid_index_abort(int64_t idx, int64_t len) {
    char buf[128];
    snprintf(buf, sizeof(buf), "list index out of bounds: index %lld, length %lld",
             (long long)idx, (long long)len);
    resid_abort(buf);
}

/* ─── TCP transport (spec §32 provider-adjacent externs) ─────────
   Minimal blocking sockets so the Resid-level HTTP stack (lib/http.res)
   can do all protocol work: URL parsing, request building, response
   parsing stay in pure Resid. recv reads until the peer closes (our
   client always sends `Connection: close`) or a 4 MB cap. */

int64_t resid_tcp_connect(const char* host, int64_t port) {
    struct addrinfo hints, *res = NULL;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    char portstr[16];
    snprintf(portstr, sizeof(portstr), "%lld", (long long)port);
    if (getaddrinfo(host, portstr, &hints, &res) != 0 || !res) return -1;
    int fd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (fd < 0) { freeaddrinfo(res); return -1; }
    if (connect(fd, res->ai_addr, res->ai_addrlen) != 0) {
        freeaddrinfo(res);
        close(fd);
        return -1;
    }
    freeaddrinfo(res);
    return (int64_t)fd;
}

int8_t resid_tcp_send(int64_t fd, const char* data) {
    size_t len = strlen(data);
    const char* p = data;
    while (len > 0) {
        ssize_t n = send((int)fd, p, len, MSG_NOSIGNAL);
        if (n <= 0) return 0;
        p += n;
        len -= (size_t)n;
    }
    return 1;
}

char* resid_tcp_recv_all(int64_t fd) {
    size_t cap = 65536, len = 0;
    char* out = (char*)malloc(cap);
    for (;;) {
        if (len + 4096 > cap) {
            if (cap >= 4u * 1024 * 1024) break; /* 4 MB cap */
            cap *= 2;
            char* nb = (char*)realloc(out, cap);
            if (!nb) break;
            out = nb;
        }
        ssize_t n = recv((int)fd, out + len, cap - len - 1, 0);
        if (n <= 0) break;
        len += (size_t)n;
    }
    out[len] = '\0';
    return out;
}

int8_t resid_tcp_close(int64_t fd) {
    return close((int)fd) == 0 ? 1 : 0;
}

/* ─── Binary-safe TCP (TLS transport) ─────────────────────────────
 * List(Int) ABI: i64 count at offset 0, i64 elements after. send_bin
 * writes count bytes (values truncated to u8); recv_bin reads exactly
 * `n` bytes into a fresh list and stores the byte count as its length
 * (0 on error/EOF). */

int8_t resid_tcp_send_bin(int64_t fd, void* lst) {
    /* seeded-list convention: slot 0 is the dummy seed, real bytes are
     * slots 1..count-1 (raw i64 values truncated to u8) */
    ResidVal* rv = (ResidVal*)lst;
    int64_t n = rv->count - 1;
    if (n <= 0) return 1;
    char* buf = (char*)malloc((size_t)n);
    if (!buf) return 0;
    for (int64_t i = 0; i < n; i++) {
        /* scalar slots are boxed: slot -> ResidVal -> slots[0] -> i64 */
        ResidVal* bx = (ResidVal*)rv->slots[1 + i];
        buf[i] = (char)(*(int64_t*)bx->slots[0] & 0xFF);
    }
    const char* p2 = buf;
    size_t left = (size_t)n;
    while (left > 0) {
        ssize_t w = send((int)fd, p2, left, MSG_NOSIGNAL);
        if (w <= 0) { free(buf); return 0; }
        p2 += w; left -= (size_t)w;
    }
    free(buf);
    return 1;
}

/* receive exactly n bytes into a fresh seeded List(Int): slot 0 = seed,
 * slots 1..n = bytes; count = n+1. On EOF/error fewer slots may be
 * filled (remaining stay 0) and count still reports n+1. */
void* resid_tcp_recv_bin(int64_t fd, int64_t n) {
    if (n < 0) n = 0;
    char* buf = (char*)malloc((size_t)(n > 0 ? n : 1));
    ResidVal* out = (ResidVal*)malloc(sizeof(ResidVal));
    out->tag = 0;
    out->count = n + 1;
    out->slots = (void**)malloc(sizeof(void*) * (size_t)(n + 1));
    out->type = "List";
    out->slots[0] = resid_box_i64(0);
    int64_t got = 0;
    while (got < n) {
        ssize_t r = recv((int)fd, buf + got, (size_t)(n - got), 0);
        if (r <= 0) break;
        got += r;
    }
    for (int64_t i = 0; i < n; i++) {
        char bv = (i < got) ? buf[i] : 0;
        out->slots[1 + i] = resid_box_i64((int64_t)(unsigned char)bv);
    }
    free(buf);
    return out;
}

/* UTC wall clock as a civil timestamp YYYYMMDDHHMMSS (i64), for x509
   validity checks. Uses gmtime_r so it is locale/timezone independent. */
int64_t resid_utc_now_civil(void) {
    time_t t = time(NULL);
    struct tm tmv;
    gmtime_r(&t, &tmv);
    return (int64_t)(tmv.tm_year + 1900) * 10000000000LL
         + (int64_t)(tmv.tm_mon + 1) * 100000000LL
         + (int64_t)tmv.tm_mday * 1000000LL
         + (int64_t)tmv.tm_hour * 10000LL
         + (int64_t)tmv.tm_min * 100LL
         + (int64_t)tmv.tm_sec;
}

/* Checked integer add/sub overflow trap (spec v3.2 §6.1). */
_Noreturn void resid_arith_overflow(void) {
    fprintf(stderr, "resid: arithmetic overflow\n");
    void* bt[32];
    int n = backtrace(bt, 32);
    backtrace_symbols_fd(bt, n, 2);
    abort();
}

/* ─── Immutable Map / Set (spec §32 core types) ────────────────────
 *
 * Maps and sets are immutable values backed by a persistent hash table
 * (separate chaining). Every mutation (insert/remove) allocates a new
 * table — no COW, no refcounting. Simple and correct.
 *
 * Keys are opaque pointers (compared by address for integers and
 * compared as NUL-terminated C strings for Str). All Resid values
 * passed as keys are string-ified via resid_val_str for hashing and
 * comparison — this works because integers are boxed and pointer-
 * comparable strings are interned.
 */

#define MAP_INIT_CAP 16

typedef struct {
    void* key;
    void* val;   /* NULL for set entries */
    int used;
} MapEntry;

typedef struct {
    MapEntry* buckets;
    int64_t cap;
    int64_t size;
} ResidMap;

/* FNV-1a hash for a string. */
static uint64_t fnv1a(const char* s) {
    uint64_t h = 14695981039346656037ULL;
    for (const unsigned char* p = (const unsigned char*)s; *p; p++) {
        h ^= *p;
        h *= 1099511628211ULL;
    }
    return h;
}

/* Hash a Resid value for use as a map/set key. Strings hash by content;
 * other values (integers, booleans) are formatted to a string first. */
static uint64_t resid_hash(void* v) {
    /* Tagged ResidVal: extract the value. */
    int64_t tag = resid_box_tag(v);
    if (tag == -1) {
        /* Scalar box — the first slot holds the raw value. */
        void* raw = resid_box_slot(v, 0);
        /* Try to interpret as string pointer first. */
        if ((uintptr_t)raw > 4096) {
            /* Looks like a pointer — treat as string. */
            return fnv1a((const char*)raw);
        }
        /* Integer scalar: hash the integer value. */
        char buf[32];
        snprintf(buf, sizeof(buf), "%ld", (long)(intptr_t)raw);
        return fnv1a(buf);
    }
    /* Untagged pointer: treat as C string. */
    if ((uintptr_t)v > 4096) {
        return fnv1a((const char*)v);
    }
    return fnv1a("?");
}

/* Compare two Resid values for key equality. Returns 1 if equal. */
static int resid_key_eq(void* a, void* b) {
    if (a == b) return 1;
    int64_t ta = resid_box_tag(a);
    int64_t tb = resid_box_tag(b);
    if (ta == -1 && tb == -1) {
        void* ra = resid_box_slot(a, 0);
        void* rb = resid_box_slot(b, 0);
        if (ra == rb) return 1;
        /* Both could be strings. */
        if ((uintptr_t)ra > 4096 && (uintptr_t)rb > 4096) {
            return strcmp((const char*)ra, (const char*)rb) == 0;
        }
        return 0;
    }
    /* Untagged pointers: compare as strings. */
    if ((uintptr_t)a > 4096 && (uintptr_t)b > 4096) {
        return strcmp((const char*)a, (const char*)b) == 0;
    }
    return 0;
}

static ResidMap* map_new(int64_t cap) {
    ResidMap* m = (ResidMap*)malloc(sizeof(ResidMap));
    m->cap = cap > 0 ? cap : MAP_INIT_CAP;
    m->size = 0;
    /* Each bucket holds 4 slots (open addressing within a bucket). */
    m->buckets = (MapEntry*)calloc((size_t)m->cap * 4, sizeof(MapEntry));
    return m;
}

/* Find entry in bucket; returns index or -1. */
static int map_bucket_find(MapEntry* b, int64_t bcap, void* key) {
    for (int64_t i = 0; i < bcap; i++) {
        if (b[i].used && resid_key_eq(b[i].key, key)) return (int)i;
    }
    return -1;
}

/* Lookup a key in the map. Returns the value or NULL. */
void* resid_map_get(void* map, void* key) {
    ResidMap* m = (ResidMap*)map;
    uint64_t h = resid_hash(key);
    int64_t idx = (int64_t)(h % (uint64_t)m->cap);
    MapEntry* b = &m->buckets[idx * 4];
    /* Each bucket has 4 slots (open addressing within bucket). */
    int64_t bcap = 4;
    int pos = map_bucket_find(b, bcap, key);
    if (pos < 0) return NULL;
    return b[pos].val;
}

/* Insert a key-value pair, returning a NEW map (immutable). */
void* resid_map_insert(void* map, void* key, void* val) {
    ResidMap* old = (ResidMap*)map;
    /* Check if key exists. */
    uint64_t h = resid_hash(key);
    int64_t idx = (int64_t)(h % (uint64_t)old->cap);
    MapEntry* ob = &old->buckets[idx * 4];
    int64_t bcap = 4;
    int exist = map_bucket_find(ob, bcap, key);

    int64_t new_cap = old->cap;
    int64_t new_size = old->size;
    if (exist < 0) new_size++;  /* new key */

    /* Grow if >75% full. */
    if (new_size * 4 > new_cap * 3) new_cap = old->cap * 2;

    ResidMap* nm = map_new(new_cap);
    nm->size = new_size;

    /* Rehash all old entries. */
    for (int64_t i = 0; i < old->cap; i++) {
        MapEntry* b = &old->buckets[i * 4];
        for (int j = 0; j < bcap; j++) {
            if (!b[j].used) continue;
            /* Skip the key we're replacing. */
            if (exist >= 0 && i == idx && j == exist) continue;
            uint64_t nh = resid_hash(b[j].key);
            int64_t nidx = (int64_t)(nh % (uint64_t)nm->cap);
            MapEntry* nb = &nm->buckets[nidx * 4];
            for (int k = 0; k < bcap; k++) {
                if (!nb[k].used) {
                    nb[k].key = b[j].key;
                    nb[k].val = b[j].val;
                    nb[k].used = 1;
                    break;
                }
            }
        }
    }

    /* Insert new entry. */
    {
        uint64_t nh2 = resid_hash(key);
        int64_t nidx2 = (int64_t)(nh2 % (uint64_t)nm->cap);
        MapEntry* nb2 = &nm->buckets[nidx2 * 4];
        if (exist >= 0) {
            /* Replace existing. */
            for (int k = 0; k < bcap; k++) {
                if (nb2[k].used && resid_key_eq(nb2[k].key, key)) {
                    nb2[k].val = val;
                    break;
                }
            }
        } else {
            /* New entry. */
            for (int k = 0; k < bcap; k++) {
                if (!nb2[k].used) {
                    nb2[k].key = key;
                    nb2[k].val = val;
                    nb2[k].used = 1;
                    break;
                }
            }
        }
    }

    return nm;
}

/* Remove a key, returning a NEW map. */
void* resid_map_remove(void* map, void* key) {
    ResidMap* old = (ResidMap*)map;
    uint64_t h = resid_hash(key);
    int64_t idx = (int64_t)(h % (uint64_t)old->cap);
    MapEntry* ob = &old->buckets[idx * 4];
    int64_t bcap = 4;
    int exist = map_bucket_find(ob, bcap, key);
    if (exist < 0) return map;  /* key not found, return same map */

    ResidMap* nm = map_new(old->cap);
    nm->size = old->size - 1;

    /* Rehash all old entries except the removed one. */
    for (int64_t i = 0; i < old->cap; i++) {
        MapEntry* b = &old->buckets[i * 4];
        for (int j = 0; j < bcap; j++) {
            if (!b[j].used) continue;
            if (i == idx && j == exist) continue;  /* skip removed */
            uint64_t nh = resid_hash(b[j].key);
            int64_t nidx = (int64_t)(nh % (uint64_t)nm->cap);
            MapEntry* nb = &nm->buckets[nidx * 4];
            for (int k = 0; k < bcap; k++) {
                if (!nb[k].used) {
                    nb[k].key = b[j].key;
                    nb[k].val = b[j].val;
                    nb[k].used = 1;
                    break;
                }
            }
        }
    }
    return nm;
}

/* Check if a key exists. Returns 1/0. */
int8_t resid_map_contains(void* map, void* key) {
    ResidMap* m = (ResidMap*)map;
    uint64_t h = resid_hash(key);
    int64_t idx = (int64_t)(h % (uint64_t)m->cap);
    MapEntry* b = &m->buckets[idx * 4];
    int64_t bcap = 4;
    return map_bucket_find(b, bcap, key) >= 0 ? 1 : 0;
}

/* Number of entries. */
int64_t resid_map_len(void* map) {
    return ((ResidMap*)map)->size;
}

/* Build a List of keys. Returns a ResidVal* list. */
void* resid_map_keys(void* map) {
    ResidMap* m = (ResidMap*)map;
    int64_t n = m->size;
    void** ks = NULL;
    if (n > 0) ks = (void**)malloc((size_t)n * sizeof(void*));
    int64_t j = 0;
    int64_t bcap = 4;
    for (int64_t i = 0; i < m->cap && j < n; i++) {
        MapEntry* b = &m->buckets[i * 4];
        for (int k = 0; k < bcap && j < n; k++) {
            if (b[k].used) ks[j++] = b[k].key;
        }
    }
    ResidVal* r = (ResidVal*)malloc(sizeof(ResidVal));
    r->tag = 0;
    r->count = n;
    r->type = "list";
    r->slots = ks;
    return r;
}

/* Build a List of values. */
void* resid_map_values(void* map) {
    ResidMap* m = (ResidMap*)map;
    int64_t n = m->size;
    void** vs = NULL;
    if (n > 0) vs = (void**)malloc((size_t)n * sizeof(void*));
    int64_t j = 0;
    int64_t bcap = 4;
    for (int64_t i = 0; i < m->cap && j < n; i++) {
        MapEntry* b = &m->buckets[i * 4];
        for (int k = 0; k < bcap && j < n; k++) {
            if (b[k].used) vs[j++] = b[k].val;
        }
    }
    ResidVal* r = (ResidVal*)malloc(sizeof(ResidVal));
    r->tag = 0;
    r->count = n;
    r->type = "list";
    r->slots = vs;
    return r;
}

/* Format a map as a string: {key1: val1, key2: val2}. Uses resid_format_val
 * on each entry. Caller must free the returned string. */
char* resid_map_format(void* map) {
    ResidMap* m = (ResidMap*)map;
    if (m->size == 0) {
        char* r = (char*)malloc(3);
        r[0] = '{'; r[1] = '}'; r[2] = '\0';
        return r;
    }
    /* Estimate: ~20 chars per entry. */
    size_t cap = 2 + (size_t)m->size * 40 + 1;
    char* buf = (char*)malloc(cap);
    size_t pos = 0;
    buf[pos++] = '{';
    int64_t j = 0;
    int64_t bcap = 4;
    for (int64_t i = 0; i < m->cap && j < m->size; i++) {
        MapEntry* b = &m->buckets[i * 4];
        for (int k = 0; k < bcap && j < m->size; k++) {
            if (!b[k].used) continue;
            if (j > 0) { buf[pos++] = ','; buf[pos++] = ' '; }
            /* Key: assume string. */
            const char* ks = (const char*)b[k].key;
            if (resid_box_tag(b[k].key) == -1) {
                ks = (const char*)resid_box_slot(b[k].key, 0);
            }
            size_t kl = strlen(ks);
            if (pos + kl + 4 >= cap) { cap = cap * 2 + kl; buf = realloc(buf, cap); }
            memcpy(buf + pos, ks, kl); pos += kl;
            buf[pos++] = ':';
            buf[pos++] = ' ';
            /* Value: assume string. */
            const char* vs = (const char*)b[k].val;
            if (resid_box_tag(b[k].val) == -1) {
                vs = (const char*)resid_box_slot(b[k].val, 0);
            }
            size_t vl = strlen(vs);
            if (pos + vl + 2 >= cap) { cap = cap * 2 + vl; buf = realloc(buf, cap); }
            memcpy(buf + pos, vs, vl); pos += vl;
            j++;
        }
    }
    buf[pos++] = '}';
    buf[pos] = '\0';
    return buf;
}

/* ─── Set operations (sets are maps with NULL values) ─────────────── */

void* resid_set_new(void) {
    return map_new(MAP_INIT_CAP);
}

/* Insert an element into a set. Returns a NEW set. */
void* resid_set_insert(void* set, void* elem) {
    return resid_map_insert(set, elem, (void*)(intptr_t)1);
}

void* resid_set_remove(void* set, void* elem) {
    return resid_map_remove(set, elem);
}

int8_t resid_set_contains(void* set, void* elem) {
    return resid_map_contains(set, elem);
}

int64_t resid_set_len(void* set) {
    return resid_map_len(set);
}

/* Set union: elements from both sets. */
void* resid_set_union(void* a, void* b) {
    ResidMap* mb = (ResidMap*)b;
    void* result = a;
    int64_t bcap = 4;
    for (int64_t i = 0; i < mb->cap; i++) {
        MapEntry* be = &mb->buckets[i * 4];
        for (int j = 0; j < bcap; j++) {
            if (!be[j].used) continue;
            result = resid_map_insert(result, be[j].key, (void*)(intptr_t)1);
        }
    }
    return result;
}

/* Set difference: elements in a but not in b. */
void* resid_set_difference(void* a, void* b) {
    ResidMap* mb = (ResidMap*)b;
    void* result = a;
    int64_t bcap = 4;
    for (int64_t i = 0; i < mb->cap; i++) {
        MapEntry* be = &mb->buckets[i * 4];
        for (int j = 0; j < bcap; j++) {
            if (!be[j].used) continue;
            result = resid_map_remove(result, be[j].key);
        }
    }
    return result;
}

/* Set intersection: elements in both sets. */
void* resid_set_intersection(void* a, void* b) {
    ResidMap* ma = (ResidMap*)a;
    ResidMap* mb = (ResidMap*)b;
    /* Iterate over the smaller set. */
    ResidMap* smaller = ma->size <= mb->size ? ma : mb;
    ResidMap* larger = ma->size <= mb->size ? mb : ma;
    void* result = map_new(MAP_INIT_CAP);
    int64_t bcap = 4;
    for (int64_t i = 0; i < smaller->cap; i++) {
        MapEntry* be = &smaller->buckets[i * 4];
        for (int j = 0; j < bcap; j++) {
            if (!be[j].used) continue;
            if (resid_map_contains(larger, be[j].key)) {
                result = resid_map_insert(result, be[j].key, (void*)(intptr_t)1);
            }
        }
    }
    return result;
}

/* Convert a set to a list. */
void* resid_set_to_list(void* set) {
    return resid_map_keys(set);
}

/* Format a set as a string: {elem1, elem2, ...}. */
char* resid_set_format(void* set) {
    ResidMap* m = (ResidMap*)set;
    if (m->size == 0) {
        char* r = (char*)malloc(3);
        r[0] = '{'; r[1] = '}'; r[2] = '\0';
        return r;
    }
    size_t cap = 2 + (size_t)m->size * 20 + 1;
    char* buf = (char*)malloc(cap);
    size_t pos = 0;
    buf[pos++] = '{';
    int64_t j = 0;
    int64_t bcap = 4;
    for (int64_t i = 0; i < m->cap && j < m->size; i++) {
        MapEntry* b = &m->buckets[i * 4];
        for (int k = 0; k < bcap && j < m->size; k++) {
            if (!b[k].used) continue;
            if (j > 0) { buf[pos++] = ','; buf[pos++] = ' '; }
            const char* es = (const char*)b[k].key;
            if (resid_box_tag(b[k].key) == -1) {
                es = (const char*)resid_box_slot(b[k].key, 0);
            }
            size_t el = strlen(es);
            if (pos + el + 2 >= cap) { cap = cap * 2 + el; buf = realloc(buf, cap); }
            memcpy(buf + pos, es, el); pos += el;
            j++;
        }
    }
    buf[pos++] = '}';
    buf[pos] = '\0';
    return buf;
}
