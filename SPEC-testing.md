# Resid Test Framework Specification

## Vision
First-class testing built into the language: comptime discovery, fluent assertions, property-based testing, sandboxed execution. Tests are compiled, not interpreted.

---

## 1. Test Syntax

### 1.1 Inline Test Blocks
```resid
fn add(a: Int, b: Int) -> Int {
    a + b
}

test "add: identity" {
    expect(add(0, 5)).toEqual(5)
    expect(add(5, 0)).toEqual(5)
}

test "add: commutativity" {
    forall(x: Int, y: Int) {
        expect(add(x, y)).toEqual(add(y, x))
    }
}
```

### 1.2 Test Files (`*_test.resid`)
```resid
// math_test.resid
import "math.resid"

test_module "math" {
    // Registration happens here
    register("add: identity", || {
        expect(add(0, 5)).toEqual(5)
    })

    register_property("add: commutativity", || {
        forall(Int, Int, |x, y| expect(add(x, y)).toEqual(add(y, x)))
    })
}
```

### 1.3 Explicit Registration
```resid
type Test = { Str name; Fn(() -> Void) body; Bool is_property; }

var TEST_REGISTRY: List(Test) = []

fn register(name: Str, body: Fn(() -> Void)) {
    TEST_REGISTRY = TEST_REGISTRY.concat([{ .name = name, .body = body, .is_property = false }])
}

fn register_property(name: Str, prop: Fn(() -> Void)) {
    TEST_REGISTRY = TEST_REGISTRY.concat([{ .name = name, .body = prop, .is_property = true }])
}
```

### 1.4 Test Attributes (Optional Sugar)
```resid
#[test]
fn test_add_identity() { ... }

#[test_property]
fn test_add_commutativity() { ... }

#[test_suite(parallel = false)]
fn test_database_integration() { ... }
```

---

## 2. Fluent Assertions

### 2.1 Core API
```resid
type Expect[T] = { value: T }

fn expect[T](value: T) -> Expect[T] {
    { .value = value }
}

impl[T] Expect[T] {
    fn toEqual(self, expected: T) -> Void
    fn toNotEqual(self, expected: T) -> Void
    fn toBeTrue(self) -> Void  // for Bool
    fn toBeFalse(self) -> Void
    fn toBeNull(self) -> Void  // for Option
    fn toContain(self, item: T) -> Void  // for List, Set
    fn toHaveLength(self, len: Int) -> Void  // for List, Str
    fn toMatch(self, pattern: Str) -> Void  // for Str (regex)
    fn toThrow(self, error_type: Type) -> Void  // for Fn
    fn toBeCloseTo(self, expected: Float, precision: Int) -> Void
}
```

### 2.2 Rich Diffs
On failure, print:
```
expect(add(2, 3)).toEqual(6)
       │           │
       │           └── expected: 6
       └── actual: 5

Diff:
- 5
+ 6
```

For complex types (List, Map, Struct):
```
expect(user).toEqual(User { name: "Alice", age: 30 })

Diff:
User {
  name: "Alice"  (matches)
  age: 25        (expected 30)
        │
        └── difference: -5
}
```

### 2.3 Custom Matchers
```resid
fn toBeSorted[T: Ord](self: Expect[List[T]]) -> Void
fn toSatisfy[T](self: Expect[T], predicate: Fn(T) -> Bool, description: Str) -> Void
```

---

## 3. Property-Based Testing

### 3.1 Generators
```resid
type Gen[T] = { Str name; Fn(Seed) -> T generate; Fn(T, Int) -> List[T] shrink; }

fn gen_int(min: Int, max: Int) -> Gen[Int]
fn gen_uint(max: UInt) -> Gen[UInt]
fn gen_float(min: Float, max: Float) -> Gen[Float]
fn gen_bool() -> Gen[Bool]
fn gen_str(min_len: Int, max_len: Int, charset: Str = "ascii") -> Gen[Str]
fn gen_list[T](gen: Gen[T], min_len: Int, max_len: Int) -> Gen[List[T]]
fn gen_option[T](gen: Gen[T]) -> Gen[Option[T]]
fn gen_map[K, V](key_gen: Gen[K], val_gen: Gen[V], min_size: Int, max_size: Int) -> Gen[Map[K, V]]
fn gen_set[T](gen: Gen[T], min_size: Int, max_size: Int) -> Gen[Set[T]]

// Combinators
fn gen_one_of[T](gens: List[Gen[T]]) -> Gen[T]
fn gen_frequency[T](pairs: List<(Int, Gen[T])>) -> Gen[T]
fn gen_such_that[T](gen: Gen[T], predicate: Fn(T) -> Bool) -> Gen[T]
fn gen_map_gen[T, U](gen: Gen[T], f: Fn(T) -> U) -> Gen[U]
fn gen_flat_map[T, U](gen: Gen[T], f: Fn(T) -> Gen[U]) -> Gen[U]
```

