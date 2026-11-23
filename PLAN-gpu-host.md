# GPU Access through a Confined Host — Implementation Plan (revision 3)

**Status: revision 3 DRAFT (2026-11-23), for review. Nothing here is
implemented.**
- Revision 1 proposed a C host. The owner rejected it as a shortcut.
- Revision 2 made the host Resid, on a hosted target.
- Revision 3 answers an adversarial review of revision 2: 3 blockers,
  8 major findings and 5 minor ones, each mapped in §15. It also adopts
  two owner decisions: development happens **entirely in cloud
  containers**, using software Vulkan until real GPUs are arranged, and
  foreign descriptors are for the GPU host **only, ever**.

This is phase 0 of the Surreal engine (`larrydewey/surreal`, `DESIGN.md`
§3 R1, milestone M0a). It ends in a measured go/no-go (§11).

Read first: `resid_specification.txt` §16 (handles), §19 (spawn), §20-21
(capabilities, sandboxes), §38 (non-goals), §47 (native modules), §48
(secrets), §49 (device access); `PLAN-native-modules.md`;
`PLAN-device-access.md` §5; `PLAN-macos.md`; `SECURITY.md` (threat model;
the `display`, sandbox and native rows).

## Goal, and exactly what is guaranteed

A Resid program can drive a GPU through Vulkan at a cost small enough for
a 240 Hz renderer, with:

1. **No undefined behavior in the program.** No native code runs in it,
   and every byte it reads from shared memory is read with defined
   semantics, even if the host is hostile (§4).
2. **No new ambient authority.** The program reaches the GPU only
   through the `gpu` family. What that grant covers is stated in §10.
3. **No code of ours outside Resid.** The host is a Resid program.
4. **Every existing law and `SECURITY.md` row stays true**, with the
   amendments listed in §13. Each one narrows a statement; none widens
   authority.

The **host process is a trusted base**, as the kernel is, and §9 states
this honestly. Its own Resid code is free of UB by the language. Its
calls into the vendor driver must satisfy Vulkan's valid-usage rules,
and a mistake there is UB *inside the host*. That UB cannot reach the
program, because the program trusts nothing from the host (guarantee 1),
and §9 sets out how such mistakes are prevented and caught.

---

## 0. Design in one paragraph

- The vendor driver never enters the program. A separate, long-lived,
  confined **GPU host** loads it. The host is written in Resid and built
  for a new **hosted target** (§5).
- The host calls Vulkan only through **foreign descriptors** generated
  from Khronos's `vk.xml`. Each becomes a typed call stub, much as device
  access calls the kernel through descriptors generated from uapi
  headers (§6).
- The program writes a **command stream** into rings in shared memory
  that **the program creates and seals** (§7). Both sides read that
  memory only through new atomic and unordered-atomic operations (§4).
- Hosts are started by a **launcher** forked before `main` (§8). So a
  confined program never needs `exec`, and a host's lifetime does not
  depend on any thread.
- The host confines itself in two phases. Landlock is applied before the
  driver starts any thread, and seccomp is applied to every thread at
  once (`TSYNC`) (§8.2).
- GPU objects are handles. Barriers, image layouts and object lifetimes
  are tracked by a state model in the host (§9).
- Any host failure reaches the program as `Err(DeviceLost)`.

## 1. Why not the alternatives

| Alternative | Why not |
|---|---|
| `@link` the driver (§47) | Each call is a fresh process (~2 ms) with no state. |
| A trusted in-process FFI in the program | Driver bugs become UB in the program, and the driver holds the program's authority. **Rejected.** |
| Re-execute the program as the host (`hs_spawn`) | Resid binaries are `-static-pie -nostdlib`. Vendor drivers need the system C library and dynamic loader. |
| A host in C or Rust | Code of ours outside the compiler's checks. **Rejected** (revision 1). |
| A Resid userspace driver over `device` descriptors | No NVIDIA proprietary support, no macOS or Windows, years of work. Long-term idea only (§14, Q6). |

## 2. Development and test environment

All work happens in cloud containers (Ubuntu 24.04), and nothing
requires a local machine or a GPU:

- **Vulkan:** Mesa's software driver, lavapipe (`mesa-vulkan-drivers`,
  checked 2026-11-23: Mesa 25.2.8, Vulkan 1.4.318, a CPU device). It is
  the primary driver for every phase and for CI.
