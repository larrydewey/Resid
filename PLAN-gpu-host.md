# GPU Access through a Confined Host — Implementation Plan (revision 1)

**Status: DRAFT (2026-11-23), for review. Nothing here is implemented.**
This is phase 0 of the Surreal engine (`larrydewey/surreal`, `DESIGN.md`
§3 R1 and milestone M0a). It ends in a **measured go/no-go**: if the
process boundary costs more than the gate in §9, the design is revised
before anything is built on it.

Read first: `resid_specification.txt` §16 (handles), §19 (spawn), §20-21
(capabilities, sandboxes), §47 (native modules), §48 (secrets), §49
(device access); `PLAN-native-modules.md`; `PLAN-device-access.md` §5
(isolation); `SECURITY.md` (threat model, the `display` rows).

**Goal.** A Resid program can drive a GPU through Vulkan with **no
undefined behavior in the program, no native code in the program, and no
new ambient authority**, at a cost small enough for a 240 Hz renderer.
Every existing law of the specification and row of `SECURITY.md` stays
true.

---

## 0. Design in one paragraph

The vendor driver never enters the program. A **GPU host**, a separate,
long-lived, confined process, loads the system's Vulkan loader and
driver, and replays a **command stream** the program writes into a
shared-memory ring. The host treats every byte from the program as
untrusted input; the program treats every byte from the host as
untrusted input. GPU objects reach the program as **handles** (§16): an
index and a generation, never an address. Bulk data lives in shared
**arenas** whose ownership moves to the GPU on submit and back when the
GPU signals completion, so the CPU cannot write memory the GPU is
reading. The program reaches the host only through a new capability
family, `gpu`. A driver crash, a GPU hang or a host that misbehaves in
any way reaches the program as `Err(DeviceLost)`, never as corruption.
This is the shape of a web browser's GPU process, which has shipped
untrusted rendering at 60+ fps for a decade.

## 1. Why not the alternatives

| Alternative | Why not |
|---|---|
| `@link` the Vulkan driver (§47) | Each call is a fresh process (~2 ms) with no state. A frame needs a live device and many calls. |
| A trusted in-process FFI (`@link(trusted)`) | The driver is C in the program's address space: any driver bug is UB in the program, and the driver holds the program's authority. Breaks §5, §38 and the threat model. **Rejected.** |
| A `device` descriptor per DRM ioctl (§49), driver written in Resid | Possible for amdgpu in principle (radv is open), impossible for NVIDIA's proprietary userspace. A full userspace driver per vendor is years of work. Kept as a long-term idea (§12, Q6). |
| Re-execute the program as the host (`hs_spawn`, as device and native hosts do) | Resid binaries are `-static-pie -nostdlib`. Vendor drivers are shared objects linked against the system C library and its dynamic loader; they cannot load into a Resid process. The host must be a separate executable (§3). |

## 2. Spec conformance matrix

