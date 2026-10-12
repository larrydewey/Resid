#!/usr/bin/env python3
"""Fail when a declaration of the standard library has no doc comment.

The API reference (resid-book, `api = "../lib"` in website/book.toml) is
generated from the `///` comments of lib/, lib/dev/ and lib/verify/: every
top-level `pub` function and every `type` or `behavior` (visible to an
importer even without `pub`) needs one, directly above its annotations.

    tools/check_doc_comments.py [ROOT]
"""
import glob
import os
import sys

root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
files = sorted(glob.glob(os.path.join(root, "lib", "*.resid")) +
               glob.glob(os.path.join(root, "lib", "dev", "*.resid")) +
               glob.glob(os.path.join(root, "lib", "verify", "*.resid")))
missing = []
total = 0
for f in files:
    lines = open(f, encoding="utf-8").read().split("\n")
    for i, line in enumerate(lines):
        if not line.startswith(("pub ", "type ", "behavior ")):
            continue
        total += 1
        j = i - 1
        while j >= 0 and lines[j].startswith("@"):
            j -= 1
        if j < 0 or not lines[j].startswith("///"):
            missing.append(f"{os.path.relpath(f, root)}:{i + 1}: {line.strip()[:80]}")
for m in missing:
    print(m)
print(f"doc comments: {total - len(missing)} of {total} declarations documented")
sys.exit(1 if missing else 0)
