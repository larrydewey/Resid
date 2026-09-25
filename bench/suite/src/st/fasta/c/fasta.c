/* fasta, single-threaded reference implementation.
 * Linear congruential generator, cumulative-probability selection and
 * 60-column output as described by the Computer Language Benchmarks Game. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define IM 139968
#define IA 3877
#define IC 29573
#define LINE 60

static unsigned last = 42;

static inline double gen_random(double max) {
    last = (last * IA + IC) % IM;
    return max * last / IM;
}

struct acid {
    char c;
    double p;
};

static struct acid iub[] = {
    {'a', 0.27}, {'c', 0.12}, {'g', 0.12}, {'t', 0.27}, {'B', 0.02},
    {'D', 0.02}, {'H', 0.02}, {'K', 0.02}, {'M', 0.02}, {'N', 0.02},
    {'R', 0.02}, {'S', 0.02}, {'V', 0.02}, {'W', 0.02}, {'Y', 0.02},
};

static struct acid homosapiens[] = {
    {'a', 0.3029549426680},
    {'c', 0.1979883004921},
    {'g', 0.1975473066391},
    {'t', 0.3015094502008},
};

static const char alu[] =
    "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG"
    "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA"
    "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT"
    "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA"
    "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG"
    "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC"
    "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

static void make_cumulative(struct acid *a, int count) {
    double cp = 0.0;
    for (int i = 0; i < count; i++) {
        cp += a[i].p;
        a[i].p = cp;
    }
}

static void repeat_fasta(const char *header, const char *s, int n) {
    int len = (int)strlen(s);
    char line[LINE + 1];
    int k = 0;
    fputs(header, stdout);
    while (n > 0) {
        int m = n < LINE ? n : LINE;
        for (int i = 0; i < m; i++) {
            line[i] = s[k];
            if (++k == len)
                k = 0;
        }
        line[m] = '\n';
        fwrite(line, 1, m + 1, stdout);
        n -= m;
    }
}

static void random_fasta(const char *header, const struct acid *a, int count, int n) {
    char line[LINE + 1];
    fputs(header, stdout);
    while (n > 0) {
        int m = n < LINE ? n : LINE;
        for (int i = 0; i < m; i++) {
            double r = gen_random(1.0);
            int j = 0;
            while (j < count - 1 && r >= a[j].p)
                j++;
            line[i] = a[j].c;
        }
        line[m] = '\n';
        fwrite(line, 1, m + 1, stdout);
        n -= m;
    }
}

int main(int argc, char **argv) {
    int n = argc > 1 ? atoi(argv[1]) : 1000;
    make_cumulative(iub, sizeof(iub) / sizeof(iub[0]));
    make_cumulative(homosapiens, sizeof(homosapiens) / sizeof(homosapiens[0]));
    repeat_fasta(">ONE Homo sapiens alu\n", alu, n * 2);
    random_fasta(">TWO IUB ambiguity codes\n", iub, sizeof(iub) / sizeof(iub[0]), n * 3);
    random_fasta(">THREE Homo sapiens frequency\n", homosapiens,
                 sizeof(homosapiens) / sizeof(homosapiens[0]), n * 5);
    return 0;
}
