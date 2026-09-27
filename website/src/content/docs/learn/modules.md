---
title: Modules
description: Imports, pub, selective and qualified imports, the standard library.
---

A file is a module. Its declarations are private unless marked `pub`:

```resid
// geometry.resid
type Point = { Int x; Int y; };

pub Int dist2(Point a, Point b) {
    Int dx = a.x - b.x;
    Int dy = a.y - b.y;
    return dx * dx + dy * dy;
}
```

Import it by path, relative to the importing file:

```text
import "geometry.resid";             // every pub name
import "geometry.resid" (dist2);     // only these
import "geometry.resid" as G;        // qualified: G.dist2(a, b)
```

An import that is not found beside the importing file is looked up in the
**standard library** (`lib/` of the Resid installation), so
`import "crypto.resid";` works anywhere. A missing module is an error
(`E0221`).

An import can also be **attenuated**: the module and everything it
imports run with at most the listed capabilities, even if it asks for more:

```text
import "http.resid" @requires(network);
```

See [Capabilities](/Resid/learn/capabilities/) and
[Modules](/Resid/reference/modules/) in the reference.
