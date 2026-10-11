---
title: Native modules
description: "@link, the types that cross, artifact rules, the sandboxed execution model, errors E0232–E0237, manifests and provenance (spec §47)."
---

A native module is code compiled from another language to LLVM IR text and
bound with `@link`. Calling it is a provider read (Law 8), an effect never
reduced at compile time (Laws 9, 10), authorized by the capability family
`native_<module>` (Law 14). The native code itself holds no authority.
Specification: §47.

## Binding

```resid
// check-only
@link("zlib")
Int adler32(Bytes(64) data, Int len) {}

@requires(native_zlib)
Int main() {
    Bytes(64) block = b"Wikipedia";
    println(f"{adler32(block, 9)}");
    return 0;
}
```

| Rule | Error |
|---|---|
| The argument is one string literal: lowercase letters, digits and `_`, starting with a letter, at most 32 bytes. | `E0234` |
| Only on a top-level function: not generic, and without `@requires`, `@needs`, `@import` or `@export`. Not on a type, behavior or test. | `E0234` |
| The body is empty, `{}`. | `E0234` |
| Not in the standard library (`lib/`), the tools (`tools/`) or the runtime (`runtime/rt/`, `--runtime-module`). | `E0232` |

The C symbol is the function's declared name. A module-private function
(renamed for its module, §22) still binds its declared name.

## Capability

- The family is `native_<module>`. It has **no modes**:
  `native_zlib(readonly)` is refused, since a native module is reached in
  full or not at all.
- A bare `native` is not a family and grants nothing. `native_a` and
  `native_ab` are unrelated.
- The `@link` function's own use is `native_<module>`. Like every family
  it flows to every caller (`E0219`), into `spawn` lists (`E0214`), and is
  bounded by `sandbox` blocks, attenuated imports and manifest ceilings
  (`E0211`, `E0212`, `E0218`).
- At run time the call checks `native_<module>` against the calling
  thread's sandbox frames before it starts.

## Types

Only values with a fixed byte form cross. Anything else is `E0233`.

| Resid | C parameter | C result |
|---|---|---|
| `Bool` | `bool` | `bool` |
| `Int`, `Int(64)` | `int64_t` | `int64_t` |
| `Int(8)`, `Int(16)`, `Int(32)` | `int8_t`, `int16_t`, `int32_t` | the same |
| `UInt`, `UInt(64)` | `uint64_t` | `uint64_t` |
| `UInt(8)`, `UInt(16)`, `UInt(32)` | `uint8_t`, `uint16_t`, `uint32_t` | the same |
| `Float`, `Float(64)` | `double` | `double` |
| `Float(32)` | `float` | `float` |
| `Str(N)` | `const char *s, int64_t cap` (N + 1 bytes, NUL-terminated) | `void`, with `char *out, int64_t cap` appended (N + 1 zeroed bytes) |
| `Bytes(N)` | `const uint8_t *b, int64_t cap` (exactly N bytes) | `void`, with `uint8_t *out, int64_t cap` appended (N zeroed bytes) |
| `Void` | | `void` |

N is at most 16777216. Refused: `Str`, `Bytes`, `List` (both forms),
`Vec`, `Dec`, wider integers, `Float(16)`, `Float(128)`, records,
variants, `Option`, `Result`, closures, `File`, maps and sets. A pointer
the native side receives points into its own copy of the value.

For example, `Str(16) upper(Str(16) s)` binds
`void upper(const char *s, int64_t cap, char *out, int64_t ocap)`.

## Artifacts

`-native <module>=<path.ll>` names a module's artifact. It is repeatable,
and a module may be named once. The path must end in `.ll` and contain
no space. A module that no `@link` uses is ignored.

The artifact is LLVM IR text for x86-64 Linux, freestanding. Before it is
linked, the compiler checks and rewrites it (`E0237` names the line of a
refusal):

- Every global it references must be its own, an LLVM intrinsic, or
  `memcpy`, `memmove` or `memset`. It may not declare or reach anything
  else, the runtime included.
- Refused outright: `module asm`, aliases, ifuncs, comdats, `section` and
  `partition` placement, `thread_local` and `external` globals,
  `personality` functions, quoted global names, and any definition of an
  `llvm.*` global (constructors, used lists). Nothing in it can run at
  load time or be placed outside its functions.
- Every symbol it defines is renamed `native.<module>.<name>`, so it
  cannot replace or reach a symbol of the program, the runtime or another
  module.

Each `@link` function must be defined by its artifact and externally
visible (`E0235`, or `E0236` for an `internal`/`private` definition),
with exactly the C types in the table (`E0236`, which shows both
signatures). Parameter names and attributes are ignored.

The rewritten artifact is written beside the output as
`<out>.native.<module>.ll` and linked with the program.

## Execution

Each call runs in a fresh process:

