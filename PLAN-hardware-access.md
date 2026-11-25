# Hardware Access — Plan (revision 1)

**Status: DRAFT (2026-11-23). Nothing here is implemented.** This plan
extends device access (`PLAN-device-access.md`, spec §49) from single
descriptor calls to stateful hardware work: user-space drivers, GPU work,
and freestanding programs (firmware, a kernel). It records the decisions
of the design discussion of 2026-11-23, the measurements that tested
them, and the order of work. In-kernel Linux modules are deferred (§12).

**What "guaranteed" means here** is what it means in `SECURITY.md`: every
claim names the code that enforces it and the test that fails if it
breaks. This draft names where each will live; none exists yet.

## 0. Goal

A program can drive hardware (memory-mapped registers, DMA, interrupts, a
GPU) with no raw pointer, no `unsafe`, and no code outside Resid in the
path, and a program that does not ask for the new grants keeps every row
of `SECURITY.md` unchanged.

Not goals: calling vendor C drivers in process; a general foreign
function interface; real-time guarantees.

## 1. Decisions

| Area | Decision | Rejected, and why |
|---|---|---|
| Hardware memory | Typed linear regions: `Region(T)` over a layout type, bounds-checked, volatile access, unmapped when dropped | `unsafe` blocks (reopens what removing the `unsafe` family closed); native modules only (drivers end up in C) |
| Who makes a region | One minting layer: a driver host on Linux, a pinned platform package when freestanding | Compiler intrinsics under a capability (not portable across boards) |
| Driver code shape | A pure core, `(state, event) -> (state, operations)`, and a thin executor that applies operations to regions | Code that writes regions directly everywhere (untestable without hardware) |
| Isolation on Linux | Each driver is its own confined process holding only its device grant; applications reach it over typed channels and shared rings | A C session host sharing regions into the application (device-writable memory in the application); in-process access behind a `device(direct)` grant (no performance case left, §8) |
| Shared address space | Rejected, on Linux and on our own kernel | Language-only isolation does not stop speculative reads; one compiler bug breaks every boundary; it contradicts the reasoning of `PLAN-native-modules.md` revision 2 |
| What is split | By authority, not by vendor: validation, shader compilation and command encoding are pure and run in the caller; only submission, mapping and interrupts need the device | Whole driver behind the boundary (affordable, §8, but a larger confined program) |
| DMA | `Dma(T)` buffers are linear and pinned, their bus address an opaque `DeviceAddr`; an IOMMU domain is required, a build without one needs a recorded, named waiver | IOMMU when available (a device can write any memory); bounce buffers only (a copy per transfer) |
| Interrupts | Events as values on a channel, polled on hot paths and waited for when idle; a restricted `@isr` class only for freestanding top halves | Preemptive handlers in ordinary code (the largest addition to the type system) |
| Hardware interfaces | Behaviors with manifest-bound instances: `Platform`, `Gpu`, `Block`, `Net`, `Audio`, `Input` | One interface per vendor |
| Who may declare one | Driver packages, bound in the manifest to the devices they name (PCI ids, paths), recorded in provenance; E0260 relaxes for them only | Any code under a grant (a wide grant dependencies could ask for); standard library only (too slow to add a device) |
| Definitions | `resid-devgen` extended (SVD, device tree, PCI capabilities, DRM and VFIO uapi) and packed word types for registers (§11, proposed) | Hand-written layouts only (drift) |
| Labels | A region read is External; layout checks are the total parser | A device-scoped label; Internal after attestation (both later, on the attestation plan) |
| GPU | A `Gpu` behavior; vendor instances written in Resid; virtio-gpu first | A confined host running a vendor's C driver (kept only as a possible fallback instance) |
| Freestanding trust root | `Platform` behavior; instances: seL4, and a bare-metal platform package | A native IR shim (the most dangerous code would not be Resid) |
| More than one CPU | One state value under one lock first; a multikernel (per-CPU state, messages between cores) to scale | Shared mutable kernel state |

## 2. The model

