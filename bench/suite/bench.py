#!/usr/bin/env python3
"""Cross-language benchmark harness and white-paper report generator.

Pure Python 3 standard library. See README.md (usage) and CONTRACT.md (cell
layout). Subcommands: env, build, inputs, run, report, all.

Result files (under --results, default bench/suite/results/):
  env.json      environment snapshot (committed)
  builds.json   per-cell build records (committed)
  inputs.json   generated stdin inputs and their sha256 (committed)
  runs.jsonl    one JSON object per timed run, append-only (committed)
  inputs/       generated stdin input files (gitignored)
  logs/         build logs, run stderr tails, mismatching output (gitignored)
"""

import argparse
import csv
import datetime
import gzip
import hashlib
import io
import json
import math
import os
import platform
import random
import resource
import shlex
import shutil
import signal
import subprocess
import sys
import tempfile
import threading
import time

SUITE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(SUITE, "..", ".."))

TRACKS = ["st", "best"]
BENCHES = ["nbody", "fannkuch-redux", "spectral-norm", "mandelbrot", "binary-trees",
           "fasta", "k-nucleotide", "reverse-complement", "pidigits", "regex-redux"]
LANGS = ["resid", "c", "cpp", "rust", "go", "java", "csharp", "javascript",
         "python", "fortran", "pascal"]
LANG_NAMES = {"resid": "Resid", "c": "C", "cpp": "C++", "rust": "Rust", "go": "Go",
              "java": "Java", "csharp": "C#", "javascript": "JavaScript",
              "python": "Python", "fortran": "Fortran", "pascal": "Pascal"}
TRACK_NAMES = {"st": "single-thread, same algorithm (st)",
               "best": "fastest known program (best)"}
SIZES = ["official", "small"]
# bench -> {size: argv size}
SIZE_ARG = {
    "nbody": {"official": "50000000", "small": "5000000"},
    "fannkuch-redux": {"official": "12", "small": "10"},
    "spectral-norm": {"official": "5500", "small": "1000"},
    "mandelbrot": {"official": "16000", "small": "4000"},
    "binary-trees": {"official": "21", "small": "16"},
    "fasta": {"official": "25000000", "small": "2500000"},
    "k-nucleotide": {"official": "0", "small": "0"},
    "reverse-complement": {"official": "0", "small": "0"},
    "pidigits": {"official": "10000", "small": "2000"},
    "regex-redux": {"official": "0", "small": "0"},
}
# bench -> {size: fasta N used to generate the stdin input}
STDIN_N = {
    "k-nucleotide": {"official": "25000000", "small": "2500000"},
    "reverse-complement": {"official": "25000000", "small": "2500000"},
    "regex-redux": {"official": "5000000", "small": "500000"},
}
REF_TRACK, REF_LANG = "st", "c"

SOURCE_EXTS = {".resid", ".c", ".h", ".cpp", ".cc", ".cxx", ".hpp", ".hh", ".rs",
               ".go", ".java", ".cs", ".js", ".mjs", ".cjs", ".py", ".f", ".f90",
               ".f95", ".f03", ".f08", ".pas", ".pp", ".lpr", ".inc"}
SKIP_DIRS = {"out", "target", "obj", "bin", "node_modules", "__pycache__", ".git"}

# Memory-limit policy per language: "rlimit" = RLIMIT_AS in the child,
# "poll" = no RLIMIT_AS, poll resident set of the process tree and kill when
# over the limit (managed runtimes reserve large virtual address ranges).
DEFAULT_MEM_POLICY = {"java": "poll", "csharp": "poll", "javascript": "poll"}
OOM_MARKERS = ["out of memory", "memoryerror", "bad_alloc", "cannot allocate memory",
               "memory allocation failed", "outofmemoryerror", "heap out of memory",
               "failed to allocate", "runtime: out of memory", "insufficient memory"]


# ----------------------------------------------------------------------------
# small utilities

def now_iso():
    return datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def read_text(path, default=None):
    try:
        with open(path, encoding="utf-8", errors="replace") as f:
            return f.read()
    except OSError:
        return default


def sh(argv, cwd=None, timeout=30):
    """Run a command, return combined stdout+stderr stripped, or None."""
    try:
        p = subprocess.run(argv, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                           timeout=timeout, text=True, errors="replace")
        return p.stdout.strip()
    except (OSError, subprocess.SubprocessError):
        return None


def write_json(path, obj):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    tmp = path + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(obj, f, indent=2, sort_keys=True)
        f.write("\n")
    os.replace(tmp, path)


def load_json(path, default):
    try:
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    except (OSError, ValueError):
        return default


