---
title: HTTP server
description: Serving HTTP/1.1 from Resid with lib/httpserv.resid, over TLS or not.
---

`lib/httpserv.resid` is an HTTP/1.1 server written in Resid over the TCP
builtins. It reads requests (with `Content-Length` or chunked bodies),
keeps connections alive, answers pipelined requests in order, routes paths,
and refuses malformed or oversized requests. The accept loop is an event
loop: it holds every connection at once and spends time only on those
with bytes to read or room to write, so a client that connects and stalls
costs a socket, not a worker. A handler may also stream its reply
(server-sent events). Parallelism comes from `spawn`: each region
runs the same loop on one listener, and the kernel hands every connection
to one of them.

## A server in one screen

A handler is a closure from `HttpRequest` to `HttpReply`. This program
starts one worker region, then talks to it over loopback:

```resid
import "httpserv.resid";

HttpReply hello(HttpRequest r) {
    Map(Str, Str) none = {};
    Map(Str, Str) m = http_route("/hello/:name", r.path) else { none };
    if (m.len() == 0) { return http_reply_status(404); }
    return http_reply_text(200, "text/plain", "hello, " + (m.get("name") else { "" }));
}

@requires(network(readonly))
Str fetch(Int port, Str path) {
    Int fd = resid_tcp_connect("127.0.0.1", port);
    _ = resid_tcp_send(fd, "GET " + path + " HTTP/1.1\r\nHost: x\r\nConnection: close\r\n\r\n");
    Str raw = resid_tcp_recv_all(fd);
    _ = resid_tcp_close(fd);
    Int at = str_index_of(raw, "\r\n\r\n", 0);
    return str_slice(raw, 9, 12) + " " + str_slice(raw, at + 4, str_len(raw));
}

@requires(network(readonly))
Int main() {
    Int lfd = http_listen(0);
    Int port = http_bound_port(lfd);
    Result(Int, RegionError) worker = spawn (network(readonly)) {
        return http_accept_loop(lfd, lambda(r) { hello(r) }, http_limits(), 2);
    };
    println(fetch(port, "/hello/world"));
    println(fetch(port, "/nope"));
    Int served = worker else { -1 };
    println(f"served {served}");
    return 0;
}
```

```text
200 hello, world
404 404 Not Found

served 2
```

`examples/http_server.resid` in the repository is a complete server:
command-line options, several workers, static files under a root
directory, and `--public` to listen on every interface.

```sh
residc examples/http_server.resid run -- --port 8080 --workers 4 --root site/
curl http://127.0.0.1:8080/hello/resid
```

## Capabilities

Everything a server does on connections it holds is `network(readonly)`:
listening on 127.0.0.1, accepting, receiving, sending and closing.
Binding an address other machines can reach is the one network write, so
it needs the full grant:

```resid
// expect-error: E0219
import "httpserv.resid";

@requires(network(readonly))
Int main() {
    Int lfd = http_listen_at("0.0.0.0", 8080);
    return 0;
}
```

The split lets a program bind its public listener in `main` under
`network` and run every worker, and every handler they call, under
`spawn (network(readonly))`. A handler that reads files lists that too:
`spawn (network(readonly), filesystem(readonly))`.

## Requests

| Field | What it holds |
|---|---|
| `method`, `target`, `version` | the request line; `target` is as sent |
| `path`, `query` | `target` split at the first `?` |
| `headers` | `Map(Str, Str)` with lower-cased names; repeated fields joined with `", "` |
| `body` | `List(Int)`, the decoded body (chunked coding removed) |
| `keep_alive` | whether the connection stays open after the reply |

Helpers: `http_header(r, name)` (any case, `""` when absent),
`http_body_text(r)` (UTF-8 decoded), `http_query_param(query, name)` and
`http_url_decode(s, form)`.

## Replies

