#!/usr/bin/env bash
# Package integrity and capability-ceiling checks for the self-hosted
# package tools (spec §21.1, §28): tools/resid-pkg.resid publishes and
# signs, tools/resid-manifest.resid resolves and verifies.
#
# Usage: tests/pkg/run.sh [-c COMPILER]
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
COMPILER="$ROOT/build/boot/stage2.bin"
while getopts "c:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
W="$(mktemp -d)"
trap 'rm -rf "$W"' EXIT
if [ -z "${RESID_SIGNING_KEY:-}" ] && [ ! -f "$ROOT/keys/resid-ed25519.key" ]; then
    "$COMPILER" keygen "$W/buildkey" >/dev/null && export RESID_SIGNING_KEY="$W/buildkey/resid-ed25519.key"
fi
pass=0; fail=0
ok()  { pass=$((pass + 1)); }
bad() { fail=$((fail + 1)); echo "FAIL $1"; }

for t in resid-pkg resid-manifest; do
    (cd "$ROOT" && "$COMPILER" "tools/$t.resid" -o "$W/$t") > "$W/$t.log" 2>&1 || { echo "FAIL build $t"; cat "$W/$t.log" | grep -i error | head -3; exit 1; }
done
PKG="$W/resid-pkg"; MAN="$W/resid-manifest"
# The driver finds the standard library and the runtime IR under RESID_HOME;
# without it they resolve relative to the current directory.
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"

# A package: greet 1.0.0, and a second one to substitute for it.
mkpkg() {  # dir name version body
    mkdir -p "$1/src"
    printf '[package]\nname = "%s"\nversion = "%s"\n' "$2" "$3" > "$1/resid.toml"
    printf '%s\n' "$4" > "$1/src/main.resid"
}
mkpkg "$W/greet" greet 1.0.0 'pub Str greet() { return "hi"; }'
mkpkg "$W/evil" greet 6.6.6 'pub Str greet() { return "evil"; }'
"$PKG" keygen "$W/pub.sec" "$W/pub.pub" > /dev/null
"$PKG" keygen "$W/other.sec" "$W/other.pub" > /dev/null
PUB="$(cat "$W/pub.pub")"; OTHER="$(cat "$W/other.pub")"

# The secret key is readable by its owner only.
[ "$(stat -c %a "$W/pub.sec")" = 600 ] && ok || bad "keygen secret mode $(stat -c %a "$W/pub.sec")"

# An app depending on greet 1.0.0 from a local registry.
app() {  # name extra-toml
    mkdir -p "$W/$1/src"
    printf '[package]\nname = "%s"\nversion = "0.1.0"\n\n[registry]\npath = "../reg"\n%s\n[dependencies.greet]\nversion = "1.0.0"\n' "$1" "$2" > "$W/$1/resid.toml"
    printf 'import "greet";\nInt main() { println(greet()); return 0; }\n' > "$W/$1/src/main.resid"
}
deps() { (cd "$W" && "$MAN" deps "$W/$1/resid.toml") > "$W/$1.out" 2>&1; }
expect_ok()   { deps "$1"; if [ $? -eq 0 ]; then ok; else bad "$1: $(tail -1 "$W/$1.out")"; fi; }
expect_fail() { deps "$1"; if [ $? -ne 0 ] && grep -q "$2" "$W/$1.out"; then ok; else bad "$1: wanted '$2', got: $(tail -1 "$W/$1.out")"; fi; }

# Unsigned publish: rejected unless the manifest opts in.
"$PKG" publish "$W/greet" "$W/reg" > /dev/null
app unsigned ""
expect_fail unsigned "is unsigned"
app devprofile $'[signing]\nallow_unsigned = true'
expect_ok devprofile

# Signed publish: the registry's signed index or a pinned key is trusted.
rm -rf "$W/reg"; "$PKG" publish "$W/greet" "$W/reg" "$W/pub.sec" > /dev/null
app noanchor ""
expect_fail noanchor "is unsigned"
app viaindex "pubkey = \"$PUB\""
expect_ok viaindex
app wrongindex "pubkey = \"$OTHER\""
expect_fail wrongindex "signature INVALID"
app pinned ""
printf 'pubkey = "%s"\n' "$PUB" >> "$W/pinned/resid.toml"
expect_ok pinned
app pinwrong ""
printf 'pubkey = "%s"\n' "$OTHER" >> "$W/pinwrong/resid.toml"
expect_fail pinwrong "INVALID or missing for its pinned key"
mkdir -p "$W/keyring"; cp "$W/pub.pub" "$W/keyring/publisher.pub"
app viakeyring $'[signing]\nkeyring = "../keyring"'
expect_ok viakeyring