- **Real GPUs:** none for now. The steps that need one (the AMD and
  NVIDIA syscall census, gate G2) are **deferred, not skipped**. They are
  listed in §12 and block the final go/no-go, not the work before it.
- **Toolchain:** whatever `boot.sh` needs in the container. Network
  access the container lacks is requested through the environment's
  settings, never worked around.

## 3. Spec conformance matrix

| Spec rule | How the design meets it | Enforced by | Test |
|---|---|---|---|
| §5, §38: no exposed storage | Handles (index + generation) in the program and the host. Foreign stubs never return an address to Resid code. | runtime `gpu_tab`, `fx_tab` | `gpu_no_address_leak`, `foreign_no_address_leak`, `gpu_stale_handle_refused` |
| Memory safety against untrusted input, with no UB | Shared memory is read only through atomic loads and unordered-atomic copies (§4). The program creates and seals every mapping it uses. | lowering, runtime `shm_*` | `shm_hostile_writer`, `gpu_unsealed_fd_refused`, `gpu_truncate_refused` |
| §4, §16: only handles carry mutable state; mutable handles move | An arena moves into `submit` and comes back from `wait` (§10.1). | checker (moved handle), runtime | `gpu_inflight_write_refused`, `err_gpu_arena_used_after_move` |
| §38: structured concurrency | A `Gpu` lives in a `with` block. Leaving it waits for all submitted work and destroys the device, so no GPU work outlives its scope. | runtime `gpu_close` | `gpu_scope_joins_work` |
| §47 and the threat model (untrusted library code) | Programs never call foreign code. Descriptors exist only in `lib/host/` (E0298), and verbs only in the host's entry (E0299), both resolved against the install root. Owner decision: never widened. | checker | `err_foreign_outside_host`, `err_foreign_descriptor_outside_lib_host`, `err_foreign_lookalike_path` |
| Laws 8-10: providers and effects | `gpu.*` and `foreign.*` are effects and never reduced. | `gx_collect`, `ga_effect` | `gpu_never_folded`, `gpu_graph_effect` |
| Law 11: provenance | The host is a signed Resid binary, pinned by SHA-256 at compile time. It runs from a write-sealed memfd copy of exactly the bytes that were hashed. Driver identity (ICD, library hash, driver ID and version) is reported at run time by `g.info()`. | driver, launcher | `gpu_host_hash_mismatch`, `gpu_host_swapped_after_hash`, `gpu_in_provenance` |
| Law 12: explicit uncertainty | Every failure is a `GpuError`. A crashed, hung, misbehaving or stuck host is `DeviceLost`. | runtime, launcher | `gpu_host_killed`, `gpu_forged_completion`, `gpu_host_stuck_killed`, `gpu_in_spawn_err` |
| §20, Law 14: no ambient authority | Family `gpu` (mode `readonly`), transitive (E0219). §10 states exactly what the grant covers. | checker | `err_gpu_ungranted`, `err_gpu_readonly_write`, `gpu_sandboxed_lib_refused` |
| §21: sandboxes cannot amplify | The GPU socket and rings are **runtime-owned descriptors**. `display` and `unix` verbs refuse them, so a sandbox holding `display` but not `gpu` cannot reach the host. | runtime `fd_owner` registry | `gpu_socket_not_display`, `gpu_handle_without_grant` |
| §48: secrets | `Secret(T)` never crosses to the GPU (E0296). | checker | `err_gpu_secret` |
| Self-hosting | Static targets' IR is unchanged. The hosted target is a new target word. New builtins and checks need a reseed, as `AGENTS.md` describes. | `boot.sh` | existing fixed point |

## 4. Prerequisite: defined access to shared memory

**Finding (blocker).** Resid's raw `load`/`store` lower to plain LLVM
loads and stores, and `copy` lowers to an ordinary `memmove`
(`compiler/lower.resid`, the `load`/`store`/`copy` arms). In LLVM's
memory model, a plain load that races with a store by another process
returns `undef`, and branching on `undef` is UB. LLVM may also re-read
the source of a copy, which brings back the double fetch that copying
was meant to prevent.

**Change.** New runtime-internal operations, and a rule:

- `load_acq` and `store_rel` (acquire and release atomics, widths 8-64)
  for ring indices, futex words and completion records.
- `copy_shared` lowers to `llvm.memcpy.element.unordered.atomic` with
  element size 1, 4 or 8 (the widest the alignment allows). Every
  element is an atomic read, so a racing writer yields *some* value,
  never `undef`, and LLVM may not read the source twice.
