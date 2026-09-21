# Stage-0 seed

This directory holds a **frozen, versioned, checksummed** build of the
self-hosted Resid driver (`examples/driver.resid`), compiled by the last
Rust pipeline before it was archived (Phase D, `PLAN-resid-only.md`). It
is the root of the self-hosting chain:

```
stage0 (this binary) → D1 → D2 → D3 → ...
```

Each generation after stage0 is produced by having the *previous*
generation compile `examples/driver.resid` again — no generation after
this one ever depends on Rust, `cargo`, or anything under
`bootstrap/rust-stage0/` (the archived Rust pipeline). This binary exists
so that a machine with **no Rust toolchain at all** can still bootstrap
the Resid compiler from scratch: it only needs this binary and a C
compiler (`clang`, still a permanent accepted external dependency — see
`PLAN-resid-only.md`'s "Locked decisions").

## Provenance

| | |
|---|---|
| Source commit | `8259bbc` (`examples/driver.resid` unchanged from this commit — only `runtime/resid_rt.c` changed, see below) |
| Built from | `examples/driver.resid` + `runtime/resid_rt.c` (`resid_process_run` fix — see "2026-09-21 rebuild" below) |
| Built with | `cargo run -p residc -- examples/driver.resid build -o residc-seed-linux-x86_64 -rt runtime/resid_rt.c` (from `bootstrap/rust-stage0/`) |
| rustc | 1.98.0 (88d9e12ae 2026-08-18) |
| cargo | 1.98.0 (797e8a9bc 2026-08-05) |
| clang | 22.1.8 |
| Host | Linux x86_64 (`7.2.5-3-omarchy`) |
| SHA-256 | see `residc-seed-linux-x86_64.sha256` (regenerate/verify with `sha256sum -c` — see below) |

### 2026-09-21 rebuild: `resid_process_run` fix

The prior build (commit `4c2df0e`) linked against a `runtime/resid_rt.c`
where `resid_process_run` had been stubbed to always `return -1` (see
commit `ab4f9e7`, "harden C runtime against injection, overflow, path
traversal" — it closed a real `system(cmd)` shell-injection hole by
disabling the primitive outright). That broke self-hosted compilation
entirely: `examples/driver.resid`'s own `main()` calls `process.run(cmd)`
to invoke `clang` as its last step, for *every* self-hosted build, not
just its own. Symptom: a self-hosted `residc` writes the `.ll` file,
prints `clang failed`, and produces no binary.

Fix (this rebuild): `resid_process_run` now runs via `fork`+`execvp` on a
whitespace-split `argv`, never through a shell — this closes the same
injection vector (`;`, `&&`, `$(...)`, backticks, pipes all become inert
literal argv bytes) without disabling the primitive the compiler needs.
See `runtime/resid_rt.c` for the implementation and the commit that
introduced it.

Also fixed in this pass: `residc-seed-linux-x86_64.sha256` had drifted
from the actual committed binary (recorded hash didn't match
`sha256sum` of the binary in the same commit, `4c2df0e`) — regenerated
here to match.

**Verified:** this seed binary compiles `examples/driver.resid` into a
working D2, and that D2 typechecks, codegens, links (via the fixed
`process.run`), and runs a sample program correctly end-to-end.

### 2026-09-21, same rebuild: scalar-box allocation fix

While investigating why a D2→D3 self-compile of `driver.resid` was
using tens of GB of RAM (see "Known limitation" below), profiling with
an `LD_PRELOAD` malloc-counting shim found `resid_box_i64` alone
accounted for ~40% of all malloc bytes on a 34KB test source, at 15
million calls for that one file. Cause: `resid_box_i64`/`f64`/`bool`/
`i128`/`u128` each did **3 separate mallocs** to box one scalar (the
`ResidVal` struct, a 1-element `slots` array, and the payload) — under
glibc's allocator, each malloc call carries its own chunk-header
overhead, so boxing a single `bool` cost 3 allocations and a large
multiple of its 1 real payload byte, forever (this runtime never
frees — `resid_box_free`/`resid_struct_free` exist but are dead code,
never called from any `.resid` source or declared to codegen).

Fix: `resid_box_scalar_alloc` combines the struct, slots array, and
payload into one allocation, same external `r->slots[0]` pointer
contract. Measured effect (`examples/parser.resid`, 34KB): malloc call
count −39% (25.6M → 15.7M), peak RSS −6% (3.48GB → 3.28GB). Real and
safe, but not the dominant cost — see below.

### Known limitation: memory footprint on large self-compiles

Self-compiling `driver.resid` (471KB) via a self-hosted `residc` needs
tens of GB of RAM — reproduced here as ~46GB and still climbing when
killed by the kernel OOM-killer (`anon-rss:45963872kB`, cgroup limit
44G) on a 54GB machine. **This is not new and not a regression from
either fix above — it's already root-caused and tracked in depth: see
`PLAN-resid-only.md` Phase E ("Self-hosted compiler memory/performance
architecture") and `PROGRESS.md` §0a.** Short version, credited to that
prior work: `runtime/resid_rt.c`'s allocator never frees by design, and
`codegen.resid`'s `GT`/`ST` structs thread two large lists (`lines`,
`glines`) as *struct fields* through every sub-expression in the file —
invisible to the one narrow in-place-growth optimization that exists
(`crates/resid-type/src/growable.rs`, bare `List(T)` *parameters* only).
Empirically (per Phase E): RSS stays ~3.5GB through the whole typecheck
phase, then jumps past 40GB within ~2 minutes of entering codegen. The
101.4s/44.1GB figure in `PROGRESS.md` §0a is the current accepted
baseline after two rounds of real fixes (an O(n³) effect-checker
fixpoint, then an O(n²) `str_len` rescan) — the remaining memory cost is
architectural (needs a Perceus-style compile-time ownership/last-use
analysis, Phase E's E.1-E.4, so codegen's accumulator structs can be
freed in place instead of leaked on every rebuild) and was deliberately
deferred: "general perf work, not a self-hosting blocker" per that
plan's own resolution. Not something to redo here.

This session's `resid_box_scalar_alloc` fix above is a small, genuine
addition *on top of* that existing analysis (Phase E's cause list
doesn't cover the 3-mallocs-per-scalar overhead) — real but not the
dominant cost, consistent with Phase E's own conclusion that codegen's
`lines`/`glines` struct-field threading is what dominates, not scalar
boxing.

**Practical effect on this rebuild:** the D2→D3 fixed-point check
(`bootstrap_driver_self_compile_fixed_point` in
`bootstrap/rust-stage0/crates/residc/tests/e2e.rs`, `PLAN-resid-only.md`
Phase B) could not be completed interactively on this development
machine (shared with other running applications, not a dedicated build
host). D2 did successfully self-compile `driver.resid` into a D3 with a
`.ll` output byte-size matching D2's own before the OOM-kill hit during
the later provenance-signing step — evidence the fixed point likely
still holds, but not a substitute for actually running the test on a
machine with more free headroom (or with this build isolated from other
memory pressure).

## Verifying the checksum

```sh
sha256sum -c residc-seed-linux-x86_64.sha256
```

## Using it to bootstrap on a machine with no Rust

```sh
# Compile driver.resid itself with the frozen seed, producing a fresh D2:
./residc-seed-linux-x86_64 examples/driver.resid -o residc -rt runtime/resid_rt.c

# residc is now a self-hosted-built compiler with no Rust involvement.
# Compile anything else with it the same way:
./residc some_program.resid -o some_program -rt runtime/resid_rt.c
```

(`-rt` points at `runtime/resid_rt.c` — the permanent C runtime, linked
into every compiled Resid binary; not part of the archived Rust pipeline,
see the repo's top-level `README.md`. The binary in this directory was
itself built when that file still lived at `crates/residc/resid_rt.c`,
before `runtime/` existed — see "Provenance" above.)

## Rebuilding stage0 for a new host architecture

`crates/` (the Rust pipeline) is archived under `bootstrap/rust-stage0/`
(not actively maintained — see `PROGRESS.md` §6) specifically so a new
stage0 binary can still be built for a host architecture this one
doesn't cover. From `bootstrap/rust-stage0/`, run the same build command
shown above against that architecture's Rust/clang toolchain, then add
the new binary here following the `residc-seed-<os>-<arch>` naming convention
with its own `.sha256` file.
