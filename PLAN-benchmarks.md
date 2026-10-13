# Plan: an industry-normalized benchmark suite

The Computer Language Benchmarks Game suite (`bench/suite/`, report in
`docs/BENCHMARKS.md`) stays, but it moves to an appendix. Its programs are
small kernels, and none of them exercises what sets Resid apart:
compile-time reduction, capabilities, constant-time secrets, static
binaries with no libc, and provenance. The new suite leads with an
external, peer-reviewed benchmark and a measured trust/security bundle.
Every number in it has to be reproducible from one command.

## Decisions (2026-10-12)

- Headline: Are We Fast Yet (Tier 1) for credibility, together with the
  trust/security bundle (Tiers 3 and 4) as the differentiator. Tier 2
  (staged inputs) is a supporting section.
- Zig joins the opponent set in every tier.
- TechEmpower: local runs under its test rules first, submission to an
  official round once the results are stable.
- Fairness: public pull requests plus one named reviewer fluent in each
  language, credited in the cell's NOTES.md. A faster port is accepted at
  any time.

## Opponents

C, C++, Rust, Go, Zig, Java, C#, JavaScript. Python appears in Tiers 1
and 4 for context only. Fortran and Pascal stay in the CLBG appendix.

## Tier 1: Are We Fast Yet (general performance)

Marr, Daloze, Mössenböck, "Cross-Language Compiler Benchmarking: Are We
Fast Yet?" (DLS 2016). There are 14 benchmarks: DeltaBlue, Richards,
Json, CD, Havlak, Bounce, List, Mandelbrot, NBody, Permute, Queens,
Sieve, Storage and Towers. Their published rules restrict every port to
a core set of abstractions (objects, closures, arrays and strings; no
standard-library shortcuts), so the benchmark measures the compiler and
not the library.

- Reuse the upstream ports where they exist (C++, Java, JavaScript,
  Python). Write ports for Resid, Rust, Go, Zig and C#.
- Follow AWFY's harness protocol (inner iterations and warmup reporting)
  on top of our cold-process timings.
- Resid ports must show how they map AWFY's object model (mutable fields)
  onto immutable values. Each deviation gets one line in NOTES.md.

## Tier 2: staged inputs (reduction, judged fairly)

These workloads take one input that is known when the program is built
(a pattern, a rule table, a schema) and data that arrives at runtime.
Opponents get their own staging tools: C++ `constexpr` and templates,
Rust `const fn`, `build.rs` and macros, Zig `comptime`, Go
`go generate`, and generated-code baselines such as re2c and ragel.

- Candidates: regex search with a literal pattern (against RE2, the Rust
  `regex` crate and PCRE2-JIT), a rule-engine evaluator, a
  fixed-schema CBOR/JSON decoder (against serde and simdjson on-demand),
  and the ledger fee schedule.
- Opponents' designs are agreed with their reviewers before any Resid
  code is written.
- Build time is reported next to run time: reduction moves work into the
  compile, and the report must show that cost.

## Tier 3: systems and security workloads

- Cryptography, eBACS/SUPERCOP style (cycles per byte and per
  operation): SHA-256/512, AES-GCM, Ed25519, X25519, ECDSA P-256/P-384,
  HPKE. Opponents: OpenSSL, BoringSSL, aws-lc-rs/ring, RustCrypto, Go
  crypto, Zig std.crypto. Add a column "constant time mechanically
  checked" (our ctgrind gate; dudect or ct-verif where an opponent has
  one). Expect to lose to hand-written assembly and say so.
- TLS 1.3: handshakes per second and bulk throughput, all opponents
  pinned to `TLS_AES_128_GCM_SHA256` with x25519 (rustls, Go crypto/tls,
  OpenSSL).
- HTTP: TechEmpower `plaintext` and `json` rules, measured with wrk2 for
  latency at fixed offered load as well as peak throughput. Opponents:
  hyper/axum, Go net/http, h2o, Netty, a Zig server.
- Attestation: SNP report plus VCEK chain verifications per second,
  against go-sev-guest and the `sev` crate.

## Tier 4: footprint and trust metrics

- Startup time (hyperfine), static binary size, peak RSS, syscall count.
- Sandbox cost: the same program with and without `@requires` ceilings,
  and a native-module call against plain FFI (about 2 ms per call,
  reported as is).
- Reproducibility: byte-identical rebuilds on two machines (diffoscope),
  the DDC check through resid-ddc, provenance verification time.
- Compile time against rustc, g++, go and zig on comparable source.
  This is a known weakness and is reported anyway.

## Contract v2 (honesty and reproducibility)

1. No foldable inputs. Sizes, seeds and data come from argv, stdin or a
   file at run time. A guard run with a second input catches any build
   whose output does not follow its input. Tier 2 declares its
   build-time inputs explicitly.
2. Outputs are checked byte for byte, or by checksum, against the
   reference.
3. Two flag profiles per language: portable release and `native`. No PGO
   unless every language gets it.
4. Toolchains are locked (Nix flake or OCI image with pinned digests).
   The hardware manifest records core types, pinning, governor, SMT and
   THP, as now.
5. Statistics: repeated cold runs, medians with bootstrap 95% confidence
   intervals, geometric means, and per-benchmark tables. Losses are
   named in the abstract.
6. Ports outside upstream reference sets are reviewed by a fluent
   reviewer (see Decisions).
7. One command per tier (`bench.py run --tier N`). Raw results, the
   manifest and the Resid commit and stage2 hashes are published. A
   second machine (Intel or AArch64) reruns the headline tiers.

## Phases

1. Contract v2 and a tiered harness (`bench.py`), the foldable-input
   guard, and a rerun of CLBG under the guard to back the 0.85× result.
2. Tier 1: AWFY ports, recruiting reviewers.
3. Tier 4 metrics.
4. Tier 3: cryptography and TLS, then HTTP locally.
5. Tier 2: opponent designs agreed first, then the Resid side.
6. Report generator, second machine, publication. TechEmpower
   submission after that.

## Status (2026-10-12)

- Phase 1: Contract v2 (`bench/v2/CONTRACT.md`), `bench/v2/bench2.py` and
  the guard (`bench/suite/bench.py guard`, sizes no compiler can fold) are
  in. The CLBG rerun is deferred: it takes hours, so AWFY is the working
  measurement.
- Phase 2: all ten Tier 1 cells exist and verify at the ReBench sizes.
  Upstream, unchanged: C++, Java, JavaScript, Python; C is Rochus Keller's
  port (argv and result printing patched). Written here: Resid, Rust, Go,
  Zig, C# (each with a NOTES.md of choices for a reviewer to challenge).
  No reviewer is recruited yet. Resid is reported in two modes: runtime
  (inputs opaque through `rt`) and as-written (reduction allowed, build time
  shown, never presented as runtime speed).
- Phases 3-6 not started.
