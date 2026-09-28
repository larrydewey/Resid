#!/usr/bin/env bash
# Resid boot build + self-hosting fixed-point verification (cargo-free).
#
# Default flow — no Rust anywhere:
#   1. clang links the committed seed build/boot/seed.ll -> stage1.bin
#   2. stage1 compiles the driver source  -> stage2.ll (must byte-match seed)
#   3. stage2 compiles the driver source  -> stage3.ll
#   4. stage3.ll must be byte-identical to stage2.ll (fixed point)
#   5. CLI smoke-test
#
# Re-seeding (only needed when the compiler source changes the fixed point):
#   ./boot.sh --bootstrap-from-self  rebuild stage2.ll/stage2.bin using the
#                                    CURRENT committed seed as the starting
#                                    compiler, no Rust anywhere. A source
#                                    change doesn't take full effect in one
#                                    round -- the compiler that compiled the
#                                    new source doesn't yet BEHAVE per that
#                                    new source until it's compiled AGAIN by
#                                    the result -- so this iterates
#                                    stage1->stage2->stage3->... up to
#                                    MAX_SELF_ROUNDS, comparing consecutive
#                                    outputs, until two consecutive rounds
#                                    match.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="${SCRIPT_DIR}/compiler/driver.resid"
OUT="${SCRIPT_DIR}/build/boot"
SEED_LL="${OUT}/seed.ll"
# The Resid runtime (runtime/rt/), lowered to IR by the compiler itself;
# committed like the seed and linked into every binary.
RT_SRC="runtime/rt/rt.resid" # relative: symbol names follow the import path
RT_LL="${OUT}/rt.ll"

# Force stdlib resolution to this checkout's freshly-synced build/boot/
export RESID_HOME="${OUT}"
BOOTSTRAP_SELF=0
[ "${1:-}" = "--bootstrap-from-self" ] && BOOTSTRAP_SELF=1

mkdir -p "$OUT"
cd "$SCRIPT_DIR"

step() { echo -e "\033[1;34m==>\033[0m $*"; }
ok()   { echo -e "  \033[0;32m✓\033[0m $*"; }
die()  { echo -e "  \033[0;31m✗\033[0m $*"; exit 1; }

# An install (install.sh) that already exists is refreshed after every
# successful build or reseed, so ~/.resid never runs a stale compiler or
# runtime; RESID_NO_INSTALL_REFRESH=1 skips it.
refresh_install() {
    local target="${RESID_INSTALL:-$HOME/.resid}"
    [ "${RESID_NO_INSTALL_REFRESH:-0}" = "1" ] && return 0
    [ -x "$target/bin/residc" ] || return 0
    step "Refreshing the install in $target"
    "${SCRIPT_DIR}/install.sh" > "${OUT}/install.log" 2>&1 || die "install refresh failed (see build/boot/install.log)"
    ok "install refreshed"
}

# Optimization level for linking the compiler binaries (RESID_OPT=-O0 for a
# fast, unoptimized bootstrap). Programs the compiler builds take -O<n> on
# its own command line instead, also defaulting to -O2.
RESID_OPT="${RESID_OPT:--O2}"

link_clang() { # link_clang <ll> <out-bin>
    # IR with its own process entry links without the C library; an older
    # seed (before _start) still links against it.
    if grep -q "^define void @_start" "$1"; then
        clang "$RESID_OPT" -static-pie -nostdlib "$1" "$RT_LL" -lgcc -o "$2" -Wno-override-module
    else
        clang "$RESID_OPT" -no-pie "$1" "$RT_LL" -o "$2" -Wno-override-module -pthread
    fi
}

build_rt() { # build_rt <compiler> <out-base>: runtime IR to <out-base>.ll
    timeout 600 "$1" "$RT_SRC" --runtime-module -o "$2" > /dev/null || die "runtime module failed to compile"
}