### 3.2 Property Syntax
```resid
// Inline property test
test "add: associativity" {
    forall(gen_int(-1000, 1000), gen_int(-1000, 1000), gen_int(-1000, 1000), |a, b, c| {
        expect(add(add(a, b), c)).toEqual(add(a, add(b, c)))
    })
}

// Registered property
register_property("reverse: involution", || {
    forall(gen_list(gen_int(-100, 100), 0, 50), |list| {
        expect(reverse(reverse(list))).toEqual(list)
    })
})
```

### 3.3 Shrinking
On failure, automatically shrink to minimal counterexample:
```
Property failed: add(add(a, b), c) == add(a, add(b, c))
Counterexample after 47 shrinks:
  a = 1
  b = 0
  c = 0
Original: a = 1247, b = -892, c = 3001
```

### 3.4 Configuration
```resid
type PropertyConfig = {
    Int max_cases = 1000
    Int max_shrinks = 1000
    Int max_size = 100
    Seed seed = random()
}

fn check_property[T](config: PropertyConfig, gen: Gen[T], prop: Fn(T) -> Bool) -> PropertyResult

type PropertyResult = {
    Bool passed
    Option<T] counterexample
    Int cases_tested
    Int shrinks_performed
    Str failure_message
}
```

---

## 4. Comptime Test Discovery

### 4.1 Compile-Time Collection
Tests are discovered at compile time via comptime reflection:

```resid
// comptime: collect all `test` blocks and `register` calls
comptime {
    var tests = collect_tests(current_module())
    // tests: List<TestInfo>
    // TestInfo = { Str module; Str name; Bool is_property; Fn(() -> Void) body; }
}

// Generate test runner entry point
fn test_main() -> Int {
    var results = run_all_tests(tests)
    print_summary(results)
    return if results.all_passed { 0 } else { 1 }
}
```

### 4.2 TestInfo Metadata
```resid
type TestInfo = {
    Str module
    Str name
    Bool is_property
    Bool is_benchmark
    List<Str> tags
    PropertyConfig? property_config
    Fn(() -> Void) body
}
```

### 4.3 Filtering at Compile Time
```resid
// Only compile tests matching filter
comptime {
    var filtered = filter_tests(tests, "math.*")
    // Or: filter_tests(tests, tags = ["unit", "!slow"])
}
```

---

## 5. Test Runner

### 5.1 Execution Modes
```resid
type ExecutionMode = Parallel | Sequential

type SuiteConfig = {
    ExecutionMode mode = Parallel
    Int max_parallel = num_cpus()
    Duration timeout_per_test = 30s
    Bool sandboxed = true
    List<Str> required_caps = []
}
```

### 5.2 Sandbox Per Test
Each test runs in a capability-controlled region:
```resid
fn run_test(test: TestInfo, config: SuiteConfig) -> TestResult {
    sandbox(config.required_caps) {
        // Test executes here with only granted capabilities
        test.body()
    }
}
```

### 5.3 Parallel Execution
```resid
fn run_parallel(tests: List[TestInfo], config: SuiteConfig) -> List[TestResult] {
    var semaphore = Semaphore(config.max_parallel)
    var results = List[TestResult]()
    
    spawn_all(tests, |test| {
        semaphore.acquire()
        var result = run_test(test, config)
        semaphore.release()
        results.push(result)
    })
    return results
}
```

### 5.4 TestResult
```resid
type TestStatus = Passed | Failed | Skipped | Timeout | Panic

type TestResult = {
    TestInfo info
    TestStatus status
    Duration duration
    Option<Str> failure_message
    Option<Str> diff_output
    Option<PropertyResult> property_result
}
```

---

## 6. Snapshot Testing

### 6.1 Snapshot API
```resid
fn expect_snapshot[T: Show](value: T, name: Str) -> Void
fn update_snapshots() -> Void  // CLI flag: --update-snapshots
```

### 6.2 Snapshot Storage
```
tests/
  snapshots/
    math_test.add_identity.snap
    math_test.add_commutativity.snap
    codegen_test.hello_world.ll.snap
```

