#!/usr/bin/env python3
"""Run each implementation at each N, reporting wall time and peak RSS.

Usage: bench/strcat/run.py [N ...]  (a run over TIMEOUT seconds is cut off)
"""
import os, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
TIMEOUT = float(os.environ.get("TIMEOUT", "30"))
IMPLS = [
    ("resid", [os.path.join(HERE, "out", "strcat_resid")]),
    ("c (immutable)", [os.path.join(HERE, "out", "strcat_c")]),
    ("rust", [os.path.join(HERE, "out", "strcat_rs")]),
    ("go", [os.path.join(HERE, "out", "strcat_go")]),
    ("node", ["node", os.path.join(HERE, "strcat.js")]),
    ("python", ["python3", os.path.join(HERE, "strcat.py")]),
    ("ruby", ["ruby", os.path.join(HERE, "strcat.rb")]),
    ("luajit", ["luajit", os.path.join(HERE, "strcat.lua")]),
]

def measure(cmd, n):
    t0 = time.monotonic()
    p = subprocess.Popen(cmd + [str(n)], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    deadline = t0 + TIMEOUT
    while True:
        pid, status, ru = os.wait4(p.pid, os.WNOHANG)
        if pid:
            break
        if time.monotonic() > deadline:
            p.kill()
            os.wait4(p.pid, 0)
            return None
        time.sleep(0.005)
    dt = time.monotonic() - t0
    out = p.stdout.read().decode().strip()
    if status != 0:
        return ("crash", dt, ru.ru_maxrss // 1024, out)
    return ("ok", dt, ru.ru_maxrss // 1024, out)

ns = [int(a) for a in sys.argv[1:]] or [10000, 50000, 100000, 1000000]
print(f"{'impl':<15}" + "".join(f"{n:>22}" for n in ns))
for name, cmd in IMPLS:
    if not os.path.exists(cmd[-1]):
        continue
    row = f"{name:<15}"
    for n in ns:
        r = measure(cmd, n)
        if r is None:
            cell = f">{TIMEOUT:.0f}s"
        elif r[0] == "crash":
            cell = f"crash {r[2]}MB"
        else:
            cell = f"{r[1]:.3f}s {r[2]}MB"
        row += f"{cell:>22}"
    print(row, flush=True)
