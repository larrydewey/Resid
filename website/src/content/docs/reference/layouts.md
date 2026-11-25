---
title: Layout types
description: Record types with a fixed byte layout, and the parsers and serializers the compiler writes for them.
---

A **layout type** is an ordinary record type marked `@layout(c_abi)`,
`@layout(le)` or `@layout(be)`. The compiler writes its parser and its
serializer; nothing else needs to read its bytes. The design is
`PLAN-labels.md` §7 in the repository; layout types are how bytes from
outside the program (device replies, wire formats, signed reports) are
read.

```text
import "dev/device.resid";            // DeviceError

@layout(c_abi)
pub type DemoResp = {
    @check(status == 0, Kernel(status)) UInt(32) status;
    @check(report_size <= 4000) UInt(32) report_size;
    @reserved(24);
    @len(report_size) List(UInt(8)) report;
};
```

## Layouts

- `c_abi`: the target's C layout. Every field is aligned to its size, the
  type to its largest field, and the type is padded at the end; integers
  are little-endian (both targets are). Only the last field may have a
  variable length (a flexible array member). The offsets are checked
  against clang for x86-64 and AArch64 (`tests/labels`).
- `le`, `be`: packed, in that byte order. Variable lengths may appear
  anywhere, and a parse must consume its bytes exactly.

## Fields and annotations

Fields are `UInt(8|16|32|64)`, `Int(8|16|32|64)`, `List(UInt(8))` with a
`@len`, or another layout type of the same layout (of fixed size under
`c_abi`).

| Annotation | Meaning |
|---|---|
| `@check(e)` | a condition over this and earlier fields: checked while parsing (else `BadReply(type, "field: e")`) and before serializing (else `BadInput`) |
| `@check(e, Ctor(args))` | as above, failing with that `DeviceError` constructor, the type's name first and each argument as an `Int`: `Kernel(status)` gives `Kernel("DemoResp", status)` |
| `@len(f)` / `@len(n)` | the byte length of a `List(UInt(8))` field: an earlier integer field, or a constant |
| `@reserved(n)` | n bytes no ABI defines: written as zero, ignored when read, never named in a literal |

Bits inside a word are a single integer field whose rules are `@check`s
written with `& | << >>`.

## What the compiler writes

For `DemoResp` (snake case `demo_resp`):

```text
Result(DemoResp, DeviceError) demo_resp_parse(List(UInt(8)) b)
Result(DemoResp__At, DeviceError) demo_resp_parse_at(List(UInt(8)) b, Int at)   // { DemoResp v; Int end; }
Result(List(UInt(8)), DeviceError) demo_resp_bytes(DemoResp r)
Int demo_resp_size()                       // the fixed part, padding included
Int demo_resp__status_at()                 // each field's offset (c_abi)
```

Every parser is total: it checks each length against the bytes it was
given before it reads or slices, so any input yields a value or an error,
never an abort; it reads each byte once and never backtracks. A failure is
`BadReply(type, "field: truncated")`, a failed check, or `trailing bytes`
(`le`/`be`). The serializer checks every `@check` and every `@len` against
the list it is given.

## Rules

A layout field may not hold a type only the runtime builds
(`ChallengeRecord` and the like, `E0274`), and a `Secret` field takes no
`@check` (`E0273`). Everything else that is malformed is `E0272`.
`Secret` fields and `Challenge(N)` request fields arrive with channels
(phase 3 of the plan).

## Packed word types

A **word type** is a record marked `@word(N)` that fits in one N-bit
word (N is 8, 16, 32 or 64). Its fields lie in order from the low bit,
each as wide as its type: a `Bool` is one bit, a `UInt(K)` K bits, and
`@reserved(n);` stands for n bits that nothing names. The widths must
add up to N.

```resid
@word(16)
type QueueCtl = {
    UInt(10) size;
    UInt(2) mode;
    @reserved(3);
    Bool enabled;
};

Int main() {
    QueueCtl q = QueueCtl { .size = 1023, .mode = 2, .enabled = true };
    UInt(16) w = queue_ctl_word(q);
    QueueCtl r = queue_ctl_from_word(w);
    println(f"{w} {r.size} {r.mode} {r.enabled}");     //> 35839 1023 2 true
    return 0;
}
```

For a type `QueueCtl` the compiler writes `queue_ctl_word(QueueCtl) ->
UInt(16)` and `queue_ctl_from_word(UInt(16)) -> QueueCtl`; no code
shifts or masks by hand. Reserved bits are written as zero and ignored
when read, so every word is some record and reading cannot fail. A word
type is not a layout type: its layout is this one, on every target. A
malformed one is `E0295`.

### Whose field it is

A device register has bits the device sets and bits the driver sets. A
field says which by its type:

