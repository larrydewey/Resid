---
title: Modules
description: Files as modules, pub, import forms, resolution and attenuation.
---

Every file is a module. Declarations are private unless marked `pub`.

```text
import "path/file.resid";                     // all pub names
import "path/file.resid" (name1, name2);      // selected names
import "path/file.resid" as M;                // qualified: M.name
import "path/file.resid" @requires(caps);     // attenuated
```

## Namespaces

Each module has its own names. When two imported modules export the same
name:

- `import "a.resid" as a;` qualifies it: `a.f()`, `a.Node`;
- a module's own declaration wins over imported ones;
- an unqualified use that could mean either import is an error at that use
  (`E0223`). A local binding of the same name is not a use.

A displayed type or variant keeps its plain name.

## Resolution

1. The path relative to the importing file.
2. A dependency listed in the project's dependency map (`resid-manifest`).
3. The standard library directory (`$RESID_HOME/../../lib`, or `lib/`
   under the current directory).

A module that cannot be found is an error (`E0221`). Each module is
compiled once, whichever file imports it first.

## Attenuation

An attenuated import compiles the module, and everything it imports,
inside `sandbox (caps)`: it can use at most those capabilities. A module
already imported without attenuation cannot be attenuated afterwards
(`E0216`); import it attenuated first. A manifest dependency is compiled
inside the capability ceiling its consumer's manifest lists.
