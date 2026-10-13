# C# port of Are We Fast Yet

Written for this suite from the Java reference (upstream commit in
`../upstream/COMMIT`); AWFY has no upstream C# port. Same algorithms, data
and verification. .NET 10, `dotnet build -c Release`, RyuJIT with its
defaults (tiered compilation, dynamic PGO); no NativeAOT, as Java runs on
HotSpot. `rap.json` is the Json document, an embedded resource.

Choices an expert C# programmer would make, recorded so a reviewer can
challenge them:

- **Object graphs** (Richards, DeltaBlue, CD's red-black tree, Havlak) stay
  class-based pointer graphs, as in Java.
- **Virtual dispatch**: DeltaBlue keeps the reference's constraint class
  hierarchy; Richards' task functions are delegates over data records.
- **CD** uses `readonly struct` for `Vector2D`, `Vector3D`, call signs,
  aircraft and collisions (Java has no value types), and a generic
  red-black tree over `IComparable<K>`.
- **Queues** (`Vector.removeFirst` in the reference) are `Queue<T>`.
- **Storage** builds `object[]` trees, as Java's `Object[]`.
- **Havlak** keeps the reference's quirks (`findSet` relinks to the starting
  node's parent; `stepE` walks a set it may extend) and sums the 50
  discarded `findLoops` results so the optimiser cannot drop them.
- **DeltaBlue** skips the reference's `Vector.sort`, whose `swap` is
  unimplemented: it only ever sees lists already in order.

## Reviewer

Not yet reviewed by a second C# programmer.