| Field | Read | In a literal |
|---|---|---|
| `Bool f;`, `UInt(K) f;` | yes | must be named |
| `DeviceOwned(T) f;` | yes | may not be named (`E0296`); written as zero |
| `DriverOwned(T) f;` | never (`E0297`); reads as zero | must be named |
| `DeviceLatch(Bool) f;` | `f`: yes. `clear_f`: never | `f` may not be named; `clear_f` may be left out |

```resid
@word(8)
type IrqStatus = {
    DeviceLatch(Bool) queue;      // set by the device, cleared by writing one
    DeviceLatch(Bool) config;
    Bool enable;
    @reserved(5);
};

Int main() {
    IrqStatus s = irq_status_from_word(7);
    println(f"{s.queue} {s.config} {irq_status_word(s)}");                //> true true 4
    println(f"{irq_status_word(IrqStatus { .clear_queue = true, .enable = true })}");   //> 5
    return 0;
}
```

A `DeviceLatch(Bool) f` is a bit the device sets and the driver clears by
writing one. The record has `f`, which is read, and `clear_f`, which a
literal sets to clear the bit or leaves out to keep it. Writing back a
value that was read writes zero there, so it never clears an event the
driver has not handled.

## Register blocks

A device's registers are a record of word types marked
`@registers(size = N)`, each at the byte offset its datasheet gives:

```resid
@word(32) type AddrLo = { UInt(32) bits; };
@word(32) type AddrHi = { UInt(32) bits; };

@registers(size = 0x100)
type QueueRegs = {
    @at(0x80) AddrLo desc_lo;
    @at(0x84) AddrHi desc_hi;
};

Int main() {
    Reg(AddrHi) hi = queue_regs_desc_hi();
    println(f"{queue_regs_size()} {hi.off} {hi.bits}");     //> 256 132 32
    return 0;
}
```

An offset is a multiple of its register's size, every register lies
inside the block, and no two overlap; a gap is an offset nothing claims.
For each register the compiler writes a handle, a `Reg(T)` typed by the
register's word (`queue_regs_desc_hi()` is a `Reg(AddrHi)`), holding its
offset and width, and `queue_regs_size()`. A malformed block is `E0298`.

### Reading and writing a block

A block that names its descriptors gets a function for each access a
register allows:

```resid
@registers(size = 0x100, device = virtio_dev, write = virtio_dev_w)
type VirtioRegs = {
    @at(0x60) IrqCause     cause;      // a @clears_on_read word
    @at(0x70) VirtioStatus status;
};

@requires(device(readonly))
Result(Bool, DeviceError) needs_reset() {
    VirtioStatus s = virtio_regs_read_status()?;
    return Ok(s.needs_reset);
}
```

| Function | For | Grant |
|---|---|---|
| `virtio_regs_read_status()` | a register with something to read | `device(readonly)` |
| `virtio_regs_write_status(v)` | a register with something the driver may write | `device` |
| `virtio_regs_take_cause()` | a `@clears_on_read` register: reading it changes the device, so there is no `read_` | `device` |

`device = d` names an `Mmio` descriptor that only loads and `write = dw`
one that writes; both come from `lib/dev/`, as every descriptor does
(`E0260`). Each function is one `device.mmio` call with its descriptor
written out, so the compiler knows which descriptor every call uses, and
a read never needs more than the read-only grant.

A device at an address known only when the program runs is declared
with `pci` and `pci_write` in place of `device` and `write`. They name
`MmioPci` descriptors, which state the vendor and device ids the block
is for, and every function takes the function's address first:

```resid
@registers(size = 0x100, pci = virtio_net, pci_write = virtio_net_w)
type VirtioRegs = { @at(0x70) VirtioStatus status; };

List(PciAddr) found = pci_find(0x1af4, 0x1041)?;      // lib/dev/pci.resid
VirtioStatus s = virtio_regs_read_status(found[0])?;
```

The device host compares the ids of the function at that address with
the descriptor's before it touches its memory, and answers `Unsupported`
when they differ, so an address chosen at run time reaches no other kind
of device.

Some devices say only at run time where in their memory a block is
(virtio lists its blocks in its PCI capabilities). Such a block is
declared with `window` and `window_write`, naming `MmioWin` descriptors,
and its functions take a `PciWindow`: the address, the resource, and the
block's base and length there.

```resid
@registers(size = 0x38, window = virtio_rng, window_write = virtio_rng_w)
type Common = { @at(0x14) Status device_status; };

PciWindow w = virtio_pci_window(addr, virtio_cfg_common())?;   // lib/dev/virtio_pci.resid
Status s = common_read_device_status(w)?;
```

The ids are checked as before. Which resource of that device is touched
is then run-time data: the provenance record names the device, not the
resource.

Each access runs in a device host of its own, like every device call:
the host maps the device's memory, installs its filter, makes the one
load or store and exits. It costs about what a device call does (2 ms),
which suits start-up and configuration, not a data path
(`PLAN-hardware-access.md` §11). Sum-typed fields are not here yet.
