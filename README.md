<div align="center">
    <img src="assets/logo.png" alt="Resid Logo" width="150px"></img>
    <p><strong>What Remains is What Matters</strong></p>
</div>

**Resid** (pronounced */ˈrɛz.ɪd/* or */ˈriː.zɪd/*) is an eager, compile-time programming language designed for **maximal authorized reduction of first-class knowledge**.

In Resid, compilation is not just translation—it is **knowledge reduction**. The compiler reduces all provable computation at compile time, leaving only irreducible residual work for the runtime. This ensures that the runtime is as small, predictable, and efficient as possible.

---

## Core Philosophy

> **Compilation is maximal authorized reduction of first-class knowledge.**

- **Everything begins as compile-time reducible.**
- The compiler reduces all provable computation.
- Unknown information must be explicitly introduced via `rt` or providers.
- **Residual computation** is the core that reaches runtime.
- **Knowledge is first-class**: values, types, constraints, proofs, and capabilities are all treated as reducible knowledge.
- **No ambient authority**: capabilities must be explicitly granted and can only be attenuated, never amplified.

---

## Key Features

### First-Class Knowledge
Values, types, constraints, behaviors, and provenance are all first-class entities. The compiler tracks their state (`KNOWN`, `EFFECT`, `RESIDUAL`, `INVALID`) to maximize reduction.

### First-Class Numeric Types
Every numeric width is a distinct nominal type with no subtyping:
- **Integer family**: `Int(8)` to `Int(512)`, `UInt(8)` to `UInt(512)`
- **Floating-point family**: `Float(16)` to `Float(128)` (widest; `Float(256)`/`Float(512)` are not part of the language)
- **Pointer-sized**: `ISize`, `USize`
- **Safe interoperability**: Automatic width widening based on range rules for mixed-width arithmetic (same-sign only).

### Sandboxing & Security
- **No ambient authority**: Capabilities form a lattice and travel with effects.
- **Policy ceiling**: The manifest defines the maximum capabilities for dependencies.
- **Source-level attenuation**: Import-time or block-level capability narrowing.
- **Transitive closure**: Attenuation applies to the entire dependency graph.
- **Package integrity**: Cryptographic signatures over source, dependencies, and capability requirements.

### Concurrency
- **Structured concurrency**: `spawn` requires explicit capability grants.
- **Mutable handles** are moved; immutable views are shareable.
- **Failure handling**: Child failures return `Result(RegionError)` to parent.

### Minimization Obligation
The compiler's primary performance goal is to:
1. Maximize compile-time reduction.
2. Minimize the residual surface reaching runtime.
3. Lower only what remains to efficient native code (LLVM).

### Self-Hosted Crypto & Tooling
The standard crypto library is written **in Resid itself** and compiled to native code by the Resid compiler:
- `lib/crypto.resid`: SHA-256, SHA-512, HMAC, PBKDF2, Base64, constant-time compare, OS randomness
- `lib/ed25519.resid`: full RFC 8032 Ed25519 signing and verification on `Int(256)`/`Int(512)` arithmetic

Tooling shipped today:
- `residc <file> [emit-ir|build|run]`: compiler driver (default checks only)
- `tools/resid-fmt`: canonical formatter
- `tools/resid-graph`: import/dependency graph visualization
- Stage-2 bootstrap compilers in `examples/` (lexer, parser, typechecker, codegen, driver — all written in Resid)

---

## Getting Started

### Hello, Resid!

```
// hello.resid
Int main() {
    println("hello from resid");
    return 0;
}
```

Run it:

    residc hello.resid run

A richer example lives at `examples/hello.resid`.

### Sandboxed Example

    import "http.resid" @requires(filesystem(readonly));

    sandbox (filesystem(readonly)) {
        // All code here sees only readonly filesystem
        // Network calls are permitted via import capability
        // but filesystem writes will fail at compile time
        // or become residual capability errors.
        let data = http.get("https://api.example.com");
        // fs.write("output.txt", data); // Hard error: capability missing
    }

### Residual Computation

    Int main() {
        // 'rt' introduces residual (runtime) knowledge
        rt Int x = unknown_value();

        // Compile-time check fails if x is residual
        // known(x); // Error: x is residual

        // Explicit residual check
        if (rt_known(x)) {
            // Safe to use x here in residual context
            return x;
        }
        return 0;
    }

---

## Installation & Build

### Prerequisites
- LLVM 22+
- Rust Edition 2024+

### Building from Source

    git clone https://github.com/your-org/resid.git
    cd resid
    cargo build --release

### Running the Compiler

    residc hello.resid build [-o out]   # build native binary (clang + tiny C runtime)
    residc hello.resid run              # build and run it
    residc hello.resid emit-ir          # print LLVM IR
    residc hello.resid                  # type-check only

---

## Project Structure

    resid/
    ├── crates/              # Compiler pipeline (Rust + LLVM)
    │   ├── resid-lexer      ├── resid-parser     ├── resid-ir
    │   ├── resid-type       ├── resid-codegen    ├── resid-builtin
    │   ├── resid-build      └── residc           # driver CLI
    ├── lib/                 # Standard library written in Resid
    │   ├── crypto.resid       # SHA-256/512, HMAC, PBKDF2, Base64, random
    │   ├── ed25519.resid      # Ed25519 sign/verify
    │   ├── der.resid          # DER parsing
    │   └── http.resid         # HTTP
    ├── examples/            # Self-hosted stage-2 compilers (.resid sources)
    ├── tools/               # fmt, graph, notes, cache, why
    └── PROGRESS.md          # Full build log, status, roadmap

---

## Contributing

Resid is a production-ready specification (v3.1). We welcome contributions in:
- Compiler implementation (LLVM lowering)
- Standard library development
- Tooling (LSP, formatter, debugger)
- Documentation

Please read `PROGRESS.md` for current status and roadmap before submitting a PR.

---

## License

This project is licensed under the MIT License. See `LICENSE` for details.

---

## Acknowledgments

Resid draws inspiration from languages like Rust, OCaml, and C++, but its core philosophy of **maximal authorized reduction** and **first-class knowledge** is unique.

---
