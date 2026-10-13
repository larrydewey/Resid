#!/usr/bin/env python3
"""Benchmark suite v2 driver (bench/v2/CONTRACT.md).

  bench2.py env                          record the machine and toolchains
  bench2.py build  [--lang L,..] [--profile portable|native]
  bench2.py run    [--lang L,..] [--bench B,..] [--mode runtime|as-written] [--outer N]
  bench2.py guard  [--lang L,..]         scaling check: time follows the work
  bench2.py report                       docs/BENCHMARKS-v2.md

Tier 1 (Are We Fast Yet) is implemented; results go to bench/v2/results/.
Process timing, memory measurement and the environment record come from
bench/suite/bench.py.
"""
import argparse
import json
import os
import re
import statistics
import subprocess
import sys
import tempfile
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "bench", "suite"))
import bench as b1  # noqa: E402  (measure, memrun_path, capture_env, stats)

T1 = os.path.join(HERE, "t1-awfy")
RESULTS = os.path.join(HERE, "results")
LANGS = ["resid", "c", "cpp", "rust", "go", "zig", "java", "csharp", "javascript", "python"]
LANG_NAMES = {"resid": "Resid", "c": "C", "cpp": "C++", "rust": "Rust", "go": "Go", "zig": "Zig",
              "java": "Java", "csharp": "C#", "javascript": "JavaScript", "python": "Python"}
# ReBench inner iterations of the reference configuration (rebench.conf).
BENCHES = [("DeltaBlue", 12000), ("Richards", 100), ("Json", 100), ("CD", 250),
           ("Havlak", 1500), ("Bounce", 1500), ("List", 1500), ("Mandelbrot", 500),
           ("NBody", 250000), ("Permute", 1000), ("Queens", 1000), ("Sieve", 3000),
           ("Storage", 1000), ("Towers", 600)]
# Benchmarks whose inner count repeats the same work (the guard halves it);
# the others take it as the problem size and verify only specific sizes.
REPEATING = {"Richards", "Json", "Bounce", "List", "Permute", "Queens", "Sieve", "Storage", "Towers"}
REF = "cpp"
LINE = re.compile(r"^(\w+): iterations=1 runtime: (\d+) ?us$")


def log(msg):
    print(msg, flush=True)


def cells(langs):
    out = []
    for l in langs:
        d = os.path.join(T1, l)
        if os.path.isfile(os.path.join(d, "build")):
            out.append((l, d))
    return out


def cmd_env(args):
    env = b1.capture_env()
    env["toolchains"]["zig"] = (b1.sh(["zig", "version"]) or "not found").strip()
    os.makedirs(RESULTS, exist_ok=True)
    b1.write_json(os.path.join(RESULTS, "env.json"), env)
    log(f"env {env['env_id']}: {env['cpu_model']}, governor {env['governor']}")


def cmd_build(args):
    builds = b1.load_json(os.path.join(RESULTS, "builds.json"), {})
    for lang, d in cells(args.langs):
        t0 = time.time()
        p = subprocess.run(["./build"], cwd=d, capture_output=True, text=True,
                           env=dict(os.environ, RESID_ROOT=ROOT, PROFILE=args.profile))
        dt = time.time() - t0
        out = os.path.join(d, "out")
        size = sum(os.path.getsize(os.path.join(r, f)) for r, _, fs in os.walk(out) for f in fs
                   if os.access(os.path.join(r, f), os.X_OK) and not f.endswith(".ll"))
        builds[f"{lang}/{args.profile}"] = {"ok": p.returncode == 0, "seconds": round(dt, 2),
                                            "out_bytes": size, "time": b1.now_iso(),
                                            "log": (p.stdout + p.stderr)[-2000:]}
        log(f"build {lang} [{args.profile}]: {'ok' if p.returncode == 0 else 'FAILED'} {dt:.1f}s")
    os.makedirs(RESULTS, exist_ok=True)
    b1.write_json(os.path.join(RESULTS, "builds.json"), builds)


