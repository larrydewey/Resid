/* regex-redux, single-threaded reference implementation using PCRE2 (JIT).
 * Pattern set, substitutions and output as described by the Computer
 * Language Benchmarks Game. */
#define PCRE2_CODE_UNIT_WIDTH 8
#include <pcre2.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *data;
    size_t len, cap;
} buffer;

static void buf_reserve(buffer *b, size_t need) {
    if (need > b->cap) {
        while (need > b->cap)
            b->cap = b->cap ? b->cap * 2 : 1 << 16;
        b->data = realloc(b->data, b->cap);
    }
}

static pcre2_code *compile(const char *pattern) {
    int err;
    PCRE2_SIZE off;
    pcre2_code *re = pcre2_compile((PCRE2_SPTR)pattern, PCRE2_ZERO_TERMINATED, 0, &err, &off, NULL);
    if (!re) {
        fprintf(stderr, "bad pattern %s\n", pattern);
        exit(1);
    }
    pcre2_jit_compile(re, PCRE2_JIT_COMPLETE);
    return re;
}

/* Replaces every match of pattern in src with repl, writing into dst. */
static void replace_all(const char *pattern, const char *repl, const buffer *src, buffer *dst) {
    pcre2_code *re = compile(pattern);
    pcre2_match_data *md = pcre2_match_data_create_from_pattern(re, NULL);
    size_t rlen = strlen(repl);
    size_t pos = 0;
    dst->len = 0;
    while (pos <= src->len &&
           pcre2_match(re, (PCRE2_SPTR)src->data, src->len, pos, 0, md, NULL) >= 0) {
        PCRE2_SIZE *ov = pcre2_get_ovector_pointer(md);
        size_t chunk = ov[0] - pos;
        buf_reserve(dst, dst->len + chunk + rlen);
        memcpy(dst->data + dst->len, src->data + pos, chunk);
        dst->len += chunk;
        memcpy(dst->data + dst->len, repl, rlen);
        dst->len += rlen;
        pos = ov[1] > ov[0] ? ov[1] : ov[1] + 1;
    }
    if (pos < src->len) {
        size_t chunk = src->len - pos;
        buf_reserve(dst, dst->len + chunk);
        memcpy(dst->data + dst->len, src->data + pos, chunk);
        dst->len += chunk;
    }
    pcre2_match_data_free(md);
    pcre2_code_free(re);
}

static long count_matches(const char *pattern, const buffer *src) {
    pcre2_code *re = compile(pattern);
    pcre2_match_data *md = pcre2_match_data_create_from_pattern(re, NULL);
    long count = 0;
    size_t pos = 0;
    while (pos <= src->len &&
           pcre2_match(re, (PCRE2_SPTR)src->data, src->len, pos, 0, md, NULL) >= 0) {
        PCRE2_SIZE *ov = pcre2_get_ovector_pointer(md);
        count++;
        pos = ov[1] > ov[0] ? ov[1] : ov[1] + 1;
    }
    pcre2_match_data_free(md);
    pcre2_code_free(re);
    return count;
}

int main(void) {
    static const char *variants[] = {
        "agggtaaa|tttaccct",
        "[cgt]gggtaaa|tttaccc[acg]",
        "a[act]ggtaaa|tttacc[agt]t",
        "ag[act]gtaaa|tttac[agt]ct",
        "agg[act]taaa|ttta[agt]cct",
        "aggg[acg]aaa|ttt[cgt]ccct",
        "agggt[cgt]aa|tt[acg]accct",
        "agggta[cgt]a|t[acg]taccct",
        "agggtaa[cgt]|[acg]ttaccct",
    };
    static const char *subst[][2] = {
        {"tHa[Nt]", "<4>"},
        {"aND|caN|Ha[DS]|WaS", "<3>"},
        {"a[NSt]|BY", "<2>"},
        {"<[^>]*>", "|"},
        {"\\|[^|][^|]*\\|", "-"},
    };

    buffer input = {0}, a = {0}, b = {0};
    size_t r;
    buf_reserve(&input, 1 << 20);
    while ((r = fread(input.data + input.len, 1, input.cap - input.len, stdin)) > 0) {
        input.len += r;
        if (input.len == input.cap)
            buf_reserve(&input, input.cap * 2);
    }
    size_t initial_len = input.len;

    replace_all(">.*\n|\n", "", &input, &a);
    size_t clean_len = a.len;

    for (size_t i = 0; i < sizeof(variants) / sizeof(variants[0]); i++)
        printf("%s %ld\n", variants[i], count_matches(variants[i], &a));

    buffer *src = &a, *dst = &b;
    for (size_t i = 0; i < sizeof(subst) / sizeof(subst[0]); i++) {
        replace_all(subst[i][0], subst[i][1], src, dst);
        buffer *t = src;
        src = dst;
        dst = t;
    }

    printf("\n%zu\n%zu\n%zu\n", initial_len, clean_len, src->len);
    free(input.data);
    free(a.data);
    free(b.data);
    return 0;
}