- **Rule:** memory in a shared mapping is reached **only** through these
  operations. Shared mappings are a distinct kind in the runtime's
  mapping table (`shm_kind`). The `shm_*` verbs are the only code that
  touches them, and the plain raw operations are never used on them
  (`tests/runtime/shm_hostile_writer`: a second process scribbles on
  every byte while the reader decodes, under the assertion runtime).
- After a `copy_shared` into private memory, the copy is ordinary data,
  and decoding it is ordinary checked Resid.

**Bulk copies.** Today the only path into shared memory copies one list
element at a time (`disp_bytes_of`). Add `shm_put_bytes` and
`shm_get_bytes` between a packed `List(UInt(8))` buffer and a mapping,
using `copy_shared`, with the bounds checks written so they cannot
overflow, as `rt_disp_shm_put` does. This is required before gate B4
means anything.

## 5. The hosted target

`--target x86_64-linux-hosted` (and later `aarch64-linux-hosted`): a
dynamically linked PIE, started by the system C library, which calls
Resid's `main`. Only the GPU host may load shared objects (§6). Any other
program built for this target behaves as its static build does.

| Static target today | Hosted target |
|---|---|
| `_start` calls `resid_start` | No `_start`. The C library calls `main`, which calls `resid_start_hosted` (argv, envp, `getauxval`). |
| `self_relocate` | Skipped: the loader relocates. |
| TLS installed with `resid_raw_tp_set` | Skipped: the loader owns the thread pointer. The runtime's `thread_local(localexec)` globals live in the executable's static TLS, which is valid in a dynamically linked executable (checked by the review). |
| Threads by raw `clone(SETTLS)` (`thread_spawn`) | `pthread_create`, so every thread has the C library's per-thread state. Guard pages and stack sizes go through `pthread_attr_*`. |
| `memcpy`/`memmove`/`memset` emitted as naked assembly under the C names | Not emitted. The C library's are used. (`setjmp`/`longjmp` are already `resid_setjmp`/`resid_longjmp`.) |
| External linkage under source names | **Hidden visibility** for every symbol, plus a version script that exports only `main`, so nothing in the host interposes on a symbol the C library or the driver imports. **E0300**: a hosted build that defines a name the C library reserves (`malloc`, `free`, `memcpy`, ...), as defence in depth. |
| `SIGCHLD` default, no handlers | Same. |
| Allocator over private anonymous `mmap` | Unchanged; it coexists with the C library's `malloc`, which the driver uses. |
| `-static-pie -nostdlib` | `-pie`, linked against the system C library, with `--no-undefined`. |

The C library entry points the hosted runtime calls (`getauxval`,
`pthread_*`, `dlopen`, `dlsym`, `dlclose`, `dlerror`) are declared in
`runtime/rt/hosted.resid`, compiled only for hosted targets and only
with `--runtime-internals` (E0220).

**Gate:** the whole conformance suite passes on the hosted target, and
the static self-compile fixed point is unchanged.

## 6. Foreign descriptors (Vulkan only, host only)

**Generated.** `tools/resid-vkgen` reads `vk.xml` (pinned by version and
hash in `tools/vkgen/registry.toml`) and an input list
(`tools/vkgen/commands.toml`) of exactly the commands, structs and
extensions the host uses. It probes the pinned headers with clang on
each target for sizes, offsets and alignments, as `resid-devgen` does,
and writes `lib/host/vk_*.resid`, headed `GENERATED`. `--check` and
`--matrix` behave as they do for devgen. **A command whose shape vkgen
cannot model is refused**: it is never hand-written in.

**Typed call stubs, not a generic engine.** Vulkan needs float, 32-bit
and many-argument calls, and Resid's only indirect call is `call2`
(two `i64`s). So for each listed command the compiler emits an LLVM
function with that command's exact C signature, which calls through the
function pointer obtained from `vkGet*ProcAddr`. This needs no assembly
and no libffi, and LLVM applies the platform ABI.

**What vkgen models**, each with tests:

