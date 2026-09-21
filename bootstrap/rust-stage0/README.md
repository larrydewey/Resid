# Archived — do not develop here

**This is the old Rust implementation of the Resid compiler. It is
archived, not actively maintained, and is not the project's source of
truth.** If you're looking for the compiler to read, extend, or fix a bug
in, it is almost certainly not this directory — see below.

## What this is for

The Resid compiler now self-hosts: it's written in Resid itself
(`examples/driver.resid` at the repo root, assembled from
`examples/typecheck.resid` + `examples/codegen.resid`). This directory
(`crates/`) is the prior Rust/LLVM (inkwell) implementation, kept for
exactly one purpose: **rebuilding `bootstrap/stage0/`'s frozen seed
binary for a new host architecture.** See
`bootstrap/stage0/README.md`'s "Rebuilding stage0 for a new host
architecture" section for that procedure. Nothing else in the project
depends on this code building, passing its tests, or being kept
up to date with the language.

## What NOT to do here

- **Don't add language features, fix compiler bugs, or "improve" this
  code.** Do that in `examples/typecheck.resid` / `examples/codegen.resid`
  (the self-hosted driver) instead — that's the real compiler.
- **Don't treat this crate's test suite as project CI.** It's a frozen
  snapshot; its own e2e suite (`crates/residc/tests/e2e.rs`) is kept
  around because some of it still exercises the stage0 rebuild path, not
  because this is where ongoing correctness work happens.
- **Don't use this as a reference implementation for "how Resid should
  behave."** Where this and the self-hosted driver disagree, the
  self-hosted driver is authoritative (see `PLAN-resid-only.md` Phase D).

See the repo-root `README.md` and `PROGRESS.md` §6 for the full picture
of why this was archived and what replaced it.
