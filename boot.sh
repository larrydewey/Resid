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
#   ./boot.sh --bootstrap-from-rust  the old path, via the archived Rust
#                                    bootstrap (see bootstrap/rust-stage0)
#                                    -- kept only as a fallback for the case
#                                    above; not part of the normal workflow.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="${SCRIPT_DIR}/examples/driver.resid"
OUT="${SCRIPT_DIR}/build/boot"
RUNTIME_C="${SCRIPT_DIR}/runtime/resid_rt.c"
SEED_LL="${OUT}/seed.ll"

# Force stdlib resolution to this checkout's freshly-synced build/boot/
export RESID_HOME="${OUT}"
BOOTSTRAP=0
BOOTSTRAP_SELF=0
[ "${1:-}" = "--bootstrap-from-rust" ] && BOOTSTRAP=1
[ "${1:-}" = "--bootstrap-from-self" ] && BOOTSTRAP_SELF=1

mkdir -p "$OUT"
cd "$SCRIPT_DIR"

step() { echo -e "\033[1;34m==>\033[0m $*"; }
ok()   { echo -e "  \033[0;32m✓\033[0m $*"; }
die()  { echo -e "  \033[0;31m✗\033[0m $*"; exit 1; }

# Optimization level for linking the compiler binaries (RESID_OPT=-O0 for a
# fast, unoptimized bootstrap). Programs the compiler builds take -O<n> on
# its own command line instead, also defaulting to -O2.
RESID_OPT="${RESID_OPT:--O2}"

link_clang() { # link_clang <ll> <out-bin>
    clang "$RESID_OPT" -no-pie "$1" "$RUNTIME_C" -o "$2" -Wno-override-module -pthread
}

# ── Re-seed path: iterate the self-hosted compiler to a new fixed point ──
MAX_SELF_ROUNDS=10
if [ "$BOOTSTRAP_SELF" -eq 1 ]; then
    step "Bootstrap: reseeding from the self-hosted compiler (no Rust)"
    [ -f "$SEED_LL" ] || die "missing committed seed $SEED_LL — need a first seed via --bootstrap-from-rust"
    link_clang "$SEED_LL" "${OUT}/stage1.bin"
    PREV_LL="${OUT}/seed.ll"
    PREV_BIN="${OUT}/stage1.bin"
    i=1
    while [ "$i" -le "$MAX_SELF_ROUNDS" ]; do
        # The compiler links to -o itself and writes its IR to <out>.ll,
        # so each round hands us both a binary and the IR to compare.
        NEXT_BIN="${OUT}/reseed_round${i}.bin"
        NEXT_LL="${NEXT_BIN}.ll"
        timeout 600 "$PREV_BIN" "$SRC" -o "$NEXT_BIN"
        [ -f "$NEXT_LL" ] || die "round $i produced no output"
        if cmp -s "$PREV_LL" "$NEXT_LL"; then
            ok "converged after $i round$([ "$i" -eq 1 ] && echo "" || echo "s")"
            cp "$NEXT_LL" "$SEED_LL"
            link_clang "$SEED_LL" "${OUT}/stage2.bin"
            rm -f "${OUT}"/reseed_round*.ll "${OUT}"/reseed_round*.bin
            ok "stage2 seeded from the self-hosted compiler"
            echo ""
            echo "Verify with a clean ./boot.sh (no args) and commit the new seed:"
            echo "  git add -f build/boot/seed.ll build/boot/stage2.bin && git commit"
            exit 0
        fi
        PREV_LL="$NEXT_LL"
        PREV_BIN="$NEXT_BIN"
        i=$((i + 1))
    done
    rm -f "${OUT}"/reseed_round*.ll "${OUT}"/reseed_round*.bin
    die "did not converge after ${MAX_SELF_ROUNDS} rounds — likely a genuinely new language construct the old seed can't parse at all (not just new behavior); fall back to --bootstrap-from-rust"
fi

# ── Re-seed path: Rust bootstrap -> fresh stage2 (fallback only) ───
if [ "$BOOTSTRAP" -eq 1 ]; then
    step "Bootstrap: rebuilding stage2 seed from the archived Rust bootstrap"
    [ -f "${SCRIPT_DIR}/bootstrap/rust-stage0/Cargo.toml" ] || die "archived Rust bootstrap not found"
    cargo build --release --quiet --manifest-path "${SCRIPT_DIR}/bootstrap/rust-stage0/Cargo.toml" --target-dir "${SCRIPT_DIR}/bootstrap/rust-stage0/target"
    RUST_SEED="${SCRIPT_DIR}/bootstrap/rust-stage0/target/release/residc"
    [ -x "$RUST_SEED" ] || die "Rust bootstrap not found at $RUST_SEED"
    step "stage1: Rust bootstrap compiles driver -> seed.ll"
    timeout 600 "$RUST_SEED" "$SRC" -o "${OUT}/rust_stage1.bin"
    [ -f "${OUT}/rust_stage1.bin.ll" ] || die "Rust bootstrap produced no output"
    cp "${OUT}/rust_stage1.bin.ll" "$SEED_LL"
    link_clang "$SEED_LL" "${OUT}/stage2.bin"
    ok "stage2 seeded from Rust bootstrap"
    echo ""
    echo "Verify with a clean ./boot.sh (no args) and commit the new seed:"
    echo "  git add -f build/boot/seed.ll build/boot/stage2.bin && git commit"
    exit 0
fi

# ── 1. stage1 from committed seed ────────────────────────────────────────
step "stage1: clang from committed seed.ll"
[ -f "$SEED_LL" ] || die "missing committed seed $SEED_LL — run ./boot.sh --bootstrap-from-rust first"
link_clang "$SEED_LL" "${OUT}/stage1.bin"
ok "stage1 linked"

# ── 2. stage1 -> stage2 (must reproduce the committed seed) ──────────────
# The compiler links to -o itself and writes its IR to <out>.ll, so each
# stage yields both a ready-to-run binary and the IR to compare.
step "stage2: stage1 compiles the driver source"
timeout 600 "${OUT}/stage1.bin" "$SRC" -o "${OUT}/stage2.bin"
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
timeout 600 "${OUT}/stage2.bin" "$SRC" -o "${OUT}/stage3.bin"
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

step "Generating build/boot/residc wrapper"
rm -rf "${OUT}/runtime"
mkdir -p "${OUT}/runtime"
cp "$RUNTIME_C" "${OUT}/runtime/resid_rt.c"
cat > "${OUT}/residc" <<'WRAPPER_EOF'
#!/usr/bin/env bash
# Cargo-free CLI wrapper: passes arguments straight to the self-hosted
# stage2 compiler, which handles compilation and linking itself.
#
# The compiler resolves its default `-rt runtime/resid_rt.c` against the
# current directory, so the wrapper appends its own copy. pick_opt in the
# driver lets the FIRST occurrence win, so an explicit -rt from the caller
# still takes precedence over the one appended here.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$SCRIPT_DIR/stage2.bin" "$@" -rt "$SCRIPT_DIR/runtime/resid_rt.c"
WRAPPER_EOF
chmod +x "${OUT}/residc"
ok "residc wrapper written"

echo ""
echo "Self-hosting verified: fixed point holds (no Rust in the build path)."