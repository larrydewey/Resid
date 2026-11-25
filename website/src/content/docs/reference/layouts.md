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

#### Sessions

A host per access costs about 2 ms. A block declared with `session` and
`session_write` (the same `MmioWin` descriptors) is read and written
through one host that stays alive, a session, and each access is then
one small message to it:

```resid
@registers(size = 0x38, session = virtio_rng, session_write = virtio_rng_w)
type Common = { @at(0x14) Status device_status; };

Result(Status, DeviceError) r = common_session(w, lambda(s) { common_read_device_status(s) })?;
```

| Generated | For | Grant |
|---|---|---|
| `CommonSession` | the type of the block's sessions | |
| `common_session(w, f)` | opens a session that loads and stores, calls `f` with it, ends it; `Ok` of what `f` gave, or why no session opened | `device` |
| `common_session_ro(w, f)` | the same, for loads only | `device(readonly)` |
| `common_read_r(s)`, `common_write_r(s, v)`, `common_take_r(s)` | the accessors, over the session | as for any block |

Only these scoped functions open a session: `device.session_open`
written by hand is `E0260`, so every session has an end. The session
ends when the scoped function returns, whatever `f` gave; a
session value kept past that names nothing, and an accessor called with
it gives `BadInput`. The host checks the device's ids once, when the
session opens, and every access against the window it mapped and
whether the session may store. A thread holds at most eight sessions,
and uses only the ones it opened.

A device with several blocks names them in a `@device` declaration, and
one host serves them all:

```resid
@registers(size = 0x38, session = device) type Common = { @at(0x14) Status device_status; };
@registers(size = 1, session = device)    type Isr = { @at(0) IsrStatus status; };

@device(session = virtio_rng, session_write = virtio_rng_w)
type Rng = { Common common; Isr isr; };

RngWindows w = RngWindows {.common = wc, .isr = wi};
Result(Status, DeviceError) r = rng_session(w, lambda(s) { common_read_device_status(s.common) })?;
```

