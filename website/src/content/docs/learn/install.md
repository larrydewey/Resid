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

## Install it

```sh
./install.sh
source ~/.resid/env        # add this line to your shell profile
```

`install.sh` copies the compiler, the runtime (`rt.ll`) and the standard
library into `~/.resid` (`RESID_INSTALL` picks another directory) and puts
`residc` in `~/.resid/bin`. `residc` then works from any directory with no
environment variables. It also creates a signing key in `~/.resid/keys` the
first time, which release builds use and reinstalls keep.

After a later `./boot.sh` (including `--bootstrap-from-self`), an existing
install is refreshed automatically, so it never lags the checkout
(`RESID_NO_INSTALL_REFRESH=1` skips that). `./uninstall.sh` removes the
install but keeps the key; `./uninstall.sh --purge` removes everything.

Inside the repository no install is needed: `build/boot/residc` runs the
freshly built compiler.

## Signing keys

Release builds are signed (every binary carries signed provenance; see
[Provenance](/Resid/reference/provenance/)). The key is looked up in
`RESID_SIGNING_KEY`, then `keys/resid-ed25519.key` in the current
directory, then the install's `~/.resid/keys`. For a per-project key:

```sh
residc keygen          # writes keys/resid-ed25519.key and .pub
```

`residc verify` accepts a key from the install's `keys/*.pub` (reported
as `anchored`), from `--pub` or `RESID_VERIFY_PUB` (`supplied`) or from
`keys/*.pub` in the current directory (`local`, which is not an anchor;
`--anchored` refuses it). Debug and check builds need no key.

## Editor support

The VS Code extension in `editors/vscode` gives highlighting, snippets and
the language server (`residc lsp`); see [Editor](/Resid/tools/editor/).