# Release builds must be signed (spec §33.1). Without a configured key,
# generate a throwaway one under build/boot/keys with the given compiler
# (a compiler that predates keygen doesn't need one).
ensure_key() { # ensure_key <compiler>
    [ -n "${RESID_SIGNING_KEY:-}" ] && return 0
    [ -f "${SCRIPT_DIR}/keys/resid-ed25519.key" ] && return 0
    if [ ! -f "${OUT}/keys/resid-ed25519.key" ]; then
        "$1" keygen "${OUT}/keys" >/dev/null 2>&1 || return 0
    fi
    [ -f "${OUT}/keys/resid-ed25519.key" ] || return 0
    export RESID_SIGNING_KEY="${OUT}/keys/resid-ed25519.key"
    export RESID_VERIFY_PUB="$(cat "${OUT}/keys/resid-ed25519.pub")"
}

# ── Re-seed path: iterate the self-hosted compiler to a new fixed point ──
MAX_SELF_ROUNDS=10
if [ "$BOOTSTRAP_SELF" -eq 1 ]; then
    step "Bootstrap: reseeding from the self-hosted compiler (no Rust)"
    [ -f "$SEED_LL" ] || die "missing committed seed $SEED_LL (restore it from git)"
    link_clang "$SEED_LL" "${OUT}/stage1.bin"
    PREV_LL="${OUT}/seed.ll"
    PREV_BIN="${OUT}/stage1.bin"
    i=1
    while [ "$i" -le "$MAX_SELF_ROUNDS" ]; do
        # The compiler links to -o itself and writes its IR to <out>.ll,
        # so each round hands us both a binary and the IR to compare.
        NEXT_BIN="${OUT}/reseed_round${i}.bin"
        NEXT_LL="${NEXT_BIN}.ll"
        ensure_key "$PREV_BIN"
        # The runtime first: the round's binary links the runtime its
        # compiler lowers.
        build_rt "$PREV_BIN" "${OUT}/reseed_rt${i}"
        RT_SAME=0
        cmp -s "${OUT}/reseed_rt${i}.ll" "$RT_LL" && RT_SAME=1
        cp "${OUT}/reseed_rt${i}.ll" "$RT_LL"
        timeout 600 "$PREV_BIN" "$SRC" -o "$NEXT_BIN" --runtime-internals
        [ -f "$NEXT_LL" ] || die "round $i produced no output"
        if cmp -s "$PREV_LL" "$NEXT_LL" && [ "$RT_SAME" -eq 1 ]; then
            ok "converged after $i round$([ "$i" -eq 1 ] && echo "" || echo "s")"
            cp "$NEXT_LL" "$SEED_LL"
            link_clang "$SEED_LL" "${OUT}/stage2.bin"
            rm -f "${OUT}"/reseed_round*.ll "${OUT}"/reseed_round*.bin "${OUT}"/reseed_rt*.ll
            ok "stage2 seeded from the self-hosted compiler"
            refresh_install
            echo ""
            echo "Verify with a clean ./boot.sh (no args) and commit the new seed:"
            echo "  git add -f build/boot/seed.ll build/boot/rt.ll build/boot/stage2.bin && git commit"
            exit 0
        fi
        PREV_LL="$NEXT_LL"
        PREV_BIN="$NEXT_BIN"
        i=$((i + 1))
    done
    rm -f "${OUT}"/reseed_round*.ll "${OUT}"/reseed_round*.bin
    die "did not converge after ${MAX_SELF_ROUNDS} rounds — likely a genuinely new language construct the old seed can't parse at all (not just new behavior); reseed in two steps (old source first)"
fi

# ── 1. stage1 from committed seed ────────────────────────────────────────
step "stage1: clang from committed seed.ll"
[ -f "$SEED_LL" ] || die "missing committed seed $SEED_LL (restore it from git)"
link_clang "$SEED_LL" "${OUT}/stage1.bin"
ok "stage1 linked"

