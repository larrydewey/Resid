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
    println(f"{xs[2]}"); // 30
    println(f"{xs.len()}"); // 3
    return 0;
}
```

### Sandboxing & Security
See `SECURITY.md` for the threat model, each guarantee's enforcing code and tests, and what is not guaranteed.
- **No ambient authority**: every capability a function uses (directly, through calls, closures or behaviors) must be granted by its `@requires` or its sandbox, so authority starts at `main` (E0219).
- **Policy ceiling**: The manifest's per-dependency `capabilities` bound the dependency's code at compile time.
- **Source-level attenuation**: Import-time (`import "m" @requires(...)`) or block-level (`sandbox`) narrowing; nested sandboxes only narrow.
- **Transitive closure**: Attenuation applies to everything a restricted function calls, checked statically and again before each provider call at run time.
- **Package integrity**: Ed25519 signatures over the package archive's content hash (sources, manifest with dependencies and capabilities, lock file); unsigned packages are rejected outside a development profile.

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
- `lib/ed25519.resid`: RFC 8032 Ed25519 signing and strict verification on `Int(256)`/`Int(512)` arithmetic
- The TLS 1.3 client (`lib/tls*.resid`) does not authenticate servers against a trust store; see `SECURITY.md`

Tooling shipped today:
- `residc <file> [build|run|emit-ir]`: self-hosted compiler driver (default checks only). Built from `compiler/driver.resid` via the stage0 seed.
- `tools/resid-fmt.resid`: canonical formatter, self-hosted (`residc tools/resid-fmt.resid run -- <file>`)
- `tools/resid-graph.resid`, `tools/resid-why.resid`, `tools/resid-pkg.resid`, `tools/resid-manifest.resid`, `tools/resid-cose.resid`: call-graph, provenance query, and package-manager tooling, all self-hosted
- The self-hosted compiler in `compiler/` (graph parser, resolver, checker, reducer, lowering, codegen; `compiler/driver.resid` is the entry), written in Resid. It enforces capabilities (§19–21) statically and with a runtime force-time guard.
- The Rust pipeline that built the first seed was deleted on 2026-09-26 (it is in git history). A frozen stage-0 seed binary (`bootstrap/stage0/`) and the committed `build/boot/seed.ll` are the bootstrap roots.

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

    residc hello.resid run

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

    residc tools/resid-manifest.resid run -- build resid.toml residc

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
- LLVM 22+ (clang and lld for code generation and linking; libgcc for 128-bit division and Float(128) arithmetic). Binaries are static PIEs with no C library: the Resid runtime makes the Linux system calls itself.
- No Rust toolchain required for normal use

### Bootstrapping (from zero-Rust machine)

The frozen stage-0 seed binary lives at `bootstrap/stage0/residc-seed-linux-x86_64` (with `.sha256` checksum). It was built from `compiler/driver.resid` by the archived Rust pipeline and is the root of the self-hosting chain:

    # 1. Compile the self-hosted driver (D2) using the frozen seed. The seed
    #    predates the Resid runtime and links the old C runtime, which is in
    #    git history (runtime/resid_rt.c at commit 1878e16, before the port).
    ./bootstrap/stage0/residc-seed-linux-x86_64 compiler/driver.resid -o residc -rt resid_rt.c

    # 2. Use the self-hosted driver to compile programs (it links
    #    build/boot/rt.ll, or $RESID_HOME/rt.ll)
    ./residc hello.resid -o hello
    ./residc hello.resid run         # build + run
    ./residc hello.resid emit-ir     # print LLVM IR

### Running the Compiler (post-bootstrap)

Once you have a self-hosted `residc` (or any later generation):

    residc hello.resid build [-o out]   # build native binary (clang + the Resid runtime)
    residc hello.resid run              # build and run it
    residc hello.resid emit-ir          # print LLVM IR
    residc hello.resid                  # type-check only

### Rebuilding stage0 for a new host architecture

The compiler emits target-neutral LLVM IR text (no `target triple`; clang picks the target), so a new 64-bit architecture needs no Rust (nor a C library: add the system call numbers and the assembly helpers in `compiler/codegen.resid` for the target): cross-compile `compiler/driver.resid` on an existing host, link the IR with `clang --target=<triple>`, and check that `./boot.sh` reaches its fixed point on the new machine. Three things still tie the output to x86_64 and must become per-target first: the `target-features` string in `compiler/lower.resid`, the `resid_raw_syscall` lowering (x86 `syscall` inline asm) and the system call numbers in `runtime/rt/`, and the debugger's register layout in `runtime/rt/sys.resid`. Add the resulting binary and its `.sha256` to `bootstrap/stage0/`.

---

## Project Structure

    resid/
    ├── runtime/rt/          # the runtime, written in Resid (lowered to
    │                        #   build/boot/rt.ll, linked into every binary)
    ├── bootstrap/
    │   └── stage0/          # frozen, versioned seed binary — the bootstrap root
    │                        #   (see PLAN-resid-only.md Phase D)
    ├── lib/                 # Standard library written in Resid
    │   ├── crypto.resid       # SHA-256/512, HMAC, PBKDF2, Base64, random
    │   ├── ed25519.resid      # Ed25519 sign/verify
    │   ├── der.resid          # DER parsing
    │   └── http.resid         # HTTP
    ├── compiler/            # the self-hosted compiler (driver.resid is the entry)
    ├── examples/            # demo programs
    │   └── stack_types.resid  # fixed-capacity Str(N)/Bytes(N)/List(T,N)
    ├── tools/               # fmt, graph, why, pkg, manifest, cose — all self-hosted
    │                        #   .resid tools (the language server is `residc lsp`)
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
