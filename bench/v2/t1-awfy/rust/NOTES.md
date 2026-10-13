# Rust port of Are We Fast Yet

Written for this suite from the Java and C++ references (upstream commit in
`../upstream/COMMIT`), with the same algorithms, data and verification.
Built with plain `rustc` (no crates); `src/rap.json` is the Json document
extracted from the Java source.

Choices an expert Rust programmer would make, recorded so a reviewer can
challenge them:

- **Object graphs** (Richards, DeltaBlue, CD's red-black tree, Havlak) are
  arenas: `Vec`s of structs linked by index, the idiomatic alternative to
  `Rc<RefCell<..>>`, and the same mapping the Resid port uses.
- **Virtual dispatch** (DeltaBlue's constraint subclasses, Richards' task
  functions) is an `enum` matched by kind.
- **List** returns references into lists the caller owns (`tail` only ever
  returns an existing list), not reference-counted nodes.
- **Json** keeps `current` as a one-character `&str` slice of the input
  (the reference's `substring`).
- **CD** uses `f64::sin`/`cos` from the standard library, as C++ and Java
  use theirs.
- **Havlak** keeps the reference's quirks (`findSet` relinks to the starting
  node's parent; `stepE` walks a set it may extend) and sums the 50
  discarded `findLoops` results so the optimiser cannot drop them.
- **DeltaBlue** asserts the reference's `Vector.sort` precondition.

## Reviewer

Not yet reviewed by a second Rust programmer.
