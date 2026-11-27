#!/usr/bin/env bash
# Runtime unit tests: each C file links the Resid runtime (build/boot/rt.ll)
# and checks one property directly (immediate boxes, the capability guard, UTF-8 bounds);
# term/ checks buffered stdin and lib/readline.resid on a pty;
# rt/primitives.resid checks the runtime primitives; and lib/ and tools/
# must not use any compiler internal.
set -uo pipefail
cd "$(dirname "$0")"
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT
pass=0; fail=0
ROOT="$(cd ../.. && pwd)"
for t in *.c; do
    n="${t%.c}"
    # With the Resid runtime's IR: part of the runtime lives there.
    if clang -O2 -w "$t" "$ROOT/build/boot/rt.ll" -Wno-override-module -o "$W/$n" -lm -lpthread 2> "$W/$n.log" && "$W/$n" > "$W/$n.out" 2>&1; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL $n: $(tail -2 "$W/$n.log" "$W/$n.out" 2>/dev/null | tr '\n' ' ')"
    fi
done
# Runtime primitives compile only in runtime/rt/ (or the compiler's own
# sources) with --runtime-internals.
COMPILER="${COMPILER:-$ROOT/build/boot/stage2.bin}"
for t in rt/*.out; do
    n="$(basename "$t" .out)"
    if (cd "$ROOT" && "$COMPILER" "tests/runtime/rt/$n.resid" -o "$W/rt_$n" --runtime-internals) > "$W/rt_$n.log" 2>&1 && "$W/rt_$n" > "$W/rt_$n.out" 2>&1 && cmp -s "$W/rt_$n.out" "$t"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL rt/$n: $(grep -m1 -i error "$W/rt_$n.log")"
    fi
done
# A lib/ file imported by an allowed entry still may not use internals.
(cd "$ROOT" && "$COMPILER" tests/runtime/rt/uses_lib.resid -o "$W/ul" --runtime-internals) > "$W/ul.log" 2>&1
if grep -q "E0220.*resid_raw_load64" "$W/ul.log"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL a lib/ file used an internal"
fi
# Nor may a file the entry reaches outside its own runtime/rt/ or compiler/
# tree: through "..", or under another directory of those names.
mkdir -p "$W/ri/a/runtime/rt" "$W/ri/b/compiler" "$W/ri/b/runtime/rt"
printf 'pub Int sneaky(Int x) { return resid_raw_load64(x); }\n' > "$W/ri/b/compiler/z.resid"
cp "$W/ri/b/compiler/z.resid" "$W/ri/b/runtime/rt/z.resid"
printf 'import "../../../b/compiler/z.resid";\nInt main() { return sneaky(0); }\n' > "$W/ri/a/runtime/rt/x.resid"
printf 'import "../../../b/runtime/rt/z.resid";\nInt main() { return sneaky(0); }\n' > "$W/ri/a/runtime/rt/y.resid"
ri_ok=1
for e in x y; do
    (cd "$ROOT" && "$COMPILER" "$W/ri/a/runtime/rt/$e.resid" -o "$W/ri/$e" --runtime-internals) > "$W/ri_$e.log" 2>&1
    grep -q "E0220.*resid_raw_load64" "$W/ri_$e.log" || ri_ok=0
done
if [ "$ri_ok" = 1 ]; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL a file outside the entry's tree used an internal"; fi
# The standard library and the tools never name a compiler internal.
if grep -nE 'resid_raw_|resid_(arena|bulk)_(push|pop)|resid_list_str_persist_copy|resid_dec_persist|resid_internals|resid_rtmod|@export\(|@import\(' "$ROOT"/lib/*.resid "$ROOT"/tools/*.resid > "$W/lint.out"; then
    fail=$((fail + 1)); echo "FAIL internals outside the compiler: $(head -1 "$W/lint.out")"
else
    pass=$((pass + 1))
fi
# A native module (spec §47) is bound by a program or package, never by
# the standard library, the tools or the runtime (E0232); and lib/ and
# tools/ name no native family.
mkdir -p "$W/nat/lib" "$W/nat/tools" "$W/nat/runtime/rt"
printf '@link("tiny")\npub Int tiny_add(Int a, Int b) {}\n' > "$W/nat/lib/bind.resid"
printf 'import "lib/bind.resid";\n@requires(native_tiny)\nInt main() { return tiny_add(1, 2); }\n' > "$W/nat/main.resid"
printf '@link("tiny")\nInt tiny_add(Int a, Int b) {}\nInt main() { return 0; }\n' > "$W/nat/tools/t.resid"
nat_ok=1
(cd "$ROOT" && "$COMPILER" "$W/nat/main.resid" -o "$W/nat/m") > "$W/nat1.log" 2>&1; grep -q "E0232" "$W/nat1.log" || nat_ok=0
(cd "$ROOT" && "$COMPILER" "$W/nat/tools/t.resid" -o "$W/nat/t") > "$W/nat2.log" 2>&1; grep -q "E0232" "$W/nat2.log" || nat_ok=0
cp "$W/nat/tools/t.resid" "$W/nat/runtime/rt/x.resid"
(cd "$ROOT" && "$COMPILER" "$W/nat/runtime/rt/x.resid" --runtime-module -o "$W/nat/r") > "$W/nat3.log" 2>&1; grep -q "E0232" "$W/nat3.log" || nat_ok=0
grep -nE '@link\(|@requires\([^)]*native_' "$ROOT"/lib/*.resid "$ROOT"/tools/*.resid > "$W/natlint.out" && nat_ok=0
if [ "$nat_ok" = 1 ]; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL @link outside a program was not refused (E0232): $(grep -h -m1 -i error "$W"/nat*.log | head -1) $(head -1 "$W/natlint.out")"; fi

# The display transport (runtime/rt/unix.resid): a Unix socket pair, bytes
# and descriptors over it, a shared mapping through its handle, and the
# same descriptors pollable under `display` alone.
if (cd "$ROOT" && "$COMPILER" tests/runtime/display.resid -o "$W/display") > "$W/display.log" 2>&1; then
    "$W/display" > "$W/display.out" 2>&1
    run_rc=$?
    if [ $run_rc -eq 0 ] && cmp -s "$W/display.out" display.out; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL display transport: $(grep -m1 -i error "$W/display.log") $(diff "$W/display.out" display.out 2>/dev/null | head -3 | tr '
' ' ')"
    fi
else
    fail=$((fail + 1)); echo "FAIL display transport: $(grep -m1 -i error "$W/display.log") $(diff "$W/display.out" display.out 2>/dev/null | head -3 | tr '
' ' ')"
fi
# Unix-domain sockets (resid_unix_*): the behaviour one process can see
# (unixsock.resid), then a server against python3: its socket is 0600 in a
# 0700 directory, a foreign client is served and its uid read, and the file
# is gone after close. Listening needs a `network` write.
mkdir -m 700 "$W/ux"; mkdir -m 755 "$W/uxloose"; touch "$W/ux/plain"
python3 -I -c "import socket,sys; socket.socket(socket.AF_UNIX).bind(sys.argv[1])" "$W/ux/stale.sock"
if (cd "$ROOT" && "$COMPILER" tests/runtime/unixsock.resid -o "$W/unixsock") > "$W/unixsock.log" 2>&1 \
    && UX_DIR="$W/ux" UX_LOOSE="$W/uxloose" timeout 30 "$W/unixsock" > "$W/unixsock.out" 2>&1 && cmp -s "$W/unixsock.out" unixsock.out; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL unix sockets: $(grep -m1 -i error "$W/unixsock.log") $(diff "$W/unixsock.out" unixsock.out 2>/dev/null | head -3 | tr '\n' ' ')"
fi
# A deadline past the socket's 30 s default (io_dl): a receive under a 45 s
# deadline waits for bytes a client sends 32 s after connecting (about 33 s).
mkdir -m 700 "$W/uxlate"
if (cd "$ROOT" && "$COMPILER" tests/runtime/long_deadline.resid -o "$W/long_deadline") > "$W/long_deadline.log" 2>&1; then
    python3 -I long_deadline_client.py "$W/uxlate/late.sock" & LDC=$!
    UX_DIR="$W/uxlate" timeout 60 "$W/long_deadline" > "$W/long_deadline.out" 2>&1
    wait $LDC 2>/dev/null
fi
if [ "$(cat "$W/long_deadline.out" 2>/dev/null)" = "$(printf 'listen true\naccepted true\nreceived 5 bytes after more than 30 s: true')" ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL a deadline past 30 s: $(grep -m1 -i error "$W/long_deadline.log") $(tr '\n' ' ' < "$W/long_deadline.out" 2>/dev/null)"
fi
# The same on AArch64, under qemu-user (skipped without it): the runtime
# reads stat buffers by architecture, and a wrong offset there refuses every
# directory (the owner was read from st_nlink, so Android could not listen).
if command -v qemu-aarch64 > /dev/null; then
    rm -rf "$W/ux" "$W/uxloose"; mkdir -m 700 "$W/ux"; mkdir -m 755 "$W/uxloose"; touch "$W/ux/plain"
    python3 -I -c "import socket,sys; socket.socket(socket.AF_UNIX).bind(sys.argv[1])" "$W/ux/stale.sock"
    if (cd "$ROOT" && "$COMPILER" tests/runtime/unixsock.resid --target aarch64 -o "$W/unixsock-a64") > "$W/unixsock-a64.log" 2>&1 \
        && UX_DIR="$W/ux" UX_LOOSE="$W/uxloose" timeout 60 qemu-aarch64 "$W/unixsock-a64" > "$W/unixsock-a64.out" 2>&1 && cmp -s "$W/unixsock-a64.out" unixsock.out; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL unix sockets on aarch64: $(grep -m1 -i error "$W/unixsock-a64.log") $(diff "$W/unixsock-a64.out" unixsock.out 2>/dev/null | head -3 | tr '\n' ' ')"
    fi
    rm -rf "$W/ux" "$W/uxloose"; mkdir -m 700 "$W/ux"; mkdir -m 755 "$W/uxloose"; touch "$W/ux/plain"
    python3 -I -c "import socket,sys; socket.socket(socket.AF_UNIX).bind(sys.argv[1])" "$W/ux/stale.sock"
else
    echo "skip unix sockets on aarch64: no qemu-aarch64"
fi
ux_ok=0
if (cd "$ROOT" && "$COMPILER" tests/runtime/unixsock_serve.resid -o "$W/uxserve") > "$W/uxserve.log" 2>&1; then
    mkfifo "$W/uxready"
    UX_PATH="$W/ux/s/serve.sock" timeout 20 "$W/uxserve" > "$W/uxready" 2>&1 &
    uxpid=$!
    read -r line < "$W/uxready" || true
    exec 7< "$W/uxready"
    if [ "$line" = ready ] && [ "$(stat -c %a "$W/ux/s")" = 700 ] && [ "$(stat -c %a "$W/ux/s/serve.sock")" = 600 ] \
        && [ "$(python3 -I -c 'import socket,sys; s=socket.socket(socket.AF_UNIX); s.connect(sys.argv[1]); s.sendall(b"hi\x00\xff"); print(s.recv(16).hex())' "$W/ux/s/serve.sock")" = 686900ff ]; then
        wait "$uxpid" && read -r line2 <&7 && [ "$line2" = "peer uid $(id -u)" ] && [ ! -e "$W/ux/s/serve.sock" ] && ux_ok=1
    fi
    exec 7<&-
fi
printf '@requires(network(readonly))\nInt main() { return resid_unix_listen("/tmp/x/y.sock"); }\n' > "$W/uxro.resid"
(cd "$ROOT" && "$COMPILER" "$W/uxro.resid" -o "$W/uxro") > "$W/uxro.log" 2>&1
grep -q "E0219" "$W/uxro.log" || ux_ok=0
if [ "$ux_ok" = 1 ]; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL unix socket server: $(grep -m1 -i error "$W/uxserve.log" "$W/uxro.log")"; fi
# Name lookup with RESID_RESOLV_CONF in place of /etc/resolv.conf, and its
# search domains (dns_search.resid), against dns_fake.py on port 53 of a
# loopback of its own: a user and network namespace (skipped without one).
if unshare -rn true 2> /dev/null; then
    if (cd "$ROOT" && "$COMPILER" tests/runtime/dns_search.resid -o "$W/dns_search") > "$W/dns.log" 2>&1 \
        && unshare -rn sh -c '
            ip link set lo up || exit 1
            python3 -I "$1" 20 > "$2/dns_q.log" 2>&1 & p=$!
            n=0; until grep -q ready "$2/dns_q.log" || [ $n -ge 50 ]; do sleep 0.1; n=$((n + 1)); done
            RESID_RESOLV_CONF="$(printf "nameserver 127.0.0.1\nsearch first.test second.test")" timeout 30 "$2/dns_search"
            r=$?; kill $p 2> /dev/null; exit $r' _ "$PWD/dns_fake.py" "$W" > "$W/dns.out" 2>&1 \
        && [ "$(cat "$W/dns.out")" = "true true true true" ] \
        && grep -qx "pylonhost.first.test 1" "$W/dns_q.log" && grep -qx "nohost 1" "$W/dns_q.log" \
        && ! grep -q "pylonhost.second.first.test" "$W/dns_q.log"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL RESID_RESOLV_CONF lookup: $(grep -m1 -i error "$W/dns.log") $(tr '\n' ' ' < "$W/dns.out")"
    fi
else
    echo "skip RESID_RESOLV_CONF lookup: no user and network namespace"
fi
# With no display named in the environment, connecting is refused rather
# than guessed at.
printf '@requires(display)
Int main() { return if (resid_disp_connect() < 0) { 0 } else { 1 }; }
' > "$W/nodisplay.resid"
if (cd "$ROOT" && "$COMPILER" "$W/nodisplay.resid" -o "$W/nodisplay") > "$W/nodisplay.log" 2>&1     && env -u DISPLAY -u WAYLAND_DISPLAY -u WAYLAND_SOCKET -u XDG_RUNTIME_DIR "$W/nodisplay"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL display connect with no display: $(grep -m1 -i error "$W/nodisplay.log")"
fi
# A display socket the launcher passes (RSP_SOCKET) is adopted at startup
# and made close-on-exec; a number that named nothing at startup, later
# taken by the PTY broker, is not a display (display_inherit.py).
if command -v python3 > /dev/null; then
    if (cd "$ROOT" && "$COMPILER" tests/runtime/display_inherit.resid -o "$W/dinh") > "$W/dinh.log" 2>&1 \
        && { python3 display_inherit.py "$W/dinh" pass; python3 display_inherit.py "$W/dinh" stale; } > "$W/dinh.out" 2>&1 \
        && cmp -s "$W/dinh.out" display_inherit.out; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL inherited display socket: $(grep -m1 -i error "$W/dinh.log") $(diff "$W/dinh.out" display_inherit.out 2>/dev/null | head -4 | tr '\n' ' ')"
    fi
fi
# `residc test`: the generated test entry point is a complete process.
if (cd "$ROOT" && "$COMPILER" test examples/math_test.resid) > "$W/tm.log" 2>&1 && grep -q "Failures: 0 | Passed: 6" "$W/tm.log"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL residc test: $(grep -v '^OK' "$W/tm.log" | tail -2 | tr '\n' ' ')"
fi
# Buffered stdin: bytes then lines, one longer than the 64 KB buffer.
if (cd "$ROOT" && "$COMPILER" tests/runtime/term/stdin.resid -o "$W/stdin" --profile debug) > "$W/stdin.log" 2>&1 \
    && { printf 'xyhello\n'; head -c 100000 /dev/zero | tr '\0' a; printf '\nlast'; } | "$W/stdin" > "$W/stdin.out" \
    && printf '120 121\n6\n100001\n4\n3 -1\n' | cmp -s - "$W/stdin.out"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL buffered stdin: $(grep -m1 -i error "$W/stdin.log")"
fi
# lib/readline.resid on a pseudo-terminal (needs python3).
if command -v python3 > /dev/null; then
    if (cd "$ROOT" && "$COMPILER" tests/runtime/term/readline.resid -o "$W/rl" --profile debug) > "$W/rl.log" 2>&1 \
        && python3 term/drive.py "$W/rl" > "$W/rl.out" 2>&1 && cmp -s "$W/rl.out" term/drive.out; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL readline on a pty: $(grep -m1 -i error "$W/rl.log") $(diff "$W/rl.out" term/drive.out | head -3 | tr '\n' ' ')"
    fi
fi
# A native module's host started by hand (spec §47, hs_auth): run as
# `resid-native-host tiny` with a socket on fd 3 and a request already in
# it, by a parent (python3) that does not answer its challenge, it sends
# the challenge and refuses (exit 124, no reply); called by the program
# itself it answers.
if command -v python3 > /dev/null; then
    if (cd "$ROOT" && "$COMPILER" tests/conformance/cases/native_stateless.resid -native tiny=tests/conformance/native/tiny.ll -o "$W/nh") > "$W/nh.log" 2>&1 \
        && [ "$("$W/nh")" = "1 1 1" ] \
        && python3 - "$W/nh" > "$W/nh.out" 2>&1 <<'PY'
import os, socket, struct, sys
a, b = socket.socketpair()
a.sendall(struct.pack("<q", 0)); a.shutdown(socket.SHUT_WR)
pid = os.fork()
if pid == 0:
    os.dup2(b.fileno(), 3)
    os.execve(sys.argv[1], ["resid-native-host", "tiny"], {})
b.close()
data = b""
while True:
    try:
        c = a.recv(4096)
    except ConnectionResetError:   # it exited with our request unread
        break
    if not c: break
    data += c
_, st = os.waitpid(pid, 0)
ok = os.WIFEXITED(st) and os.WEXITSTATUS(st) == 124 and len(data) == 16
print("refused" if ok else f"answered: status {st}, {len(data)} bytes")
sys.exit(0 if ok else 1)
PY
    then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL native host by hand: $(grep -m1 -i error "$W/nh.log") $(cat "$W/nh.out" 2>/dev/null)"
    fi
fi
# A native module's host while it runs (spec §47): seccomp in filter mode,
# no new privileges, and, where the CPU and kernel have it, the shadow
# stack on and locked (x86-64 CET; tests/conformance/native/spin.ll spins
# so the test can read the live host's /proc status).
if command -v python3 > /dev/null; then
    printf '@link("spin") Int spin(Int n) {}\n@requires(native_spin)\nInt main() { println(f"{spin(rt 2000000000)}"); return 0; }\n' > "$W/spin.resid"
    if (cd "$ROOT" && "$COMPILER" "$W/spin.resid" -native spin=tests/conformance/native/spin.ll -o "$W/spin") > "$W/spin.log" 2>&1 \
        && python3 - "$W/spin" > "$W/spin.out" 2>&1 <<'PY'
import os, subprocess, sys, time
p = subprocess.Popen([sys.argv[1]], stdout=subprocess.PIPE)
status = None
deadline = time.time() + 20
while status is None and time.time() < deadline and p.poll() is None:
    for pid in os.listdir("/proc"):
        if not pid.isdigit():
            continue
        try:
            argv = open(f"/proc/{pid}/cmdline", "rb").read().split(b"\0")
            if argv[:2] == [b"resid-native-host", b"spin"]:
                status = dict(l.split(":", 1) for l in open(f"/proc/{pid}/status").read().splitlines() if ":" in l)
        except OSError:
            pass
    time.sleep(0.02)
out = p.communicate()[0].decode().strip()
if status is None:
    sys.exit(f"no live host seen (program printed {out!r})")
flags = open("/proc/cpuinfo").read().split()
want = {"Seccomp": "2", "NoNewPrivs": "1"}
bad = [f"{k}={status.get(k, '').strip()}" for k, v in want.items() if status.get(k, "").strip() != v]
if "user_shstk" in flags and "x86_Thread_features_locked" in status:
    if "shstk" not in status["x86_Thread_features"] or "shstk" not in status["x86_Thread_features_locked"]:
        bad.append("shadow stack not on and locked: " + status["x86_Thread_features_locked"].strip())
if out != "2000000000":
    bad.append(f"result {out!r}")
print("host confined" if not bad else "; ".join(bad))
sys.exit(1 if bad else 0)
PY
    then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL native host confinement: $(grep -m1 -i error "$W/spin.log") $(cat "$W/spin.out" 2>/dev/null)"
    fi
fi
# An AArch64 build hardens a native module's own code (compiler/native.resid,
# nt_harden): every function signs its return address, gets landing pads
# and is GCS-compatible, in its own section between page-aligned marks
# that bound every module symbol (the host maps those pages PROT_BTI).
# Needs the AArch64 builtins and the AArch64 runtime IR; it only builds.
RH="${RESID_HOME:-$ROOT/build/boot}"
if { [ -n "${RESID_AARCH64_BUILTINS:-}" ] || [ -f "$RH/aarch64/libclang_rt.builtins.a" ]; } && [ -f "$RH/rt-aarch64.ll" ] && command -v nm > /dev/null && command -v python3 > /dev/null; then
    if (cd "$ROOT" && "$COMPILER" tests/conformance/cases/native_ok.resid --target aarch64 -native tiny=tests/conformance/native/aarch64/tiny.ll -o "$W/a64") > "$W/a64.log" 2>&1 \
        && nm "$W/a64" > "$W/a64.nm" && python3 - "$W/a64.native.tiny.ll" "$W/a64.nm" > "$W/a64.out" 2>&1 <<'PY'
import sys
ir = open(sys.argv[1]).read().splitlines()
defs = [l for l in ir if l.startswith("define ")]
need = ['"branch-target-enforcement"', '"guarded-control-stack"', '"sign-return-address"="non-leaf"', '"sign-return-address-key"="a_key"', 'section "resid_native_tiny"']
bad = [l.split("(")[0] for l in defs if not all(n in l for n in need)]
syms = {}
for l in open(sys.argv[2]):
    f = l.split()
    if len(f) == 3 and f[2].startswith("native.tiny."):
        syms[f[2]] = int(f[0], 16)
lo, hi = syms.get("native.tiny.__resid_lo"), syms.get("native.tiny.__resid_hi")
if lo is None or hi is None or lo % 4096 or hi % 4096 or hi <= lo:
    bad.append(f"marks {lo} {hi}")
else:
    bad += [n for n, a in syms.items() if n != "native.tiny.__resid_hi" and not lo <= a < hi]
print("hardened" if not bad and len(defs) > 2 else f"not hardened: {bad} ({len(defs)} functions)")
sys.exit(1 if bad or len(defs) <= 2 else 0)
PY
    then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL aarch64 native hardening: $(grep -m1 -i error "$W/a64.log") $(cat "$W/a64.out" 2>/dev/null)"
    fi
fi
# Secret mode turns core dumps off (runtime/rt/malloc.resid): a program
# holding a secret aborts with exit 134 and its message, not SIGABRT, and a
# stack overflow in it dumps no core; the control without a secret still
# aborts with SIGABRT (needs python3 to tell an exit from a signal).
if command -v python3 > /dev/null; then
    nd_ok=1; nd_why=""
    for p in secret_abort public_abort secret_overflow; do
        (cd "$ROOT" && "$COMPILER" "tests/runtime/nodump/$p.resid" -o "$W/nd_$p") > "$W/nd_$p.log" 2>&1 \
            || { nd_ok=0; nd_why="$nd_why $p: $(grep -m1 -i error "$W/nd_$p.log")"; continue; }
        python3 nodump/check.py "$W/nd_$p" > "$W/nd_$p.out" 2>&1
    done
    msg="resid: abort: integer overflow in checked arithmetic"
    [ "$(head -1 "$W/nd_secret_abort.out" 2>/dev/null)" = "exit 134" ] && grep -qF "$msg" "$W/nd_secret_abort.out" \
        || { nd_ok=0; nd_why="$nd_why secret_abort: $(tr '\n' ' ' < "$W/nd_secret_abort.out")"; }
    head -1 "$W/nd_public_abort.out" 2>/dev/null | grep -q '^signal 6 ' && grep -qF "$msg" "$W/nd_public_abort.out" \
        || { nd_ok=0; nd_why="$nd_why public_abort: $(tr '\n' ' ' < "$W/nd_public_abort.out")"; }
    [ "$(head -1 "$W/nd_secret_overflow.out" 2>/dev/null)" = "signal 11 nocore" ] \
        || { nd_ok=0; nd_why="$nd_why secret_overflow: $(tr '\n' ' ' < "$W/nd_secret_overflow.out")"; }
    if [ "$nd_ok" = 1 ]; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL secret mode core dumps:$nd_why"; fi
fi
# Large objects (region.resid): a 64 MB list made inside a loop and carried
# through its compactions is adopted, not copied, so the loop stays within
# 220 MB. Measured: the adopting runtime needs 175-200 MB depending on the
# machine (200 on a 16-core desktop), the copying one (v0.10.1) 260-300.
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/large_carry.resid -o "$W/large_carry") > "$W/large_carry.log" 2>&1 \
    && RESID_MEM_LIMIT=220 timeout 120 "$W/large_carry" > "$W/large_carry.out" 2>&1 \
    && [ "$(cat "$W/large_carry.out")" = "30244212908" ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL large objects carried through a loop: $(tail -1 "$W/large_carry.out" "$W/large_carry.log" 2>/dev/null | tr '\n' ' ')"
fi
# Loop regions for lists of sums, of 64-bit integers and of lists, and for
# a loop returning a Result (lower.resid, lr_move and lr_region_ok): eight
# loops of two million steps whose carried state holds them each keep a few
# hundred bytes live. Measured: under 20 MB with regions; the compiler that
# gave these loops none (v0.13.0) needed over 4 GB.
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/loop_shapes.resid -o "$W/loop_shapes") > "$W/loop_shapes.log" 2>&1 \
    && RESID_MEM_LIMIT=64 timeout 120 "$W/loop_shapes" > "$W/loop_shapes.out" 2>&1 \
    && [ "$(tr '\n' ' ' < "$W/loop_shapes.out")" = "2000015 7999993 6 2000001 4 3999998 3999998 5 " ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL loop regions for lists of sums and 64-bit integers: $(tail -1 "$W/loop_shapes.out" "$W/loop_shapes.log" 2>/dev/null | tr '\n' ' ')"
fi
# --loop-report (lower.resid, The loop report): a loop that allocates and
# has no region is named with its reason; without the flag nothing is said.
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/loop_report.resid -o "$W/loop_report" --loop-report) > "$W/loop_report.log" 2>&1 \
    && [ "$(grep -c '^note: loop: ' "$W/loop_report.log")" = 2 ] \
    && grep -q '^note: loop: probe keeps .*: it returns Result(Int, Str) and carries no heap value that changes' "$W/loop_report.log" \
    && grep -q '^note: loop: join keeps .*: it carries a StrBuf' "$W/loop_report.log" \
    && (cd "$ROOT" && "$COMPILER" tests/runtime/mem/loop_report.resid -o "$W/loop_report2") > "$W/loop_report2.log" 2>&1 \
    && ! grep -q '^note: loop: ' "$W/loop_report2.log" \
    && [ "$("$W/loop_report")" = "true true 3" ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL loop report: $(grep '^note: loop: \|rror' "$W/loop_report.log" | head -3 | tr '\n' ' ')"
fi
# Builders in loop regions (lower.resid, lr_move): eight loops that carry
# a ListBuf and allocate at each step, their results read back in full.
# Measured: 306 MB, nearly all of it the eight results; the compiler that
# gave a loop carrying a builder no region needed 620 MB.
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/builder_loops.resid -o "$W/builder_loops") > "$W/builder_loops.log" 2>&1 \
    && RESID_MEM_LIMIT=420 timeout 120 "$W/builder_loops" > "$W/builder_loops.out" 2>&1 \
    && [ "$(tr '\n' ' ' < "$W/builder_loops.out")" = "125000250002 500000 500000 29638890 14500002 -11111112 41667879633 1500000 " ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL builders in loop regions: $(tail -1 "$W/builder_loops.out" "$W/builder_loops.log" 2>/dev/null | tr '\n' ' ')"
fi
# Loop generations (region.resid, Generations): a loop carrying a structure
# that keeps growing (a list kept every 97 steps, a map of 500 entries
# rewritten), a loop inside a loop, and one returning through a function.
# Its first compaction makes an old region, later ones move only what is
# new into it, and a full one runs when the old region has doubled.
# Measured: 39 MB.
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/generations.resid -o "$W/generations") > "$W/generations.log" 2>&1 \
    && RESID_MEM_LIMIT=96 timeout 120 "$W/generations" > "$W/generations.out" 2>&1 \
    && [ "$(tr '\n' '|' < "$W/generations.out")" = "4124 27719 500 v399507-garbage  v399999-garbage  1183175|400 10 514|3093907677|" ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL loop generations: $(tail -1 "$W/generations.out" "$W/generations.log" 2>/dev/null | tr '\n' ' ')"
fi
# str_repeat's result is region memory (strutil.resid), so a loop and a
# scoped recursion that pad with it keep none of it. Measured: 4 MB; the
# runtime that took it from the heap kept every one (250 MB).
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/str_repeat.resid -o "$W/str_repeat") > "$W/str_repeat.log" 2>&1 \
    && RESID_MEM_LIMIT=24 timeout 120 "$W/str_repeat" > "$W/str_repeat.out" 2>&1 \
    && [ "$(tr '\n' ' ' < "$W/str_repeat.out")" = "137500000 23976000 xyxyxy " ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL str_repeat in a loop: $(tail -1 "$W/str_repeat.out" "$W/str_repeat.log" 2>/dev/null | tr '\n' ' ')"
fi
# Spawned regions in a loop (ctl.resid, Structured spawn): control blocks,
# each job's garbage and an aborted job's memory are given back at the
# join, and a job past the memory budget fails alone. Measured: 66 MB, the
# budget the memory bomb runs into; before, the first loop alone kept
# 120 MB and the bomb aborted the process.
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/spawn_jobs.resid -o "$W/spawn_jobs") > "$W/spawn_jobs.log" 2>&1 \
    && RESID_MEM_LIMIT=64 timeout 120 "$W/spawn_jobs" > "$W/spawn_jobs.out" 2>&1 \
    && [ "$(tr '\n' ' ' < "$W/spawn_jobs.out")" = "599997 -100000 40000780 4999950000 -2 3003 " ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL spawned regions in a loop: $(tail -1 "$W/spawn_jobs.out" "$W/spawn_jobs.log" 2>/dev/null | tr '\n' ' ')"
fi
# Spawns made at depth 0 whose results point into the job's region
# (ctl.resid, resid_spawn_out): the job's return moves the result to the
# heap and the job frees its region, and the join frees the control
# block. 300k string results, 20k lists and 20k records: 35 MB; before,
# each join kept the job's region page (the budget ran out after about
# 12k spawns; without one, the region range ran out at 262k, 1.6 GB).
# 5k options and 5k lists of closures too: a container of closures was
# moved as a closure (a list crashed; an option kept the job's region).
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/spawn_depth0.resid -o "$W/spawn_depth0") > "$W/spawn_depth0.log" 2>&1 \
    && RESID_MEM_LIMIT=48 timeout 300 "$W/spawn_depth0" > "$W/spawn_depth0.out" 2>&1 \
    && [ "$(cat "$W/spawn_depth0.out")" = "ok ok ok ok ok" ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL depth-0 spawns returning region values: $(tail -1 "$W/spawn_depth0.out" "$W/spawn_depth0.log" 2>/dev/null | tr '\n' ' ')"
fi
# Owned updates of a large list a call froze (map.resid, no_thaw_cost):
# after about one copy's worth of path copies the list is thawed and then
# written in place, in loops that have no region. Measured: under 1 MB;
# before, each update copied a path for good (1.2 GB). The debt is each
# list's own: another list's thaw every 25 steps does not reset it (3 MB;
# with one debt per thread, 87 MB).
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/list_with.resid -o "$W/list_with") > "$W/list_with.log" 2>&1 \
    && RESID_MEM_LIMIT=32 timeout 120 "$W/list_with" > "$W/list_with.out" 2>&1 \
    && [ "$(tr '\n' ' ' < "$W/list_with.out")" = "257 999994 999999 15 5001 99999 7 0 1 1 " ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL owned updates of a frozen list: $(tail -1 "$W/list_with.out" "$W/list_with.log" 2>/dev/null | tr '\n' ' ')"
fi
# xs.grow shares its buffer's tip as an append does (map.resid,
# list_grow), so a run of grows is amortized and leaves no copies behind.
# Measured: 30 MB; before, every grow copied the list (over 13 GB here).
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/list_grow.resid -o "$W/list_grow") > "$W/list_grow.log" 2>&1 \
    && RESID_MEM_LIMIT=48 timeout 120 "$W/list_grow" > "$W/list_grow.out" 2>&1 \
    && [ "$(tr '\n' ' ' < "$W/list_grow.out")" = "50000 49999 101000 999 140010 19999 900000 223 " ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL grow in a loop: $(tail -1 "$W/list_grow.out" "$W/list_grow.log" 2>/dev/null | tr '\n' ' ')"
fi
# RESID_MEM_LIMIT charges memory as it is handed out (malloc.resid,
# mem_charge): 1-1.2 GB allocations (str_repeat, str_replace, grow) are
# refused before they are touched, as Err(RegionError) in a spawn and by
# the budget's abort at the top level, and the peak stays under the limit:
# 20 MB. Before, a large fresh mapping was not resident yet and went
# through (1.1 GB resident under a 100 MB limit).
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/big_alloc.resid -o "$W/big_alloc") > "$W/big_alloc.log" 2>&1 \
    && python3 -I -c '
import resource, subprocess, sys, os
r = subprocess.run([sys.argv[1]], capture_output=True, text=True, timeout=120, env=dict(os.environ, RESID_MEM_LIMIT="100"))
peak = resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss
ok = r.returncode != 0 and r.stdout == "refused refused refused ok 20000000 ok 20000000\n" and "memory budget exceeded (100 MB)" in r.stdout + r.stderr and peak < 100 * 1024
print(f"rc {r.returncode} peak {peak} KB: {r.stdout.strip()} {r.stderr.strip()}")
sys.exit(0 if ok else 1)' "$W/big_alloc" > "$W/big_alloc.out" 2>&1; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL large allocations under RESID_MEM_LIMIT: $(tail -1 "$W/big_alloc.out" "$W/big_alloc.log" 2>/dev/null | tr '\n' ' ')"
fi
# RESID_MEM_LIMIT under concurrent spawns (malloc.resid mem_take,
# region.resid page_charge): 100 jobs that each fill a fresh region page
# after a sleep; the ones past the budget get Err(RegionError) and the
# peak stays under the limit plus 8 MB of slack for what is not charged
# (thread stacks, the runtime's tables): measured 37 MB. Then three
# sequential 20 MB jobs must run: no idle worker keeps freed pages charged.
# Before: every job ran, 83 MB resident under 50, and the three were
# refused.
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/spawn_budget.resid -o "$W/spawn_budget") > "$W/spawn_budget.log" 2>&1 \
    && python3 -I -c '
import re, resource, subprocess, sys, os
r = subprocess.run([sys.argv[1]], capture_output=True, text=True, timeout=120, env=dict(os.environ, RESID_MEM_LIMIT="50"))
peak = resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss
m = re.fullmatch(r"burst 100 ok (\d+) refused (\d+)\nafter ok 3 refused 0\n", r.stdout)
ok = r.returncode == 0 and m is not None and int(m.group(1)) > 0 and int(m.group(2)) > 0 and int(m.group(1)) + int(m.group(2)) == 100 and peak < 58 * 1024
print(f"rc {r.returncode} peak {peak} KB: {r.stdout.strip()} {r.stderr.strip()}")
sys.exit(0 if ok else 1)' "$W/spawn_budget" > "$W/spawn_budget.out" 2>&1; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL concurrent spawns under RESID_MEM_LIMIT: $(tail -1 "$W/spawn_budget.out" "$W/spawn_budget.log" 2>/dev/null | tr '\n' ' ')"
fi
# The compiler builds the runtime with freed big blocks unmapped at once
# (malloc.resid, RESID_UNMAP_FREED=1), so a value read after its arena is
# freed faults instead of finding the old bytes. Before, --runtime-module
# printed a file name made in the code generator's arena after the arena
# was popped (driver.resid), and crashed this way (exit 139).
if (cd "$ROOT" && RESID_UNMAP_FREED=1 timeout 600 "$COMPILER" runtime/rt/rt.resid --runtime-module -o "$W/rt_unmapped") > "$W/rt_unmapped.log" 2>&1 \
    && grep -q "^wrote $W/rt_unmapped.ll$" "$W/rt_unmapped.log"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL runtime build with freed blocks unmapped: $(tail -1 "$W/rt_unmapped.log" 2>/dev/null)"
fi
# A large object whose page charge the budget refuses (region.resid,
# lg_new) is linked into its region first, so the pop frees its page.
# Under ulimit -v the region range is 1024 pages; 1100 jobs are refused
# for the budget, all of them. Before, each refusal lost a page: after
# 986 jobs the rest were refused for "region address space exhausted".
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/lg_refused.resid -o "$W/lg_refused") > "$W/lg_refused.log" 2>&1 \
    && (ulimit -v 2500000; RESID_MEM_LIMIT=40 RESID_SPAWN_STACK_MB=8 timeout 300 "$W/lg_refused") > "$W/lg_refused.out" 2>&1 \
    && [ "$(cat "$W/lg_refused.out")" = "budget 1100 other 0 then 20" ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL refused large objects keep the region range: $(tail -1 "$W/lg_refused.out" "$W/lg_refused.log" 2>/dev/null | tr '\n' ' ')"
fi
# CBOR encoding appends packed bytes (lib/cbor.resid): 2 MB encoded in
# 54 MB. The encoder that kept a cons cell per output byte took 486 MB.
if (cd "$ROOT" && "$COMPILER" tests/runtime/mem/cbor_bytes.resid -o "$W/cbor_bytes") > "$W/cbor_bytes.log" 2>&1 \
    && RESID_MEM_LIMIT=96 timeout 120 "$W/cbor_bytes" > "$W/cbor_bytes.out" 2>&1 \
    && [ "$(cat "$W/cbor_bytes.out")" = "2000005 90 128 0 31 995216952 [162, 97, 97, 131, 1, 33, 98, 195, 188, 97, 98, 66, 0, 255]" ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL CBOR encoding of a large byte string: $(tail -1 "$W/cbor_bytes.out" "$W/cbor_bytes.log" 2>/dev/null | tr '\n' ' ')"
fi
# Volatile raw loads and stores (lower.resid): two processes pass a counter
# through a shared page, each polling with resid_raw_loadv64; a plain load
# is hoisted out of the loop and the program never ends. Built from its own
# directory (the entry's path must hold runtime/rt/), so the compiler is
# told where its runtime is.
if (cd "$ROOT/tests/runtime/internals" && RESID_HOME="$RH" "$COMPILER" runtime/rt/volatile_poll.resid --runtime-internals -o "$W/volatile_poll") > "$W/volatile_poll.log" 2>&1 \
    && [ "$(timeout 60 "$W/volatile_poll")" = "45150 1 8 9" ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL volatile raw loads: $(grep -m1 -i error "$W/volatile_poll.log")"
fi
echo "runtime: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
