---
title: resid-fmt, resid-pkg, resid-manifest
description: Formatting, package archives and signatures, and project manifests.
---

## resid-fmt

`resid-fmt <file.resid> [-w | --check]` prints the file in canonical
form; `-w` rewrites it in place and `--check` exits non-zero when it is not
formatted.

## resid-manifest

Reads a project's `resid.toml`:

```text
[package]
name = "example"
version = "0.1.0"

[capabilities]
grant = ["filesystem(readonly)"]

[dependencies.http]
path = "vendor/http"
capabilities = ["network"]

[signing]
keyring = "keys/"
require_signatures = true
```

| Command | |
|---|---|
| `resid-manifest <resid.toml>` | print the parsed manifest |
| `resid-manifest deps <resid.toml>` | resolve dependencies transitively, checking cycles, name clashes, capability ceilings and signatures |
| `resid-manifest depmap <resid.toml> <out>` | write the dependency map the compiler reads with `-depmap` |
| `resid-manifest lock <resid.lock>` | print a lock file |

## resid-pkg

| Command | |
|---|---|
| `resid-pkg keygen <secret.hex> <pub.hex>` | an Ed25519 key pair |
| `resid-pkg pack <dir> <out>` | a content-addressed archive of the package's `.resid` and `.toml` files |
| `resid-pkg sign <out> <keyfile>` | sign an archive's content hash |
| `resid-pkg sign-dir <dir> <keyfile>` | sign a path dependency in place |
| `resid-pkg checksig <out> <pubkey-hex>` | verify a signature |
| `resid-pkg extract <out> <dir>` | extract (never outside `dir`) |
| `resid-pkg publish <dir> <registry> [keyfile]` | pack, sign and add to a local registry index |

A dependency is accepted only when its hash is listed by a trusted
registry's signed index or its signature verifies under a pinned or
keyring key, and when its archive names the requested package and
version; see [Security](/Resid/tools/security/).
