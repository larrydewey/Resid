---
title: Providers
description: The capability-gated interfaces to the outside world.
---

A **provider** is how authorized external knowledge enters a program.
Calling one is an effect, needs its capability family, and is checked
twice: at compile time (`E0219`) and again, before it runs, against the
calling thread's sandbox frames.

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

The TCP builtins (`resid_tcp_connect(host, port)`, `resid_tcp_send`,
`resid_tcp_recv_all`, `resid_tcp_close` and their byte variants) need
`network`. `lib/http.resid` and `lib/tls.resid` are built on them.

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
