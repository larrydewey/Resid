# Device Access — Implementation Plan (revision 1)

**Status: ACCEPTED (2026-10-09).** Open questions 1, 2 and 4 settled (§7); question 3 is decided during implementation. Depends on
PLAN-secret-type.md for descriptors that return key material.

**Progress.** Phase 1, the compile-time half, is in (2026-10-09; spec §49,
`SECURITY.md` "Device access"): the `device` family with `readonly` and
full modes (E0219, spawn lists, sandboxes, manifest grants, the force-time
guard as `device` / `device!`); the descriptor types in
`lib/dev/device.resid` (`Dir`, `Field`, `IoctlOp`, `Transact`, `ReadAttr`,
`ConfigfsReport`, `Sequence`, `Link`, per-target `Request`s, the interface
version, the stability class, `DeviceError`); the five verbs, typed and
lowered to the engine in `lib/dev/` and from it to one runtime entry
(`resid_device_call`, `resid_device_call_w`), which answers `Unsupported`
until phase 2's host; E0260-E0264 (`compiler/gcheck.resid`,
`compiler/device.resid`); manifest bounds `devices = [...]`
(`tools/resid-manifest.resid`); descriptors in the graph artifact and the
provenance record (`devices`), shown by `residc verify`; the sample
`lib/dev/sev_guest.resid` (SNP_GET_REPORT) and
`lib/dev/sev_guest_key.resid` (SNP_GET_DERIVED_KEY). Tests: 19
conformance cases (`device_*`, `err_device_*`), `tests/device` (27: one per
E0263/E0264 rule against a private standard library, and E0260 with a
relative library root), `tests/runtime/device_entry.c`, `tests/pkg`
(`pkg_device_ceiling`), `tests/provenance` (`device_in_provenance`,
`device_stability_in_provenance`).

As built, compared with the text below:

- **Bytes.** The plan's `Bytes` / `Bytes(N)` (§2, §3) are NUL-terminated
  in Resid (spec §44), so they cannot carry device buffers and their
  length check would branch on secret bytes. Buffers cross as
  `List(UInt(8))`, secret ones as `List(Secret(UInt(8)))` (the
  `lib/word.resid` convention); fixed-size inputs are `List(UInt(8))`
  checked against the descriptor's length.
- **Shapes.** `Scalar` and `Inline` carry a direction
  (`Scalar(offset, width, dir)`), which E0263's direction-bit rule and
  E0264's output/input rule need. `IoctlOp` has `requests: List(Request)`
  (one per target) for `request`, plus `version: IfaceVersion` and
  `stability: Stability`. A Resid variant cannot share its sum type's
  name, so `Link` is a record with a constructor function `link(...)`.
  Every verb returns `Result(List(DevOut), DeviceError)`, outputs in field
  order (`OutNum`, `OutBytes`, `OutSecret`); inputs are `List(DevIn)`
  (`InNum`, `InBytes`). The Sequence verb is `device.sequence(op, args)`.
- **Who may call a verb.** Any code, with a descriptor from `lib/dev/`
  (§3): E0260 refuses a descriptor literal or `@descriptor` outside the
  standard library's `lib/dev/` (by the resolved path, so a dependency's
  own `lib/dev/` does not count), a call of the engine, and a call of the
  runtime entry. Descriptor types are found by their `@descriptor(kind)`
  annotation, not their names.
- **Read or write.** The checker reads `write` before reduction from the
  literal the descriptor argument names (a zero-argument function returning
  the literal); otherwise it assumes a write. The engine is split in two
  modules, `device.resid` (reads) and `device_write.resid` (writes): a
  module is compiled inside its importer's ceiling, so a dependency granted
  `device(readonly)` can import only modules without a writing descriptor.
  That is why SNP_GET_DERIVED_KEY is `sev_guest_key.resid`.
- **E0261 names.** A bound entry is a descriptor name
  (`sev_guest.snp_get_report`) or a device module prefix (`sev_guest`).
  Descriptor names are `<module>.<op>`.
