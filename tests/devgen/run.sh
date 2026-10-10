#!/usr/bin/env bash
# Generated device descriptors (PLAN-device-access.md §6.2, spec §49):
# lib/dev/uapi_*.resid must be exactly what tools/resid-devgen generates
# from the committed header snapshot (tools/devgen/uapi/), so a hand edit, a
# stale file or a changed snapshot fails here; the generator must notice a
# header whose layout or request numbers drift; and the generated
# descriptors' request numbers must be the kernel's own _IOWR values on
# both targets, and pass the compiler's E0263 check for each.
#
# Usage: tests/devgen/run.sh [-c COMPILER] [FILTER...]
#
# Offline: the network is used only by `resid-devgen --matrix` and
# `--snapshot` (the release job, tools/devgen-matrix.sh), never here.
# Needs python3 (3.11+, tomllib) and clang with the x86 and AArch64 targets.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
COMPILER="$ROOT/build/boot/stage2.bin"
while getopts "c:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
shift $((OPTIND - 1))
DEVGEN="$ROOT/tools/resid-devgen"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
if [ -z "${RESID_SIGNING_KEY:-}" ] && [ -f "$ROOT/keys/resid-ed25519.key" ]; then
    export RESID_SIGNING_KEY="$ROOT/keys/resid-ed25519.key"
elif [ -z "${RESID_SIGNING_KEY:-}" ]; then
    "$COMPILER" keygen "$WORK/key" >/dev/null && export RESID_SIGNING_KEY="$WORK/key/resid-ed25519.key"
fi
export RESID_HOME="$ROOT/build/boot"
pass=0; fail=0; skip=0
selected() {
    local n="$1"; shift
    [ "${#FILTERS[@]}" -eq 0 ] && return 0
    for pat in "${FILTERS[@]}"; do [[ "$n" == *"$pat"* ]] && return 0; done
    return 1
}
FILTERS=("$@")
ok() { echo "PASS $1"; pass=$((pass + 1)); }
bad() { echo "FAIL $1: $2"; fail=$((fail + 1)); }
skipped() { echo "SKIP $1 ($2)"; skip=$((skip + 1)); }

command -v python3 >/dev/null && command -v clang >/dev/null || { echo "python3 and clang are needed"; exit 2; }
MODULES="$(cd "$ROOT/lib/dev" && ls uapi_*.resid | sed 's/\.resid$//')"

# The committed files are what the snapshot generates, byte for byte, and
# the snapshot is what its manifest lists.
"$DEVGEN" --check > "$WORK/check.log" 2>&1; rc=$?
if selected devgen_check; then
    if [ "$rc" -eq 0 ]; then ok devgen_check; else bad devgen_check "$(grep -m3 -E 'FAIL|snapshot|resid-devgen' "$WORK/check.log" | tr '\n' ' ')"; fi
fi
for m in $MODULES; do
    n="devgen_matches_uapi_${m#uapi_}"
    selected "$n" || continue
    if grep -qx "ok    lib/dev/$m.resid" "$WORK/check.log"; then ok "$n"; else bad "$n" "lib/dev/$m.resid is not what the snapshot's header generates"; fi
done

# Generating twice gives the same bytes (no time, path or order in them).
if selected devgen_byte_stable; then
    mkdir -p "$WORK/g1" "$WORK/g2"
    "$DEVGEN" --write --lib "$WORK/g1" >/dev/null 2>&1 && "$DEVGEN" --write --lib "$WORK/g2" >/dev/null 2>&1; rc=$?
    why=""
    [ "$rc" -eq 0 ] || why="--write failed"
    for m in $MODULES; do
        cmp -s "$WORK/g1/$m.resid" "$WORK/g2/$m.resid" || why="${why:+$why; }$m differs between runs"
        cmp -s "$WORK/g1/$m.resid" "$ROOT/lib/dev/$m.resid" || why="${why:+$why; }$m differs from the committed file"
    done
    if [ -z "$why" ]; then ok devgen_byte_stable; else bad devgen_byte_stable "$why"; fi
fi