def run_one(lang, d, bench, inner, outer, mode, cpus, timeout=3600):
    cmdfile = os.path.join(d, "cmd.aw" if mode == "as-written" and os.path.isfile(os.path.join(d, "cmd.aw")) else "cmd")
    argv = open(cmdfile).read().split() + [bench, str(outer), str(inner)]
    with tempfile.NamedTemporaryFile(delete=False, prefix="b2-") as tf:
        out_path = tf.name
    m = b1.measure(argv, d, None, out_path, out_path + ".err", timeout, 16 << 30,
                   "poll" if lang in ("java", "csharp", "javascript") else "rlimit",
                   cpus, dict(os.environ, RESID_ROOT=ROOT), b1.memrun_path(RESULTS))
    text = open(out_path, errors="replace").read()
    err = open(out_path + ".err", errors="replace").read()
    os.unlink(out_path)
    os.unlink(out_path + ".err")
    its = [int(mt.group(2)) for mt in (LINE.match(l) for l in text.splitlines()) if mt]
    ok = m["status"] == "ok" and len(its) == outer
    return {"lang": lang, "bench": bench, "inner": inner, "outer": outer, "mode": mode,
            "status": "ok" if ok else (m["status"] if m["status"] != "ok" else "bad-output"),
            "iterations_us": its, "wall_s": round(m["wall_s"], 6), "maxrss_kib": m["maxrss_kib"],
            "stderr_tail": err[-400:], "time": b1.now_iso()}


