#!/usr/bin/env bash
# A real register read and write, in a virtual machine: boots a Linux
# kernel under QEMU with a virtio entropy device, takes the device from
# the kernel's driver, and runs tests/device/vm/virtio_bring_up.resid
# there as root, then tests/device/vm/virtio_session.resid, which does the
# same through a session (one host kept alive). The program finds the device by its ids, reads where its
# common configuration is from its capability list, and resets it,
# acknowledges it and reads its features through a register block
# (PLAN-hardware-access.md §11). Each access is a device host that maps
# the device's resource; nothing here is a fixture.
#
# Not part of run.sh: it needs qemu-system-x86_64, a static busybox, cpio
# and a kernel image, and about a minute without KVM.
#
#   tests/device/virtio_vm.sh [-c COMPILER] [-k KERNEL_IMAGE]
#
# KERNEL_IMAGE defaults to $RESID_VM_KERNEL, then the newest readable
# /boot/vmlinuz-*. Exit 0 on a pass or a skip (a tool is missing), 1 on a
# difference.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CASES="$ROOT/tests/device/cases"
COMPILER="$ROOT/build/boot/residc"
KERNEL="${RESID_VM_KERNEL:-}"
while getopts "c:k:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        k) KERNEL="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
if [ -z "$KERNEL" ]; then
    for k in $(ls -t /boot/vmlinuz-* 2>/dev/null); do [ -r "$k" ] && { KERNEL="$k"; break; }; done
fi
BB="$(command -v busybox || true)"
for t in qemu-system-x86_64 cpio gzip; do
    command -v "$t" >/dev/null || { echo "SKIP virtio_vm (no $t)"; exit 0; }
done
[ -n "$BB" ] && ! ldd "$BB" >/dev/null 2>&1 || { echo "SKIP virtio_vm (no static busybox)"; exit 0; }
[ -n "$KERNEL" ] && [ -r "$KERNEL" ] || { echo "SKIP virtio_vm (no readable kernel image; pass -k)"; exit 0; }
[ -x "$COMPILER" ] || { echo "compiler not found: $COMPILER (run ./boot.sh)"; exit 2; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
if [ -z "${RESID_SIGNING_KEY:-}" ] && [ -f "$ROOT/keys/resid-ed25519.key" ]; then
    export RESID_SIGNING_KEY="$ROOT/keys/resid-ed25519.key"
elif [ -z "${RESID_SIGNING_KEY:-}" ]; then
    "$COMPILER" keygen "$WORK/keys" >/dev/null && export RESID_SIGNING_KEY="$WORK/keys/resid-ed25519.key"
fi
# A private home with the case's fixture descriptors, as run.sh makes.
HOME_DIR="$WORK/home"
mkdir -p "$HOME_DIR"
cp -r "$ROOT/lib" "$HOME_DIR/lib"
ln -s "$ROOT/build/boot/rt.ll" "$HOME_DIR/rt.ll"
cp "$CASES/device_virtio_window.dev" "$HOME_DIR/lib/dev/fx_device_virtio_window.resid"
for prog in virtio_bring_up virtio_session; do
    if ! RESID_HOME="$HOME_DIR" "$COMPILER" "$ROOT/tests/device/vm/$prog.resid" -o "$WORK/$prog" > "$WORK/compile.log" 2>&1; then
        echo "FAIL virtio_vm: $prog: compile failed"; grep -v '^OK ' "$WORK/compile.log" | head -20; exit 1
    fi
done

# The initial file system: busybox, the program and the libraries it loads.
R="$WORK/root"
mkdir -p "$R/bin" "$R/proc" "$R/sys" "$R/dev" "$R/tmp"
cp "$BB" "$R/bin/busybox"
cp "$WORK/virtio_bring_up" "$WORK/virtio_session" "$R/"
for l in $(ldd "$WORK/virtio_bring_up" 2>/dev/null | grep -o '/[^ ]*'); do
    mkdir -p "$R$(dirname "$l")"; cp -L "$l" "$R$l"
done
cat > "$R/init" <<'INIT'
#!/bin/busybox sh
/bin/busybox --install -s /bin
mount -t proc proc /proc; mount -t sysfs sys /sys; mount -t devtmpfs dev /dev
mkdir -p /dev/shm; mount -t tmpfs shm /dev/shm
# Take the entropy device (1af4:1044) from the kernel's driver, and leave
# its memory decoding on.
for d in /sys/bus/pci/devices/*; do
    if [ "$(cat $d/vendor)" = "0x1af4" ] && [ "$(cat $d/device)" = "0x1044" ]; then
        [ -e "$d/driver" ] && echo "$(basename $d)" > "$d/driver/unbind"
        echo 1 > "$d/enable"
    fi
done
echo "VM-BEGIN"
/virtio_bring_up; a=$?
echo "-- through a session"
/virtio_session; b=$?
echo "VM-END $((a + b))"
poweroff -f
INIT
chmod +x "$R/init"
(cd "$R" && find . | cpio -o -H newc 2>/dev/null | gzip > "$WORK/initrd.gz")

ACCEL=""
[ -w /dev/kvm ] && ACCEL="-enable-kvm -cpu host"
timeout 600 qemu-system-x86_64 -M q35 $ACCEL -m 512 -nographic -no-reboot \
    -kernel "$KERNEL" -initrd "$WORK/initrd.gz" -append "console=ttyS0 quiet panic=-1" \
    -device virtio-rng-pci,disable-legacy=on > "$WORK/console.log" 2>&1
tr -d '\r' < "$WORK/console.log" | sed -n '/VM-BEGIN$/,/^VM-END/p' | sed '1d;$d' > "$WORK/out.txt"
if ! grep -q '^VM-END 0' <(tr -d '\r' < "$WORK/console.log"); then
    echo "FAIL virtio_vm: the program did not finish in the machine"; tail -20 "$WORK/console.log"; exit 1
fi
if cmp -s "$WORK/out.txt" "$ROOT/tests/device/vm/virtio_vm.out"; then
    echo "PASS virtio_vm"; cat "$WORK/out.txt" | sed 's/^/    /'
else
    echo "FAIL virtio_vm: output differs from vm/virtio_vm.out"; diff "$WORK/out.txt" "$ROOT/tests/device/vm/virtio_vm.out" 2>&1 | head -20; echo "  got:"; sed 's/^/    /' "$WORK/out.txt"; exit 1
fi
