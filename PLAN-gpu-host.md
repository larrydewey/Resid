# GPU Access through a Confined Host — Implementation Plan (revision 2)

**Status: revision 2 DRAFT (2026-11-23), for review. Nothing here is
implemented.** Revision 1 proposed writing the GPU host in C. The owner
rejected that as a shortcut: **the host is Resid**, and the compiler
gains what that needs (§3, §4). Decisions D2-D4 of revision 1 were
accepted with their proposed answers (§13).

This is phase 0 of the Surreal engine (`larrydewey/surreal`, `DESIGN.md`
§3 R1 and milestone M0a). It ends in a **measured go/no-go**: if the
process boundary costs more than the gate in §10, the design is revised
before anything is built on it.

Read first: `resid_specification.txt` §16 (handles), §19 (spawn), §20-21
(capabilities, sandboxes), §47 (native modules), §48 (secrets), §49
(device access); `PLAN-native-modules.md`; `PLAN-device-access.md` §5
(isolation); `PLAN-macos.md` (libSystem as the kernel interface);
`SECURITY.md` (threat model, the `display` rows).

**Goal.** A Resid program can drive a GPU through Vulkan with **no
undefined behavior in the program, no native code in the program, no
new ambient authority, and no code of ours outside Resid**, at a cost
small enough for a 240 Hz renderer. Every existing law of the
specification and row of `SECURITY.md` stays true.

---

## 0. Design in one paragraph

The vendor driver never enters the program. A **GPU host**, a separate,
long-lived, confined process **written in Resid**, loads the system's
Vulkan loader and driver, and replays a **command stream** the program
writes into a shared-memory ring. To load a driver, the host is built
for a new **hosted target**: a dynamically linked Resid executable
started by the system's dynamic loader, whose runtime defers to the
system C library for process start-up, thread-local storage and
threads. The host calls Vulkan through **foreign descriptors** generated
from Khronos's registry (`vk.xml`), the same way device access calls the
kernel through descriptors generated from uapi headers (§49): Resid code
never sees an address, and only the reviewed host may make such calls.
The host treats every byte from the program as untrusted, and the
program treats every byte from the host as untrusted. GPU objects reach
the program as handles (§16). Bulk data lives in shared arenas whose
ownership moves to the GPU on submit and back on completion. A driver
crash, a GPU hang or a misbehaving host reaches the program as
`Err(DeviceLost)`, never as corruption.

## 1. Why not the alternatives

| Alternative | Why not |
|---|---|
| `@link` the Vulkan driver (§47) | Each call is a fresh process (~2 ms) with no state. A frame needs a live device and many calls. |
| A trusted in-process FFI in the program | The driver would be C in the program's address space: any driver bug is UB in the program, and the driver holds the program's authority. **Rejected.** |
| Re-execute the program as the host (`hs_spawn`) | Resid binaries are `-static-pie -nostdlib`. Vendor drivers are shared objects that need the system C library and dynamic loader. |
| The host in C or Rust | Code of ours outside Resid, outside the compiler's checks. **Rejected** (revision 1). |
| A Resid userspace driver over `device` descriptors (no vendor driver) | Removes the vendor driver from the trusted base, but there is no NVIDIA proprietary support, no public kernel GPU interface on macOS or Windows, and years of work. A long-term idea (§13, Q6). |

## 2. Spec conformance matrix