### 6.3 Diff on Mismatch
```
Snapshot mismatch: codegen_test.hello_world.ll
--- expected (snapshot)
+++ actual
@@ -1,5 +1,5 @@
 define i64 @main() {
-  ret i64 42
+  ret i64 43
 }
```

---

## 7. CLI Interface

### 7.1 Commands
```bash
# Run all tests
residc test

# Run tests matching pattern
residc test --filter "math.*"
residc test --filter "tags:unit,!slow"

# Run specific test file
residc test math_test.resid

# Update snapshots
residc test --update-snapshots

# Run with custom parallelism
residc test --parallel 4

# Run sequentially
residc test --sequential

# Property test config
residc test --max-cases 10000 --max-shrinks 5000

# Output formats
residc test --format tap
residc test --format junit
residc test --format json
residc test --format pretty  # default
```

### 7.2 Exit Codes
- `0`: All tests passed
- `1`: Tests failed
- `2`: Compile error
- `3`: Internal error
- `124`: Timeout

### 7.3 Output Formats
**Pretty (default):**
```
math_test
  ✓ add: identity (2ms)
  ✓ add: commutativity (47 cases, 15ms)
  ✓ add: associativity (1000 cases, 234ms)

codegen_test
  ✓ hello_world (1.2s)

Failures: 0 | Passed: 4 | Duration: 1.4s
```

**TAP:**
```
TAP version 13
1..4
ok 1 math_test.add: identity
ok 2 math_test.add: commutativity
ok 3 math_test.add: associativity
ok 4 codegen_test.hello_world
```

**JUnit XML:** Standard format for CI.

---

## 8. Benchmarks (First-Class)

```resid
#[bench]
fn bench_add_1m() {
    var sum = 0
    for i in 0..1_000_000 {
        sum = add(sum, i)
    }
    // Auto-measured: ns/op, MB/s, allocations/op
}

#[bench_config]
fn bench_config() -> BenchConfig {
    { .iterations = 100, .warmup = 10, .outlier_threshold = 0.05 }
}
```

Output:
```
bench_add_1m:  45.2 ns/op  (σ=2.1)  12.3 MB/s  0 allocs/op
```

---

## 9. Coverage

```bash
residc test --coverage
# Generates: coverage.json, coverage.html
```

---

## 10. Implementation Phases

### Phase 1: Core (Week 1-2) — DONE
- [x] Test syntax parsing (inline blocks, test files) — `test "name" { ... }`
      is rewritten to a plain declaration before any other pass runs
      (`td_desugar`, examples/codegen.resid); the rewrite never adds or
      removes a newline, so diagnostics keep their line numbers.
- [x] Explicit registration runtime — `TestCase`/`test_case`/`run_tests` in
      lib/testing.resid, bodies held as zero-argument closures. Registration
      does NOT use a mutable global registry as §1.3 sketches: the language
      has no mutable globals, so the case list is ordinary data the caller
      passes to `run_tests`.
- [x] Fluent `expect()` assertions with basic diffs — the full §2.1 matcher
      set plus §2.3's `toSatisfy`; failures report actual vs expected.
