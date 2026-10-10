---
title: Device access
description: "The device provider: descriptors from lib/dev/, the generic verbs, readonly and write modes, E0260–E0264, manifest bounds and provenance (spec §49)."
---

A program reaches a kernel device -- an ioctl on `/dev/sev-guest`, a TPM
command on `/dev/tpmrm0`, the configfs report interface, a sysfs
attribute -- through the provider `device`. It never holds a pointer, a
file descriptor, a request number or a path of its own: what a call does is
a **descriptor**, a record only the standard library's `lib/dev/` may
declare. Specification: §49; design: `PLAN-device-access.md`.

## Using a device module

```resid
// check-only
import "dev/sev_guest.resid";

List(UInt(8)) zeros(Int n, ListBuf(UInt(8)) acc) {
    if (n <= 0) { return acc.finish(); }
    return zeros(n - 1, acc.push((UInt(8))0));
}

@requires(device(readonly))
Int main() {
    Str s = match (snp_get_report(zeros(64, ListBuf()), 0)) {
        Ok(report) => f"{report.len()}-byte report",
        Err(e) => device_error_text(e),
    };
    println(s);
    return 0;
}
```

A missing device is a value, not an abort: `Err(Absent(name))`, so an
attester can probe for its platform. Every failure is a `DeviceError`
naming the descriptor: `Absent`, `Denied`, `Kernel(name, errno)`,
`TooLong`, `GenerationChanged`, `Unsupported`, `Version`, `Overrun`,
`UnknownDriver`, `BadInput`, `BadReply`, `Timeout`.

Buffers cross as `List(UInt(8))`, or `List(Secret(UInt(8)))` for a buffer
marked secret ([secret values](/Resid/reference/secrets/)); never as
`Bytes(N)`, which ends at the first zero byte.

