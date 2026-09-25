// regex-redux, single-threaded C++ implementation using std::regex
// (ECMAScript grammar). Pattern set, substitutions and output as described by
// the Computer Language Benchmarks Game.
#include <cstdio>
#include <iostream>
#include <iterator>
#include <regex>
#include <string>
#include <utility>

int main() {
    std::ios::sync_with_stdio(false);
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
    static const std::pair<const char *, const char *> subst[] = {
        {"tHa[Nt]", "<4>"},
        {"aND|caN|Ha[DS]|WaS", "<3>"},
        {"a[NSt]|BY", "<2>"},
        {"<[^>]*>", "|"},
        {"\\|[^|][^|]*\\|", "-"},
    };

    std::string input((std::istreambuf_iterator<char>(std::cin)), std::istreambuf_iterator<char>());
    const std::size_t initial_len = input.size();

    std::string seq = std::regex_replace(input, std::regex(">[^\n]*\n|\n"), "");
    const std::size_t clean_len = seq.size();

    for (const char *v : variants) {
        std::regex re(v);
        auto begin = std::sregex_iterator(seq.begin(), seq.end(), re);
        std::printf("%s %ld\n", v, static_cast<long>(std::distance(begin, std::sregex_iterator())));
    }

    for (const auto &s : subst)
        seq = std::regex_replace(seq, std::regex(s.first), s.second);

    std::printf("\n%zu\n%zu\n%zu\n", initial_len, clean_len, seq.size());
}