- **Reduction.** Records have no literal form in the reducer, so a device
  verb's known descriptor is written out by `gx_render_full`; and since
  code inside a sandbox (an attenuated import, a dependency under its
  ceiling) was not reduced at all, a sandboxed function holding a device
  verb now is, and sandboxed declarations are known to the evaluator
  (never specialized, so no copy escapes its sandbox).
- **Not checked by `--profile check`.** E0261-E0264 run on the reduced
  program, before lowering.
- **Open question 3 (decided): no descriptor list in `residc --version`.**
  The compiler holds no descriptor: the set is the standard library's
  `lib/dev/` files, versioned with the library and hashed into every
  provenance record's `sources`. What an auditor needs is per binary --
  `residc verify` prints the descriptors it reaches, with their stability
  classes -- and per toolchain the directory itself, which a listing in
  `--version` could only restate and could drift from.

Phase 2 needs from this: `runtime/rt/device.resid`'s two entries take the
request `lib/dev/device.resid` documents (magic `RDV`, kind, write, name,
path, the kind's own part, inputs) and answer the reply it documents (0 +
outputs, or 1 + error code + value); the host must re-check the layout
itself (it is not the compiler), choose the request number for
`resid_raw_arch()`, set the interface version and check it after the
call, and keep `resid_device_call` read-only (phase 1's stub already
refuses, with Denied, a request whose write byte is not 0; the host must
keep that). The provenance and graph records are already there.

- **TODO (phase 2): secret slots.** A Buffer marked secret reaches the
  engine inside the reply as ordinary bytes and is wrapped as
  `Secret(UInt(8))` only there. The host must deliver secret slots in a
  separate buffer, wiped after the engine copies them, so key material
  never sits in the general reply.

**Security review (2026-10-09), fixed:**

