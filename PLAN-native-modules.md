# Native Modules — Implementation Plan (revision 2)

**Status: DONE (2026-10-06).** Revision 1 was reviewed and rejected. Its
process boundary limited crashes but not authority. Its own example was
refused by the manifest check. Its thunk and native symbol shared one name.
Its root-grant change (A2) contradicted spec §21.1. This revision replaces
it, and is what shipped (PROGRESS §0zv).

As built, compared with the text below:
- Two more manifest defects turned up and were fixed in stage 1. A
  dependency's own dependencies are now bounded by its ceiling, and a
  dependency declared twice gets the meet of every declaration (and every
  pinned key is checked). Before, the first declaration reached won.
- The LSP needed no change: it has no family list, and its diagnostics
  come from the checker.
- Package archives include every `.ll` file rather than only the paths
  named under `[native]`, so a pinned-key signature covers them too.
- The test for a forged reply writes to the host's socket itself. The
  thunk can never produce an out-of-range value, so that is the only way
  to exercise the parent's checks.

**Goal**: let a Resid program call code written in another language (C,
assembly, anything that compiles to LLVM IR) without weakening any law of
`resid_specification.txt` or any row of `SECURITY.md`.

**What "guaranteed" means here.** Every claim below names the code that
enforces it and the test that fails if it breaks, as `SECURITY.md` does. The
threat model is `SECURITY.md`'s, unchanged: kernel bugs, side channels,
denial of service and an attacker who can write the build tree are out of
scope. Within that model the native code gets no OS authority at all. The
kernel enforces this, not a scan of the code.

---

## 0. Design in one paragraph

A native module is a **provider** (Law 8: authorized external knowledge
enters through providers). A call to it is an **effect** (Law 9), so it is
never reduced at compile time (Law 10). It is authorized by the
capability family `native_<module>` (Law 14, §20). Each call runs the native
code in a **fresh child process**: the program's own executable, re-executed
from `/proc/self/exe` with an empty environment. Before any native
instruction runs, that child closes every descriptor but its one socket,
unmaps the vDSO, disables the time-stamp counter and installs a seccomp
filter. The filter lets it read and write that socket, manage non-executable
memory and exit — nothing else. The parent sends the arguments as bytes, reads
the result as bytes, **validates the result as untrusted input**, and the
child exits. Native code therefore holds no capability, sees none of the
parent's memory, keeps no state between calls (no hidden identity, §38), and
can only answer the question it was asked.

## 1. Spec conformance matrix

| Spec rule | How the design meets it | Enforced by | Test |
|---|---|---|---|
| Law 2, 5: reduce all provable computation; compile time never depends on residual information | The compiler never executes an artifact. A `@link` function has no body for the reducer (`fbody = -1`), so every call stays residual | `gx_collect` (`greduce.resid`) | `native_never_folded` |
| Law 8: external knowledge enters through providers | A native call is a provider read. The parent stub is the only route to it | `lw_link` (`lower.resid`) | `native_ok` |
| Law 9, 10: acquisition is an effect; effects decide reducibility | The graph artifact marks each call `effect`, with effect name `native_<m>.<fn>` | `ga_effect` (`gart.resid`) | `native_graph_effect` (graph suite) |
| Law 11: external information has provenance | The provenance record gains `native: {module: sha256}`, and the archive hash covers the artifact | `prov_payload`, `resid-pkg pack` | `native_in_provenance`, `native_artifact_in_archive` |
| Law 12, §9: runtime uncertainty is explicit; force failure aborts, or is `Err(RegionError)` inside `spawn` | Any host failure (signal, nonzero exit, short or malformed reply, invalid value) aborts the calling thread with a message naming the module and function | `resid_native_call` (`runtime/rt/native.resid`) | `native_host_killed`, `native_in_spawn_err` |
| Law 14, §20: no ambient authority | `native_<m>` is a capability family, checked transitively (E0219) and at force time (`resid_cap_check`). The native code itself holds **zero** OS authority | `gk_all_facts`, the stub's check, the seccomp filter | `err_native_ungranted`, `err_native_bare_native`, escape tests (§7.2) |
| §4: values immutable, no observable identity; only handles hold mutable state | Arguments are copied into the child. Results are copied out and validated. A fresh process per call means no state survives a call, so no hidden identity | process-per-call | `native_stateless` |
| §5, §38: no exposed storage, no raw intrinsics, no programmer-controlled allocation | The language gains no pointer, `extern`, or intrinsic. `Str(N)`/`Bytes(N)` cross as copies of their bytes | type rules §3 | `err_native_illegal_type` |
| §19: child ≤ parent; residual forcing uses the child's CapEnv | The stub's check runs in the calling thread's frames | `resid_cap_check` | `err_native_spawn_ungranted` |
| §21: sandboxes and manifest ceilings only narrow | `native_<m>` is an ordinary family under `sandbox`, import attenuation and `[dependencies.X] capabilities` | existing `meet_caps`, `check_dep_capabilities` | `err_native_sandbox`, pkg `native_manifest_ceiling` |
| §21.1, §28.2(5): dependency capabilities must be *grantable* under the manifest | Fixed defect (A1): modes are now compared, so `filesystem` is not grantable under `filesystem(readonly)` | `first_missing_cap` (`resid-manifest.resid`) | pkg `depmap_mode_refused`, `depmap_mode_ok` |
| §44: `Str(N)` is valid UTF-8 of ≤ N bytes, NUL-terminated; `Bytes(N)` is exactly N bytes | A returned `Str(N)` is UTF-8-checked and NUL-terminated by the parent; `Bytes(N)` is copied exactly | `resid_native_str_ok` | `native_bad_utf8_refused` |
| §33.1/§34 provenance record | `native` map added to the CDDL | `prov_payload` | `native_in_provenance` |