| Module | Descriptors | Grant |
|---|---|---|
| `dev/sev_guest.resid` | `sev_guest.snp_get_report` (SNP attestation report; hardware-signed) | `device(readonly)` |
| `dev/sev_guest_key.resid` | `sev_guest.snp_get_derived_key` (a sealing key, secret; not signed) | `device`, `declassify` (only the response's status word is published) |
| `dev/tdx_guest.resid` | `tdx_guest.tdx_get_report0` (TDREPORT; MAC'd for this platform, not signed) | `device(readonly)` |
| `dev/nsm.resid` | `nsm.raw` (a CBOR request to the Nitro Secure Module; only an attestation document is signed) | `device` (a request can extend or lock a PCR) |

Each wrapper's comment says whether what it returns is signed by hardware
(and so verified downstream, where a corrupted reply fails) or is only the
kernel's word. The descriptors of these modules are generated from the
kernel's uapi headers (below); SNP_GET_EXT_REPORT has none yet, since its
certificate buffer is a pointer inside the request struct, which no field
kind places.

## Modes

A descriptor whose `write` is false is a read: `device(readonly)` covers
it. Deriving a key, extending a measurement or changing device state is a
write and needs `device`, at compile time (`E0219`, `E0212`) and in the
force-time guard (`device!`). The checker reads `write` before reduction
from the literal the descriptor argument names; one it cannot read counts as
a write. `device` works in spawn lists, sandboxes and manifest ceilings like
any family.

`write` is a label reviewed with each descriptor in `lib/dev/`, not
something the compiler proves; but an ioctl that only sends data
(`_IOC_WRITE`, no Out or InOut field) marked `write = false` is refused
(`E0263`), and so is a `Transact` marked `write = false`: sending its
command is a write to the device, so `device(readonly)` never covers one.
The runtime's read entry also refuses a request that says it writes.

`device` names the provider everywhere: a binding (a pattern such as
`if (Some(device) = x)` included), function, type, variant or import alias
called `device` is refused.

## The generic verbs

Device modules are written over five verbs, each giving
`Result(List(DevOut), DeviceError)`:

| Verb | Descriptor | Inputs |
|---|---|---|
| `device.ioctl(op, args)` | `IoctlOp`: path, request number per target, struct size, fields | `List(DevIn)`, one per `In`/`InOut` field |
| `device.transact(op, cmd)` | `Transact`: command and response maxima | `List(UInt(8))` |
| `device.configfs_report(op, req)` | `ConfigfsReport`: entry path, accepted providers, blob maxima | `ReportReq` |
| `device.read_attr(op)` | `ReadAttr`: attribute path and maximum | none |
| `device.sequence(op, args)` | `Sequence`: ioctl steps on one file, with links | `List(DevIn)` |

An `IoctlOp`'s fields are `Scalar(offset, width, dir)`,
`Inline(offset, length, dir)` and
`Buffer(offset, length_at, max, dir, secret)`; a `Scalar` a buffer names as
its length is filled in and read back by the engine. Outputs come back in
field order as `OutNum`, `OutBytes` or `OutSecret`.

A program may call a verb itself, but only with a descriptor from
`lib/dev/`: writing a descriptor literal anywhere else is `E0260`, and so
is passing a record of another type with the same fields. "`lib/dev/`" is
the standard library's, compared by absolute path: with `RESID_HOME`
unset the library root is relative and no file counts.

## Generated descriptors

The ioctl descriptors over `include/uapi` headers are not written by hand:
`tools/resid-devgen` generates `lib/dev/uapi_*.resid` (each headed
`GENERATED`, with the header, the kernel tag and commit, and a layout
fingerprint), and the hand-written module beside each (`sev_guest.resid`,
`tdx_guest.resid`, ...) holds the typed wrappers. Every number comes from
the compiler's own view of the ABI: the generator writes a C probe of
`__builtin_offsetof`, `sizeof` and the header's `_IOWR(...)` macros,
compiles it with clang for `x86_64-linux-gnu` and `aarch64-linux-gnu` to
LLVM IR, and reads the probe array's constant initializer back. Nothing is
computed by hand and nothing runs, so both targets are probed on any host.
The wrappers fill and parse the request structs through the generated
`<struct>_size()`, `<struct>_<member>_at()` and `_len()` functions.

| File | Role |
|---|---|
| `tools/devgen/descriptors.toml` | the input list: which structs and requests, and what a header cannot say -- Scalar, Inline or Buffer, direction, secret, length links, the write label, the stability class, the version field, older member names |
| `tools/devgen/kernels.toml` | the pinned kernels: the generation tree and the matrix, each a tag and the commit it must resolve to |
| `tools/devgen/uapi/` | the generation tree's headers (every header clang read for the probes) and their SHA-256 manifest |

| Command | What it does |
|---|---|
| `tools/resid-devgen --write` | regenerate `lib/dev/uapi_*.resid` from the snapshot |
| `tools/resid-devgen --check` | regenerate in memory and compare byte for byte, and check the snapshot against its manifest; offline (`tests/devgen`, `tests/device`) |
| `tools/resid-devgen --local [DIR]` | compare with installed headers (`/usr/include`) or a kernel source tree |
| `tools/resid-devgen --matrix` | fetch each pinned kernel (a sparse, shallow checkout of the uapi trees, cached in `tools/devgen/cache/`, refused unless it is the pinned commit) and compare every size, offset, width, maximum and request number on both targets; drift fails |
| `tools/resid-devgen --snapshot` | refresh the snapshot from the generation pin |

The network is used only by `--matrix` and `--snapshot`, never by a build
or a test. `tools/devgen-matrix.sh` is the release job (and
`.github/workflows/devgen-matrix.yml` runs it). The matrix pins the oldest
kernel of each interface (5.19 for `sev-guest.h`, 6.2 for `tdx-guest.h`,
6.8 for `nsm.h`), the LTS lines 6.1, 6.6, 6.12 and 6.18, the current stable
release and the latest mainline tag. A member renamed without an ABI change
is reported but is not drift: `snp_guest_request_ioctl`'s `exitinfo2` was
`fw_err` before Linux 6.4 (so in 5.19 and 6.2; 6.1.y has the new name by
backport), at the same offset and width.

To add a descriptor: add the module or op to `descriptors.toml` (the
header must be under `include/uapi`), run `--snapshot` if it needs headers
the snapshot lacks, then `--write`; write the wrapper in a hand-written
module (importing `device_write.resid` if the op writes); run
`--matrix`, and add the header's first kernel to `kernels.toml` when it
is older than every pin. Review the generated diff like any descriptor.

## Checks

Every verb is an effect, never reduced. After reduction its descriptor must
be known, and is checked:

| Code | Rule |
|---|---|
| `E0260` | descriptors, the `@descriptor` annotation, the engine, `resid_device_call` and `resid_device_secret` belong to `lib/dev/` |
| `E0261` | a dependency reaches only the descriptors its manifest's `devices = [...]` names, behavior instances it could dispatch to included; a sub-dependency without a bound gets its parent's |
| `E0262` | the descriptor is known after reduction (not chosen or computed at run time) |
| `E0263` | `_IOC_SIZE` is the struct size and the direction bits cover the fields; fields inside the struct and apart; Scalars of 1, 2, 4 or 8 bytes; pointers 8-byte aligned; buffers with a maximum; length fields are Scalars wide enough for their buffer's maximum, one per buffer; the path under `/dev/` or `/sys/` without `..`; one request number for the build's target; a descriptor marked `write = false` is not an ioctl that only sends, nor a `Transact` |
| `E0264` | a Sequence's links go forward from a Scalar output to a Scalar input of one width; only the last step has outputs; one path |

These run on the reduced program: `--profile check` does not make them.
Function names starting with `resid_` are the runtime's (`E0265`), so no
program can stand in for a device entry point.

## Provenance

The signed provenance record lists every descriptor the program holds --
reached from an entry point or not, so an imported module's descriptors are
listed even when unused -- and `residc verify` prints them:

```text
attestation: device sev_guest.snp_get_report (ioctl /dev/sev-guest, request 0xc0205300, uapi)
```

Each entry carries the descriptor's stability class: `uapi` (a kernel
userspace ABI), `abi-testing` (a sysfs ABI still marked testing) or
`out-of-tree` (a driver outside the kernel). In a debug build's graph
artifact each verb is an effect naming its descriptor,
`device.ioctl(sev_guest.snp_get_report)`, which `resid-why` and
`resid-graph` show.

## The device host

Every call runs in a fresh, isolated process: the program itself,
re-executed as `resid-device-host` with an empty environment and one
socket, every other file descriptor closed, no core dumps, no time-stamp
counter (x86-64) and no vDSO. Before it reads anything it checks who
started it: not with privilege its parent lacks (no `AT_SECURE`, no extra
capability), its socket's peer is its parent, the parent runs the same
executable and answers a random challenge, and every byte after carries the
parent's credentials. Run by hand, it exits without acting. It checks the
request again -- the same rules as `E0263`/`E0264`, and the inputs against
the fields -- opens the one path with no symbolic link on the way (`openat2`;
only magic links are refused on a sysfs attribute's path, which passes
through sysfs's own links; without `openat2`, only the last component is
checked), and refuses the wrong kind of file (a character device for
`ioctl`, `sequence` and `transact`; a regular sysfs or configfs file for
`read_attr`). The struct and each buffer get a mapping of their own between
two inaccessible guard pages, with a random canary in the slack. Then a
seccomp filter allows only the descriptor's operation on that descriptor --
`ioctl` with each step's request number, or `read` and `write` -- plus its
reply, private anonymous memory without execution, and exit; anything else
kills it.

A call has a wall-clock limit: 30 seconds, 120 for a configfs report (a
quote goes through firmware or a quoting service). A host that has not
answered by then is killed and the call is `Timeout`; the operation may
have run.

| What happens | The result |
|---|---|
| the path does not exist | `Absent` |
| the kernel refuses to open it | `Denied` |
| the driver does not know the request (`ENOTTY`, `EINVAL`), a symbolic link, the wrong kind of file, a missing configfs attribute, no Landlock | `Unsupported` |
| the kernel writes past a buffer (a canary changed, a guard page hit) | `Overrun` |
| the version field comes back different | `Version(name, the kernel's)` |
| a length beyond the descriptor's maximum | `TooLong` |
| a configfs report's generation changed, or counts a store the host did not make; its provider is not listed | `GenerationChanged`, `UnknownDriver(name, "provider ...")` |
| any other errno | `Kernel(name, errno)` |
| the host is killed or answers something that does not parse | `BadReply` |
| no answer within the wall-clock limit | `Timeout` |

None of them aborts the program. A `Sequence` runs its steps on one open
file in one host, copying each `Link` just before its step; only the last
step's outputs come back. A configfs report creates a fresh entry with an
unpredictable name the program chose, confines the host to it with
Landlock, writes `inblob` (and `privlevel`, `service_provider` when given),
reads the generation, the blobs and the provider and the generation again,
and removes the entry; the program removes it too if the host did not
(killed, timed out). The kernel counts each store to the entry in
`generation`, so both reads must equal the stores the host made: any other
writer, before the first read or between the two, is `GenerationChanged`.

A buffer marked secret never travels in the general reply: the host sends
it separately and zeroes its copy, and the runtime hands it to the engine
once, already `Secret`.