- A local named `device` bound by a pattern (`if (Some(device) = x)`,
  `Some(device) = x;`) escaped E0001 (the binder is the node's `aux`), and
  the device pass then rewrote the program's own `device.ioctl(...)`
  method call into the write engine with a look-alike record and no
  grant. Now: every binder form and import aliases are checked
  (`dv_rebinds`, `imp_resolve_lines_a`); after reduction a verb's
  `device` must resolve to the builtin provider (`dv_is_provider_verb`,
  on a resolution of the residual graph -- `rs_dense` now tolerates the
  repeated uses a shared subtree gives); and the descriptor literal must
  be of the role type `lib/dev/device.resid` declares, compared in full
  (`dv_lit_type`, E0260).
- The runtime's read entry refuses a write request; E0263 refuses an
  ioctl that only sends labelled `write = false`. Otherwise `write` is a
  reviewed label.
- `snp_get_derived_key` checks the response status (declassified alone,
  so it needs `declassify` as well as `device`) and `exitinfo2`.
- The engine refuses a number output wider than its Scalar, and decodes
  any 8-byte value without overflow (`dv_rd64`).
- E0260's lib/dev/ test fails closed when the standard library root is
  not absolute (`RESID_HOME` unset).
- A sandbox's own `@fold` / `@reduce(steps = ...)` are ignored: its
  functions evaluate under the default step limit (`gx_sb_nocap`).
- Provenance lists every descriptor the residual program holds; a
  dependency's reach includes every behavior instance's functions
  (dispatch, `sort`, operators); a sub-dependency without a bound inherits
  its parent's; functions are looked up by every declaration of a name.

**Goal**: let a Resid program talk to kernel devices (ioctls on character
devices, request/response devices such as `/dev/tpmrm0`, and configfs
interfaces such as `/sys/kernel/config/tsm/report`) through **one generic
mechanism**, without weakening any law of `resid_specification.txt` or any row
of `SECURITY.md`. The program gains no pointer, no file descriptor, no raw
request number and no free-form path.

**What "guaranteed" means here.** Same as PLAN-native-modules.md: each claim
names its enforcement point and its test. The threat model is `SECURITY.md`'s.
Kernel bugs and a kernel ABI that differs from its published header are out of
scope, but their *blast radius* is bounded by the isolation in §5.

---

## 0. Design in one paragraph

Device access is a **provider** (Law 8). Each kind of device operation is
described by a **descriptor**: a record value the compiler must fully reduce
at compile time (Law 1, Law 5), giving the device path, the operation, the
request number, the byte layout of the argument struct, and which fields are
pointers to buffers. One generic runtime engine interprets descriptors; there
is no per-device code in the compiler or runtime. Descriptors may be declared
**only in the standard library** (`lib/dev/`), which keeps the full set of
kernel interfaces a Resid program can reach in one reviewed place. Every call
runs in a **fresh, isolated child process** (the native-module host, reused):
the child opens the one path, installs a seccomp filter that allows only the
descriptor's operation on that descriptor and I/O on its socket, performs the
call into memory it allocated itself, and returns the bytes. The parent
validates them as untrusted input. Authority is one family, `device`, with
`readonly` and full modes; the descriptor says which operations are writes.

## 1. Why generic, and how least privilege survives it

A family per device (`device_sev_guest`, `device_tdx_guest`, ...) gives the
finest grant but multiplies families, manifests and checker cases with every
new device. The generic design keeps one family and recovers precision two
other ways:

- **The descriptor set is closed.** Only `lib/dev/*.resid` can declare one
  (E0260 elsewhere), so "what can `device` reach" is a reviewed list, not
  anything a dependency writes.
- **Which descriptors a binary uses is knowledge.** Every descriptor reached
  is a KNOWN value, recorded in the graph artifact and the provenance record
  (`devices: [{name, path, op, request}]`). `resid-why` and `residc verify`
  show exactly which devices and operations a binary can touch, and a manifest
  can bound a dependency to named descriptors:
  `[dependencies.X] devices = ["tsm_report", "tpm"]` (E0261 if exceeded).
- **Modes still mean something.** Each descriptor operation is classified:
  reading a report or a register is a read; deriving a key, extending a
  measurement register or changing device state is a write. `device(readonly)`
  covers reads only, at compile time and in the force-time guard.

If finer grants turn out to be needed, a later revision can add descriptor
names as modes (`device(tsm_report)`) without changing descriptors.

## 2. Descriptor kinds

All are plain Resid records in `lib/dev/`, reduced to KNOWN at compile time
(E0262 if any field is not KNOWN).

| Kind | Covers | Engine steps |
|---|---|---|
| `Ioctl` | `/dev/sev-guest`, `/dev/tdx_guest`, `/dev/nsm`, NVIDIA `/dev/nvidia*` control calls, PCI TSM/TDISP device nodes | open path; allocate struct and buffers; patch pointer fields; `ioctl(fd, request, struct)`; return struct and out-buffers |
| `Transact` | `/dev/tpmrm0` (TPM 2.0 command/response) | open; write command; read response up to a declared maximum |
| `ConfigfsReport` | `/sys/kernel/config/tsm/report` (SNP, TDX, Arm CCA, and any future TSM provider) | create a fresh entry; write `inblob` (and `privlevel`, `service_provider` when given); read `outblob`, `auxblob`, `manifestblob`, `provider`, `generation`; check `generation` did not change between write and read; remove the entry |
| `ReadAttr` | read-only sysfs attributes the attesters need (for example the TSM provider name, NVIDIA CC mode state) | open; read up to a declared maximum |
| `Sequence` | stateful interfaces where one call's output is the next call's input: NVIDIA's resource-manager objects (allocate a client, a device, the confidential-computing object, then make the control call) | open the path once; run the listed `Ioctl` steps in order in the same host; copy declared output fields of one step into declared input fields of a later step; return only the final step's declared outputs. Handles and intermediate structs never leave the host |

An `Ioctl` descriptor's layout is a list of fields:

```resid
type Dir = In | Out | InOut;
type Field = Scalar(Int, Int)                  // offset, width in bytes (1, 2, 4, 8)
           | Inline(Int, Int)                  // offset, length: bytes inside the struct
           | Buffer(Int, Int, Int, Dir, Bool); // pointer offset, length-field offset (or -1), max length, direction, secret
type IoctlOp = { Str name; Str path; Int request; Int size; List(Field) fields; Bool write; };
```

The compiler checks every descriptor (E0263, naming the field):

- `request`'s encoded size (`_IOC_SIZE`) equals `size`, and its direction bits
  agree with the fields' directions;
- fields lie inside `size`, do not overlap, and pointer fields are 8-byte
  aligned;
- every `Buffer` has a finite maximum, and a length field, when given, is a
  `Scalar` of the struct;
- `path` is under `/dev/` or `/sys/` and contains no `..`;
- the architecture: request numbers that differ between x86-64 and AArch64 are
  given per target, and a descriptor without one for the build's target is
  refused.

A `Sequence` is a list of `Ioctl` steps plus a list of links
`Link(from_step, from_offset, to_step, to_offset, width)`. The compiler checks
(E0264) that every link goes forward, reads a `Scalar` output of an earlier
step and writes a `Scalar` input of a later one with the same width, and that
only the last step has outputs visible to the program. The host keeps the fd
open across the steps and closes it before replying. The seccomp filter allows
each step's request number on that fd and nothing else.

Pointer fields never reach the program. It supplies and receives buffer
*contents* as `Bytes` (or `Secret(Bytes)` when the field is marked secret);
the child places them and writes their addresses into its own copy of the
struct.

## 3. Surface

```resid
import "dev/sev_guest.resid";      // a descriptor module in lib/dev/

@requires(device(readonly))
Result(Bytes, DeviceError) get_report(Bytes(64) report_data) {
    return snp_get_report(report_data);    // a wrapper in lib/dev over device.ioctl(SNP_GET_REPORT, ...)
}
```

- Programs call the typed wrappers in `lib/dev/`. The generic verbs
  (`device.ioctl(op, args)`, `device.transact(op, cmd)`,
  `device.configfs_report(op, req)`, `device.read_attr(op)`) are callable only
  with a descriptor value from `lib/dev/` (E0260).
- Results are `Result(T, DeviceError)`. `DeviceError` carries the errno and the
  descriptor name: device absent, permission denied, kernel error, reply too
  long, `generation` changed. A device that is missing is a value, not an
  abort, because attesters probe for platforms.

## 4. Spec conformance matrix

| Spec rule | How the design meets it | Enforced by (to build) | Test (to write) |
|---|---|---|---|
| Law 1, 5: compile time never depends on residual information | Descriptors are KNOWN; a descriptor depending on runtime data is refused | checker (E0262) | `err_device_descriptor_residual` |
| Law 2, 10: effects are never reduced | Every device verb is an effect node; the reducer never folds it | `gx_collect` | `device_never_folded` |
| Law 8: external knowledge enters through providers | `device` is a provider; the wrappers are the only route | provider table | `device_ok` |
| Law 11: provenance | Graph and provenance record list every descriptor reached | `ga_effect`, `prov_payload` | `device_in_provenance` |
| Law 12: runtime uncertainty is explicit | Every failure is `Err(DeviceError)`; a malformed child reply aborts like a native host failure | engine, parent validation | `device_absent_is_err`, `device_host_killed` |
| Law 14: no ambient authority; only attenuated | `device` family, checked transitively (E0219), in spawn lists, sandboxes, manifest ceilings, and `devices = [...]` bounds | `gk_all_facts`, `resid_cap_check("device")` / `("device!")`, manifest | `err_device_ungranted`, `err_device_readonly_write`, `err_device_sandbox`, `pkg_device_ceiling` |
| §5, §38: no exposed storage | No pointer, fd, request number or path reaches the program; buffers cross as copies | engine | `err_device_raw_verb`, `device_no_address_leak` |
| Kernel ABI drift cannot corrupt the program or pass as a correct result | Request numbers encode size and direction; descriptors generated from uapi headers and checked against a kernel matrix; guard pages and canaries in the host; replies validated (§6.2) | checker, `resid-devgen --check`, engine | `devgen_matches_uapi_*`, `device_overrun_guard_page`, `device_resized_struct_unsupported` |
| §4: no hidden identity | Fresh child per call; no fd survives a call | engine | `device_stateless` |
| Secrecy (PLAN-secret-type.md) | A `Buffer` marked secret returns `Secret(Bytes)`; the child zeroes its copy before exit | engine, checker | `device_secret_out` |

## 5. Isolation

Each call reuses the native-module host (`resid_native_call`'s fork and
re-exec of `/proc/self/exe`, empty environment, one socket):

1. The parent checks the capability (`resid_cap_check`), serializes the
   descriptor and input bytes, and forks the host.
2. The host closes every descriptor but its socket, unmaps the vDSO, disables
   the TSC, then opens the descriptor's one path (`O_RDWR|O_CLOEXEC`, or
   `O_RDONLY` for reads; for `ConfigfsReport`, the entry directory it creates).
