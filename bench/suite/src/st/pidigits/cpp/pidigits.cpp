// pidigits, single-threaded C++ implementation using the GMP C API.
// Unbounded spigot algorithm (step-by-step) as described by the Computer
// Language Benchmarks Game.
#include <gmp.h>

#include <cstdio>
#include <cstdlib>
#include <string>

namespace {

class Spigot {
  public:
    Spigot() {
        mpz_init(tmp1_);
        mpz_init(tmp2_);
        mpz_init_set_ui(acc_, 0);
        mpz_init_set_ui(den_, 1);
        mpz_init_set_ui(num_, 1);
    }
    ~Spigot() {
        mpz_clear(tmp1_);
        mpz_clear(tmp2_);
        mpz_clear(acc_);
        mpz_clear(den_);
        mpz_clear(num_);
    }
    Spigot(const Spigot &) = delete;
    Spigot &operator=(const Spigot &) = delete;

    // Advances until the next digit is known and returns it.
    unsigned next_digit() {
        for (;;) {
            next_term(++k_);
            if (mpz_cmp(num_, acc_) > 0)
                continue;
            unsigned d = extract_digit(3);
            if (d != extract_digit(4))
                continue;
            eliminate_digit(d);
            return d;
        }
    }

  private:
    unsigned extract_digit(unsigned nth) {
        mpz_mul_ui(tmp1_, num_, nth);
        mpz_add(tmp2_, tmp1_, acc_);
        mpz_tdiv_q(tmp1_, tmp2_, den_);
        return static_cast<unsigned>(mpz_get_ui(tmp1_));
    }
    void eliminate_digit(unsigned d) {
        mpz_submul_ui(acc_, den_, d);
        mpz_mul_ui(acc_, acc_, 10);
        mpz_mul_ui(num_, num_, 10);
    }
    void next_term(unsigned k) {
        unsigned k2 = k * 2U + 1U;
        mpz_addmul_ui(acc_, num_, 2U);
        mpz_mul_ui(acc_, acc_, k2);
        mpz_mul_ui(den_, den_, k2);
        mpz_mul_ui(num_, num_, k);
    }

    mpz_t tmp1_, tmp2_, acc_, den_, num_;
    unsigned k_ = 0;
};

} // namespace

int main(int argc, char **argv) {
    const unsigned n = argc > 1 ? static_cast<unsigned>(std::atoi(argv[1])) : 27;
    Spigot spigot;
    std::string line;
    for (unsigned i = 1; i <= n; ++i) {
        line.push_back(static_cast<char>('0' + spigot.next_digit()));
        if (line.size() == 10) {
            std::printf("%s\t:%u\n", line.c_str(), i);
            line.clear();
        }
    }
    if (!line.empty()) {
        line.resize(10, ' ');
        std::printf("%s\t:%u\n", line.c_str(), n);
    }
}
