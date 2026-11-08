# Plan: packed byte lists

Decided 2026-11-07 (with the user): **static packing.** A `List(UInt(8))`
(and `List(Secret(UInt(8)))`, which erases to it) is stored one byte per
element. Byte APIs in `lib/` move from `List(Int)` to `List(UInt(8))`.
`List(Int)` and every other list keep today's representation, so other
lists' hot paths (AWFY) are unchanged.

## Why

A byte held in a `List(Int)` takes an 8-byte slot. Every byte-heavy path
pays for it:

- **HTTP:** a 64 KB reply is 512 KB of slots. `rawify`, `memmove` and
  `memset` were 70% of the 64 KB path.
- **AES-GCM:** after the 16-byte builtins, about 30% of the time is
  writing 8-byte slots for 1-byte values.
- **Files and sockets:** `read_bytes` / `write_bytes` run 7-9x slower than
  `read_all` / `write_all`.
- **Hashing:** a hash reads four list slots per 32-bit word.

## Representation

- **Header:** the list header is as today (count, shift, root, type
  word). Type word **4** is "raw bytes": the root is a flat buffer
  `{used, cap, kept, bytes[cap]}`, with `used`, `cap` and `kept` counted
  in bytes.
- **Always flat:** a byte list is never a trie. An append past capacity
  copies into a buffer of twice the size, and a shared tip appends in
  place as flat lists do today.
- **Transient:** transient (owned, written in place) and frozen work as
  for flat lists: shift -2 / -1.

## Phases

### Phase 1: runtime

The `bl_*` byte paths, each a byte-slot twin of an existing list path:

- `new`, `get`, `with` (owned and shared), `push` / ListBuf push and
  finish;
- `concat`, `slice`, `fill`, `len`, iteration;
- equality, compare, hash (map keys), show;
- the loop and barrier moves (`list_move` on kind 4 copies bytes);
- `persist`, `freeze`, `thaw`.

The runtime's generic entry points (`show`, `compare`, `concat` reached
from generic code, `list_move`) dispatch on type word 4. The hot entry
points the compiler inlines are not touched: byte lists get their own.

Bulk builtins:

- `resid_bytes_from_str` / `to_str`;
- file read and write on a byte list (no conversion);
- `resid_tcp_send_some_at` / `recv_some` straight into byte lists;
- word loads (`be32`, `le64`, `be16` on 16 bytes);
- `xor16` on byte lists.

### Phase 2: compiler

- **Routing:** a list whose element type is `UInt(8)` (after secret
  erasure) lowers to the `bl_*` calls: index, `with` (owned in place),
  push, finish, len, slice, concat, literals (constant byte data in
  `.rodata`, copied on first use), `for x in xs`, `==`, f-string show and
  sort.
- **Ownership:** the in-place `with` / push paths apply to byte lists
  too.
- **Loop versioning:** the text matchers (`ol_*`, `orf_*`) skip byte
  lists, which is correct and only forgoes the optimization. A byte
  version comes later if a profile asks for it.

### Phase 3: library migration

**Revised 2026-11-07 (with the user): generic, no flag day.** The measured
scope of a hard flip was about 1,200 public signatures (`hex_encode` alone
has 465 call sites). Byte functions instead become generic over the
`Byte(B)` behavior (`lib/word.resid`: instances `Int` and `UInt(8)`), so
`List(Int)` callers keep compiling and `List(UInt(8))` callers get packed
storage; the hot paths move to `UInt(8)` inside. Packed public word
instances need their own word type (`Word(UInt(32), UInt(8))`): an
instance sharing `W` with `Word(Int, Int)` makes every W-only verb call
ambiguous. Generic copies now keep their `@needs` (substituted), so a
verb inside a copy resolves through them (`compiler/mono.resid`).

Done so far:

- `lib/wire.resid`: `Session` (the event loop's transport, used only by
  httpserv) carries `List(UInt(8))`; `lib/tlswire.resid` converts at that
  boundary, its record layer still `List(Int)`. `Wire` stays `List(Int)`:
  symbolon uses it generically, and changing it would break it.
- `lib/httpserv.resid`: the loop's buffers, framing and parser are packed;
  `HttpRequest.body`, `HttpReply.body` and `HttpStep.out` stay `List(Int)`
  and are converted once. `http_text` is generic.
- `resid_tcp_recv_some_u8`; the send builtins take either type.

Measured (one worker, 16 keep-alive clients): 64 KB replies 3.0-3.6k to
11.7-12.3k requests/s, server memory 64-72 MB to 26 MB; 1 KB replies +8%.

The original phase text follows, as the list of what remains.

### Phase 3 (original text): library migration (the API change)

1. Byte functions take and return `List(UInt(8))`, starting with the
   modules where bytes are the payload:
   - `crypto` (SHA-1/2, HMAC, HKDF, base64/hex)
   - `hash`, `sha*g`, `aesgcm*`, `chacha*`, `ed25519*`, `x25519`, `ecdsa`
   - `rsa*`, `hpke*`, `cose`, `cbor*`, `der`/`x509`/`chain`
   - `tls*`, `httpserv`, `wire`/`tlswire`, file and net helpers
2. Generic code already over `B`, with an instance `B = Int`, gets
   `B = UInt(8)` as the public instance.
3. Conversion helpers for callers that still hold `List(Int)`:
   `bytes_u8(List(Int))` and `bytes_int(List(UInt(8)))`.
4. Tests, examples, tools, and the website book and API reference move
   with it. `resid-book` regenerates the API pages.
5. Sibling packages that call these APIs move too: symbolon,
   resid-datastar, resid-json, resid-cbor and resid-serial (kept in step
   with lib/serial and lib/cbor).

### Phase 4: measure and harden

- **Measure:** HTTP 64 KB replies, AES-GCM 16 KB, SHA-256 / 512 1 KB,
  RSA, ECDSA, `read_bytes` / `write_bytes`, and the TLS handshake.
  Instruction counts and wall time against the pre-change build.
- **Gates:**
  - AWFY instruction counts unchanged (other lists untouched);
  - all 18 suites, ct (constant time) included;
  - the ownership fuzzer;
  - an adversarial review of every new runtime path (bounds, aliasing,
    secret mode, constant time).
- **Symbolon:** rebuilt and its tests run.

## Order and gates

Phases 1 and 2 land together behind one reseed, with conformance cases
for every byte operation and no library change. That proves the
representation on its own. Phase 3 then goes module by module, each step
building and passing its suite. Nothing is committed until the full suite
passes.

## Risks

- **Generic code:** `List(T)` code instantiated with `T = UInt(8)`.
  Every list operation in lowering must route by element type, and a
  missed site is a wrong read (8-byte load of a 1-byte slot). Mitigation:
  an assertion mode where every generic list entry point checks its type
  word, plus a fuzz case per operation.
- **Secret bytes:** constant-time behavior of the new paths (`tests/ct`
  covers them through the existing secret cases once the library uses
  them).
- **API break:** users of byte functions must convert. The migration
  notes go in the release notes and `docs/`.
