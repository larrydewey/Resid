// spectral-norm, single-threaded C++ implementation.
// Power method as described by the Computer Language Benchmarks Game.
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <vector>

namespace {

inline double eval_a(int i, int j) { return 1.0 / ((i + j) * (i + j + 1) / 2 + i + 1); }

void mul_av(const std::vector<double> &v, std::vector<double> &av) {
    int n = static_cast<int>(v.size());
    for (int i = 0; i < n; ++i) {
        double s = 0.0;
        for (int j = 0; j < n; ++j)
            s += eval_a(i, j) * v[j];
        av[i] = s;
    }
}

void mul_atv(const std::vector<double> &v, std::vector<double> &atv) {
    int n = static_cast<int>(v.size());
    for (int i = 0; i < n; ++i) {
        double s = 0.0;
        for (int j = 0; j < n; ++j)
            s += eval_a(j, i) * v[j];
        atv[i] = s;
    }
}

void mul_atav(const std::vector<double> &v, std::vector<double> &atav, std::vector<double> &tmp) {
    mul_av(v, tmp);
    mul_atv(tmp, atav);
}

} // namespace

int main(int argc, char **argv) {
    int n = argc > 1 ? std::atoi(argv[1]) : 100;
    std::vector<double> u(n, 1.0), v(n), tmp(n);
    for (int i = 0; i < 10; ++i) {
        mul_atav(u, v, tmp);
        mul_atav(v, u, tmp);
    }
    double vbv = 0.0, vv = 0.0;
    for (int i = 0; i < n; ++i) {
        vbv += u[i] * v[i];
        vv += v[i] * v[i];
    }
    std::printf("%0.9f\n", std::sqrt(vbv / vv));
}
