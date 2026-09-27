---
title: Capabilities and sandboxes
description: "The authority model: @requires, families, modes, transitive checking, sandboxes and manifests."
---

Resid has **no ambient authority**. Every capability family a function
uses must be granted to it, by its own `@requires` or, when it has none, by
its enclosing sandbox (`E0219`).

A function *uses* what its provider calls and effectful builtins use, and
what every function it calls, wraps in a closure, or runs as a behavior
(a `sort` comparator, a `Show` instance) uses or declares. Authority
therefore enters a program only at `main` or a `test` block.

## Families

| Family | Grants |
|---|---|
| `filesystem` | the `filesystem` provider |
| `environment` | the `environment` provider |
| `args` | the `args` provider |
| `process` | `process.run` and the native debugger builtins |
| `network` | the TCP builtins |

Printing, reading stdin and OS randomness need no capability.

## Modes

`@requires` entries take the same modes as sandboxes: `readonly` or
`readwrite` (the default). A read-only grant does not cover a write
(filesystem write verbs, `process.run`). An unknown family or mode is an
error (`E0213`).

## Sandboxes and attenuation

```text
sandbox (filesystem(readonly)) {
    // declarations here, and everything they import, see only these
}
```

Nested sandboxes meet (only narrow); `sandbox ()` grants nothing. A
statically apparent requirement that exceeds a sandbox is a compile-time
error; a dynamic one fails when the provider call runs, because every
provider call is checked against the calling thread's sandbox frames. A
handle may enter a sandbox only when every capability it requires fits.

## Manifests

A project manifest (`resid.toml`) caps what each dependency may receive:

```text
[dependencies.http]
path = "vendor/http"
capabilities = ["filesystem(readonly)", "network"]
```

Source code may only narrow this ceiling, never widen it.

## Diagnostics

| Code | Meaning |
|---|---|
| `E0219` | a function uses a capability it is not granted |
| `E0211` | a call exceeds the caller's sandbox ceiling (attenuation is transitive) |
| `E0212` | a region violation: a handle entering a sandbox it exceeds, or a write under a read-only grant |
| `E0213` | a malformed capability list: unknown family or mode |
| `E0214` | a `spawn` lists a capability its parent does not have |
| `E0215` | a call inside a `spawn` needs a capability the region was not given |
| `E0216` | an attenuated import after the module was imported without attenuation |
| `E0218` | a provider call in a restricted region uses a family outside it |
| `E0220` | a compiler-internal primitive used outside the compiler's own sources |