| `vk.xml` feature | Model |
|---|---|
| Scalars, enums, flags | Range-checked against the registry (valid enum values, valid flag bits). |
| `len` expressions | A small grammar: a parameter or member, `/`, `*`, `+`, `-`, constants, `null-terminated`. Evaluated with checked arithmetic. `altlen` is used where `vk.xml` gives one. Anything else is refused. |
| Unions (`VkClearValue`, ...) | A Resid sum type. The stub writes the selected member and zeroes the rest. |
| `void*` blobs with size or stride (push constants, query results, specialization data) | `Blob(size, stride)`, from a packed byte list, checked against size, stride and flags. |
| `VK_INCOMPLETE` two-call queries | The stub runs the count/fill loop itself (bounded) and returns the full list. |
| Dispatchable handles | Resid handles of the right type. |
| Non-dispatchable handles, which may not be unique | A handle table keyed by (type, value) with a reference count. |
| Input `pNext` chains | Only the structs the input list allows for that parent, built in order. |
| Output `pNext` chains | Built empty by the stub from an allowed list, then read back. |
| Mapped memory | A mapping handle with a size. Non-coherent memory is flushed and invalidated automatically, on `nonCoherentAtomSize` boundaries. |
| Function pointers, allocation callbacks | Never passed. Allocation callbacks are always null. Debug messages go to a log file through layer settings, with no messenger callback. |

Structs are built in a scratch region with guard pages and canaries, and
outputs are read back only within their declared capacity.

## 7. Shared memory and the rings

- **The program creates every shared mapping**: the rings and every
  arena. Each is a `memfd` sealed `F_SEAL_SHRINK | F_SEAL_GROW |
  F_SEAL_SEAL` before it is sent (`SCM_RIGHTS`). The host checks
  `F_GET_SEALS` and the `fstat` size of every descriptor it receives,
  and refuses anything else. **The program never maps a descriptor the
  host created**, so a hostile host cannot cause `SIGBUS` by truncating
  a file, or hang a load through a FUSE or userfaultfd mapping.
- **Command ring**: program to host. **Completion ring**: host to
  program. 64-bit indices that only grow. Records are length-prefixed and
  16-byte aligned.
- **Wake-ups**: futex words in the rings, using the *shared* futex
  operations (no private flag), and accessed only through `load_acq` and
  `store_rel`.

### 7.1 Neither side trusts the other

The host `copy_shared`s each command record into private memory, then
decodes the copy (§8.3). The program `copy_shared`s each completion,
then checks it: the ticket is pending, the status is known, timeline
values only grow. Any failure kills the host, and every handle of that
device becomes `DeviceLost` (one self-test mode per kind of bad
completion).

## 8. The launcher and the host

### 8.1 Starting, identity and lifetime

- **Launcher.** When a program's graph reaches `gpu.open`, the compiler
  puts `resid_gpu_launcher()` first in `main` (`gpu_hook_main`, as
  `dv_hook_main` does for device hosts). This forks a small launcher from
  the process's first thread, before `main` runs and before any
  `resid_sandbox_confine`. The launcher keeps one end of a socketpair and
  a pidfd of the program. It does nothing but start hosts on request and
  kill them when the program's pidfd reports exit. A confined program
  therefore never needs `execve`, `clone` or `memfd_create`, and the
  sandbox's syscall list stays as it is.
- **Identity is by possession.** The program and the launcher are
  connected by a socketpair made before the fork, not by pid. So
  `resid_sandbox_confine`'s fork changes nothing. The socket is a
  runtime-owned descriptor that no `display` or `unix` verb accepts
  (`fd_owner` registry, §3).
- **The host image is pinned.** At compile time the program pins the
  host's SHA-256. The launcher copies the host file into a memfd while
  hashing it, seals it against writes (`F_SEAL_WRITE`), compares the
  hash, and executes the memfd (`execveat(fd, "", AT_EMPTY_PATH)`). So
  the bytes that run are exactly the bytes that were hashed. If the
  kernel forbids executable memfds (`vm.memfd_noexec = 2`), the launcher
  fails closed with `Err(HostUnavailable)`.
- **Where the host is.** Beside the program's own executable
  (`resid-gpu-host` next to `/proc/self/exe`), else at the absolute
  install path recorded at compile time. No environment variable is read
  (§10).
- **One host per device a program opens.** The program keeps a
  per-device record (host pidfd, socket, rings), not the single
  `hs_peer` slot that device calls use, which another host call on the
  same thread could overwrite. Host start-up reuses `hs_auth`'s
  challenge, non-dumpable before anything else, tracer refusal, and Yama
  in secret mode.