Driver code holds three kinds of value and nothing else that reaches
hardware:

- `Region(T)`: a mapping whose contents are laid out as `T`. Field reads
  and writes are generated from the layout; a read is volatile and its
  result External; no ordinary Resid value is ever backed by a region.
- `Irq`: a source of events to wait on or poll.
- `Dma(T)`: a pinned buffer the device may read or write, with a
  `DeviceAddr` that can be stored only into a field typed for one.

All three are linear: moved, never copied, and released in an order the
compiler checks (DMA quiesced before unmap, the device reset before its
IOMMU domain goes). Only the minting layer creates them.

A value the device supplied (a ring index, a length) is External. Using
one to index a region without a check that bounds it is a compile error,
not a run-time abort: this is the classic driver bug, and the `@check`
machinery of the labels plan is where it is caught.

## 3. Drivers

A driver package declares its formats, regions and channels for the
devices its manifest names, and implements a behavior. Its logic is a
pure core that can be run and fuzzed against a device model with no
hardware; the executor that applies its operations is the only part that
touches regions.

On Linux a driver runs as its own process, started and confined as the
device host is today (seccomp by what the manifest lists, Landlock, no
other grant). The lockdown is fixed when the device is opened, so the
manifest must list every request number and mapping the driver will ever
use. An application never holds a device mapping: it sends commands and
buffers over a shared ring, and hands buffers over by ownership (after
the hand-off it cannot touch them, so nothing is copied and nothing is
read while it changes).

What this changes in `SECURITY.md` terms is stated in §7.

## 4. GPU

One `Gpu` behavior. Above it, written once: the API an engine sees, all
validation (bounds, resource lifetimes, shader interfaces), the shader
front end and a shared intermediate form. Below it, per vendor: lowering
that form to the GPU's instructions, command encoding, memory and
submission. Each instance reports its limits as a value.