step "runtime: stage1 lowers runtime/rt/ (must byte-match build/boot/rt.ll)"
build_rt "${OUT}/stage1.bin" "${OUT}/rt_check"
cmp -s "${OUT}/rt_check.ll" "$RT_LL" || die "runtime IR differs from build/boot/rt.ll — runtime or compiler source changed; re-seed with --bootstrap-from-self"
ok "runtime IR reproduced"

# ── 2. stage1 -> stage2 (must reproduce the committed seed) ──────────────
# The compiler links to -o itself and writes its IR to <out>.ll, so each
# stage yields both a ready-to-run binary and the IR to compare.
step "stage2: stage1 compiles the driver source"
ensure_key "${OUT}/stage1.bin"
timeout 600 "${OUT}/stage1.bin" "$SRC" -o "${OUT}/stage2.bin" --runtime-internals
[ -f "${OUT}/stage2.bin.ll" ] || die "stage1 produced no output"
if cmp -s "${OUT}/stage2.bin.ll" "$SEED_LL"; then
    HASH=$(sha256sum "$SEED_LL" | cut -c1-16)
    ok "reproduced committed seed exactly (sha256 ${HASH})"
else
    diff "${OUT}/stage2.bin.ll" "$SEED_LL" | head -20 || true
    die "reproduced IR differs from committed seed — compiler source changed; re-seed with --bootstrap-from-self and commit the new seed"
fi
[ -x "${OUT}/stage2.bin" ] || die "stage1 produced no linked stage2 binary"
ok "stage2 linked"

# ── 3+4. stage2 -> stage3, fixed-point check ─────────────────────────────
step "stage3: stage2 compiles the driver source"
ensure_key "${OUT}/stage2.bin"
timeout 600 "${OUT}/stage2.bin" "$SRC" -o "${OUT}/stage3.bin" --runtime-internals
[ -f "${OUT}/stage3.bin.ll" ] || die "stage2 produced no output"
ok "stage3 emitted"

step "Fixed-point check: stage2 output == stage3 output"
if cmp -s "${OUT}/stage2.bin.ll" "${OUT}/stage3.bin.ll"; then
    HASH=$(sha256sum "${OUT}/stage2.bin.ll" | cut -c1-16)
    ok "deterministic (sha256 ${HASH})"
else
    diff "${OUT}/stage2.bin.ll" "${OUT}/stage3.bin.ll" | head -20 || true
    die "FIXED POINT BROKEN: stage2 and stage3 outputs differ"
fi

# ── smoke: stage2 CLI compiles, links and runs a program ─────────────────
step "Smoke: stage2 CLI compiles + links + runs"
cat > /tmp/resid_smoke.resid <<'SMOKE_EOF'
Int add(Int a, Int b) { return a + b; }
Int main() {
    expect(add(2, 3)).toEqual(5);
    println("smoke test passed");
    return 0;
}
SMOKE_EOF
timeout 120 "${OUT}/stage2.bin" /tmp/resid_smoke.resid -o "${OUT}/smoke.bin" >/dev/null
[ -x "${OUT}/smoke.bin" ] || die "smoke did not produce a linked binary"
RESULT="$("${OUT}/smoke.bin")"
echo "$RESULT" | grep -q "smoke test passed" || die "smoke output was '$RESULT'"
ok "smoke output correct"
"${OUT}/stage2.bin" verify "${OUT}/smoke.bin" >/dev/null || die "smoke binary failed provenance verification"
ok "smoke binary provenance verified"

step "Generating build/boot/residc wrapper"
cat > "${OUT}/residc" <<'WRAPPER_EOF'
#!/usr/bin/env bash
# Cargo-free CLI wrapper: passes arguments straight to the self-hosted
# stage2 compiler, which links the Resid runtime (rt.ll next to it).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export RESID_HOME="${RESID_HOME:-$SCRIPT_DIR}"
exec "$SCRIPT_DIR/stage2.bin" "$@"
WRAPPER_EOF
chmod +x "${OUT}/residc"
ok "residc wrapper written"
refresh_install

echo ""
echo "Self-hosting verified: fixed point holds (no Rust in the build path)."