- **Stuck hosts.** Every wait has a deadline. When one passes, the
  program asks the launcher to kill the host (`pidfd_send_signal`
  `SIGKILL`) and reports `DeviceLost`. Arenas imported by that host stay
  in flight until its pidfd reports exit, because only then has the
  kernel torn down its GPU context, so no GPU write can still land.

### 8.2 Two-phase confinement

**Phase A (before the driver loads, and before any driver thread exists).**
- Working directory `/`. The environment contains only a fixed list: no
  `HOME`, no `XDG_*`, and `VK_LOADER_LAYERS_DISABLE=~implicit~`. The
  loader version is checked (>= 1.3.234, which honours that variable);
  an older loader gives `Err(Unsupported)`.
- **Landlock first**, while the host is still single-threaded, so every
  driver thread inherits it. The ruleset allows reading the ICD manifest
  directories, the driver and loader libraries, and `/sys/class/drm`
  and `/sys/devices` (read-only), and opening `/dev/dri/*` (plus
  `/dev/nvidia*` on NVIDIA). No other path. Where the kernel supports
  restricting every thread, it is used as well.
- `dlopen` the loader, create the instance, select the device, create the
  device with a single universal queue, require the features in §9, and
  **create every pipeline the spike uses**, so the driver's compiler
  libraries are loaded now and not lazily later.
- Record the descriptors the driver opened.

**Phase B (before reading the first command).**
- seccomp with **`SECCOMP_FILTER_FLAG_TSYNC`**, applied to every thread
  the driver started. The kernel refuses `TSYNC` if any thread cannot
  take the filter, and then the host fails closed.
- Policy, written from the census (§12):
  - **Allowed:** what the C library and threads need (`futex`,
    `clone` with thread flags only, `rt_sigprocmask`,
    `set_robust_list`, `rseq`, `madvise`, `brk`, `mmap`/`munmap`/
    `mprotect`, `close`, `sched_yield`, `nanosleep`, `ppoll`, `exit`,
    `exit_group`); `ioctl` on any descriptor (no new files can be
    opened, so every descriptor is the driver's own or derived from it:
    syncobj, sync_file, dma-buf); and `read`/`write`/`recvmsg` on the
    socket.
  - **ENOSYS:** `clone3`, so the C library falls back to `clone`, whose
    flags seccomp can inspect.
  - **EPERM:** anything else not listed as dangerous, so a code path the
    census never saw fails as a value instead of killing a shipped game.
    That includes `mmap`/`mprotect` with `PROT_EXEC` on a hardware
    device (D3).
  - **Kill:** the dangerous set: every `open*`, `exec*`, `ptrace`,
    `process_vm_*`, `socket`, `connect`, `bind`, `kill` of other pids,
    `memfd_create`, `userfaultfd`, `bpf`, `perf_event_open`, `mount`, the
    `*xattr` calls, and `prctl` except `PR_GET_*`.
- **Software device (lavapipe):** `PROT_EXEC` is allowed, because
  lavapipe compiles shaders to CPU code. This is decided in phase A from
  the selected device's type (`VK_PHYSICAL_DEVICE_TYPE_CPU`) and reported
  in `g.info()`.

### 8.3 One schema, two generated ends

`tools/resid-gpugen` generates both ends of the wire from
`tools/gpugen/commands.toml`: the program's encoder
(`lib/gpu_wire.resid`) and the host's decoder
(`lib/host/gpu_decode.resid`), both `GENERATED`. Both work on **packed
byte cursors**, not `List(Int)`, for speed. The decoder is total and
returns `Err` on any input, never aborting. It is fuzzed in the style of
`tests/crypto`'s mutation fuzz, and a round-trip test runs in the suite.
`--check` fails on any difference. The schema also lists, for each
command, the Vulkan valid-usage IDs the host checks before replaying it
(§9).

## 9. The host's state model and GPU-side UB

The host checks valid usage itself. The validation layer only
*confirms* its checks; it never replaces them.