def load_jsonl(path):
    out = []
    try:
        with open(path, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line:
                    try:
                        out.append(json.loads(line))
                    except ValueError:
                        pass
    except OSError:
        pass
    return out


def split_list(value, universe):
    if not value:
        return list(universe)
    wanted = [v.strip() for v in value.split(",") if v.strip()]
    return [u for u in universe if u in wanted] + [w for w in wanted if w not in universe]


def git_commit():
    c = sh(["git", "-C", ROOT, "rev-parse", "HEAD"])
    if not c or " " in c:
        return "unknown"
    dirty = sh(["git", "-C", ROOT, "status", "--porcelain", "--untracked-files=no"])
    return c + ("-dirty" if dirty else "")


def log(msg):
    print(msg, flush=True)


# ----------------------------------------------------------------------------
# cells

class Cell:
    def __init__(self, src, track, bench, lang):
        self.track, self.bench, self.lang = track, bench, lang
        self.dir = os.path.join(src, track, bench, lang)
        self.key = f"{track}/{bench}/{lang}"

    @property
    def exists(self):
        return os.path.isdir(self.dir)

    @property
    def is_na(self):
        return os.path.isfile(os.path.join(self.dir, "NA"))

    @property
    def runnable(self):
        return (not self.is_na and os.path.isfile(os.path.join(self.dir, "build"))
                and os.path.isfile(os.path.join(self.dir, "cmd")))

    def na_reason(self):
        return (read_text(os.path.join(self.dir, "NA"), "") or "").strip()

    def notes(self):
        return (read_text(os.path.join(self.dir, "NOTES.md"), "") or "").strip()

    def cmd(self):
        text = read_text(os.path.join(self.dir, "cmd"), "") or ""
        for line in text.splitlines():
            line = line.strip()
            if line and not line.startswith("#"):
                return shlex.split(line)
        return []

    def files(self):
        """All regular files of the cell, excluding build artefact dirs."""
        res = []
        for base, dirs, files in os.walk(self.dir):
            dirs[:] = sorted(d for d in dirs if d not in SKIP_DIRS)
            for fn in sorted(files):
                p = os.path.join(base, fn)
                if os.path.isfile(p) and not os.path.islink(p):
                    res.append(os.path.relpath(p, self.dir))
        return sorted(res)

    def source_hash(self):
        h = hashlib.sha256()
        for rel in self.files():
            if rel in ("NOTES.md", "NA"):
                continue  # documentation edits do not invalidate builds or runs
            h.update(rel.encode() + b"\0")
            with open(os.path.join(self.dir, rel), "rb") as f:
                h.update(f.read())
            h.update(b"\0")
        return h.hexdigest()

    def source_stats(self):
        blob = io.BytesIO()
        nbytes = nlines = 0
        names = []
        for rel in self.files():
            if os.path.splitext(rel)[1].lower() not in SOURCE_EXTS:
                continue
            with open(os.path.join(self.dir, rel), "rb") as f:
                data = f.read()
            names.append(rel)
            nbytes += len(data)
            nlines += data.count(b"\n") + (0 if data.endswith(b"\n") or not data else 1)
            blob.write(data)
        gz = len(gzip.compress(blob.getvalue(), compresslevel=9, mtime=0)) if nbytes else 0
        return {"source_files": names, "source_bytes": nbytes, "source_lines": nlines,
                "source_gzip_bytes": gz}


def all_cells(src, tracks=TRACKS, benches=BENCHES, langs=LANGS):
    return [Cell(src, t, b, l) for b in benches for t in tracks for l in langs]


# ----------------------------------------------------------------------------
# env

TOOLCHAINS = [
    ("gcc", ["gcc", "--version"]), ("g++", ["g++", "--version"]),
    ("clang", ["clang", "--version"]), ("gfortran", ["gfortran", "--version"]),
    ("fpc", ["fpc", "-iV"]), ("rustc", ["rustc", "--version"]),
    ("cargo", ["cargo", "--version"]), ("go", ["go", "version"]),
    ("java", ["java", "-version"]), ("javac", ["javac", "-version"]),
    ("dotnet", ["dotnet", "--version"]), ("node", ["node", "--version"]),
    ("python3", ["python3", "--version"]), ("pcre2", ["pcre2-config", "--version"]),
]


def capture_env():
    env = {}
    cpu = {}
    lscpu = sh(["lscpu"]) or ""
    for line in lscpu.splitlines():
        if ":" in line:
            k, v = line.split(":", 1)
            cpu[k.strip()] = v.strip()
    env["cpu_model"] = cpu.get("Model name", platform.processor())
    env["cpu_threads"] = os.cpu_count()
    try:
        cores = int(cpu.get("Core(s) per socket", "0")) * int(cpu.get("Socket(s)", "1"))
    except ValueError:
        cores = None
    env["cpu_cores"] = cores
    env["threads_per_core"] = cpu.get("Thread(s) per core")
    env["cpu_max_mhz"] = cpu.get("CPU max MHz")
    freqs = {}
    for i in range(os.cpu_count() or 0):
        f = read_text(f"/sys/devices/system/cpu/cpu{i}/cpufreq/cpuinfo_max_freq")
        if f:
            freqs[str(i)] = int(f.strip()) // 1000
    env["cpu_max_mhz_per_cpu"] = freqs
    mem = {}
    for line in (read_text("/proc/meminfo", "") or "").splitlines():
        k, _, v = line.partition(":")
        mem[k] = v.strip()
    try:
        env["ram_gib"] = round(int(mem["MemTotal"].split()[0]) / 1048576, 1)
    except (KeyError, ValueError):
        env["ram_gib"] = None
    env["kernel"] = f"{platform.system()} {platform.release()}"
    env["machine"] = platform.machine()
    env["governor"] = (read_text("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor", "?") or "?").strip()
    env["thp"] = (read_text("/sys/kernel/mm/transparent_hugepage/enabled", "?") or "?").strip()
    env["smt_active"] = (read_text("/sys/devices/system/cpu/smt/active", "?") or "?").strip()
    env["boost"] = cpu.get("Frequency boost", (read_text("/sys/devices/system/cpu/cpufreq/boost", "?") or "?").strip())
    tc = {}
    for name, argv in TOOLCHAINS:
        out = sh(argv)
        tc[name] = out.splitlines()[0].strip() if out else "not found"
    env["toolchains"] = tc
    env["resid_commit"] = git_commit()
    stage2 = os.path.join(ROOT, "build", "boot", "stage2.bin")
    env["resid_stage2_sha256"] = sha256_file(stage2) if os.path.isfile(stage2) else "missing"
    env["python_harness"] = platform.python_version()
    ident = json.dumps({k: v for k, v in env.items() if k not in ("resid_commit",)}, sort_keys=True)
    env["env_id"] = hashlib.sha256(ident.encode()).hexdigest()[:12]
    env["date"] = now_iso()
    return env


def cmd_env(args):
    env = capture_env()
    write_json(os.path.join(args.results, "env.json"), env)
    log(f"env: {env['cpu_model']}, {env['cpu_threads']} threads, {env['ram_gib']} GiB, "
        f"governor {env['governor']}, env_id {env['env_id']}")
    return env


def ensure_env(args):
    env = load_json(os.path.join(args.results, "env.json"), None)
    if not env:
        env = cmd_env(args)
    return env


# ----------------------------------------------------------------------------
# build

def dir_bytes(path):
    total = 0
    for base, _dirs, files in os.walk(path):
        for fn in files:
            p = os.path.join(base, fn)
            if os.path.isfile(p) and not os.path.islink(p):
                total += os.path.getsize(p)
    return total


def build_cell(args, cell, builds):
    log_dir = os.path.join(args.results, "logs")
    os.makedirs(log_dir, exist_ok=True)
    log_path = os.path.join(log_dir, f"build-{cell.track}-{cell.bench}-{cell.lang}.log")
    out_dir = os.path.join(cell.dir, "out")
    shutil.rmtree(out_dir, ignore_errors=True)
    env = dict(os.environ, RESID_ROOT=ROOT)
    t0 = time.perf_counter_ns()
    try:
        p = subprocess.run(["bash", "build"], cwd=cell.dir, env=env, stdout=subprocess.PIPE,
                           stderr=subprocess.STDOUT, timeout=args.build_timeout,
                           start_new_session=True)
        rc, output = p.returncode, p.stdout
    except subprocess.TimeoutExpired as e:
        rc, output = "timeout", (e.stdout or b"") + b"\n[harness] build timed out\n"
    t1 = time.perf_counter_ns()
    with open(log_path, "wb") as f:
        f.write(output)
    rec = {"key": cell.key, "track": cell.track, "bench": cell.bench, "lang": cell.lang,
           "ok": rc == 0, "exit": rc, "build_s": round((t1 - t0) / 1e9, 4),
           "timestamp": now_iso(), "git_commit": args.git_commit,
           "source_sha256": cell.source_hash(), "log": os.path.relpath(log_path, args.results),
           "cmd": cell.cmd()}
    rec.update(cell.source_stats())
    rec["artifact_bytes"] = dir_bytes(out_dir) if os.path.isdir(out_dir) else 0
    argv = rec["cmd"]
    exe = None
    if argv and (argv[0].startswith("./out/") or argv[0].startswith("out/")):
        exe_path = os.path.join(cell.dir, argv[0])
        if os.path.isfile(exe_path):
            exe = os.path.getsize(exe_path)
    rec["exe_bytes"] = exe
    if rc != 0:
        rec["stderr_tail"] = output[-2000:].decode("utf-8", "replace")
    builds[cell.key] = rec
    write_json(os.path.join(args.results, "builds.json"), builds)
    status = "ok" if rc == 0 else f"FAILED ({rc})"
    log(f"build {cell.key}: {status} in {rec['build_s']:.2f} s")
    return rec


def needs_build(cell, builds):
    rec = builds.get(cell.key)
    if not rec or not rec.get("ok"):
        return True
    if rec.get("source_sha256") != cell.source_hash():
        return True
    argv = cell.cmd()
    if argv and argv[0].startswith(("./out/", "out/")) and not os.path.exists(os.path.join(cell.dir, argv[0])):
        return True
    return not os.path.isdir(os.path.join(cell.dir, "out"))


def cmd_build(args):
    builds = load_json(os.path.join(args.results, "builds.json"), {})
    cells = [c for c in all_cells(args.src, args.tracks, args.benches, args.langs) if c.runnable]
    if not cells:
        log("build: no runnable cells match")
    for c in cells:
        if args.force or not args.only_stale or needs_build(c, builds):
            build_cell(args, c, builds)
    return builds


# ----------------------------------------------------------------------------
# inputs

def input_path(args, n):
    return os.path.join(args.results, "inputs", f"fasta-{n}.txt")


def cmd_inputs(args, needed=None):
    fasta = Cell(args.src, REF_TRACK, "fasta", REF_LANG)
    manifest_path = os.path.join(args.results, "inputs.json")
    manifest = load_json(manifest_path, {})
    if needed is None:
        needed = sorted({n for b in STDIN_N for n in STDIN_N[b].values()}, key=int)
    if not fasta.runnable:
        log(f"inputs: reference generator {fasta.dir} missing; stdin benchmarks cannot run")
        return manifest
    builds = load_json(os.path.join(args.results, "builds.json"), {})
    src_hash = fasta.source_hash()
    for n in needed:
        path = input_path(args, n)
        m = manifest.get(n)
        if (m and os.path.isfile(path) and m.get("generator_sha256") == src_hash
                and os.path.getsize(path) == m.get("bytes") and sha256_file(path) == m.get("sha256")):
            continue
        if needs_build(fasta, builds):
            build_cell(args, fasta, builds)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        tmp = path + ".tmp"
        with open(tmp, "wb") as out:
            p = subprocess.run(fasta.cmd() + [n], cwd=fasta.dir, stdin=subprocess.DEVNULL,
                               stdout=out, stderr=subprocess.PIPE, timeout=3600)
        if p.returncode != 0:
            log(f"inputs: fasta {n} failed: {p.stderr[-500:]!r}")
            os.unlink(tmp)
            continue
        os.replace(tmp, path)
        manifest[n] = {"sha256": sha256_file(path), "bytes": os.path.getsize(path),
                       "generator": fasta.key, "generator_sha256": src_hash}
        write_json(manifest_path, manifest)
        log(f"inputs: fasta-{n}.txt {manifest[n]['bytes']} bytes sha256 {manifest[n]['sha256'][:16]}")
    return manifest



# ----------------------------------------------------------------------------
# memrun: tiny C launcher. ru_maxrss survives execve (Linux folds the old
# address space's high-water mark into the process's maxrss), so a child
# forked from the Python harness would report the harness's ~20 MB RSS as a
# floor. The harness therefore execs this small launcher, which forks and execs
# the benchmark and reports the grandchild's rusage and wall time.

MEMRUN_C = r"""
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>
int main(int argc, char **argv) {
    if (argc < 3) { fprintf(stderr, "usage: memrun RESULT argv...\n"); return 2; }
    struct timespec a, b;
    clock_gettime(CLOCK_MONOTONIC, &a);
    pid_t pid = fork();
    if (pid < 0) { perror("fork"); return 2; }
    if (pid == 0) {
        execvp(argv[2], argv + 2);
        fprintf(stderr, "[memrun] exec %s failed: %s\n", argv[2], strerror(errno));
        _exit(127);
    }
    int st; struct rusage ru;
    while (wait4(pid, &st, 0, &ru) < 0) { if (errno != EINTR) { perror("wait4"); return 2; } }
    clock_gettime(CLOCK_MONOTONIC, &b);
    long long ns = (long long)(b.tv_sec - a.tv_sec) * 1000000000LL + (b.tv_nsec - a.tv_nsec);
    FILE *f = fopen(argv[1], "w");
    if (!f) { perror("fopen"); return 2; }
    fprintf(f, "%lld %d %ld %ld %ld %ld %ld\n", ns, st,
            (long)ru.ru_utime.tv_sec, (long)ru.ru_utime.tv_usec,
            (long)ru.ru_stime.tv_sec, (long)ru.ru_stime.tv_usec, ru.ru_maxrss);
    fclose(f);
    return 0;
}
"""


def memrun_path(results):
    """Compile (once) and return the launcher path, or None if no C compiler."""
    tool_dir = os.path.join(results, "tools")
    digest = hashlib.sha256(MEMRUN_C.encode()).hexdigest()[:12]
    exe = os.path.join(tool_dir, f"memrun-{digest}")
    if os.path.isfile(exe):
        return exe
    os.makedirs(tool_dir, exist_ok=True)
    src = os.path.join(tool_dir, "memrun.c")
    with open(src, "w") as f:
        f.write(MEMRUN_C)
    for cc in ("cc", "gcc", "clang"):
        if shutil.which(cc):
            p = subprocess.run([cc, "-O2", "-o", exe, src], stdout=subprocess.PIPE,
                               stderr=subprocess.STDOUT)
            if p.returncode == 0:
                return exe
    log("warning: no C compiler for memrun; peak RSS will include the harness's fork footprint")
    return None


# ----------------------------------------------------------------------------
# run

def proc_tree_rss_kib(pid):
    """Sum VmRSS (KiB) over pid and all descendants."""
    total, stack, seen = 0, [pid], set()
    while stack:
        p = stack.pop()
        if p in seen:
            continue
        seen.add(p)
        st = read_text(f"/proc/{p}/status")
        if not st:
            continue
        for line in st.splitlines():
            if line.startswith("VmRSS:"):
                total += int(line.split()[1])
                break
        try:
            for tid in os.listdir(f"/proc/{p}/task"):
                ch = read_text(f"/proc/{p}/task/{tid}/children", "") or ""
                stack.extend(int(x) for x in ch.split())
        except OSError:
            pass
    return total


def measure(argv, cwd, stdin_path, stdout_path, stderr_path, timeout, mem_bytes, policy, cpus, env,
            memrun=None):
    def preexec():
        if cpus:
            os.sched_setaffinity(0, cpus)
        if policy == "rlimit" and mem_bytes:
            resource.setrlimit(resource.RLIMIT_AS, (mem_bytes, mem_bytes))

    fin = open(stdin_path or os.devnull, "rb")
    fout = open(stdout_path, "wb")
    ferr = open(stderr_path, "wb")
    killed = {"why": None}
    done = threading.Event()
    peak_poll = [0]
    res_file = stdout_path + ".rusage"
    real_argv = [memrun, res_file] + argv if memrun else argv
    t0 = time.perf_counter_ns()
    try:
        proc = subprocess.Popen(real_argv, cwd=cwd, stdin=fin, stdout=fout, stderr=ferr, env=env,
                                preexec_fn=preexec, start_new_session=True, close_fds=True)
    except OSError as e:
        for f in (fin, fout, ferr):
            f.close()
        with open(stderr_path, "a") as f:
            f.write(f"[harness] exec failed: {e}\n")
        return {"status": "error", "exit": None, "signal": None, "wall_s": 0.0, "user_s": 0.0,
                "sys_s": 0.0, "maxrss_kib": 0}
    pid = proc.pid

    def kill(why):
        if killed["why"] is None:
            killed["why"] = why
        try:
            os.killpg(pid, signal.SIGKILL)
        except OSError:
            pass

    def watchdog():
        deadline = time.monotonic() + timeout
        limit_kib = mem_bytes // 1024 if mem_bytes else 0
        while not done.is_set():
            if time.monotonic() >= deadline:
                kill("timeout")
                return
            if policy == "poll" and limit_kib:
                rss = proc_tree_rss_kib(pid)
                peak_poll[0] = max(peak_poll[0], rss)
                if rss > limit_kib:
                    kill("oom")
                    return
            done.wait(0.1 if policy == "poll" else 0.5)

    th = threading.Thread(target=watchdog, daemon=True)
    th.start()
    while True:
        try:
            _, status, ru = os.wait4(pid, 0)
            break
        except InterruptedError:
            continue
    t1 = time.perf_counter_ns()
    done.set()
    proc.returncode = status  # tell Popen the child is reaped
    try:
        os.killpg(pid, signal.SIGKILL)  # stray descendants
    except OSError:
        pass
    th.join()
    for f in (fin, fout, ferr):
        f.close()
    res = {"wall_s": (t1 - t0) / 1e9, "user_s": ru.ru_utime, "sys_s": ru.ru_stime,
           "maxrss_kib": max(ru.ru_maxrss, peak_poll[0]), "rss_method": "direct"}
    if memrun:
        line = (read_text(res_file, "") or "").split()
        if len(line) == 7 and os.WIFEXITED(status) and os.WEXITSTATUS(status) == 0:
            ns, status, us, uu, ss, su, rss = (int(v) for v in line)
            res.update({"wall_s": ns / 1e9, "user_s": us + uu / 1e6, "sys_s": ss + su / 1e6,
                        "maxrss_kib": max(rss, peak_poll[0]), "rss_method": "memrun"})
        else:
            res["rss_method"] = "memrun-killed"
        try:
            os.unlink(res_file)
        except OSError:
            pass
    if os.WIFEXITED(status):
        res["exit"], res["signal"] = os.WEXITSTATUS(status), None
    else:
        res["exit"], res["signal"] = None, os.WTERMSIG(status)
    if killed["why"]:
        res["status"] = killed["why"]
    elif res["exit"] == 0:
        res["status"] = "ok"
    else:
        tail = b""
        try:
            with open(stderr_path, "rb") as f:
                f.seek(max(0, os.path.getsize(stderr_path) - 65536))
                tail = f.read().lower()
        except OSError:
            pass
        res["status"] = "oom" if any(m.encode() in tail for m in OOM_MARKERS) else "error"
    return res


def reference_sums(runs):
    """(bench, size, input_sha256) -> stdout sha256 of the C st cell (latest batch)."""
    refs = {}
    for key, batch in latest_batches(runs).items():
        track, bench, lang, size = key
        if (track, lang) != (REF_TRACK, REF_LANG):
            continue
        for r in batch:
            if r.get("status") == "ok":
                refs[(bench, size, r.get("input_sha256"))] = r["stdout_sha256"]
                break
    return refs


def latest_batches(runs):
    """(track, bench, lang, size) -> list of runs of the most recent batch."""
    batches = {}
    for r in runs:
        key = (r["track"], r["bench"], r["lang"], r["size"])
        batches.setdefault(key, {}).setdefault(r["batch"], []).append(r)
    out = {}
    for key, bs in batches.items():
        best = max(bs.values(), key=lambda b: (b[0]["timestamp"], b[0]["batch"]))
        out[key] = sorted(best, key=lambda r: r["run_index"])
    return out


def batch_complete(batch, source_sha):
    if not batch or batch[0].get("source_sha256") != source_sha:
        return False
    last = batch[-1]
    return len(batch) >= last.get("planned", 1)


def parse_policy(spec):
    pol = dict(DEFAULT_MEM_POLICY)
    for item in (spec or "").split(","):
        if "=" in item:
            k, v = item.split("=", 1)
            if v.strip() not in ("rlimit", "poll", "none"):
                sys.exit(f"bad --mem-policy value {v!r} (rlimit|poll|none)")
            pol[k.strip()] = v.strip()
    return pol


def cmd_run(args, size=None):
    size = size or args.size
    env_rec = ensure_env(args)
    runs_path = os.path.join(args.results, "runs.jsonl")
    runs = load_jsonl(runs_path)
    builds = load_json(os.path.join(args.results, "builds.json"), {})
    policy = parse_policy(args.mem_policy)
    mem_bytes = int(args.mem_limit_gb * (1 << 30)) if args.mem_limit_gb > 0 else 0
    timeout = args.timeout or (1800 if size == "official" else 300)
    all_cpus = sorted(os.sched_getaffinity(0))
    memrun = memrun_path(args.results)
    log_dir = os.path.join(args.results, "logs")
    os.makedirs(log_dir, exist_ok=True)

    selected = [c for c in all_cells(args.src, args.tracks, args.benches, args.langs) if c.runnable]
    # The C st cell is the correctness reference: always run it first.
    plan = []
    for bench in args.benches:
        ref = Cell(args.src, REF_TRACK, bench, REF_LANG)
        if ref.runnable and not args.no_reference:
            plan.append(ref)
        plan.extend(c for c in selected if c.bench == bench and c.key != ref.key)
    plan.extend(c for c in selected if c.bench not in args.benches)

    needed_inputs = sorted({STDIN_N[c.bench][size] for c in plan if c.bench in STDIN_N}, key=int)
    inputs = cmd_inputs(args, needed_inputs) if needed_inputs else {}
    run_env = dict(os.environ, RESID_ROOT=ROOT)

    for cell in plan:
        key = (cell.track, cell.bench, cell.lang, size)
        src_sha = cell.source_hash()
        prev = latest_batches(runs).get(key)
        if not args.force and batch_complete(prev, src_sha):
            log(f"run {cell.key} [{size}]: already have {len(prev)} run(s), skipping")
            continue
        if needs_build(cell, builds):
            rec = build_cell(args, cell, builds)
            if not rec["ok"]:
                log(f"run {cell.key} [{size}]: build failed, skipping")
                continue
        argv = cell.cmd()
        if not argv:
            log(f"run {cell.key}: empty cmd, skipping")
            continue
        argv = argv + [SIZE_ARG[cell.bench][size]]
        stdin_path, input_sha = None, None
        if cell.bench in STDIN_N:
            n = STDIN_N[cell.bench][size]
            stdin_path = input_path(args, n)
            if not os.path.isfile(stdin_path):
                log(f"run {cell.key} [{size}]: input fasta-{n} unavailable, skipping")
                continue
            input_sha = inputs.get(n, {}).get("sha256")
        cpus = {args.core} if cell.track == "st" else set(all_cpus)
        pol = policy.get(cell.lang, "rlimit")
        refs = reference_sums(runs)
        batch_id = hashlib.sha256(f"{cell.key}|{size}|{time.time_ns()}".encode()).hexdigest()[:12]
        planned = args.runs
        i = 0
        while i < planned:
            with tempfile.NamedTemporaryFile(dir=args.tmpdir, delete=False, prefix="bench-out-") as tf:
                out_path = tf.name
            err_path = out_path + ".err"
            m = measure(argv, cell.dir, stdin_path, out_path, err_path, timeout, mem_bytes,
                        pol, cpus, run_env, memrun)
            digest = sha256_file(out_path)
            out_bytes = os.path.getsize(out_path)
            ref = refs.get((cell.bench, size, input_sha))
            if m["status"] != "ok":
                verdict = "n/a"
            elif (cell.track, cell.lang) == (REF_TRACK, REF_LANG):
                verdict = "reference"
            elif ref is None:
                verdict = "no-reference"
            else:
                verdict = "ok" if ref == digest else "mismatch"
            stem = f"run-{cell.track}-{cell.bench}-{cell.lang}-{size}"
            if verdict == "mismatch":
                with open(out_path, "rb") as f, open(os.path.join(log_dir, stem + ".mismatch.out"), "wb") as g:
                    g.write(f.read(4096))
            with open(err_path, "rb") as f:
                f.seek(max(0, os.path.getsize(err_path) - 4096))
                err_tail = f.read()
            if err_tail or m["status"] != "ok":
                with open(os.path.join(log_dir, stem + ".stderr"), "wb") as g:
                    g.write(err_tail)
            os.unlink(out_path)
            os.unlink(err_path)
            if i == 0 and m["status"] == "ok":
                if m["wall_s"] > 300:
                    planned = 1
                elif m["wall_s"] > 60:
                    planned = min(planned, 3)
            if m["status"] != "ok":
                planned = i + 1  # do not repeat a failing configuration
            cpu = m["user_s"] + m["sys_s"]
            rec = {"timestamp": now_iso(), "git_commit": args.git_commit,
                   "env_id": env_rec.get("env_id"), "batch": batch_id, "run_index": i,
                   "planned": planned, "track": cell.track, "bench": cell.bench,
                   "lang": cell.lang, "size": size, "size_arg": argv[-1],
                   "argv": argv, "input_sha256": input_sha, "source_sha256": src_sha,
                   "status": m["status"], "exit": m["exit"], "signal": m["signal"],
                   "wall_s": round(m["wall_s"], 6), "user_s": round(m["user_s"], 6),
                   "sys_s": round(m["sys_s"], 6), "cpu_s": round(cpu, 6),
                   "cpu_util": round(cpu / m["wall_s"], 4) if m["wall_s"] > 0 else None,
                   "maxrss_kib": m["maxrss_kib"], "stdout_bytes": out_bytes,
                   "stdout_sha256": digest, "verdict": verdict, "mem_policy": pol, "rss_method": m.get("rss_method"),
                   "mem_limit_bytes": mem_bytes, "timeout_s": timeout,
                   "cpus": sorted(cpus) if cell.track == "st" else "all"}
            with open(runs_path, "a", encoding="utf-8") as f:
                f.write(json.dumps(rec, sort_keys=True) + "\n")
            runs.append(rec)
            log(f"run {cell.key} [{size}] #{i + 1}/{planned}: {m['status']} {verdict} "
                f"wall {m['wall_s']:.3f} s cpu {cpu:.3f} s rss {m['maxrss_kib'] / 1024:.1f} MiB")
            i += 1


# ----------------------------------------------------------------------------
# statistics

def median(xs):
    s = sorted(xs)
    n = len(s)
    if n == 0:
        return None
    return s[n // 2] if n % 2 else (s[n // 2 - 1] + s[n // 2]) / 2


def stdev(xs):
    n = len(xs)
    if n < 2:
        return 0.0
    m = sum(xs) / n
    return math.sqrt(sum((x - m) ** 2 for x in xs) / (n - 1))


def bootstrap_ci(xs, reps=2000, seed=20260925):
    if len(xs) < 2:
        return (None, None)
    rng = random.Random(seed)
    n = len(xs)
    meds = sorted(median([xs[rng.randrange(n)] for _ in range(n)]) for _ in range(reps))
    return (meds[int(0.025 * reps)], meds[min(reps - 1, int(0.975 * reps))])


def geomean(xs):
    xs = [x for x in xs if x and x > 0]
    if not xs:
        return None
    return math.exp(sum(math.log(x) for x in xs) / len(xs))


# ----------------------------------------------------------------------------
# aggregation

STATUS_LABEL = {"ok": "ok", "unverified": "ok (unverified)", "na": "N/A",
                "missing": "missing", "build-failed": "build failed", "not-run": "not run",
                "timeout": "timeout", "oom": "OOM", "error": "error", "mismatch": "mismatch"}
COMPLETED = ("ok", "unverified")


def aggregate(src, runs, builds):
    refs = reference_sums(runs)
    batches = latest_batches(runs)
    agg = {}
    for cell in all_cells(src):
        build = builds.get(cell.key)
        for size in SIZES:
            key = (cell.track, cell.bench, cell.lang, size)
            a = {"track": cell.track, "bench": cell.bench, "lang": cell.lang, "size": size,
                 "runs": 0}
            batch = batches.get(key, [])
            if not cell.exists:
                a["status"] = "missing"
            elif cell.is_na:
                a["status"] = "na"
            elif not cell.runnable:
                a["status"] = "missing"
            elif build and not build.get("ok") and not batch:
                a["status"] = "build-failed"
            elif not batch:
                a["status"] = "not-run"
            else:
                verdicts = []
                for r in batch:
                    if r["status"] != "ok":
                        verdicts.append("n/a")
                    elif (r["track"], r["lang"]) == (REF_TRACK, REF_LANG):
                        verdicts.append("reference")
                    else:
                        ref = refs.get((r["bench"], size, r.get("input_sha256")))
                        verdicts.append("no-reference" if ref is None else
                                        ("ok" if ref == r["stdout_sha256"] else "mismatch"))
                statuses = [r["status"] for r in batch]
                okruns = [r for r, v in zip(batch, verdicts) if r["status"] == "ok" and v != "mismatch"]
                if "timeout" in statuses:
                    a["status"] = "timeout"
                elif "oom" in statuses:
                    a["status"] = "oom"
                elif "error" in statuses:
                    a["status"] = "error"
                elif "mismatch" in verdicts:
                    a["status"] = "mismatch"
                elif "no-reference" in verdicts:
                    a["status"] = "unverified"
                else:
                    a["status"] = "ok"
                a["runs"] = len(batch)
                a["timestamp"] = batch[-1]["timestamp"]
                a["git_commit"] = batch[0].get("git_commit")
                a["stale"] = batch[0].get("source_sha256") != cell.source_hash()
                if batch[0].get("status") != "ok":
                    a["fail_wall_s"] = batch[0]["wall_s"]
                if a["status"] in COMPLETED and okruns:
                    walls = [r["wall_s"] for r in okruns]
                    cpus = [r["cpu_s"] for r in okruns]
                    rss = [r["maxrss_kib"] for r in okruns]
                    lo, hi = bootstrap_ci(walls)
                    a.update({
                        "n_ok": len(okruns), "wall_median": median(walls), "wall_min": min(walls),
                        "wall_max": max(walls), "wall_mean": sum(walls) / len(walls),
                        "wall_stdev": stdev(walls), "ci_lo": lo, "ci_hi": hi,
                        "user_median": median([r["user_s"] for r in okruns]),
                        "sys_median": median([r["sys_s"] for r in okruns]),
                        "cpu_median": median(cpus), "rss_median_kib": median(rss),
                        "rss_max_kib": max(rss)})
                    a["wall_cv"] = a["wall_stdev"] / a["wall_mean"] if a["wall_mean"] else 0.0
                    a["cpu_util"] = a["cpu_median"] / a["wall_median"] if a["wall_median"] else None
            if build:
                for k in ("build_s", "artifact_bytes", "exe_bytes", "source_bytes",
                          "source_lines", "source_gzip_bytes"):
                    a[k] = build.get(k)
                a["build_ok"] = build.get("ok")
            elif cell.runnable:
                a.update(cell.source_stats())
                a.pop("source_files", None)
            agg[key] = a
    # ratios vs C of the same track and size, and ranks
    for (track, bench, lang, size), a in agg.items():
        c = agg.get((track, bench, "c", size))
        if a["status"] in COMPLETED and c and c["status"] in COMPLETED and "wall_median" in a and "wall_median" in c:
            a["ratio_wall"] = a["wall_median"] / c["wall_median"] if c["wall_median"] else None
            a["ratio_cpu"] = a["cpu_median"] / c["cpu_median"] if c["cpu_median"] else None
            a["ratio_mem"] = a["rss_median_kib"] / c["rss_median_kib"] if c["rss_median_kib"] else None
    for track in TRACKS:
        for bench in BENCHES:
            for size in SIZES:
                done = sorted((agg[(track, bench, l, size)] for l in LANGS
                               if agg[(track, bench, l, size)].get("wall_median") is not None),
                              key=lambda a: (a["wall_median"], LANGS.index(a["lang"])))
                for i, a in enumerate(done):
                    a["rank"] = i + 1
    return agg


def ranking(agg, track, size, field="ratio_wall"):
    """Two geomean variants. Returns (common_benches, compared_langs, rows)."""
    base = [b for b in BENCHES if agg[(track, b, "c", size)].get(field) is not None]
    per = {}
    for l in LANGS:
        vals = {b: agg[(track, b, l, size)].get(field) for b in base}
        per[l] = {b: v for b, v in vals.items() if v is not None}
    need = max(1, math.ceil(len(base) / 2))
    compared = [l for l in LANGS if len(per[l]) >= need]
    common = [b for b in base if all(b in per[l] for l in compared)]
    rows = []
    for l in LANGS:
        own = geomean(list(per[l].values()))
        com = geomean([per[l][b] for b in common]) if l in compared and common else None
        rows.append({"lang": l, "common": com, "own": own, "n_own": len(per[l]),
                     "n_base": len(base)})
    return base, common, compared, rows


# ----------------------------------------------------------------------------
# formatting

DASH = "—"


def f_time(x):
    if x is None:
        return DASH
    if x >= 100:
        return f"{x:.1f}"
    if x >= 10:
        return f"{x:.2f}"
    return f"{x:.3f}"


def f_ratio(x):
    if x is None:
        return DASH
    if x >= 100:
        return f"{x:.0f}"
    if x >= 10:
        return f"{x:.1f}"
    return f"{x:.2f}"


def f_mib(kib):
    if kib is None:
        return DASH
    m = kib / 1024
    return f"{m:.0f}" if m >= 100 else f"{m:.1f}"


def f_int(x):
    return DASH if x is None else f"{int(x):,}"


def f_bytes(x):
    if x is None:
        return DASH
    if x >= 1 << 20:
        return f"{x / (1 << 20):.1f} MiB"
    if x >= 1024:
        return f"{x / 1024:.1f} KiB"
    return f"{int(x)} B"


def f_pct(x):
    return DASH if x is None else f"{x * 100:.0f}%"


def md_table(header, rows, align=None):
    align = align or ["l"] + ["r"] * (len(header) - 1)
    sep = ["---:" if a == "r" else ":---:" if a == "c" else "---" for a in align]
    lines = ["| " + " | ".join(header) + " |", "| " + " | ".join(sep) + " |"]
    for r in rows:
        lines.append("| " + " | ".join(str(c).replace("|", "\\|").replace("\n", " ") for c in r) + " |")
    return "\n".join(lines)


def first_paragraph(text, limit=400):
    if not text:
        return ""
    lines = []
    for line in text.strip().splitlines():
        if not line.strip():
            if lines:
                break
            continue
        if line.lstrip().startswith("#") and not lines:
            continue
        lines.append(line.strip())
    p = " ".join(lines)
    return p if len(p) <= limit else p[:limit - 1].rstrip() + "…"


def status_cell(a):
    s = STATUS_LABEL[a["status"]]
    if a.get("stale"):
        s += " (stale)"
    return s


# ----------------------------------------------------------------------------
# SVG charts (hand written; explicit white background, dark grey text)

SVG_BG = "#ffffff"
SVG_TEXT = "#1f2937"
SVG_MUTED = "#6b7280"
SVG_GRID = "#e5e7eb"
SVG_AXIS = "#9ca3af"
COL_RESID = "#d97706"
COL_C = "#2563eb"
COL_OTHER = "#94a3b8"
FONT = "font-family=\"Helvetica, Arial, sans-serif\""


def esc(s):
    return (str(s).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
            .replace('"', "&quot;"))


def lang_color(lang):
    return COL_RESID if lang == "resid" else COL_C if lang == "c" else COL_OTHER


def log_ticks(lo, hi):
    ticks = []
    e = math.floor(math.log10(lo))
    while 10 ** e <= hi * 1.0001:
        for m in (1, 2, 5):
            v = m * 10 ** e
            if lo * 0.9999 <= v <= hi * 1.0001:
                ticks.append(v)
        e += 1
    return ticks


def tick_label(v):
    if v >= 1:
        return f"{v:g}×"
    return f"{v:g}×"


def svg_hbar(title, subtitle, items, xlabel):
    """items: list of (label, value or None, color, annotation). Log scale, bars from 1."""
    vals = [v for _, v, _, _ in items if v]
    width, left, right, top, row = 760, 120, 90, 58, 24
    height = top + row * max(1, len(items)) + 46
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" '
           f'viewBox="0 0 {width} {height}" {FONT} font-size="12">',
           f'<rect x="0" y="0" width="{width}" height="{height}" fill="{SVG_BG}"/>',
           f'<text x="16" y="22" font-size="15" font-weight="bold" fill="{SVG_TEXT}">{esc(title)}</text>',
           f'<text x="16" y="40" fill="{SVG_MUTED}">{esc(subtitle)}</text>']
    if not vals:
        out.append(f'<text x="{left}" y="{top + 16}" fill="{SVG_MUTED}">no completed results</text>')
        out.append("</svg>")
        return "\n".join(out) + "\n"
    lo = 10 ** math.floor(math.log10(min(min(vals), 1.0)))
    hi = 10 ** math.ceil(math.log10(max(max(vals), 1.0)))
    if hi <= lo:
        hi = lo * 10
    if hi / lo < 10:
        hi = lo * 10
    plot_w = width - left - right

    def x(v):
        return left + plot_w * (math.log10(v) - math.log10(lo)) / (math.log10(hi) - math.log10(lo))

    bottom = top + row * len(items)
    for t in log_ticks(lo, hi):
        xt = x(t)
        major = abs(math.log10(t) - round(math.log10(t))) < 1e-9
        out.append(f'<line x1="{xt:.1f}" y1="{top - 4}" x2="{xt:.1f}" y2="{bottom}" '
                   f'stroke="{SVG_GRID if not major else "#d1d5db"}" stroke-width="1"/>')
        if major or hi / lo <= 100:
            out.append(f'<text x="{xt:.1f}" y="{bottom + 16}" text-anchor="middle" '
                       f'fill="{SVG_MUTED}" font-size="11">{esc(tick_label(t))}</text>')
    x1 = x(1.0)
    for i, (label, v, color, ann) in enumerate(items):
        y = top + i * row
        out.append(f'<text x="{left - 8}" y="{y + row / 2 + 4:.1f}" text-anchor="end" '
                   f'fill="{SVG_TEXT}">{esc(label)}</text>')
        if v:
            xv = x(v)
            xa, xb = min(x1, xv), max(x1, xv)
            out.append(f'<rect x="{xa:.1f}" y="{y + 4}" width="{max(xb - xa, 1.5):.1f}" '
                       f'height="{row - 8}" fill="{color}"/>')
            out.append(f'<text x="{max(xb, x1) + 5:.1f}" y="{y + row / 2 + 4:.1f}" '
                       f'fill="{SVG_TEXT}" font-size="11">{esc(ann)}</text>')
        else:
            out.append(f'<text x="{x1 + 5:.1f}" y="{y + row / 2 + 4:.1f}" '
                       f'fill="{SVG_MUTED}" font-size="11">{esc(ann)}</text>')
    out.append(f'<line x1="{x1:.1f}" y1="{top - 6}" x2="{x1:.1f}" y2="{bottom + 2}" '
               f'stroke="{SVG_TEXT}" stroke-width="1.5"/>')
    out.append(f'<text x="{left + plot_w / 2:.1f}" y="{bottom + 34}" text-anchor="middle" '
               f'fill="{SVG_MUTED}">{esc(xlabel)}</text>')
    out.append("</svg>")
    return "\n".join(out) + "\n"


def heat_color(r):
    """log-diverging: r<1 blue, r=1 near white, r>1 orange/red, saturating at 1/8 and 128."""
    if r is None:
        return "#f3f4f6"
    t = math.log2(r)
    if t <= 0:
        k = min(1.0, -t / 3.0)
        a, b = (0xf7, 0xf7, 0xf7), (0x21, 0x66, 0xac)
    else:
        k = min(1.0, t / 7.0)
        a, b = (0xf7, 0xf7, 0xf7), (0xb2, 0x18, 0x2b)
    c = tuple(round(a[i] + (b[i] - a[i]) * k) for i in range(3))
    return "#%02x%02x%02x" % c


def text_on(hexcol):
    r, g, b = (int(hexcol[i:i + 2], 16) for i in (1, 3, 5))
    lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
    return "#ffffff" if lum < 140 else SVG_TEXT


def svg_heatmap(title, subtitle, rows, cols, cell):
    """cell(row, col) -> (ratio or None, text)."""
    cw, ch, left, top = 74, 26, 110, 92
    width = left + cw * len(cols) + 90
    height = top + ch * len(rows) + 56
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" '
           f'viewBox="0 0 {width} {height}" {FONT} font-size="11">',
           f'<rect x="0" y="0" width="{width}" height="{height}" fill="{SVG_BG}"/>',
           f'<text x="16" y="22" font-size="15" font-weight="bold" fill="{SVG_TEXT}">{esc(title)}</text>',
           f'<text x="16" y="40" font-size="12" fill="{SVG_MUTED}">{esc(subtitle)}</text>']
    for j, c in enumerate(cols):
        cx = left + j * cw + cw / 2
        out.append(f'<text x="{cx:.1f}" y="{top - 8}" text-anchor="start" fill="{SVG_TEXT}" '
                   f'transform="rotate(-30 {cx:.1f} {top - 8})">{esc(c)}</text>')
    for i, r in enumerate(rows):
        y = top + i * ch
        out.append(f'<text x="{left - 8}" y="{y + ch / 2 + 4:.1f}" text-anchor="end" '
                   f'fill="{SVG_TEXT}" font-size="12">{esc(LANG_NAMES.get(r, r))}</text>')
        for j, c in enumerate(cols):
            v, txt = cell(r, c)
            col = heat_color(v)
            x = left + j * cw
            out.append(f'<rect x="{x}" y="{y}" width="{cw - 2}" height="{ch - 2}" fill="{col}"/>')
            out.append(f'<text x="{x + (cw - 2) / 2:.1f}" y="{y + ch / 2 + 3:.1f}" '
                       f'text-anchor="middle" fill="{text_on(col) if v else SVG_MUTED}">{esc(txt)}</text>')
    # legend
    ly = top + ch * len(rows) + 18
    stops = [0.125, 0.25, 0.5, 1, 2, 4, 8, 16, 32, 64, 128]
    lw = 40
    for k, s in enumerate(stops):
        col = heat_color(s)
        out.append(f'<rect x="{left + k * lw}" y="{ly}" width="{lw}" height="12" fill="{col}"/>')
        out.append(f'<text x="{left + k * lw + lw / 2}" y="{ly + 26}" text-anchor="middle" '
                   f'fill="{SVG_MUTED}" font-size="10">{s:g}×</text>')
    out.append(f'<text x="{left - 8}" y="{ly + 10}" text-anchor="end" fill="{SVG_MUTED}" '
               f'font-size="10">vs C</text>')
    out.append("</svg>")
    return "\n".join(out) + "\n"