def cmd_run(args):
    os.makedirs(RESULTS, exist_ok=True)
    path = os.path.join(RESULTS, "runs.jsonl")
    cpus = {args.core}
    for lang, d in cells(args.langs):
        for bench, inner in BENCHES:
            if args.benches and bench not in args.benches:
                continue
            outer = args.outer
            # A slow implementation runs fewer outer iterations (at least 3).
            r0 = run_one(lang, d, bench, inner, 1, args.mode, cpus)
            if r0["status"] == "ok" and r0["iterations_us"][0] > 2_000_000:
                outer = max(3, min(outer, int(60_000_000 / r0["iterations_us"][0])))
            r = r0 if r0["status"] != "ok" else run_one(lang, d, bench, inner, outer, args.mode, cpus)
            with open(path, "a") as f:
                f.write(json.dumps(r, sort_keys=True) + "\n")
            its = r["iterations_us"]
            steady = statistics.median(its[len(its) // 2:]) if its else None
            log(f"run {lang} {bench} [{args.mode}]: {r['status']} first {its[0] if its else '-'}us steady {steady}us")


def cmd_guard(args):
    """Time per iteration must follow the work: halving the inner count of a
    repeating benchmark halves the time, and nothing runs in zero time."""
    cpus = {args.core}
    bad = 0
    for lang, d in cells(args.langs):
        for bench, inner in BENCHES:
            if bench not in REPEATING:
                continue
            full = run_one(lang, d, bench, inner, 5, "runtime", cpus)
            half = run_one(lang, d, bench, inner // 2, 5, "runtime", cpus)
            if full["status"] != "ok" or half["status"] != "ok":
                log(f"guard {lang} {bench}: run failed")
                bad += 1
                continue
            tf = statistics.median(full["iterations_us"][2:])
            th = statistics.median(half["iterations_us"][2:])
            ratio = tf / th if th > 0 else float("inf")
            ok = tf > 0 and 1.6 <= ratio <= 2.5
            bad += 0 if ok else 1
            log(f"guard {lang} {bench}: {th}us -> {tf}us x{ratio:.2f} {'ok' if ok else 'FAIL'}")
    sys.exit(1 if bad else 0)


def latest(runs):
    out = {}
    for r in runs:
        out[(r["lang"], r["bench"], r["mode"])] = r
    return out


def steady(r):
    its = r["iterations_us"]
    return statistics.median(its[len(its) // 2:]) if r["status"] == "ok" and its else None


def cmd_report(args):
    runs = b1.load_jsonl(os.path.join(RESULTS, "runs.jsonl"))
    env = b1.load_json(os.path.join(RESULTS, "env.json"), {})
    builds = b1.load_json(os.path.join(RESULTS, "builds.json"), {})
    lt = latest(runs)
    langs = [l for l in LANGS if any(k[0] == l for k in lt)]
    W = []
    W.append("# Resid benchmarks v2: Are We Fast Yet\n")
    W.append("*Generated by `bench/v2/bench2.py report` from `bench/v2/results/`. Rules: "
             "`bench/v2/CONTRACT.md`.*\n")
    W.append(f"Machine: {env.get('cpu_model', '?')}, governor {env.get('governor', '?')}, "
             f"Resid {env.get('resid_commit', '?')[:12]}. Steady state = median of the last half "
             "of the outer iterations, in milliseconds; ratio = language / C++ (lower is faster).\n")
    for mode in ("runtime", "as-written"):
        rows = []
        ratios = {l: [] for l in langs}
        for bench, _ in BENCHES:
            ref = lt.get((REF, bench, "runtime"))
            refv = steady(ref) if ref else None
            row = [bench]
            for l in langs:
                r = lt.get((l, bench, mode)) or (lt.get((l, bench, "runtime")) if mode == "as-written" and l != "resid" else None)
                v = steady(r) if r else None
                if v is None:
                    row.append("—")
                    continue
                row.append(f"{v / 1000:.1f}" + (f" ({v / refv:.2f}×)" if refv else ""))
                if refv:
                    ratios[l].append(v / refv)
            rows.append(row)
        if not any(ratios.values()):
            continue
        title = "Runtime mode (inputs opaque to every compiler)" if mode == "runtime" else \
            "As-written mode (build-time evaluation allowed; not run-time speed)"
        W.append(f"\n## {title}\n")
        W.append("| Benchmark | " + " | ".join(LANG_NAMES[l] for l in langs) + " |")
        W.append("|---|" + "---|" * len(langs))
        for row in rows:
            W.append("| " + " | ".join(row) + " |")
        W.append("| **geomean ratio** | " + " | ".join(
            (f"**{b1.geomean(ratios[l]):.2f}×**" if ratios[l] else "—") for l in langs) + " |")
        if mode == "runtime" and ratios.get("resid"):
            losses = [b for (b, _), x in zip(BENCHES, ratios["resid"]) if x > 1.0]
            W.append(f"\nResid is slower than C++ on {len(losses)} of {len(ratios['resid'])} "
                     f"benchmarks: {', '.join(losses)}.\n")
    if builds:
        W.append("\n## Builds\n")
        W.append("| Cell | ok | seconds | output bytes |")
        W.append("|---|---|---|---|")
        for k in sorted(builds):
            v = builds[k]
            W.append(f"| {k} | {'yes' if v['ok'] else 'no'} | {v['seconds']} | {v['out_bytes']} |")
    os.makedirs(os.path.join(ROOT, "docs"), exist_ok=True)
    out = os.path.join(ROOT, "docs", "BENCHMARKS-v2.md")
    with open(out, "w") as f:
        f.write("\n".join(W) + "\n")
    log(f"wrote {out}")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--core", type=int, default=2, help="CPU to pin runs to")
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("env")
    p = sub.add_parser("build")
    p.add_argument("--lang")
    p.add_argument("--profile", choices=["portable", "native"], default="portable")
    p = sub.add_parser("run")
    p.add_argument("--lang")
    p.add_argument("--bench")
    p.add_argument("--mode", choices=["runtime", "as-written"], default="runtime")
    p.add_argument("--outer", type=int, default=10)
    p = sub.add_parser("guard")
    p.add_argument("--lang")
    sub.add_parser("report")
    a = ap.parse_args()
    a.langs = a.lang.split(",") if getattr(a, "lang", None) else LANGS
    a.benches = a.bench.split(",") if getattr(a, "bench", None) else None
    {"env": cmd_env, "build": cmd_build, "run": cmd_run, "guard": cmd_guard, "report": cmd_report}[a.cmd](a)


if __name__ == "__main__":
    main()
