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
| `resid-manifest build <resid.toml> <driver>` | resolve, write the depmap, and compile the package's root |
| `resid-manifest test <resid.toml> <driver>` | run every `*_test.resid` in the package's source tree |

## resid-manifest test

`residc test` runs one file, or with no file every `*_test.resid` under
`--root`. `resid-manifest test` runs a *package's* tests: it resolves
dependencies and writes the depmap exactly as `build` does, then hands
discovery to the driver's own `test` mode — so there is one implementation of
discovery, naming and the exit-code contract, not one per tool.

```text
$ resid-manifest test resid.toml ./residc
test: 3 test file/s under /path/to/pkg/src
src/math_test.resid

math_test
  ✓ add: identity (0ms)

Failures: 0 | Passed: 1 | Duration: 0ms
...
---
3 file/s passed, 0 failed, 0 did not compile
```

A test file's bare `import "pkgname";` resolves to the same dependency the
package's own root sees, inside the same capability ceiling. A file that
fails — a failing assertion or a compile error — is reported and counted and
the remaining files still run. A file that does not compile is counted apart
from a failing one and dominates the exit status (2, not 1; see
[Testing](/Resid/learn/testing/)). A package with no `*_test.resid` files
succeeds and says so. `target` is build output, not source, so it is never
searched.

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
