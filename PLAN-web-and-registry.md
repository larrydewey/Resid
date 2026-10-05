# Web and Registry Plan

> **STATUS: step 2 done (2026-10-03) except `resid build` fetching https itself, which is a compiler memory problem; `tools/resid-fetch.resid` reaches a TLS registry today.** Agreed order of work
> after the TLS client, trust store and provenance verification. Each step
> is a forcing function for the next: the server needs byte I/O and
> listening, the registry needs the server, TLS and serialization.

**Goal**: a package registry that is a Resid program end to end: served
over HTTPS by a Resid HTTP server, with signed uploads, an index written
through `resid-serial`, and packages that are themselves fetched through it.

---

## 1. HTTP/1.1 server — done

- `lib/httpserv.resid`: request parsing, `Content-Length` and chunked
  bodies, keep-alive and pipelining, `http_route`, `HttpLimits`, and the
  request-smuggling shapes refused (see `SECURITY.md`, HTTP server).
- `examples/http_server.resid`: worker regions sharing one listener,
  static files, `--public`.
- Runtime: `resid_tcp_listen_at`, `resid_tcp_recv_some`,
  `resid_tcp_shutdown` in `runtime/rt/net.resid`.
- Capabilities: `network` takes modes. `network(readonly)` covers
  everything but binding a non-loopback address, which is the one write.
- Tests: `tests/http/run.sh`, conformance `network_readonly_loopback` and
  `err_network_readonly_listen`. Docs: site page `tools/http-server`.

## 2. TLS server side — done, except the registry transport

- `lib/tlsserver.resid`: the server handshake over an accepted socket --
  ClientHello, ServerHello, EncryptedExtensions, Certificate,
  CertificateVerify, Finished, then the client's Finished checked. Every
  refusal is an alert (`ts_alert_for`), never a silent close.
- `lib/tlsmsg.resid` (server half): ClientHello parsing and the four
  flight messages. The transcript is anchored on the received
  ClientHello bytes, so a field this server does not read is still hashed.
- `lib/tlskey.resid`: what a server signs with -- PKCS#8 or SEC1, PEM or
  DER, Ed25519 or ECDSA P-256 -- plus `tls_key_cert_matches`, so a
  certificate and a key that disagree are refused at startup.
- `lib/ec256.resid`: `ecdsa_sign_k` and the DER `ECDSA-Sig-Value`
  encoding, with a nonce drawn per signature (rejection sampling in
  `[1, N-1]`, never reused) and low-s normalisation. Verified against
  `openssl dgst -verify`.
- The transport seam: `lib/httpserv.resid` now declares `Wire(T)` and
  `Accept(T, C)` and runs its connection path over them, with the plain
  transport as one instance; `lib/tlswire.resid` is the TLS instance. The
  same handler serves both, and the plain path is unchanged for callers
  (`http_accept_loop` keeps its signature).
- `examples/https_server.resid`: the routes and static files of
  `examples/http_server.resid` over TLS.
- ALPN, so `http/1.1` is negotiated rather than assumed.
- Tests: `tests/tls/run.sh` gained the server side (key loading,
  certificate/key match, pinned signatures, ClientHello parsing against a
  captured real openssl 3.6 hello) and live handshakes -- this
  repository's client against this repository's server, and `openssl
  s_client` when openssl is installed, including a TLS 1.2 refusal.

Open questions, answered while doing it:

- **Private-key file mode.** There is no stat verb, so a permission check
  is not expressible; the key file's mode is the operator's job
  (`SECURITY.md`).
- **Session resumption**: no. No ticket is ever sent, so every connection
  pays a full handshake -- the safe direction to be wrong in.
- **Where the handshake's leftover bytes go.** They are handed back in
  `TlsKeys.pending`: a client that pipelines its first request right after
  the handshake has those bytes in the socket before the server is ready,
  and re-reading the socket loses them.
- **`resid_tcp_recv_bin` reads *exactly* n bytes and zero-pads.** The
  handshake has to use `resid_tcp_recv_some`, whose comment says as much.
- **`resid_tcp_recv_bin` is for known lengths.** Nothing in the record
  layer may use it to "read what is there".

### The client half — done, with one compiler-sized exception

`lib/tlsclient.resid` is the client: the handshake, `Wire(TlsClient)`, and
`tls_https_get` (one GET, Content-Length required, 64 MB cap). Verified
against `openssl s_server` and against this repository's own server, in
one process (`tests/tls/client.resid`).

Fetching over https into `resid build` is where this stops:

- Importing `lib/tlsclient.resid` into `tools/resid-manifest.resid` sends
  the compiler past 20 GB in reduce. The same import in a small program
  is unremarkable inside 4 GB, so it is the module graph against the
  manifest's size, not the client. Raising `RESID_MEM_LIMIT` would move
  the cost onto every machine that resolves a dependency, so it is not a
  fix.
- So `tools/resid-fetch.resid` is the bridge: one artifact over https,
  authenticated, SHA-256 printed, and `[registry] path` pointed at the
  directory. Every signature and hash check stays where it was -- an
  `https://` registry is reached, not trusted.
- `url = "https://..."` in a manifest stays refused until the reduce
  memory profile can carry the client inside the manifest's own compile.
  That is step 5 work with the compiler, not a transport gap.

## 3. Serialization into the ecosystem

- `resid-serial` and `resid-json` become the first real packages
  published to and fetched from a registry, instead of sibling checkouts.
- The registry index moves from its line format to JSON through
  `Encode`/`Decode`, signed as today (the signature covers the bytes).
- `resid-skill` and the site document the package workflow with these as
  the worked example.

## 4. Registry v2

- Authenticated publish: an upload is a signed archive, checked against
  the publisher keyring before it is written; `index add` rules apply
  (no hash that contradicts an archive already published).
- Served over TLS by `lib/httpserv.resid`. Done 2026-10-04: `resid-pkg
  serve` is a thin wrapper over `lib/httpserv.resid` (four workers,
  deadlines, no 1 MiB artifact cap); TLS for it is still
  `examples/https_server.resid`.
- Storage behind a behavior, so a directory and other backends are
  interchangeable.

## Known issues found along the way

- `Int(N)` is a *signed* N-bit type, so `>>` sign-fills. The EC code
  treats `Int(256)` as an unsigned bit pattern (which is why it has its own
  `ec_ge`); anything that shifts a scalar has to avoid `>>`, which is why
  `ec_low_s` decides the low-s question by watching `2*s` wrap instead.
- Authority analysis: a top-level function named like a built-in method
  (`get`) gets an authority edge from every `m.get(k)`, including inside
  imported libraries (`gk_user_ref` in `compiler/gcheck.resid` matches
  method names without the receiver type). Codegen is correct; the effect
  is a spurious E0219 only.
- Done 2026-10-04: per-request read and reply deadlines
  (`HttpLimits.request_ms`, `reply_ms`; `resid_tcp_deadline` in the
  runtime), and a 30 s bound on any one blocked send on every socket.
- Done 2026-10-04: the accept loop is an event loop (`resid_tcp_poll`,
  `Session(S, C)`, `open_max` eviction), so stalled clients no longer hold
  workers; clients (`tls_https_get`, `resid-fetch --timeout`,
  `lib/http.resid`, the `http://` registry fetch) have a whole-exchange
  deadline, and connect gives up after 30 s.
