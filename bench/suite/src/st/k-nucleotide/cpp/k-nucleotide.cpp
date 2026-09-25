// k-nucleotide, single-threaded C++ implementation.
// Reads FASTA on stdin, extracts sequence THREE and counts k-mers with
// std::unordered_map (keys packed 2 bits per nucleotide), as described by
// the Computer Language Benchmarks Game.
#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <iostream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

namespace {

using Counts = std::unordered_map<std::uint64_t, std::uint32_t>;

inline std::uint64_t code_of(char c) {
    switch (c) {
    case 'A': return 0;
    case 'C': return 1;
    case 'G': return 2;
    default: return 3; // 'T'
    }
}

Counts count_kmers(const std::string &seq, int k) {
    Counts counts;
    const std::uint64_t mask = (std::uint64_t{1} << (2 * k)) - 1;
    std::uint64_t key = 0;
    for (int i = 0; i < k - 1; ++i)
        key = (key << 2) | code_of(seq[i]);
    for (std::size_t i = k - 1; i < seq.size(); ++i) {
        key = ((key << 2) | code_of(seq[i])) & mask;
        ++counts[key];
    }
    return counts;
}

std::string decode(std::uint64_t key, int k) {
    static const char letters[] = "ACGT";
    std::string s(k, ' ');
    for (int j = k - 1; j >= 0; --j) {
        s[j] = letters[key & 3];
        key >>= 2;
    }
    return s;
}

void write_frequencies(const std::string &seq, int k) {
    Counts counts = count_kmers(seq, k);
    std::vector<std::pair<std::uint64_t, std::uint32_t>> entries(counts.begin(), counts.end());
    std::uint64_t total = 0;
    for (const auto &e : entries)
        total += e.second;
    std::sort(entries.begin(), entries.end(), [](const auto &a, const auto &b) {
        return a.second != b.second ? a.second > b.second : a.first < b.first;
    });
    for (const auto &e : entries)
        std::printf("%s %.3f\n", decode(e.first, k).c_str(), 100.0 * e.second / total);
    std::printf("\n");
}

void write_count(const std::string &seq, const std::string &frag) {
    const int k = static_cast<int>(frag.size());
    Counts counts = count_kmers(seq, k);
    std::uint64_t key = 0;
    for (char c : frag)
        key = (key << 2) | code_of(c);
    auto it = counts.find(key);
    std::printf("%u\t%s\n", it == counts.end() ? 0u : it->second, frag.c_str());
}

} // namespace

int main() {
    std::ios::sync_with_stdio(false);
    std::string line, seq;
    while (std::getline(std::cin, line))
        if (line.compare(0, 6, ">THREE") == 0)
            break;
    while (std::getline(std::cin, line)) {
        if (!line.empty() && line[0] == '>')
            break;
        for (char c : line) {
            if (c == '\r')
                continue;
            seq.push_back(static_cast<char>(c >= 'a' && c <= 'z' ? c - ('a' - 'A') : c));
        }
    }

    write_frequencies(seq, 1);
    write_frequencies(seq, 2);
    for (const char *frag : {"GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"})
        write_count(seq, frag);
}
