// reverse-complement, single-threaded C++ implementation.
// Reads FASTA on stdin; for each sequence writes the header and the reverse
// complement in 60-column lines, as described by the Computer Language
// Benchmarks Game.
#include <array>
#include <cstdio>
#include <iostream>
#include <iterator>
#include <string>

namespace {

constexpr std::size_t LINE = 60;

std::array<char, 256> make_table() {
    std::array<char, 256> t{};
    for (int i = 0; i < 256; ++i)
        t[i] = static_cast<char>(i);
    const std::string from = "ACGTUMRWSYKVHDBN";
    const std::string to = "TGCAAKYWSRMBDHVN";
    for (std::size_t i = 0; i < from.size(); ++i) {
        t[static_cast<unsigned char>(from[i])] = to[i];
        t[static_cast<unsigned char>(from[i] + ('a' - 'A'))] = to[i];
    }
    return t;
}

void flush(const std::string &seq, const std::array<char, 256> &comp, std::string &out) {
    out.clear();
    out.reserve(seq.size() + seq.size() / LINE + 1);
    std::size_t col = 0;
    for (auto it = seq.rbegin(); it != seq.rend(); ++it) {
        out.push_back(comp[static_cast<unsigned char>(*it)]);
        if (++col == LINE) {
            out.push_back('\n');
            col = 0;
        }
    }
    if (col != 0)
        out.push_back('\n');
    std::fwrite(out.data(), 1, out.size(), stdout);
}

} // namespace

int main() {
    std::ios::sync_with_stdio(false);
    const auto comp = make_table();
    std::string input((std::istreambuf_iterator<char>(std::cin)), std::istreambuf_iterator<char>());
    std::string seq, out;
    bool have = false;
    std::size_t i = 0;
    while (i < input.size()) {
        std::size_t end = input.find('\n', i);
        if (end == std::string::npos)
            end = input.size();
        if (input[i] == '>') {
            if (have)
                flush(seq, comp, out);
            seq.clear();
            have = true;
            std::fwrite(input.data() + i, 1, end - i, stdout);
            std::fputc('\n', stdout);
        } else {
            seq.append(input, i, end - i);
        }
        i = end + 1;
    }
    if (have)
        flush(seq, comp, out);
}