| Function | Reply |
|---|---|
| `http_reply_text(status, content_type, text)` | a UTF-8 text body |
| `http_reply_bytes(status, content_type, bytes)` | a byte body |
| `http_reply_empty(status)` | no body |
| `http_reply_status(status)` | a plain-text error page, `"404 Not Found\n"` |
| `http_with_header(reply, name, value)` | `reply` with one more header |

The writer adds `Content-Length` and `Connection`. A `HEAD` reply, a 204
and a 304 carry no body.

## Routing

`http_route(pattern, path)` returns the captures of a match, or `None`. A
segment `:name` captures one percent-decoded path segment, and a final `*`
captures the rest of the path:

| Pattern | Path | Captures |
|---|---|---|
| `/users/:id` | `/users/42` | `id` = `42` |
| `/files/*` | `/files/a/b.txt` | `*` = `a/b.txt` |
| `/users/:id` | `/users/42/x` | no match |

## Limits and refusals

`http_limits()` allows 64 KiB of request head, 8 MiB of body, 1000
requests per connection, 30 s (`request_ms`) for a client to deliver
each whole request and 60 s (`reply_ms`) for it to take each reply, so a
slow, idle or non-reading client is disconnected, and 1024 open
connections per loop (`open_max`), past which the connection that has
waited longest for its request makes room for the newcomer; pass your own
`HttpLimits` to change them. A
refused request is answered and its connection closed:

| Status | When |
|---|---|
| 400 | a malformed request line or header, no `Host` in HTTP/1.1, `Transfer-Encoding` together with `Content-Length`, a bad or inconsistent `Content-Length`, obsolete line folding, a bad chunk |
| 413 | a body over the limit |
| 431 | a head over the limit |
| 501 | a transfer coding other than `chunked` |
| 505 | an HTTP version other than 1.0 and 1.1 |

Connections are closed by half-closing and draining first, so a client
that is still sending receives its error reply rather than a reset.

## Streamed replies

A handler can also answer with a stream: a head, then bytes as they are
made, which is what server-sent events need. Such a handler returns
`HttpOut(K)`, either `Whole(reply)` or `Stream(s)`, and is served by
`http_stream_loop` (`tls_stream_loop` over TLS). A stream is its first
step and a function from the stream's state `K` to the next step:

```resid
import "httpserv.resid";

// Three events, 10 ms apart; the state counts down.
HttpStep(Int) next(Int left) {
    if (left == 1) { return http_step_end(0, http_bytes("data: last\n\n")); }
    return http_step(left - 1, http_bytes(f"data: {left}\n\n"), 10);
}

HttpOut(Int) handle(HttpRequest r) {
    if (r.path != "/events") { return Whole(http_reply_status(404)); }
    HttpStream(Int) s = HttpStream { .status = 200, .headers = ["Content-Type: text/event-stream"],
        .first = http_step(3, http_bytes("data: first\n\n"), 10), .next = lambda(k) { next(k) } };
    return Stream(s);
}

@requires(network(readonly))
Int main() {
    Int lfd = http_listen(0);
    Int port = http_bound_port(lfd);
    HttpOut(Int) closure(HttpRequest) h = lambda(r) { handle(r) };
    Result(Int, RegionError) worker = spawn (network(readonly)) {
        return http_stream_loop(lfd, h, http_limits(), 1);
    };
    Int fd = resid_tcp_connect("127.0.0.1", port);
    _ = resid_tcp_send(fd, "GET /events HTTP/1.0\r\n\r\n");
    Str raw = resid_tcp_recv_all(fd);
    _ = resid_tcp_close(fd);
    print(str_slice(raw, str_index_of(raw, "\r\n\r\n", 0) + 4, str_len(raw)));
    Int served = worker else { -1 };
    println(f"served {served}");
    return 0;
}
```

```text
data: first

data: 3

data: 2

data: last

served 1
```

