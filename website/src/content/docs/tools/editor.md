---
title: Editor support
description: The VS Code extension and the residc language server.
---

## VS Code

`editors/vscode` in the repository is the extension:

- highlighting for the whole language (numeric widths, fixed-capacity
  types, f-strings, raw and byte strings, capabilities, behaviors);
- snippets for functions, types, `match`, `with`, `spawn`, sandboxes and
  more;
- bracket matching, comment toggling and folding;
- the language server.

Install it from the repository:

```sh
cd editors/vscode
npm install
npm run compile
npx @vscode/vsce package
code --install-extension resid-lang-0.3.0.vsix
```

| Setting | Default | |
|---|---|---|
| `resid.lsp.enable` | `true` | run the language server |
| `resid.compilerPath` | `""` | the compiler; empty finds `build/boot/stage2.bin` in the workspace, then `residc` on `PATH` |

## The language server

The language server is the compiler: `residc lsp` speaks the Language
Server Protocol on standard input and output, running the compiler's own
front end (import resolution, parsing, resolution and checking) on the
editor's unsaved buffer. It provides:

- **diagnostics** on open, change and save: the compiler's own errors,
  with their codes, in the file they occur in (including imported files);
- **hover**: the definition's signature, its `///` documentation and the
  expression's type;
- **go to definition**, across imports and into the standard library;
- **document symbols**: functions, types, behaviors and tests;
- **completion** of keywords and top-level names.

Any editor with an LSP client can use it: configure the command
`residc lsp` for `.resid` files. Each request is handled in its own
memory arena and open documents live in memory files, so the server's
memory stays flat over a long session; checking the compiler's own 8,000
lines takes under half a second.
