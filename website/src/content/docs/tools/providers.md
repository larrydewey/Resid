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
| `read_some(File, n)` | `List(UInt(8))`: the next `n` bytes from the handle's offset, fewer only at the end of the file, empty there | read |
| `read_at(File, offset, n)` | `List(UInt(8))`: `n` bytes at `offset` (fewer at the end, empty past it); the handle's offset does not move | read |
| `size(File)` | `Int`: the file's size, `-1` when the handle is closed or not a regular file | read |
| `is_open(File)` | `Bool`: the handle holds an open file | read |
| `create(path)` → `File` | open for writing: created, or an existing file truncated | write |
| `create_new(path)` → `File` | open for writing only when nothing is at the path: an existing file, directory or symbolic link (even a dangling one) is refused | write |
| `write_handle(File, bytes)` | `Bool`: all of `bytes` (`List(Int)` or `List(UInt(8))`) at the handle's offset | write |
| `write_all(path, text)` | `Bool` | write |
| `write_bytes(path, bytes)`, `append_bytes(path, bytes)` | `Bool` | write |
| `write_hex(path, hex)`, `append_hex(path, hex)` | `Bool` | write |
| `write_secret(path, bytes)` | `Bool`: created readable by the owner only; a symlink is refused | write |
| `create_dir(path)` | `Bool` | write |
| `remove(path)` | `Bool` | write (a file or an empty directory) |
| `rename(from, to)` | `Bool` | write (atomic within one file system) |
| `size(path)` | `Int`: the size of the file at a path, without opening it (`size` takes a path or a `File`) | read (bytes; -1 when it cannot be read) |
| `modified_ms(path)` | `Int` | read (ms since the epoch; -1 likewise) |
| `read_range(path, off, n)` | `List(Int)` | read (up to `n` bytes at `off`; fewer at the end, none when it cannot be read) |
| `write_at(path, off, bytes)` | `Bool` | write (in place; the file created when missing; not durable until `sync`) |
| `sync(path)` | `Bool` | write (fsync: a file's data, or a directory's entries, reach the disk) |
| `truncate(path, len)` | `Bool` | write (cut, or extended with zeros, to `len` bytes) |

`filesystem(readonly)` grants the read verbs only.

A file is read or written **in pieces** through one `File`, so a large one
never has to be held in memory whole:

```resid
@requires(filesystem)
Int pump(File r, File w, Int total) {
    List(UInt(8)) piece = filesystem.read_some(r, 32768);
    if (piece.len() == 0) { return if (filesystem.is_open(r)) { total } else { -1 }; }
    if (!filesystem.write_handle(w, piece)) { return -1; }
    return pump(r, w, total + piece.len());
}
```

A `File` is a handle, not a value: copies of it name the same open file,
and `close` (or the end of a `with`) closes it for all of them. A `File`
dropped without either keeps its descriptor until the program exits, so
open one with `with` or close it on every path. An open that fails still
gives a `File`, one that `is_open` says is not open; every verb on it
fails (`false`, `-1` or an empty list). A write that fails returns
`false` and leaves the handle open; a *read* that fails closes it, after
returning the bytes read before the failure, so an empty piece from a
handle that `is_open` still is the end of the file, and one from a closed
handle is an error. `n <= 0` or a negative offset reads nothing and
leaves the handle as it was. Writes through a handle opened by `open`,
and reads through one opened by `create`, fail (the read closes it).
`create` follows a symbolic link at the path as `write_bytes` does;
`create_new` (`O_EXCL`) never does. Both make the file with mode 0666 less
the umask; secrets go through `write_secret` (owner-only), never
`write_handle` (`E0255`).

## environment, args, process

| Call | Returns | Family |
|---|---|---|
| `environment.get(name)` | the value, or `""` | `environment` |
| `environment.has(name)` | `Bool`: the variable is set, even to `""` | `environment` |
| `args.count()`, `args.get(i)` | the command line; `args.get(0)` is the program | `args` |
| `process.run(cmd)` | the exit status | `process` (a write) |

`process.run` runs a program directly (no shell) with its standard streams
inherited.

## network

