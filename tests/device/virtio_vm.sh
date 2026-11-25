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
#   tests/device/virtio_vm.sh [-c COMPILER] [-k KERNEL_IMAGE] [-m MODULES] [-v]
#
# -v: the kernel's own messages are kept on the machine's console (they
# are shown when a machine fails), for finding out why one did not boot.
#
# With MODULES (or $RESID_VM_MODULES), a directory holding that kernel's
# VFIO modules as .ko files whose names sort in the order they are loaded
# (tests/device/vm_modules.sh makes one; a part built into the kernel has
# no file),
# a second machine is booted with an emulated IOMMU, the device is bound
# to vfio-pci, and tests/device/vm/virtio_rng.resid drives it: a
# virtqueue laid out in memory the device host maps for the device, one
# buffer offered, and the random bytes the device wrote read back. Then
# tests/device/vm/virtio_blk.resid drives a virtio disk: sectors read and
# written by requests of three descriptors, one at a time and sixteen in
# flight. Then tests/device/vm/virtio_net.resid drives a virtio network
# device on QEMU's own network: an ARP request sent on one queue, and the
# gateway's reply received on the other. Last,
# tests/device/vm/virtio_rng_driver.resid runs the entropy device's driver
# inside the device host: the program only sends it messages; and
# tests/device/vm/virtio_blk_driver.resid does the same for the disk,
# whose driver takes requests to read and write sectors.
#
# KERNEL_IMAGE defaults to $RESID_VM_KERNEL, then the newest readable
# /boot/vmlinuz-*. Exit 0 on a pass or a skip (a tool is missing), 1 on a
# difference.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CASES="$ROOT/tests/device/cases"
COMPILER="$ROOT/build/boot/residc"
KERNEL="${RESID_VM_KERNEL:-}"
MODULES="${RESID_VM_MODULES:-}"
QUIET="quiet"
while getopts "c:k:m:v" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        k) KERNEL="$(realpath "$OPTARG")" ;;
        m) MODULES="$(realpath "$OPTARG")" ;;
        v) QUIET="" ;;
        *) exit 2 ;;
    esac
done
if [ -z "$KERNEL" ]; then
    # The running kernel's image first: where distributions keep a copy
    # anyone may read, then /boot.
    for k in "/usr/lib/modules/$(uname -r)/vmlinuz" "/lib/modules/$(uname -r)/vmlinuz" "/boot/vmlinuz-$(uname -r)" $(ls -t /boot/vmlinuz-* 2>/dev/null); do [ -r "$k" ] && { KERNEL="$k"; break; }; done
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
for prog in virtio_bring_up virtio_session virtio_rng virtio_blk virtio_net virtio_rng_driver virtio_blk_driver; do
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

# A machine that did not finish: QEMU's exit status and the end of its
# console, as text a terminal shows (the console's carriage returns and
# escape sequences taken out).
vm_failed() {
    echo "FAIL virtio_vm$1: the program did not finish in the machine (qemu exit $2, kernel $KERNEL)"
    tr -d '\r' < "$3" | sed 's/\x1b\[[0-9;?]*[a-zA-Z]//g; s/\x1bc//g' | grep -v '^[[:space:]]*$' | tail -${4:-25} | sed 's/^/  | /'
    [ -n "$QUIET" ] && echo "  (run again with -v for the kernel's own messages)"
    return 0
}
ACCEL=""
[ -w /dev/kvm ] && ACCEL="-enable-kvm -cpu host"
if [ -n "$ACCEL" ]; then echo "  (hardware virtualisation: the times are this machine's)"; else echo "  (no /dev/kvm: the machine is emulated, about 75 times slower)"; fi
timeout 600 qemu-system-x86_64 -M q35 $ACCEL -m 512 -nographic -no-reboot \
    -kernel "$KERNEL" -initrd "$WORK/initrd.gz" -append "console=ttyS0 $QUIET panic=-1" \
    -device virtio-rng-pci,disable-legacy=on < /dev/null > "$WORK/console.log" 2>&1
QRC=$?
tr -d '\r' < "$WORK/console.log" | sed -n '/VM-BEGIN$/,/^VM-END/p' | sed '1d;$d' > "$WORK/out.txt"
if ! grep -q '^VM-END 0' <(tr -d '\r' < "$WORK/console.log"); then
    vm_failed "" "$QRC" "$WORK/console.log" 40; exit 1
fi
if cmp -s "$WORK/out.txt" "$ROOT/tests/device/vm/virtio_vm.out"; then
    echo "PASS virtio_vm"; cat "$WORK/out.txt" | sed 's/^/    /'
else
    echo "FAIL virtio_vm: output differs from vm/virtio_vm.out"; diff "$WORK/out.txt" "$ROOT/tests/device/vm/virtio_vm.out" 2>&1 | head -20; echo "  got:"; sed 's/^/    /' "$WORK/out.txt"; exit 1
fi

# The queue: a machine with an IOMMU, the device bound to vfio-pci.
if [ -z "$MODULES" ] || [ ! -d "$MODULES" ]; then
    echo "SKIP virtio_vm queue (no VFIO modules: pass -m DIR)"; exit 0