| Spec rule | How the design meets it | Enforced by | Test |
|---|---|---|---|
| §5, §38: no exposed storage, no programmer-controlled allocation | GPU objects and arenas are handles (index + generation). No pointer, fd or device address reaches the program. GPU memory is placed by the host. | runtime `gpu_tab` | `gpu_no_address_leak`, `gpu_stale_handle_refused` |
| §4: values immutable; §16: only handles carry mutable state | Device, buffers, arenas, pipelines are handles. Writing an arena is a handle verb, like `resid_disp_shm_put`. | checker, runtime | `gpu_arena_put_bounds` |
| §16: mutable handles move, immutable views are shared | An arena submitted to the GPU is **in flight**: writes are refused until its ticket completes. (A compile-time version waits for `Buf`, Surreal R2.) | runtime `arena_state` | `gpu_inflight_write_refused` |
| Law 8, 9, 10: external knowledge through providers; acquisition is an effect | `gpu.*` verbs are a provider. They are effects and never reduced. | `gx_collect`, `ga_effect` | `gpu_never_folded`, `gpu_graph_effect` |
| Law 11: provenance | The host executable's SHA-256 is fixed at compile time, checked before exec, and written to the provenance record (`gpu_host`). | driver, runtime | `gpu_in_provenance`, `gpu_host_hash_mismatch` |
| Law 12: runtime uncertainty is explicit | Every failure is a `GpuError` value. A crashed, hung or misbehaving host is `DeviceLost`, inside or outside `spawn`. | runtime | `gpu_host_killed`, `gpu_forged_completion`, `gpu_in_spawn_err` |
| §20, Law 14: no ambient authority | New family `gpu`, with mode `readonly` for queries. Transitive like every family (E0219). | `gk_builtin_family`, `gk_unknown_family` | `err_gpu_ungranted`, `err_gpu_readonly_write`, `gpu_sandboxed_lib_refused` |
| §21: sandboxes cannot amplify | A sandbox that drops `gpu` makes every `gpu.*` call inside it refused; a handle passed in does not carry the grant. | `resid_cap_check` | `gpu_handle_without_grant` |
| §48: secrets | `Secret(T)` never crosses to the GPU (E0296). GPU memory and the host are not constant-time and are less trusted than the program. | checker | `err_gpu_secret` |
| Threat model: untrusted input never causes out-of-bounds access | The program validates every completion; the host copies then validates every command (§5.1). The host's decoder is generated and fuzzed. | runtime, generated decoder | `gpu_forged_completion`, `tests/gpu/fuzz` |

## 3. The host executable

**What it is.** `resid-gpu-host`, a small C program (target: under 3,000
lines plus generated code), linked against the system C library and
dynamically loading `libvulkan.so.1`. It is the one part of the GPU path
that is not Resid, and it shares a trust domain with the vendor driver it
loads. Its job is only: decode, validate, replay, report.

**Why C** (decision D1, §12): the driver it loads is C, Vulkan's
interface is C, and the host's own logic is small. Most of it is
generated (§6) and fuzzed under ASan and UBSan in CI. Alternatives in
§12.

**Where it comes from.** Built by `install.sh` with the system `cc`
against the system Vulkan headers, installed as
`$RESID_HOME/libexec/resid-gpu-host`. A shipped game carries it beside
its binary.

**Integrity.** The program's compile pins the host's SHA-256 (from the
install, recorded in provenance as `gpu_host`). At start the runtime
opens the host file, hashes the open descriptor, compares, and executes
**that descriptor** (`execveat(fd, "", AT_EMPTY_PATH)`), so the file
cannot be swapped between the check and the exec. A mismatch is
`Err(HostMismatch)`.