3. It installs a seccomp filter that allows: `ioctl` with `arg0 == fd` and
   `arg1 == request` (for `Ioctl`); `read`/`write` on that fd (for
   `Transact`, `ReadAttr`); the fixed set of `openat`/`mkdirat`/`unlinkat`
   calls on the entry's own files (for `ConfigfsReport`, using descriptors
   opened before the filter where possible, and a Landlock ruleset applied
   before the filter that confines the host to the one report entry); `read`/`write` on its socket;
   non-executable `mmap`/`munmap`; and `exit_group`. Anything else kills it.
4. It performs the call into its own memory, writes the struct and out-buffers
   to the socket, zeroes secret buffers, and exits.
5. The parent reads the reply with the declared maxima, validates lengths and
   any length fields against them, and returns the values.

A wrong descriptor or a kernel that writes past a buffer can therefore corrupt
only the host's memory, never the program's.

## 6. Descriptors in the first set

- `sev_guest`: `SNP_GET_REPORT`, `SNP_GET_DERIVED_KEY` (write, secret out),
  `SNP_GET_EXT_REPORT`.
- `tdx_guest`: `TDX_CMD_GET_REPORT0` (TDREPORT; quotes come through
  `tsm_report`).
- `tsm_report`: the configfs report interface (SNP, TDX, Arm CCA).
- `tpm`: `/dev/tpmrm0` transact (bare metal, NitroTPM, the Azure and Google
  vTPMs, including Azure's paravisor report in its NV index).
- `nsm`: AWS Nitro Secure Module request/response ioctl.
- `pci_tsm`: the kernel's PCI TSM interfaces for TDISP device
  authentication (sysfs, from Linux 6.19), through `ReadAttr` and, as the
  device-assignment flow lands, `Ioctl`. This is the primary path for NVIDIA
  Blackwell and later generations, and for any TDISP device: a stable kernel
  interface, not a vendor driver's.
- `nvidia_rm`: Hopper's attestation through NVIDIA's open kernel modules, as a
  `Sequence`. This is the legacy path (§6.1).

### 6.1 Driver-versioned descriptors (NVIDIA Hopper)

The evidence a GPU returns (an SPDM measurements response and a certificate
chain) is defined by DMTF, so parsing and verification never depend on the
driver. Only the resource-manager calls that fetch it do. To keep driver
releases from becoming code changes:

1. **Generated, not written.** `tools/resid-devgen` reads the structs and
   request codes it needs from `open-gpu-kernel-modules` at a release tag and
   emits a descriptor module under `lib/dev/nvidia_rm/`. A new driver release
   is a regenerated file and a reviewed diff. The generator's input list (which
   structs, which commands) is itself checked in, so the review covers exactly
   what changed.