# A modified archive fails the signed index and the pinned signature.
cp -r "$W/reg" "$W/reg.good"
printf 'x' >> "$W/reg/pkg/greet-1.0.0.resid-pkg"
rm -f "$W/reg/pkg/greet-1.0.0.resid-sha256"
app tamperidx "pubkey = \"$PUB\""
expect_fail tamperidx "does not match the signed registry index"
app tamperpin ""
printf 'pubkey = "%s"\n' "$PUB" >> "$W/tamperpin/resid.toml"
expect_fail tamperpin "INVALID or missing for its pinned key"
rm -rf "$W/reg"; mv "$W/reg.good" "$W/reg"

# Substitution: another package signed by the same key, served as greet.
"$PKG" pack "$W/evil" "$W/evilpkg" > /dev/null
cp "$W/evilpkg.resid-pkg" "$W/reg/pkg/greet-1.0.0.resid-pkg"
rm -f "$W/reg/pkg/greet-1.0.0.resid-sha256"
"$PKG" sign "$W/reg/pkg/greet-1.0.0" "$W/pub.sec" > /dev/null
app subst ""
printf 'pubkey = "%s"\n' "$PUB" >> "$W/subst/resid.toml"
expect_fail subst "archive holds package 'greet-6.6.6'"

# A path dependency pinned to a key: its sources must be what was signed.
mkpkg "$W/local" local 1.0.0 'pub Str local_name() { return "local"; }'
"$PKG" sign-dir "$W/local" "$W/pub.sec" > /dev/null
mkdir -p "$W/pathapp/src"
printf '[package]\nname = "pathapp"\nversion = "0.1.0"\n\n[dependencies.local]\npath = "../local"\npubkey = "%s"\n' "$PUB" > "$W/pathapp/resid.toml"
expect_ok pathapp
printf '// changed\n' >> "$W/local/src/main.resid"
expect_fail pathapp "sources differ from what was signed"

# Extraction never writes outside the target directory.
python3 - "$W/trav.resid-pkg" <<'PY'
import struct, sys
entries = [(b"../escaped.resid", b"x"), (b"/abs.resid", b"y"), (b"ok.resid", b"z")]
out = b"RESIDPKG1" + struct.pack("<I", len(entries))
for p, c in entries:
    out += struct.pack("<H", len(p)) + p + struct.pack("<Q", len(c)) + c
open(sys.argv[1], "wb").write(out)
PY
mkdir -p "$W/x/in"
"$PKG" extract "$W/trav" "$W/x/in" > /dev/null
if [ -f "$W/x/in/ok.resid" ] && [ ! -e "$W/x/escaped.resid" ] && [ ! -e /abs.resid ]; then ok; else bad "extract path traversal"; fi

# The manifest ceiling bounds a dependency's code (spec §21.1).
mkpkg "$W/reader" reader 1.0.0 $'@requires(filesystem(readonly))\npub Bool etc_exists() { return filesystem.exists("/etc"); }'
mkdir -p "$W/ceil/src"
printf '[package]\nname = "ceil"\nversion = "0.1.0"\n\n[capabilities]\ngrant = ["filesystem"]\n\n[dependencies.reader]\npath = "../reader"\ncapabilities = []\n' > "$W/ceil/resid.toml"
printf 'import "reader";\n@requires(filesystem(readonly))\nInt main() { if (etc_exists()) { println("yes"); } return 0; }\n' > "$W/ceil/src/main.resid"
(cd "$ROOT" && "$MAN" build "$W/ceil/resid.toml" "$COMPILER") > "$W/ceil.out" 2>&1
if [ $? -ne 0 ] && grep -q "E0212" "$W/ceil.out"; then ok; else bad "ceiling not enforced: $(grep -m1 -i error "$W/ceil.out")"; fi
sed -i 's/capabilities = \[\]/capabilities = ["filesystem(readonly)"]/' "$W/ceil/resid.toml"
(cd "$ROOT" && "$MAN" build "$W/ceil/resid.toml" "$COMPILER") > "$W/ceil2.out" 2>&1
if [ $? -eq 0 ] && [ "$("$W/ceil/target/resid/ceil")" = yes ]; then ok; else bad "ceiling grant: $(grep -m1 -i error "$W/ceil2.out")"; fi

