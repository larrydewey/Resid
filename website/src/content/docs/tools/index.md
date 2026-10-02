---
title: Stdlib & Tools
description: The compiler and its companions, the standard library, providers, the editor, and the numbers.
---

Everything here is written in Resid and built by the Resid compiler.

| Tool | What it does |
|---|---|
| [`residc`](/Resid/tools/residc/) | the compiler, test runner, key manager, verifier and language server |
| [Standard library](/Resid/tools/stdlib/) | cryptography, TLS 1.3, HTTP, X.509, CBOR/COSE, DWARF, the graph reader, testing |
| [Providers](/Resid/tools/providers/) | the capability-gated interfaces to files, environment, arguments, processes and the network |
| [HTTP server](/Resid/tools/http-server/) | serving HTTP/1.1 with `lib/httpserv.resid`: requests, replies, routing, limits, worker regions |
| [Editor](/Resid/tools/editor/) | the VS Code extension and the language server |
| [resid-why, resid-graph, resid-debug](/Resid/tools/why-graph-debug/) | ask the knowledge graph what was reduced and why; debug by node |
| [resid-fmt, resid-pkg, resid-manifest](/Resid/tools/fmt-pkg/) | formatting, packages and manifests |
| [Security model](/Resid/tools/security/) | every security guarantee and how it is enforced |
| [Benchmarks](/Resid/tools/benchmarks/) | Resid compared with other languages |

The tools live in `tools/` of the repository. Build one with the compiler:

```sh
residc tools/resid-why.resid -o resid-why      # a release build: needs a key (residc keygen)
```