# A hand edit of a generated file fails --check.
if selected devgen_stale_file; then
    mkdir -p "$WORK/stale"
    cp "$ROOT"/lib/dev/uapi_*.resid "$WORK/stale/"
    sed -i 's/Buffer(16, -1, 4000, Out, false)/Buffer(16, -1, 4096, Out, false)/' "$WORK/stale/uapi_sev_guest.resid"
    "$DEVGEN" --check --lib "$WORK/stale" > "$WORK/stale.log" 2>&1; rc=$?
    if [ "$rc" -ne 0 ] && grep -q "FAIL  lib/dev/uapi_sev_guest.resid" "$WORK/stale.log"; then ok devgen_stale_file; else bad devgen_stale_file "a hand-edited descriptor passed --check (exit $rc)"; fi
fi

# A changed snapshot header fails --check before anything is generated.
if selected devgen_snapshot_tamper; then
    cp -r "$ROOT/tools/devgen/uapi" "$WORK/snap"
    sed -i 's/__u8 data\[4000\];/__u8 data[4096];/' "$WORK/snap/include/uapi/linux/sev-guest.h"
    RESID_DEVGEN_SNAPSHOT="$WORK/snap" "$DEVGEN" --check > "$WORK/snap.log" 2>&1; rc=$?
    if [ "$rc" -ne 0 ] && grep -q "snapshot file changed: include/uapi/linux/sev-guest.h" "$WORK/snap.log"; then ok devgen_snapshot_tamper; else bad devgen_snapshot_tamper "a changed snapshot header passed (exit $rc)"; fi
fi

# Drift: a kernel tree whose header changes a layout or a request number is
# reported, naming the fact; one that only renames a member (as 5.19's
# `fw_err` is 6.4's `exitinfo2`) is not.
drift_tree() {
    rm -rf "$WORK/k"; cp -r "$ROOT/tools/devgen/uapi" "$WORK/k"; rm -f "$WORK/k/MANIFEST"
}
if selected devgen_drift_layout; then
    drift_tree
    sed -i 's/__u32 vmpl;/__u64 vmpl;/' "$WORK/k/include/uapi/linux/sev-guest.h"
    "$DEVGEN" --local "$WORK/k" > "$WORK/d1.log" 2>&1; rc=$?
    if [ "$rc" -eq 1 ] && grep -q "uapi_sev_guest.resid.*DRIFT" "$WORK/d1.log" && grep -q "snp_report_req.vmpl.width is 8, the descriptor has 4" "$WORK/d1.log" && grep -q "snp_get_report.field.req_data.max is 104, the descriptor has 96" "$WORK/d1.log"; then
        ok devgen_drift_layout
    else
        bad devgen_drift_layout "exit $rc: $(grep -m2 -E 'DRIFT|is ' "$WORK/d1.log" | tr '\n' ' ')"
    fi
fi
if selected devgen_drift_request; then
    drift_tree
    sed -i "s/#define TDX_CMD_GET_REPORT0              _IOWR('T', 1,/#define TDX_CMD_GET_REPORT0              _IOWR('T', 2,/" "$WORK/k/include/uapi/linux/tdx-guest.h"
    "$DEVGEN" --local "$WORK/k" > "$WORK/d2.log" 2>&1; rc=$?
    if [ "$rc" -eq 1 ] && grep -q "x86: tdx_get_report0.request is 0xc4405402, the descriptor has 0xc4405401" "$WORK/d2.log" && grep -q "arm64: tdx_get_report0.request is 0xc4405402" "$WORK/d2.log"; then
        ok devgen_drift_request
    else
        bad devgen_drift_request "exit $rc: $(grep -m2 -E 'DRIFT|is ' "$WORK/d2.log" | tr '\n' ' ')"
    fi
fi
if selected devgen_drift_rename_only; then
    drift_tree
    sed -i 's/__u64 exitinfo2;/__u64 fw_err;/' "$WORK/k/include/uapi/linux/sev-guest.h"
    "$DEVGEN" --local "$WORK/k" > "$WORK/d3.log" 2>&1; rc=$?
    if [ "$rc" -eq 0 ] && grep -q "uapi_sev_guest.resid .*ok .*exitinfo2 is \`fw_err\` here" "$WORK/d3.log"; then
        ok devgen_drift_rename_only
    else
        bad devgen_drift_rename_only "exit $rc: $(grep -m2 -E 'DRIFT|sev_guest' "$WORK/d3.log" | tr '\n' ' ')"
    fi
fi

