/* spectral-norm, single-threaded reference implementation.
 * Power method as described by the Computer Language Benchmarks Game. */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

static inline double eval_a(int i, int j) {
    return 1.0 / ((i + j) * (i + j + 1) / 2 + i + 1);
}

static void mul_av(int n, const double *v, double *av) {
    for (int i = 0; i < n; i++) {
        double s = 0.0;
        for (int j = 0; j < n; j++)
            s += eval_a(i, j) * v[j];
        av[i] = s;
    }
}

static void mul_atv(int n, const double *v, double *atv) {
    for (int i = 0; i < n; i++) {
        double s = 0.0;
        for (int j = 0; j < n; j++)
            s += eval_a(j, i) * v[j];
        atv[i] = s;
    }
}

static void mul_atav(int n, const double *v, double *atav, double *tmp) {
    mul_av(n, v, tmp);
    mul_atv(n, tmp, atav);
}

int main(int argc, char **argv) {
    int n = argc > 1 ? atoi(argv[1]) : 100;
    double *u = malloc(n * sizeof(double));
    double *v = malloc(n * sizeof(double));
    double *tmp = malloc(n * sizeof(double));
    for (int i = 0; i < n; i++)
        u[i] = 1.0;
    for (int i = 0; i < 10; i++) {
        mul_atav(n, u, v, tmp);
        mul_atav(n, v, u, tmp);
    }
    double vbv = 0.0, vv = 0.0;
    for (int i = 0; i < n; i++) {
        vbv += u[i] * v[i];
        vv += v[i] * v[i];
    }
    printf("%0.9f\n", sqrt(vbv / vv));
    free(u);
    free(v);
    free(tmp);
    return 0;
}
