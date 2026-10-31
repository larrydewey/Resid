# macOS — Implementation Plan (v0.6.0)

**Status: planned** (2026-10-31). The goal is macOS on Apple Silicon
(`--target macos-arm64`) and Intel (`--target macos-x86_64`): programs
compiled for both, and the compiler itself self-hosting on both, with its
fixed point. Revised after an adversarial review of the first draft
(§5).

## 0. Decisions (asked 2026-10-31)

- **Kernel access: a libSystem shim.** Apple supports only libSystem as
  the kernel interface: syscall numbers are private and change between
  releases, and static binaries are refused. On macOS the runtime calls
  libSystem. Linux stays libc-free, and its IR stays byte-identical.
- **Test hosts:** real Macs of both kinds (over ssh), plus GitHub Actions:
  an arm64 runner, and whatever Intel label GitHub still offers
  (`macos-15-intel` at the time of writing; `macos-13` is retired).
- **Scope: core first.** The compiler, the standard library, TLS, HTTP,
  pkg and attestation *verification* (pure code) run on macOS. Native
  modules, device access, display and `resid-debug` are refused for a
  macOS target at compile time with a new E0238 ("not available on target
  macos-*"). Seatbelt and Mach-port equivalents come in a later release.
- **GUI: none this release.** The `display` family is refused on macOS.

**Forced by the scope: secret mode cannot be refused.** The compiler
switches it on for every program whose reduced graph holds a secret.
That covers every TLS client and server, and the compiler itself, which
signs provenance with a `Secret` seed. So macOS gets a reduced secret
mode, documented honestly (M5), instead of a refusal.

## 1. Where Linux is wired in today

### System calls

- `resid_raw_syscall(n, ...)` with x86-64 numbers: about 70 distinct
  numbers across 16 runtime files.
- `n` is not always a literal: `sc`/`sc4` (`runtime/rt/sys.resid:6-16`)
  pass it through, and `sys_open`/`sys_stat` and friends go through
  them.
- AArch64 renumbers in lowering (`a64_nr_table`). macOS must replace the
  instruction itself.

### Linux-only calls in core paths

| Use | Calls |
|---|---|
| Fork for `process.run` | `clone(SIGCHLD)` (`sys.resid:486`, `proc.resid:70`). Every compile's clang link goes through it. |
| Threads | `clone` + `CLONE_CHILD_CLEARTID`. `thread_join` waits on the cleared word (`start.resid:265`). |
| Locks | `futex`; `ctl.resid:107` wakes 0x7fffffff waiters. |
| Polling | `ppoll` (`net.resid:355`) |
| Descriptors | `dup3`, `pipe2` |
| Directory listing | `getdents64` + the dirent64 layout (`sys.resid:268`) |
| Big-block realloc | `mremap`. On failure `c_realloc` returns 0 (`malloc.resid:354`); there is no fallback. |
| Randomness | `getrandom` |
| LSP output capture | `memfd_create` (`compiler/lsp.resid:33`; result unchecked, then `dup3`'d) |
| Thread pointer | `arch_prctl`/`resid_raw_tp_set` |
| Secret mode | `prctl`, `mlock2` |

### Linux constants written as numbers

- Open flags: `O_CLOEXEC` 524288, `O_CREAT` 64, ... (`sys.resid:20-22`).
- `fcntl` `O_NONBLOCK` 2048, which is `O_EXCL` on Darwin (`net.resid:165`).
- `SOL_SOCKET` 1, `SO_REUSEADDR` 2, `SO_ERROR` 4, `SO_RCVTIMEO`/
  `SO_SNDTIMEO` 20/21, and `SO_DOMAIN` 39 (`sock_ok` checks it,
  `net.resid:632`; Darwin has no `SO_DOMAIN`).
- `MSG_DONTWAIT` 64 (`MSG_WAITALL` on Darwin) and `MSG_NOSIGNAL` 16384
  (absent there). SIGPIPE is never ignored.
- `CLOCK_MONOTONIC` 1 (`time.resid:44`, `net.resid:220`, `chal.resid:14`).
  A failed `clock_gettime` gives -1, so deadlines never expire.
- `SIGCHLD` 17 (SIGSTOP on Darwin), errno numbers, and the `stat`,
  `termios`, `sigaction`, `sockaddr` (`sin_len`) and `dirent` layouts.

### Process start

- `resid_start` reads auxv past envp: `AT_PAGESZ`, `AT_HWCAP`/`HWCAP2`
  (the AES, SHA and RNDR gates) and `AT_SECURE` (`start.resid:27-82`). On
  Darwin those words are `apple[]` strings.
- `resid_raw_arch() == 1` selects Linux-AArch64 layouts (`tls_block`,
  `st_mode_at`), and that test would be true on macOS arm64 too.

### `/proc`

- `self/environ`, `self/cmdline`, `self/statm` (the resident check;
  unreadable means 2^62, so every over-limit check aborts) and
  `self/maps`.
- Hosts only: `self/exe`, `self/status`, Yama.

### Entry, linking, unwinding

- The compiler emits `_start`; naked assembly provides memcpy/memmove/
  memset, setjmp/longjmp and clone.
- Link: `clang ... -static-pie -nostdlib` plus libgcc, with bare `clang`
  taken from PATH, and LTO with `-fuse-ld=lld -Wl,--lto-partitions=8`
  (`driver.resid:10523-10545`).
- `@e.catch` calls `resid_setjmp` at a `returns_twice` call site
  (`codegen.resid:5193,5214`).
- Already done: `main` runs on a runtime-made thread
  (`rt_run_main`, `sys.resid:970`, stack `stack_mb()`), so the reducer's
  stack floor (E0902) is known there. No `-stack_size` link flag is
  needed.

## 2. Phases

### M0. The target word, and an OS test separate from the ISA test

- `--target macos-arm64 | macos-x86_64`: `tgt_word` values 2 and 3.
- **Two independent tests:**
  - `tgt_a64()` (the ISA) is true for 1 and 2;
  - `tgt_mac()` (the OS) is true for 2 and 3.

  Each `tgt_a64()` site in `lower.resid` is reviewed. The ISA choices
  stay (TBL, PMULL, AESE, `mov sp`); the OS choices are `svc`,
  `tp_set`, `_start`, the asm helpers and the valgrind preamble. On
  macOS, `resid_raw_syscall` never lowers to `svc` or `syscall`.
- `resid_raw_os()` (0 Linux, 1 macOS) for runtime code. Every
  `resid_raw_arch() == 1` that means "Linux AArch64" becomes an
  arch-and-OS test.
- Triple `arm64-apple-macos13` / `x86_64-apple-macos13`; LLVM adds
  Mach-O's `_` prefix.
- E0238: a macOS target refuses `@link`, `device.*`, the `display`
  verbs, and `resid-debug`.

**Gate:** x86-64 and AArch64 Linux builds are byte-identical to HEAD
(`seed.ll`, `rt.ll`, `rt-aarch64.ll`).

### M1. The OS layer: `runtime/rt/darwin.resid`

#### Dispatch

On macOS, lowering turns every `resid_raw_syscall(n, a...)` into
`call @rt_dw_syscall(n, a...)`. That one function switches on `n`: a
literal `n` folds after inlining, and a runtime one, through `sc`/`sc4`,
still works. An unknown `n` returns `-ENOSYS` (38).

#### Per call, the shim

- Translates the arguments from the Linux form:
  - open and `fcntl` flags (`O_NONBLOCK` included);
  - `mmap` flags;
  - socket levels and options (`SOL_SOCKET` 0xffff and every `SO_*`
    used);
  - `MSG_*`: `MSG_DONTWAIT` becomes 0x80; `MSG_NOSIGNAL` is dropped,
    and the socket gets `SO_NOSIGPIPE` when it is made;
  - clock ids (`CLOCK_MONOTONIC` becomes 6);
  - signal numbers;
  - `sockaddr` with `sin_len`.
- Translates results back to the Linux layout: `stat`, `termios`, and
  dirent records.
- Turns `-1` plus `*__error()` into minus the **Linux** errno number, so
  callers' errno tests are unchanged.
- Answers `getsockopt(SO_DOMAIN)` from `getsockname`'s family, so
  `sock_ok` keeps refusing non-inet sockets without changing.

The flag and constant tables are generated, not hand-written: a C probe
compiled against the macOS SDK prints the values, like
`tools/resid-devgen`, and the generated module is committed and checked.

#### Calls with no direct equivalent

| Linux call | macOS shim |
|---|---|
| `clone(SIGCHLD)` (fork for `process.run`) | `fork()`, then the child only calls `execve`/`dup2`/`close`/`_exit`, with no allocation: the same discipline as `hs_child`. `posix_spawn` would be better if `proc.resid`'s child actions map onto its file actions; decide when reading `proc.resid`. |
| `clone` for a thread | `pthread_create` on a stack the runtime mmaps (`pthread_attr_setstack`). `thread_main` stores 0 to `rec+24` and wakes it as its last act, standing in for `CLONE_CHILD_CLEARTID`. `thread_join` then calls `pthread_join` *before* `munmap` of the stack, so pthread's exit code is off the stack. |
| `clone` for a host | `-ENOSYS` (out of scope) |
| `futex` | `__ulock_wait`/`__ulock_wake` with `UL_COMPARE_AND_WAIT`. A wake of more than one waiter adds `ULF_WAKE_ALL` (0x100). These are private but stable (libc++ uses them); `os_sync_wait_on_address` is used where present (14.4+), behind the same shim. |
| `ppoll` | `poll`, with the timespec converted to ms |
| `dup3` | `dup2` + `fcntl(F_SETFD, FD_CLOEXEC)` |
| `pipe2` | `pipe` + `fcntl`. A fork in another thread can leak a descriptor between the two calls; the program spawns under its process lock, so that is safe only if every fork takes it. Check that. |
| `getdents64` | `getdirentries64`, or `readdir` on an `fdopendir` copy, converted to dirent64 records |
| `mremap` | `-ENOSYS`, **and** `c_realloc` gains the missing fallback: allocate, copy, free (used on Linux too when `mremap` fails). |
| `getrandom` | `getentropy`, in 256-byte chunks |
| `memfd_create` | `-ENOSYS`, **and** `compiler/lsp.resid` checks the result and falls back to a pipe. |
| `prctl`, `mlock2`, `seccomp`, `landlock_*`, `pidfd_*` | See M5 for the first two; the rest return `-ENOSYS`. |

#### Process facts

`resid_start` on macOS reads no auxv:

- the page size from `getpagesize()` (16 KB on arm64);
- CPU features from `sysctlbyname("hw.optional.arm.FEAT_AES")`, the SHA,
  SHA512 and RNDR equivalents, and CPUID on x86;
- `AT_SECURE` from `issetugid()`;
- argv and environ from `main`'s arguments, or `_NSGetArgv`/
  `_NSGetEnviron`;
- resident bytes from `task_info(MACH_TASK_BASIC_INFO)` (the shim returns
  bytes, not pages; an unreadable value is a reported abort, not a
  silent 2^62);
- the executable path from `_NSGetExecutablePath`.

#### Rest of M1

- **Stack overflow:** it can arrive as SIGBUS on Darwin; handle both
  signals.
- **DNS:** keep the runtime resolver over `/etc/resolv.conf`. SECURITY.md
  says scoped resolvers (VPN split DNS) are not seen.

**Gate:** `tests/runtime` (macOS cases) passes on an arm64 Mac, plus a
socket test that asserts a deadline fires, a peer reset does not kill the
process, and `sock_ok` accepts a TCP socket.

### M2. Entry, TLS, memory primitives, unwinding

- **Entry:** no `_start` and no self-relocation. dyld calls `main(argc,
  argv, envp, apple)`, which calls `resid_start` with them, minus the
  relocation and thread-pointer steps.
- **TLS:** `resid_raw_tls(name, size)` lowers to an LLVM `thread_local`
  global per name (Mach-O TLV); `tls_block` is Linux-only. Measure the
  `tlv_get_addr` cost on AWFY (M6).
- **Memory primitives:** memcpy/memmove/memset come from libSystem.
- **setjmp/longjmp:** these cannot go through a Resid wrapper, since
  `_setjmp` would save the wrapper's frame and `longjmp` would return
  into a dead one. Lowering on macOS calls `_setjmp` directly at the
  `@e.catch` call site (`returns_twice` kept) and `_longjmp` at the
  throw. The jmp_buf size differs: 37 words on arm64 and 18.5 on x86-64,
  versus the runtime's; size it per target.

### M3. The driver's link line

- **Toolchain:** Homebrew LLVM, not Apple clang (its LLVM lags, and the
  IR we emit targets current LLVM, 23 here). New in the driver: `clang`
  is resolved from `$RESID_CLANG`, else `/opt/homebrew/opt/llvm/bin`,
  else `/usr/local/opt/llvm/bin`, and never bare from PATH on macOS.
- **Link command:**
  `-target <triple> -mmacosx-version-min=13 -isysroot <SDK> -lSystem`,
  with the SDK from `xcrun --show-sdk-path` or `$RESID_MACOS_SDK`.
  - No `-static-pie -nostdlib -lgcc`. 128-bit division and `Float(128)`
    need compiler-rt's builtins (`libclang_rt.osx.a`, shipped with
    Homebrew LLVM).
  - No `--lto-partitions` (checked: ld64.lld rejects it as an unknown
    argument).
  - Apple's ld64, or ld64.lld, signs arm64 binaries ad hoc, which arm64
    macOS requires before it runs them.
  - Self-compile LTO time without partitions is measured. If it is too
    slow, try ThinLTO (`-flto=thin`) on macOS only.
- **Cross-linking from Linux** (optional, CI): ld64.lld plus an SDK copy
  (checked: without one, `library not found for -lSystem`).

### M4. Bootstrap and reproducibility

- **Runtime IR:** commit `build/boot/rt-macos-arm64.ll` and
  `rt-macos-x86_64.ll`. `boot.sh` checks them, `--bootstrap-from-self`
  regenerates them, and the pre-commit hook covers them.
- **Mac seeds are not committed** (19 MB each per reseed):
  - `tools/mac-seed.sh` on Linux lowers `compiler/driver.resid` with
    `--target macos-<arch>`;
  - `build/boot/mac-seeds.sha256` pins both seeds in the commit;
  - CI and the release attach them.
- **On a Mac,** `boot.sh --seed <file>` checks the hash, links stage1,
  then reaches a byte-identical stage2/stage3 fixed point.
- **Cross-checks** (each is a separate test, not implied by the fixed
  point):
  1. The Mac-hosted stage2 lowering `--target macos-<host arch>`
     reproduces the Linux-made mac seed byte for byte. This shows the
     seed lowered on Linux is the compiler the Mac really runs.
  2. The Mac-hosted stage2 lowering `--target x86_64` reproduces
     `seed.ll`, and `--target aarch64` reproduces the AArch64 runtime.
     A Mac is then an independent second compile of the Linux seed.
  3. Linux stage2 lowering `--target macos-<other arch>` agrees with the
     Mac-hosted one for that arch.
- **Pins:** `tools/attest/verify_pins.py` covers `runtime/rt/`, so
  `darwin.resid` and its generated constants module are included.

### M5. Secret mode on macOS: what holds and what does not

| | Guarantee | How |
|---|---|---|
| **Kept** | Freed blocks and region pages are zeroed | as on Linux |
| **Kept** | Core limit off, inherited by children | `RLIMIT_CORE` {0, 0} |
| **Kept** | Abort is exit 134, not SIGABRT | as on Linux |
| **Kept** | Pages locked | `mlock`, now with its result checked. A failed lock is recorded, and secret mode reports it once on stderr; it does not abort, because a locked-memory limit would otherwise make every TLS program fail. This applies on Linux too, where `mlock2`'s result is also ignored today (`malloc.resid:49`, `region.resid:150`). |
| **Replaced** | No debugger attach | `PR_SET_DUMPABLE` 0 becomes `ptrace(PT_DENY_ATTACH)`, which refuses a later ptrace attach. Same-user `task_for_pid` is measured on a Mac with SIP on, before SECURITY.md claims anything. |
| **Lost** | Per-mapping exclusion from dumps | No `MADV_DONTDUMP` on Darwin: the advice fails with EINVAL and the runtime ignores it. dyld's TLV memory is not a runtime mapping at all. |
| **Lost** | No crash data on disk | `RLIMIT_CORE` does not stop ReportCrash. A crash writes an `.ips` report to `~/Library/Logs/DiagnosticReports`. It holds registers and backtraces; whether it holds stack or heap bytes is to be measured. Until then SECURITY.md says a crash of a secret-mode program on macOS can leave register contents, among them key material, in a crash report. A `task_set_exception_ports` handler that `_exit`s before ReportCrash sees the crash is a possible mitigation; it is a separate item. |

SECURITY.md gets a separate macOS secret-mode row. Linux's row (line 51)
is unchanged.

Tests:

- `tests/runtime/secret_zero.c` ports as it is.
- `secret_nodump.c` gets a macOS variant without `PR_GET_DUMPABLE` and
  `/proc/self/smaps`. It checks the core limit, `PT_DENY_ATTACH` (a
  ptrace attach from a child fails) and exit 134.
- `tests/runtime/nodump/check.py` asserts no new DiagnosticReports file,
  and fails (as an expected failure, documented) until the mitigation
  lands.

### M6. Suites, CI, perf

- **Skips:** `tests/conformance/run.sh` gets a per-case skip: an
  `os = linux` header line or a `.needs` file. Then the 33 `@link` cases
  and the device/display cases are skipped on macOS. The same goes for
  the runtime, graph and ledger suites (ledger's native fee schedule).
- **On macOS:**
  - conformance, reduce, provenance, pkg, tls, http, regex, crypto,
    own (and its fuzzer) and attest (verification only);
  - lsp, once its output capture is fixed (M1).
- **ct stays Linux-only**, since there is no valgrind on arm64 macOS. A
  SECURITY.md row says the constant-time evidence is for Linux builds.
  macOS IR is the same graph lowered for another target, through a
  different clang build: not evidence.
- **CI:** `.github/workflows/macos.yml` on the arm64 and Intel runners:
  - install Homebrew llvm;
  - fetch the seed artifact from a Linux job;
  - run `boot.sh --seed`, the cross-checks, then the suites.
- **AWFY** on an arm64 Mac against AArch64 Linux on real hardware (qemu
  doesn't count). The suspects are TLV access, the libSystem calls, and
  the 16 KB page in region sizing.

### M7. Install, docs, release

- `install.sh` and `uninstall.sh` on macOS: the same `~/.resid` layout;
  the wrapper exports `RESID_CLANG`.
- The spec's targets section and E0238; an AGENTS.md macOS bullet; a
  website install page.
- SECURITY.md macOS section:
  - libSystem in the trusted base;
  - what is refused and why (no seccomp, no Landlock);
  - the M5 table;
  - the resolver note;
  - ct scope.
- v0.6.0 assets: the mac seeds and `stage2` builds for both
  architectures. They are ad-hoc signed, not notarized (that needs an
  Apple Developer account, a later decision), and the install page says
  to remove the quarantine attribute.

## 3. Risks

- **Constants missed:** any Linux number not reached through a syscall
  argument, for example a struct offset read directly. Mitigation: the
  generated constant tables, plus a grep audit of `runtime/rt/` and
  `lib/` for numeric literals next to `ld*`/`st*` of syscall buffers.
- **Page size:** 16 KB on arm64 macOS. Every mmap rounding and
  `rg_page()` must read it. The 4096 in `malloc.resid:257` is
  accounting only.
- **`__ulock_*`** are private. Fall back to `os_sync_*` where present.
- **LTO link time** without partitions.

## 4. Order of work

1. M0, the `c_realloc` fallback, the `mlock` result check, and the lsp
   memfd check: on Linux, with byte-identical seeds except for the fixes
   that change Linux behaviour on purpose (reseeded and tested).
2. The generated constants module (M1).
3. M1 and M2 on an arm64 Mac: hello world, `process.run`, threads, then
   `tests/runtime`.
4. M3, then a cross-lowered stage1 linked on the Mac, then M4's fixed
   point and cross-checks.
5. M5 with the measurements (`task_for_pid`, crash reports).
6. M6 on both runners; the Intel Mac.
7. M7 and the release.

Each phase gets an adversarial review before it is called done.

## 5. Review of the first draft (2026-10-31)

| Finding | Action |
|---|---|
| ISA and OS were mixed in one test | Split into `tgt_a64`/`tgt_mac` (M0). |
| A literal-only shim breaks the `sc` callers | One dispatch function (M1). |
| No `mremap` fallback exists | It is added (step 1). |
| `ULF_WAKE_ALL` | Added to the futex shim (M1). |
| `CLONE_CHILD_CLEARTID` emulation | Store and wake in `thread_main`, `pthread_join` before `munmap` (M1). |
| ld64.lld rejects `--lto-partitions` | Dropped on macOS (M3). |
| No `-stack_size` in ld64.lld | Not needed: `main` already runs on a runtime thread. |
| Bare `clang` from PATH; SDK; compiler-rt | Explicit lookup, `-isysroot`, `libclang_rt.osx.a` (M3). |
| Seed check is only self-consistency | Three cross-checks (M4). |
| `MADV_DONTDUMP`, ReportCrash, `PT_DENY_ATTACH` claims | Rewritten as the M5 table. |
| Unchecked `mlock` | Checked (M5, step 1). |
| Test-portability claims | Per-OS tests and a skip mechanism (M5, M6). |
| fork for `process.run` | Mapped (M1). |
| `ppoll`, `dup3`, `pipe2`, `getdents64` | Mapped (M1). |
| `MSG_*`, SIGPIPE, `fcntl`, `SOL_SOCKET`, `SO_*`, `SO_DOMAIN` | Generated tables; `sock_ok` without `SO_DOMAIN` (M1). |
| `CLOCK_MONOTONIC` | Translated (M1). |
| lsp `memfd_create` | Checked, with a pipe fallback (step 1). |
| setjmp through a wrapper | Called directly at the call site (M2). |
| auxv, `SIGCHLD`, `resid_raw_arch` | Process facts from libSystem; arch-and-OS tests (M1, M0). |
| The main thread's stack floor | Not a bug: `rt_run_main` runs `main` on a runtime thread, which sets it. |