# The probe's array is read from its own definition only: a header that
# spells "@resid_probe = ..." in a top-level asm statement (module asm in
# the IR) or renames the array with a macro changes nothing.
if selected devgen_probe_anchor; then
    drift_tree
    printf '%s\n' '#define resid_probe resid_forged' '__asm__("@resid_probe = global [1 x i64] [i64 7]");' >> "$WORK/k/include/uapi/linux/sev-guest.h"
    "$DEVGEN" --local "$WORK/k" > "$WORK/d4.log" 2>&1; rc=$?
    if [ "$rc" -eq 0 ] && [ "$(grep -c ' ok ' "$WORK/d4.log")" -eq "$(echo "$MODULES" | wc -w)" ] && ! grep -q DRIFT "$WORK/d4.log"; then
        ok devgen_probe_anchor
    else
        bad devgen_probe_anchor "exit $rc: $(grep -m2 -E 'DRIFT|resid-devgen|is ' "$WORK/d4.log" | tr '\n' ' ')"
    fi
fi

# Input that would escape a comment, a string literal or an identifier in
# the generated Resid is refused before anything is generated.
if selected devgen_input_escaping; then
    why=""
    inject() { # inject <name> <file: input|kernels> <python replace old> <new> <expected message>
        local src="$ROOT/tools/devgen/descriptors.toml"; [ "$2" = kernels ] && src="$ROOT/tools/devgen/kernels.toml"
        python3 -c 'import sys; s = open(sys.argv[1]).read(); assert sys.argv[2] in s; open(sys.argv[3], "w").write(s.replace(sys.argv[2], sys.argv[4], 1))' "$src" "$3" "$WORK/inj.toml" "$4" || { why="${why:+$why; }$1: cannot edit"; return; }
        if [ "$2" = kernels ]; then RESID_DEVGEN_KERNELS="$WORK/inj.toml" "$DEVGEN" --check > "$WORK/inj.log" 2>&1
        else RESID_DEVGEN_INPUT="$WORK/inj.toml" "$DEVGEN" --check > "$WORK/inj.log" 2>&1; fi
        local rc=$?
        [ "$rc" -eq 2 ] && grep -q -- "$5" "$WORK/inj.log" || why="${why:+$why; }$1 not refused (exit $rc: $(head -1 "$WORK/inj.log"))"
    }
    inject summary_newline input 'summary = "Intel TDX guest reports (/dev/tdx_guest)."' 'summary = "x\nInt evil() { return 1; }"' "has a control character"
    inject path_quote input 'path = "/dev/tdx_guest"' 'path = "/dev/tdx_guest\", .write = false, .x = \""' "has a control character, a quote or a backslash"
    inject doc_backslash input 'doc = "TDX_CMD_GET_REPORT0: ' 'doc = "TDX\\x0a: ' "has a control character, a quote or a backslash"
    inject fn_not_ident input 'fn = "tdx_get_report0_op"' 'fn = "tdx_get_report0_op() { return evil(); } IoctlOp x"' "is not a valid fn"
    inject name_not_ident input 'name = "tdx_get_report0"' 'name = "tdx get report0"' "is not a valid name"
    inject prefix_not_ident input 'prefix = "snp_report_req"' 'prefix = "snp_report_req() { return 0; } Int x"' "is not a valid prefix"
    inject header_dotdot input 'header = "linux/tdx-guest.h"' 'header = "../linux/tdx-guest.h"' "is not a valid header"
    inject since_newline input 'since = "v6.2"' 'since = "v6.2\nInt evil"' "has a control character"
    inject max_semicolon input 'max = "NSM_REQUEST_MAX_SIZE"' 'max = "1}; int x[] = {2"' "is not a plain C expression"
    inject tag_newline kernels 'tag = "v7.2.9"' 'tag = "v7.2.9\nInt evil"' "has a control character"
    inject commit_not_hex kernels 'commit = "5fce161649b4d779d1b76d9fcd52dc77779774b8"' 'commit = "5fce16 Int evil"' "is not a valid commit"
    if [ -z "$why" ]; then ok devgen_input_escaping; else bad devgen_input_escaping "$why"; fi
fi