`http_step(state, bytes, wait_ms)` sends `bytes` and asks for the next step
after `wait_ms`; `http_step_end(state, bytes)` sends them and ends the
stream. The wait is the connection's deadline in the event loop, so a
stream costs a socket and no worker, and the loop still reads no clock. A
client that goes away ends its stream; one that stops reading is cut off
after `reply_ms`, as for any reply. Over HTTP/1.1 the body is chunked and
the connection stays open for the next request; over HTTP/1.0 the stream
ends with the connection. `HEAD` gets the head alone.

Bind the handler to a typed closure (`HttpOut(Int) closure(HttpRequest) h
= ...`) before passing it: the loop is generic in `K`, so a bare lambda
argument has no type to take. A whole-reply handler still goes to
`http_accept_loop`, which is this loop with every answer `Whole`.

[resid-datastar](https://github.com/larrydewey/resid-datastar) builds a
Datastar SDK on these streams.

## Serving over TLS

The same handler serves an encrypted connection. `lib/tlswire.resid` is
the TLS transport: it implements the `Wire(T)` and `Accept(T, C)`
behaviours `lib/httpserv.resid` declares, so nothing above this layer
changes.

```resid
// check-only: a server that needs server.key and server.pem and never exits
import "tlswire.resid";
import "tlskey.resid";
import "httpserv.resid";

HttpReply handle(HttpRequest r) {
    return http_reply_text(200, "text/plain; charset=utf-8", "hello over tls\n");
}

@requires(args, filesystem(readonly), network(readonly), declassify)
Int main() {
    Option(ServerKey) maybe_key = tls_key_load("server.key");
    Str err = match maybe_key { Some(k) => "", None => "cannot read the key" };
    if (err != "") { eprintln(err); return 2; }
    ServerKey key = maybe_key else { EdKey([]) };
    List(List(Int)) chain = tls_chain_load("server.pem");
    Int lfd = http_listen(8443);
    return tls_accept_loop(lfd, tls_cfg(key, chain, ["http/1.1"]), lambda(r) { handle(r) }, http_limits(), 0);
}
```

`examples/https_server.resid` is this with the HTTP example's routes,
static files and worker regions:

```
residc examples/https_server.resid run -- --cert server.pem --key server.key \
    [--alpn http/1.1] [--port N] [--public] [--workers N] [--root DIR] [--conns N]
```

| Function | What it does |
|---|---|
| `tls_key_load(path)` | PKCS#8 or SEC1, PEM or DER, Ed25519 or ECDSA P-256; `None` for anything else, including an unsupported curve |
| `tls_chain_load(path)` | the chain to present, leaf first: a PEM bundle or one DER certificate |
| `tls_key_cert_matches(key, leaf)` | whether the certificate carries the key, checked at startup |
| `tls_key_sign(key, content)` | a DER `ECDSA-Sig-Value` or 64 Ed25519 bytes |
| `tls_server_handshake(fd, key, chain, alpn)` | one handshake, returning the connection's keys |
| `tls_accept_loop(lfd, cfg, handler, lim, max_conns)` | accept, handshake, serve |
| `tls_stream_loop(lfd, cfg, handler, lim, max_conns)` | the same with a handler that may stream |

TLS 1.3 only, and `TLS_AES_128_GCM_SHA256` only: those are the versions
and suites this language can protect a record with. A client that does not
offer them is refused with an alert rather than served under something
else. The key share is x25519, drawn per handshake. No session ticket is
ever sent, so every connection pays a full handshake.

Reading the key is `filesystem(readonly)` and serving is
`network(readonly)`; the two are separate calls, so a server does not carry
the authority to read a private key just because it serves. Serving, and
`tls_key_cert_matches`, also need `declassify`: the private key and every
TLS secret are `Secret` values ([secret values](/Resid/reference/secrets/)),
and the handshake and record layer publish what goes on the wire (the key
share, the signature, ciphertext) and hand up what a record decrypts to.
A `spawn` that serves lists it too.

## Not included

There is no HTTP/2 server and no compression. TLS covers only what is above: no session
resumption, no client certificates, no RSA signing, no 0-RTT.
