// fasta, single-threaded C++ implementation.
// Linear congruential generator, cumulative-probability selection and
// 60-column output as described by the Computer Language Benchmarks Game.
#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>

namespace {

constexpr unsigned IM = 139968, IA = 3877, IC = 29573;
constexpr int LINE = 60;

struct Random {
    unsigned last = 42;
    double next(double max) {
        last = (last * IA + IC) % IM;
        return max * last / IM;
    }
};

struct Acid {
    char c;
    double p;
};

std::vector<Acid> cumulative(std::vector<Acid> acids) {
    double cp = 0.0;
    for (Acid &a : acids) {
        cp += a.p;
        a.p = cp;
    }
    return acids;
}

void repeat_fasta(const char *header, const std::string &s, int n) {
    std::fputs(header, stdout);
    std::string line;
    std::size_t k = 0;
    while (n > 0) {
        int m = n < LINE ? n : LINE;
        line.clear();
        for (int i = 0; i < m; ++i) {
            line.push_back(s[k]);
            if (++k == s.size())
                k = 0;
        }
        line.push_back('\n');
        std::fwrite(line.data(), 1, line.size(), stdout);
        n -= m;
    }
}

void random_fasta(const char *header, const std::vector<Acid> &acids, int n, Random &rng) {
    std::fputs(header, stdout);
    std::string line;
    const std::size_t last = acids.size() - 1;
    while (n > 0) {
        int m = n < LINE ? n : LINE;
        line.clear();
        for (int i = 0; i < m; ++i) {
            double r = rng.next(1.0);
            std::size_t j = 0;
            while (j < last && r >= acids[j].p)
                ++j;
            line.push_back(acids[j].c);
        }
        line.push_back('\n');
        std::fwrite(line.data(), 1, line.size(), stdout);
        n -= m;
    }
}

} // namespace

int main(int argc, char **argv) {
    const int n = argc > 1 ? std::atoi(argv[1]) : 1000;
    const std::string alu =
        "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG"
        "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA"
        "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT"
        "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA"
        "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG"
        "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC"
        "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";
    const std::vector<Acid> iub = cumulative({
        {'a', 0.27}, {'c', 0.12}, {'g', 0.12}, {'t', 0.27}, {'B', 0.02},
        {'D', 0.02}, {'H', 0.02}, {'K', 0.02}, {'M', 0.02}, {'N', 0.02},
        {'R', 0.02}, {'S', 0.02}, {'V', 0.02}, {'W', 0.02}, {'Y', 0.02},
    });
    const std::vector<Acid> homosapiens = cumulative({
        {'a', 0.3029549426680},
        {'c', 0.1979883004921},
        {'g', 0.1975473066391},
        {'t', 0.3015094502008},
    });
    Random rng;
    repeat_fasta(">ONE Homo sapiens alu\n", alu, n * 2);
    random_fasta(">TWO IUB ambiguity codes\n", iub, n * 3, rng);
    random_fasta(">THREE Homo sapiens frequency\n", homosapiens, n * 5, rng);
}