**Lifecycle.** Started lazily by the first `gpu.open()`, one per device.
It runs with `PR_SET_PDEATHSIG`, so it dies with the program. Start-up
reuses the device host's checks: the host goes non-dumpable first,
refuses a tracer, proves to the program that it is this exact child
(`hs_auth`'s challenge), and the program accepts bytes only from that
child's socket (`SO_PEERCRED` pid). In secret mode no host starts
without Yama `ptrace_scope` >= 1 (`hs_yama_ok`).

### 3.1 Two-phase confinement

A driver cannot be loaded under a tight filter: it reads ICD manifests,
probes `/sys` and `/proc`, opens device nodes, maps device memory and
starts threads. So the host confines itself in two steps, as browser GPU
processes do.

**Phase A, initialize (untrusted input not yet read).**
- Environment: empty except a fixed list the runtime sets. Implicit
  Vulkan layers are disabled (`VK_LOADER_LAYERS_DISABLE=~implicit~`), so
  overlays and capture tools cannot inject code. In the `debug` profile,
  `VK_LAYER_KHRONOS_validation` is enabled explicitly, as an extra check.
- Load the loader, create the instance, pick the device the program
  asked for, create the logical device and queues, and require the
  robustness features (§7). A device without them is
  `Err(Unsupported)`.
- Create the shared rings and the futex words (§5).

**Phase B, lockdown (before reading the first command).**
- Close every descriptor but the socket, the rings, and the descriptors
  the driver opened (recorded by diffing `/proc/self/fd` around phase A).
- Landlock: no filesystem access, except an optional per-program shader
  cache directory the runtime creates. No cache means the driver's
  cache is turned off.
- seccomp: an allowlist built from a measured **syscall census** (P1)
  of the driver after initialization: `ioctl` on the recorded device
  descriptors only, `mmap`/`munmap`/`mprotect` (no `PROT_EXEC`, except
  in the software-driver test mode, D3), `futex`, `read`/`write`/`recvmsg`
  on the socket, `clone` with thread flags only (drivers start worker
  threads; no new processes), `exit`/`exit_group`, and a short list of
  harmless probes answered with `EPERM`. Anything else kills the host,
  which the program sees as `DeviceLost`. That fails closed.

The host never receives a path, an fd it did not create, or an
environment variable from the program.

## 4. The program side

### 4.1 Surface (spike scope)

`lib/gpu.resid`, every verb an effect needing `gpu` (queries need only
`gpu(readonly)`):

```resid
@requires(gpu)
Int main() {
    Gpu g = gpu.open(GpuPick.Discrete)?;          // starts the host
    GpuBuf out = g.buffer(1024 * 1024, Usage.Storage)?;
    Arena a = g.arena(1024 * 1024)?;
    Arena a1 = a.put(0, input_bytes)?;            // writes into shared memory
    Ticket t = g.submit([
        Cmd.Upload(a1, 0, out, 0, input_bytes.count()),
        Cmd.Dispatch(Kernel.Saxpy, 1024, 1, 1, [out]),
    ])?;
    g.wait(t)?;                                   // arena a1 writable again
    List(UInt(8)) r = g.readback(out, 0, 4096)?;
    return 0;
}
```

- `Gpu`, `GpuBuf`, `Arena`, `Ticket` are handles: an index into a
  runtime table plus a generation, as display shared mappings are.
- `Cmd` is a sum type. The encoder (§6) writes it into the ring.
  Commands that are invalid by construction (a size past a buffer, a
  dispatch over zero groups, an arena still in flight) are refused when
  encoded, before anything reaches the host.
- **The spike's shaders are fixed.** `Kernel` names compute and graphics
  pipelines compiled into the host from SPIR-V the repository commits.
  Shaders supplied by the program are a separate plan (§11), because
  that is where GPU-side UB is decided.
- Barriers do not exist in the surface. The host derives them from each
  command's declared reads and writes, in submit order (§7).

### 4.2 Runtime builtins

`runtime/rt/gpu.resid`, following the display builtins'
pattern (`resid_disp_shm_*`): `resid_gpu_open`, `_close`, `_arena_new`,
`_arena_put` (packed bytes, bounds checks written so they cannot
overflow), `_submit`, `_poll`, `_wait`, `_readback`. Each new builtin
needs the four places listed in `AGENTS.md` (the `@export`, both type
tables, `hdr_core`) and `ls_builtins`, then a reseed.

## 5. Shared memory and the rings

- **Arenas** are `memfd`s, sealed against shrinking (`F_SEAL_SHRINK`),
  mapped in both processes, and sent to the host over the socket
  (`SCM_RIGHTS`, as `resid_disp_send` does).
- **Command ring**: single producer (program), single consumer (host).
  Head and tail are 64-bit counters that only grow, so there is no
  wrap-around ambiguity. Records are length-prefixed and 16-byte
  aligned.
- **Completion ring**: the reverse direction. Each record is
  `{ticket, status, timeline_value}`.
- **Wake-ups**: futex words in the shared mapping. These must be the
  *shared* futex operations (no `FUTEX_PRIVATE_FLAG`), unlike the ones in
  `runtime/rt/ctl.resid`. A submit costs one wake only when the host is
  asleep.

### 5.1 Neither side trusts the other

**Host reading commands.** The program could change ring bytes after the
host looked at them (in principle; it has no reason to). So the host
**copies each record out of shared memory, then validates the copy**,
and never reads the shared bytes twice. Validation is the generated
decoder (§6), then semantic checks: handles live and owned by this
program, ranges inside buffers, pipelines known, every offset
computation overflow-checked.

**Program reading completions.** The runtime checks each completion:
the ticket was issued and is pending, the status code is known,
timeline values only grow. Any failure means the host is broken or
compromised: the runtime kills it, and every handle of that device
becomes `DeviceLost`. Tested by a self-test mode that forges each kind
of bad completion (`gpu_forged_completion`).

## 6. One schema, two generated ends

As `tools/resid-devgen` generates the device descriptors, a new
`tools/resid-gpugen` generates both ends of the wire from one checked-in
schema, `tools/gpugen/commands.toml`:

- `lib/gpu_wire.resid`: the encoder, `GENERATED`, with doc comments.
- `host/gpu/wire.h` / `wire.c`: the decoder, `GENERATED`. It is total by
  construction: fixed-size fields read from a bounds-checked cursor, no
  recursion, every enum checked against its range.
- `resid-gpugen --check` fails on any difference (`tests/gpu/run.sh`).

The decoder is fuzzed with libFuzzer under ASan and UBSan in CI
(`tests/gpu/fuzz/`), seeded with the encoder's output for every
command. A round-trip property test (encode in Resid, decode in C,
compare) runs in the suite.

## 7. Removing GPU-side UB (spike scope)

| Hazard | Spike's answer |
|---|---|
| Invalid API usage | Commands are typed and validated twice (encoder, host). The fixed pipelines are validated once, when the host is built. In debug runs the Khronos validation layer is on, and the suite fails on any message from it. |
| Missing barriers | The host derives barriers from declared reads and writes, in order. There is no barrier command to get wrong. |
| Use-after-free | Destroying a handle queues the object. The host frees it when the timeline passes the last submit that used it. |
| CPU/GPU race on an arena | An arena is in flight from submit until its ticket completes. `put` on it is refused (runtime check now, a compile-time linear type with Surreal's `Buf` later). |
| Out-of-bounds shader access | The host requires `robustBufferAccess2` and `robustImageAccess2` (`VK_EXT_robustness2`); without them, `Err(Unsupported)`. Bounds-checked shader compilation belongs to the shader plan (§11). |
| Hang | A per-submit timeout. Device loss is `DeviceLost` and is recoverable: open a new `Gpu`. |

## 8. Capability, checks and errors

- Family `gpu`; `gpu(readonly)` covers `open` (enumerate only),
  `info` and `limits`. Every other verb is a write.
- **E0295**: a `gpu` verb in `lib/dev/`, `runtime/rt/` or `tools/`
  (the standard library's own GPU surface is `lib/gpu*.resid` only).
- **E0296**: a `Secret` type in a `gpu` verb's argument, or inside a
  value reaching one.
- **E0297**: a `Cmd` whose fields are known after reduction and are
  invalid (a statically out-of-range copy, a zero-group dispatch). The
  runtime checks remain for values not known at compile time.
- E0298 and E0299 are reserved for the shader plan.
- `GpuError`: `Unsupported`, `HostMismatch`, `HostFailed(stage)`,
  `DeviceLost`, `OutOfMemory`, `InvalidHandle`, `InFlight`,
  `OutOfRange`, `Timeout`. Each carries the verb's name.

## 9. The measurement and the gate

`bench/gpu-host/`, run by one command, reporting CPU time on the
program's thread, CPU time in the host, and wall time:

| Bench | Workload | Why |
|---|---|---|
| B1 | Empty submit + wait, 10,000 times | Bare round-trip latency |
| B2 | **64 commands per frame**, 2 frames in flight, 10,000 frames | Shape of a GPU-driven frame (Surreal's renderer) |
| B3 | 5,000 commands per frame | Shape of a CPU-driven frame, to see the slope |
| B4 | 16 MiB arena upload per frame | Bulk bandwidth |

**Baseline**: `bench/gpu-host/baseline.c` does the same work with
Vulkan called in-process from C. **Overhead** = (program + host CPU per
frame) - (baseline CPU per frame).

**Gate (go/no-go), on the reference machine with a real GPU:**
- B2 overhead median **< 100 µs/frame**, p99 **< 250 µs**.
- B4 bandwidth **>= 80%** of the baseline.
- B1 is reported, not gated.

On lavapipe (Mesa's software Vulkan) the suite runs in CI for
correctness, and the overhead is reported but not gated, since a
software driver's own cost swamps it.

If the gate fails, the first step is the profile: the encoder (Resid
CPU speed, Surreal R3), copies (host-pointer import,
`VK_EXT_external_memory_host`, instead of a staging copy), or wake-ups
(spin briefly before the futex). The design changes only if those
cannot close the gap.

## 10. Phases

| Phase | Work | Done when |
|---|---|---|
| **P1 Host skeleton** | `resid-gpu-host` builds from `install.sh`. Hash-pinned `execveat` start, socket handshake reusing `hs_auth`, phase A on lavapipe, radv and NVIDIA. **Syscall census** of each driver after initialization (strace under each), written to `host/gpu/census/*.txt`. Phase B confinement from the census. | Host starts, initializes and locks down on all three. A forbidden syscall in a self-test mode kills it, and the program sees `DeviceLost`. |
| **P2 Wire** | `resid-gpugen` with `--check`, the two rings, arenas over `SCM_RIGHTS`, shared futexes, completion validation, fuzzing. The `gpu` family in the checker (E0219, E0213 modes, E0295, E0296). | Round-trip and fuzz suites green. Every forged-completion mode gives `DeviceLost`. |
| **P3 Commands** | `lib/gpu.resid`: buffers, arenas, upload, compute dispatch on fixed kernels, an offscreen triangle into an image, readback, deferred destruction, in-flight refusal, E0297. | Saxpy and the triangle's pixels match the expected bytes on lavapipe in CI and on a real GPU. |
| **P4 Measure** | `bench/gpu-host/` with baseline. A report in `docs/` with the numbers and the machine. | **Go/no-go decision** recorded in this file's status. |

Each phase adds its `SECURITY.md` rows and tests before the next starts.
Spec §50 (GPU access) is drafted in P2 and finished in P4.

## 11. Out of scope here (later plans)

- **`PLAN-gpu-shaders.md`**: program-supplied shaders. WGSL first,
  compiled offline to SPIR-V by a pinned compiler that inserts bounds
  checks, hash-pinned in provenance, `spirv-val` in the host; then a
  Resid shader subset. E0298-E0299.
- **`PLAN-gpu-present.md`**: windows. The swapchain lives in the host,
  rendering into dmabuf images that the program presents over its own
  Wayland connection (`linux-dmabuf`) or X11 (DRI3/Present), under
  `display`.
- macOS (a Metal host under Seatbelt) and Windows (a D3D12 host in an
  AppContainer). The wire and the program side stay the same.
- Compile-time arena ownership (linear `Buf`, Surreal R2).

## 12. Open questions and proposed answers

1. **D1, host language.** Proposed: **C**, mostly generated, fuzzed
   under sanitizers, and kept small, since it shares a trust domain with
   a C driver anyway. Alternatives: Rust (memory-safe host logic, but
   it reintroduces a toolchain the repository removed), or Resid with a
   new "hosted" target linking the system C library (the cleanest end
   state, but a large compiler change). The README's "no C" line would
   need to read: *the compiler and runtime are Resid; the GPU host,
   which loads the system's C driver, is C*.
2. **D2, `SECURITY.md` wording** for what remains trusted. Proposed:
   *the GPU host and the vendor driver are trusted to be the driver;
   they are confined to their device descriptors, and their failures
   reach the program as values*. GPU side channels are out of scope,
   as other side channels are.
3. **D3, executable memory in the host.** Proposed: refused, except in
   an explicit software-driver mode for CI (lavapipe compiles shaders
   to CPU code with LLVM).
4. **D4, one host per program or one per device?** Proposed: one per
   device the program opens. Hosts shared across programs are refused,
   since they would share state across programs.
5. **D5, the census.** If a driver needs a syscall after initialization
   that cannot be confined (for example opening a new device node
   lazily), the options are: open it during phase A, allow it narrowly,
   or refuse that driver version. To be decided per case, with the
   census as evidence.
6. **Q6, a Resid userspace driver** over `device` descriptors, which
   would remove the vendor driver from the trusted base. This is
   possible for open drivers (amdgpu, and nouveau/NVK on NVIDIA),
   impossible for NVIDIA's proprietary stack, and years of work. Not
   planned.