Rejected from revision 1, with reasons:

- **A2, "root grant binds `main`"**: the spec makes the manifest grant a ceiling
  for *dependencies* (§21.1, §28.2, §43), and authority enters at `main` (§20).
  The sibling packages rely on this (`resid-datastar` grants `[]` while its
  UI's `main` declares its own). Changing it is a language change, not a fix.
- **A3**: `prov_grant_of` already records modes (`filesystem(readonly)`).
- **A4, `verify --max-grant` on a host binary**: there is no separate host
  binary any more.
- **`process.run` + loopback**: it needs the full `process` grant, which already
  means "run anything", and it keeps a stateful server.
- **Persistent host process**: state across calls is hidden identity (§38).
  It also makes results depend on call order.

## 2. Surface

```resid
@link("tiny")
Int tiny_add(Int a, Int b) {}

@requires(native_tiny)
Int main() { println(f"{tiny_add(rt 2, 3)}"); return 0; }
```

- `@link("<m>")` takes one string literal matching `[a-z][a-z0-9_]*`, at most
  32 bytes long (it becomes part of a capability family name).
- It may appear only on a top-level, non-generic `fn` with no `@needs`,
  `@inst`, `@import`, `@export` or `@requires`. The family is implied by the
  annotation, and writing it twice could disagree.
- The body must be empty: `{}`. The checker does not check it, the reducer
  does not see it, and the lowering replaces it.
- The C symbol is the Resid name. Inside the artifact it is renamed to
  `native.<m>.<name>` (§5), so the Resid stub owns `@<name>` and nothing
  collides.
- Refused in files under `lib/`, `tools/`, `runtime/rt/`, and under
  `--runtime-module` (E0232). The standard library stays pure Resid.

## 3. Types that cross (E0233 otherwise)

| Resid | parameter (C / LLVM) | result |
|---|---|---|
| `Bool` | `bool` / `i1 zeroext` | same; the parent refuses anything but 0/1 |
| `Int`, `Int(64)` | `int64_t` / `i64` | same |
| `Int(8/16/32)` | `int8_t`… / `iN signext` | same; the parent checks the range |
| `UInt`, `UInt(64)` | `uint64_t` / `i64` | same |
| `UInt(8/16/32)` | `uint8_t`… / `iN zeroext` | same; the parent checks the range |
| `Float`, `Float(64)` | `double` | same |
| `Float(32)` | `float` | same |
| `Str(N)` | `const char *`, `int64_t cap` / `ptr, i64` — the N + 1 bytes, NUL-terminated | trailing `char *out, int64_t cap` (N + 1 zeroed bytes) and C returns `void`; the parent checks UTF-8 and the NUL, and zeroes the bytes after the NUL |
| `Bytes(N)` | `const uint8_t *`, `int64_t cap` / `ptr, i64` — exactly N bytes | trailing `uint8_t *out, int64_t cap` (N zeroed bytes) and C returns `void` |
| `Void` | — | `void` |

Everything else is refused: `Str`, `Bytes`, `List` (both forms), `Vec`,
`Dec`, wider integers, `Float(16/128)`, records, variants, `Option`,
`Result`, closures, `File`, `Task`, maps, sets and type parameters. These have
no fixed byte form, or a heap form whose layout the language does not
expose. Pointers never cross: the native side gets pointers into its own
copy.

## 4. Capability

- The family is `native_<m>`, mode-less. `native_<m>(readonly)` is refused
  (E0219, "native_<m> has no modes"). A bare `native` is an unknown family.
- A `@link` function's own use is `native_<m>`, full. `gk_all_facts` seeds it,
  so the existing fixpoint carries it to every caller (E0219), to `spawn` lists
  (E0214), and to `sandbox` ceilings (E0211/E0212).
- The force-time guard: the parent stub calls `resid_cap_check("native_<m>!")`
  before it forks. The `!` makes it a write, so it is never satisfied by a
  read-only entry.

## 5. The artifact (driver: `-native <m>=<path.ll>`)

The path must end in `.ll` and contain no space. `<m>` must be a valid module
name. A module given twice is refused. The artifact is read as text and
**rewritten**, never linked as-is:

1. **Lexed**: comments, strings (`c"…"`, `"…"`), `@ident` tokens. A quoted
   global (`@"…"`) and any `$comdat` token are refused.
2. **Classified, top level only**: blank lines, comments, `source_filename`,
   `target datalayout`, `target triple` (must start with `x86_64-` and
   contain `linux`), `%T = type`, `@g = …global|constant…`, `define … {` to
   `}`, `declare`, `attributes #N`, and `!…` metadata. Anything else is
   refused: `module asm`, `ifunc`, `alias`, `section`, `comdat`,
   `thread_local`, `llvm.global_ctors/dtors/used/compiler.used`, and any
   `@llvm.*` definition.
3. **Closed**: every `@x` it references must be defined in the artifact, be an
   `llvm.*` intrinsic, or be `memcpy`/`memmove`/`memset` (the runtime's).
   Anything else is refused, including `resid_*`. Native code reaches
   nothing of the runtime's.
4. **Renamed**: every symbol the artifact defines becomes `native.<m>.<x>`.
   It can then neither override nor be confused with a program, runtime or
   libgcc symbol.
5. **Matched**: each `@link("m") name` must be defined by artifact `m` (E0235),
   with exactly the §3 parameter and return types (E0236, compared type by
   type after stripping parameter names and attributes). An artifact for a
   module no `@link` names is a warning-free no-op.
6. The rewritten text goes to `<out>.native.<m>.ll`, which is added to the
   clang link.

E0237 covers every refusal in steps 1–4, and names the line.

These checks keep native code out of the **parent**: it cannot run at load
time (no constructors, no ifunc, no init sections), cannot replace a symbol
the parent calls, and cannot be called except through the host dispatch.
Inside the **child**, the kernel filter (§6) is the boundary, so inline `asm`
is allowed there and contained.

## 6. Execution: one sandboxed process per call

**Parent** (`resid_native_call(ptr module, ptr req, i64 reqlen, ptr resp, i64 resplen)`,
in `runtime/rt/native.resid`):

1. `socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC)`; build argv
   `["resid-native-host", <m>]` and an empty envp **before** `fork`.
2. `fork`. The child makes only raw system calls before `execve`, so a
   multi-threaded parent is safe: `dup2(s, 3)`, close 0–2 and everything
   above 3 (`close_range`), `setrlimit(RLIMIT_CPU, 60 s soft / 61 s hard)`,
   `setrlimit(RLIMIT_CORE, 0)`, `prctl(PR_SET_PDEATHSIG, SIGKILL)`, then
   `execve("/proc/self/exe", argv, [])`, or `exit_group(127)` if that fails.
3. Write the request with `MSG_NOSIGNAL`, `shutdown(SHUT_WR)`, read until EOF
   (at most `resplen + 1` bytes), `waitpid` (retrying on `EINTR`).
4. Require exit status 0 **and** exactly `resplen` bytes. Otherwise abort:
   `native module `m`: `f` failed (<signal N | exit N | short reply>)`.

**Child** (`resid_native_host`, called from the generated `main` before
`resid_run_main` only when the program links native modules): it acts only
when `argc == 2`, `argv[0] == "resid-native-host"` and `envp` is empty.
Then, in order, failing closed (`exit_group(126)`) at any step:

1. Find module `<m>` in the generated table (else exit).
2. `prctl(PR_SET_DUMPABLE, 0)`, `prctl(PR_SET_TSC, PR_TSC_SIGSEGV)`, and write
   `1000` to `/proc/self/oom_score_adj` (best effort: an OOM kills the host,
   not the program).
3. Unmap `[vdso]`, `[vvar]` and `[vvar_vclock]` (from `/proc/self/maps`), so
   no clock is readable without a system call.
4. `prctl(PR_SET_NO_NEW_PRIVS, 1)`, then `seccomp(SECCOMP_SET_MODE_FILTER)`
   with this filter (anything else is `SECCOMP_RET_KILL_PROCESS`):
   - architecture must be `AUDIT_ARCH_X86_64`, and the syscall number below
     `0x40000000` (no x32);
   - `read`, `write`: only when fd == 3;
   - `mmap`, `mprotect`: only without `PROT_EXEC`;
   - `munmap`, `brk`, `mremap`, `madvise`, `exit`, `exit_group`.
5. Read `[i64 fn][args]` from fd 3. `fn` is bounds-checked and must belong to
   `<m>`, and the request length must be exact. Call the generated thunk
   (which calls `native.<m>.<name>`), write the result and `exit_group(0)`.

No clock, no randomness system call, no file, no socket other than fd 3, no
process, no signal, no thread, no executable memory. Stdout and stderr are
closed. The child is a fresh image, so the parent's heap, arguments and
environment are not in its memory.

Cost: one `fork` + `execve` per call (measured: about 2 ms for a small program). This is stated in §47;
statelessness is worth more than call speed.

## 7. Tests

### 7.1 Conformance (`tests/conformance/cases/`, fixtures in `tests/conformance/native/`)

Fixtures are C compiled once with
`clang -S -emit-llvm -O1 -ffreestanding -fno-builtin -fno-stack-protector`
and committed as `.ll`, so the suite needs only clang.

| Case | Expectation |
|---|---|
| `native_ok` | integer, float, bool, `Int(8)`, `UInt(16)`, `Str(N)` and `Bytes(N)` in and out |
| `native_never_folded` | `tiny_add(2, 3)` with literal arguments still calls the artifact (it answers 6, not 5) |
| `native_stateless` | a native counter returns 1 on every call |
| `native_in_spawn_err` | a crashing native call inside `spawn` is `Err`, the program continues |
| `native_host_killed` | a crash outside `spawn` aborts, exit ≠ 0 |
| `native_bad_utf8_refused` | a `Str(N)` result with invalid UTF-8 aborts |
| `native_bad_bool_refused` | a `Bool` result of 2 aborts |
| `native_escape_*` | native code attempting `open`, `socket`, `execve`, `fork`, `getpid`, `clock_gettime` (syscall), `rdtsc`, a write to fd 1, `mmap` with `PROT_EXEC`: each call is killed and aborts |
| `native_escape_env` | native code scanning its own stack finds no parent environment variable |
| `err_native_ungranted` | E0219 `native_tiny` |
| `err_native_bare_native` | `@requires(native)`: unknown family |
| `err_native_readonly` | `native_tiny(readonly)` refused |
| `err_native_spawn_ungranted` | E0214 |
| `err_native_sandbox` | E0212/E0211 |
| `err_native_in_lib` | E0232 |
| `err_native_illegal_type` | E0233 for `Str`, `List(Int)`, `Vec`, a record, a closure, `Dec`, `Int(128)` |
| `err_native_bad_body` | E0234 (non-empty body) |
| `err_native_bad_name`, `err_native_generic`, `err_native_with_requires` | E0234 |
| `err_native_no_artifact`, `err_native_export_absent` | E0235 |
| `err_native_abi_mismatch` | E0236 |
| `err_native_artifact_extern` | E0237: the artifact declares `resid_process_run` |
| `err_native_artifact_ctor`, `_module_asm`, `_ifunc`, `_section` | E0237 |

### 7.2 Package (`tests/pkg/run.sh`)

`depmap_mode_refused` (root `filesystem(readonly)`, dep `filesystem`),
`depmap_mode_ok`, `native_manifest_ceiling`, `native_pkg_hash` (a modified
artifact fails `sha256`), `native_artifact_in_archive`, `native_dep_build` (a
dependency's `[native]` module reaches the consumer's link).

### 7.3 Provenance

`native_in_provenance`: the record's `native.tiny` equals the artifact's
SHA-256, and `verify` shows it as attestation.

### 7.4 Runtime

`cap_guard.c`: `native_a` is distinct from `native_ab` and from `native`.
A grant set over the frame size aborts instead of being truncated (it used
to drop entries silently, which failed closed but confusingly).

## 8. Manifest and packages

```toml
[native.tiny]
path   = "native/tiny.ll"
sha256 = "<64 lowercase hex>"
```

`resid-manifest` checks `sha256` for the root package and every dependency.
It passes `-native tiny=<absolute path>` for each, and refuses one module name
claimed by two packages. `resid-pkg pack` includes every `[native]` path in
the archive (sorted with the sources), so the content hash covers it.

## 9. Sequence

1. A1: mode-aware grantability in `resid-manifest` + pkg tests.
2. Runtime: abort on grant-set overflow; `lsg_req` modes (`false` → `true`).
3. Compiler: `@link` parse checks (`graph.resid`), reducer exclusion, checker
   (E0232–E0234, the family), lowering (stub, thunks, table, `main`), the
   artifact pipeline (E0235–E0237), the graph effect, the provenance map.
4. Runtime: `runtime/rt/native.resid`. Reseed (`rt.ll`, seed).
5. Manifest `[native]`, `resid-pkg pack`.
6. Spec (§20, §28.2, §33.1, §34, §35, new §47), `SECURITY.md`, website.
7. Full suite.