1. The caller checks the capability, encodes the arguments into a request
   (8 bytes per scalar, the bytes of a `Str(N)` or `Bytes(N)`), and starts
   the program's own executable again (`/proc/self/exe`) with an empty
   environment, the arguments `resid-native-host <module>`, and the call's
   socket as its only descriptor. A program in secret mode does so only
   under the Yama ptrace policy; see [the device host](/Resid/reference/devices/#who-starts-a-host)
   (§49), whose start and checks native hosts share.
2. The host first makes itself not dumpable and checks who started it,
   as a device host does: no `AT_SECURE`, no capability beyond its
   parent's, its parent made its socket and answers a random challenge,
   and every byte it reads carries the parent's pid; otherwise it exits
   124 without reading the request. The caller reads only what that host
   sent. Then, before running any native instruction, the host: disables
   the time-stamp counter (`rdtsc` faults), unmaps
   the vDSO clock pages, asks to be the first victim of the OOM killer,
   reads the request, turns on the shadow stack (below), sets
   no-new-privileges, and installs a seccomp filter. The filter allows
   `write` on its socket, `exit` and `exit_group`, nothing else: the
   request is already read, and nothing the host does afterwards needs
   memory from the kernel. Any other system call, an x32 call or a 32-bit
   entry kills it with `SIGSYS`.
3. The host calls the native function, writes the result and exits. Its
   CPU time is limited to 60 seconds.
4. The caller requires a clean exit and a reply of exactly the expected
   length, then checks the value: a `Bool` is 0 or 1, a narrow integer
   fits its type, a `Str(N)` is valid UTF-8 up to a NUL within its
   capacity (the bytes after the NUL are zeroed).

A failed call (a signal, another exit status, a malformed reply) aborts
the calling thread with a message naming the module, the function and
the reason, such as ``native module `tiny`: `tiny_add` failed: killed by
signal 31``. Inside a `spawn` region that is the region's
`Err(RegionError)`.

Hardening of the host, each where the CPU and kernel have it (without
it the host runs as before):

- **Shadow stack.** On x86-64 the host turns on and locks CET's shadow
  stack (Linux 6.6); on AArch64, the guarded control stack (Linux 6.13).
  Every return must then match its call. It starts in the host's last
  frame, which never returns.
- **Return signing and landing pads (AArch64).** The compiler builds
  every function of the module with return-address signing (PAC),
  landing pads (BTI) and guarded-control-stack compatibility, whatever
  the artifact's own attributes say, and places the module's code in its
  own section between two page-aligned marks. The host maps exactly those
  pages with `PROT_BTI`, so an indirect branch into the module's code
  must land on a pad. The instructions are hints and do nothing on a CPU
  without the features. x86-64 has no counterpart for landing pads:
  Linux does not enable indirect-branch tracking in user space.

**Inline asm** in a module's functions is allowed and recorded. It runs
only inside the host, after the filter, so it gains nothing the filter
does not allow: refusing it would not be a boundary, since native code
can reach the program's own system-call instructions without it. The
provenance record lists each module that has inline asm, with its sites
by mnemonic, and `residc verify` prints it, for example
``attestation: native module esc contains inline asm, 13 sites: syscall x12, rdtsc x1``.
`module asm` stays refused: it is outside any function and could define
symbols in the program.

Consequences:

- A native call sees only its arguments and keeps no state between calls.
- Its cost is a process start, about 2 ms on a small program, more for a large one.
- Native code cannot use the OS. A display, a device or a file is the
  program's business, through its providers.

## Errors

| Code | Meaning |
|---|---|
| `E0232` | `@link` in the standard library, the tools or the runtime |
| `E0233` | a parameter or result type that cannot cross |
| `E0234` | a malformed `@link`: bad module name, non-empty body, generic, combined with another annotation, or not on a function |
| `E0235` | no artifact for a bound module, or the artifact does not define the function |
| `E0236` | the artifact's definition has other C types, or is not visible outside it |
| `E0237` | a refused artifact (see [Artifacts](#artifacts)), or a malformed `-native` flag |

## Manifests

```text
[native.tiny]
path   = "native/tiny.ll"
sha256 = "<64 lowercase hex digits>"
```

`resid-manifest build` and `test` check each artifact of the package and
of every dependency against its pinned SHA-256, and pass `-native` for
each. A module name may be claimed by only one package. A consumer grants
a dependency the family through its ceiling
(`capabilities = ["native_tiny"]`). Package archives include `.ll` files,
so the content hash and any pinned-key signature cover them.

## Provenance

The signed record gains a `native` map from each linked module to the
SHA-256 of its artifact as given:

```text
attestation: native module tiny from an artifact with SHA-256 6b89b5bc…
```

It is attestation: the code hash covers the linked binary, and the signer
names the artifact it came from. In the knowledge graph, each native call
is an `effect` node named `native_<module>.<function>` whose capability
is `native_<module>`, so `residc verify` checks it lies within the grant.