| Builtin | Returns | Mode |
|---|---|---|
| `resid_tcp_connect(host, port)` | a connected socket, or -1; `host` is an IPv4 or IPv6 literal (brackets allowed) or a name, whose IPv6 and IPv4 addresses are tried in turn | read |
| `resid_tcp_send(fd, s)`, `resid_tcp_send_bin(fd, bytes)` | `Bool`; at most 1 MB of bytes per call | read |
| `resid_tcp_recv_all(fd)` | `Str`: everything until the peer closes, at most 4 MB | read |
| `resid_tcp_recv_bin(fd, n)` | `List(Int)`: exactly `n` bytes, zero-filled past EOF | read |
| `resid_tcp_recv_some(fd, max)` | `List(Int)`: what one receive returns, empty at EOF or timeout | read |
| `resid_tcp_listen(port)` | a listener on 127.0.0.1 (`0` = any free port), or -1 | read |
| `resid_tcp_listen_at(host, port)` | a listener on an interface address such as `"0.0.0.0"`, `"::"` (IPv6 and IPv4) or one IPv6 address, or -1 | write |
| `resid_tcp_bound_port(lfd)` | the port a listener bound | read |
| `resid_tcp_accept(lfd)` | an accepted connection, or -1 | read |
| `resid_tcp_shutdown(fd)` | `Bool`: no more sends; receives end 2 s from now | read |
| `resid_tcp_deadline(fd, ms)` | `Bool`: receives and sends end `ms` from now, however the bytes are paced; 0 clears | read |
| `resid_tcp_accept_now(lfd)` | a waiting connection, -2 when none is, -1 on failure; makes the listener non-blocking | read |
| `resid_tcp_poll(fds, wants, ms)` | `List(Int)`: per socket 1 readable, 2 writable, 4 deadline passed, 8 not a socket; waits at most `ms` (-1 no bound) and never past the nearest deadline | read |
| `resid_tcp_send_some(fd, bytes)` | `Int`: bytes sent without waiting, 0 when the buffer is full, -1 on error | read |
| `resid_tcp_peer(fd)` | `List(Int)`: the peer as `[n, address (n bytes), port_hi, port_lo]`, `n` 4 for IPv4 and 16 for IPv6; empty when `fd` is not a connected socket | read |
| `resid_tcp_close(fd)` | `Bool` | read |
| `resid_udp_open()` | a client UDP socket on every interface (IPv6 carrying IPv4 too, or IPv4 alone without IPv6), or -1 | read |
| `resid_udp_bind(port)`, `resid_udp_bind_at(host, port)` | a UDP socket on 127.0.0.1, or on an interface address (`"0.0.0.0"`, `"::"`, one address), or -1 | read, write |
| `resid_udp_send_to(fd, addr, port, bytes)` | `Bool`: one datagram to `addr` (4 or 16 bytes) | read |
| `resid_udp_recv_from(fd, max)` | `List(Int)`: one waiting datagram as `[n, address (n bytes), port_hi, port_lo, data...]` (an IPv4 sender is 4 bytes, also on an IPv6 socket), empty when none is waiting | read |

Sockets have a 30 s timeout on any one receive or blocked send, and a
connect gives up after 30 s (5 s for an address of a name when another
is left to try). Names are looked up in `/etc/hosts`, then with AAAA
and A queries to the nameservers of `/etc/resolv.conf` (IPv4 or IPv6). `network(readonly)` grants every row
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

## device

| Verb | Does | Mode |
|---|---|---|
| `device.ioctl(d, ...)` | one ioctl on the descriptor's device file | read, or write when the descriptor says so |
| `device.transact(d, cmd)` | one command and its response (a TPM) | as above |
| `device.transact_chain(d, cmds)` | up to 16 commands on one open file, handles linked between them | as above |
| `device.configfs_report(d, ...)` | a configfs-tsm attestation report | as above |
| `device.read_attr(d)`, `device.read_pci_attr(d, addr)` | a sysfs attribute, of a PCI function for the second | read |
| `device.mmio(d, access)` | one load or store in a device's mapped memory (a register); [register blocks](/Resid/reference/layouts/#register-blocks) write these calls | a load under a descriptor that does not write: read; otherwise as the descriptor says |
| `device.sequence(d, ...)` | a fixed sequence of the operations above | as above |

`d` is a descriptor from the standard library's `lib/dev/`, never one a
program writes itself (`E0260`); the compiler checks it and records it in
the provenance record, and each call runs in a fresh, confined device host.
Programs normally call the typed wrappers in `lib/dev/` (`sev_guest`,
`tdx_guest`, `nsm`, `tsm_report`, `tpm`, `pci_tsm`) instead. See
[Device access](/Resid/reference/devices/).

## Other families

`display` (the window-server builtins `resid_disp_*`), `declassify`
(publishing a [secret](/Resid/reference/secrets/)), `provision` (relying on
a provisioned key), `assume` (relying on an assumption instead of evidence)
and `native_<m>` (calling [native module](/Resid/reference/native-modules/)
`m`) are families without providers: each gates builtins or library calls,
and none has modes. See [Capabilities](/Resid/reference/capabilities/).

## Not capabilities

Printing (`print`, `println`, `eprintln`), reading standard input
(`resid_read_line()` for a line with its newline, `""` at end of input;
`resid_read_byte()` for one byte, `-1` at end of input), and OS randomness
are available to every function. Standard input is read through one 64 KB
buffer, so the two builtins can be mixed; reading `/dev/stdin` through
`filesystem` bypasses it.
