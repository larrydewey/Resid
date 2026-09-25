/* reverse-complement, single-threaded reference implementation.
 * Reads FASTA on stdin; for each sequence writes the header and the
 * reverse complement in 60-column lines, as described by the Computer
 * Language Benchmarks Game. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LINE 60

static unsigned char comp[256];

static void init_comp(void) {
    for (int i = 0; i < 256; i++)
        comp[i] = (unsigned char)i;
    const char *from = "ACGTUMRWSYKVHDBN";
    const char *to = "TGCAAKYWSRMBDHVN";
    for (int i = 0; from[i]; i++) {
        comp[(unsigned char)from[i]] = to[i];
        comp[(unsigned char)from[i] + ('a' - 'A')] = to[i];
    }
}

static char *out;
static size_t out_cap;

static void flush_sequence(const char *seq, size_t len) {
    size_t need = len + len / LINE + 1;
    if (need > out_cap) {
        out_cap = need;
        out = realloc(out, out_cap);
    }
    size_t o = 0, col = 0;
    for (size_t i = len; i > 0; i--) {
        out[o++] = comp[(unsigned char)seq[i - 1]];
        if (++col == LINE) {
            out[o++] = '\n';
            col = 0;
        }
    }
    if (col != 0)
        out[o++] = '\n';
    fwrite(out, 1, o, stdout);
}

int main(void) {
    init_comp();
    /* slurp stdin */
    size_t cap = 1 << 20, n = 0;
    char *buf = malloc(cap);
    size_t r;
    while ((r = fread(buf + n, 1, cap - n, stdin)) > 0) {
        n += r;
        if (n == cap) {
            cap *= 2;
            buf = realloc(buf, cap);
        }
    }

    size_t seq_cap = 1 << 20, seq_len = 0;
    char *seq = malloc(seq_cap);
    int have = 0;
    size_t i = 0;
    while (i < n) {
        char *nl = memchr(buf + i, '\n', n - i);
        size_t end = nl ? (size_t)(nl - buf) : n;
        if (buf[i] == '>') {
            if (have)
                flush_sequence(seq, seq_len);
            seq_len = 0;
            have = 1;
            fwrite(buf + i, 1, end - i, stdout);
            fputc('\n', stdout);
        } else {
            size_t l = end - i;
            if (seq_len + l > seq_cap) {
                while (seq_len + l > seq_cap)
                    seq_cap *= 2;
                seq = realloc(seq, seq_cap);
            }
            memcpy(seq + seq_len, buf + i, l);
            seq_len += l;
        }
        i = end + 1;
    }
    if (have)
        flush_sequence(seq, seq_len);
    free(seq);
    free(buf);
    free(out);
    return 0;
}
