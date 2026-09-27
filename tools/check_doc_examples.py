#!/usr/bin/env python3
"""Compile and run every complete Resid example in the website docs.

A ```resid block that defines `main()` is a program. It is compiled with
the Resid compiler (--profile debug) and run; when the block is followed by
a ```text block, the program's output must equal it. Markers inside the
block (as comments) change the check:

  // check-only            type-check only (--profile check)
  // expect-error: E0219   compilation must fail with this code
  // expect-abort          the program must exit non-zero

Usage: tools/check_doc_examples.py [compiler] [docs-dir]
"""
import os, re, subprocess, sys, tempfile

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
compiler = sys.argv[1] if len(sys.argv) > 1 else os.path.join(root, "build", "boot", "stage2.bin")
docs = sys.argv[2] if len(sys.argv) > 2 else os.path.join(root, "website", "src", "content", "docs")
env = dict(os.environ)
env.setdefault("RESID_HOME", os.path.dirname(os.path.abspath(compiler)))
fence = re.compile(r"^```(\w+)[^\n]*\n(.*?)^```\s*$", re.M | re.S)

passed, failed = 0, []
work = tempfile.mkdtemp()
for dirpath, _, files in sorted(os.walk(docs)):
    for name in sorted(files):
        if not name.endswith((".md", ".mdx")):
            continue
        path = os.path.join(dirpath, name)
        text = open(path).read()
        blocks = list(fence.finditer(text))
        for i, m in enumerate(blocks):
            lang, body = m.group(1), m.group(2)
            if lang != "resid" or not re.search(r"\bmain\s*\(\)", body):
                continue
            where = f"{os.path.relpath(path, docs)}:{text[:m.start()].count(chr(10)) + 1}"
            expect = None
            if i + 1 < len(blocks) and blocks[i + 1].group(1) == "text":
                gap = text[m.end():blocks[i + 1].start()]
                if len(gap.strip()) == 0 or len(gap) < 200:
                    expect = blocks[i + 1].group(2)
            src = os.path.join(work, f"ex{passed + len(failed)}.resid")
            out = src[:-6]
            open(src, "w").write(body)
            err = re.search(r"//\s*expect-error:\s*(E\d+)", body)
            profile = "check" if ("// check-only" in body or err) else "debug"
            c = subprocess.run([compiler, src, "-o", out, "--profile", profile], capture_output=True, text=True, cwd=work, timeout=300, env=env)
            log = c.stdout + c.stderr
            if err:
                if c.returncode != 0 and err.group(1) in log:
                    passed += 1
                else:
                    failed.append(f"{where}: expected {err.group(1)}, got: {log.strip()[-300:]}")
                continue
            if c.returncode != 0:
                failed.append(f"{where}: does not compile: {log.strip()[-400:]}")
                continue
            if profile == "check":
                passed += 1
                continue
            r = subprocess.run([out], capture_output=True, text=True, cwd=work, timeout=60)
            if "// expect-abort" in body:
                if r.returncode != 0:
                    passed += 1
                else:
                    failed.append(f"{where}: expected an abort, exited 0")
                continue
            if r.returncode != 0:
                failed.append(f"{where}: exit {r.returncode}: {(r.stdout + r.stderr).strip()[-300:]}")
            elif expect is not None and r.stdout.rstrip("\n") != expect.rstrip("\n"):
                failed.append(f"{where}: output differs\n--- expected\n{expect}--- got\n{r.stdout}")
            else:
                passed += 1

for f in failed:
    print("FAIL", f)
print(f"doc examples: {passed} passed, {len(failed)} failed")
sys.exit(1 if failed else 0)