| Spec rule | How the design meets it | Enforced by | Test |
|---|---|---|---|
| §5, §38: no exposed storage | GPU objects and arenas are handles (index + generation), in the program and in the host. Foreign descriptors marshal values and never return an address to Resid code. | runtime `gpu_tab`, `fx_tab` | `gpu_no_address_leak`, `gpu_stale_handle_refused`, `foreign_no_address_leak` |
| §4, §16: only handles carry mutable state; mutable handles move | Writing an arena is a handle verb. An arena submitted to the GPU is in flight, and writes are refused until its ticket completes. | runtime `arena_state` | `gpu_arena_put_bounds`, `gpu_inflight_write_refused` |
| §47 (native code holds no authority) and the threat model (untrusted library code) | **Programs cannot call foreign code at all.** Foreign descriptors exist only in `lib/host/` (E0298), and their verbs are reachable only from the host's own entry in `tools/` (E0299). The rule is unchanged for every program. | checker, by resolved path as E0260 | `err_foreign_outside_host`, `err_foreign_descriptor_outside_lib_host` |
| Law 8, 9, 10: providers and effects | `gpu.*` and `foreign.*` verbs are effects and are never reduced. | `gx_collect`, `ga_effect` | `gpu_never_folded`, `gpu_graph_effect` |
| Law 11: provenance | The host is a signed Resid release binary. Its SHA-256 is fixed when the program compiles, checked before exec, and recorded as `gpu_host`. | driver, runtime | `gpu_in_provenance`, `gpu_host_hash_mismatch` |
| Law 12: runtime uncertainty is explicit | Every failure is a `GpuError` value. A crashed, hung or misbehaving host is `DeviceLost`, inside or outside `spawn`. | runtime | `gpu_host_killed`, `gpu_forged_completion`, `gpu_in_spawn_err` |
| §20, Law 14: no ambient authority | New family `gpu`, with mode `readonly` for queries, transitive (E0219). | `gk_builtin_family`, `gk_unknown_family` | `err_gpu_ungranted`, `err_gpu_readonly_write`, `gpu_sandboxed_lib_refused` |
| §21: sandboxes cannot amplify | A sandbox that drops `gpu` refuses every `gpu.*` call inside it; a handle passed in does not carry the grant. | `resid_cap_check` | `gpu_handle_without_grant` |
| §48: secrets | `Secret(T)` never crosses to the GPU (E0296). | checker | `err_gpu_secret` |
| Threat model: untrusted input never causes out-of-bounds access | The program validates every completion. The host copies, then decodes, every command in Resid, with checked indexing. The decoder is generated and fuzzed. | runtime, generated decoder | `gpu_forged_completion`, `tests/gpu/fuzz` |
| Self-hosting, byte-identical seeds | The static targets' IR does not change. The hosted target is a separate target word, as AArch64 is. | `boot.sh` fixed point | existing |

## 3. The hosted target

`--target x86_64-linux-hosted` (and `aarch64-linux-hosted` after it). A
hosted binary is a dynamically linked PIE with the system dynamic loader
as its interpreter, started by the C library's start-up code, which then
calls Resid's `main`. It exists so a Resid program can share a process
with shared objects built against the system C library. The **only**
program allowed to load such objects is the GPU host (§4). A hosted
build of any other program behaves exactly like its static build.

What changes in the runtime under the hosted target (a target word, as
`tgt_a64` is, so x86-64 static IR stays byte-identical):

| Static target today | Hosted target |
|---|---|
| `_start` emitted with `main`, calling `resid_start` | No `_start`. The C library's start-up calls `main`, which calls a hosted `resid_start_hosted` that records argv, envp and auxv from `getauxval`. |
| Self-relocation (`self_relocate`) | Skipped: the dynamic loader relocates. |
| TLS block installed with `resid_raw_tp_set` | Skipped: the loader owns the thread pointer. The runtime's `thread_local(localexec)` globals live in the executable's static TLS, which `localexec` already addresses correctly in a dynamically linked executable. |
| Threads by raw `clone(SETTLS)` with their own TCB (`thread_spawn`) | Threads by `pthread_create`, so the C library's per-thread state exists on every thread. Guard pages and stack sizes are kept through `pthread_attr_*`. |
| `memcpy`/`memmove`/`memset`/`setjmp`/`longjmp` emitted as naked assembly under those names | Emitted under runtime-private names (`resid_rt_memcpy`, ...) with LLVM told not to lower to the libc names, so nothing in the process interposes on the C library's symbols or the other way round. |
| `SIGCHLD` set to default; no other handlers | Same. The host installs no signal handlers. |
| Allocator over `mmap` | Unchanged. It coexists with the C library's `malloc`, which the driver uses. |
| Linked `-static-pie -nostdlib` | Linked `-pie` against the system C library, with `--no-undefined`. The C library is resolved, not copied: the host carries no C of ours. |

