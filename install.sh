#!/usr/bin/env bash
# Installs the Resid compiler, runtime and standard library into a per-user
# location (~/.resid, or $RESID_INSTALL if set), so `residc` works from any
# directory without setting RESID_HOME or sitting in this checkout.
#
# Layout: bin/residc (the command; sets RESID_HOME to the install),
# bin/stage2.bin (the compiler), bin/resid-manifest, bin/resid-pkg and
# bin/resid-fetch (the package tools), rt.ll (the runtime), lib/ (the standard
# library), keys/ (a signing key for release builds, created once and never
# replaced), env and env.fish (PATH snippets to source).
#
# ./boot.sh builds and verifies the compiler for this checkout, then
# refreshes an install that already exists (RESID_NO_INSTALL_REFRESH=1
# skips that). A first install is this separate step.
#
# Usage:
#   ./install.sh          install or refresh
#   ./install.sh --help
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${RESID_INSTALL:-$HOME/.resid}"

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *)
            echo "error: unknown option '$1' (try --help)" >&2
            exit 1
            ;;
    esac
done

# A mistyped RESID_INSTALL must not turn the `rm -rf` below into something
# catastrophic, nor point into a checkout's build tree.
case "$TARGET" in
    ""|/|"$HOME"|"$SCRIPT_DIR"|"$SCRIPT_DIR"/*)
        echo "error: refusing unsafe install target: '$TARGET'" >&2
        exit 1
        ;;
    /*) ;;
    *)
        echo "error: RESID_INSTALL must be an absolute path, got: '$TARGET'" >&2
        exit 1
        ;;
esac

BOOT="$SCRIPT_DIR/build/boot"
for f in stage2.bin rt.ll; do
    [ -f "$BOOT/$f" ] || { echo "error: build/boot/$f missing -- run ./boot.sh first" >&2; exit 1; }
done
command -v clang > /dev/null || echo "warning: clang not found on PATH; residc needs it to link programs" >&2

echo "Installing to $TARGET"
mkdir -p "$TARGET/bin"
# Copied to a temporary name first: a running residc keeps its old binary.
cp "$BOOT/stage2.bin" "$TARGET/bin/.stage2.bin.new"
mv -f "$TARGET/bin/.stage2.bin.new" "$TARGET/bin/stage2.bin"
cp "$BOOT/rt.ll" "$TARGET/.rt.ll.new"
mv -f "$TARGET/.rt.ll.new" "$TARGET/rt.ll"
# The AArch64 runtime, and compiler-rt's builtins when present, for
# `residc --target aarch64`.
if [ -f "$BOOT/rt-aarch64.ll" ]; then
    cp "$BOOT/rt-aarch64.ll" "$TARGET/.rt-aarch64.ll.new"
    mv -f "$TARGET/.rt-aarch64.ll.new" "$TARGET/rt-aarch64.ll"
fi
if [ -f "$BOOT/aarch64/libclang_rt.builtins.a" ]; then
    mkdir -p "$TARGET/aarch64"
    cp "$BOOT/aarch64/libclang_rt.builtins.a" "$TARGET/aarch64/libclang_rt.builtins.a"
fi
rm -rf "$TARGET/lib"
mkdir -p "$TARGET/lib"
cp "$SCRIPT_DIR"/lib/*.resid "$TARGET/lib/"

cat > "$TARGET/bin/residc" <<WRAPPER
#!/usr/bin/env bash
# The installed Resid compiler (install.sh): the runtime, the standard
# library and the signing key are found under $TARGET.
set -euo pipefail
export RESID_HOME="$TARGET"
exec "$TARGET/bin/stage2.bin" "\$@"
WRAPPER
chmod +x "$TARGET/bin/residc"

# Release builds are signed; the key is made once and kept across
# reinstalls (uninstall.sh keeps it too).
if [ ! -f "$TARGET/keys/resid-ed25519.key" ]; then
    echo "Creating a signing key in $TARGET/keys"
    (cd "$TARGET" && "$TARGET/bin/residc" keygen keys > /dev/null)
fi

# The package tools, built by the installed compiler: resid-manifest
# (resolve, depmap, build, test), resid-pkg (pack, sign, publish, serve)
# and resid-fetch (one artifact over https).
echo "Building the package tools..."
TOOLS="$(mktemp -d)"
for t in resid-manifest resid-pkg resid-fetch; do
    if (cd "$TOOLS" && env -u RESID_HOME "$TARGET/bin/residc" "$SCRIPT_DIR/tools/$t.resid" -o "$TOOLS/$t" > "$TOOLS/$t.log" 2>&1); then
        cp "$TOOLS/$t" "$TARGET/bin/.$t.new" && mv -f "$TARGET/bin/.$t.new" "$TARGET/bin/$t"
    else
        echo "  WARNING: $t did not build:" >&2
        grep -m3 -i "error" "$TOOLS/$t.log" >&2 || tail -3 "$TOOLS/$t.log" >&2
    fi
done
rm -rf "$TOOLS"

cat > "$TARGET/env" <<ENVFILE
# source this file (or add the line below to your shell rc) to use residc
export PATH="$TARGET/bin:\$PATH"
ENVFILE
cat > "$TARGET/env.fish" <<ENVFILE
# source this file (or add the line below to your fish config) to use residc
set -gx PATH "$TARGET/bin" \$PATH
ENVFILE

# The install works away from the checkout: build and run a program in an
# empty directory, then ask the language server to initialize.
echo "Checking the install..."
PROBE="$(mktemp -d)"
trap 'rm -rf "$PROBE"' EXIT
cat > "$PROBE/hello.resid" <<'EOF'
import "crypto.resid";
Int main() { println(if (str_len(hex_encode(bytes_of("ok"))) == 4) { "ok" } else { "bad" }); return 0; }
EOF
if (cd "$PROBE" && env -u RESID_HOME "$TARGET/bin/residc" hello.resid -o hello > build.log 2>&1 && ./hello | grep -qx ok); then
    echo "  compile and run OK"
else
    echo "  WARNING: the installed compiler could not build a program:" >&2
    grep -m3 -i "error" "$PROBE/build.log" >&2 || tail -3 "$PROBE/build.log" >&2
fi
LSP_INIT='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":null,"capabilities":{}}}'
LSP_EXIT='{"jsonrpc":"2.0","method":"exit","params":{}}'
lsp_frame() { printf 'Content-Length: %d\r\n\r\n%s' "${#1}" "$1"; }
# Captured first: `grep -q` quitting early would fail the pipe (pipefail).
LSP_OUT="$({ lsp_frame "$LSP_INIT"; lsp_frame "$LSP_EXIT"; } | (cd "$PROBE" && timeout 20 "$TARGET/bin/residc" lsp 2> /dev/null) || true)"
if grep -q '"capabilities"' <<< "$LSP_OUT"; then
    echo "  language server OK"
else
    echo "  WARNING: the language server (residc lsp) did not answer an initialize request" >&2
fi

echo
echo "Installed:"
echo "  $TARGET/bin/residc   compiler (residc lsp: language server)"
echo "  $TARGET/bin/resid-manifest, resid-pkg, resid-fetch   package tools"
echo "  $TARGET/lib/         standard library"
echo "  $TARGET/keys/        release signing key"
echo
case ":$PATH:" in
    *":$TARGET/bin:"*) echo "$TARGET/bin is already on PATH." ;;
    *)
        case "$(basename "${SHELL:-bash}")" in
            fish) echo "Add this to ~/.config/fish/config.fish:"; echo "  source $TARGET/env.fish" ;;
            *)    echo "Add this to your shell's rc file (~/.bashrc, ~/.zshrc, ...):"; echo "  source $TARGET/env" ;;
        esac
        echo "Or run that command directly to use residc in this shell session."
        ;;
esac
