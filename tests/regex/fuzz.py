#!/usr/bin/env python3
"""Differential fuzz of lib/regex.resid against Go's regexp (RE2 semantics).

Usage: tests/regex/fuzz.py BIN GOREF [SEED] [CASES] [match]
With `match`, both programs print only whether each pattern matches (the
runtime's matcher behind toMatch and --filter); a pattern Go refuses
("E") is skipped.
Random patterns and texts go to both programs, one `pattern<TAB>text` per
line (`~` stands for a newline in the text); every line of output must match.
"""
import random
import subprocess
import sys

ATOMS = ["(?i)A", "(?i:b)", "[^\\d]", "\\W", "\\S", "[[:alpha:]]", "é", "(?m:^)", "(?m:$)",
         "(?s:.)", "[a-cé]", "(?i)[^a]", "\\A", "\\z", "\\n", "[\\s\\d]", "(?P<n>a)", "a{2,3}?",
         "a", "b", "c", ".", "[ab]", "[^a]", "\\d", "\\w", "\\s", "x", "[a-c]", "\\b", "\\B",
         "^", "$", "1", " ", "(?:a|b)"]
QUANTS = ["*", "+", "?", "{2}", "{1,3}", "{0,2}", "*?", "+?", "??", "{2,}"]


def gen(d):
    r = random.random()
    if d > 3 or r < 0.35:
        return random.choice(ATOMS)
    if r < 0.55:
        return gen(d + 1) + gen(d + 1)
    if r < 0.7:
        return gen(d + 1) + "|" + gen(d + 1)
    if r < 0.85:
        return "(" + gen(d + 1) + ")"
    return "(" + gen(d + 1) + ")" + random.choice(QUANTS)


# Go accepts a repeated group name; this library refuses it, as Python does.
def unique_names(p):
    parts = p.split("(?P<n>")
    return parts[0] + "".join(f"(?P<n{i}>" + part for i, part in enumerate(parts[1:]))


def text():
    return "".join(random.choice("abcx1 -~éABÉ") for _ in range(random.randint(0, 12)))


def main():
    binary, goref = sys.argv[1], sys.argv[2]
    random.seed(int(sys.argv[3]) if len(sys.argv) > 3 else 1)
    count = int(sys.argv[4]) if len(sys.argv) > 4 else 2000
    cases = [(unique_names(gen(0)), text()) for _ in range(count)]
    inp = "".join(f"{p}\t{s}\n" for p, s in cases).encode()
    got = subprocess.run([binary], input=inp, capture_output=True).stdout.decode().split("\n")
    want = subprocess.run([goref], input=inp, capture_output=True).stdout.decode().split("\n")
    only = len(sys.argv) > 5 and sys.argv[5] == "match"
    bad = 0
    for i, (p, s) in enumerate(cases):
        if only and want[i] == "E":
            continue
        if got[i] != want[i]:
            bad += 1
            if bad <= 8:
                print(f"MISMATCH {p!r} {s!r}\n  got  {got[i]!r}\n  want {want[i]!r}")
    print(f"regex {'match ' if only else ''}fuzz: {count} cases, {bad} mismatches")
    sys.exit(1 if bad else 0)


main()
