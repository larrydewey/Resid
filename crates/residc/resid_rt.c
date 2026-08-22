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
#include <limits.h>
#include <pthread.h>

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

/* ASCII-only case mapping (Unicode full casing is a later milestone). */
char* str_to_lower(const char* s) {
    size_t n = strlen(s);
    char* p = (char*)malloc(n + 1);
    for (size_t i = 0; i < n; i++)
        p[i] = (s[i] >= 'A' && s[i] <= 'Z') ? (char)(s[i] + 32) : s[i];
    p[n] = '\0';
    return p;
}

char* str_to_upper(const char* s) {
    size_t n = strlen(s);
    char* p = (char*)malloc(n + 1);
    for (size_t i = 0; i < n; i++)
        p[i] = (s[i] >= 'a' && s[i] <= 'z') ? (char)(s[i] - 32) : s[i];
    p[n] = '\0';
    return p;
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

static void* rt_list_sorted_copy(void* box, int (*cmp)(const void*, const void*)) {
    ResidVal* b = (ResidVal*)box;
    ResidVal* out = (ResidVal*)malloc(sizeof(ResidVal));
    out->tag = b->tag;
    out->count = b->count;
    out->type = b->type;
    out->slots = b->count > 0 ? (void**)malloc((size_t)b->count * sizeof(void*)) : NULL;
    for (int64_t i = 0; i < b->count; i++) out->slots[i] = b->slots[i];
    qsort(out->slots, (size_t)b->count, sizeof(void*), cmp);
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