# ----------------------------------------------------------------------------
# report

def extract_flags(cell):
    """Compiler/interpreter invocation lines from a build script, for the flags table."""
    text = read_text(os.path.join(cell.dir, "build"), "") or ""
    keep = []
    for line in text.splitlines():
        s = line.strip()
        if (not s or s.startswith("#") or s.startswith("set ") or s.startswith("mkdir")
                or s.startswith("cd ") or s in ("fi", "then", "else", "done", "}", "{")
                or s.startswith(("echo", "if ", "rm ", "cp ", "ROOT=", "RESID_ROOT=", "export ", ": \"${"))):
            continue
        keep.append(s)
    return " ; ".join(keep)


def cmd_report(args):
    res = args.results
    env = load_json(os.path.join(res, "env.json"), {})
    builds = load_json(os.path.join(res, "builds.json"), {})
    inputs = load_json(os.path.join(res, "inputs.json"), {})
    runs = load_jsonl(os.path.join(res, "runs.jsonl"))
    agg = aggregate(args.src, runs, builds)
    docs = args.docs
    chart_dir = os.path.join(docs, "benchmarks")
    os.makedirs(chart_dir, exist_ok=True)
    for fn in os.listdir(chart_dir):
        if fn.endswith(".svg"):
            os.unlink(os.path.join(chart_dir, fn))
    charts = {}

    def chart(name, svg):
        with open(os.path.join(chart_dir, name), "w", encoding="utf-8") as f:
            f.write(svg)
        charts[name] = True
        return f"benchmarks/{name}"

    have = {(t, s) for (t, b, l, s), a in agg.items() if a.get("wall_median") is not None}
    md = []
    W = md.append

    # ---------------- title & abstract
    W("# Resid cross-language benchmarks")
    W("")
    W("*Generated by `bench/suite/bench.py report` from `bench/suite/results/`. "
      "Do not edit by hand; rerun the generator.*")
    W("")
    W("## Abstract")
    W("")
    n_cells = sum(1 for c in all_cells(args.src) if c.runnable)
    n_na = sum(1 for c in all_cells(args.src) if c.is_na)
    n_runs = len(runs)
    abstract = (f"We compare the Resid compiler against {len(LANGS) - 1} other languages "
                f"(C, C++, Rust, Go, Java, C#, JavaScript, Python, Fortran, Pascal) on the "
                f"{len(BENCHES)} programs of the Computer Language Benchmarks Game, in two tracks: "
                f"a single-threaded same-algorithm track (`st`) and a fastest-known-program track "
                f"(`best`). The suite currently holds {n_cells} runnable program cells and "
                f"{n_na} cell(s) declared not applicable; {n_runs} timed process executions are "
                f"recorded. Every program output is checked byte-for-byte against the C `st` "
                f"reference. Times are wall-clock medians of cold process runs; languages are "
                f"aggregated by the geometric mean of their time ratio to C.")
    W(abstract)
    W("")
    for track in TRACKS:
        for size in SIZES:
            if (track, size) not in have:
                continue
            base, common, compared, rows = ranking(agg, track, size)
            r = next(x for x in rows if x["lang"] == "resid")
            if r["own"] is not None:
                W(f"- **{track}, {size}**: Resid geometric-mean wall-time ratio to C is "
                  f"**{f_ratio(r['own'])}×** over its {r['n_own']} completed benchmark(s)"
                  + (f"; {f_ratio(r['common'])}× over the {len(common)} benchmark(s) all compared "
                     f"languages completed." if r["common"] is not None else "."))
    W("")
    W("Contents: [Environment](#environment) · [Methodology](#methodology) · "
      "[Overall ranking](#overall-ranking) · [Matrices](#matrices) · "
      "[Resid versus other languages](#resid-versus-other-languages) · "
      "[Per-benchmark results](#per-benchmark-results) · [Coverage](#coverage) · "
      "[Appendix](#appendix-cell-notes-and-provenance)")
    W("")

    # ---------------- environment
    W("## Environment")
    W("")
    if env:
        tc = env.get("toolchains", {})
        core_mhz = env.get("cpu_max_mhz_per_cpu", {}).get(str(args.core))
        rows = [("CPU", env.get("cpu_model", DASH)),
                ("Cores / threads", f"{env.get('cpu_cores', DASH)} / {env.get('cpu_threads', DASH)}"),
                ("SMT active", env.get("smt_active", DASH)),
                ("Max clock", f"{float(env.get('cpu_max_mhz') or 0):.0f} MHz"
                 + (f" (pinned core {args.core}: {core_mhz} MHz)" if core_mhz else "")),
                ("Frequency boost", env.get("boost", DASH)),
                ("RAM", f"{env.get('ram_gib', DASH)} GiB"),
                ("Kernel", env.get("kernel", DASH)),
                ("CPU governor", env.get("governor", DASH)),
                ("Transparent huge pages", env.get("thp", DASH)),
                ("Resid commit", f"`{env.get('resid_commit', DASH)}`"),
                ("stage2.bin sha256", f"`{env.get('resid_stage2_sha256', DASH)}`"),
                ("Environment id", f"`{env.get('env_id', DASH)}`"),
                ("Captured", env.get("date", DASH))]
        W(md_table(["Item", "Value"], rows, ["l", "l"]))
        W("")
        freqs = env.get("cpu_max_mhz_per_cpu", {})
        if freqs and len(set(freqs.values())) > 1:
            groups = {}
            for cpu_id, mhz in freqs.items():
                groups.setdefault(mhz, []).append(int(cpu_id))
            desc = "; ".join(f"{mhz} MHz: CPUs {','.join(map(str, sorted(ids)))}"
                             for mhz, ids in sorted(groups.items(), reverse=True))
            W(f"The CPU is heterogeneous (per-CPU maximum clocks differ: {desc}). The `st` track "
              f"is pinned to CPU {args.core}; `best` programs run on all CPUs, mixing core types.")
            W("")
        W(md_table(["Toolchain", "Version"], [(k, f"`{v}`") for k, v in sorted(tc.items())], ["l", "l"]))
    else:
        W("No `results/env.json` yet; run `bench.py env`.")
    W("")

    # ---------------- methodology
    W("## Methodology")
    W("")
    W("### Tracks and fairness rules")
    W("")
    W("- **`st` (single-thread, same algorithm).** Every language implements the algorithm "
      "described by the Benchmarks Game for that program, single-threaded, without SIMD "
      "intrinsics, inline assembly or `-march=native`, using the standard release optimisation "
      "level of its toolchain. Bignum and regex benchmarks use the language's standard or "
      "customary library (GMP for C/C++/Fortran/Pascal, PCRE2 for C/C++). Processes are pinned "
      f"to one CPU (CPU {args.core}) with `sched_setaffinity`.")
    W("- **`best` (fastest known program).** The fastest program known for the language, "
      "adapted from the Benchmarks Game (3-clause BSD); multithreading, SIMD and "
      "`-O3 -march=native` are allowed. Processes may use every CPU.")
    W("- Program cells live in `bench/suite/src/<track>/<bench>/<lang>/`, each with a `build` "
      "script, a one-line `cmd`, optional `NOTES.md` (deviations, provenance, licence) or an `NA` "
      "file explaining why the cell cannot exist. See `bench/suite/CONTRACT.md`.")
    W("")
    W("### Compiler flags per language")
    W("")
    policy = {"resid": "`stage2.bin -O2` (default)", "c": "`gcc -O2`", "cpp": "`g++ -O2`",
              "rust": "`rustc -C opt-level=3` / cargo `--release`", "go": "`go build` (default)",
              "java": "HotSpot defaults", "csharp": "`dotnet` Release", "javascript": "`node`",
              "python": "CPython `python3`", "fortran": "`gfortran -O2`", "pascal": "`fpc -O2`"}
    frows = []
    for l in LANGS:
        ex = {}
        for t in TRACKS:
            for b in BENCHES:
                c = Cell(args.src, t, b, l)
                if c.runnable:
                    fl = extract_flags(c) or ("run: " + " ".join(c.cmd()))
                    ex[t] = f"`{fl[:160]}` ({b})"
                    break
        frows.append((LANG_NAMES[l], policy[l], ex.get("st", DASH), ex.get("best", DASH)))
    W(md_table(["Language", "`st` policy", "`st` example build", "`best` example build"],
               frows, ["l", "l", "l", "l"]))
    W("")
    W("Exact commands for every cell are in its `build` script; the per-cell notes in the appendix "
      "record deviations.")
    W("")
    W("### Problem sizes")
    W("")
    srows = []
    for b in BENCHES:
        stdin = (f"fasta output, N = {STDIN_N[b]['official']} / {STDIN_N[b]['small']}"
                 if b in STDIN_N else DASH)
        srows.append((f"`{b}`", SIZE_ARG[b]["official"], SIZE_ARG[b]["small"], stdin))
    W(md_table(["Benchmark", "official", "small", "stdin input (official / small)"], srows,
               ["l", "r", "r", "l"]))
    W("")
    if inputs:
        W(md_table(["Input", "Bytes", "sha256"],
                   [(f"`fasta-{n}.txt`", f_int(v.get("bytes")), f"`{v.get('sha256', '')[:16]}…`")
                    for n, v in sorted(inputs.items(), key=lambda kv: int(kv[0]))], ["l", "r", "l"]))
        W("")
    W("### Measurement procedure")
    W("")
    W("- Each run is a fresh (cold) process: no warm-up run, no in-process repetition, like the "
      "Benchmarks Game. Every run is recorded; none is discarded.")
    W("- The harness execs `cmd` plus the size argument directly (no shell), with cwd = cell "
      "directory, stdin from the generated input file (or `/dev/null`) and stdout to a temporary "
      "file. Wall time is `time.perf_counter_ns()` around fork/exec and `os.wait4`; user and "
      "system CPU time and peak resident set size (`ru_maxrss`) come from the `rusage` returned "
      "by `wait4`. CPU utilisation = (user + sys) / wall; values above 100% indicate parallelism.")
    W("- Runs per cell: 5 by default; if the first run takes more than 60 s, 3 in total; if more "
      "than 300 s, only 1. A failing run (timeout, OOM, non-zero exit) is not repeated.")
    W("- Limits: a wall-clock timeout (default 1800 s official, 300 s small) kills the process "
      "group. Memory is limited to 16 GiB: via `RLIMIT_AS` for native languages; managed runtimes "
      "that reserve large virtual ranges (Java, C#, JavaScript) instead have their process-tree "
      "RSS polled from `/proc` every 100 ms and are killed when over the limit. A non-zero exit "
      "whose stderr mentions an allocation failure is classified as OOM.")
    W("- Correctness: the sha256 of stdout is compared with the C `st` program's output for the "
      "same benchmark, size and input. Mismatching cells are excluded from all aggregates.")
    W("- Build time is measured cold with respect to the cell (`out/` removed first), but "
      "toolchain-level caches (Go build cache, NuGet, Cargo registry) are warm.")
    W("- Source size is the gzip -9 compressed size of the concatenated source files of the cell "
      "(build scripts, `cmd`, notes and project boilerplate excluded), as on the Benchmarks Game.")
    W("")
    W("### Statistics")
    W("")
    W("- Per cell: median, minimum, maximum, mean, sample standard deviation and coefficient of "
      "variation (stdev / mean) of wall time over the successful runs of the latest batch.")
    W("- 95% confidence interval of the median: percentile bootstrap, 2000 resamples, fixed "
      "seed 20260925 (so regeneration is deterministic). With 5 runs the interval is coarse; "
      "with one run no interval is given.")
    W("- Ratios are median / median of the C program of the same track and size. Aggregation "
      "across benchmarks uses the geometric mean of ratios, so C = 1.00 by construction.")
    W("- Two geometric means are reported. **Common set**: only benchmarks that every compared "
      "language completed (a language is compared if it completed at least half of the "
      "benchmarks that C completed); this is the like-for-like figure. **Own set**: each "
      "language over all benchmarks it completed; not comparable across languages with different "
      "coverage and labelled with its benchmark count.")
    W("- N/A, missing, build-failure, timeout, OOM, error and mismatch results are shown as "
      f"`{DASH}` in matrices with the status in the per-benchmark tables, and never enter an "
      "aggregate. A cell whose source changed after its runs is marked *stale*.")
    W("")
    W("### Threats to validity")
    W("")
    W("- Single machine, single OS; results do not transfer to other micro-architectures. The "
      "CPU runs with frequency boost, so clock speed depends on temperature and load.")
    W("- The pinned `st` CPU's SMT sibling is not isolated and background processes are not "
      "stopped; the coefficient of variation is reported so noisy cells are visible.")
    W("- Cold-process timing includes runtime start-up and JIT warm-up for Java, C#, JavaScript "
      "and interpreter start-up for Python; this is intended (whole-program cost) but penalises "
      "managed runtimes on the small sizes.")
    W("- Peak RSS for polled runtimes is the maximum of `ru_maxrss` and the 100 ms RSS samples; "
      "`ru_maxrss` is per process (maximum over waited-for descendants, not their sum).")
    W("- Program quality differs between languages; `best` programs come from different authors "
      "with different amounts of tuning effort, and `st` ports may be more or less idiomatic.")
    W("- Output files are written to a temporary directory (tmpfs on this host), so I/O-heavy "
      "benchmarks (fasta, reverse-complement, mandelbrot) measure memory-backed writes.")
    W("")

    # ---------------- overall ranking
    W("## Overall ranking")
    W("")
    for track in TRACKS:
        for size in SIZES:
            W(f"### {track} — {size}")
            W("")
            if (track, size) not in have:
                W("No completed runs yet.")
                W("")
                continue
            for field, what in (("ratio_wall", "wall time"), ("ratio_cpu", "CPU time"),
                                ("ratio_mem", "peak RSS")):
                base, common, compared, rows = ranking(agg, track, size, field)
                rows = sorted(rows, key=lambda r: (r["common"] is None, r["common"] or 0,
                                                   r["own"] is None, r["own"] or 0,
                                                   LANGS.index(r["lang"])))
                W(f"**Geometric mean of {what} ratio to C.** Common set ({len(common)} benchmark(s)): "
                  + (", ".join(f"`{b}`" for b in common) if common else "empty") + ".")
                W("")
                trows = []
                rank = 0
                for r in rows:
                    rank += r["common"] is not None
                    trows.append((rank if r["common"] is not None else DASH, LANG_NAMES[r["lang"]],
                                  f_ratio(r["common"]), f_ratio(r["own"]),
                                  f"{r['n_own']}/{r['n_base']}"))
                W(md_table(["#", "Language", "geomean (common set)", "geomean (own set)",
                            "completed"], trows, ["r", "l", "r", "r", "r"]))
                W("")
                if field == "ratio_wall":
                    items = [(LANG_NAMES[r["lang"]], r["common"] if common else r["own"],
                              lang_color(r["lang"]),
                              f_ratio(r["common"] if common else r["own"]) + "×"
                              if (r["common"] if common else r["own"]) else "not ranked")
                             for r in rows]
                    p = chart(f"geomean-{track}-{size}.svg", svg_hbar(
                        f"Geometric mean wall-time ratio to C — {track}, {size}",
                        (f"common set of {len(common)} benchmarks" if common else "own set per language")
                        + "; lower is faster; log scale", items, "ratio to C (C = 1)"))
                    W(f"![geomean {track} {size}]({p})")
                    W("")
                if field == "ratio_mem":
                    items = [(LANG_NAMES[r["lang"]], r["common"] if common else r["own"],
                              lang_color(r["lang"]),
                              f_ratio(r["common"] if common else r["own"]) + "×"
                              if (r["common"] if common else r["own"]) else "not ranked")
                             for r in rows]
                    p = chart(f"memory-{track}-{size}.svg", svg_hbar(
                        f"Geometric mean peak-RSS ratio to C — {track}, {size}",
                        (f"common set of {len(common)} benchmarks" if common else "own set per language")
                        + "; lower uses less memory; log scale", items, "peak RSS ratio to C (C = 1)"))
                    W(f"![memory {track} {size}]({p})")
                    W("")

    # ---------------- matrices
    W("## Matrices")
    W("")
    W(f"Rows are languages, columns benchmarks. `{DASH}` = no completed result "
      "(see [Coverage](#coverage)).")
    W("")
    short = {b: b for b in BENCHES}

    def matrix(track, size, fn):
        rows = []
        for l in LANGS:
            rows.append([LANG_NAMES[l]] + [fn(agg[(track, b, l, size)]) for b in BENCHES])
        return md_table(["Language"] + [f"`{short[b]}`" for b in BENCHES], rows)

    for track in TRACKS:
        for size in SIZES:
            if (track, size) not in have:
                continue
            W(f"### {track} — {size}")
            W("")
            W("**Wall-time ratio to C** (median / C median)")
            W("")
            W(matrix(track, size, lambda a: f_ratio(a.get("ratio_wall"))))
            W("")
            p = chart(f"heatmap-{track}-{size}.svg", svg_heatmap(
                f"Wall-time ratio to C — {track}, {size}",
                "blue = faster than C, red = slower; grey = no result",
                LANGS, BENCHES,
                lambda l, b: (agg[(track, b, l, size)].get("ratio_wall"),
                              f_ratio(agg[(track, b, l, size)].get("ratio_wall")))))
            W(f"![heatmap {track} {size}]({p})")
            W("")
            W("**CPU-time ratio to C** (user + sys)")
            W("")
            W(matrix(track, size, lambda a: f_ratio(a.get("ratio_cpu"))))
            W("")
            W("**Peak-memory ratio to C** (peak RSS)")
            W("")
            W(matrix(track, size, lambda a: f_ratio(a.get("ratio_mem"))))
            W("")
            W("**Median wall time (s)**")
            W("")
            W(matrix(track, size, lambda a: f_time(a.get("wall_median"))))
            W("")
    for track in TRACKS:
        W(f"### {track} — source and build")
        W("")
        W("**Gzipped source size (bytes)**")
        W("")
        W(matrix(track, "official", lambda a: f_int(a.get("source_gzip_bytes"))
                 if a["status"] not in ("na", "missing") else DASH))
        W("")
        W("**Cold build time (s)**")
        W("")
        W(matrix(track, "official", lambda a: f_time(a.get("build_s")) if a.get("build_ok") else DASH))
        W("")
        W("**Main executable size** (only when `cmd` runs `./out/…`; otherwise total `out/` size in italics)")
        W("")

        def binsize(a):
            if not a.get("build_ok"):
                return DASH
            if a.get("exe_bytes") is not None:
                return f_bytes(a["exe_bytes"])
            return f"*{f_bytes(a.get('artifact_bytes'))}*"
        W(matrix(track, "official", binsize))
        W("")

    # ---------------- resid section
    W("## Resid versus other languages")
    W("")
    W("Each entry is Resid median wall time divided by the other language's median wall time "
      "for the same track, benchmark and size: **below 1.00 Resid is faster**, above 1.00 it is "
      "slower. The geometric mean is over benchmarks both completed.")
    W("")
    for track in TRACKS:
        for size in SIZES:
            if (track, size) not in have:
                continue
            W(f"### {track} — {size}")
            W("")
            trows = []
            for l in LANGS:
                if l == "resid":
                    continue
                cells_ = []
                vals = []
                wins = losses = 0
                for b in BENCHES:
                    ra = agg[(track, b, "resid", size)].get("wall_median")
                    rb = agg[(track, b, l, size)].get("wall_median")
                    if ra and rb:
                        v = ra / rb
                        vals.append(v)
                        wins += v < 1
                        losses += v >= 1
                        cells_.append(("**" + f_ratio(v) + "**") if v < 1 else f_ratio(v))
                    else:
                        cells_.append(DASH)
                gm = geomean(vals)
                trows.append([LANG_NAMES[l]] + cells_ + [f_ratio(gm), f"{wins}/{losses}"])
            W(md_table(["vs"] + [f"`{b}`" for b in BENCHES] + ["geomean", "wins/losses"], trows))
            W("")
            wins_list = []
            loss_list = []
            for l in LANGS:
                if l == "resid":
                    continue
                for b in BENCHES:
                    ra = agg[(track, b, "resid", size)].get("wall_median")
                    rb = agg[(track, b, l, size)].get("wall_median")
                    if ra and rb:
                        (wins_list if ra < rb else loss_list).append((ra / rb, LANG_NAMES[l], b))
            if wins_list:
                best = sorted(wins_list)[:5]
                W("Largest Resid wins: " + "; ".join(f"`{b}` vs {n} ({f_ratio(v)}×)" for v, n, b in best) + ".")
                W("")
            if loss_list:
                worst = sorted(loss_list, reverse=True)[:5]
                W("Largest Resid losses: " + "; ".join(f"`{b}` vs {n} ({f_ratio(v)}×)" for v, n, b in worst) + ".")
                W("")
    W("### Resid cells without a result")
    W("")
    prob = []
    for track in TRACKS:
        for b in BENCHES:
            cell = Cell(args.src, track, b, "resid")
            sts = {s: agg[(track, b, "resid", s)]["status"] for s in SIZES}
            bad = {s: st for s, st in sts.items() if st not in COMPLETED}
            if not bad:
                continue
            if cell.is_na:
                reason = first_paragraph(cell.na_reason(), 600)
            elif not cell.exists or not cell.runnable:
                reason = "no cell yet"
            else:
                reason = first_paragraph(cell.notes(), 400)
                for s_, st in bad.items():
                    if st in ("timeout", "oom", "error", "mismatch"):
                        errp = os.path.join(res, "logs", f"run-{track}-{b}-resid-{s_}.stderr")
                        last = [ln for ln in (read_text(errp, "") or "").splitlines() if ln.strip()]
                        hint = f"{s_} stderr: `{last[-1][:160]}`" if last else f"{s_}: see `results/logs/`"
                        reason = (reason + " " if reason else "") + hint + "."
                if any(st == "build-failed" for st in bad.values()):
                    tail = (builds.get(cell.key, {}).get("stderr_tail") or "").strip().splitlines()
                    if tail:
                        reason = f"build failed: `{tail[-1][:200]}`. " + reason
            what = ", ".join(f"{s}: {STATUS_LABEL[st]}" for s, st in bad.items())
            prob.append((track, f"`{b}`", what, reason))
    W(md_table(["Track", "Benchmark", "Status", "Reason"], prob, ["l", "l", "l", "l"])
      if prob else "Resid completed every benchmark in both tracks and sizes.")
    W("")

    # ---------------- per benchmark
    W("## Per-benchmark results")
    W("")
    W("Wall time is the median with its 95% bootstrap CI in brackets; CPU is median user + sys; "
      "util = CPU / wall; RSS is median peak resident set size; ratio is wall-time ratio to C "
      "of the same track; CV is the coefficient of variation of wall time.")
    W("")
    for b in BENCHES:
        W(f"### {b}")
        W("")
        for track in TRACKS:
            for size in SIZES:
                rows_a = [agg[(track, b, l, size)] for l in LANGS]
                if all(a["status"] in ("missing", "not-run") for a in rows_a):
                    continue
                W(f"**{track}, {size}** (argument `{SIZE_ARG[b][size]}`"
                  + (f", stdin fasta N = {STDIN_N[b][size]}" if b in STDIN_N else "") + ")")
                W("")
                rows_a = sorted(rows_a, key=lambda a: (a.get("rank") is None, a.get("rank") or 0,
                                                       LANGS.index(a["lang"])))
                trows = []
                for a in rows_a:
                    if a.get("wall_median") is not None:
                        ci = (f" [{f_time(a['ci_lo'])}–{f_time(a['ci_hi'])}]"
                              if a.get("ci_lo") is not None else "")
                        trows.append((a.get("rank"), LANG_NAMES[a["lang"]],
                                      f_time(a["wall_median"]) + ci, f_time(a["cpu_median"]),
                                      f_pct(a["cpu_util"]), f_mib(a["rss_median_kib"]),
                                      f_ratio(a.get("ratio_wall")), f_pct(a["wall_cv"]),
                                      f"{a['n_ok']}/{a['runs']}", status_cell(a)))
                    else:
                        extra = ""
                        if a["status"] == "timeout" and a.get("fail_wall_s"):
                            extra = f" after {f_time(a['fail_wall_s'])} s"
                        trows.append((DASH, LANG_NAMES[a["lang"]], DASH, DASH, DASH, DASH, DASH,
                                      DASH, f"0/{a['runs']}" if a["runs"] else DASH,
                                      status_cell(a) + extra))
                W(md_table(["#", "Language", "wall s [95% CI]", "CPU s", "util", "RSS MiB",
                            "vs C", "CV", "runs", "status"], trows,
                           ["r", "l", "r", "r", "r", "r", "r", "r", "r", "l"]))
                W("")
                if any(a.get("wall_median") is not None for a in rows_a):
                    items = []
                    for l in LANGS:
                        a = agg[(track, b, l, size)]
                        r = a.get("ratio_wall")
                        items.append((LANG_NAMES[l], r, lang_color(l),
                                      f"{f_ratio(r)}×  ({f_time(a['wall_median'])} s)" if r
                                      else STATUS_LABEL[a["status"]] if a.get("wall_median") is None
                                      else f"{f_time(a['wall_median'])} s, no C baseline"))
                    p = chart(f"wall-{track}-{size}-{b}.svg", svg_hbar(
                        f"{b} — {track}, {size}", "wall-time ratio to C; lower is faster; log scale",
                        items, "ratio to C (C = 1)"))
                    W(f"![{b} {track} {size}]({p})")
                    W("")

    # ---------------- coverage
    W("## Coverage")
    W("")
    W("Cell status per track (official size). `ok` = verified output; `N/A` = the cell has an "
      "`NA` file; `missing` = no cell yet.")
    W("")
    abbrev = {"ok": "ok", "unverified": "ok?", "na": "N/A", "missing": DASH, "build-failed": "build✗",
              "not-run": "not run", "timeout": "timeout", "oom": "OOM", "error": "error",
              "mismatch": "mismatch"}
    for track in TRACKS:
        for size in SIZES:
            W(f"**{track}, {size}**")
            W("")
            W(matrix(track, size, lambda a: abbrev[a["status"]] + ("*" if a.get("stale") else "")))
            W("")
    miss = [(t, b, l) for (t, b, l, s), a in sorted(agg.items(),
            key=lambda kv: (TRACKS.index(kv[0][0]), BENCHES.index(kv[0][1]), LANGS.index(kv[0][2])))
            if s == "official" and a["status"] == "missing"]
    if miss:
        W(f"Missing cells ({len(miss)}): " + ", ".join(f"`{t}/{b}/{l}`" for t, b, l in miss) + ".")
        W("")
    W("`ok?` = completed but no C reference output to verify against; `*` = stale (source changed "
      "after the runs).")
    W("")

    # ---------------- appendix
    W("## Appendix: cell notes and provenance")
    W("")
    any_notes = False
    for track in TRACKS:
        for b in BENCHES:
            for l in LANGS:
                c = Cell(args.src, track, b, l)
                if not c.exists:
                    continue
                if c.is_na:
                    any_notes = True
                    W(f"<details><summary><code>{c.key}</code> — N/A</summary>")
                    W("")
                    W(c.na_reason())
                    W("")
                    W("</details>")
                    W("")
                elif c.notes():
                    any_notes = True
                    W(f"<details><summary><code>{c.key}</code></summary>")
                    W("")
                    notes = c.notes()
                    # demote headings so they do not break the document outline
                    notes = "\n".join(("####" + ln.lstrip("#")) if ln.startswith("#") else ln
                                      for ln in notes.splitlines())
                    W(notes)
                    W("")
                    W("</details>")
                    W("")
    if not any_notes:
        W("No cell has notes yet.")
        W("")
    W("## Appendix: reproduction")
    W("")
    W("```sh")
    W("cd bench/suite")
    W("./bench.py env                       # capture environment -> results/env.json")
    W("./bench.py build                     # cold-build every cell -> results/builds.json")
    W("./bench.py inputs                    # generate fasta stdin inputs (C st fasta)")
    W("./bench.py run --size small          # quick pass")
    W("./bench.py run --size official       # full pass (hours)")
    W("./bench.py report                    # regenerate docs/BENCHMARKS.md and charts")
    W("./bench.py all                       # everything above in order")
    W("./bench.py run --track st --bench nbody --lang resid,c --size small --force")
    W("```")
    W("")
    W("Raw data: [`benchmarks/runs.csv`](benchmarks/runs.csv) (every run), "
      "[`benchmarks/results.csv`](benchmarks/results.csv) (aggregates). Git commits of the runs: "
      + (", ".join(f"`{c}`" for c in sorted({r.get('git_commit', '?') for r in runs})) or DASH) + ".")
    W("")

    text = "\n".join(md).rstrip() + "\n"
    with open(os.path.join(docs, "BENCHMARKS.md"), "w", encoding="utf-8") as f:
        f.write(text)

    # CSVs
    fields = ["track", "size", "bench", "lang", "status", "stale", "runs", "n_ok", "rank",
              "wall_median", "wall_min", "wall_max", "wall_mean", "wall_stdev", "wall_cv",
              "ci_lo", "ci_hi", "user_median", "sys_median", "cpu_median", "cpu_util",
              "rss_median_kib", "rss_max_kib", "ratio_wall", "ratio_cpu", "ratio_mem",
              "build_s", "artifact_bytes", "exe_bytes", "source_bytes", "source_lines",
              "source_gzip_bytes"]

    def fmt(v):
        if v is None:
            return ""
        if isinstance(v, bool):
            return "1" if v else "0"
        if isinstance(v, float):
            return f"{v:.6f}"
        return str(v)

    with open(os.path.join(chart_dir, "results.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(fields)
        for t in TRACKS:
            for s in SIZES:
                for b in BENCHES:
                    for l in LANGS:
                        a = agg[(t, b, l, s)]
                        w.writerow([fmt(a.get(k)) for k in fields])
    rfields = ["timestamp", "git_commit", "env_id", "batch", "run_index", "track", "bench",
               "lang", "size", "size_arg", "status", "exit", "signal", "verdict", "wall_s",
               "user_s", "sys_s", "cpu_s", "cpu_util", "maxrss_kib", "stdout_bytes",
               "stdout_sha256", "input_sha256", "source_sha256", "mem_policy", "timeout_s"]
    with open(os.path.join(chart_dir, "runs.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(rfields)
        for r in runs:
            w.writerow([fmt(r.get(k)) for k in rfields])
    log(f"report: wrote {os.path.join(docs, 'BENCHMARKS.md')} and {len(charts)} chart(s)")


# ----------------------------------------------------------------------------
# CLI

def cmd_all(args):
    cmd_env(args)
    cmd_build(args)
    cmd_inputs(args)
    cmd_run(args, "small")
    cmd_run(args, "official")
    cmd_report(args)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--src", default=os.path.join(SUITE, "src"), help="cell tree root")
    ap.add_argument("--results", default=os.path.join(SUITE, "results"), help="results directory")
    ap.add_argument("--docs", default=os.path.join(ROOT, "docs"), help="report output directory")
    ap.add_argument("--core", type=int, default=2, help="CPU for the st track (default 2)")
    sub = ap.add_subparsers(dest="cmd", required=True)

    def filters(p):
        p.add_argument("--track", help="comma list (st,best)")
        p.add_argument("--bench", help="comma list of benchmarks")
        p.add_argument("--lang", help="comma list of languages")
        p.add_argument("--force", action="store_true")
        p.add_argument("--build-timeout", type=int, default=1800)

    def runopts(p):
        p.add_argument("--runs", type=int, default=5)
        p.add_argument("--timeout", type=int, default=0,
                       help="seconds per run (default 1800 official, 300 small)")
        p.add_argument("--mem-limit-gb", type=float, default=16.0)
        p.add_argument("--mem-policy", default="",
                       help="per-language overrides, e.g. go=poll,java=rlimit (rlimit|poll|none)")
        p.add_argument("--tmpdir", default=None, help="where stdout temp files go")
        p.add_argument("--no-reference", action="store_true",
                       help="do not automatically run the C st reference cell")

    sub.add_parser("env")
    p = sub.add_parser("build")
    filters(p)
    p.add_argument("--only-stale", action="store_true", help="skip cells whose build is current")
    sub.add_parser("inputs")
    p = sub.add_parser("run")
    filters(p)
    runopts(p)
    p.add_argument("--size", choices=SIZES, default="small")
    sub.add_parser("report")
    p = sub.add_parser("all")
    filters(p)
    runopts(p)
    p.set_defaults(only_stale=False)

    args = ap.parse_args(argv)
    args.src = os.path.abspath(args.src)
    args.results = os.path.abspath(args.results)
    args.docs = os.path.abspath(args.docs)
    args.tracks = split_list(getattr(args, "track", None), TRACKS)
    args.benches = split_list(getattr(args, "bench", None), BENCHES)
    args.langs = split_list(getattr(args, "lang", None), LANGS)
    for name, vals, uni in (("track", args.tracks, TRACKS), ("bench", args.benches, BENCHES),
                            ("lang", args.langs, LANGS)):
        bad = [v for v in vals if v not in uni]
        if bad:
            sys.exit(f"unknown {name}: {', '.join(bad)}")
    for k, v in (("force", False), ("build_timeout", 1800), ("only_stale", False)):
        if not hasattr(args, k):
            setattr(args, k, v)
    args.git_commit = git_commit()
    os.makedirs(args.results, exist_ok=True)
    {"env": cmd_env, "build": cmd_build, "inputs": cmd_inputs, "run": cmd_run,
     "report": cmd_report, "all": cmd_all}[args.cmd](args)


if __name__ == "__main__":
    main()
