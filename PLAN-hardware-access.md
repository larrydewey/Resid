# Hardware Access — Plan (revision 1)

**Status: DRAFT (2026-11-23). Nothing here is implemented.** This plan
extends device access (`PLAN-device-access.md`, spec §49) from single
descriptor calls to stateful hardware work: user-space drivers, GPU work,
and freestanding programs (firmware, a kernel). It records the decisions
of the design discussion of 2026-11-23, the measurements that tested
them, and the order of work. In-kernel Linux modules are deferred (§11).

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
| Definitions | `resid-devgen` extended (SVD, device tree, PCI capabilities, DRM and VFIO uapi) and bitfield layouts with access modes (`ro`, `wo`, `rw`, `w1c`, must-be-one) | Hand-written layouts only (drift) |
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
not a run-time abort: this is the classic driver bug, and the bitfield
`@check` machinery of the labels plan is where it is caught.

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

1. Bitfield layouts with access modes; a volatile load in the compiler
   (§9).
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

## 11. Open questions

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