# `resid-manifest test` resolves dependencies, writes the depmap, then hands
# discovery to the driver's own `test` mode (SPEC-testing.md §7.1).
mkpkg "$W/mathlib" mathlib 1.0.0 'pub Int triple(Int a) { return a * 3; }'
mkdir -p "$W/tsuite/src"
printf '[package]\nname = "tsuite"\nversion = "0.1.0"\n\n[dependencies.mathlib]\npath = "../mathlib"\ncapabilities = []\n' > "$W/tsuite/resid.toml"
printf 'import "mathlib";\nInt main() { return 0; }\n' > "$W/tsuite/src/main.resid"
printf 'test "arithmetic" {\n    expect(2 + 2).toEqual(4);\n}\n' > "$W/tsuite/src/math_test.resid"
printf 'test "strings" {\n    expect("resid").toHaveLength(5);\n}\n' > "$W/tsuite/src/str_test.resid"
printf 'import "mathlib";\ntest "a bare dependency import resolves in a test file" {\n    expect(triple(5)).toEqual(15);\n}\n' > "$W/tsuite/src/dep_test.resid"
(cd "$ROOT" && "$MAN" test "$W/tsuite/resid.toml" "$COMPILER") > "$W/tsuite.out" 2>&1
if [ $? -eq 0 ] && grep -q "3 file/s passed, 0 failed, 0 did not compile" "$W/tsuite.out"; then ok; else bad "manifest test: $(tail -3 "$W/tsuite.out" | tr '\n' '|')"; fi

# A failing test fails only its own file; the rest still run, exit is 1.
printf 'test "arithmetic" {\n    expect(2 + 2).toEqual(5);\n}\n' > "$W/tsuite/src/math_test.resid"
(cd "$ROOT" && "$MAN" test "$W/tsuite/resid.toml" "$COMPILER") > "$W/tsuite2.out" 2>&1
rc=$?
if [ $rc -eq 1 ] && grep -q "2 file/s passed, 1 failed, 0 did not compile" "$W/tsuite2.out" && grep -q "a bare dependency import resolves" "$W/tsuite2.out"; then ok; else bad "manifest test failure isolation (rc $rc)"; fi

# `residc test` with no file discovers and runs a whole tree (SPEC-testing.md
# §7.1 "Run all tests"). It needs the depmap, as any build does: one of these
# files imports a dependency by bare name.
printf 'test "arithmetic" {\n    expect(2 + 2).toEqual(4);\n}\n' > "$W/tsuite/src/math_test.resid"
(cd "$W/tsuite/src" && "$COMPILER" test -depmap "$W/tsuite/target/resid/depmap.txt") > "$W/drv1.out" 2>&1
rc=$?
if [ $rc -eq 0 ] && grep -q "3 file/s passed, 0 failed, 0 did not compile" "$W/drv1.out"; then ok; else bad "driver bare test: $(tail -3 "$W/drv1.out" | tr '\n' '|')"; fi
(cd "$W/tsuite/src" && "$COMPILER" test math_test.resid) >/dev/null 2>&1
[ $? -eq 0 ] && ok || bad "driver single test file, passing"
printf 'test "arithmetic" {\n    expect(2 + 2).toEqual(5);\n}\n' > "$W/tsuite/src/math_test.resid"
(cd "$W/tsuite/src" && "$COMPILER" test math_test.resid) >/dev/null 2>&1
[ $? -eq 1 ] && ok || bad "driver single test file, assertion failure must exit 1"
printf 'test "nope" {\n    expect(1).toEqual("str");\n}\n' > "$W/tsuite/src/broken_test.resid"
(cd "$W/tsuite/src" && "$COMPILER" test broken_test.resid) >/dev/null 2>&1
[ $? -eq 2 ] && ok || bad "driver single test file, compile error must exit 2 (not 1)"
# A plain (non-test) compile error keeps its own status.
"$COMPILER" "$W/tsuite/src/broken_test.resid" -o "$W/plain" >/dev/null 2>&1
[ $? -eq 1 ] && ok || bad "non-test compile error must stay 1"
rm -f "$W/tsuite/src/broken_test.resid"

