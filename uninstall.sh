#!/usr/bin/env bash
# Removes what install.sh put under ~/.resid (or $RESID_INSTALL if set):
# bin/residc, bin/stage2.bin, rt.ll, lib/ and the env snippets. The signing
# key (keys/, which cannot be recreated) and anything else you put there
# are kept, and listed.
#
# install.sh never edits your shell profile, so neither does this. Remove
# any `source ~/.resid/env` line you added by hand.
#
# Usage:
#   ./uninstall.sh            remove only what install.sh installed
#   ./uninstall.sh --purge    remove the whole directory, keys included
#                             (asks first; --yes skips the question)
#   ./uninstall.sh --help
set -euo pipefail
TARGET="${RESID_INSTALL:-$HOME/.resid}"
PURGE=0
YES=0

while [ $# -gt 0 ]; do
    case "$1" in
        --purge) PURGE=1; shift ;;
        -y|--yes) YES=1; shift ;;
        -h|--help)
            sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *)
            echo "error: unknown option '$1' (try --help)" >&2
            exit 1
            ;;
    esac
done

case "$TARGET" in
    ""|/|"$HOME")
        echo "error: refusing unsafe removal target: '$TARGET'" >&2
        exit 1
        ;;
    /*) ;;
    *)
        echo "error: RESID_INSTALL must be an absolute path, got: '$TARGET'" >&2
        exit 1
        ;;
esac

if [ ! -d "$TARGET" ]; then
    echo "Nothing to remove: $TARGET does not exist"
    exit 0
fi
# Only a directory install.sh made: its wrapper names it, or (after a plain
# uninstall) only the kept signing key is left.
if ! grep -qs "install.sh" "$TARGET/bin/residc" && [ ! -f "$TARGET/keys/resid-ed25519.key" ]; then
    echo "error: $TARGET does not look like a Resid install (no bin/residc from install.sh)" >&2
    exit 1
fi

if [ "$PURGE" -eq 1 ]; then
    echo "WARNING: --purge deletes all of $TARGET, including:"
    [ -d "$TARGET/keys" ] && echo "  $TARGET/keys   the release signing key (cannot be recovered)"
    if [ "$YES" -eq 0 ]; then
        if [ ! -t 0 ]; then
            echo "error: --purge needs confirmation; re-run with --yes to confirm non-interactively" >&2
            exit 1
        fi
        printf "Type 'purge' to delete %s: " "$TARGET"
        read -r answer
        if [ "$answer" != "purge" ]; then
            echo "Aborted; nothing removed."
            exit 1
        fi
    fi
    rm -rf "$TARGET"
    echo "Removed $TARGET"
    exit 0
fi

echo "Removing the Resid installation from $TARGET"
for f in bin/residc bin/stage2.bin bin/resid-manifest bin/resid-pkg bin/resid-fetch rt.ll env env.fish; do
    if [ -e "$TARGET/$f" ]; then
        rm -f "$TARGET/$f"
        echo "  removed $f"
    fi
done
rmdir "$TARGET/bin" 2> /dev/null && echo "  removed bin/" || true
if [ -d "$TARGET/lib" ]; then
    rm -rf "$TARGET/lib"
    echo "  removed lib/"
fi

KEPT="$(cd "$TARGET" && ls -A)"
if [ -z "$KEPT" ]; then
    rmdir "$TARGET"
    echo "Removed the now-empty $TARGET"
else
    echo "Kept in $TARGET (use --purge to delete these too):"
    printf '%s\n' "$KEPT" | while IFS= read -r name; do
        case "$name" in
            keys) echo "  $name/  release signing key" ;;
            *)    echo "  $name" ;;
        esac
    done
fi
echo "Done."