# --matrix uses a cached checkout only when it is the pinned commit with
# a clean working tree: a header edited, or a file added, in the cache
# after the fetch is not read as the kernel's; the checkout is fetched
# again. A local repository stands in for the kernel mirror (no network).
if selected devgen_cache_dirty; then
    G="$WORK/mirror"; rm -rf "$G" "$WORK/cache"
    mkdir -p "$G"; cp -r "$ROOT/tools/devgen/uapi/include" "$ROOT/tools/devgen/uapi/arch" "$G/"
    git -C "$G" init -q && git -C "$G" add -A && git -C "$G" -c user.name=t -c user.email=t@t commit -q -m snapshot && git -C "$G" tag v9.9-test
    sha="$(git -C "$G" rev-parse HEAD)"
    python3 -c 'import sys, re; s = open(sys.argv[1]).read(); s = re.sub(r"^remote = .*$", "remote = \"file://" + sys.argv[2] + "\"", s, flags=re.M); s = s[:s.index("[[matrix]]")] + "[[matrix]]\ntag = \"v9.9-test\"\ncommit = \"" + sys.argv[3] + "\"\n"; open(sys.argv[4], "w").write(s)' "$ROOT/tools/devgen/kernels.toml" "$G" "$sha" "$WORK/kern.toml"
    run_matrix() { RESID_DEVGEN_KERNELS="$WORK/kern.toml" RESID_DEVGEN_CACHE="$WORK/cache" "$DEVGEN" --matrix > "$WORK/$1.log" 2>&1; }
    why=""
    run_matrix m1 || why="clean fetch: exit $? $(grep -m1 -E 'DRIFT|resid-devgen' "$WORK/m1.log")"
    C="$WORK/cache/v9.9-test"
    sed -i 's/__u32 vmpl;/__u64 vmpl;/' "$C/include/uapi/linux/sev-guest.h"
    run_matrix m2 || why="${why:+$why; }edited header: exit $? $(grep -m1 -E 'DRIFT|resid-devgen' "$WORK/m2.log")"
    grep -q "fetched again" "$WORK/m2.log" || why="${why:+$why; }edited header: the cache was used as it was"
    grep -q "__u32 vmpl;" "$C/include/uapi/linux/sev-guest.h" || why="${why:+$why; }edited header: still in the cache"
    echo '#define SNP_GET_REPORT 0' > "$C/include/uapi/linux/stray.h"
    run_matrix m3 || why="${why:+$why; }untracked file: exit $?"
    grep -q "fetched again" "$WORK/m3.log" && [ ! -e "$C/include/uapi/linux/stray.h" ] || why="${why:+$why; }untracked file: the cache was used as it was"
    run_matrix m4 || why="${why:+$why; }clean cache: exit $?"
    grep -q "fetched again" "$WORK/m4.log" && why="${why:+$why; }a clean cache was fetched again"
    if [ -z "$why" ]; then ok devgen_cache_dirty; else bad devgen_cache_dirty "$why"; fi
fi

# The installed headers of this host, when it has them.
if selected devgen_matches_uapi_host; then
    if [ -f /usr/include/linux/ioctl.h ]; then
        "$DEVGEN" --local /usr/include > "$WORK/host.log" 2>&1; rc=$?
        if [ "$rc" -eq 0 ]; then ok devgen_matches_uapi_host; else bad devgen_matches_uapi_host "$(grep -m3 -E 'DRIFT|is |resid-devgen' "$WORK/host.log" | tr '\n' ' ')"; fi
    else
        skipped devgen_matches_uapi_host "no /usr/include/linux/ioctl.h"
    fi
fi

