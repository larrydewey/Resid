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

char* resid_env_get(const char* name) {
    const char* v = getenv(name);
    return v ? resid_box_str(v) : resid_box_str("");
}

int8_t resid_env_has(const char* name) {
    return getenv(name) != NULL ? 1 : 0;
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