fi
mkdir -p "$R/ko"
cp "$MODULES"/*.ko "$R/ko/" 2>/dev/null
cp "$WORK/virtio_rng" "$WORK/virtio_blk" "$WORK/virtio_net" "$WORK/virtio_rng_driver" "$WORK/virtio_blk_driver" "$R/"
# A disk of 2048 sectors, a line of text at the start of sector 3.
dd if=/dev/zero of="$WORK/disk.img" bs=512 count=2048 2>/dev/null
printf 'RESID-SECTOR-THREE' | dd of="$WORK/disk.img" bs=512 seek=3 conv=notrunc 2>/dev/null
cat > "$R/init" <<'INIT'
#!/bin/busybox sh
/bin/busybox --install -s /bin
mount -t proc proc /proc; mount -t sysfs sys /sys; mount -t devtmpfs dev /dev
mkdir -p /dev/shm; mount -t tmpfs shm /dev/shm
# The modules, in the order of their names (tests/device/vm_modules.sh
# numbers them as they are to be loaded).
for m in /ko/*.ko; do
    [ -f "$m" ] && insmod "$m"
done
# Give the entropy device (1af4:1044) and the disk (1af4:1042) to vfio-pci.
for d in /sys/bus/pci/devices/*; do
    if [ "$(cat $d/vendor)" = "0x1af4" ] && { [ "$(cat $d/device)" = "0x1044" ] || [ "$(cat $d/device)" = "0x1042" ] || [ "$(cat $d/device)" = "0x1041" ]; }; then
        [ -e "$d/driver" ] && echo "$(basename $d)" > "$d/driver/unbind"
        echo vfio-pci > "$d/driver_override"
        echo "$(basename $d)" > /sys/bus/pci/drivers_probe
    fi
done
echo "VM-BEGIN"
/virtio_rng; a=$?
echo "-- a disk"
/virtio_blk; b=$?
echo "-- a network"
/virtio_net; c=$?
echo "-- a driver in its host"
/virtio_rng_driver; d=$?
echo "-- a disk's driver in its host"
/virtio_blk_driver; e=$?
echo "VM-END $((a + b + c + d + e))"
poweroff -f
INIT
chmod +x "$R/init"
(cd "$R" && find . | cpio -o -H newc 2>/dev/null | gzip > "$WORK/initrd2.gz")
timeout 600 qemu-system-x86_64 -M q35,kernel-irqchip=split $ACCEL -m 512 -nographic -no-reboot \
    -kernel "$KERNEL" -initrd "$WORK/initrd2.gz" -append "console=ttyS0 $QUIET panic=-1 intel_iommu=on" \
    -device intel-iommu,intremap=on -device virtio-rng-pci,disable-legacy=on,iommu_platform=on \
    -drive file="$WORK/disk.img",if=none,id=d0,format=raw -device virtio-blk-pci,drive=d0,disable-legacy=on,iommu_platform=on \
    -netdev user,id=n0 -device virtio-net-pci,netdev=n0,mac=52:54:00:12:34:56,disable-legacy=on,iommu_platform=on < /dev/null > "$WORK/console2.log" 2>&1
QRC=$?
tr -d '\r' < "$WORK/console2.log" | sed -n '/VM-BEGIN$/,/^VM-END/p' | sed '1d;$d' > "$WORK/all2.txt"
# Timings are shown, not compared: they depend on the machine (and without
# KVM the machine is emulated instruction by instruction).
grep -v '^note:' "$WORK/all2.txt" > "$WORK/out2.txt"
grep '^note:' "$WORK/all2.txt" | sed 's/^/  /'
if ! grep -q '^VM-END 0' <(tr -d '\r' < "$WORK/console2.log"); then
    vm_failed " queue" "$QRC" "$WORK/console2.log" 40; exit 1
fi
# What the program wrote to sector 5 is on the disk: 512 bytes, byte i
# being (3 i + 7) mod 251, so it starts 7, 10, 13, 16.
SECTOR5="$(dd if="$WORK/disk.img" bs=512 skip=5 count=1 2>/dev/null | od -An -tu1 -N4 | tr -s ' ' | sed 's/^ //')"
if [ "$SECTOR5" != "7 10 13 16" ]; then
    echo "FAIL virtio_vm queue: sector 5 of the disk starts '$SECTOR5', not '7 10 13 16'"; sed 's/^/    /' "$WORK/out2.txt"; exit 1
fi
# And sector 12, one of sixteen written in flight: byte i is (i + 156) mod 251.
SECTOR12="$(dd if="$WORK/disk.img" bs=512 skip=12 count=1 2>/dev/null | od -An -tu1 -N4 | tr -s ' ' | sed 's/^ //')"
if [ "$SECTOR12" != "156 157 158 159" ]; then
    echo "FAIL virtio_vm queue: sector 12 of the disk starts '$SECTOR12', not '156 157 158 159'"; sed 's/^/    /' "$WORK/out2.txt"; exit 1
fi
# And sector 6, written by the disk's driver in its host: byte i is
# (5 i + 11) mod 251.
SECTOR6="$(dd if="$WORK/disk.img" bs=512 skip=6 count=1 2>/dev/null | od -An -tu1 -N4 | tr -s ' ' | sed 's/^ //')"
if [ "$SECTOR6" != "11 16 21 26" ]; then
    echo "FAIL virtio_vm queue: sector 6 of the disk starts '$SECTOR6', not '11 16 21 26'"; sed 's/^/    /' "$WORK/out2.txt"; exit 1
fi
if cmp -s "$WORK/out2.txt" "$ROOT/tests/device/vm/virtio_rng.out"; then
    echo "PASS virtio_vm queue"; cat "$WORK/out2.txt" | sed 's/^/    /'
else
    echo "FAIL virtio_vm queue: output differs from vm/virtio_rng.out"; diff "$WORK/out2.txt" "$ROOT/tests/device/vm/virtio_rng.out" 2>&1 | head -20; echo "  got:"; sed 's/^/    /' "$WORK/out2.txt"; exit 1
fi