# The request numbers the compiled descriptors carry are the kernel's own
# _IOWR values: clang evaluates the snapshot's macros for each target here,
# independently of the generator, and a Resid program prints what its
# descriptors hold.
if selected devgen_request_numbers; then
    S="$ROOT/tools/devgen/uapi"
    printf '%s\n' '#include <linux/ioctl.h>' '#include <linux/types.h>' '#include <linux/sev-guest.h>' '#include <linux/tdx-guest.h>' '#include <linux/nsm.h>' \
        'unsigned long long resid_req[5] = { SNP_GET_REPORT, SNP_GET_DERIVED_KEY, SNP_GET_EXT_REPORT, TDX_CMD_GET_REPORT0, NSM_IOCTL_RAW };' > "$WORK/req.c"
    mkdir -p "$WORK/shim/asm"
    for h in types ioctl; do echo "#include <asm-generic/$h.h>" > "$WORK/shim/asm/$h.h"; done
    : > "$WORK/kernel.txt"
    for t in x86_64:x86 aarch64:arm64; do
        clang --target="${t%%:*}-linux-gnu" -nostdinc -ffreestanding -w -S -emit-llvm -o - \
            -I "$S/arch/${t##*:}/include/uapi" -I "$S/include/uapi" -I "$WORK/shim" "$WORK/req.c" \
            | sed -n 's/^@resid_req = .*\[\(i64 .*\)\].*/\1/p' | sed 's/i64 //g; s/, /\n/g' > "$WORK/k.${t%%:*}"
    done
    paste -d' ' "$WORK/k.x86_64" "$WORK/k.aarch64" > "$WORK/kernel.txt"
    printf '%s\n' 'import "dev/sev_guest_key.resid";' 'import "dev/sev_guest_ext.resid";' 'import "dev/tdx_guest.resid";' 'import "dev/nsm.resid";' \
        'Str reqs(IoctlOp op) { return f"{op.requests[0].number} {op.requests[1].number}"; }' \
        '@requires(device, declassify)' \
        'Int main() { println(reqs(snp_get_report_op())); println(reqs(snp_get_derived_key_op())); println(reqs(snp_get_ext_report_op())); println(reqs(tdx_get_report0_op())); println(reqs(nsm_raw_op())); return 0; }' > "$WORK/reqs.resid"
    (cd "$WORK" && timeout 600 "$COMPILER" reqs.resid -o reqs > reqs.log 2>&1 && ./reqs > resid.txt); rc=$?
    if [ "$rc" -eq 0 ] && [ "$(wc -l < "$WORK/kernel.txt")" -eq 5 ] && cmp -s "$WORK/kernel.txt" "$WORK/resid.txt"; then
        ok devgen_request_numbers
    else
        bad devgen_request_numbers "exit $rc; kernel [$(tr '\n' ',' < "$WORK/kernel.txt")] descriptors [$(tr '\n' ',' < "$WORK/resid.txt" 2>/dev/null)]"
    fi
fi

# Each generated descriptor passes E0263 for the AArch64 build too (a
# request number per target). Linking an AArch64 binary needs compiler-rt
# builtins this host may not have; E0263 runs before lowering, so the
# emitted IR is the evidence.
if selected devgen_aarch64_descriptors; then
    printf '%s\n' 'import "dev/sev_guest_key.resid";' 'import "dev/sev_guest_ext.resid";' 'import "dev/tdx_guest.resid";' 'import "dev/nsm.resid";' \
        '@requires(device, declassify)' \
        'Int main() { Bool x = match (snp_get_ext_report([(UInt(8))(rt 0)], 0)) { Ok(r) => true, Err(e) => false, }; Bool a = match (snp_get_report([(UInt(8))(rt 0)], 0)) { Ok(r) => true, Err(e) => false, }; Bool b = match (snp_get_derived_key(0, 0, 0, 0, 0)) { Ok(k) => true, Err(e) => false, }; Bool c = match (tdx_get_report0([(UInt(8))(rt 0)])) { Ok(r) => true, Err(e) => false, }; Bool d = match (nsm_request([(UInt(8))(rt 0)])) { Ok(r) => true, Err(e) => false, }; println(f"{x} {a} {b} {c} {d}"); return 0; }' > "$WORK/a64.resid"
    (cd "$WORK" && timeout 600 "$COMPILER" a64.resid -o a64 --target aarch64 > a64.log 2>&1)
    n=$(grep -c 'call void @resid_device_host()' "$WORK/a64.ll" 2>/dev/null)
    if ! grep -q 'error\[' "$WORK/a64.log" && [ "$n" = 1 ] && grep -q '"target-features"="+aes,+neon"' "$WORK/a64.ll"; then
        ok devgen_aarch64_descriptors
    else
        bad devgen_aarch64_descriptors "$(grep -m1 -E '^error' "$WORK/a64.log")"
    fi
fi

echo "---"
echo "$pass passed, $fail failed$([ "$skip" -gt 0 ] && echo ", $skip skipped")"
[ "$fail" -eq 0 ]
