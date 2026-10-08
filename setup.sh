#!/usr/bin/env bash
# One-command setup: checks prerequisites, builds the compiler (boot.sh),
# installs it (install.sh), and puts residc on your PATH by adding one
# `source ~/.resid/env` line to your shell's rc file.
#
# Usage:
#   ./setup.sh             full setup
#   ./setup.sh --no-rc     skip editing the shell rc file
#   ./setup.sh --help
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${RESID_INSTALL:-$HOME/.resid}"
EDIT_RC=1

while [ $# -gt 0 ]; do
    case "$1" in
        --no-rc) EDIT_RC=0; shift ;;
        -h|--help) sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "error: unknown option '$1' (try --help)" >&2; exit 1 ;;
    esac
done

die() { echo "error: $*" >&2; exit 1; }

# ── Prerequisites ────────────────────────────────────────────────────────
missing=0
command -v clang >/dev/null || { missing=1; echo "✗ clang not found"; }
command -v timeout >/dev/null || { missing=1; echo "✗ timeout (coreutils) not found"; }
if [ "$missing" -eq 1 ]; then
    cat >&2 <<EOF
Install the missing tools first, e.g.:
  Debian/Ubuntu:  sudo apt install clang
  Fedora:         sudo dnf install clang
  Arch:           sudo pacman -S clang
  macOS:          xcode-select --install
Then re-run ./setup.sh
EOF
    exit 1
fi
echo "==> prerequisites OK (clang $(clang --version | head -1 | grep -o '[0-9][0-9.]*' | head -1))"

# ── Build + install ──────────────────────────────────────────────────────
"$SCRIPT_DIR/boot.sh"
"$SCRIPT_DIR/install.sh"

# ── PATH ─────────────────────────────────────────────────────────────────
if [ "$EDIT_RC" -eq 1 ]; then
    case "$(basename "${SHELL:-bash}")" in
        fish) rc="$HOME/.config/fish/config.fish"; line="source $TARGET/env.fish" ;;
        zsh)  rc="$HOME/.zshrc";                      line="source $TARGET/env" ;;
        *)    rc="$HOME/.bashrc";                     line="source $TARGET/env" ;;
    esac
    mkdir -p "$(dirname "$rc")"
    if [ -f "$rc" ] && grep -qF "source $TARGET/env" "$rc"; then
        echo "==> $rc already sources $TARGET/env"
    else
        printf '\n# Resid compiler\n%s\n' "$line" >> "$rc"
        echo "==> added '$line' to $rc"
    fi
fi

# Committed git hooks (.githooks/pre-commit checks the seed artifacts).
if git -C "$SCRIPT_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    git -C "$SCRIPT_DIR" config core.hooksPath .githooks
    echo "==> git hooks: core.hooksPath set to .githooks"
fi

echo
echo "Done. Open a new shell (or run: source $TARGET/env), then: residc --help"
