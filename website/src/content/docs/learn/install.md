---
title: Install
description: Build the Resid compiler from source.
---

Resid is self-hosted: the compiler is written in Resid and builds itself
from a committed seed. You need:

- **Linux on x86-64** (the runtime makes Linux system calls directly).
- **LLVM 22 or newer**: `clang` and `lld` compile the LLVM IR the Resid
  compiler emits and link it. `libgcc` provides 128-bit division and
  `Float(128)` arithmetic.
- **git** and **bash**.

Binaries are static position-independent executables with **no C library**;
nothing else is needed at runtime.

## Build

```sh
git clone https://github.com/larrydewey/Resid.git
cd Resid
./boot.sh
```

`boot.sh` links the committed seed, lets it compile the compiler, lets that
compiler compile itself again, and checks that the last two outputs are
byte-identical (the *fixed point*). It takes a few seconds for the compiler
and about fifteen for clang's optimizing link. The result is
`build/boot/stage2.bin`: that is `residc`, the Resid compiler.

## Put it on your PATH

The compiler finds its runtime (`rt.ll`) through `RESID_HOME`:

```sh
mkdir -p ~/.local/bin
ln -s "$PWD/build/boot/stage2.bin" ~/.local/bin/residc
export RESID_HOME="$PWD/build/boot"     # add this to your shell profile
```

Inside the repository no variable is needed.

## Signing keys

Release builds are signed (every binary carries signed provenance; see
[Provenance](/Resid/reference/provenance/)). Create a key once per project:

```sh
residc keygen          # writes keys/resid-ed25519.key and .pub
```

or point `RESID_SIGNING_KEY` at an existing key. Debug and check builds
need no key.

## Editor support

The VS Code extension in `editors/vscode` gives highlighting, snippets and
the language server (`residc lsp`); see [Editor](/Resid/tools/editor/).