The C library entry points the hosted runtime calls (`getauxval`,
`pthread_create`, `pthread_join`, `pthread_attr_*`, `dlopen`, `dlsym`,
`dlclose`, `dlerror`) are declared in one runtime file,
`runtime/rt/hosted.resid`, compiled only for hosted targets and only
with `--runtime-internals` (E0220 as for every runtime internal). They
are not reachable from any program.

**Gate for the target:** the whole conformance suite passes on it
(`RESID_TARGET=x86_64-linux-hosted tests/conformance/run.sh`), as
AArch64 does under qemu, and the static self-compile fixed point is
unchanged.

## 4. Foreign descriptors (Vulkan only)

The host calls Vulkan the way device access calls the kernel: through
**descriptors**, never through pointers in Resid code.

**Generated, not written.** `tools/resid-vkgen` reads the Khronos
registry `vk.xml` (pinned by version and hash in
`tools/vkgen/registry.toml`) and an input list of the commands the host
uses (`tools/vkgen/commands.toml`). It compiles a probe against the
pinned Vulkan headers with clang for each target, reads back every
size, offset and alignment (as `resid-devgen` does), and writes
`lib/host/vk_*.resid`, headed `GENERATED`. `--check` fails on any
difference, and `--matrix` checks layouts across the pinned header
versions.

**What a descriptor states**, from `vk.xml` and the probe:
- the command, how its function pointer is obtained
  (`vkGetInstanceProcAddr` / `vkGetDeviceProcAddr`), and its result
  codes;