# A test file that does not compile is counted apart from a failing one, and
# §7.2 makes the compile error dominate: exit 2, not 1. Its own package, so
# the check does not depend on the state the steps above left behind.
mkdir -p "$W/badpkg/src"
printf '[package]\nname = "badpkg"\nversion = "0.1.0"\n' > "$W/badpkg/resid.toml"
printf 'Int main() { return 0; }\n' > "$W/badpkg/src/main.resid"
printf 'test "fine" {\n    expect(1).toEqual(1);\n}\n' > "$W/badpkg/src/ok_test.resid"
printf 'test "does not compile" {\n    expect(1).toEqual("str");\n}\n' > "$W/badpkg/src/broken_test.resid"
(cd "$ROOT" && "$MAN" test "$W/badpkg/resid.toml" "$COMPILER") > "$W/tsuite3.out" 2>&1
rc=$?
if [ $rc -eq 2 ] && grep -q "1 file/s passed, 0 failed, 1 did not compile" "$W/tsuite3.out" && grep -q "E0001" "$W/tsuite3.out"; then ok; else bad "manifest test compile error (rc $rc): $(tail -3 "$W/tsuite3.out" | tr '\n' '|')"; fi

# A package with no test files succeeds and says so.
mkdir -p "$W/notest/src"
printf '[package]\nname = "notest"\nversion = "0.1.0"\n' > "$W/notest/resid.toml"
printf 'Int main() { return 0; }\n' > "$W/notest/src/main.resid"
(cd "$ROOT" && "$MAN" test "$W/notest/resid.toml" "$COMPILER") > "$W/notest.out" 2>&1
if [ $? -eq 0 ] && grep -q "no test files" "$W/notest.out"; then ok; else bad "manifest test with no tests: $(tail -2 "$W/notest.out" | tr '\n' '|')"; fi

# `target` is build output, not source: a test file there is not run.
mkdir -p "$W/tsuite/target/resid"
printf 'test "not a real test" {\n    expect(1).toEqual(2);\n}\n' > "$W/tsuite/target/resid/stale_test.resid"
(cd "$ROOT" && "$MAN" test "$W/tsuite/resid.toml" "$COMPILER") > "$W/tsuite4.out" 2>&1
if grep -q "stale_test" "$W/tsuite4.out"; then bad "manifest test walked target/"; else ok; fi
rm -rf "$W/tsuite/target"

# process.run splits its command on byte 32 and execs the words directly, so a
# path with a space is refused rather than silently split into two arguments.
mkdir -p "$W/sp ace/src"
printf '[package]\nname = "sp"\nversion = "0.1.0"\n' > "$W/sp ace/resid.toml"
printf 'Int main() { return 0; }\n' > "$W/sp ace/src/main.resid"
printf 'test "t" {\n    expect(1).toEqual(1);\n}\n' > "$W/sp ace/src/a_test.resid"
(cd "$ROOT" && "$MAN" test "$W/sp ace/resid.toml" "$COMPILER") > "$W/sp.out" 2>&1
rc=$?
if [ $rc -eq 2 ] && grep -q "contains a space" "$W/sp.out"; then ok; else bad "space in package path not refused (rc $rc)"; fi
(cd "$ROOT" && "$COMPILER" test --root "$W/sp ace/src") > "$W/sp2.out" 2>&1
rc=$?
if [ $rc -eq 2 ] && grep -q "contains a space" "$W/sp2.out"; then ok; else bad "space in --root not refused (rc $rc)"; fi
(cd "$ROOT" && "$COMPILER" "$W/sp ace/src/a_test.resid" -o "$W/sp ace/out") > "$W/sp3.out" 2>&1
rc=$?
if [ $rc -eq 2 ] && grep -q "contains a space" "$W/sp3.out"; then ok; else bad "space in -o not refused (rc $rc)"; fi

echo "pkg: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
