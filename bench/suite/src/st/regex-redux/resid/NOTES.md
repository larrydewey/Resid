# regex-redux (Resid, st)

Port of the regex-redux description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/regexredux.html)
on the standard library's `lib/regex.resid`: strip the headers and line
breaks with `>.*\n|\n`, count the nine variant patterns, then apply the five
IUB substitutions in order.

How it is written:

- Every pattern here has no assertions, so `regex_compile` builds the whole
  DFA up front (forward for the match end, reverse for its start) and a
  search is a tail-recursive walk that indexes a flat transition list per
  codepoint. No backtracking and no per-character allocation.
- `regex_count` and `regex_replace_all` reuse one compiled pattern over the
  whole text; replacements build the result with a string builder.
- The input is read whole with `filesystem.read_all("/dev/stdin")`.

Measured on this host at the official size (fasta 5000000): 2.4 s and
320 MB peak RSS (C with PCRE2 JIT: 1.7 s, 152 MB). Replacing and counting
over a whole-DFA pattern is a loop that carries only integers and the
builder, and gaps go into the builder with `str_sb_append_slice`, so a
match costs no allocation. Output byte-identical to the C program.