- [x] Comptime test collection — discovery happens in the compiler, which
      emits the `main` that runs what it found (§4.1's `test_main`).
- [x] `residc test` command — `--filter`, `--format pretty|tap|json`, and
      §7.2 exit codes 0/1/2.

Phase 1 deviations from the spec as written, all forced by the language:
- Spec examples are in a Rust-flavoured syntax (`fn`, `|a, b|`, `var`,
  `Expect[T]`). The implementation uses Resid syntax: `lambda(a, b) { ... }`,
  `Ret closure(Args)`, `type T = { ... };`.
- `toThrow()` takes no error-type argument (§2.1 shows `toThrow(error_type)`):
  Resid has no exception types, so the matcher asserts only that calling the
  receiver aborted.
- `toMatch` uses a documented regex SUBSET — `^ $ . * + ? [...]` with ranges
  and negation. No alternation, groups or backreferences.
- Per-test isolation is an abort catch, not a process or thread boundary, so
  a test that corrupts memory still takes the runner down with it.

### Phase 2: Property Testing (Week 2-3) — NOT STARTED
- [ ] Generator library (`gen_int`, `gen_list`, combinators)
- [ ] Shrinking algorithm
- [ ] Property runner with config
- [ ] Integration with test registration

### Phase 3: Runner & Sandbox (Week 3-4) — PARTIAL
- [ ] Parallel/sequential execution (runs sequentially; §11's deterministic
      alphabetical ordering is also not implemented — tests run in source
      order)
- [ ] Sandbox per test (capability integration)
- [ ] Timeout handling (so exit code 124 is never produced)
- [x] Output formats: pretty, TAP, JSON. JUnit XML is not implemented.

### Phase 4: Snapshots & Polish (Week 4-5) — PARTIAL
- [ ] Snapshot testing with diffs
- [ ] `--update-snapshots` flag
- [x] Filtering by name (`--filter`, a regex over the test name). Tag and
      module filtering are not implemented — tests carry no tags yet.
- [ ] Benchmarks
- [x] Documentation (this section, plus lib/testing.resid's header)

Known limitation: `--filter` reaches the test binary through the environment
and process.run has no shell, so a filter containing a space is split and
will not match.

---

## 11. Design Decisions (Final)

| Aspect | Decision |
|--------|----------|
| **Test location** | Inline `test { ... }` + `*_test.resid` files |
| **Discovery** | Explicit registration in `test_module` |
| **Assertions** | Fluent `expect(actual).toEqual(expected)` with structural diffs |
| **Execution** | Configurable parallel/sequential per suite |
| **Isolation** | Configurable per suite: process (integration) or thread + sandbox (unit) |
| **Ordering** | Deterministic (alphabetical) by default |
| **Fixtures** | Hierarchical: `before_all` → `before_each` → test → `after_each` → `after_all` |
| **Mocking** | Built-in mock library (`expect().toReturn()`, `spy()`, `mock()`, `verify()`) |
| **Property testing** | Native: generators, shrinking, `forall(gen, ... \|a,b\| { ... })` |
| **Comptime discovery** | Yes — `collect_tests()` at compile time generates `test_main()` |
| **Sandboxing** | Per-test via capability system (`resid_cap_enter/leave`) |
| **Snapshots** | `expect_snapshot()` + `--update-snapshots` |
| **Benchmarks** | First-class `#[bench]` with ns/op, MB/s, allocs/op |
| **Filtering** | `--filter "name.*"`, `--filter "tags:unit,!slow"` |
| **Flaky detection** | `--repeat N` with statistical threshold |
| **IDE integration** | Full: test lens, gutter icons, output panel |
| **Test deps** | Both: capability sandbox + service registry (DB lifecycle) |
| **Workspace** | `residc test --workspace` discovers all `*_test.resid` |
| **Incremental** | Hash-based (test + deps) — skip unchanged |
| **CI sharding** | `--shard 1/4` + CI env auto-detection |
| **Coverage** | `--coverage` flag → `coverage.json/html` |
| **Output formats** | Pretty (default), TAP, JUnit XML, JSON |
| **Killer features** | Property-based testing + Comptime discovery |

---

## 12. Example: Complete Test File

```resid
// list_test.resid
import "list.resid"
import "testing.resid"

test_module "list" {
    // Unit tests
    register("empty list has length 0", || {
        expect(List(Int)()).toHaveLength(0)
    })

    register("push increases length", || {
        var list = List(Int)()
        list = list.push(1)
        expect(list).toHaveLength(1)
        expect(list[0]).toEqual(1)
    })

    // Property tests
    register_property("push/pop roundtrip", || {
        forall(gen_list(gen_int(-100, 100), 0, 50), |list| {
            var l = list
            for x in list {
                l = l.push(x)
            }
            for _ in list {
                var popped = l.pop()
                expect(popped.is_some()).toBeTrue()
            }
            expect(l).toHaveLength(0)
        })
    }, { .max_cases = 500 })

    register_property("sort is idempotent", || {
        forall(gen_list(gen_int(-1000, 1000), 0, 100), |list| {
            expect(sort(sort(list))).toEqual(sort(list))
        })
    })

    // Snapshot test
    register("format snapshot", || {
        var list = [1, 2, 3].push(4).push(5)
        expect_snapshot(list.format(), "list_format")
    })
}
```

---

## 13. Integration with Capabilities

```resid
// Test requiring filesystem
#[test(requires = ["filesystem.read", "filesystem.write"])]
fn test_file_roundtrip() {
    sandbox(["filesystem.read", "filesystem.write"]) {
        // test code
    }
}

// Test requiring network
#[test(requires = ["network.tcp"])]
fn test_http_client() {
    sandbox(["network.tcp"]) { ... }
}

// Test requiring nothing (pure)
#[test]
fn test_pure_function() { ... }
```

---

## 14. Migration Path

1. Existing Rust e2e tests → port to `examples/*_test.resid`
2. Run both in CI during transition
3. Drop Rust e2e once coverage matches

---

*End of SPEC*