| Hazard | Answer |
|---|---|
| Valid usage per command | A host-side object model: which parent owns each object; memory bindings with their alignment; pools and the objects a pool reset frees implicitly (`vkResetCommandPool`, `vkResetDescriptorPool`, `vkFreeCommandBuffers` all invalidate their children's handles); device limits. Each command is checked against the VU IDs the schema lists for it. |
| Barriers and image layouts | Each command declares its reads and writes per resource and subresource. The host tracks each image subresource's layout and derives barriers and layout transitions. There is no barrier command. |
| Queues | One universal queue in this plan, so there are no queue-family ownership transfers. More queues need their own plan. |
| Use-after-free | Destruction is deferred until the timeline passes the last use. Uses are counted from submits, descriptor sets, recorded command buffers and memory bindings. |
| CPU/GPU races on arenas | Arenas move (§10.1). Imported arenas stay in flight across device loss until the host exits (§8.1). |
| Readback | A barrier to `HOST_READ`, a timeline wait, then invalidating non-coherent memory, all inside `readback`. |
| Out-of-bounds shader access | Requires `robustBufferAccess2`, `robustImageAccess2` and `nullDescriptor` (`VK_EXT_robustness2`), and `timelineSemaphore`. A device without them gives `Err(Unsupported)`. Bounds-checked shader compilation belongs to the shader plan. |
| Limits | Dispatch sizes, offsets and alignments are checked against the device's limits: at compile time when they are known (E0297), at run time otherwise. |
| Hangs | Deadlines and launcher kill (§8.1). |
| **Mistakes the model misses** | Every CI test runs with the Khronos validation layer, **synchronization validation and GPU-assisted validation** enabled. Any message fails the test. |

**Stated in `SECURITY.md`:** the host's Vulkan calls are its trusted
base. The model above and the CI validation are how that trust is
earned, and a remaining host or driver bug is contained in the host
process.

## 10. The program side

### 10.1 Surface (spike scope)

```resid
@requires(gpu)
Int main() {
    with (Gpu g = gpu.open(GpuPick.Discrete)?) {     // scope joins all work
        GpuBuf out = g.buffer(1024 * 1024, Usage.Storage)?;
        Arena a0 = g.arena(1024 * 1024)?;
        Arena a1 = a0.put(0, input_bytes)?;           // moved: a0 is gone
        Ticket t = g.submit(a1, [                     // a1 moves to the GPU
            Cmd.Upload(0, out, 0, input_bytes.count()),
            Cmd.Dispatch(Kernel.Saxpy, 1024, 1, 1, [out]),
        ])?;
        Arena a2 = g.wait(t)?;                        // the arena comes back
        List(UInt(8)) r = g.readback(out, 0, 4096)?;
    }
    return 0;
}
```

- Arenas are **moved** handles. `put` consumes one and returns the next.
  `submit` consumes the arena its commands read from, and `wait` returns
  it. Using an arena after it has moved is a compile error, the existing
  rule for moved mutable handles (§16).
- `GpuBuf` is a reference to GPU memory that the CPU never writes, so
  it may appear in several commands.
- The spike's shaders are fixed pipelines built into the host from
  SPIR-V the repository commits.

### 10.2 What the `gpu` grant covers

Stated in its `SECURITY.md` row, as `display`'s row states its
Xauthority exception:

- starting the pinned host through the launcher (no `process` or
  `filesystem` grant is needed or used);
- the driver's phase-A reads, confined by the Landlock ruleset in §8.2;
- GPU work on the devices the program opened.

`gpu(readonly)` covers `open` for enumeration, `info` and `limits`.
It still starts a host and runs phase A, and the row says so. There is
**no persistent shader cache** in this plan (no state that survives a
host). A later plan may add one, keyed per program and verified.

### 10.3 Errors and codes

- **E0295**: a `gpu` verb in `lib/dev/`, `lib/host/`, `runtime/rt/` or
  `tools/` (other than the host).
- **E0296**: a `Secret` reaching a `gpu` verb.
- **E0297**: a command known after reduction to be invalid (out of
  range, over a device's minimum guaranteed limits).
- **E0298**: a foreign descriptor outside `lib/host/`.
- **E0299**: a `foreign.*` verb outside the host's entry, or in a
  static-target build.
- **E0300**: a hosted build defining a name the C library reserves.
- E0302-E0305 are reserved for the shader plan.
- E0298 and E0299 are checked by **resolved path against the install
  root**, as E0260 is, so a user file named `tools/resid-gpu-host.resid`
  does not pass.
- `GpuError`: `Unsupported`, `HostMismatch`, `HostUnavailable`,
  `HostFailed(stage)`, `DeviceLost`, `OutOfMemory`, `InvalidHandle`,
  `OutOfRange`, `Timeout`, each with the verb's name.

## 11. Measurement and gates

`bench/gpu-host/` runs from one command. It pins the benchmark to
dedicated cores (`taskset`), records the CPU governor when it can be
read, repeats each run and reports the variance.

| Bench | Workload |
|---|---|
| B1 | Empty submit + wait, 10,000 times: round-trip and wake-up latency |
| B2 | 64 commands per frame, 2 frames in flight, a 240 Hz paced loop, 10,000 frames |
| B3 | 1,000 / 2,500 / 5,000 commands per frame: the slope per command |
| B4 | 16 MiB arena upload per frame through `shm_put_bytes` |

**Baseline:** the same work with Vulkan called in-process, as a
benchmark opponent (`bench/gpu-host/baseline/`), the way the AWFY ports
are opponents in `bench/v2`. It is never part of the product.

**Gate G1: measurable in the cloud now, on lavapipe.** CPU-side costs do
not depend on the GPU, so they are measured here:
- B2: added CPU per frame (program + host - baseline) median
  **< 100 µs**, p99 **< 250 µs**.
- B2 frame pacing: p99 deviation from the 4.17 ms period **< 0.5 ms**
  attributable to the boundary (with the baseline's jitter subtracted).
- B1: wake-up latency p99 **< 50 µs**.
- B3: slope **< 1 µs per command**.
- B4: copy throughput **>= 80%** of the baseline's copy into its own
  mapped memory.

**Gate G2: needs a real GPU (deferred, §12).** Submit-to-GPU-start
latency p99 from GPU timestamps, and B4 against device-local memory.

**Decision points.** Passing G1 is the go to build P5 onward. The final
go/no-go needs G2 **and** the presentation plan's measurement, since
presenting a frame across processes is the other cost that matters at
240 Hz.

If G1 fails, profile first: the encoder and decoder (Resid's CPU speed,
`PLAN-awfy-lead.md`), copies, or wake-ups (a short spin before the
futex). The design changes only if those cannot close the gap.

## 12. Phases

| Phase | Work | Done when | Where |
|---|---|---|---|
| **S1 Shared memory** | `load_acq`, `store_rel`, `copy_shared`, `shm_kind`, `shm_put_bytes`/`shm_get_bytes`, the `fd_owner` registry, and `display`/`unix` verbs refusing runtime-owned descriptors. | Hostile-writer and owner tests green. Static fixed point after reseed. | Cloud |
| **H1 Hosted target** | §5, including hidden visibility, the version script and E0300. | Conformance suite green on the hosted target; static fixed point unchanged. | Cloud |
| **H2 Foreign descriptors** | `resid-vkgen`, typed stubs, the models in §6, E0298, E0299. Tested against a test-only shared object, then lavapipe. | Create an instance and device on lavapipe from Resid. Fault tests refuse cleanly. | Cloud |
| **P3 Launcher and host** | §8.1, §8.2, the census on lavapipe (`tools/gpu/census/lavapipe.txt`), and phase B from it. | Host starts, initializes and locks down on lavapipe. A forbidden call in a self-test mode is refused or kills the host as specified. Stuck-host kill works. | Cloud |
| **P4 Wire** | `resid-gpugen`, the rings, sealing checks, completion validation, fuzzing, the `gpu` family, E0295, E0296. | Round-trip and fuzz green. Every forged-completion mode gives `DeviceLost`. | Cloud |
| **P5 Commands** | §9's state model and §10, E0297. | Saxpy and an offscreen triangle match the expected bytes on lavapipe, with sync and GPU-assisted validation clean. | Cloud |
| **P6 Gate G1** | §11 on lavapipe; report in `docs/`. | G1 recorded in this file's status. | Cloud |
| **P7 Real GPUs** | The census on radv and NVIDIA (`census/radv.txt`, `census/nvidia.txt`), phase-B adjustments, gate G2. | G2 recorded. | **Deferred** until real GPUs are available |

Each phase adds its `SECURITY.md` rows and tests before the next starts.
Spec §50 (GPU access) and §51 (shared memory, the hosted target and
foreign descriptors) are drafted in S1 and H1 and finished in P6.

## 13. Spec and `SECURITY.md` changes

- §20: the families `gpu` (modes: none, `readonly`) and `foreign`
  (mode-less, host only).
- §38: unchanged in meaning. The `with` scope keeps GPU work structured
  (§10.1).
- §47.4 and the `SECURITY.md` native row ("native code runs only in a
  re-executed `/proc/self/exe` with no vDSO or TSC") are amended to:
  *native code runs only in a confined host: the per-call native host
  (unchanged), or the GPU host, whose own rows state its confinement*.
- New rows: shared-memory access (§4), runtime-owned descriptors (§3),
  the launcher and host pinning (§8.1), confinement (§8.2), the `gpu`
  grant (§10.2), and the host's trusted base (§9).
- §50 and §51 as in §12.

## 14. Decisions and open questions

Decided (2026-11-23):
- **D1:** the host is Resid on the hosted target. No C or Rust of ours.
- **D2:** `SECURITY.md` states the host and driver as a contained
  trusted base, in the words of §9 and §10.2.
- **D3:** executable memory only for a software (CPU) device.
  Elsewhere it is `EPERM`.
- **D4:** one host per device a program opens, never shared.
- **D6:** development entirely in cloud containers; lavapipe until real
  GPUs are arranged (§2).
- **D7:** foreign descriptors for the GPU host only, ever. Any future
  need (audio, video decode) gets its own host and its own plan.

Open:
- **Q5, the census on real drivers.** A post-initialization need that
  cannot be confined is decided per case: move it into phase A, allow it
  narrowly, or refuse that driver version.
- **Q6, a Resid userspace driver.** Not planned.
- **Q8, the benchmark baseline.** The in-process baseline must call
  Vulkan directly, so it cannot be Resid. Is a non-Resid benchmark
  opponent acceptable, as the AWFY ports are? The alternative is to
  compare against published numbers, which is less fair.

## 15. Review of revision 2 and how revision 3 answers it

| # | Severity | Finding | Answer |
|---|---|---|---|
| 1 | Blocker | Plain loads and memmove on shared memory are UB under races and allow double fetches | §4: atomic and unordered-atomic operations only, enforced by mapping kind |
| 2 | Blocker | Landlock covers only the calling thread; seccomp lacked `TSYNC` | §8.2: Landlock before any driver thread exists; seccomp with `TSYNC`; fail closed |
| 3 | Blocker | "No UB" overclaimed for the host; descriptor checks cover little valid usage | Goal restated; §9 state model, VU IDs per command, sync and GPU-assisted validation in CI |
| 4 | Major | `display` code could drive the GPU socket | `fd_owner` registry; display and unix verbs refuse runtime-owned descriptors |
| 5 | Major | `hs_peer` TLS slot, thread-bound `PDEATHSIG`, confinement's fork | §8.1: per-device records, a pre-`main` launcher, identity by socketpair, pidfd lifetime |
| 6 | Major | Program mapped host-made memory (SIGBUS, FUSE hangs) | §7: the program creates and seals every mapping; the host checks seals and size |
| 7 | Major | Census-built seccomp would kill real hosts; `clone3`; fds created later; lazy `PROT_EXEC` | §8.2: tiered policy (allow / ENOSYS / EPERM / kill), `ioctl` on any fd, pipelines created in phase A |
| 8 | Major | Generic engine unbuildable; `len` expressions, unions, blobs, `VK_INCOMPLETE`, pools | §6: typed compiler-emitted stubs; each feature modelled, or the command refused |
| 9 | Major | Hazard table incomplete | §9: layouts, one queue, readback sequence, timeline semaphores, limits, use counting, arenas across device loss |
| 10 | Major | Gate unsound (B4 copy path, CPU time only, present excluded) | §4 bulk copy; §11 wall-clock pacing, wake-ups, B3 slope, pinned cores; final go/no-go includes present |
| 11 | Major | Symbols exported under the hosted link interpose on the C library | §5: hidden visibility, version script, E0300, the C library's mem* used |
| 12 | Minor | File can change between hash and exec; driver identity unrecorded | §8.1: hash into a write-sealed memfd and exec that; §3: driver identity reported |
| 13 | Minor | Ambient authority in `open` (`RESID_HOME`, cache, phase A) | §8.1: no environment read; §10.2: the grant's coverage stated; no persistent cache |
| 14 | Minor | Loader version; cwd and `HOME`/`XDG` | §8.2: loader >= 1.3.234 checked; cwd `/`; fixed environment |
| 15 | Minor | Spec and `SECURITY.md` gaps; example misused a moved arena | §13; §10.1 example corrected with moved arenas and a `with` scope |
| 16 | Minor | E0298/E0299 path look-alikes | §10.3: resolved against the install root, with a look-alike test |
