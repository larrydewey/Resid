# Go port of Are We Fast Yet

Written for this suite from the Java reference (upstream commit in
`../upstream/COMMIT`), with the same algorithms, data and verification.
Standard library only, built with `go build` (gc); `rap.json` is the Json
document extracted from the Java source, embedded with `//go:embed`.

Choices an expert Go programmer would make, recorded so a reviewer can
challenge them:

- **Object graphs** (Richards, DeltaBlue, CD's red-black tree, Havlak) stay
  pointer graphs, as in the Java original: Go is garbage-collected, so the
  arena mapping of the Rust and Resid ports buys nothing idiomatic here.
- **Virtual dispatch**: Richards' task functions are closures over their
  data records; DeltaBlue's constraint subclasses are one struct switched by
  kind; Json's values are an interface.
- **CD** uses value types for `Vector2D`, `Vector3D` and call signs and a
  generic red-black tree (Go 1.18+ generics) keyed by a `compare` method.
- **Storage** builds `[]interface{}` trees, the closest match to Java's
  `Object[]`.
- **Havlak** keeps the reference's quirks (`findSet` relinks to the starting
  node's parent; `stepE` walks a set it may extend) and sums the 50
  discarded `findLoops` results so the optimiser cannot drop them.
- **DeltaBlue** skips the reference's `Vector.sort`, whose `swap` is
  unimplemented: it only ever sees lists already in order.
- The `native` profile sets `GOAMD64=v3`; gc has no further tuning flags.

## Reviewer

Not yet reviewed by a second Go programmer.
