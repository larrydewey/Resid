---
title: residc
description: The compiler's commands, options, profiles, outputs and environment.
---

```text
residc <file.resid> [-o out] [--profile release|debug|check] [-O0|-O1|-O2|-O3|-Os|-Oz]
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
| `RESID_HOME` | the directory holding `rt.ll` (the runtime); the standard library is at `$RESID_HOME/../../lib` |
| `RESID_SIGNING_KEY` | the signing key for release builds (else `keys/resid-ed25519.key`) |
| `RESID_MEM_LIMIT` | the compiler's memory budget in MB (default 4096) |

The compiler needs `clang` and `lld` (LLVM 22+) to link.
