# Device Access — Implementation Plan (revision 1)

**Status: ACCEPTED (2026-10-09).** Open questions 1, 2 and 4 settled (§7); question 3 is decided during implementation. Depends on
PLAN-secret-type.md for descriptors that return key material.

**Progress.** Phases 1 to 4 are in: the compile-time half, then the
isolated host and all five operations, then descriptors generated from the
uapi headers with a kernel matrix (2026-10-10, below); and phase 5's
non-ioctl descriptors (tsm_report, tpm, pci_tsm; below). Phase 1, the
compile-time half, came first (2026-10-09; spec §49,
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

- **Secret slots (phase 1 TODO, resolved in phases 2 and 3 below).** A
  Buffer marked secret reached the engine inside the reply as ordinary
  bytes and was wrapped as `Secret(UInt(8))` only there. Now the host
  sends secret outputs in a separate section after the reply, the
  runtime copies them straight into secret lists and wipes the transport
  buffer, and the engine takes each with `resid_device_secret(k)`.

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

**Phases 2 and 3 (2026-10-10): the isolated host and all five
operations.** `runtime/rt/device.resid` replaces the `Unsupported` stub
(spec §49.4, `SECURITY.md` "Device access"):

- **Parent.** `resid_device_call` keeps refusing a write request (Denied);
  both entries then parse and check the request themselves (`pq_parse`,
  `pq_check`: the E0263/E0264 rules again, the inputs against the slots,
  the reply's shape and largest size). A request that fails is refused
  (error code 10, `BadInput(name, "the device host refused the request
  (n)")`) and no host starts. Otherwise `hs_spawn` (shared with native
  modules, `runtime/rt/native.resid`; `hs_quiet` and `hs_filter_install`
  are shared too) re-executes `/proc/self/exe` as `resid-device-host`
  with an empty environment and the socket as fd 3. The compiler calls
  `resid_device_host()` first in `main` of any program whose IR calls the
  device entry (`dv_hook_main`, `compiler/native.resid`). The reply is
  read up to the request's cap plus one byte and checked byte by byte
  (`dp_reply`, `dp_walk`): framing, output count and kinds, every length
  against its maximum, every number against its width, no trailing
  bytes.
- **Host.** `dh_main`: argv `["resid-device-host"]`, empty environment,
  fd 3 a socket, else return to `main`; then close every other fd, refuse
  to run set-id (uid/gid differ from euid/egid), no dump, no TSC (x86-64),
  no vDSO, OOM-first; read and re-check the request; open the one path
  with `O_NOFOLLOW|O_CLOEXEC` (`O_RDWR` for a writing ioctl and for
  Transact, else `O_RDONLY`; the flag values differ per target) and check
  the file: a character device for Ioctl/Sequence/Transact, a regular
  file on sysfs or configfs (`fstatfs` magic) for ReadAttr; choose the
  request number for `resid_raw_arch()`; put the struct and every buffer
  in its own mapping ending at a `PROT_NONE` guard page, the slack filled
  with an 8-byte random canary; set inputs, length fields (an In buffer's
  length, else its capacity), pointers and the interface version;
  allocate the reply; install the filter (`dh_lock`: arch check, no x32,
  then per-call rules: `ioctl` with `arg0 == fd` and `arg1 ==` each
  step's request, `read`/`write` with `arg0 ==` the fd, `write` on fd 3,
  `mmap` without `PROT_EXEC`, `munmap`, `exit`, `exit_group`; anything
  else `SECCOMP_RET_KILL_PROCESS`); call; check every canary (Overrun),
  the version field (`Version` with what the kernel wrote), each output
  buffer's length field against its maximum (TooLong); reply, wipe the
  secret regions and the secret section, exit.
- **Kinds.** Ioctl; Sequence (one fd, steps in order, each Link copied
  into its step's struct just before it runs, only the last step's
  outputs); Transact (write the command, one `read` of at most
  `max_response`); ReadAttr (read to EOF, at most `max + 1` bytes: more
  is TooLong); ConfigfsReport (open the root with `O_DIRECTORY`, check it
  is configfs, `mkdirat` an entry named `resid-` + 32 hex digits of
  `getrandom`, open it `O_PATH`, Landlock -- READ_FILE|WRITE_FILE beneath
  the entry, REMOVE_DIR beneath the root, every right the running ABI
  knows handled; no Landlock is `Unsupported`, fail closed -- then open
  the attributes, two files for `generation` because configfs fills an
  attribute's text at its first read; the filter allows writes to
  inblob/privlevel/service_provider, reads of the rest, `close` of each,
  and `unlinkat(root, *, AT_REMOVEDIR)`; write inblob and close it (the
  commit), privlevel and service_provider when given; read generation,
  the blobs, provider, generation again; remove the entry on every path;
  then `GenerationChanged` when the two reads differ, and a provider the
  descriptor does not list is error code 9 with the provider's printable
  text, `UnknownDriver(name, "provider X")`). `auxblob` and
  `manifestblob` are optional (a provider without them hides them); a
  missing required attribute is `Unsupported`.
- **Errors.** errno: ENOENT/ENODEV/ENXIO/ENOTDIR Absent, EACCES/EPERM
  Denied, ENOTTY/EINVAL from an ioctl Unsupported, ELOOP (a symbolic
  link) Unsupported, EFAULT (the kernel hit a guard page) Overrun, any
  other `Kernel(errno)`. A host killed by SIGSEGV/SIGBUS is Overrun (its
  buffers end at guard pages); any other signal, a bad exit status, no
  sandbox (exit 126), no host, or a malformed reply is error code 11,
  `BadReply(name, ...)` naming which.
- **Secret outputs.** The host's reply carries a secret output as tag 2 +
  length; the bytes follow all outputs in a separate section. The parent
  copies them into `List(UInt(8))` values (a `List(Secret(UInt(8)))`:
  secrets are erased after checking) held per thread, zeroes the boxes
  and the transport mapping, and the engine takes each once with the new
  builtin `resid_device_secret(k)` (family `device`, E0260 outside
  lib/dev/), checking its length against the reply. The host zeroes its
  secret regions and section before it exits.

As built, compared with §3-§5:

- **Law 12 (§4).** The plan said a malformed reply aborts like a native
  host failure. It is `Err(BadReply)` instead: a device is probed (§3,
  "a missing device is a value"), and a host that dies or answers
  garbage is the device misbehaving, which the program must be able to
  handle as it handles an absent one. Native modules still abort.
- **Self-test modes.** The fault paths (seccomp kill, canary, guard
  page, killed host, malformed and oversized replies, the configfs flow,
  no Landlock) need faults no real device gives on demand. The host has
  numbered self-test modes reachable only through
  `resid_device_host_test`, an entry no Resid program can name (the
  compiler declares only `resid_device_host`); the configfs flow runs
  against a fake configfs root made by `tests/runtime/device_host.c`.
  The real `/sys/kernel/config/tsm/report` is tested only for absence.
- **Request numbers above 2^32**, an `_IOC_NONE` ioctl's integer
  argument and secret inputs are not supported: every ioctl argument is
  the struct's address, and inputs are public (`DevIn`).
- **Not built.** The device suites run on x86-64; under qemu-user
  (`RESID_TARGET=aarch64`) seccomp is unavailable and device runs that
  reach the filter fail closed. (The wall-clock limit and the `AT_SECURE`
  check this list used to name came with the second review, below.)

Tests: `tests/device` (runs real devices any user can open: `/dev/ptmx`
TIOCGPTN/TIOCSPTLCK and a Sequence with a Link, a resized TIOCGPTN
(ENOTTY, Unsupported), `/dev/zero` and `/dev/null` as Transact devices,
a secret Transact, sysfs attributes, a DRM render node's
DRM_IOCTL_VERSION with three buffers behind pointers -- skipped where
there is none -- for `device_no_address_leak`, `device_version_mismatch`
and `device_reply_length_drm`, plus `device_absent_is_err`,
`device_stateless`, `device_reply_length_checked`);
`tests/runtime/device_host.c` (seccomp kill, `device_overrun_canary`,
`device_overrun_guard_page` by a kernel read and by a fault,
`device_host_killed`, malformed and oversized replies, secret delivery
and the host's wipe, the configfs flow, `configfs_unknown_provider_err`,
`configfs_missing_attr_err`, generation change, no Landlock, no fd left
in the parent, the parent's own refusals); conformance
`err_device_secret_raw`.

**Security review 2 (2026-10-10), fixed:**

- **A host started by hand.** Both hosts (device and native module) now
  authenticate before reading a request (`hs_auth`, `runtime/rt/native.resid`):
  no `AT_SECURE` (read in `resid_start`'s auxv walk, else from
  `/proc/self/auxv`), no effective or permitted capability the parent lacks,
  fd 3's `SO_PEERCRED` is the parent with our uid and gid, the parent runs
  the same executable (`/proc/self/exe` and `/proc/<ppid>/exe` by device
  and inode), and the parent sends back 16 random bytes the host sends
  (`hs_answer`); every later read checks `SCM_CREDENTIALS`. Refused: exit
  124. Deviations from the review: capabilities are compared with the
  parent's rather than refused outright -- on SNP/TDX guests
  `/dev/sev-guest` and the configfs report are root's, and a program run as
  root must keep working; and the token goes host to parent, not parent to
  host -- a token chosen by the parent cannot be checked by a freshly
  executed host, and the challenge plus per-read credentials defeat a
  pre-written request with an exec or a passed socket. The native host now
  also closes every fd but 3 and reads its whole request before its filter.
- **The device-host hook** matches `@resid_device_call(` /
  `@resid_device_call_w(` exactly, and function names starting `resid_` are
  reserved (E0265, prelude and `runtime/rt/` exempt); the checker's family
  result is not used, since the hook is decided on the IR after lowering.
- **Wall-clock limit.** 30 s per call, 120 s for a ConfigfsReport (no
  descriptor field: a per-kind default, which a C harness can only lower).
  Every wait polls the socket against the deadline; then SIGKILL, a 2 s
  bounded reap (pidfd, else WNOHANG naps), and a host still not dead is
  left for a later call to reap (`hs_reap_pending`). `DeviceError` gains
  `Timeout(name)` (reply code 12). Native modules get the same at 120 s,
  though their host can block only if stopped (it makes no blocking call
  but on its socket, which the parent half-closes).
- **Transact is a write** (E0263, `pq_check` 19).
- **ConfigfsReport generation**: both reads must equal the stores the host
  made (inblob once when committed, each `write(2)` to privlevel and
  service_provider), as the kernel's `write_generation` counts them from 0;
  the fake configfs models it (`dh_fake_bump`, a `pwrite64` the filter
  allows only on the fake's own generation file).
- **The entry's name comes from the parent**, which removes that one name
  under the root (opened without links, checked configfs) after every
  report call, so a killed or timed-out host leaks nothing.
- **SIGCHLD**: an inherited `SIG_IGN` is reset to the default in
  `resid_start` and again in `hs_spawn` (a C harness); `wait_pid` already
  retried EINTR (`sc4`). A host whose status is lost anyway is a distinct
  `BadReply` (detail 6), or its reply when that arrived whole and checks out.
- **Secret hygiene**: the parent's request copy is wiped before it is
  freed, `dp_list` wipes its staging slots (bytes are immediate boxes, so
  there are no heap boxes to wipe), and secrets the engine did not take are
  wiped when the next call clears the slots (not freed: they may live in a
  region).
- **Hardening**: `mmap` only with flags exactly `MAP_PRIVATE|MAP_ANONYMOUS`,
  fd -1 and no `PROT_EXEC`; no `munmap` after the filter; a guard page
  before each region as well as after; length fields at least as wide as
  their buffer's maximum and not shared (E0263, `pq_check` 42); `openat2`
  with `RESOLVE_NO_SYMLINKS|RESOLVE_NO_MAGICLINKS` for `/dev/` paths and the
  configfs root (and `RESOLVE_BENEATH` inside the entry), only
  `RESOLVE_NO_MAGICLINKS` for sysfs attributes (sysfs class paths are
  symlinks), falling back to `openat` + `O_NOFOLLOW` where `openat2` is
  missing (ENOSYS).
- **Tests independent of the host**: the conformance device cases and
  `tests/pkg`'s `pkg_device_ceiling` print `reached` for any answer the
  device gives (absent here, a report or a refusal on an SNP guest), and
  `configfs_absent` uses a report root that exists nowhere.

Tests: `tests/runtime/device_host.c` (`device_host_by_hand_other_exe`,
`device_host_by_hand_no_answer`, `device_host_at_secure`,
`device_host_capability`, `device_timeout`, `configfs_timeout_entry_removed`,
`configfs_killed_entry_removed`, `configfs_generation_foreign_write`,
`configfs_root_symlink_refused`, `device_sigchld_ignored`,
`device_overrun_guard_page_before`, `device_seccomp_mmap_shared`,
`device_seccomp_munmap`, `device_transact_read_refused`,
`device_length_field_narrow_refused`, `device_length_field_shared_refused`,
`device_request_wiped`), `tests/runtime/run.sh` (native host by hand),
`tests/device` (`e0263_transact_read`, `e0263_length_narrow`,
`e0263_length_shared`, `device_hook_exact`), conformance
`err_reserved_runtime_name`.

**Phase 4 (2026-10-10): generated descriptors and the kernel matrix.**
`tools/resid-devgen` (§6.1, §6.2; `SECURITY.md` "Device access"):

- **Input.** `tools/devgen/descriptors.toml` lists each generated module
  (`lib/dev/uapi_<name>.resid`), its uapi header and first kernel, and per
  op the request macro, the struct, the path, the reviewed `write` label,
  the stability class, the version field and each field's member and role
  (Scalar/Inline/Buffer, direction, `max` as a C expression, `length` link,
  `secret`, `also`: older member names with the same ABI); plus `layout`
  structs and `const` macros the wrappers need, and `check` requests kept
  under the matrix without a descriptor. `tools/devgen/kernels.toml` pins
  the generation tree and the matrix, each a tag *and* its commit.
- **Numbers from the compiler.** A C probe (`__builtin_offsetof`, `sizeof`,
  the header's own `_IOWR(...)`) is compiled by clang with
  `--target x86_64-linux-gnu` / `aarch64-linux-gnu`, `-nostdinc`, to LLVM
  IR; the probe array's constant initializer is read back. Nothing runs,
  so both targets are probed anywhere; no hand arithmetic, and the
  hand-written `dv_iowr` calls are gone from the uapi descriptors. Kernel
  source trees get what `headers_install` would add: asm-generic shims
  for the arch's generic-y headers, empty `linux/compiler*.h`,
  `__EXPORTED_HEADERS__`. Chosen over `-fdump-record-layouts` (no request
  numbers, text meant for humans) and over running a probe (no AArch64
  execution here).
- **Language.** Python 3 (tomllib) under `tools/`, like `gen_nistp.py`:
  a build-time generator outside every program's trusted base, whose
  output is committed, reviewed and re-verified; its work is driving clang
  and git and comparing text. No new dependency.
- **Output.** Each `uapi_*.resid` is headed GENERATED with the header, the
  kernel tag and commit, the input module and a layout fingerprint
  (SHA-256 of every probed fact on both targets), then each IoctlOp with
  its layout as a comment table, `<struct>_size()` / `_<member>_at()` /
  `_len()` and constants. Hand-written wrappers sit beside it:
  `sev_guest.resid` (`snp_get_report`, now also checking `exitinfo2`),
  `sev_guest_key.resid` (`snp_get_derived_key`, unchanged API),
  `tdx_guest.resid` (`tdx_get_report0`), `nsm.resid` (`nsm_request`, a
  write: a raw request can extend or lock a PCR). Each says whether its
  data is hardware-signed (§6.2's last row).
- **Modes.** `--write`; `--check` (regenerate in memory from the committed
  snapshot `tools/devgen/uapi/`, every header clang read, with a SHA-256
  manifest; compare byte for byte; offline); `--local [DIR]` (installed
  headers or a kernel tree); `--matrix` (sparse, shallow, blob-filtered
  checkouts of `include/uapi` and the two arch uapi trees per pin, from a
  GitHub mirror of the stable tree, cached in the gitignored
  `tools/devgen/cache/`, refused unless HEAD is the pinned commit);
  `--snapshot`. `tools/devgen-matrix.sh` is the release job;
  `.github/workflows/devgen-matrix.yml` runs it on tags, on changes to
  the generator or the generated files, and weekly.
- **Pins.** Generation: v7.2.9. Matrix: v5.19.17 (sev-guest.h's first),
  v6.1.189, v6.2.16 (tdx-guest.h's first), v6.6.158, v6.8.12 (nsm.h's
  first), v6.12.112, v6.18.55, v7.2.9, v7.3-rc6. Result: no ABI drift in
  any interface on either target. Two API changes it reported: the
  `exitinfo2` union of `struct snp_guest_request_ioctl` (Linux 6.4,
  backported to 6.1.y) was `__u64 fw_err` in 5.19 and 6.2, at the same
  offset and width, so `also = ["fw_err"]`; and `SNP_REPORT_USER_DATA_SIZE`
  is missing from 6.6 and older, so the wrapper takes the 64 from the
  member's size instead of the macro.

As built, compared with the plan:

- **SNP_GET_EXT_REPORT: Nested and Errno fields.** Its certificate
  buffer is a pointer *inside* the request buffer (`struct
  snp_ext_report_req`'s `certs_address`, `certs_len`). Two field kinds
  were added (lib/dev/device.resid, E0263 in `compiler/device.resid`,
  `pq_check` and the host in `runtime/rt/device.resid`, wire tags 3 and 4):
  `Nested(parent, offset, length_at, length_width, max, dir, secret)` -- a
  buffer whose pointer and length are inside an earlier In or InOut
  Buffer; the host gives it its own guarded region, patches its address
  into the parent and zeroes it again in the parent's output; its length
  is its input's (In) or what the program wrote at `length_at` in the
  parent, at most `max` (else BadInput), so a wrapper sizes it; no deeper
  nesting -- and `Errno`, an explicit opt-in that makes a failed ioctl
  reply with its outputs and the errno (ENOTTY stays Unsupported, EFAULT
  Overrun; not in a Sequence). The kernel's length negotiation (a
  too-small `certs_len` gives EIO, `exitinfo2`'s VMM half
  SNP_GUEST_VMM_ERR_INVALID_LEN, and the needed length written back into
  the request struct) is `lib/dev/sev_guest_ext.resid`'s
  `snp_get_ext_report`: two pages first, one retry with the needed length
  when it is larger, whole 4 KiB pages and at most 16 KiB (the kernel's
  SEV_FW_BLOB_MAX_SIZE, the descriptor's maximum), else TooLong or
  BadReply (`sg_ext_need`). The descriptor is generated
  (`uapi_sev_guest_ext.resid`, its own module so the provenance records of
  programs importing `sev_guest.resid` are unchanged) and matrix-checked.
- **Hex literals (fixed).** The reducer did not read `0x` / `0b` / `0o`
  integer literals (`sem_lit` took only decimal text), so code over them
  never folded, and a descriptor written in hex stayed unknown (E0262).
  `sem_lit_dec` reads them by value. The generator still emits decimal
  (hex in the comment), since seeds before this one do not fold hex.

- **Review fixes (2026-10-10).** The matrix's fetch cache is used only
  when the checkout is the pinned commit *and* clean (`git status
  --porcelain --ignored --untracked-files=all` empty), else fetched again;
  the probe array is read with a line-anchored match and its name is
  `#undef`d after the header, so neither a header's top-level `asm` nor a
  macro can supply the values; every input string that reaches the output
  is validated (identifiers for names, shapes for paths, headers, tags and
  commits, no control character, quote or backslash anywhere). The input
  list, kernel list and cache can be pointed elsewhere
  (`RESID_DEVGEN_INPUT`, `_KERNELS`, `_CACHE`) for the tests:
  `devgen_probe_anchor`, `devgen_input_escaping`, `devgen_cache_dirty` (a
  local repository as the mirror).

Tests: `tests/devgen/run.sh` (18: `devgen_check`,
`devgen_matches_uapi_{sev_guest,sev_guest_ext,sev_guest_key,tdx_guest,nsm}`,
`devgen_matches_uapi_host` against `/usr/include`, `devgen_byte_stable`,
`devgen_stale_file`, `devgen_snapshot_tamper`, `devgen_drift_layout`,
`devgen_drift_request`, `devgen_drift_rename_only`,
`devgen_probe_anchor`, `devgen_input_escaping`, `devgen_cache_dirty`,
`devgen_request_numbers` -- the descriptors' numbers against clang's
evaluation of the kernel's `_IOWR` for both targets, independently of the
generator -- and `devgen_aarch64_descriptors`); `tests/device`
(`devgen_check`, `e0263_nested_parent_out`, `e0263_nested_no_parent`,
`e0263_nested_unaligned`, `e0263_nested_outside`,
`e0263_nested_length_narrow`, `e0263_nested_length_overlap`,
`e0263_nested_siblings`, `e0263_errno_twice`, `e0264_errno`,
`device_errno` -- TIOCSIG's real EINVAL as an output --
`device_hex_descriptor`); `tests/runtime/device_host.c`
(`device_nested_placed`, `device_nested_pointer_never_leaks`,
`device_nested_overrun_canary`, `device_nested_overrun_guard_page`,
`device_nested_length_refused`, `device_nested_out_parent_refused`,
`device_errno_outputs`, `device_errno_opt_in`,
`device_errno_enotty_unsupported`; self-test modes 23-26 play a kernel
that follows Nested pointers, since no device any user can open has
one); `tests/reduce` (`hex_literals`); conformance `device_uapi_wrappers`,
`device_ext_negotiation`.

**Phase 5, the non-ioctl descriptors (2026-10-10).** Library code only:
no compiler or runtime change. Checked against Linux 7.3-rc6 (torvalds
3857c2fe5449), pinned with every fact used in
`tests/device/kernel-pin.txt`.

- **`lib/dev/tsm_report.resid`**: one ConfigfsReport, `tsm_report.report`
  (`/sys/kernel/config/tsm/report`, providers `sev_guest`, `tdx_guest`,
  `arm_cca_guest` -- the drivers' KBUILD_MODNAME, so `arm_cca_guest`, not
  `arm-cca-guest`; inblob 64, outblob 128 KiB (TDX's GET_QUOTE_BUF_SIZE),
  auxblob 16 KiB (SEV_FW_BLOB_MAX_SIZE), manifestblob 64 KiB, `write =
  false`: a report is a read, §1). One descriptor rather than one per
  platform: the provider check already fails closed, and the provider
  says which format outblob is. `tsm_report_get(report_data, opts)` ->
  `TsmReport {provider, platform, outblob, auxblob, manifestblob,
  generation}`; `tsm_opts`, `tsm_opts_vmpl(n)`, `tsm_opts_svsm()`;
  `tsm_platform`, `tsm_platform_text`, `tsm_outblob_text`;
  `tsm_report_decode` (the engine's outputs, checked again);
  `tsm_report_honoured` refuses a report from a provider other than
  `sev_guest` asked for a VMPL or an SVSM (CCA has no visibility hooks,
  so it shows privlevel and service_provider and ignores them); and
  `tsm_snp_certs`, a total parser of the SNP certificate table in
  auxblob, with the GUIDs of the ARK, ASK, VCEK, VLEK and CRL (RFC 4122
  byte order, as virtee/sev and go-sev-guest lay the table out; sources in
  the module). `tsm_opts_svsm_service(guid, version)` asks an SVSM for
  one service's report in one manifest version (engine change, below).
- **`lib/dev/tpm.resid`** (Transact `tpm.tpmrm0` on `/dev/tpmrm0`, 4096
  bytes each way = TPM_BUFSIZE, `write = true`) and
  **`lib/dev/tpm_wire.resid`** (pure encoders and total decoders: TPM2_
  GetCapability, GetRandom, PCR_Read, ReadPublic, NV_ReadPublic, NV_Read,
  Quote with an existing key and a password session; TPMS_ATTEST of a
  quote; the known NV indices and handles with sources: TCG EK
  certificates, GCE AK certificates and templates (go-tpm-tools), Azure's
  HCL report 0x01400001, AK certificate 0x01C101D0 and AK 0x81000003
  (Azure/confidential-computing-cvm-guest-attestation); no AWS NitroTPM
  index is documented, so none is named). CreatePrimary/Create/Load are
  out. **Authority**: every TPM wrapper needs the full `device` grant.
  A read-only TPM descriptor is not possible here, and should not be
  added: E0263 refuses a Transact marked `write = false`, rightly -- the
  kernel passes any command through the one `write(2)`, so only a host
  that parsed TPM commands could keep a "read" descriptor to reads, and
  that is per-device code the generic host does not have (§0). Instead
  the descriptor is private to `tpm.resid` (not `pub`), so the TPM's
  reachable surface is the typed wrappers, none of which sends a command
  meant to change TPM state; `devices = ["tpm"]` bounds a dependency to
  them. Not tested live: no TPM this user can open in the test setup.
- **`lib/dev/pci_tsm.resid`**: the mainline PCI TSM sysfs ABI is
  `/sys/class/tsm/tsmN`, and per device `tsm/connect` (RW), `tsm/
  disconnect` (WO), `tsm/dsm`, `tsm/bound`, `authenticated` (RO), plus the
  host bridge's `available_secure_streams` and `streamH.R.E`
  (sysfs-bus-pci, sysfs-class-tsm, sysfs-devices-pci-host-bridge; there
  is no `sysfs-bus-pci-devices-tsm`). No measurement, certificate or
  TDI-report attribute exists yet. The one fixed path is a ReadAttr,
  `pci_tsm.tsm0` (`/sys/class/tsm/tsm0/uevent`, AbiTesting), behind
  `pci_tsm_present()`; `pci_tsm_name` parses the "tsmN\n" / "\n" text of
  connect and bound for when they are reachable.
- **Path parameterization (pci_tsm), a proposal, not built.** The
  per-device attributes sit under a PCI address, which is run-time data;
  a descriptor's path is known at compile time (E0262) and the engine has
  no run-time path component, so they are unreachable today. A fixed set
  of addresses cannot work (they differ per machine). The narrowest safe
  change is a new kind, not a looser ReadAttr:
  `@descriptor(pci_attr) type PciAttr = { Str name; Str rel; Int max;
  Stability stability; }` with the verb
  `device.read_pci_attr(PciAttr, PciAddr)`, where `rel` is a fixed path
  under the device's directory (`tsm/connect`), known and checked at
  compile time (E0263: relative, `[a-z0-9_]` components, no `..`, at most
  two components), and the address is a typed record,
  `PciAddr = { Int domain; Int bus; Int device; Int function; }` (domain
  0..0xffffffff -- the ABI allows more than 16 bits for emulated host
  bridges --, bus 0..255, device 0..31, function 0..7), never a string, so
  no path text comes from the program. The engine and the host each
  check the ranges and format it (`%04x:%02x:%02x.%x`); the host reads the
  link `/sys/bus/pci/devices/<addr>` with `readlinkat` before its filter,
  requires the target to be `../../../devices/pci<dom>:<bus>/` followed by
  address components only (`[0-9a-f:.]`, no `..`), and opens
  `/sys/devices/...` + `rel` with `RESOLVE_NO_SYMLINKS|
  RESOLVE_NO_MAGICLINKS` -- the existing checks (a regular sysfs file, at
  most `max`) then apply unchanged. It is a read (device(readonly)); the
  provenance record lists the descriptor and `rel` (the address is data,
  like an ioctl input); manifest bounds work by name as today. Writes
  (`tsm/connect`, `tsm/disconnect`) would be a separate, writing kind, and
  are a host-administration act an attester does not need.
- **nvidia_rm, not built (design note for a later phase).** Hopper's
  attestation is RM control calls on `/dev/nvidiactl`, a Sequence per
  §6.1, generated by `tools/resid-devgen` from `open-gpu-kernel-modules`
  pinned to a release tag (recorded with the generator's input list).
  Checked at tag 615.78.08 (NVIDIA/open-gpu-kernel-modules 1a82fbfd,
  2026-10-07), the input list is:
  - Request numbers: `_IOWR('F', esc, sizeof(params))` -- the driver
    takes `_IOC_NR` and `_IOC_SIZE` of the request (`kernel-open/nvidia/
    nv.c`, `nvidia_ioctl`) -- with `NV_IOCTL_MAGIC 'F'` and `NV_ESC_*` of
    `kernel-open/common/inc/nv-ioctl-numbers.h` (`NV_IOCTL_BASE` 200:
    `NV_ESC_REGISTER_FD` 201, `NV_ESC_CHECK_VERSION_STR` 210,
    `NV_ESC_ATTACH_GPUS_TO_FD` 212), and the RM escapes of
    `src/nvidia/arch/nvalloc/unix/include/nv_escape.h`
    (`NV_ESC_RM_FREE` 0x29, `NV_ESC_RM_CONTROL` 0x2A, `NV_ESC_RM_ALLOC`
    0x2B).
  - Argument structs (`src/common/sdk/nvidia/inc/nvos.h`):
    `NVOS21_PARAMETERS` or `NVOS64_PARAMETERS` for alloc (the driver
    tells them apart by the ioctl's size, `src/nvidia/arch/nvalloc/unix/
    src/escape.c`, so each is its own request number), `NVOS54_PARAMETERS`
    for control (`hClient`, `hObject`, `cmd`, `flags`, `params` pointer,
    `paramsSize`, `status`), `NVOS00_PARAMETERS` for free. Each carries a
    pointer to a parameters struct and its size (a Buffer with a length
    field), and an RM `status` word out (checked like SNP's exitinfo2).
  - Classes: `NV01_ROOT` 0x0 (`class/cl0000.h`, the client),
    `NV01_DEVICE_0` 0x80 (`cl0080.h`), `NV20_SUBDEVICE_0` 0x2080
    (`cl2080.h`), `NV_CONFIDENTIAL_COMPUTE` 0xcb33 (`clcb33.h`), each with
    its alloc parameters struct.
  - Controls (`ctrl/ctrlcb33.h`): `NV_CONF_COMPUTE_CTRL_CMD_GET_GPU_CERTIFICATE`
    0xcb330109 (cert chain up to 0x1000 bytes, attestation cert chain up
    to 0x1400) and `NV_CONF_COMPUTE_CTRL_CMD_GET_GPU_ATTESTATION_REPORT`
    0xcb33010a (a 0x20-byte nonce in; the report up to 0x2000 bytes and
    the CEC report up to 0x1000 out).
  - The Sequence: the version check (`NV_ESC_CHECK_VERSION_STR`, control
    device only), alloc the root client (its handle out), the device and
    subdevice under it, the CC object, then the control call; Links carry
    each new handle into later steps' parent fields; closing the fd frees
    the objects. The wrapper first reads `/sys/module/nvidia/version` (a
    ReadAttr), maps it to a layout fingerprint and answers
    `UnknownDriver` when no generated descriptor covers it. The evidence
    (SPDM measurements, the certificate chain) is DMTF-defined and signed
    by the GPU, so its parser does not depend on the driver.
  - Open engine questions: the version check's argument is a string
    struct the generator must lay out; and if the RM needs a per-GPU fd
    (`/dev/nvidiaN`) registered on the control fd (`NV_ESC_REGISTER_FD`),
    that is two files, outside a one-path Sequence.

**Phase 5, follow-up (2026-10-10).**

- **SVSM service options** (engine and runtime): `ReportReq` gains
  `service_guid` (36 characters, "" for none) and
  `service_manifest_version` (a u32, -1 for none); the request carries
  them after `service_provider`; the parent and the host refuse a
  malformed GUID, a version past a u32, or either without a service
  provider (`pq_report_err` 24, `BadInput`); the host opens and writes
  `service_guid` and `service_manifest_version` like the other written
  attributes (Landlock, the filter's write rule per fd), and counts each
  `write(2)` as a store. That is the kernel's rule for both
  (`drivers/virt/coco/guest/report.c`: every `*_store` calls
  `try_advance_write_generation`; `service_guid`'s before it parses the
  text, `service_manifest_version`'s after), and the values are checked
  beforehand, so a store that fails ends the call before the generation
  is compared. Tests in `tests/runtime/device_host.c`:
  `configfs_report_service_guid` (generation 4: inblob, service_provider,
  service_guid, service_manifest_version), `configfs_service_written`
  (self-test 28 hard-links the two attributes to files under the fake
  root, so the harness reads what the host wrote: the GUID's 36
  characters and "3\n"), `configfs_service_guid_missing_attr` (self-test
  27: a provider without them is `Unsupported`),
  `configfs_service_options_refused`. `rt.ll` and `rt-aarch64.ll` are
  regenerated with the committed stage2 (which first reproduced the
  committed files byte for byte); no compiler change.
- **The TPM, live, against a simulator.** `tpm_wire.resid` now holds the
  wrappers' logic over any transport (`tpm_*_via(send, ...)`, `send` a
  closure from a command's bytes to the response's); `tpm.resid`'s
  wrappers are those over `/dev/tpmrm0`. `tests/device/run.sh`'s
  `tpm_simulator` case (skipped unless `RESID_TPM_SIMULATOR` names it;
  `tests/device/tpm-sim/build.sh` builds the IBM TPM 2.0 simulator,
  kgoldman/ibmswtpm2 e1df46e4, without root) runs them over the
  simulator's TCP port: GetRandom, GetCapability, PCR_Read, a primary
  ECC P-256 AK made with a raw CreatePrimary, ReadPublic, Quote -- the
  ECDSA signature over `attest` verified with lib/ecdsa.resid against
  the AK's public point, the PCR digest against PCR_Read's values, the
  nonce in extraData -- and NV_DefineSpace/NV_Write raw, then
  NV_ReadPublic and a chunked NV_Read of 2000 bytes (TPM_PT_NV_BUFFER_MAX
  1024) by owner and by index auth, and TPM errors for a missing key and
  index. The simulator speaks TCP, not a character device, so the device
  host's Transact itself is not exercised against a TPM (no root here for
  CUSE or the `tss` group); no binary gains a non-device path to a TPM.
- **Review fixes: the TPM's lockout and secret NV data.** The command
  builders lost their password parameter (a password is a secret, and a
  command carrying one would need a secret command buffer; only the empty
  password is ever sent). NV_Read reads NV_ReadPublic first and refuses an
  index authorized by its own authValue (TPMA_NV_AUTHREAD) without
  TPMA_NV_NO_DA, and any authorizing handle but the owner, the platform
  or the index (`tpm_nv_read_da_ok`); Quote reads the key's public area
  and refuses a key without noDA whose userWithAuth is clear or that has
  an authPolicy (`tpm_quote_key_ok`). Checked against the reference
  implementation (ibmswtpm2 e1df46e4, SessionProcess.c `IsDAExempted`,
  `IncrementLockout`: permanent handles but TPM_RH_LOCKOUT are exempt, an
  index with NO_DA and an object with noDA are) and go-tpm's bit values.
  What no public area shows -- whether the authValue is empty -- stays a
  residual for a userWithAuth key without noDA or policy (SECURITY.md).
  `tpm_nv_read_secret` reads through a second private Transact,
  `tpm.tpmrm0_secret`, whose output is secret, and declassifies only the
  response's structure (`tpm2_nv_read_resp_secret`). Tests: conformance
  `device_tpm_wire` (every DA rule; the secret decoder agrees with the
  public one on every prefix and mutant), the simulator case (a
  DA-protected index with a password and two keys refused with
  TPM_PT_LOCKOUT_COUNTER still 0, the withheld raw NV_Read then counting
  1; a secret read of 64 bytes), `tests/ct` (`dev-tpm-nv-resp-secret`,
  `dev-tpm-nv-read-secret`).
- **Sources checked.** SNP certificate-table GUIDs and byte order:
  virtee/sev a966d06d and google/go-sev-guest 9c5dffcd (AMD's GHCB PDF,
  56421, could not be retrieved from amd.com); the earlier guid_t
  (mixed-endian) reading was wrong and is fixed, with the CRL GUID added.
  CCA token size: TF-RMM 2e198822 (`RMM_CCA_TOKEN_BUFFER` pages, default
  1). nvidia_rm: the note above, at tag 615.78.08.

Tests: conformance `device_tsm_report` (input checks, decoding, the
provider map, VMPL/SVSM honoured only by SNP, the certificate table with
every prefix and corruption), `device_tpm_wire` (commands against
tpm2-tss's GetCapability vector and go-tpm v0.9.8's encodings --
`tests/device/tpm-vectors/` regenerates them --, responses go-tpm decodes
to the same values, a TPM error, wrong session tag, absurd counts, and
every response truncated (as read and size-patched) and with every byte
set to 0xff and 0x00), `device_tpm_ok` and `device_pci_tsm` (reached on
any host), `err_device_tpm_readonly` (E0219), `err_device_tpm_raw` (the
private descriptor). The configfs flow itself stays on the fake configfs
of `tests/runtime/device_host.c`; the wrapper's part past the engine is
`tsm_report_decode`, tested directly.

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
| A layout change behind the same request number | Linux's userspace-ABI rule forbids it for `include/uapi` interfaces. Descriptors are **generated from the uapi headers**, not written by hand (`tools/resid-devgen`, the same generator as §6.1), and a conformance job compiles the headers of every supported kernel and compares `sizeof`/`offsetof` with each descriptor. Drift fails the build before release | `resid-devgen --check` (built, phase 4), CI kernel matrix (`tools/devgen-matrix.sh`) | `devgen_matches_uapi_*` (`tests/devgen`) |
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
