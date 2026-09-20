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

### Fixed-Capacity Stack Types
`Str(N)`, `Bytes(N)`, and `List(T, N)` carry a statically known extent and are placed inline in the frame — **never heap-allocated**:
- Sized literals adopt the annotated capacity: `Str(8) s = "abc"`, `List(Int, 8) xs = [1, 2, 3]` (dense, zero-filled tail)
- Oversized literals are a compile-time error (no silent truncation)
- Capacity changes only via an explicit cast — bounded copy, truncating on the right
- Indexing is bounds-checked against the capacity (`resid_index_abort`)
- `Str(N) ↔ Str` and `Bytes(N) ↔ Bytes` are identity retypes over a NUL-terminated view; builtins like `println`/`str_len` accept them directly
- `List(T, N).len()` is the compile-time capacity

```resid
Int main() {
    Str(8) s = "hello";
    Bytes(4) b = b"abcd";
    List(Int, 3) xs = [10, 20, 30];
    println(s);                  // hello
    println(IntToString(xs[2])); // 30
    println(IntToString(xs.len())); // 3
    return 0;
}
```

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
- `residc-d2 <file> [build|run|emit-ir]`: self-hosted compiler driver (default checks only). Built from `examples/driver.resid` via the stage0 seed.
- `tools/resid-fmt.resid`: canonical formatter, self-hosted (`residc-d2 tools/resid-fmt.resid run -- <file>`)
- `tools/resid-graph.resid`, `tools/resid-why.resid`, `tools/resid-pkg.resid`, `tools/resid-manifest.resid`, `tools/resid-cose.resid`: call-graph, provenance query, and package-manager tooling, all self-hosted
- Stage-2 bootstrap compilers in `examples/` (lexer, parser, typechecker, codegen, driver — all written in Resid). The fused `examples/driver.resid` has full parity with the Rust `residc` pipeline, including sandbox/capability enforcement (§21) and its runtime force-time guard.
- The Rust pipeline (`bootstrap/rust-stage0/crates/`) is archived, not actively developed — see `PLAN-resid-only.md` Phase D and `PROGRESS.md` §6. A frozen stage-0 seed binary (`bootstrap/stage0/`) is the actual bootstrap root going forward.

---

## Getting Started

### Hello, Resid!

```
# hello.resid
Int main() {
    println("hello from resid");
    return 0;
}
```

Run it:

    residc-d2 hello.resid run

A richer example lives at `examples/hello.resid`. Fixed-capacity
stack types are demonstrated in `examples/stack_types.resid`.

### Multi-File Projects (Package Manager)

Resid has a self-hosted package manager (`tools/resid-manifest.resid`,
`tools/resid-pkg.resid`). A project uses a `resid.toml` manifest:

```toml
# resid.toml
[package]
name = "myapp"
version = "0.1.0"

[capabilities]
grant = ["filesystem", "network"]

[dependencies.http]
path = "../lib/http.resid"

[dependencies.crypto]
version = "0.2.0"
```

Build + run:

    residc-d2 tools/resid-manifest.resid run -- build resid.toml residc-d2 runtime/resid_rt.c

This resolves dependencies (local `path =` or versioned from a registry),
generates an import depmap, and invokes the compiler. The `resid.lock` file
pins resolved versions. See `tools/resid-manifest.resid` for all commands
(`deps`, `depmap`, `pack`, `sign`, `publish`).

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
- LLVM 22+ (clang for final linking)
- No Rust toolchain required for normal use

### Bootstrapping (from zero-Rust machine)

The frozen stage-0 seed binary lives at `bootstrap/stage0/residc-linux-x86_64` (with `.sha256` checksum). It was built from `examples/driver.resid` by the archived Rust pipeline and is the root of the self-hosting chain:

    # 1. Compile the self-hosted driver (D2) using the frozen seed
    ./bootstrap/stage0/residc-linux-x86_64 examples/driver.resid -o residc-d2 -rt runtime/resid_rt.c

    # 2. Use the self-hosted driver to compile programs
    ./residc-d2 hello.resid -o hello -rt runtime/resid_rt.c
    ./residc-d2 hello.resid run         # build + run
    ./residc-d2 hello.resid emit-ir     # print LLVM IR

### Running the Compiler (post-bootstrap)

Once you have a self-hosted `residc-d2` (or any later generation):

    residc-d2 hello.resid build [-o out]   # build native binary (clang + C runtime)
    residc-d2 hello.resid run              # build and run it
    residc-d2 hello.resid emit-ir          # print LLVM IR
    residc-d2 hello.resid                  # type-check only

### Rebuilding stage0 for a new host architecture

The archived Rust pipeline lives at `bootstrap/rust-stage0/` (not actively maintained). To build a fresh stage0 binary for a new architecture:

    cd bootstrap/rust-stage0
    cargo run -p residc -- ../../examples/driver.resid build -o residc-<os>-<arch> -rt ../../runtime/resid_rt.c

Add the resulting binary + `.sha256` to `bootstrap/stage0/`.

---

## Project Structure

    resid/
    ├── runtime/             # resid_rt.c — permanent C runtime, linked into every
    │                        #   compiled Resid binary (Rust-built or self-hosted)
    ├── bootstrap/
    │   ├── stage0/          # frozen, versioned seed binary — the actual bootstrap
    │   │                    #   root now (see PLAN-resid-only.md Phase D)
    │   └── rust-stage0/     # archived Rust pipeline (crates/), not actively
    │       └── crates/      #   developed — kept only to rebuild stage0 for a new
    │                        #   host architecture
    ├── lib/                 # Standard library written in Resid
    │   ├── crypto.resid       # SHA-256/512, HMAC, PBKDF2, Base64, random
    │   ├── ed25519.resid      # Ed25519 sign/verify
    │   ├── der.resid          # DER parsing
    │   └── http.resid         # HTTP
    ├── examples/            # Self-hosted stage-2 compilers + feature demos
    │   ├── driver.resid       # fused self-hosted compiler (typecheck+codegen)
    │   └── stack_types.resid  # fixed-capacity Str(N)/Bytes(N)/List(T,N)
    ├── tools/               # fmt, graph, why, pkg, manifest, cose — all self-hosted
    │                        #   .resid tools now; resid-lsp/resid-lsp-full stay Rust
    └── PROGRESS.md          # Full build log, status, roadmap

---

## Contributing

Resid is a production-ready specification (v3.3). We welcome contributions in:
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
