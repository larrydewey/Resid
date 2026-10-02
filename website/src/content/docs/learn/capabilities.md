---
title: Capabilities
description: No ambient authority. @requires, capability families and modes, sandboxes and attenuated imports.
---

A Resid function cannot touch the outside world unless it is **granted the
authority**. Reading a file, reading an environment variable, running a
process or opening a socket each needs a *capability*, declared with
`@requires`:

```resid
@requires(filesystem(readonly))
Int count_lines(Str path) {
    Str text = filesystem.read_all(path);
    return str_count(text, "\n");
}

@requires(args, filesystem(readonly))
Int main() {
    Str path = if (args.count() > 1) { args.get(1) } else { "/etc/hostname" };
    println(f"{path}: {count_lines(path)} line(s)");
    return 0;
    // check-only
}
```

The rule is checked **transitively**: a function needs every capability
used by anything it calls, including through closures and behaviors. So
authority enters a program only where `main` (or a `test` block) declares
it, and you can read a function's signature to know what it can do.

```resid
Str home() {
    return environment.get("HOME");   // error: home() is not granted `environment`
}

Int main() {
    println(home());
    return 0;
    // expect-error: E0219
}
```

Printing to stdout and stderr, reading stdin and OS randomness are not
capabilities.

## Families and modes

| Family | Grants |
|---|---|
| `filesystem` | the `filesystem.*` provider: `read_all`, `write_all`, `read_bytes`, `write_bytes`, `append_bytes`, `write_secret`, `exists`, `is_dir`, `list_dir`, `create_dir`, `sha256`, `open` / `read_handle` / `close` |
| `environment` | `environment.get(name)` |
| `args` | `args.count()`, `args.get(i)` |
| `process` | `process.run(cmd)` and the native debugger builtins |
| `network` | the TCP builtins |
| `terminal` | the terminal builtins (`resid_term_*`) and `lib/readline.resid` |
| `clock` | `clock.now_ns()`, `clock.now_sec()`, `clock.monotonic_ns()`, `clock.sleep_ns(n)` and `lib/clock.resid` |

A family can be narrowed with a mode: `filesystem(readonly)` covers the
reading verbs only; a write needs `filesystem` or `filesystem(readwrite)`.
`terminal(readonly)` covers the TTY and window-size queries but not raw
mode. `clock(readonly)` covers reading the clock but not sleeping: reading
time observes it, sleeping consumes it. `network(readonly)` covers
connecting out and everything a server does on a loopback listener; only
binding an address other machines can reach needs the full `network`, so a
server's worker regions can run with `network(readonly)`.

## Sandboxes

A region of code can be limited further. Everything declared inside a
`sandbox`, and everything it imports, sees at most the listed capabilities:

```text
sandbox (filesystem(readonly)) {
    // code here can read files, and nothing else
}
```

An import can be attenuated the same way:

```text
import "vendor/parser.resid" @requires(filesystem(readonly));
```

Authority can only be narrowed across these boundaries, never widened.
The [security model](/Resid/tools/security/) lists every guarantee and how
it is enforced.