2. **Keyed by layout, not by release.** Each generated descriptor carries a
   fingerprint of its layout. Releases that don't change the layout map to the
   same descriptor, so most driver releases add only a table row.
3. **Selected at run time, failing closed.** The wrapper first reads the loaded
   driver's version (`ReadAttr`), picks the descriptor whose release range
   covers it, and returns `Err(DeviceError::UnknownDriver(version))` when none
   does. It never guesses a layout.


### 6.2 Kernel ABI changes

The kernel is part of the trusted computing base, so no design can make a
wrong kernel produce right answers. What the design guarantees is narrower and
enforceable: **a kernel ABI change can never corrupt the program's memory, and
can never be silently accepted as a correct result.** Most of that comes from
how Linux versions its interfaces; the rest is cheap to add.

| What can change | Why it can't hurt the program | Enforced by (to build) | Test (to write) |
|---|---|---|---|
| A struct's size or direction | `_IOC` request numbers encode both. A resized struct is a different request number, so an old descriptor gets `ENOTTY`, not a mismatched layout. The compiler already checks each descriptor's `size` and directions against its request number (E0263) | checker; engine maps `ENOTTY`/`EINVAL` to `Err(DeviceError::Unsupported)` | `device_resized_struct_unsupported` |
| A layout change behind the same request number | Linux's userspace-ABI rule forbids it for `include/uapi` interfaces. Descriptors are **generated from the uapi headers**, not written by hand (`tools/resid-devgen`, the same generator as §6.1), and a conformance job compiles the headers of every supported kernel and compares `sizeof`/`offsetof` with each descriptor. Drift fails the build before release | `resid-devgen --check`, CI kernel matrix | `devgen_matches_uapi_*` |
| An interface's version field (for example `msg_version` on `sev-guest`) | Descriptors declare the version they speak and the engine sets it; a reply carrying another version is `Err(DeviceError::Version)` | engine | `device_version_mismatch` |
| The kernel writing past a buffer (a kernel bug, or a wrong length field) | The call runs in the isolated host (§5), never in the program. Inside the host, every buffer ends at a `PROT_NONE` guard page and its slack is filled with a canary checked after the call. An overrun kills the host or fails the canary, and the program gets `Err(DeviceError::Overrun)` | engine | `device_overrun_guard_page`, `device_overrun_canary` |
| A reply's lengths or fields out of range | The parent validates every length and length field against the descriptor's maxima, and treats contents as untrusted input | parent validation | `device_reply_length_checked` |
| configfs and sysfs attributes (files renamed, added, removed) | The engine reads the attributes the descriptor names and fails closed on a missing one; `ConfigfsReport` checks `provider` against the descriptor's expected providers and `generation` for races | engine | `configfs_missing_attr_err`, `configfs_unknown_provider_err` |
| Interfaces outside the kernel's stability rule (out-of-tree drivers; sysfs ABI still marked "testing", such as PCI TSM) | Version-keyed, generated descriptors selected at run time, failing closed (§6.1). Each descriptor records its stability class (`uapi`, `abi-testing`, `out-of-tree`) and `residc verify` lists the classes a binary depends on | checker, provenance | `device_stability_in_provenance` |
| Wrong data that is well-formed | For attestation, evidence is signed by hardware and verified downstream, so a corrupted report fails verification rather than passing. Descriptors that return unsigned data say so in their documentation | library design | — |

The remaining risk is a kernel that changes a layout in violation of its own
ABI rule, or a driver that does so between releases. Generated descriptors and
the conformance matrix catch that before release; when one slips through, the
fix is a regenerated descriptor, and the guard pages and validation above keep
it from corrupting anything in the meantime.

## 7. Open questions

1. Settled (2026-10-09): `ConfigfsReport` uses Landlock as well as seccomp.
   The host creates the entry, applies a Landlock ruleset limited to that
   entry, then installs the seccomp filter. Where Landlock is unavailable the
   call fails closed (`Err(DeviceError)`), not open.
2. Settled (2026-10-09): PCI TSM is the primary path for new GPU generations;
   Hopper uses generated descriptors keyed by layout and selected by driver
   version at run time, failing closed (§6.1). Stateful driver interfaces use
   the `Sequence` kind.
3. Should the whole descriptor list appear in `residc --version` output, so an
   auditor can see the device surface of a given compiler?
4. Settled (2026-10-09): kernel ABI changes are contained rather than trusted
   away: descriptors are generated from uapi headers and checked against a
   kernel matrix, request numbers encode size and direction, buffers carry
   guard pages and canaries in the isolated host, and every reply is validated
   (§6.2). A descriptor that breaks anyway is patched by regenerating it.
