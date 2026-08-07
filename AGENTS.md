# Resid Language

Resid is an eager compile-time language: compilation is maximal authorized
reduction of first-class knowledge. This repo holds the language spec plus an
in-progress Rust/Cargo implementation.

- **Source of truth**: `resid_specification.txt` — the complete language spec (currently **v2.9 — Production Ready**). All design questions must be answered by consulting it.
- **Implementation**: Cargo workspace. Members under `crates/` (lexer, parser, ir, type, codegen, builtin, build, residc) and `tools/` (fmt, notes, cache, graph, why).
- **Status**: lexer 7, parser 10, resid-ir 9, resid-codegen 4 — **30 tests pass**. `resid-ir` implements the spec-§6 primitive numeric types and mixed-width widening. `resid-type` does type inference with widening + signed/unsigned mixing rejection. `resid-codegen` emits verified LLVM IR: functions, arithmetic, casts, calls, bool. The full workspace compiles against system LLVM 22 (inkwell `0.9` / `llvm22-1`).
- **Branch**: `master` (uncommitted).

When working here, consult `resid_specification.txt` first; the spec is the contract the implementation must satisfy. `residc <f> emit-ir` now runs the full pipeline (lex → parse → type → codegen → IR).