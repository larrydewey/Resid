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
| `terminal` | the terminal builtins (`resid_term_*`) and `lib/readline.resid` |
| `clock` | the `clock` provider and `lib/clock.resid` |
| `device` | the `device` provider: kernel devices through descriptors from `lib/dev/` ([device access](/Resid/reference/devices/)) |
| `display` | the display builtins (`resid_disp_*`): the window-server connection, its bytes and descriptors, shared memory and waiting (no modes) |
| `native_<m>` | calls into [native module](/Resid/reference/native-modules/) `m` (no modes) |
| `declassify` | `declassify(s, "reason")`: publishing a [secret value](/Resid/reference/secrets/) (no modes); each call is recorded on the graph with its reason |

Printing, reading stdin and OS randomness need no capability.

## Modes

`@requires` entries take the same modes as sandboxes: `readonly` or
`readwrite` (the default). A read-only grant does not cover a write
(filesystem write verbs, `process.run`, terminal raw mode, `clock.sleep_ns`,
a listener bound to an address other than loopback, and a device descriptor
whose `write` is true). An unknown family
or mode is an error (`E0213`).

`network(readonly)` covers connecting out, listening on 127.0.0.1,
accepting, sending and receiving. Binding a listener other machines can
reach (`resid_tcp_listen_at`, `http_listen_at`) is the one network write.

`display`, `declassify` and `native_<m>` have no modes at all:
`display(readonly)` is refused, like `native_m(readonly)` and
`declassify(readonly)`. A display descriptor is a socket, so
`resid_disp_poll` waits on one under `display` alone; waiting on display
and TCP descriptors together needs both families.

## Sandboxes and attenuation

```text
sandbox (filesystem(readonly)) {
    // declarations here, and everything they import, see only these
}
```

Nested sandboxes meet (only narrow); `sandbox ()` grants nothing. A
statically apparent requirement that exceeds a sandbox is a compile-time
error; a dynamic one fails when the provider call runs, because every
provider call is checked against the calling thread's sandbox frames. So
is `declassify`: a function, lambda or spawn body that declassifies checks
the grant against those frames when it is entered, so a closure that
publishes a secret fails inside a spawn or sandbox that dropped
`declassify`. A
handle may enter a sandbox only when every capability it requires fits.

### Closures

A closure carries no authority of its own. Its lambda's needs count
against the function that makes it, but its body runs under the frames
where it is *called*: a closure made in `main`, where `filesystem` is
granted, and called inside a sandbox or `spawn` that drops `filesystem`
fails at its provider call, exactly as a named function's body would.

```text
sandbox (args) {
    Int run_in(Int closure(Int) f, Int x) { return f(x); }
}

@requires(filesystem, args)
Int main() {
    Int closure(Int) f = lambda(v) { str_len(filesystem.read_all("in.txt")) + v };
    println(f"{f(1)}");          // runs: main holds filesystem
    println(f"{run_in(f, 1)}");  // aborts: capability not granted: filesystem
    return 0;
}
```

Inside a `spawn` the failure is the region's `Err`. A spawn body that calls
a closure *by the name it is bound to* is checked at compile time, since
the binding can hold nothing else: `spawn () { return f(1); }` above is
`E0214`. A closure reached any other way (passed to a function, kept in a
record) is checked when it runs.

## Manifests

A project manifest (`resid.toml`) caps what each dependency may receive:

```text
[dependencies.http]
path = "vendor/http"
capabilities = ["filesystem(readonly)", "network"]
```

Source code may only narrow this ceiling, never widen it. The rules that
keep a ceiling a ceiling:

- Each entry must be **grantable** under the manifest's
  `[capabilities] grant`, modes included: under
  `grant = ["filesystem(readonly)"]` a dependency may receive
  `filesystem(readonly)`, never `filesystem`.
- A dependency's ceiling for **its own** dependencies must fit inside the
  ceiling it was given, so authority only narrows down the tree.
- A dependency **declared twice** (by your manifest and by another
  dependency's) gets the meet of the ceilings, the narrowest per family,
  and every pinned key either declaration names must verify.

A dependency granted `device` can also be bounded to named device
descriptors, by descriptor or by device module:

```text
[dependencies.attest]
path = "vendor/attest"
capabilities = ["device(readonly)"]
devices = ["sev_guest", "tsm_report.report"]
```

Its code reaching any other descriptor is `E0261`; its own dependencies'
bounds must fit inside this one, and a second declaration narrows it.

## Diagnostics

| Code | Meaning |
|---|---|
| `E0219` | a function uses a capability it is not granted |
| `E0211` | a call exceeds the caller's sandbox ceiling (attenuation is transitive) |
| `E0212` | a region violation: a handle entering a sandbox it exceeds, or a write under a read-only grant |
| `E0213` | a malformed capability list: unknown family or mode |
| `E0214` | a `spawn` lists a capability its parent does not have, or its body (with what it calls, closures called by name included) uses one its list does not grant |
| `E0215` | a call inside a `spawn` needs a capability the region was not given |
| `E0216` | an attenuated import after the module was imported without attenuation |
| `E0218` | a provider call in a restricted region uses a family outside it |
| `E0220` | a compiler-internal primitive used outside the compiler's own sources |
| `E0260`–`E0264` | [device access](/Resid/reference/devices/): descriptors outside `lib/dev/`, a dependency's `devices` bound, unknown descriptors, inconsistent layouts, Sequence links |
