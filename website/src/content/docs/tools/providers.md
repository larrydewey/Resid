---
title: Providers
description: The capability-gated interfaces to the outside world.
---

A **provider** is how authorized external knowledge enters a program.
Calling one is an effect, needs its capability family, and is checked
twice: at compile time (`E0219`) and again, before it runs, against the
calling thread's sandbox frames.

## clock

| Verb | Signature | Mode |
|---|---|---|
| `now_ns()` | `Int`, nanoseconds since the Unix epoch (1677-09-21 … 2262-04-11) | read |
| `now_sec()` | `Int`, whole seconds over the whole range of `Int` | read |
| `monotonic_ns()` | `Int`, from an unspecified origin; immune to a clock step | read |
| `sleep_ns(ns)` | `Int`, the part still unslept after an interruption, `-1` for a request that makes no sense | **write** |

`lib/clock.resid` wraps these as `clock_now()`, `clock_monotonic_ns()`,
`clock_sleep_ms()` and friends, and is the only place in the standard
library that reads the clock. Reading it is an effect like any other: the
answer to "what time is it" is knowledge the program does not have. See
[capabilities](../reference/capabilities/).

## filesystem

| Verb | Signature | Mode |
|---|---|---|
| `read_all(path)` | `Str` | read |
| `read_bytes(path)` | `List(Int)` | read |
| `exists(path)`, `is_dir(path)` | `Bool` | read |
| `list_dir(path)` | `List(Str)` | read |
| `sha256(path)` | `List(Int)`, 32 bytes, without loading the file | read |
| `open(path)` → `File`, `read_handle(File)` → `Str`, `close(File)` | | read |
| `write_all(path, text)` | `Bool` | write |
| `write_bytes(path, bytes)`, `append_bytes(path, bytes)` | `Bool` | write |
| `write_hex(path, hex)`, `append_hex(path, hex)` | `Bool` | write |
| `write_secret(path, bytes)` | `Bool`: created readable by the owner only; a symlink is refused | write |
| `create_dir(path)` | `Bool` | write |

`filesystem(readonly)` grants the read verbs only.

## environment, args, process

| Call | Returns | Family |
|---|---|---|
| `environment.get(name)` | the value, or `""` | `environment` |
| `args.count()`, `args.get(i)` | the command line; `args.get(0)` is the program | `args` |
| `process.run(cmd)` | the exit status | `process` (a write) |

`process.run` runs a program directly (no shell) with its standard streams
inherited.

## network

| Builtin | Returns | Mode |
|---|---|---|
| `resid_tcp_connect(host, port)` | a connected socket, or -1 | read |
| `resid_tcp_send(fd, s)`, `resid_tcp_send_bin(fd, bytes)` | `Bool`; at most 1 MB of bytes per call | read |
| `resid_tcp_recv_all(fd)` | `Str`: everything until the peer closes, at most 4 MB | read |
| `resid_tcp_recv_bin(fd, n)` | `List(Int)`: exactly `n` bytes, zero-filled past EOF | read |
| `resid_tcp_recv_some(fd, max)` | `List(Int)`: what one receive returns, empty at EOF or timeout | read |
| `resid_tcp_listen(port)` | a listener on 127.0.0.1 (`0` = any free port), or -1 | read |
| `resid_tcp_listen_at(host, port)` | a listener on an interface address such as `"0.0.0.0"`, or -1 | write |
| `resid_tcp_bound_port(lfd)` | the port a listener bound | read |
| `resid_tcp_accept(lfd)` | an accepted connection, or -1 | read |
| `resid_tcp_shutdown(fd)` | `Bool`: no more sends; receives time out after 2 s | read |
| `resid_tcp_close(fd)` | `Bool` | read |

Sockets have a 30 s receive timeout. `network(readonly)` grants every row
marked read: exposing a port to other machines is the only write.
`lib/http.resid`, `lib/httpserv.resid` and `lib/tls.resid` are built on
these builtins.

## terminal

| Builtin | Returns | Mode |
|---|---|---|
| `resid_term_is_tty(fd)` | `Bool`: fd 0, 1 or 2 is a terminal | read |
| `resid_term_cols()`, `resid_term_rows()` | the window size (80 x 24 when unknown) | read |
| `resid_term_raw()` | `Bool`: stdin in raw mode (no echo, no line editing, no signal keys) | write |
| `resid_term_restore()` | `Bool`: stdin back to the settings `resid_term_raw` saved | write |

`terminal(readonly)` grants the queries only. The runtime restores the
terminal when `main` returns and on an uncaught abort. `lib/readline.resid`
is built on these builtins.

## Not capabilities

Printing (`print`, `println`, `eprintln`), reading standard input
(`resid_read_line()` for a line with its newline, `""` at end of input;
`resid_read_byte()` for one byte, `-1` at end of input), and OS randomness
are available to every function. Standard input is read through one 64 KB
buffer, so the two builtins can be mixed; reading `/dev/stdin` through
`filesystem` bypasses it.