- each parameter's role: scalar, enum (with its valid range), flags (with
  valid bits), dispatchable or non-dispatchable handle (with its type), input
  struct, output struct, input array or output array (with the parameter
  or member that holds its length, from `vk.xml`'s `len`), and
  `pNext` chains limited to the structs the input list allows;
- each struct's layout per target.

**The engine.** `foreign.call(desc, args)` (`runtime/rt/foreign.resid`):
- checks every value against its role (enum range, flag bits, handle
  live and of the right type, array length equals its length field);
- builds the C structs in a scratch region with guard pages and
  canaries, as the device host builds ioctl structs;
- calls through the function pointer;
- reads outputs back within their declared capacities, checks the
  canaries, and turns returned Vulkan handles into Resid handles of the
  right type.

A mapped memory pointer (`vkMapMemory`) becomes a mapping handle with a
size, read and written through checked verbs, as display shared memory
is. A program arena imported as host memory
(`VK_EXT_external_memory_host`) is passed as the arena's handle; the
engine alone turns it into an address.

**No callbacks.** No Resid function is ever called from driver code. The
allocation callbacks are always null. In the `debug` profile the
validation layer's messages go to a log file through the layer's own
settings (no debug-messenger callback), and the host forwards them to
the program as values.

**What stays trusted:** the driver's behavior once called. The engine
guarantees that what it passes is well formed and that what comes back
stays inside declared bounds; it cannot make a buggy driver correct.
That is §8's trusted base, confined by §5.

## 5. The host program

`tools/resid-gpu-host.resid`, built for the hosted target by `boot.sh`
and `install.sh` as a signed release binary, installed as
`$RESID_HOME/libexec/resid-gpu-host`. A shipped game carries it beside
its binary. It is Resid end to end: the decoder, the validation, the
replay and the confinement.

**Integrity.** When a program is compiled, its build pins the host's
SHA-256 (recorded in provenance as `gpu_host`). At start the runtime
opens the host file, hashes the open descriptor, compares, and executes
**that descriptor** (`execveat(fd, "", AT_EMPTY_PATH)`), so the file
cannot be swapped between check and exec. A mismatch is
`Err(HostMismatch)`.

**Lifecycle.** One host per device the program opens (D4), started by
`gpu.open()`. It runs with `PR_SET_PDEATHSIG`, so it dies with the
program. Start-up reuses the device host's checks: the host goes
non-dumpable first, refuses a tracer, proves to the program that it is
this exact child (`hs_auth`'s challenge), and the program accepts bytes
only from that child's socket (`SO_PEERCRED` pid). In secret mode no
host starts without Yama `ptrace_scope` >= 1 (`hs_yama_ok`).

### 5.1 Two-phase confinement

A driver cannot initialize under a tight filter: it reads ICD manifests,
probes `/sys` and `/proc`, opens device nodes, maps device memory and
starts threads. So the host confines itself in two steps, as browser GPU
processes do.

**Phase A, initialize (no input from the program yet read).**
- Environment: empty except a fixed list the runtime sets. Implicit
  Vulkan layers are disabled (`VK_LOADER_LAYERS_DISABLE=~implicit~`),
  so overlays and capture tools cannot inject code. In the `debug`
  profile, `VK_LAYER_KHRONOS_validation` is enabled explicitly.
- `dlopen` the loader, create the instance, pick the device the program
  asked for, create the logical device and queues, and require the
  robustness features (§8). A device without them is `Err(Unsupported)`.
- Create the shared rings and the futex words (§6).

**Phase B, lockdown (before reading the first command).**
- Close every descriptor but the socket, the rings and those the driver
  opened (recorded by diffing `/proc/self/fd` around phase A).
- Landlock: no filesystem access, except an optional per-program shader
  cache directory the runtime creates. No cache means the driver's
  cache is turned off.
- seccomp: an allowlist built from a measured **syscall census** (P3) of
  each driver after initialization: `ioctl` on the recorded device
  descriptors only, `mmap`/`munmap`/`mprotect` without `PROT_EXEC`
  (except in the software-driver test mode, D3), `futex`,
  `read`/`write`/`recvmsg` on the socket, `clone` with thread flags only
  (drivers start worker threads; no new processes), `exit`/`exit_group`,
  and a short list of harmless probes answered with `EPERM`. Anything
  else kills the host, which the program sees as `DeviceLost`. This
  fails closed.

The host never receives a path, an fd it did not create, or an
environment variable from the program.

## 6. Shared memory and the rings

- **Arenas** are `memfd`s sealed against shrinking (`F_SEAL_SHRINK`),
  mapped in both processes, and sent to the host over the socket
  (`SCM_RIGHTS`, as `resid_disp_send` does).
- **Command ring**: single producer (program), single consumer (host).
  Head and tail are 64-bit counters that only grow. Records are
  length-prefixed and 16-byte aligned.
- **Completion ring**: the reverse direction; each record is
  `{ticket, status, timeline_value}`.
- **Wake-ups**: futex words in the shared mapping, using the *shared*
  futex operations (no `FUTEX_PRIVATE_FLAG`), unlike those in
  `runtime/rt/ctl.resid`. A submit costs one wake only when the host is
  asleep.

### 6.1 Neither side trusts the other

**Host reading commands.** The host **copies each record out of shared
memory, then decodes the copy**, and never reads the shared bytes
twice. Decoding is the generated decoder (§7), then semantic checks:
handles live and owned by this program, ranges inside buffers,
pipelines known, offsets computed with checked arithmetic (Resid's
default).

**Program reading completions.** The runtime checks each completion:
the ticket was issued and is pending, the status is known, timeline
values only grow. Anything else means the host is broken or
compromised: the runtime kills it and every handle of that device
becomes `DeviceLost` (`gpu_forged_completion`, one self-test mode per
kind of bad completion).

## 7. One schema, two generated ends

`tools/resid-gpugen` generates both ends of the wire from one schema,
`tools/gpugen/commands.toml`:

- `lib/gpu_wire.resid`: the program's encoder, `GENERATED`.
- `lib/host/gpu_decode.resid`: the host's decoder, `GENERATED`, total
  by construction: fixed-size fields through a bounds-checked cursor, no
  recursion, every enum checked against its range. Being Resid, an
  out-of-range read is a checked abort, never UB. It must also never
  abort on any input, so it returns `Err` instead (tested by the fuzzer).
- `resid-gpugen --check` fails on any difference (`tests/gpu/run.sh`).

The decoder is fuzzed in the style of `tests/crypto`'s mutation fuzz of
every untrusted-input parser, seeded with the encoder's output for every
command. A round-trip property test (encode, decode, compare) runs in
the suite.

## 8. The program side and GPU-side UB (spike scope)

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

The spike's shaders are fixed: `Kernel` names pipelines built into the
host from SPIR-V the repository commits. Program-supplied shaders are a
separate plan (§12), because that is where GPU-side UB is decided.
Runtime builtins `resid_gpu_*` (`runtime/rt/gpu.resid`) follow the
display builtins' pattern, each in the four places `AGENTS.md` lists
plus `ls_builtins`, then a reseed.

| Hazard | Spike's answer |
|---|---|
| Invalid API usage | Commands are typed and validated twice (encoder, host). Every Vulkan call goes through a checked foreign descriptor. In debug runs the validation layer is on, and the suite fails on any message from it. |
| Missing barriers | The host derives barriers from each command's declared reads and writes, in order. There is no barrier command to get wrong. |
| Use-after-free | Destroying a handle queues the object. The host frees it when the timeline passes the last submit that used it. |
| CPU/GPU race on an arena | In flight from submit until its ticket completes. `put` is refused (a runtime check now, a compile-time linear type with Surreal's `Buf` later). |
| Out-of-bounds shader access | The host requires `robustBufferAccess2` and `robustImageAccess2` (`VK_EXT_robustness2`); without them, `Err(Unsupported)`. Bounds-checked shader compilation belongs to the shader plan. |
| Hang | A per-submit timeout. Device loss is `DeviceLost`, recoverable by opening a new `Gpu`. |

## 9. Capabilities, checks and errors

- Family `gpu`; `gpu(readonly)` covers `open` (enumerate only), `info`
  and `limits`. Every other verb is a write.
- Family `foreign`, mode-less, held only by the host's `main`.
- **E0295**: a `gpu` verb in `lib/dev/`, `lib/host/`, `runtime/rt/` or
  `tools/` other than the host.
- **E0296**: a `Secret` type in a `gpu` verb's argument, or inside a
  value reaching one.
- **E0297**: a `Cmd` known after reduction to be invalid (a statically
  out-of-range copy, a zero-group dispatch). Runtime checks remain for
  values not known at compile time.
- **E0298**: a foreign descriptor (a literal of a `lib/host/` descriptor
  type, or `@foreign`) outside `lib/host/`, checked by resolved path
  against the stdlib root, as E0260.
- **E0299**: a `foreign.*` verb reached from anything but the host's
  entry (`tools/resid-gpu-host.resid`), or in a static-target build.
- E0302-E0305 are reserved for the shader plan.
- `GpuError`: `Unsupported`, `HostMismatch`, `HostFailed(stage)`,
  `DeviceLost`, `OutOfMemory`, `InvalidHandle`, `InFlight`,
  `OutOfRange`, `Timeout`, each with the verb's name.

## 10. The measurement and the gate

`bench/gpu-host/`, run by one command, reporting CPU time on the
program's thread, CPU time in the host, and wall time:

| Bench | Workload | Why |
|---|---|---|
| B1 | Empty submit + wait, 10,000 times | Bare round-trip latency |
| B2 | **64 commands per frame**, 2 frames in flight, 10,000 frames | Shape of a GPU-driven frame (Surreal's renderer) |
| B3 | 5,000 commands per frame | Shape of a CPU-driven frame, to see the slope |
| B4 | 16 MiB arena upload per frame | Bulk bandwidth |

**Baseline**: the same work with Vulkan called in-process, as the other
benchmark suites compare against opponents (`bench/gpu-host/baseline/`,
a reference port like the AWFY ports, not part of the product).
**Overhead** = (program + host CPU per frame) - (baseline CPU per
frame).

**Gate (go/no-go), on the reference machine with a real GPU:**
- B2 overhead median **< 100 µs/frame**, p99 **< 250 µs**.
- B4 bandwidth **>= 80%** of the baseline.
- B1 is reported, not gated.

On lavapipe (Mesa's software Vulkan) the suite runs in CI for
correctness, and the overhead is reported but not gated.

If the gate fails, the first step is the profile: the encoder and
decoder (Resid CPU speed, Surreal R3, `PLAN-awfy-lead.md`), copies
(host-pointer import instead of a staging copy), or wake-ups (spin
briefly before the futex). The design changes only if those cannot
close the gap.

## 11. Phases

| Phase | Work | Done when |
|---|---|---|
| **H1 Hosted target** | The target word, start-up, TLS, pthread threads, private mem*/setjmp names, link line, `runtime/rt/hosted.resid`. `boot.sh` builds and checks a hosted runtime IR beside `rt.ll` and `rt-aarch64.ll`. | The whole conformance suite passes on the hosted target. The static fixed point is unchanged. |
| **H2 Foreign descriptors** | `resid-vkgen` (`--write`, `--check`, `--matrix`), the engine with guard pages and canaries, the `foreign` family, E0298, E0299. Tested against a test-only shared object, as the native-module fixtures are, then against the Vulkan loader with lavapipe. | Enumerate devices and create a device on lavapipe from Resid. Engine fault tests (overrun, bad handle type, length mismatch) refuse cleanly. |
| **P3 Host skeleton** | `tools/resid-gpu-host.resid`, hash-pinned `execveat` start, `hs_auth` handshake, phase A on lavapipe, radv and NVIDIA. **Syscall census** of each driver after initialization, written to `tools/gpu/census/*.txt`. Phase B from the census. | Host starts, initializes and locks down on all three. A forbidden syscall in a self-test mode kills it, and the program sees `DeviceLost`. |
| **P4 Wire** | `resid-gpugen` with `--check`, the rings, arenas over `SCM_RIGHTS`, shared futexes, completion validation, fuzzing. The `gpu` family in the checker, E0295, E0296. | Round-trip and fuzz suites green. Every forged-completion mode gives `DeviceLost`. |
| **P5 Commands** | `lib/gpu.resid`: buffers, arenas, upload, compute dispatch on fixed kernels, an offscreen triangle, readback, deferred destruction, in-flight refusal, E0297. | Saxpy and the triangle's pixels match on lavapipe in CI and on a real GPU. |
| **P6 Measure** | `bench/gpu-host/` with baseline; a report in `docs/` with numbers and machine. | **Go/no-go recorded** in this file's status. |

Each phase adds its `SECURITY.md` rows and tests before the next starts.
Spec §50 (GPU access) and §51 (hosted target and foreign descriptors)
are drafted in H2 and finished in P6.

## 12. Out of scope here (later plans)

- **`PLAN-gpu-shaders.md`**: program-supplied shaders. WGSL first,
  compiled offline to SPIR-V by a pinned compiler that inserts bounds
  checks, hash-pinned in provenance, validated in the host; then a
  Resid shader subset. E0302-E0305.
- **`PLAN-gpu-present.md`**: windows. The swapchain lives in the host,
  rendering into dmabuf images the program presents over its own
  Wayland connection (`linux-dmabuf`) or X11 (DRI3/Present), under
  `display`.
- macOS: per `PLAN-macos.md` the runtime already calls libSystem there,
  so every macOS binary is effectively hosted. A Metal host under
  Seatbelt needs foreign descriptors for the Objective-C runtime.
  Windows: a D3D12 host in an AppContainer. The wire and the program
  side stay the same.
- Compile-time arena ownership (linear `Buf`, Surreal R2).
- Threads in the host beyond what the driver starts itself.

## 13. Decisions and open questions

Decided (2026-11-23):

- **D1, host language: Resid**, on the hosted target (§3, §4). No C or
  Rust of ours.
- **D2, `SECURITY.md` wording:** *the GPU host's Vulkan driver is
  trusted to be the driver; it is confined to its device descriptors,
  and its failures reach the program as values*. GPU side channels are
  out of scope, as other side channels are.
- **D3, executable memory in the host:** refused, except in an explicit
  software-driver mode for CI (lavapipe compiles shaders to CPU code).
- **D4:** one host per device a program opens, never shared between
  programs.

Open:

5. **D5, the census.** If a driver needs a syscall after initialization
   that cannot be confined (for example opening a device node lazily),
   the options are: open it during phase A, allow it narrowly, or refuse
   that driver version. Decided per case, with the census as evidence.
6. **Q6, a Resid userspace driver** over `device` descriptors, which
   would remove the vendor driver from the trusted base. Possible for
   open drivers (amdgpu; nouveau/NVK on NVIDIA), impossible for NVIDIA's
   proprietary stack. Not planned.
7. **Q7, the hosted target beyond the host.** Should any other program
   ever be allowed foreign descriptors (for example audio through ALSA's
   library)? This plan says no: each such use would need its own host
   and its own plan.
