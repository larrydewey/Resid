# Web and Registry Plan

> **STATUS: done (2026-10-05). Steps 1-4 shipped; the JSON index was dropped by decision.** Agreed order of work
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

Done 2026-10-05: `resid-manifest` fetches an `https://` registry itself,
with `[registry] ca` naming the trust store (required; no store is a
refusal). The reduce blowup that kept the client out of the manifest tool
is gone: the tool now builds in about 2 s at about 400 MB.

## 3. Serialization into the ecosystem — done (2026-10-05), index format kept

- Done: `resid-serial`, `resid-json` and the other format packages import
  each other by package name (`import "resid-serial/serial.resid";`,
  resolved beside the dependency's root through the depmap and compiled
  inside its ceiling), so they build the same from a checkout or from a
  registry. Their test runners use `resid-manifest depmap`, which
  `./install.sh` now installs beside `residc` (with `resid-pkg` and
  `resid-fetch`).
- Decided against (2026-10-05): moving the index to JSON. The core tools
  would depend on packages that are themselves fetched from a registry;
  the signed line format stays.

## 4. Registry v2 — done (2026-10-05)

- Authenticated publish: `serve --upload <keyring> --index-key <key>` and
  `resid-pkg upload`; the signature is checked against the publisher
  keyring before the archive is read, a version is never replaced, and
  the index is re-signed by the registry's key.
- Served over TLS by `lib/httpserv.resid` (`--cert F --key F`), uploads
  included.
- Storage behind `RegStore(T)` (`store_get`, `store_has`, `store_put`),
  `DirStore` shipped.

## Known issues found along the way

- `Int(N)` is a *signed* N-bit type, so `>>` sign-fills. The EC code
  treats `Int(256)` as an unsigned bit pattern (which is why it has its own
  `ec_ge`); anything that shifts a scalar has to avoid `>>`, which is why
  `ec_low_s` decides the low-s question by watching `2*s` wrap instead.
- Done 2026-10-05: a top-level function named like a built-in method
  (`get`) no longer gets an authority edge from `m.get(k)` on a Map: the
  checker records the method calls a built-in method took (`TL.bm`) and
  `gk_user_ref` skips them.
- Done 2026-10-04: per-request read and reply deadlines
  (`HttpLimits.request_ms`, `reply_ms`; `resid_tcp_deadline` in the
  runtime), and a 30 s bound on any one blocked send on every socket.
- Done 2026-10-04: the accept loop is an event loop (`resid_tcp_poll`,
  `Session(S, C)`, `open_max` eviction), so stalled clients no longer hold
  workers; clients (`tls_https_get`, `resid-fetch --timeout`,
  `lib/http.resid`, the `http://` registry fetch) have a whole-exchange
  deadline, and connect gives up after 30 s.