- Validation is never vendor code: an instance receives validated input.
- Instances, in order: software (the rasterizer of `resid-gui`, also the
  oracle every other instance is tested against); virtio-gpu (one driver
  for every host GPU in a VM, and it runs in CI); one native family
  (Intel or AMD, through the kernel's DRM interface).
- Which instance runs is chosen by a probed device id, which is External:
  it may only select among instances that are each sound, as a driver
  version selects among formats today (device access R2.6).

Most of a native instance is its shader compiler. That is the cost of
this choice, and it is per GPU family.

## 5. Freestanding

A kernel is a pure loop, `state = handle(state, trap)`, with
`resume(context)` returning the next trap as a value. The compiler
already updates a uniquely owned value in place when it is threaded
through a tail call, so this needs no mutable state in the language.

What hardware does force:

- **Placement.** Page tables, interrupt tables and device rings are read
  by hardware at physical addresses: a value with a fixed address and
  layout, or a region over RAM.
- **A stub.** Trap entry and exit and privileged register access, a few
  hundred instructions, in the platform package.
- **Bounded steps.** With no preemption, interrupt latency is the longest
  `handle` step, so steps need a compiler-checked bound.
- **Bounded memory.** No host gives a 1 GiB stack or pages on demand:
  the stack and the allocator behind inferred reclamation need static
  limits and a boot-time page source (§9).

Address spaces stay separate on our own kernel; crossings are made cheap
by a short synchronous message path and tagged address-space ids, and
kept rare by the authority split of §1.

## 6. Order of work

1. A volatile load in the compiler (done, §9); how a register's bits
   are declared (proposed, §11).
2. `Region(T)` and the driver process, VFIO BAR mapping only.
3. `Irq` over eventfd (MSI-X).
4. `Dma(T)` with an IOMMU domain.
5. virtio-blk as the first driver package, then virtio-net; both under
   QEMU with an IOMMU in CI.
6. The `Gpu` behavior with the software instance; `resid-gui` moved onto
   it.
7. virtio-gpu instance.
8. Freestanding profile: `Platform`, bounded memory, the state-loop
   kernel on QEMU `virt` (UART, timer), then the virtio drivers of step 5
   unchanged.
9. A native GPU family.

Steps 1 to 5 and steps 6 to 7 are independent of each other.

## 7. What changes for security

| | Today | With this plan |
|---|---|---|
| A program without the new grants | every row of `SECURITY.md` | unchanged; a test must show the new features unreachable without the grant |
| Kernel writing into program memory | never (guard pages, a helper per call) | never into an application; into a driver process, only inside its regions |
| Lockdown granularity | per call | per driver session, fixed at open |
| Freestanding | not applicable | the language's laws hold given the platform instance is correct: it is a small, pinned trusted base, `unsafe` relocated, not removed |
| GPU | no GPU | no vendor C in the path; a driver holds only its device |

## 8. Measurements

`bench/crossing/` in this repository (a ring between two processes, in
Resid and C) and in `resid-gui` (the 1080p benchmark view's display list,
871 draw ops, 39 KiB as GPU-style commands, handed to a fake driver
process; the heavy frame is that list twenty times, 791 KiB). Prototypes
over the runtime's raw primitives, not language features. The gate was
1% of a 144 Hz frame, 69 µs.

| | Laptop (Ryzen AI 7 PRO 350, Linux 7.2) | Cloud container (4 vCPU) |
|---|---|---|
| Polling round trip | 52-88 ns | 300-500 ns |
| Sleeping round trip (eventfd) | 2.4-2.7 µs | 25-30 µs |
| UI frame: encode only / handed on / driver reads all | 5.0 / 5.0-5.1 / 6.3-6.4 µs | 9-12 / 10 / 27-32 µs |
| Heavy frame: encode only / handed on / driver reads all | 101-102 / 102-103 / 124-127 µs | 188-211 / 191-222 / 300-338 µs |
| Heavy frame, read in the same process | 122-124 µs | 228-276 µs |

On real hardware the boundary costs about 1 µs a frame handed on, and
about 3 µs over reading the same frame in process; every case passes the
gate, a driver that reads every command included, and a sleeping driver
adds about 2.5 µs a wake-up, so no core need spin. The container's
numbers, on which an earlier conclusion rested (that the authority split
was needed for speed), were several times worse and misleading.

Not measured: submission to a real GPU; any machine but this one.
Resid's direct encoding ran at about half C's speed on the laptop
(15-17 µs against 8.6 µs for 10,000 commands); that is a code generation
question apart from the boundary.

## 9. What the compiler and runtime need first

- **A volatile load.** A plain raw load in a polling loop is hoisted out
  of it; the benchmark hung until it read with an atomic add of zero.
  Done as compiler-only primitives, `resid_raw_loadvN` and
  `resid_raw_storevN` (PROGRESS 0zzb); a region read and write will
  lower to them. An atomic load is not needed yet.
- **Region writes as direct stores.** Building a record per command and
  then writing it doubled the encoding time.
- **Bounded memory.** Loops that kept every step's garbage are the first
  part: lists of sums, of 64-bit integers and of lists, and loops that
  return a sum, now have regions, and `--loop-report` names each loop
  that still has none and why (PROGRESS 0zzb). Still to do: moves for
  maps with record values and for `StrBuf`; the report as an error once
  it names only real leaks; a memory budget that is part of the program
  (per `spawn` region, an `Err` and not an abort); capacities in types
  for long-lived state.

## 10. Holes considered

| Attack or failure | Closed by | Residual risk |
|---|---|---|
| Device changes a value between two reads of it | every region read is a fresh External value; no Resid value is backed by a region | a driver that reads twice and assumes equality (a lint) |
| Device-supplied index or length used unchecked | compile error on an External index into a region without a bounding check | the check being wrong for the device's protocol |
| Device writes outside its buffers | IOMMU domain per driver; DMA only through `Dma(T)` | boards without an IOMMU, under a recorded waiver |
| A region or buffer used after its session ended | linearity; compiler-checked release order | none intended |
| Application corrupts a buffer the driver is reading | ownership hand-off: the sender cannot touch it after | none intended |
| A dependency asks for hardware it should not have | manifest bound to named devices, as E0261 | a manifest written too widely |
| Probed device id selects a weaker instance | selection only among sound instances | availability |
| Session lockdown too wide | the manifest lists every request and mapping; fixed at open | coarser than per call |
| Compiler bug in region code | a driver is a separate process holding one device | that device |
| Platform instance wrong (freestanding) | small, pinned, reviewed; seL4 as an instance replaces our stub with a verified kernel | the trusted base |
| Speculative reads across a boundary | separate address spaces everywhere | what hardware leaves |

## 11. Step 1 proposal: packed word types

**Accepted 2026-11-23 as a design. Stages A to D are built**
(`compiler/word.resid`: `Bool` and `UInt(K)` fields, `@reserved`,
`DeviceOwned`, `DriverOwned`, `DeviceLatch`, `@clears_on_read`, the two
generated functions, `@registers` blocks with their `Reg(T)` handles and
their read, write and take functions; `device.mmio` in the device host).
Sum-typed fields, a PCI address as run-time data and the driver process
are not. How a register's
bits are declared. Three earlier forms (bit positions with access keywords in a
new layout kind; whole words with masks; generated accessors) were put
aside as unintuitive. This one uses what the language has: a register is
a record that fits in one word.

```resid
@word(32)
type VirtioStatus = {
    Bool acknowledge;
    Bool driver;
    Bool driver_ok;
    Bool features_ok;
    @reserved(2);
    DeviceOwned(Bool) needs_reset;
    Bool failed;
    @reserved(24);
};

@word(32)
type IrqStatus = {
    DeviceLatch(Bool) queue;       // set by the device, cleared by writing 1
    DeviceLatch(Bool) config;
    @reserved(30);
};

VirtioStatus s = virtio_regs_read_status()?;                  // one volatile read
Bool a = virtio_regs_write_status(
    VirtioStatus { .acknowledge = true, .driver = true, .driver_ok = true,
                   .features_ok = true, .failed = false })?;   // one volatile write
Bool b = virtio_regs_write_irq(IrqStatus { .clear_queue = true })?;   // config kept
```

- **Fields in order, low bit first; widths from their types**: `Bool`
  one bit, `UInt(N)` N bits, a sum type without payloads the bits its
  variants need. `@reserved(n)` is n bits here (bytes in a wire format).
  The widths must add up to the word: a compile error otherwise, and a
  value read that names no variant of a sum is an error value, as a bad
  reply is.
- **`DeviceOwned(T)`**: the device owns the field. A read gives a `T`; a
  record literal that is written may not name it (as a literal never
  names a `Challenge(N)` field, labels §6.2), and it is written as zero.
- **`DeviceLatch(Bool) queue`**: set by the device and cleared by
  writing one. It gives the record two fields: `queue`, which the device
  owns (read it), and `clear_queue`, which the driver owns (a written
  literal sets it to clear the bit, or leaves it out to keep it).
  Writing back a value that was read therefore never clears a pending
  event, the usual mistake with these registers. First accepted as one
  field read as a `Bool` and written as `Clear`; changed on 2026-11-23
  because that gives one field two types, a rule nothing else in the
  language has, where two names need only the two rules above.
- **A read and a write are whole values.** Each is one hardware access
  and visible in the source; nothing reads, modifies and writes behind
  the program. A written literal names every field it may name.
- **Labels**: a value read is External (§2); its fields are well-typed
  External values.
- **Lowering**: one `resid_raw_loadvN` or `resid_raw_storevN` (§9) and
  shifts and masks the compiler writes.

How this meets labels §7: that plan allows no bit fields in a layout type
because a C bit field's layout is the implementation's, and a wire format
must match C. A packed word has one layout, which Resid defines, and it
is a new kind of type, not a change to `c_abi`, `le` or `be`. Using one
as a field of a wire format (SNP's `KEY_SEL` as a named field, where
device access R2.2a writes `(root_key_select >> 1) & 3`) would be a later
step, since it changes parsers that are tested.

`DeviceOwned` was chosen over `DeviceSet` (which reads as a `Set` of
devices) and `ReadOnly` (which says what the program may not do, not
whose the field is, and suggests a value that does not change).

Three further rules, decided the same day:

- **A register that changes when it is read** is marked
  `@clears_on_read`. It has no `read_` function, only `take_`, which
  reads it once, gives the value and needs the full grant, so a second read, or one added for
  a log line, does not compile.

  ```resid
  @word(32) @clears_on_read
  type IrqCause = { DeviceOwned(Bool) rx; DeviceOwned(Bool) tx; @reserved(30); };

  IrqCause c = nic_regs_take_cause()?;
  ```

  Rejected: no marking (a stray read is a silent bug); a linear value
  (it brings linearity into ordinary driver code and does not stop a
  second read).
- **A word is 8, 16, 32 or 64 bits**, what one hardware access carries.
  A wider value is a record of words in the region's layout, and the
  driver reads or writes each word itself, so each access and their
  order are in the source (a 64-bit queue address on 32-bit registers is
  `desc_lo` then `desc_hi`). Rejected: wider words with a declared
  access order (one assignment would be several accesses).
- **`DriverOwned(T)`**: a field the driver writes and cannot read back
  (a command, a key slot), the mirror of `DeviceOwned`. A written
  literal names it; reading it from any value is a compile error, so no
  code depends on what the hardware returns there. Rejected: separate
  read and write types for a register (two declarations to keep in
  step); reading it as an `Option`.

  ```resid
  @word(32)
  type Command = {
      DriverOwned(UInt(8)) opcode;
      Bool busy_irq;
      DeviceOwned(Bool) busy;
      @reserved(22);
  };
  ```

**Register blocks and access** (decided 2026-11-23). Resid has no
assignment, so the first examples here, written `dev.status = ...`,
could not exist; they are corrected above.

- A register block is a record of word types, each at a stated offset,
  as a datasheet gives them. The compiler checks that none overlap and
  that all lie inside the block; a gap is an offset nothing claims.

  ```resid
  @registers(size = 0x100)
  type VirtioRegs = {
      @at(0x00) DeviceMagic    magic;
      @at(0x10) DeviceFeatures features;
      @at(0x70) VirtioStatus   status;
      @at(0x80) AddrLo         desc_lo;
      @at(0x84) AddrHi         desc_hi;
  };
  ```

  Rejected: registers in order with `@reserved(n)` gaps (one wrong count
  moves every register after it); generated blocks only (no driver
  until the generator exists).
- For each register the compiler writes a typed handle
  (`virtio_regs_status()`, a `Reg(VirtioStatus)`), and access is a
  provider call under the `device` capability, as a filesystem call is.
  A start-up handshake, where each read decides the next write, is a
  sequence of these.
- **The calls are functions the compiler writes for the block**
  (decided 2026-11-24): `virtio_regs_read_status()`,
  `virtio_regs_write_status(v)`, `virtio_regs_take_cause()`, for a block
  that names its descriptors, `@registers(size = N, device = d, write =
  dw)`. First written `device.read(region, reg)`; that passes a
  descriptor as a parameter, which the compiler counts as a possible
  write (device access: a read-only grant covers only a descriptor
  whose `write = false` is written down), so a read would need the full
  grant. A generated function has its descriptor written out, and the
  rule stands as it is. Rejected: following descriptors through
  parameters (new analysis inside the rule that keeps a read-only grant
  honest).
- The pure core of §1 (`(state, event) -> (state, operations)`) is a
  library over these calls, for the steady state, where running a driver
  against a device model with no hardware matters most. Rejected:
  operations as values only (a handshake becomes a state machine with a
  state for each step); calls only (nothing testable without a fake
  device).

**How the first version reaches hardware** (decided 2026-11-24).

- One confined helper per access, as every device call works today
  (device access R2.1): the helper opens and maps the device memory
  before its lockdown is installed, does the one read or write, and
  exits. The seccomp filter does not change (it allows mapping of
  anonymous memory only, and still does once it is in place), and the
  kernel still never writes into the program's memory. An access costs
  about what a device call does, 2 ms: enough for start-up and
  configuration, not for a data path. The driver process of §3 serves
  the same calls later, for speed. Rejected: the driver process first
  (a large piece before one register can be read); mapping in the
  program (the model §1 rejects).
- A mappable device is declared in `lib/dev/` only, as every descriptor
  is (E0260). Driver packages bound by manifest (§1) are a step of
  their own, with their own review, once this is proven. Rejected for
  now: driver packages in the same step (the trust rule and the
  mechanism would change at once); a development flag.
- Tested first against a fixture, a file the test prepares, as the
  `fx_` descriptors test the other verbs against `/dev/zero` and the
  like; a virtio device under QEMU after.

**A PCI device, by its address** (decided 2026-11-25). A descriptor
with a fixed path serves a fixture; a real device is at an address
known only when the program runs.

- **The descriptor names what it is for**: the vendor and device ids,
  which resource, its size. The address is run-time data (a `PciAddr`,
  as for a PCI attribute). The device host opens the function's
  directory once and, from that one directory, reads its ids and maps
  the resource, so the device cannot change between the check and the
  mapping; ids that are not the descriptor's are refused before the
  mapping is touched. The provenance record then says which kinds of
  device a program can map. Rejected: an address alone (a wrong one
  maps another device's memory); a check by the library (two more
  hosts an access, and a gap between check and mapping).
- **Finding it**: one read-only call lists the PCI functions present,
  in a device host like every other call, and a library function keeps
  those whose ids match. It tells a program which devices exist, which
  the attribute calls already do one address at a time. Rejected: an
  address from configuration only (every driver needs setting up by
  hand); trying every address (tens of thousands of hosts).
- A block over such a descriptor, `@registers(size = N, pci = d,
  pci_write = dw)`, gets the same functions with the address first:
  `t_read_r(addr)`, `t_write_r(addr, v)`, `t_take_r(addr)`.

**A block the device places** (decided 2026-11-25). Virtio says in its
capability list which resource and offset each block is at. Chosen: a
run-time window (address, resource, base, length) from a library
function that reads the list; the descriptor names the ids and a
maximum size; the host checks ids and bounds as before. Which resource
of the named device is touched is no longer known at compile time.
Rejected: one fixed layout per hypervisor (breaks on the next one); the
host parsing capabilities (device-family logic in the most trusted
code). Built as stage F and run against a virtio entropy device in a
virtual machine.

Built (PROGRESS.md, stage E): `device.mmio_pci`, `device.pci_list`,
`lib/dev/pci.resid`. What the check does and does not give: the ids
are read after the host's filter is in and the resource is mapped but
untouched, all through one directory handle, so the function checked is
the function mapped. It says which model of device is there, not that
the device is honest; binding a driver to a device that proves its
identity is the TSM work (`lib/dev/pci_tsm.resid`). The kernel's own
rule still applies first: mapping a resource needs the privilege the
kernel asks for and a function no kernel driver holds exclusively.

First slice to build, before `Region(T)` exists: `@word(N)` types alone,
with the packing the compiler generates exposed as two functions (a
record to its word, a word to a record or an error value), the way a
layout type gets its parser and serializer (`compiler/layout.resid`),
and the three wrappers' rules as compile errors. Region reads, writes
and `take()` then call those.

## 12. Open questions

1. Does virtio-gpu let a driver process pass a command buffer on unread,
   or must something on our side validate it? (No longer a speed
   question, §8; still a question of how small the confined part is.)
2. The `@isr` class: its restrictions, and how a top half shares with
   the state loop. Designed with the freestanding profile, not before.
3. How a step's bound is stated and checked.
4. The form of the no-IOMMU waiver and who may accept it.
5. In-kernel Linux modules: deferred. The Resid code would share an
   address space with the kernel's C, which is the model §1 rejects;
   revisit after the freestanding profile, as a `Platform` instance over
   a small generated shim.
6. A second and third machine for §8.
