---
title: residc
description: The compiler's commands, options, profiles, outputs and environment.
---

```text
residc <file.resid> [-o out] [--profile release|debug|check] [-O0|-O1|-O2|-O3|-Os|-Oz] [--target x86_64|aarch64]
residc test <file.resid> [--filter REGEX] [--format pretty|tap|json]
residc keygen [dir]
residc verify <binary> [--pub HEX] [--anchored] [--sources DIR]
residc lsp
```

## Building

`residc app.resid -o app` compiles, reduces, lowers to LLVM IR, and links a
static binary with clang. The default output is `a.out`.

| Profile | Optimization | Debug info | Graph artifact | Signing |
|---|---|---|---|---|
| `release` (default) | `-O2`, LTO | no | no | required |
| `debug` | `-O0` | DWARF | yes | if a key is present |
| `check` | no binary | | yes | |

`-O0` … `-Oz` override the optimization level.

## Targets

`--target` picks the machine the binary is for: `x86_64` (the default) or
`aarch64` (also spelled `arm64`, `aarch64-linux`, `aarch64-linux-android`),
64-bit ARM Linux, Android included. Both are static PIEs with no C library;
the compiler may run on either and builds the same IR for a given target.

A cross build links the AArch64 runtime (`rt-aarch64.ll`) with `lld` and
compiler-rt's AArch64 builtins in place of `libgcc`.
`tools/aarch64-builtins.sh` copies them from clang's resource directory or
an Android NDK into `build/boot/aarch64/`, where `install.sh` picks them
up; `RESID_AARCH64_BUILTINS` names an archive directly.

```sh
residc app.resid --target aarch64 -o app
adb push app /data/local/tmp/ && adb shell /data/local/tmp/app
```

On an x86-64 host with qemu-user registered in binfmt_misc the binary runs
directly. What differs on AArch64:

- A [native module](/Resid/reference/native-modules/)'s artifact must be
  AArch64 IR. Its sandbox works the same, except that the CPU's generic
  timer (`CNTVCT_EL0`) stays readable: Linux cannot deny it to a process
  the way `PR_SET_TSC` denies the x86-64 time stamp counter. qemu-user has
  no seccomp, so native calls fail there ("the sandbox could not be
  installed"); they need AArch64 hardware.
- `resid-debug` is x86-64 only.

## Outputs

| File | Contents |
|---|---|
| `out` | the static binary, with its signed provenance trailer |
| `out.ll` | the LLVM IR |
| `out.resid-graph.cbor` | the knowledge graph ([reference](/Resid/reference/knowledge-graph/)) |
| `out.resid-notes.cbor` | residual notes |
| `out.resid-prov.cbor` | a detached copy of the provenance signature |

## Other options

| Option | |
|---|---|
| `-march=CPU` | passed to clang, e.g. `-march=native` to use the host's vector units (the binary then needs that CPU, and the provenance does not record the flag) |
| `--no-reduce` | skip compile-time reduction (for comparison) |
| `--reduce-budget N` | evaluate up to N steps at compile time (default 16,000,000), or `unbounded`: no step or depth limit, only the memory meter ([budgets](/Resid/reference/reduction/#determinism-and-budgets)); a budget other than the default is recorded in the provenance |
| `--no-facts` | keep every runtime check (no range facts) |
| `--dump-reduced PATH` | write the residual program as source text |
| `--dump-graph PATH` | write the parsed graph |
| `-depmap PATH` | a dependency map from `resid-manifest` |
| `-native M=PATH.ll` | the artifact of [native module](/Resid/reference/native-modules/) `M` (repeatable) |

## Commands

- `residc test` builds the file's `test` blocks into a test binary and runs
  it ([Testing](/Resid/learn/testing/)).
- `residc keygen [dir]` writes an Ed25519 key pair (`resid-ed25519.key`,
  readable only by its owner, and `.pub`), by default in `keys/`.
- `residc verify <binary>` checks the provenance signature, the code hash
  and every sidecar present, then reports evidence and attestation apart
  and names the keyring the key came from; `--anchored` accepts only the
  install's keyring and `--sources DIR` re-hashes the sources
  ([Provenance](/Resid/reference/provenance/)).
- `residc lsp` runs the language server on stdin/stdout
  ([Editor](/Resid/tools/editor/)).

## Environment

| Variable | |
|---|---|
| `RESID_HOME` | the directory holding `rt.ll` and `rt-aarch64.ll` (the runtime); the standard library is at `$RESID_HOME/../../lib` |
| `RESID_AARCH64_BUILTINS` | compiler-rt's AArch64 builtins archive, for `--target aarch64` (else `$RESID_HOME/aarch64/libclang_rt.builtins.a`) |
| `RESID_SIGNING_KEY` | the signing key for release builds (else `keys/resid-ed25519.key`) |
| `RESID_MEM_LIMIT` | the compiler's memory budget in MB (default 4096); one compile-time evaluation may meter a quarter of it |
| `RESID_STACK_MB` | the stack of a program's main thread in MB (default 1024); for the compiler, how deep compile-time evaluation may nest before E0902 |

The compiler needs `clang` and `lld` (LLVM 22+) to link.
