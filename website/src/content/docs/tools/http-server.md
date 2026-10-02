---
title: HTTP server
description: Serving HTTP/1.1 from Resid with lib/httpserv.resid.
---

`lib/httpserv.resid` is an HTTP/1.1 server written in Resid over the TCP
builtins. It reads requests (with `Content-Length` or chunked bodies),
keeps connections alive, answers pipelined requests in order, routes paths,
and refuses malformed or oversized requests. Concurrency comes from
`spawn`: each worker region runs the same accept loop on one listener, and
the kernel hands every connection to one of them.

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

`http_limits()` allows 64 KiB of request head, 8 MiB of body and 1000
requests per connection; pass your own `HttpLimits` to change them. A
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

## Not included

There is no TLS server side yet: put a public server behind a proxy that
terminates TLS. There is no HTTP/2 server, no compression, and no read
deadline beyond each socket's 30 s receive timeout.