`session = device` on a block says its sessions come from devices: it
gets its session type and accessors and no scope of its own, so one
block (virtio's common configuration) is declared once for every device
that has it. The device gets `RngWindows` (a `PciWindow` per block),
`RngSession` (a session per block), `rng_session` and `rng_session_ro`.
The windows are all of one PCI function; the host maps each resource
they name and holds every access to the one it names (`E0298` for a
member that is not a session block).

#### A device that is given memory

A device that reads and writes memory its driver gives it (a virtio
queue) is declared with `dma`, naming a `DmaDev` descriptor:

```resid
@device(dma = virtio_rng_dma)
type Rng = { Common common; Notify notify; };

@registers(size = 6, session = device)
type Avail = { @at(0) Half flags; @at(2) Half idx; @at(4) Half ring0; };

rng_session(w, lambda(s) {
    AvailSession av = avail_in(s.dma, 4096);         // a block placed in the memory
    Bool ok = avail_write_idx(av, Half {.v = 1})?;
    List(UInt(8)) bytes = dma_read(s.dma, 12288, 32)?;
    ...
})
```

The session's host reaches the function through the kernel's VFIO
driver, so the function must be bound to `vfio-pci` and behind an IOMMU
(`Unsupported` otherwise). It maps the descriptor's `dma` bytes of its
own memory for the device at the address `iova`; the IOMMU lets the
device reach those bytes and nothing else. The session record carries
that memory as `s.dma`, a `DmaRegion`: `s.dma.iova` is the address to
give the device, `dma_read` and `dma_write` move bytes, and every
`session = device` block has `t_in(s.dma, off)`, its session at that
offset, so a queue's parts are packed types like any register. The
memory is in the host, never in the program, and the host knows nothing
of queues. Such a session always writes (`device`).

`dma_wait(s.dma, timeout_ms)` sleeps until the device interrupts, at
most 60 seconds: it gives how many interrupts came since the last wait,
0 when the time passed with none. The interrupt is the device's MSI-X
vector 0, which the host turns into an event before its filter is
installed; the driver points its queues at that vector. A device
without MSI-X has none to wait for (`BadInput`), and its driver polls.

#### A driver in the host

With `driver = f`, the device's driver is a function of yours that runs
inside the session's host, after its filter. There the register
accessors are direct loads and stores of the device's mapped memory,
checked against the session's bounds, and `dma_read`, `dma_write`,
`dma_wait` and batches are made in place: all in the driver's own
process, with no message. The program holds no session, only a link to
send the driver messages on.

```resid
@device(dma = virtio_rng_dma, driver = entropy_driver)
type Rng = { Common common; Notify notify; };

// In the host: set the device up, then loop.
@requires(device)
Int entropy_driver(RngSession s) { ... return serve(s, 0); }

@requires(device)
Int serve(RngSession s, Int n) {
    return match (driver_next(60000)) {
        Ok(ev) => match (ev) {
            DrvRequest(msg) => ...,          // do it, driver_reply(bytes), serve(s, n + 1)
            DrvInterrupt(count) => ...,      // the device's interrupt
            DrvIdle => serve(s, n),          // the time passed
        },
        Err(e) => 1,
    };
}

// In the program: start the host with the driver, talk to it.
Result(List(UInt(8)), DeviceError) r = rng_driver(w, lambda(d) { driver_call(d, [32]) })?;
```

| | |
|---|---|
| `t_driver(w, g)` | generated: starts the host running the driver, calls `g` with a `DriverLink`, ends the session (`device`) |
| `driver_call(d, bytes)` | in the program: a message to the driver and its answer, 64 KiB each at most, a minute at most |
| `driver_next(timeout_ms)` | in the driver: a `DrvRequest(bytes)` from the program, `DrvInterrupt(count)` from the device, or `DrvIdle` |
| `driver_reply(bytes)` | in the driver: the answer to the request it took |

The driver is `Int f(TSession s)`: a function with its own tail loop,
whose state is what the loop carries. Messages are bytes; give them
structure with [layout types](#layout-types). A driver holds no
capability but `device`: one that asks for another is `E0219` where the
compiler writes its entry, and the host's filter allows a driver only
its device, its socket and its own memory. When the program ends the
session, `driver_next` does not return and the driver's process ends;
a driver that returns ends its host, and the program's next
`driver_call` fails. The host is a fresh start of the program's own
binary, so the driver shares no memory with the program.

#### Batches

Every access of a session is a message to its host and its answer. A
batch sends several operations in one message; the host makes them in
order and answers once, so a request to a device is a crossing or two.
Each register of a block with sessions also gets its access as an
operation:

```resid
List(DevOp) ops = [
    dma_write_op(m, at_header, header),                // bytes into the device's memory
    slot_head_store(slot, Half {.v = 0}),              // a register, or a block placed in memory
    ring_head_idx_store(avail, Half {.v = next}),
    notify_queue_store(bell, Half {.v = 0}),
    dma_wait_op(1000),                                 // sleep for the interrupt, in the host
    ring_head_idx_load(used),
    dma_read_op(m, at_data, 512)
];
List(DevOut) outs = device_batch(m.id, ops)?;
Half used = ring_head_idx_of(outs, 1)?;               // output 0 is the wait's count
```

| Generated for register `r` of block `T` | |
|---|---|
| `t_r_load(s)` | the load as a `DevOp` |
| `t_r_store(s, v)` | the store as a `DevOp` |
| `t_r_of(outs, i)` | the load's answer, output `i` of the batch, as the register's type |

`dma_read_op`, `dma_write_op` and `dma_wait_op` are the other
operations. The outputs are one for each load and wait (a number) and
each read (bytes), in the order of the operations; stores and writes
give none. `device_batch(id, ops)` needs `device`;
`device_batch_ro(id, ops)` takes a batch that neither stores nor writes
under `device(readonly)`. A batch is at most 256 operations, 64 KiB of
them and 64 KiB of answers. When the host refuses an operation, the
batch stops there and those before it were made.

Without a session, each access runs in a device host of its own, like every device call:
the host maps the device's memory, installs its filter, makes the one
load or store and exits. It costs about what a device call does (2 ms),
which suits start-up and configuration, not a data path
(`PLAN-hardware-access.md` §11). Sum-typed fields are not here yet.
