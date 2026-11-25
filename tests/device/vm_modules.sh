#!/usr/bin/env bash
# Collect the kernel modules tests/device/virtio_vm.sh needs for its
# second machine (VFIO and what it depends on) into a directory, as plain
# .ko files named in the order they are to be loaded:
#
#   tests/device/vm_modules.sh OUT_DIR
#   tests/device/virtio_vm.sh -m OUT_DIR
#
# The modules are those of the kernel the machine will boot, by default
# the running one. With -r RELEASE another release's, and with -b ROOT
# from a tree that holds lib/modules/RELEASE (an unpacked package).
# Nothing is loaded or changed on this machine: the files are copied, and
# decompressed when the kernel ships them compressed. A part that is
# built into the kernel has no file and needs none.
set -u
RELEASE="$(uname -r)"
BASE=""
while getopts "r:b:" opt; do
    case "$opt" in
        r) RELEASE="$OPTARG" ;;
        b) BASE="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
shift $((OPTIND - 1))
OUT="${1:-}"
[ -n "$OUT" ] || { echo "usage: $0 [-r RELEASE] [-b ROOT] OUT_DIR"; exit 2; }
command -v modprobe >/dev/null || { echo "no modprobe (install kmod)"; exit 1; }
[ -d "$BASE/lib/modules/$RELEASE" ] || { echo "no modules for kernel $RELEASE under ${BASE:-/}lib/modules"; exit 1; }
mkdir -p "$OUT" || exit 1
ARGS=(-S "$RELEASE")
[ -n "$BASE" ] && ARGS+=(-d "$BASE")
# What loading vfio-pci and the IOMMU backend would load, in order.
LIST="$( { modprobe "${ARGS[@]}" --show-depends vfio-pci; modprobe "${ARGS[@]}" --show-depends vfio_iommu_type1; } 2>/dev/null | awk '$1 == "insmod" { print $2 }' | awk '!seen[$0]++')"
if [ -z "$LIST" ]; then
    echo "modprobe names no module files for vfio-pci in kernel $RELEASE: VFIO is built in (then run virtio_vm.sh with an empty -m directory) or not there"
    [ -n "$BASE" ] && echo "(for an unpacked tree, run depmod -b $BASE $RELEASE first)"
    exit 1
fi
n=0
for f in $LIST; do
    n=$((n + 1))
    name="$(basename "$f")"
    plain="${name%.zst}"; plain="${plain%.xz}"; plain="${plain%.gz}"
    to="$OUT/$(printf '%02d' "$n")-$plain"
    case "$name" in
        *.zst) command -v zstd >/dev/null || { echo "no zstd to decompress $name"; exit 1; }; zstd -dqf "$f" -o "$to" ;;
        *.xz) command -v xz >/dev/null || { echo "no xz to decompress $name"; exit 1; }; xz -dc "$f" > "$to" ;;
        *.gz) gzip -dc "$f" > "$to" ;;
        *) cp "$f" "$to" ;;
    esac || { echo "could not copy $f"; exit 1; }
    echo "  $(basename "$to")"
done
echo "$n module(s) of kernel $RELEASE in $OUT"
