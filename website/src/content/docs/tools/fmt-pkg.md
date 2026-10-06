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

[native.zlib]
path   = "native/zlib.ll"
sha256 = "<64 lowercase hex digits>"
```

Each dependency's `capabilities` must be grantable under `grant`, modes
included, and a dependency's own dependencies get at most its ceiling
([capabilities](/Resid/reference/capabilities/#manifests)). `[native.<m>]`
pins a [native module](/Resid/reference/native-modules/)'s artifact by
SHA-256; the build refuses a changed one and passes `-native` for it.

A `version =` dependency is fetched from the registry, named either as a
directory (`[registry] path`) or as an `http://` or `https://` base URL
(`[registry] url`) — not both, since a build should not have to guess
which one it read from. A dependency may give both `path` and `version`:
the path is used when it exists (a working copy beside yours), the
registry version when it does not (in a published copy of your package).
Its modules are imported by package name: `import "pkg";` is its root,
`import "pkg/m.resid";` the module `m.resid` beside that root.

```text
[registry]
url = "http://127.0.0.1:8080"
pubkey = "<the registry's signing key, hex>"
```

A remote registry is untrusted input exactly like a local one: the
archive's hash is checked against `resid.lock` and the `-sha256` sidecar,
and trust comes from a pinned key, a keyring key or the registry's signed
index.

### A registry over HTTPS

`resid-pkg serve <registry> --cert server.pem --key server.key` serves a
registry over TLS 1.3, at the same paths as over plain HTTP. Name it with
an `https://` url and the trust store its certificate must chain to:

```toml
[registry]
url = "https://registry.example:8443"
ca = "certs/registry-ca.pem"
pubkey = "<the registry's signing key, hex>"
```

`ca` is a PEM bundle or a directory of DER certificates, relative to the
manifest. It is required: with no trust store nothing is trusted, so an
`https://` url without `ca` is refused, and nothing is ever downgraded to
plaintext. The server must present a certificate for the url's host that
chains to `ca`.

Nothing is trusted because it came over TLS: `resid build` still checks
the index against `pubkey` and every archive against its hash, exactly as
for a registry on disk. TLS only proves which server the bytes came from.

`resid-fetch` pulls a single artifact the same way, to mirror a registry
into a directory:

```
residc tools/resid-fetch.resid run -- [--timeout SECONDS] \
    https://registry.example:8443 ca.pem pkg/index.resid-idx reg/pkg/index.resid-idx
```

`require_signatures = true` goes further than the index: an entry in the
signed index is a hash somebody wrote down, not a signature over it, so
this refuses the index on its own and demands a detached Ed25519
signature under a pinned or keyring key.

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
| `resid-pkg pack <dir> <out>` | a content-addressed archive of the package's `.resid`, `.toml` and `.ll` (native module) files, and its README, LICENSE (or LICENCE), CHANGELOG, NOTICE and COPYING at the root (bare, `.md`, `.markdown` or `.txt`) |
| `resid-pkg sign <out> <keyfile>` | sign an archive's content hash |
| `resid-pkg sign-dir <dir> <keyfile>` | sign a path dependency in place |
| `resid-pkg checksig <out> <pubkey-hex>` | verify a signature |
| `resid-pkg extract <out> <dir>` | extract (never outside `dir`) |
| `resid-pkg publish <dir> <registry> [keyfile]` | pack, sign and add to a local registry index |
| `resid-pkg serve <registry> [--port N] [--port-file F] [--requests N] [--cert F --key F] [--upload KEYRING --index-key F]` | serve that registry over HTTP, or over TLS 1.3 with a certificate and key; with `--upload`, accept signed uploads |
| `resid-pkg upload <dir> <registry-url> <keyfile> [--ca F]` | pack, sign and upload a package to a registry served with `--upload` |
| `resid-pkg index list <registry>` | print the index |
| `resid-pkg index add <registry> <name> <version> <sha256-hex> <keyfile>` | vouch for an entry, re-signing the index |
| `resid-pkg index remove <registry> <name> <version> <keyfile>` | withdraw an entry, re-signing the index |
| `resid-pkg index verify <registry> <pubkey-hex>` | check the index signature, as a consumer will |

`serve` is the publish side of the same artifact layout a `[registry] url`
reads, and it is deliberately small: loopback only, `GET` and `HEAD`, no
directory listing, and no request path may name a file outside the
registry directory. `--port 0` (the default) binds an ephemeral port and
reports it, so `--port-file` is enough for a script to learn where to
point a client.

### Uploading

`serve --upload <keyring> --index-key <keyfile>` also accepts uploads.
The keyring is a directory of publisher public keys (`*.pub`, hex, as
`[signing] keyring` reads), and the index key is the registry's own
signing key, the one clients pin as `[registry] pubkey`.
`resid-pkg upload <dir> <url> <keyfile>` packs the package, signs its
hash with the publisher's key and sends it as
`PUT /pkg/<name>-<version>.resid-pkg`. The server:

- verifies the signature under a keyring key before it reads the archive
  (403 otherwise);
- requires the archive's own `resid.toml` to name the package and version
  in the path (400);
- never replaces a published version: the same archive again is a 200, a
  different one under that version is a 409;
- writes the archive, its `-sha256` and `-sig`, and re-signs the index with
  the index key (201).

Uploads run on one worker, so two never interleave their index writes.

A worked example, with resid-serial and resid-json as the packages (it is
`tests/registry.sh` in resid-json):

```sh
resid-pkg keygen alice.key alice.pub          # a publisher
resid-pkg keygen index.key index.pub          # the registry
mkdir keyring registry && cp alice.pub keyring/
resid-pkg serve registry --port 8080 --upload keyring --index-key index.key &
resid-pkg upload ../resid-serial http://127.0.0.1:8080 alice.key
resid-pkg upload ../resid-json http://127.0.0.1:8080 alice.key
```

An app then names only what it uses:

```toml
[registry]
url = "http://127.0.0.1:8080"
pubkey = "<contents of index.pub>"

[dependencies.resid-json]
version = "0.1.0"
```

and imports a module of it by package name, `import
"resid-json/json.resid";`. resid-json's own manifest gives resid-serial
both a `path` (its working copy, beside a checkout) and a `version`; in the
published copy the path is not there, so `resid-manifest build` takes
resid-serial from the registry too, verifies both against the signed index,
and pins both in `resid.lock`.
Over HTTPS, give `upload` the trust store: `--ca <PEM bundle or directory>`.
Storage goes through a `RegStore(T)` behavior (`store_get`, `store_has`,
`store_put`), with a directory as the shipped instance, so another backend
is one instance away.

`index add` refuses a hash that contradicts an archive already published
under that name and version, and both `index add` and `index remove`
require the key that signs the registry's index, because the signature
covers the whole file and there is no per-row signature to keep in step.

A dependency is accepted only when its hash is listed by a trusted
registry's signed index or its signature verifies under a pinned or
keyring key, and when its archive names the requested package and
version; see [Security](/Resid/tools/security/).
