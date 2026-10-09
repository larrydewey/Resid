# Device Access — Implementation Plan (revision 1)

**Status: PROPOSED (2026-10-09).** Under review; two open questions settled (§7). Depends on
PLAN-secret-type.md for descriptors that return key material.

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
