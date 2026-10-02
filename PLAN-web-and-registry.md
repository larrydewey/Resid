# Web and Registry Plan

> **STATUS: step 1 done (2026-10-02); step 2 next.** Agreed order of work
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

## 2. TLS server side — next

- Server handshake in `lib/tls.resid` / `lib/tlsmsg.resid`: ServerHello,
  EncryptedExtensions, Certificate, CertificateVerify, Finished.
- Loading a certificate chain (PEM or DER) and a private key; signing
  CertificateVerify with ECDSA P-256 and Ed25519 (RSA-PSS signing later:
  only verification exists today).
- ALPN, so `h2` can be negotiated once an HTTP/2 server exists.
- `lib/httpserv.resid` over TLS: the same handler type on an encrypted
  connection.
- Tests over committed fixtures, as `tests/tls` does: the existing client
  handshakes against the new server in one process, and an openssl
  `s_client` case when openssl is installed.
- Then the registry transport stops refusing `https://` (`SECURITY.md`,
  Packages), still never downgrading to plaintext.

Open questions: private-key file format and permissions check (reuse
`filesystem.write_secret`'s owner-only rule on read?); whether session
resumption is in scope (proposed: no).

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
- Served over TLS by `lib/httpserv.resid`; `resid-pkg serve` becomes a thin
  wrapper over it.
- Storage behind a behavior, so a directory and other backends are
  interchangeable.

## Known issues found along the way

- Authority analysis: a top-level function named like a built-in method
  (`get`) gets an authority edge from every `m.get(k)`, including inside
  imported libraries (`gk_user_ref` in `compiler/gcheck.resid` matches
  method names without the receiver type). Codegen is correct; the effect
  is a spurious E0219 only.
- No per-connection read deadline in the server beyond the socket's 30 s
  receive timeout, so slow clients can hold workers.
