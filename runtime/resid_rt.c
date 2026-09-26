/*
 * resid_rt.c — minimal bootstrap runtime linked into every native Resid
 * binary produced by `residc build|run`.
 *
 * This is bootstrap glue: it lets Resid programs observe the outside world.
 * Providers, standard-library types, and a full runtime will replace these as
 * the compiler self-hosts.
 *
 * Note: `print`/`println` may eventually move behind a capability, but for the
 * bootstrap stage the kernel allows them unconditionally.
 */
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#ifdef __GLIBC__
#include <malloc.h>
#endif
#include <stdint.h>
#include <time.h>
#include <execinfo.h>
#include <string.h>
#include <limits.h>
#include <pthread.h>
#include <setjmp.h>
#include <sys/random.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/stat.h>
#include <errno.h>
#include <dirent.h>
#include <libgen.h>
#include <sys/wait.h>

_Noreturn void resid_abort(const char* msg);
_Noreturn void resid_index_abort(int64_t idx, int64_t len, const char* at);

/* ── Arena (region) allocator ──────────────────────────────────────────
 *
 * This runtime's core policy is "never free" (locked decision: no GC, no
 * refcounting — every value is permanently retained). That's sound but
 * unbounded: the self-hosted compiler's own no-reassignment accumulator
 * idiom rebuilds structs/lists/strings constantly, and every superseded
 * intermediate value is permanent garbage. Measured on a real
 * driver.resid self-compile: ~50GB+ resident for the compile phase
 * alone, dominated by allocation *volume* (hundreds of millions of tiny
 * boxes/list-nodes), not any single bug.
 *
 * An arena bulk-frees a whole region at once, at a caller-chosen
 * boundary. This is NOT garbage collection: no tracing, no liveness
 * scanning, no runtime object graph, no refcounts — a bump-pointer
 * allocator plus one free() call per region. Compliant with the "no GC,
 * no refcounting" constraint by construction, and correct at any scope
 * boundary the *caller* can prove nothing needed from the region
 * survives past it — no automated proof required, same as any other
 * hand-verified invariant already used throughout this file (e.g. the
 * GrowBuf mechanism's own documented soundness argument above).
 *
 * SAFETY — read before adding an arena-scoped allocation site:
 *
 * 1. Only allocation sites with NO matching free() elsewhere in this
 *    file may be routed through resid_alloc()/resid_calloc(). A site
 *    whose result is later passed to free() (resid_list_to_array's
 *    scratch buffers, str_sb's rope chunks, GrowBuf's slots, any
 *    realloc-grown buffer) MUST keep using real malloc/calloc/realloc
 *    directly — free() on a pointer that isn't a standalone malloc'd
 *    block (e.g. an offset into an arena chunk) is undefined behavior.
 *    This is why resid_alloc() is opt-in per call site, not a global
 *    malloc override.
 * 2. Anything that must survive past the arena's own resid_arena_pop()
 *    — because a caller merges it into a longer-lived structure — must
 *    be deep-copied (content AND container) via the real allocator
 *    BEFORE popping. See resid_list_deep_copy_persist below.
 * 3. str_index_slot's cache (below) is keyed by pointer identity and is
 *    long-lived by design (that's the whole point of it). Caching an
 *    arena-allocated string would leave a dangling — and, worse,
 *    address-reusable (ABA) — key once the arena pops. Fixed by simply
 *    not caching while any arena is active (bounded, known cost: no
 *    caching benefit for strings touched only during a function's own
 *    arena-scoped compile; the long-lived hot string this cache exists
 *    for — the whole program's resolved source text — is read before
 *    any arena is ever pushed, so this doesn't reintroduce the O(n^2)
 *    bug that cache was built to fix).
 */
typedef struct ArenaChunk {
    size_t cap;
    size_t used;
    struct ArenaChunk* next;
    char data[];
} ArenaChunk;

typedef struct Arena {
    ArenaChunk* head;      /* for the free-everything walk on pop */
    ArenaChunk* current;   /* bump-pointer chunk */
    struct Arena* prev;    /* saved outer arena — supports nested push/pop */
} Arena;

static _Thread_local Arena* g_current_arena = NULL;

/* The bulk arena backs the compiler-generated allocations (struct
 * values, boxes, IntToString buffers: resid_gmalloc below), which
 * resid_arena_push leaves on the real heap because values such as a
 * function's returned struct routinely outlive a per-function arena.
 * resid_bulk_push opens a scope for both kinds of allocation, meant for
 * whole compiler phases whose only surviving results are copied out
 * (resid_list_str_persist_copy) or are scalars read before the pop. */
static _Thread_local Arena* g_bulk_arena = NULL;

/* Bytes requested through the arena-aware allocators. The compile-time
 * reducer bounds its evaluation by this (resid_mem_mark /
 * resid_mem_since_mark): it counts requests, not RSS, so the limit is
 * deterministic and the reduced program is the same on every run. */
static _Thread_local uint64_t g_alloc_bytes = 0;
static _Thread_local uint64_t g_alloc_mark = 0;

/* Scalar scopes: compiler-inferred allocation regions.
 *
 * Values are immutable (spec §4), so nothing allocated while evaluating an
 * expression whose result is a plain scalar (Int, Float, Bool, ...) can be
 * reachable once the expression has produced its value: no older value can
 * be made to point at the new memory, and the scalar refers to nothing. The
 * compiler brackets such expressions with resid_scope_push/resid_scope_pop,
 * and every allocation in between comes from one thread-local bump region
 * that the pop rewinds to the push's mark. This is not garbage collection:
 * nothing is traced or counted, and a pop costs O(chunks released).
 *
 * The runtime's few writes that attach new memory to an older object (a
 * frozen map's cached trie, per-literal list constants, handle boxes)
 * allocate outside the region (alloc_suspend), and the pointer-keyed string
 * index caches never keep a region string past a pop.
 *
 * A mark is an index into a stack and pop(d) restores depth d. The
 * compiler never brackets an expression with an early exit, but a pop can
 * still be skipped by an abort that a test body or a spawned region
 * catches; its memory then goes to the next enclosing pop, which is
 * equally sound because the enclosing expression is scalar too, or is
 * never freed. At depth 0 no region memory is live.
 * Structured spawn (spec §19) joins before the spawning expression
 * finishes, and a child thread has its own region, so a region is never
 * read after its pop. */
typedef struct ScopeChunk {
    struct ScopeChunk* prev;
    size_t cap;
    char data[];
} ScopeChunk;

typedef struct {
    ScopeChunk* chunk;
    char* ptr;
} ScopeMark;

#define SCOPE_CHUNK_SIZE ((size_t)1 << 20)
/* Released standard-size chunks kept for reuse per thread. */
#define SCOPE_POOL_MAX 16

static _Thread_local int64_t g_sc_depth = 0;
static _Thread_local ScopeChunk* g_sc_chunk = NULL;
static _Thread_local char* g_sc_ptr = NULL;
static _Thread_local char* g_sc_end = NULL;
static _Thread_local ScopeMark* g_sc_marks = NULL;
static _Thread_local int64_t g_sc_marks_cap = 0;
static _Thread_local ScopeChunk* g_sc_pool = NULL;
static _Thread_local int g_sc_pool_n = 0;


#define ARENA_CHUNK_SIZE (4 * 1024 * 1024)

static ArenaChunk* arena_chunk_new(size_t cap) {
    ArenaChunk* c = (ArenaChunk*)malloc(sizeof(ArenaChunk) + cap);
    if (!c) resid_abort("arena_chunk_new: out of memory");
    c->cap = cap;
    c->used = 0;
    c->next = NULL;
    return c;
}

/* Starts a new, empty arena and makes it current. Nests: the previous
 * arena (if any) is restored by the matching resid_arena_pop(). Callable
 * directly from Resid source (typecheck.resid/codegen.resid builtin
 * dispatch, mirroring str_sb_new's zero-arg-extern pattern) — returns an
 * unused i64 only because every Resid call is an expression with a
 * value, not because the return carries meaning. */
int64_t resid_arena_push(void) {
    Arena* a = (Arena*)malloc(sizeof(Arena));
    if (!a) resid_abort("resid_arena_push: out of memory");
    a->head = NULL;
    a->current = NULL;
    a->prev = g_current_arena;
    g_current_arena = a;
    return 0;
}

/* Frees every chunk in the current arena in one pass and restores the
 * previous current arena (NULL at top level). Anything the caller needed
 * from this arena's memory must already have been deep-copied out —
 * see resid_list_str_persist_copy below. */
static void str_index_arena_popped(void);

int64_t resid_arena_pop(void) {
    Arena* a = g_current_arena;
    if (!a) resid_abort("resid_arena_pop: no active arena");
    str_index_arena_popped();
    ArenaChunk* c = a->head;
    while (c) {
        ArenaChunk* next = c->next;
        free(c);
        c = next;
    }
    g_current_arena = a->prev;
    free(a);
    return 0;
}

static void* arena_bump_alloc(Arena* a, size_t size) {
    size = (size + 15) & ~(size_t)15; /* 16-byte align, matches malloc */
    if (!a->current || a->current->used + size > a->current->cap) {
        size_t chunk_size = ARENA_CHUNK_SIZE;
        if (chunk_size < size) chunk_size = size;
        ArenaChunk* c = arena_chunk_new(chunk_size);
        c->next = a->head;
        a->head = c;
        a->current = c;
    }
    void* p = a->current->data + a->current->used;
    a->current->used += size;
    return p;
}

/* True iff `p` falls within any chunk of an active arena —
 * used only by str_index_slot's cache to decide whether a string is
 * arena-scoped (see safety note 3 above). NULL/no active arena: false. */
static int arena_chain_contains(Arena* a, const void* p) {
    for (; a; a = a->prev) {
        for (ArenaChunk* c = a->head; c; c = c->next) {
            const char* lo = c->data;
            const char* hi = c->data + c->cap;
            if ((const char*)p >= lo && (const char*)p < hi) return 1;
        }
    }
    return 0;
}

static int scope_contains(const void* p) {
    for (ScopeChunk* c = g_sc_chunk; c; c = c->prev) {
        if ((const char*)p >= c->data && (const char*)p < c->data + c->cap) return 1;
    }
    return 0;
}

static int arena_contains(const void* p) {
    /* Every active arena, not just the innermost (a string from an outer
     * arena must not enter the persistent cache either), the bulk arenas,
     * and the scalar-scope region. */
    return arena_chain_contains(g_current_arena, p) || arena_chain_contains(g_bulk_arena, p) || scope_contains(p);
}

int64_t resid_bulk_push(void) {
    Arena* a = (Arena*)malloc(sizeof(Arena));
    if (!a) resid_abort("resid_bulk_push: out of memory");
    a->head = NULL;
    a->current = NULL;
    a->prev = g_bulk_arena;
    g_bulk_arena = a;
    return resid_arena_push();
}

int64_t resid_bulk_pop(void) {
    resid_arena_pop();
    Arena* a = g_bulk_arena;
    if (!a) resid_abort("resid_bulk_pop: no active bulk arena");
    str_index_arena_popped();
    ArenaChunk* c = a->head;
    while (c) {
        ArenaChunk* next = c->next;
        free(c);
        c = next;
    }
    g_bulk_arena = a->prev;
    free(a);
#ifdef __GLIBC__
    /* A phase scope just released its whole heap footprint; hand it back
     * so the next phase's growth does not stack on top of it. */
    if (!g_bulk_arena) malloc_trim(0);
#endif
    return 0;
}

static pthread_key_t g_sc_key;
static pthread_once_t g_sc_key_once = PTHREAD_ONCE_INIT;
static _Thread_local int g_sc_key_set = 0;

/* Thread exit: hand the reuse pool back. Chunks still in use are left
 * alone (an unpopped region may hold a value the thread returned). */
static void scope_thread_exit(void* unused) {
    (void)unused;
    while (g_sc_pool) {
        ScopeChunk* c = g_sc_pool;
        g_sc_pool = c->prev;
        free(c);
    }
    g_sc_pool_n = 0;
    free(g_sc_marks);
    g_sc_marks = NULL;
    g_sc_marks_cap = 0;
}

static void scope_key_init(void) { pthread_key_create(&g_sc_key, scope_thread_exit); }

static __attribute__((noinline)) void scope_marks_grow(void) {
    int64_t cap = g_sc_marks_cap ? g_sc_marks_cap * 2 : 64;
    ScopeMark* m = (ScopeMark*)realloc(g_sc_marks, (size_t)cap * sizeof(ScopeMark));
    if (!m) resid_abort("scope: out of memory");
    g_sc_marks = m;
    g_sc_marks_cap = cap;
    if (!g_sc_key_set) {
        pthread_once(&g_sc_key_once, scope_key_init);
        pthread_setspecific(g_sc_key, (void*)1);
        g_sc_key_set = 1;
    }
}

int64_t resid_scope_push(void) {
    int64_t d = g_sc_depth;
    if (__builtin_expect(d == g_sc_marks_cap, 0)) scope_marks_grow();
    g_sc_marks[d].chunk = g_sc_chunk;
    g_sc_marks[d].ptr = g_sc_ptr;
    g_sc_depth = d + 1;
    return d;
}

static void scope_chunk_release(ScopeChunk* c) {
    if (c->cap == SCOPE_CHUNK_SIZE && g_sc_pool_n < SCOPE_POOL_MAX) {
        c->prev = g_sc_pool;
        g_sc_pool = c;
        g_sc_pool_n++;
        return;
    }
    free(c);
}

void resid_scope_pop(int64_t d) {
    if (d < 0 || d >= g_sc_depth) return;
    ScopeMark m = g_sc_marks[d];
    g_sc_depth = d;
    if (g_sc_ptr == m.ptr) return; /* nothing was allocated */
    while (g_sc_chunk != m.chunk) {
        ScopeChunk* c = g_sc_chunk;
        g_sc_chunk = c->prev;
        scope_chunk_release(c);
    }
    g_sc_ptr = m.ptr;
    g_sc_end = m.chunk ? m.chunk->data + m.chunk->cap : NULL;
    /* A pointer-keyed string cache entry may name freed region memory. */
    str_index_arena_popped();
}

static __attribute__((noinline)) void* scope_alloc_slow(size_t size) {
    ScopeChunk* c;
    if (size > SCOPE_CHUNK_SIZE / 4) {
        /* A big block gets a chunk of its own. */
        c = (ScopeChunk*)malloc(sizeof(ScopeChunk) + size);
        if (!c) resid_abort("out of memory");
        c->cap = size;
    } else if (g_sc_pool) {
        c = g_sc_pool;
        g_sc_pool = c->prev;
        g_sc_pool_n--;
    } else {
        c = (ScopeChunk*)malloc(sizeof(ScopeChunk) + SCOPE_CHUNK_SIZE);
        if (!c) resid_abort("out of memory");
        c->cap = SCOPE_CHUNK_SIZE;
    }
    c->prev = g_sc_chunk;
    g_sc_chunk = c;
    g_sc_ptr = c->data + size;
    g_sc_end = c->data + c->cap;
    return c->data;
}

/* Blocks whose size is an odd multiple of 8 are placed on an 8-byte
 * boundary (a 40-byte box holds only 8-byte words); every other block is
 * 16-byte aligned, as malloc would give. Anything needing 16-byte alignment
 * inside (the Int(128) scalar box payload) asks for a multiple of 16. */
static inline void* scope_alloc(size_t size) {
    size = (size + 7) & ~(size_t)7;
    char* p = g_sc_ptr;
    size_t pad = (size & 8) ? 0 : ((uintptr_t)p & 8);
    if (__builtin_expect(p != NULL && (size_t)(g_sc_end - p) >= size + pad, 1)) {
        g_sc_ptr = p + pad + size;
        return p + pad;
    }
    return scope_alloc_slow((size + 15) & ~(size_t)15);
}

/* Runtime writes that attach new memory to an existing (possibly older)
 * object allocate on the plain heap: no arena and no scalar scope. */
typedef struct {
    Arena* cur;
    Arena* bulk;
    int64_t depth;
} AllocSuspend;

static inline AllocSuspend alloc_suspend(void) {
    AllocSuspend s = { g_current_arena, g_bulk_arena, g_sc_depth };
    g_current_arena = NULL;
    g_bulk_arena = NULL;
    g_sc_depth = 0;
    return s;
}

static inline void alloc_resume(AllocSuspend s) {
    g_current_arena = s.cur;
    g_bulk_arena = s.bulk;
    g_sc_depth = s.depth;
}

void* resid_gmalloc(int64_t size) {
    g_alloc_bytes += (uint64_t)size;
    if (g_sc_depth) return scope_alloc((size_t)size);
    if (g_bulk_arena) return arena_bump_alloc(g_bulk_arena, (size_t)size);
    void* p = malloc((size_t)size);
    if (!p) resid_abort("out of memory");
    return p;
}

void resid_gfree(void* p) {
    /* Inside a scalar scope the block may be region memory; the pop (or
     * never freeing) covers it. At depth 0 no region memory is live. */
    if (g_sc_depth) return;
    if (arena_chain_contains(g_bulk_arena, p)) return;
    free(p);
}

/* The one indirection point for allocation sites with no matching
 * free() (see safety note 1). NULL current arena => real malloc, i.e.
 * unchanged behavior everywhere outside an explicit arena scope. */

int64_t resid_mem_mark(void) {
    g_alloc_mark = g_alloc_bytes;
    return 0;
}

int64_t resid_mem_since_mark(void) {
    return (int64_t)(g_alloc_bytes - g_alloc_mark);
}

static void* resid_alloc(size_t size) {
    g_alloc_bytes += size;
    if (g_sc_depth) return scope_alloc(size);
    if (g_current_arena) return arena_bump_alloc(g_current_arena, size);
    void* p = malloc(size);
    if (!p && size) resid_abort("out of memory");
    return p;
}

static void* resid_calloc(size_t n, size_t size) {
    size_t total = n * size;
    g_alloc_bytes += total;
    if (g_sc_depth) {
        void* p = scope_alloc(total);
        memset(p, 0, total);
        return p;
    }
    if (g_current_arena) {
        void* p = arena_bump_alloc(g_current_arena, total);
        memset(p, 0, total);
        return p;
    }
    return calloc(n, size);
}

/* Was CWD-restricted (`dirname(path)` had to resolve, via realpath, to
 * somewhere inside getcwd()), then just realpath-on-dirname (existence
 * only, no CWD check). Both broke real, ordinary usage:
 *
 * - CWD restriction: `residc foo.resid -o /tmp/out` (or any e2e test
 *   writing to a scratch dir outside the repo, a large fraction of this
 *   suite) silently failed to write, surfacing only as a confusing
 *   downstream "clang: no such file" — confirmed via a dozen e2e
 *   failures sharing that exact signature. Has no basis in this
 *   language's actual capability model (verb-level read/write/
 *   process-run gating, enforced at compile time — see the comment
 *   above this section: "a real build will gate them behind capability
 *   authorization", i.e. THIS function was never that gate).
 * - realpath-on-dirname existence check: realpath() requires the target
 *   to already exist, which is fundamentally incompatible with
 *   resid_fs_create_dir_all's whole job (creating a multi-level path
 *   that does NOT exist yet, e.g. `create_dir_all("a/b/c")` from
 *   scratch) — every such call was rejected before ever attempting to
 *   create anything. Confirmed via run_fs_create_dir.
 *
 * Path traversal via untrusted SOURCE TEXT (e.g. a crafted `import`
 * target) is a different, real concern, but belongs in import
 * resolution's own path-joining logic, not a blanket restriction on
 * every fs call including the compiler's own operator-specified -o/-rt
 * arguments and directory-creation calls. What's left here: reject only
 * empty paths — a minimal sanity check, not a capability boundary,
 * matching what this function was ever intended to be (see the "real
 * build will gate them" comment above). */
static int resid_path_is_safe(const char* path) {
    return path && path[0] != '\0';
}

bool print(const char* s) {
    if (fputs(s, stdout) == EOF) return false;
    if (fflush(stdout) == EOF) return false;
    return true;
}

bool println(const char* s) {
    if (fputs(s, stdout) == EOF) return false;
    if (putchar('\n') == EOF) return false;
    if (fflush(stdout) == EOF) return false;
    return true;
}

bool eprintln(const char* s) {
    if (fputs(s, stderr) == EOF) return false;
    if (putc('\n', stderr) == EOF) return false;
    if (fflush(stderr) == EOF) return false;
    return true;
}

/* Abort with a message: `todo(...)`/`unimplemented(...)` trap here.
 *
 * Inside a spawned region (spec §19) the abort is *catchable*: rather than
 * terminating the process, it unwinds back to the spawn worker's setjmp point
 * and is delivered to the parent as `Err(RegionError)`. At top level — where
 * no catch is installed — it aborts the process (spec §24: "Top-level
 * residual force or unwrap failure aborts the process; inside a concurrent
 * region, failure is delivered as Result"). */
static _Thread_local sigjmp_buf* resid_spawn_catch = NULL;
static _Thread_local const char* resid_spawn_catch_msg = NULL;

static _Noreturn void resid_fail(const char* msg, const char* at) {
    if (resid_spawn_catch) {
        resid_spawn_catch_msg = msg ? msg : "region abort";
        longjmp(*resid_spawn_catch, 1);
    }
    if (at && at[0]) {
        fprintf(stderr, "resid: abort: %s (%s)\n", msg && msg[0] ? msg : "abort", at);
    } else if (msg && msg[0]) {
        fprintf(stderr, "resid: abort: %s\n", msg);
    } else {
        fprintf(stderr, "resid: abort\n");
    }
    abort();
}

_Noreturn void resid_abort(const char* msg) {
    resid_fail(msg, NULL);
}

/* Dynamic-message abort with a STATIC source-location suffix. The location
 * string is baked into the C string literal at compile time (codegen), so
 * residual failures like a failing `assert` carry `(file:line:col)` context
 * at zero runtime cost (spec §34 diagnostics). */
_Noreturn void resid_abort_at(const char* msg, const char* at) {
    resid_fail(msg, at);
}

/* ── Test runner (SPEC-testing.md §5, §7) ───────────────────────────────
 * A test binary is an ordinary Resid program whose `main` the compiler
 * generates: it calls resid_test_plan once, then resid_test_run per
 * discovered `test "name" { ... }` block, then resid_test_summary.
 *
 * Per-test isolation reuses the spawn catch above rather than introducing a
 * second unwind path: resid_test_run installs itself as the catch target, so
 * ANY abort raised inside the body — a failed expectation, an out-of-range
 * index, a capability violation, `todo(...)` — unwinds back here and is
 * reported as one failing test instead of killing the whole run. The catch is
 * saved and restored around the body so a test that spawns still nests. */

#define RESID_TEST_MSG_MAX 1024

static int    resid_test_in_test = 0;
static char   resid_test_fail_buf[RESID_TEST_MSG_MAX];
static int64_t resid_test_passed = 0;
static int64_t resid_test_failed = 0;
static int64_t resid_test_skipped = 0;
static int64_t resid_test_index = 0;
static double resid_test_total_ms = 0.0;
static int    resid_test_fmt = -1;          /* 0 pretty, 1 TAP, 2 JSON */
static int    resid_test_json_first = 1;
static const char* resid_test_module_name = "";
/* Set by resid_test_run_closure just before it calls resid_test_run with a
 * NULL body; consumed there. */
static int64_t resid_test_closure_env = 0;
static void (*resid_test_closure_fn)(int64_t) = NULL;

/* Output format, from RESID_TEST_FORMAT (the `residc test --format` flag is
 * passed to the compiled binary through the environment). */
static int resid_test_format(void) {
    if (resid_test_fmt < 0) {
        const char* f = getenv("RESID_TEST_FORMAT");
        if (f && strcmp(f, "tap") == 0) resid_test_fmt = 1;
        else if (f && strcmp(f, "json") == 0) resid_test_fmt = 2;
        else resid_test_fmt = 0;
    }
    return resid_test_fmt;
}

/* Progress-chatter suppression. The compiler prints an `OK <decl>` line per
 * declaration, which is useful on a normal build and fatal to a machine-read
 * test report — stray lines before `TAP version 13` break every TAP parser.
 * `residc test` raises this flag before type checking, and the checker's
 * progress prints consult it. */
static int resid_quiet_flag = 0;

int8_t resid_quiet_set(int8_t on) { resid_quiet_flag = on ? 1 : 0; return 1; }
int8_t resid_quiet(void) { return (int8_t)resid_quiet_flag; }

/* ── Tiny regex (subset) ────────────────────────────────────────────────
 * Supports `^` `$` `.` `*` `+` `?` and `[...]` classes (with `^` negation
 * and `a-z` ranges). Deliberately NOT a full regex engine: it is what
 * `toMatch` (SPEC-testing.md §2.1) and `--filter` (§7.1) need, and nothing
 * in the runtime should grow a backtracking engine for them. Alternation and
 * capture groups are unsupported; a pattern using them will not match. */
static int resid_rx_class(const char** pp, char c) {
    const char* p = *pp + 1;            /* past '[' */
    int neg = 0, hit = 0;
    if (*p == '^') { neg = 1; p++; }
    for (; *p && *p != ']'; p++) {
        if (p[1] == '-' && p[2] && p[2] != ']') {
            if (c >= p[0] && c <= p[2]) hit = 1;
            p += 2;
        } else if (*p == c) {
            hit = 1;
        }
    }
    if (*p == ']') p++;
    *pp = p;
    return neg ? !hit : hit;
}

/* Length of the single-character matcher starting at p. */
static int resid_rx_atom_len(const char* p) {
    if (*p == '[') {
        const char* q = p + 1;
        if (*q == '^') q++;
        if (*q == ']') q++;             /* a literal ']' first in the class */
        while (*q && *q != ']') q++;
        return (int)((*q == ']' ? q + 1 : q) - p);
    }
    if (*p == '\\' && p[1]) return 2;
    return 1;
}

static int resid_rx_one(const char* p, char c) {
    if (*p == '[') { const char* q = p; return resid_rx_class(&q, c); }
    if (*p == '\\' && p[1]) return p[1] == c;
    if (*p == '.') return c != '\0';
    return *p == c;
}

static int resid_rx_here(const char* p, const char* s);

/* `atom*` / `atom+` / `atom?` against s, then the rest of the pattern. */
static int resid_rx_rep(const char* atom, char op, const char* rest, const char* s) {
    if (op == '?') {
        if (resid_rx_here(rest, s)) return 1;
        if (*s && resid_rx_one(atom, *s)) return resid_rx_here(rest, s + 1);
        return 0;
    }
    if (op == '+') {
        if (!*s || !resid_rx_one(atom, *s)) return 0;
        s++;
    }
    for (;;) {
        if (resid_rx_here(rest, s)) return 1;
        if (!*s || !resid_rx_one(atom, *s)) return 0;
        s++;
    }
}

static int resid_rx_here(const char* p, const char* s) {
    if (p[0] == '\0') return 1;
    if (p[0] == '$' && p[1] == '\0') return *s == '\0';
    int alen = resid_rx_atom_len(p);
    char op = p[alen];
    if (op == '*' || op == '+' || op == '?') return resid_rx_rep(p, op, p + alen + 1, s);
    if (*s && resid_rx_one(p, *s)) return resid_rx_here(p + alen, s + 1);
    return 0;
}

/* Unanchored search unless the pattern starts with '^'. */
int8_t resid_regex_match(const char* pattern, const char* text) {
    if (!pattern || !text) return 0;
    if (pattern[0] == '^') return (int8_t)(resid_rx_here(pattern + 1, text) != 0);
    do {
        if (resid_rx_here(pattern, text)) return 1;
    } while (*text++);
    return 0;
}

/* ── Expectation failure ────────────────────────────────────────────────
 * `actual`/`expected` are already-rendered strings (ToString output, or the
 * raw Str for Str comparisons); either may be NULL when the matcher has no
 * meaningful pair to show, in which case only the method name is reported.
 * Always terminal: inside a test it unwinds to resid_test_run via the abort
 * catch, at top level it aborts the process exactly as before. */
_Noreturn void resid_expect_fail(const char* method, const char* actual, const char* expected) {
    char buf[RESID_TEST_MSG_MAX];
    if (actual && expected) {
        snprintf(buf, sizeof buf,
                 "expectation failed: %s\n    actual:   %s\n    expected: %s",
                 method ? method : "?", actual, expected);
    } else if (actual) {
        snprintf(buf, sizeof buf, "expectation failed: %s\n    actual:   %s",
                 method ? method : "?", actual);
    } else {
        snprintf(buf, sizeof buf, "expectation failed: %s", method ? method : "?");
    }
    if (resid_test_in_test) {
        snprintf(resid_test_fail_buf, sizeof resid_test_fail_buf, "%s", buf);
    }
    /* resid_abort prints `buf` itself on the top-level path, so there is no
     * separate eprintln here — the message used to be emitted twice. */
    resid_abort(buf);
}

/* `expect(closure).toThrow()` (SPEC-testing.md §2.1): call a zero-argument
 * closure with the abort catch installed and report whether it aborted.
 * `clo` is the closure value the compiler builds — an i64 array whose slot 0
 * holds the function pointer and whose address is passed back as the
 * environment argument, matching cg_fn_call's lowering. */
int8_t resid_expect_throws(void* clo) {
    if (!clo) return 0;
    int64_t fp = ((int64_t*)clo)[0];
    if (!fp) return 0;
    void (*fn)(int64_t) = (void (*)(int64_t))(intptr_t)fp;

    sigjmp_buf jb;
    sigjmp_buf* prev_catch = resid_spawn_catch;
    const char* prev_msg = resid_spawn_catch_msg;
    char saved[RESID_TEST_MSG_MAX];
    int prev_in_test = resid_test_in_test;
    memcpy(saved, resid_test_fail_buf, sizeof saved);

    int threw = 0;
    resid_test_in_test = 1;   /* capture any failure text instead of printing it */
    resid_spawn_catch = &jb;
    if (setjmp(jb) == 0) {
        fn((int64_t)(intptr_t)clo);
    } else {
        threw = 1;
    }
    resid_spawn_catch = prev_catch;
    resid_spawn_catch_msg = prev_msg;
    resid_test_in_test = prev_in_test;
    memcpy(resid_test_fail_buf, saved, sizeof saved);
    return (int8_t)threw;
}

/* Should `name` run? RESID_TEST_FILTER is a regex (see resid_regex_match);
 * an unset or empty filter selects everything. */
int8_t resid_test_selected(const char* name) {
    const char* f = getenv("RESID_TEST_FILTER");
    if (!f || !f[0]) return 1;
    return resid_regex_match(f, name ? name : "");
}

/* Emitted once, before any test: the TAP preamble / pretty module header. */
int8_t resid_test_plan(int64_t n, const char* module) {
    resid_test_module_name = module ? module : "";
    switch (resid_test_format()) {
        case 1:
            printf("TAP version 13\n1..%lld\n", (long long)n);
            break;
        case 2:
            printf("{\"module\":\"%s\",\"tests\":[", resid_test_module_name);
            break;
        default:
            printf("\n%s\n", resid_test_module_name);
            break;
    }
    fflush(stdout);
    return 1;
}

static void resid_test_report(const char* name, int failed, int skipped, double ms) {
    switch (resid_test_format()) {
        case 1:
            if (skipped) {
                printf("ok %lld %s.%s # SKIP filtered\n",
                       (long long)resid_test_index, resid_test_module_name, name);
            } else if (failed) {
                printf("not ok %lld %s.%s\n",
                       (long long)resid_test_index, resid_test_module_name, name);
                printf("  ---\n  message: |\n");
                for (const char* l = resid_test_fail_buf; *l; ) {
                    const char* e = strchr(l, '\n');
                    int len = e ? (int)(e - l) : (int)strlen(l);
                    printf("    %.*s\n", len, l);
                    if (!e) break;
                    l = e + 1;
                }
                printf("  ...\n");
            } else {
                printf("ok %lld %s.%s\n",
                       (long long)resid_test_index, resid_test_module_name, name);
            }
            break;
        case 2:
            printf("%s{\"name\":\"%s\",\"status\":\"%s\",\"duration_ms\":%.3f}",
                   resid_test_json_first ? "" : ",", name,
                   skipped ? "skipped" : (failed ? "failed" : "passed"), ms);
            resid_test_json_first = 0;
            break;
        default:
            if (skipped) {
                printf("  - %s (skipped)\n", name);
            } else if (failed) {
                printf("  \u2717 %s (%.0fms)\n", name, ms);
                for (const char* l = resid_test_fail_buf; *l; ) {
                    const char* e = strchr(l, '\n');
                    int len = e ? (int)(e - l) : (int)strlen(l);
                    printf("    %.*s\n", len, l);
                    if (!e) break;
                    l = e + 1;
                }
            } else {
                printf("  \u2713 %s (%.0fms)\n", name, ms);
            }
            break;
    }
    fflush(stdout);
}

/* Run one test body under the abort catch. Returns 1 if it failed. */
int64_t resid_test_run(void (*body)(void), const char* name) {
    const char* nm = name ? name : "<unnamed>";
    resid_test_index++;
    if (!resid_test_selected(nm)) {
        resid_test_closure_fn = NULL;
        resid_test_closure_env = 0;
        resid_test_skipped++;
        resid_test_report(nm, 0, 1, 0.0);
        return 0;
    }
    struct timespec t0, t1;
    sigjmp_buf jb;
    sigjmp_buf* prev_catch = resid_spawn_catch;
    const char* prev_msg = resid_spawn_catch_msg;
    int failed = 0;

    resid_test_fail_buf[0] = '\0';
    resid_test_in_test = 1;
    clock_gettime(CLOCK_MONOTONIC, &t0);
    void (*clo_fn)(int64_t) = resid_test_closure_fn;
    int64_t clo_env = resid_test_closure_env;
    resid_test_closure_fn = NULL;
    resid_test_closure_env = 0;
    resid_spawn_catch = &jb;
    if (setjmp(jb) == 0) {
        if (body) body(); else if (clo_fn) clo_fn(clo_env);
    } else {
        failed = 1;
        if (!resid_test_fail_buf[0]) {
            snprintf(resid_test_fail_buf, sizeof resid_test_fail_buf, "%s",
                     resid_spawn_catch_msg ? resid_spawn_catch_msg : "aborted");
        }
    }
    resid_spawn_catch = prev_catch;
    resid_spawn_catch_msg = prev_msg;
    resid_test_in_test = 0;
    clock_gettime(CLOCK_MONOTONIC, &t1);

    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1000.0
              + (double)(t1.tv_nsec - t0.tv_nsec) / 1000000.0;
    resid_test_total_ms += ms;
    if (failed) resid_test_failed++; else resid_test_passed++;
    resid_test_report(nm, failed, 0, ms);
    return failed ? 1 : 0;
}

/* As resid_test_run, but the body is a CLOSURE value rather than a plain
 * function: slot 0 holds the function pointer and the closure address rides
 * as the environment argument (SPEC-testing.md §1.3 explicit registration,
 * where the bodies are lambdas held in a list). */
int64_t resid_test_run_closure(void* clo, const char* name) {
    if (!clo) return 1;
    int64_t fp = ((int64_t*)clo)[0];
    if (!fp) return 1;
    resid_test_closure_env = (int64_t)(intptr_t)clo;
    resid_test_closure_fn = (void (*)(int64_t))(intptr_t)fp;
    return resid_test_run(NULL, name);
}

/* Footer; returns the process exit code (0 all passed, 1 any failure). */
int64_t resid_test_summary(void) {
    switch (resid_test_format()) {
        case 1:
            break;
        case 2:
            printf("],\"passed\":%lld,\"failed\":%lld,\"skipped\":%lld,\"duration_ms\":%.3f}\n",
                   (long long)resid_test_passed, (long long)resid_test_failed,
                   (long long)resid_test_skipped, resid_test_total_ms);
            break;
        default:
            if (resid_test_skipped) {
                printf("\nFailures: %lld | Passed: %lld | Skipped: %lld | Duration: %.0fms\n",
                       (long long)resid_test_failed, (long long)resid_test_passed,
                       (long long)resid_test_skipped, resid_test_total_ms);
            } else {
                printf("\nFailures: %lld | Passed: %lld | Duration: %.0fms\n",
                       (long long)resid_test_failed, (long long)resid_test_passed,
                       resid_test_total_ms);
            }
            break;
    }
    fflush(stdout);
    return resid_test_failed ? 1 : 0;
}

/* ── Force-time capability enforcement (spec §21.3) ──────────────────────
 * The compile-time checker rejects every statically-apparent capability
 * violation, but a requirement that is dynamic or residual must also fail
 * at FORCE TIME with a capability error. Each sandboxed region pushes its
 * granted capability set onto a thread-local stack; a residual provider call
 * verifies its required capability against every frame (attenuation only
 * shrinks, so a capability must be present in ALL frames — the transitive
 * closure). An empty stack means the ambient grant is unrestricted.
 *
 * Bypassing resid_cap_check fires resid_abort: at top level that aborts the
 * process (spec §24); inside a spawned region it unwinds and is delivered to
 * the parent as Err(RegionError). */
#define RESID_CAP_MAX_DEPTH 32
#define RESID_CAP_MAX_SET 64

static _Thread_local const char* resid_cap_stack[RESID_CAP_MAX_DEPTH][RESID_CAP_MAX_SET];
static _Thread_local int64_t resid_cap_ns[RESID_CAP_MAX_DEPTH];
static _Thread_local int resid_cap_depth = 0;
static _Thread_local int resid_cap_active = 0;

/* Push a granted set `caps` of length `n` for the current region. n < 0
 * (or n == 0 with a NULL caps array) pushes a marker frame that grants
 * nothing. */
void resid_cap_enter(const char* const* caps, int64_t n) {
    if (resid_cap_depth >= RESID_CAP_MAX_DEPTH) {
        resid_abort("capability: sandbox nesting exceeds RESID_CAP_MAX_DEPTH");
        return;
    }
    int64_t m = (caps && n > 0) ? n : 0;
    for (int64_t i = 0; i < m && i < RESID_CAP_MAX_SET; i++) {
        resid_cap_stack[resid_cap_depth][i] = caps[i];
    }
    resid_cap_ns[resid_cap_depth] = m;
    resid_cap_depth++;
    resid_cap_active = 1;
}

void resid_cap_leave(void) {
    if (resid_cap_depth > 0) resid_cap_depth--;
    if (resid_cap_depth == 0) resid_cap_active = 0;
}

static int resid_cap_term(char c) {
    return c == '\0' || c == '(' || c == ':';
}

static int resid_cap_same_family(const char* a, const char* b) {
    if (!a || !b) return 0;
    while (*a && *b && !resid_cap_term(*a) && !resid_cap_term(*b) && *a == *b) {
        a++;
        b++;
    }
    return resid_cap_term(*a) && resid_cap_term(*b);
}

static int resid_cap_granted(const char* cap) {
    if (resid_cap_depth == 0) return 1; /* ambient: unrestricted */
    for (int d = 0; d < resid_cap_depth; d++) {
        int found = 0;
        for (int64_t i = 0; i < resid_cap_ns[d]; i++) {
            if (resid_cap_same_family(resid_cap_stack[d][i], cap)) {
                found = 1;
                break;
            }
        }
        if (!found) return 0; /* attenuation only shrinks: must be in every frame */
    }
    return 1;
}

void resid_cap_check(const char* cap) {
    if (!resid_cap_granted(cap)) {
        char buf[128];
        snprintf(buf, sizeof(buf), "capability not granted: %s", cap ? cap : "?");
        resid_abort(buf);
    }
}

static char* resid_box_str(const char* s) {
    size_t n = strlen(s);
    char* p = (char*)malloc(n + 1);
    if (!p) resid_abort("resid_box_str: out of memory");
    memcpy(p, s, n + 1);
    return p;
}

/*
 * Runtime string concatenation: f-string interpolation and `Str + Str`
 * (spec §32) build string values out of parts that aren't constant-foldable.
 */
char* resid_str_concat(const char* a, const char* b) {
    size_t la = strlen(a);
    size_t lb = strlen(b);
    if (la > SIZE_MAX - lb) resid_abort("resid_str_concat: size overflow");
    char* p = (char*)resid_alloc(la + lb + 1);
    if (!p) resid_abort("resid_str_concat: out of memory");
    memcpy(p, a, la);
    memcpy(p + la, b, lb + 1);
    return p;
}

/*
 * In-place string accumulators (examples/stracc.resid). The compiler
 * rewrites a Str accumulator threaded through a self tail call so that
 * `acc + piece` becomes resid_sacc_append(acc, piece) on a buffer made by
 * resid_sacc_from at entry; it proves the buffer has no other reader while
 * it grows. The buffer is an ordinary NUL-terminated string preceded by a
 * {len, cap} header, so it can be returned and used as any other Str.
 *
 * Growth reallocates. The old block has no other reader, but the
 * string-index caches are keyed by pointer, so its address is evicted
 * from them first (a freed-then-reused address must not hit a stale
 * entry).
 */
static void str_index_forget(const char* s);
typedef struct {
    size_t len;
    size_t cap;
} SaccHdr;

static char* sacc_alloc(size_t cap) {
    SaccHdr* h = (SaccHdr*)malloc(sizeof(SaccHdr) + cap + 1);
    if (!h) resid_abort("resid_sacc: out of memory");
    h->len = 0;
    h->cap = cap;
    return (char*)(h + 1);
}

char* resid_sacc_from(const char* s) {
    size_t n = strlen(s);
    size_t cap = n < 32 ? 64 : n * 2;
    char* d = sacc_alloc(cap);
    memcpy(d, s, n + 1);
    ((SaccHdr*)d - 1)->len = n;
    return d;
}

static char* sacc_reserve(char* d, size_t n) {
    SaccHdr* h = (SaccHdr*)d - 1;
    if (h->len > SIZE_MAX / 2 - n) resid_abort("resid_sacc_append: size overflow");
    if (h->len + n <= h->cap) return d;
    size_t cap = h->cap * 2;
    if (cap < h->len + n) cap = h->len + n;
    str_index_forget(d);
    h = (SaccHdr*)realloc(h, sizeof(SaccHdr) + cap + 1);
    if (!h) resid_abort("resid_sacc: out of memory");
    h->cap = cap;
    return (char*)(h + 1);
}

char* resid_sacc_append(char* d, const char* s) {
    size_t n = strlen(s);
    d = sacc_reserve(d, n);
    SaccHdr* h = (SaccHdr*)d - 1;
    memcpy(d + h->len, s, n + 1);
    h->len += n;
    return d;
}

/* acc + IntToString(v), formatted straight into the buffer. */
char* resid_sacc_append_int(char* d, int64_t v) {
    char tmp[24];
    int n = snprintf(tmp, sizeof tmp, "%lld", (long long)v);
    d = sacc_reserve(d, (size_t)n);
    SaccHdr* h = (SaccHdr*)d - 1;
    memcpy(d + h->len, tmp, (size_t)n + 1);
    h->len += (size_t)n;
    return d;
}

/* Copy a NUL-terminated string into a fixed-capacity stack buffer
 * (Str(N) = N UTF-8 bytes + NUL, cap = N + 1). Copies at most cap - 1 bytes,
 * truncating on overflow (a NUL terminator is always written). Returns
 * the number of bytes stored (excluding the terminator). Used to
 * materialize stack-allocated Str(N) values without any heap use. */
size_t resid_str_to_fixed(char* dst, const char* src, size_t cap) {
    if (cap == 0) return 0;
    size_t n = 0;
    while (n < cap - 1 && src[n] != 0) {
        dst[n] = src[n];
        n++;
    }
    /* Never split a codepoint: back off to its lead byte when truncated. */
    if (src[n] != 0 && (src[n] & 0xC0) == 0x80) {
        while (n > 0 && (src[n] & 0xC0) == 0x80) n--;
    }
    dst[n] = 0;
    return n;
}

/* Copy a raw byte buffer into a fixed-capacity stack buffer
 * (Bytes(N) = exactly N bytes, cap = N). Copies at most cap bytes,
 * truncating on overflow. Returns the number of bytes stored. Used to
 * materialize stack-allocated Bytes(N) values without any heap use. */
size_t resid_bytes_to_fixed(unsigned char* dst, const unsigned char* src, size_t cap) {
    if (cap == 0) return 0;
    size_t n = 0;
    while (n < cap && src[n] != 0) {
        dst[n] = src[n];
        n++;
    }
    return n;
}

/* Str == Str / Str != Str. Returns 1 when equal (C ABI Bool = i8). */
int8_t resid_str_eq(const char* a, const char* b) {
    return strcmp(a, b) == 0;
}

/* UTF-8 decoding helpers for the string introspection functions. */
static int utf8_seq_len(const unsigned char c) {
    if (c < 0x80) return 1;
    if ((c & 0xE0) == 0xC0) return 2;
    if ((c & 0xF0) == 0xE0) return 3;
    if ((c & 0xF8) == 0xF0) return 4;
    return 1; /* invalid continuation byte — treat as 1 */
}

static int64_t utf8_decode(const unsigned char* p, int len) {
    switch (len) {
        case 1: return p[0];
        case 2: return ((p[0] & 0x1F) << 6) | (p[1] & 0x3F);
        case 3: return ((p[0] & 0x0F) << 12) | ((p[1] & 0x3F) << 6) | (p[2] & 0x3F);
        default: return ((p[0] & 0x07) << 18) | ((p[1] & 0x3F) << 12)
                        | ((p[2] & 0x3F) << 6) | (p[3] & 0x3F);
    }
}

/* ── Per-string byte-offset index (true O(1) random access) ──
 *
 * str_len/str_char_at/str_slice used to walk from byte 0 of `s` on
 * EVERY call, decoding UTF-8 the whole way — O(N) per call regardless
 * of what's being asked for. The self-hosted lexer's `lex_tok` calls
 * `str_len(s)` as its very first statement on EVERY token, with `s`
 * always the WHOLE source file (not the remaining suffix), so
 * tokenizing an N-character file cost O(N) per token from str_len
 * alone — O(N^2) just to lex the file once. str_char_at/str_slice add
 * a further O(position) per call on top. Worse still: a hand-rolled
 * recursive-descent parser re-lexes the same/nearby positions from
 * many different call sites for lookahead (no token memoization), so
 * access is NOT purely forward — a single-entry "resume from last
 * position" cursor thrashes (full reset) on every backward step and
 * only recovers a constant factor, not the complexity class (measured:
 * ~3.7x faster, still O(n^2) — see git history for that attempt).
 *
 * Str values are immutable and this runtime's allocator never frees a
 * string's backing buffer once created (see the "allocator never
 * frees" design note above), so caching derived data by pointer
 * identity is permanently sound: an address can never later denote
 * different content, so there is no ABA staleness hazard.
 *
 * Fix: build a codepoint-index -> byte-offset array per distinct
 * string pointer (O(N), first touch only), then every str_len/
 * str_char_at/str_slice call is a genuine O(1) array lookup — correct
 * and fast regardless of access direction/pattern, not just the
 * forward case.
 *
 * A single slot is NOT enough: helpers like `str_has_prefix` build a
 * short-lived probe string via `str_slice` and test it against a
 * handful of literal patterns ("List(", "Map(", "Set(", ...), so real
 * traffic ping-pongs between a small working set of distinct strings
 * (the big source string plus a few small literals/probes), not one
 * string at a time. A direct-mapped (1-slot) cache thrashes on that —
 * every switch is a miss, so it rebuilds the O(N)-sized source index
 * over and over (measured: ~225 rebuilds per checked function, ~n/4,
 * i.e. still O(n^2) rebuilds — worse than before in leaked memory even
 * though each hit was O(1)). A small set-associative cache (any of the
 * last STR_IDX_SLOTS distinct strings stays resident, LRU-evicted)
 * fully absorbs a working set that size, same as an L1 cache beating
 * direct-mapped for a cyclic access pattern. Thread-local to stay safe
 * under `spawn`, matching resid_cap_stack/resid_spawn_catch above. An
 * evicted slot's array is intentionally leaked — matches this
 * runtime's established never-free allocator policy. */
#define STR_IDX_SLOTS 16
typedef struct {
    const char* s;
    int64_t len;       /* codepoint count; -1 = empty slot */
    size_t* off;        /* NULL for ASCII; else off[k] = byte offset of codepoint k*STR_IDX_STRIDE */
    uint64_t touched;   /* LRU clock value at last use */
    size_t blen;        /* byte length */
} StrIndexSlot;
static _Thread_local StrIndexSlot g_str_slots[STR_IDX_SLOTS];
#define STR_IDX_SMALL 256
static _Thread_local StrIndexSlot g_str_small = { NULL, -1, NULL, 0 };
static _Thread_local uint64_t g_str_clock = 0;
static _Thread_local int g_str_slots_ready = 0;

/* Scratch slot for arena-scoped strings — never inserted into the
 * persistent cache above (see arena_contains use below): a string built
 * while an arena is active is freed in bulk on resid_arena_pop(), and
 * this cache is keyed by pointer identity with no eviction notification,
 * so caching such a key would leave it dangling — and worse,
 * address-reusable (ABA) — the moment the arena pops. It holds the most
 * recent arena-scoped string instead, and resid_arena_pop clears it. */
static _Thread_local StrIndexSlot g_str_scratch;

/* Byte offset of codepoint `i` in the slot's string (i in [0, len]). An
 * all-ASCII string needs no table: codepoint i is byte i. Otherwise the
 * table is sparse — one checkpoint every STR_IDX_STRIDE codepoints — and
 * the remainder is walked (at most STR_IDX_STRIDE - 1 steps), which keeps
 * the table 16x smaller than one entry per codepoint. */
#define STR_IDX_SHIFT 4
#define STR_IDX_STRIDE (1 << STR_IDX_SHIFT)
static inline size_t str_slot_off(const StrIndexSlot* sl, int64_t i) {
    if (!sl->off) return (size_t)i;
    const unsigned char* p = (const unsigned char*)sl->s + sl->off[i >> STR_IDX_SHIFT];
    for (int64_t k = i & (STR_IDX_STRIDE - 1); k > 0; k--) p += utf8_seq_len(*p);
    return (size_t)((const char*)p - sl->s);
}

static void str_index_build(const char* s, StrIndexSlot* out) {
    /* The slot owns its previous table (if any): release it rather than
     * leak one table per rebuild. */
    if (out->off) { free(out->off); out->off = NULL; }
    /* Pure-ASCII strings (the common case) need only their byte length:
     * strlen plus a word-at-a-time high-bit test, both at memory speed. */
    size_t blen = strlen(s);
    {
        const unsigned char* q = (const unsigned char*)s;
        size_t k = 0;
        uint64_t hi = 0;
        for (; k + 32 <= blen; k += 32) {
            uint64_t w0, w1, w2, w3;
            memcpy(&w0, q + k, 8);
            memcpy(&w1, q + k + 8, 8);
            memcpy(&w2, q + k + 16, 8);
            memcpy(&w3, q + k + 24, 8);
            hi |= w0 | w1 | w2 | w3;
        }
        for (; k < blen; k++) hi |= q[k];
        if ((hi & 0x8080808080808080ULL) == 0) {
            out->s = s;
            out->len = (int64_t)blen;
            out->blen = blen;
            return;
        }
    }
    int64_t n = 0;
    const unsigned char* p = (const unsigned char*)s;
    while (*p) {
        n++;
        p += utf8_seq_len(*p);
    }
    out->s = s;
    out->len = n;
    out->blen = blen;
    int64_t nck = (n >> STR_IDX_SHIFT) + 1;
    size_t* off = (size_t*)malloc((size_t)nck * sizeof(size_t));
    if (!off) resid_abort("str_index_slot: out of memory");
    p = (const unsigned char*)s;
    for (int64_t i = 0; i < n; i++) {
        if ((i & (STR_IDX_STRIDE - 1)) == 0) off[i >> STR_IDX_SHIFT] = (size_t)((const char*)p - s);
        p += utf8_seq_len(*p);
    }
    if ((n & (STR_IDX_STRIDE - 1)) == 0) off[n >> STR_IDX_SHIFT] = (size_t)((const char*)p - s);
    out->off = off;
}

/* The slot that answered the previous lookup. A scan over one string
 * (str_char_at in a loop) hits here without touching the LRU or measuring
 * the string again. Always checked against the slot's current key, which
 * every rebuild and eviction updates, so it can never name a stale entry. */
static _Thread_local StrIndexSlot* g_str_mru = NULL;

/* The last all-ASCII string looked up, and its length: str_char_at and
 * str_len on it are a compare and a byte load. Cleared wherever a cached
 * string's address can be freed (str_index_forget, arena pops). */
static _Thread_local const char* g_str_fast_s = NULL;
static _Thread_local int64_t g_str_fast_len = 0;

static StrIndexSlot* str_index_slot_slow(const char* s);

static inline StrIndexSlot* str_index_slot(const char* s) {
    StrIndexSlot* m = g_str_mru;
    if (m && m->s == s) return m;
    StrIndexSlot* sl = str_index_slot_slow(s);
    g_str_mru = sl;
    if (!sl->off) {
        g_str_fast_s = s;
        g_str_fast_len = sl->len;
    }
    return sl;
}

static __attribute__((noinline)) StrIndexSlot* str_index_slot_slow(const char* s) {
    if (!g_str_slots_ready) {
        for (int k = 0; k < STR_IDX_SLOTS; k++) {
            g_str_slots[k].s = NULL;
            g_str_slots[k].len = -1;
            g_str_slots[k].off = NULL;
            g_str_slots[k].touched = 0;
        }
        g_str_slots_ready = 1;
    }
    /* Short strings (type names, tokens, identifiers) never enter the LRU:
     * a burst of them used to evict the big source text's index, so the
     * next lex step rebuilt it by walking the whole program again. Their
     * own index is cheap to build and is kept in one dedicated slot. */
    /* resid_arena_pop clears this slot and the scratch slot, so a pointer
     * match always names the live string it was built from. */
    if (g_str_small.s == s) return &g_str_small;
    if (strnlen(s, STR_IDX_SMALL) < STR_IDX_SMALL) {
        str_index_build(s, &g_str_small);
        return &g_str_small;
    }
    g_str_clock++;
    /* MRU hits skip the clock; credit the last string used now so a hot
     * string is not the one evicted. */
    if (g_str_mru) g_str_mru->touched = g_str_clock;
    for (int k = 0; k < STR_IDX_SLOTS; k++) {
        if (g_str_slots[k].s == s) {
            g_str_slots[k].touched = g_str_clock;
            return &g_str_slots[k];
        }
    }
    if (g_str_scratch.s == s) return &g_str_scratch;
    if (arena_contains(s)) {
        str_index_build(s, &g_str_scratch);
        g_str_scratch.touched = g_str_clock;
        return &g_str_scratch;
    }
    int victim = 0;
    for (int k = 1; k < STR_IDX_SLOTS; k++) {
        if (g_str_slots[k].touched < g_str_slots[victim].touched) victim = k;
    }
    str_index_build(s, &g_str_slots[victim]);
    g_str_slots[victim].touched = g_str_clock;
    return &g_str_slots[victim];
}

/* An arena is about to be freed: the small-string and scratch slots may
 * be keyed by a string inside it, and malloc may hand that address out
 * again, so neither may survive the pop. (The LRU never holds arena
 * strings.) */
static void str_index_arena_popped(void) {
    g_str_fast_s = NULL;
    g_str_small.s = NULL;
    g_str_scratch.s = NULL;
}

/* Drop every cached index keyed by `s` (about to be freed). */
static void str_index_forget(const char* s) {
    if (g_str_fast_s == s) g_str_fast_s = NULL;
    if (g_str_small.s == s) g_str_small.s = NULL;
    if (g_str_scratch.s == s) g_str_scratch.s = NULL;
    if (!g_str_slots_ready) return;
    for (int k = 0; k < STR_IDX_SLOTS; k++) {
        if (g_str_slots[k].s == s) { g_str_slots[k].s = NULL; g_str_slots[k].touched = 0; }
    }
}

/* Number of Unicode codepoints in a UTF-8 string. */
int64_t str_len(const char* s) {
    if (s == g_str_fast_s) return g_str_fast_len;
    return str_index_slot(s)->len;
}

static __attribute__((noinline)) int64_t str_char_at_slow(const char* s, int64_t i) {
    StrIndexSlot* sl = str_index_slot(s);
    if ((uint64_t)i >= (uint64_t)sl->len) return -1;
    if (!sl->off) return (unsigned char)s[i];   /* all-ASCII: byte i */
    const unsigned char* p = (const unsigned char*)(s + str_slot_off(sl, i));
    return utf8_decode(p, utf8_seq_len(*p));
}

/* Codepoint at index `i` (0-based), or -1 when out of bounds. The fast path
 * — the string answered the previous lookup and is all ASCII — is small
 * enough to inline into user loops under LTO. */
int64_t str_char_at(const char* s, int64_t i) {
    if (__builtin_expect(s == g_str_fast_s, 1)) {
        return (uint64_t)i < (uint64_t)g_str_fast_len ? (int64_t)(unsigned char)s[i] : -1;
    }
    return str_char_at_slow(s, i);
}

/* UTF-8 encode one codepoint into `buf` (≥4 bytes); returns bytes written. */
static int utf8_encode_cp(int64_t cp, char* buf) {
    if (cp < 0x80) {
        buf[0] = (char)cp;
        return 1;
    } else if (cp < 0x800) {
        buf[0] = (char)(0xC0 | (cp >> 6));
        buf[1] = (char)(0x80 | (cp & 0x3F));
        return 2;
    } else if (cp < 0x10000) {
        buf[0] = (char)(0xE0 | (cp >> 12));
        buf[1] = (char)(0x80 | ((cp >> 6) & 0x3F));
        buf[2] = (char)(0x80 | (cp & 0x3F));
        return 3;
    } else {
        buf[0] = (char)(0xF0 | (cp >> 18));
        buf[1] = (char)(0x80 | ((cp >> 12) & 0x3F));
        buf[2] = (char)(0x80 | ((cp >> 6) & 0x3F));
        buf[3] = (char)(0x80 | (cp & 0x3F));
        return 4;
    }
}

/* Build a 1-codepoint string from a Unicode codepoint. */
char* str_from_code(int64_t cp) {
    char buf[4];
    int n = utf8_encode_cp(cp, buf);
    char* p = (char*)malloc((size_t)n + 1);
    if (!p) resid_abort("str_from_code: out of memory");
    memcpy(p, buf, (size_t)n);
    p[n] = '\0';
    return p;
}

/*
 * String builders.
 *
 * `acc + piece` inside a loop materializes a fresh NUL-terminated buffer on
 * every step — O(total^2) bytes copied for a byte-at-a-time accumulator (the
 * lib/h2.resid h2_bs_acc pattern). A builder accumulates into one flat,
 * geometrically grown byte buffer (amortized O(1) appends; large blocks grow
 * by realloc, which glibc services with mremap, so the bytes are not copied)
 * and `str_sb_finish` hands that same buffer back, shrunk to fit, as the
 * finished NUL-terminated Str — no second copy of the whole output.
 *
 * The handle is an opaque pointer carried by Resid as a `Str`-typed value.
 * It stays at a fixed address while the buffer behind it moves, so a stale
 * handle never dangles; appending to a finished builder is undefined, as
 * before. A builder is used linearly by one thread (each append returns the
 * handle it was given).
 */
typedef struct {
    char* buf;
    size_t len;              /* bytes appended */
    size_t cap;              /* bytes allocated in buf, excluding the NUL slot */
} StrSb;

static __attribute__((noinline)) void sb_grow(StrSb* r, size_t n) {
    if (r->len > SIZE_MAX / 2 - n) resid_abort("str_sb: size overflow");
    size_t cap = r->cap ? r->cap * 2 : 64;
    if (cap < r->len + n) cap = r->len + n;
    char* nb = (char*)realloc(r->buf, cap + 1);
    if (!nb) resid_abort("str_sb: out of memory");
    r->buf = nb;
    r->cap = cap;
}

static inline void sb_append_bytes(StrSb* r, const char* s, size_t n) {
    if (r->cap - r->len < n) sb_grow(r, n);
    memcpy(r->buf + r->len, s, n);
    r->len += n;
}

void* str_sb_new(void) {
    StrSb* r = (StrSb*)malloc(sizeof(StrSb));
    if (!r) resid_abort("str_sb_new: out of memory");
    r->buf = NULL;
    r->len = 0;
    r->cap = 0;
    return r;
}

void* str_sb_append(void* b, const char* s) {
    sb_append_bytes((StrSb*)b, s, strlen(s));
    return b;
}

static __attribute__((noinline)) void sb_append_cp_slow(StrSb* r, int64_t cp) {
    char buf[4];
    int n = utf8_encode_cp(cp, buf);
    sb_append_bytes(r, buf, (size_t)n);
}

void* str_sb_append_cp(void* b, int64_t cp) {
    StrSb* r = (StrSb*)b;
    if (__builtin_expect((uint64_t)cp < 0x80 && r->len < r->cap, 1)) {
        r->buf[r->len++] = (char)cp;
        return b;
    }
    sb_append_cp_slow(r, cp);
    return b;
}

char* str_sb_finish(void* b) {
    StrSb* r = (StrSb*)b;
    char* out = r->buf;
    if (!out) {
        out = (char*)malloc(1);
        if (!out) resid_abort("str_sb_finish: out of memory");
    } else if (r->cap > r->len + r->len / 8 + 64) {
        char* shrunk = (char*)realloc(out, r->len + 1);
        if (shrunk) out = shrunk;
    }
    out[r->len] = '\0';
    free(r);
    return out;
}

/* `print(str_sb_finish(b))` / `println(...)`: the finished string is a
 * temporary no other expression can see, so the compiler fuses the pair
 * and the buffer is written, then freed, instead of being kept forever. */
bool resid_sb_print(void* b, int8_t nl) {
    StrSb* r = (StrSb*)b;
    bool ok = true;
    if (r->buf) {
        r->buf[r->len] = '\0';
        if (fputs(r->buf, stdout) == EOF) ok = false;
    }
    if (ok && nl && putchar('\n') == EOF) ok = false;
    if (ok && fflush(stdout) == EOF) ok = false;
    free(r->buf);
    free(r);
    return ok;
}

/* Half-open substring `s[start..end]` by codepoint index (clamped).
 * O(1) endpoint lookup via the byte-offset index above, O(slice length)
 * for the copy itself (unavoidable — the result is a fresh string). */
char* str_slice(const char* s, int64_t start, int64_t end) {
    if (start < 0) start = 0;
    if (end < start) end = start;
    StrIndexSlot* sl = str_index_slot(s);
    int64_t len = sl->len;
    if (start > len) start = len;
    if (end > len) end = len;
    size_t bstart = str_slot_off(sl, start);
    size_t bend = str_slot_off(sl, end);
    size_t n = bend - bstart;
    char* out = (char*)resid_alloc(n + 1);
    if (!out) resid_abort("str_slice: out of memory");
    memcpy(out, s + bstart, n);
    out[n] = '\0';
    return out;
}

/* Codepoint index of the first occurrence of `needle` in `s` at or after
 * codepoint `from`, or -1 when there is none. `from` below 0 is taken as 0;
 * past the end of `s` there is no match. An empty needle matches at `from`.
 * The byte search is strstr; for an all-ASCII `s` the byte offset is the
 * codepoint index, otherwise it is converted through the sparse index. */
/* Rough frequency class of a byte in text (higher = more common), used to
 * pick the needle byte str_index_of hands to memchr. */
static int byte_commonness(unsigned char c) {
    if ((c >= 'a' && c <= 'z') || c == ' ' || c == '\n') return 3;
    if ((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')) return 2;
    return 1;
}

/* First occurrence of needle[0..m) in h[0..n). memchr on the needle's
 * rarest byte finds candidates at memory speed; if candidates keep failing
 * (a pathological needle), the rest goes to memmem's linear-time search. */
static const char* find_bytes(const char* h, size_t n, const char* nd, size_t m) {
    if (m == 0) return h;
    if (m > n) return NULL;
    size_t r = 0;
    for (size_t k = 1; k < m; k++)
        if (byte_commonness((unsigned char)nd[k]) < byte_commonness((unsigned char)nd[r])) r = k;
    const char* end = h + n;
    const char* p = h + r;               /* next place nd[r] may sit */
    size_t misses = 0;
    while (p < end - (m - 1 - r)) {
        const char* hit = (const char*)memchr(p, nd[r], (size_t)(end - (m - 1 - r) - p));
        if (!hit) return NULL;
        const char* cand = hit - r;
        if (memcmp(cand, nd, m) == 0) return cand;
        p = hit + 1;
        if (++misses > 64 && (size_t)(p - h) < misses * 16) {
            return (const char*)memmem(cand + 1, (size_t)(end - cand - 1), nd, m);
        }
    }
    return NULL;
}

int64_t str_index_of(const char* s, const char* needle, int64_t from) {
    StrIndexSlot* sl = str_index_slot(s);
    int64_t len = sl->len;
    if (from < 0) from = 0;
    if (from > len) return -1;
    size_t b = str_slot_off(sl, from);
    const char* q = find_bytes(s + b, sl->blen - b, needle, strlen(needle));
    if (!q) return -1;
    size_t qb = (size_t)(q - s);
    if (!sl->off) return (int64_t)qb;
    int64_t lo = 0, hi = len >> STR_IDX_SHIFT;   /* last checkpoint <= qb */
    while (lo < hi) {
        int64_t mid = (lo + hi + 1) / 2;
        if (sl->off[mid] <= qb) lo = mid; else hi = mid - 1;
    }
    int64_t idx = lo << STR_IDX_SHIFT;
    const unsigned char* p = (const unsigned char*)s + sl->off[lo];
    while ((size_t)((const char*)p - s) < qb) { p += utf8_seq_len(*p); idx++; }
    return idx;
}

/*
 * Boxed value objects.
 *
 * Every product struct and sum variant is a `ResidVal*` with a tag, a slot
 * count, an array of slots, and a type name. A slot for a scalar operand is
 * a heap box (created by resid_box_*); a slot for a string / nested
 * composite is the raw pointer. List values are NOT ResidVal — they use
 * the separate persistent-trie representation (ResidList, see
 * resid_list_new/get/concat/... below) for O(log32 n) push/concat instead
 * of a flat array's O(n) copy-on-every-op.
 */
/* 16 bytes, followed directly by the `count` slots (RV_SLOTS). A tag and a
 * slot count fit in 32 bits each (tags are variant indexes or small runtime
 * markers, counts are field counts), and every variant, record-payload box
 * and Option/Result pays for the header: a two-field record payload makes a
 * 32-byte box. */
typedef struct {
    int32_t tag;
    int32_t count;
    const char* type;
} ResidVal;

#define RV_SLOTS(v) ((void**)((ResidVal*)(v) + 1))

/* Int(128) scalar payloads are only 8-byte aligned (see
 * resid_box_scalar_alloc). */
static inline __int128 ld_i128(const void* p) {
    __int128 v;
    memcpy(&v, p, sizeof v);
    return v;
}

void* resid_box_new(int64_t tag, int64_t count, void** src, const char* type) {
    /* One allocation: the slot array sits right after the header. */
    size_t n = count > 0 ? (size_t)count : 0;
    ResidVal* v = (ResidVal*)resid_alloc(sizeof(ResidVal) + n * sizeof(void*));
    if (!v) resid_abort("resid_box_new: out of memory");
    v->tag = tag;
    v->count = count;
    v->type = type;
    for (int64_t i = 0; i < count; i++) RV_SLOTS(v)[i] = src[i];
    return v;
}

/* resid_box_new without the copy: the caller stores `count` slots right
 * after the header before the box is used (a variant whose record payload
 * is built in place). */
void* resid_box_alloc(int64_t tag, int64_t count, const char* type) {
    size_t n = count > 0 ? (size_t)count : 0;
    ResidVal* v = (ResidVal*)resid_alloc(sizeof(ResidVal) + n * sizeof(void*));
    if (!v) resid_abort("resid_box_alloc: out of memory");
    v->tag = tag;
    v->count = count;
    v->type = type;
    return v;
}

int64_t resid_box_tag(void* b) { return ((ResidVal*)b)->tag; }

int64_t resid_box_count(void* b) { return ((ResidVal*)b)->count; }

void** resid_box_slots(void* b) { return RV_SLOTS(b); }

/* The i-th slot of a boxed object. */
void* resid_box_slot(void* b, int64_t i) { return RV_SLOTS(b)[i]; }

/* A spawn worker ({ fn, captures }), run on a fresh thread. */
typedef struct {
    void* (*worker)(void*);
    void* captures;
} resid_spawn_arg_t;

/* Thread entry for spawn. Installs a catchable-abort target (spec §19) on the
 * region's own thread and runs the worker:
 *   - normal return -> the worker's boxed `Ok(T)` result;
 *   - `resid_abort` inside the worker (e.g. division by zero, bounds abort,
 *     an outstanding `todo`) -> longjmps here, which builds a boxed
 *     `Err(RegionError)` carrying the failure message (child failure is
 *     delivered to the parent as Result, spec §19/§24). */
static void* resid_spawn_entry(void* a) {
    resid_spawn_arg_t* arg = (resid_spawn_arg_t*)a;
    sigjmp_buf jb;
    resid_spawn_catch = &jb;
    if (sigsetjmp(jb, 1) == 0) {
        void* result = arg->worker(arg->captures);
        resid_spawn_catch = NULL;
        return result;
    }
    /* Unwound out of the worker body: build Err(RegionError{message}). */
    const char* msg = resid_spawn_catch_msg ? resid_spawn_catch_msg : "child region aborted";
    resid_spawn_catch = NULL;
    char* m = resid_box_str(msg);
    /* RegionError is a one-field struct: a flat block holding `message`. */
    void** region = (void**)malloc(sizeof(void*));
    region[0] = m;
    return resid_box_new(2, 1, (void*[]){ region }, "Result");
}

/* Ok(payload) as a Result box (tag 1), for spawn workers. */
void* resid_ok_box(void* payload) {
    return resid_box_new(1, 1, (void*[]){ payload }, "Result");
}

/* Structured spawn (spec §19): run `worker(captures)` on a fresh thread and
 * join before returning the result — a boxed `Result(T, RegionError)` that is
 * `Ok(T)` on success or `Err(RegionError)` when the child region aborts. */
void* resid_spawn(void* (*worker)(void*), void* captures) {
    pthread_t t;
    void* ret = NULL;
    resid_spawn_arg_t arg = { worker, captures };
    if (pthread_create(&t, NULL, resid_spawn_entry, &arg) != 0) return NULL;
    pthread_join(t, &ret);
    return ret;
}

void* resid_malloc(size_t size) { return malloc(size); }

/* ── Persistent list (32-way branching trie, Clojure/Scala Vector style) ──
 *
 * Lists were previously ResidVal boxes (a flat void** array): correct, but
 * O(n) per concat and O(n) per copy, so a loop appending one element at a
 * time via List.concat is O(n^2) and re-copies the whole list every step.
 * A persistent trie makes push/concat O(log32 n) amortized while keeping
 * every existing snapshot of a list valid and untouched: path-copying only
 * copies the nodes on the root-to-leaf path; every other node is shared, by
 * pointer, with whatever list it came from. This is a strict, eager
 * structure — every operation computes its full result immediately,
 * nothing here is deferred/thunked, and it has no interaction with comptime
 * reduction (which never evaluates List(_) values — see resid-type's
 * CValue).
 *
 * Separate from ResidVal (which remains the representation for struct and
 * sum values): ResidVal's flat "slots" array has no equivalent in a trie,
 * so most list verbs below flatten to a plain array via
 * resid_list_to_array, operate, and rebuild via resid_list_new. */
#define PVEC_BITS 5
#define PVEC_WIDTH 32
#define PVEC_MASK 31

/* Nodes are sized to exactly the slots they hold (`cap` <= PVEC_WIDTH), not
 * a fixed 32-slot block: most lists in real programs are short (tokens,
 * environments, single-element `[x]` literals fed to concat), and a fixed
 * 256-byte node per short list dominated the allocator in the self-hosted
 * compiler. Every valid index of a list lands in an allocated slot, because
 * a node always covers the populated prefix of its range. */
typedef struct PVecNode {
    int64_t cap;
    void* items[];
} PVecNode;

typedef struct {
    int64_t count;
    int32_t shift;
    PVecNode* root;
    const char* type;
} ResidList;

static PVecNode* pvec_node_new(int64_t cap) {
    PVecNode* n = (PVecNode*)resid_alloc(sizeof(PVecNode) + (size_t)cap * sizeof(void*));
    if (!n) resid_abort("pvec_node_new: out of memory");
    n->cap = cap;
    memset(n->items, 0, (size_t)cap * sizeof(void*));
    return n;
}

static void* pvec_get_raw(PVecNode* root, int32_t shift, int64_t i) {
    PVecNode* node = root;
    for (int32_t level = shift; level > 0; level -= PVEC_BITS) {
        node = (PVecNode*)node->items[(i >> level) & PVEC_MASK];
    }
    return node->items[i & PVEC_MASK];
}

/* Flat lists. A list built from a flat array (literals, slices, map keys,
 * accumulated results) starts as one contiguous FlatBuf instead of a trie:
 * `shift == -1` and `root` points at the FlatBuf. Element reads are then a
 * single indexed load, which the LTO build inlines into user loops.
 *
 * Appends stay persistent without copying: a FlatBuf records how many of
 * its slots are in use (`used`), and a list whose count equals `used` is
 * the buffer's tip, so an append that fits writes the new elements past the
 * end, bumps `used`, and returns a new header over the same buffer. Every
 * older header still sees exactly its own prefix, since slots below `used`
 * are never written again. Appending to a list that is not the tip (a
 * second branch off the same base) copies: small lists into a new FlatBuf,
 * larger ones into a trie, so repeated branching off a big list keeps the
 * trie's O(log32 n) path-copy cost instead of an O(n) copy per branch.
 *
 * A full tip grows by allocating a new, doubled FlatBuf. The old buffer is
 * never resized in place: headers made before an arena push may still point
 * at it, and a realloc from inside the arena would leave them dangling
 * after the pop. */
typedef struct {
    int64_t used;
    int64_t cap;
    void* items[];
} FlatBuf;

#define FLAT_SHIFT (-1)
/* A non-tip append copies into a fresh FlatBuf up to this many elements and
 * into a trie beyond it. */
#define FLAT_BRANCH_COPY_MAX 64

static FlatBuf* flatbuf_new(int64_t cap) {
    FlatBuf* f = (FlatBuf*)resid_alloc(sizeof(FlatBuf) + (size_t)cap * sizeof(void*));
    if (!f) resid_abort("flatbuf_new: out of memory");
    f->used = 0;
    f->cap = cap;
    return f;
}

static inline void* list_at(const ResidList* v, int64_t i) {
    if (v->shift == FLAT_SHIFT) return ((FlatBuf*)v->root)->items[i];
    return pvec_get_raw(v->root, v->shift, i);
}

/* Path-copy: a new node equal to `node` (may be NULL) with slot `slot` set
 * to `val`, grown to cover `slot`. `node` itself is never modified — it is
 * still shared by every list that already points at it. */
static PVecNode* pvec_node_with(PVecNode* node, int64_t slot, void* val) {
    int64_t old = node ? node->cap : 0;
    int64_t cap = slot + 1 > old ? slot + 1 : old;
    PVecNode* out = pvec_node_new(cap);
    if (old) memcpy(out->items, node->items, (size_t)old * sizeof(void*));
    out->items[slot] = val;
    return out;
}

/* Returns a copy of the subtree `node` (at `level`) with leaf number
 * `leaf_idx` (leaf_idx = element index >> PVEC_BITS) replaced by `leaf`. */
static PVecNode* pvec_set_leaf(PVecNode* node, int32_t level, int64_t leaf_idx, PVecNode* leaf) {
    if (level == 0) return leaf;
    int64_t slot = (leaf_idx >> (level - PVEC_BITS)) & PVEC_MASK;
    PVecNode* child = (node && slot < node->cap) ? (PVecNode*)node->items[slot] : NULL;
    return pvec_node_with(node, slot, pvec_set_leaf(child, level - PVEC_BITS, leaf_idx, leaf));
}

/* Append `m` elements to `v`, returning a new list. Works a whole leaf at a
 * time: the partial last leaf of `v` is copied once and filled, then each
 * further run of 32 elements becomes one new leaf. The old list is left
 * untouched (only the root-to-leaf paths are copied). */
static ResidList* trie_from_items(void** items, int64_t n, const char* type);

static ResidList* pvec_append(ResidList* v, void** elems, int64_t m) {
    if (v->shift == FLAT_SHIFT || v->root == NULL) {
        FlatBuf* f = (FlatBuf*)v->root;
        int64_t n = v->count;
        FlatBuf* dst = NULL;
        int64_t expect = n;
        if (f && n + m <= f->cap &&
            __atomic_compare_exchange_n(&f->used, &expect, n + m, 0, __ATOMIC_ACQ_REL, __ATOMIC_ACQUIRE)) {
            /* Tip with room: claim slots n..n+m atomically, so two regions
             * appending to one shared list (spawn may run in parallel,
             * spec §19) never write the same slots; the loser copies. */
            dst = f;
        } else if (!f || __atomic_load_n(&f->used, __ATOMIC_ACQUIRE) == n || n <= FLAT_BRANCH_COPY_MAX) {
            /* Empty, full tip, or a small branch: copy into a new buffer,
             * doubling so a run of appends stays amortized O(1). */
            int64_t cap = f ? (n + m) * 2 : n + m; /* a fresh build is exact-size */
            dst = flatbuf_new(cap);
            if (n > 0) memcpy(dst->items, f->items, (size_t)n * sizeof(void*));
            dst->used = n;
        } else {
            /* Large non-tip branch: fall back to the persistent trie. */
            v = trie_from_items(f->items, n, v->type);
        }
        if (dst) {
            memcpy(dst->items + n, elems, (size_t)m * sizeof(void*));
            if (dst != f) dst->used = n + m;
            ResidList* out = (ResidList*)resid_alloc(sizeof(ResidList));
            if (!out) resid_abort("pvec_append: out of memory");
            out->type = v->type;
            out->count = n + m;
            out->shift = FLAT_SHIFT;
            out->root = (PVecNode*)dst;
            return out;
        }
    }
    ResidList* out = (ResidList*)resid_alloc(sizeof(ResidList));
    if (!out) resid_abort("pvec_append: out of memory");
    out->type = v->type;
    out->count = v->count;
    out->shift = v->shift;
    out->root = v->root;
    int64_t done = 0;
    while (done < m) {
        int64_t idx = out->count;
        int64_t leaf_idx = idx >> PVEC_BITS;
        int64_t in_leaf = idx & PVEC_MASK;
        int64_t take = PVEC_WIDTH - in_leaf;
        if (take > m - done) take = m - done;
        PVecNode* leaf = pvec_node_new(in_leaf + take);
        if (in_leaf > 0) {
            PVecNode* old_leaf = out->root;
            for (int32_t level = out->shift; level > 0; level -= PVEC_BITS)
                old_leaf = (PVecNode*)old_leaf->items[(idx >> level) & PVEC_MASK];
            memcpy(leaf->items, old_leaf->items, (size_t)in_leaf * sizeof(void*));
        }
        memcpy(leaf->items + in_leaf, elems + done, (size_t)take * sizeof(void*));
        if (out->root == NULL) {
            out->root = leaf;
            out->shift = 0;
        } else {
            int64_t capacity = ((int64_t)1) << (out->shift + PVEC_BITS);
            if (idx >= capacity) {
                /* Tree is full: grow a level; the old root becomes child 0. */
                PVecNode* new_root = pvec_node_new(1);
                new_root->items[0] = out->root;
                out->root = new_root;
                out->shift += PVEC_BITS;
            }
            out->root = out->shift == 0 ? leaf : pvec_set_leaf(out->root, out->shift, leaf_idx, leaf);
        }
        out->count += take;
        done += take;
    }
    return out;
}

static ResidList* pvec_push_raw(ResidList* v, void* elem) {
    return pvec_append(v, &elem, 1);
}

/* Build a trie-backed list holding `items` (used when a large flat list is
 * branched: see the flat-list comment above). */
static ResidList* trie_from_items(void** items, int64_t n, const char* type) {
    ResidList* out = (ResidList*)resid_alloc(sizeof(ResidList));
    if (!out) resid_abort("trie_from_items: out of memory");
    out->count = 0;
    out->shift = 0;
    out->root = NULL;
    out->type = type;
    /* pvec_append on an empty list takes the flat path, so seed the trie
     * with its first leaf directly and append the rest as a trie. */
    int64_t first = n < PVEC_WIDTH ? n : PVEC_WIDTH;
    PVecNode* leaf = pvec_node_new(first);
    memcpy(leaf->items, items, (size_t)first * sizeof(void*));
    out->root = leaf;
    out->count = first;
    if (n > first) return pvec_append(out, items + first, n - first);
    return out;
}

/* Build a new persistent list from a flat array of `count` element
 * pointers (scalar slots are boxes, as with the old ResidVal lists). */
void* resid_list_new(int64_t count, void** src, const char* type) {
    ResidList v = { 0, 0, NULL, type };
    if (count == 0) {
        ResidList* e = (ResidList*)resid_alloc(sizeof(ResidList));
        if (!e) resid_abort("resid_list_new: out of memory");
        *e = v;
        return e;
    }
    return pvec_append(&v, src, count);
}

/* Length of a list = its element count. */
int64_t resid_list_len(void* b) { return ((ResidList*)b)->count; }

/* Element `i` of a list (unchecked — callers bounds-check first). */
void* resid_list_get(void* b, int64_t i) {
    ResidList* v = (ResidList*)b;
    /* Bounds-checked: pvec_get_raw walks the trie blind, so an out-of-range
     * index used to return whatever the walk landed on and the caller
     * segfaulted unboxing it. Spec §24 makes this a force-time abort — which
     * a test body also catches, so one bad index fails one test. */
    if (i < 0 || i >= v->count) resid_index_abort(i, v->count, NULL);
    return list_at(v, i);
}

const char* resid_list_type(void* b) { return ((ResidList*)b)->type; }

/* Flatten a list to a fresh void** array (caller frees). Used by list verbs
 * that need direct random access to every element (sort, reverse, sum, ...)
 * rather than one resid_list_get call per element. */
void** resid_list_to_array(void* b) {
    ResidList* v = (ResidList*)b;
    void** out = v->count > 0 ? (void**)malloc((size_t)v->count * sizeof(void*)) : NULL;
    if (v->count > 0 && !out) resid_abort("resid_list_to_array: out of memory");
    for (int64_t i = 0; i < v->count; i++) out[i] = list_at(v, i);
    return out;
}

/* Deep-copies a List(Str) into a fresh, persistent (real-malloc'd,
 * never-arena) List(Str) with identical content — the list structure
 * itself AND every element string's bytes are entirely new memory. Not a
 * generic deep-copy (assumes every element is a raw Str pointer, true
 * for every call site this exists for: a function's finished lines/
 * hlines/glines lists, right before its per-function arena — see
 * resid_arena_push/pop above — gets popped). Call this on an
 * arena-scoped list BEFORE popping that arena; safe to call regardless
 * of whether the source list is actually arena-scoped (a real-heap
 * source just gets an extra, harmless copy).
 *
 * Temporarily clears the current arena for the duration of the copy so
 * every allocation this function makes — including resid_list_to_array's
 * own scratch array and resid_list_new's internal trie-node allocations
 * — goes through the real allocator regardless of which arena was active
 * when this was called, then restores it (the caller pops explicitly
 * right after; restoring first is still correct if it doesn't). */
void* resid_list_str_persist_copy(void* list) {
    ResidList* v = (ResidList*)list;
    int64_t n = v->count;
    void** flat = resid_list_to_array(list);
    Arena* saved_arena = g_current_arena;
    /* The copy has to outlive the current arena, and no more: it goes to
     * the enclosing arena when there is one (freed with that scope), the
     * real heap otherwise. */
    Arena* target = saved_arena ? saved_arena->prev : NULL;
    g_current_arena = target;
    void** copies = n > 0 ? (void**)malloc((size_t)n * sizeof(void*)) : NULL;
    if (n > 0 && !copies) resid_abort("resid_list_str_persist_copy: out of memory");
    for (int64_t i = 0; i < n; i++) {
        const char* src = (const char*)flat[i];
        size_t len = strlen(src);
        char* dst = (char*)resid_alloc(len + 1);
        if (!dst) resid_abort("resid_list_str_persist_copy: out of memory");
        memcpy(dst, src, len + 1);
        copies[i] = dst;
    }
    void* out = resid_list_new(n, copies, v->type);
    if (copies) free(copies);
    g_current_arena = saved_arena;
    if (flat) free(flat);
    return out;
}

/* Constant list literals (every element a compile-time constant). The
 * compiler emits one cache slot per literal and calls these instead of
 * building the list on every evaluation: the first call builds it —
 * outside any arena, so it lives for the whole process — and publishes it
 * in *cache; later calls return the same immutable list. A benign race
 * between threads can build it twice; either copy is equally valid. */
void* resid_box_i64(int64_t v);
void* resid_box_bool(int8_t v);

static void* list_const_publish(void** cache, void* list) {
    __atomic_store_n(cache, list, __ATOMIC_RELEASE);
    return list;
}

void* resid_list_const_i64(void** cache, int64_t n, const int64_t* data, const char* type) {
    void* hit = __atomic_load_n(cache, __ATOMIC_ACQUIRE);
    if (hit) return hit;
    AllocSuspend saved = alloc_suspend();
    void** boxes = (void**)malloc((size_t)(n > 0 ? n : 1) * sizeof(void*));
    if (!boxes) resid_abort("resid_list_const_i64: out of memory");
    for (int64_t i = 0; i < n; i++) boxes[i] = resid_box_i64(data[i]);
    void* list = resid_list_new(n, boxes, type);
    free(boxes);
    alloc_resume(saved);
    return list_const_publish(cache, list);
}

void* resid_list_const_bool(void** cache, int64_t n, const int8_t* data, const char* type) {
    void* hit = __atomic_load_n(cache, __ATOMIC_ACQUIRE);
    if (hit) return hit;
    AllocSuspend saved = alloc_suspend();
    void** boxes = (void**)malloc((size_t)(n > 0 ? n : 1) * sizeof(void*));
    if (!boxes) resid_abort("resid_list_const_bool: out of memory");
    for (int64_t i = 0; i < n; i++) boxes[i] = resid_box_bool(data[i] ? 1 : 0);
    void* list = resid_list_new(n, boxes, type);
    free(boxes);
    alloc_resume(saved);
    return list_const_publish(cache, list);
}

/* Elements are pointers to static data (string literal constants). */
void* resid_list_const_ptr(void** cache, int64_t n, void* const* data, const char* type) {
    void* hit = __atomic_load_n(cache, __ATOMIC_ACQUIRE);
    if (hit) return hit;
    AllocSuspend saved = alloc_suspend();
    void* list = resid_list_new(n, (void**)data, type);
    alloc_resume(saved);
    return list_const_publish(cache, list);
}

/* Convert a list into the length-first flat layout used by the stage-2
 * driver ({ i64 count, [count x ptr] elements }): slot array at offset 8,
 * count at offset 0. Used at the C-runtime boundary so lists returned by
 * resid_map_keys/values and resid_set_to_list match what the driver's list
 * ops (and e.lconcat) expect. */
void* resid_rt_list_to_flat(void* b) {
    ResidList* v = (ResidList*)b;
    int64_t n = v->count;
    void* out = malloc((size_t)n * 8 + 8);
    ((int64_t*)out)[0] = n;
    for (int64_t i = 0; i < n; i++) ((void**)out)[i + 1] = list_at(v, i);
    return out;
}

/* Concatenate two lists: push every element of `b` onto `a`. O(m log32 n) —
 * not optimal for joining two huge lists, but every real call site here
 * concats a handful of elements onto a large accumulator, and this is still
 * overwhelmingly better than the previous O(n) full copy per concat. */
void* resid_list_concat(void* a, void* b) {
    ResidList* x = (ResidList*)a;
    ResidList* y = (ResidList*)b;
    if (y->count == 0) return x;
    if (y->count == 1) return pvec_push_raw(x, list_at(y, 0));
    void** flat = resid_list_to_array(y);
    ResidList* out = pvec_append(x, flat, y->count);
    free(flat);
    return out;
}


/* xs.concat([e]) without the one-element list (codegen peephole). */
void* resid_list_push(void* a, void* elem) {
    return pvec_push_raw((ResidList*)a, elem);
}

/* rt_assert(c, msg) / assert(c, msg): abort with the message unless c. */
void resid_assert(int8_t ok, const char* msg) {
    if (ok) return;
    char buf[512];
    snprintf(buf, sizeof buf, "assertion failed%s%s", msg ? ": " : "", msg ? msg : "");
    resid_abort(buf);
}

/* todo(msg) (kind 0) / unimplemented(msg) (kind 1): abort when reached. */
void resid_todo(int8_t kind, const char* msg) {
    char buf[512];
    snprintf(buf, sizeof buf, "%s%s%s", kind ? "not implemented" : "not yet implemented", msg ? ": " : "", msg ? msg : "");
    resid_abort(buf);
}

/* xs[lo..hi] as a new list (bounds clamped to [0, count], empty when
 * lo >= hi). */
void* resid_list_slice(void* list, int64_t lo, int64_t hi) {
    ResidList* x = (ResidList*)list;
    if (lo < 0) lo = 0;
    if (hi > x->count) hi = x->count;
    int64_t n = hi > lo ? hi - lo : 0;
    void** flat = (void**)malloc((size_t)(n > 0 ? n : 1) * sizeof(void*));
    if (!flat) resid_abort("resid_list_slice: out of memory");
    for (int64_t i = 0; i < n; i++) flat[i] = list_at(x, lo + i);
    void* out = resid_list_new(n, flat, x->type);
    free(flat);
    return out;
}

/* lo..hi (hi exclusive) as a List(Int): Range(Int) values are materialized. */
void* resid_range_list(int64_t lo, int64_t hi) {
    int64_t n = hi > lo ? hi - lo : 0;
    void** flat = (void**)malloc((size_t)(n > 0 ? n : 1) * sizeof(void*));
    if (!flat) resid_abort("resid_range_list: out of memory");
    for (int64_t i = 0; i < n; i++) flat[i] = resid_box_i64(lo + i);
    void* out = resid_list_new(n, flat, "List(Int(64))");
    free(flat);
    return out;
}

/* ── Growable accumulator buffer (perf: O(1)-amortized self-recursive
 * accumulators, replacing per-step copy-and-leak via resid_list_concat) ──
 *
 * Private, opaque intermediate representation. Never exposed to, or
 * producible by, any Resid construct except the compiler's own codegen
 * for a function proven safe by resid-type's growable-accumulator
 * analysis: a self-recursive parameter that starts life as a fresh list
 * literal at *every* call site in the whole program and is never
 * aliased, stored, returned early, or passed to anything but that same
 * recursive call and List.concat. Under that proof, no other live
 * reference to the buffer can exist anywhere, so growing and freeing it
 * in place is sound — this is not a general list representation change,
 * every other List(_) value in the program is still the plain,
 * always-copy ResidVal path in resid_list_concat above.
 *
 * A GrowBuf is created once (resid_growbuf_from_list) from the seed
 * value's elements, mutated in place across every recursive step
 * (resid_growbuf_push_list, amortized doubling — realloc, never a fresh
 * malloc-and-copy-and-leak-the-old-one), and converted to a normal boxed
 * List (resid_growbuf_finish) exactly once, at the base case, by
 * wrapping the *same* backing array — no final copy either. */
typedef struct {
    int64_t count;
    int64_t capacity;
    void** slots;
} GrowBuf;

static void* growbuf_new_raw(void** initial, int64_t n) {
    GrowBuf* g = (GrowBuf*)malloc(sizeof(GrowBuf));
    int64_t cap = n < 4 ? 4 : n * 2;
    g->slots = (void**)malloc((size_t)cap * sizeof(void*));
    for (int64_t i = 0; i < n; i++) g->slots[i] = initial[i];
    g->count = n;
    g->capacity = cap;
    return g;
}

static void* growbuf_push_raw(void* buf, void** elems, int64_t n) {
    GrowBuf* g = (GrowBuf*)buf;
    int64_t needed = g->count + n;
    if (needed > g->capacity) {
        int64_t newcap = g->capacity * 2;
        if (newcap < needed) newcap = needed;
        g->slots = (void**)realloc(g->slots, (size_t)newcap * sizeof(void*));
        g->capacity = newcap;
    }
    for (int64_t i = 0; i < n; i++) g->slots[g->count + i] = elems[i];
    g->count = needed;
    return g;
}

/* Codegen never builds a raw slot array itself — it always has a normal,
 * already-lowered List value on hand (a literal or the result of some other
 * expression the analysis proved fresh), so the two entry points below take
 * that directly: seed a new growbuf from one, or push one's elements onto
 * an existing growbuf. Both flatten the source trie into a scratch array
 * (its nodes are intentionally not freed: analysis guarantees a source
 * value nothing else in the program can ever reference, so the bounded,
 * one-time leak of that value's small node set is the same trade-off the
 * previous flat-ResidVal version already made by not freeing its element
 * pointers) — safe because the analysis that gates these call sites
 * (resid-type's find_growable_accumulators) only ever allows such a
 * source. */
void* resid_growbuf_from_list(void* src) {
    int64_t n = resid_list_len(src);
    void** flat = resid_list_to_array(src);
    void* g = growbuf_new_raw(flat, n);
    free(flat);
    return g;
}

void* resid_growbuf_push_list(void* buf, void* src) {
    int64_t n = resid_list_len(src);
    void** flat = resid_list_to_array(src);
    void* g = growbuf_push_raw(buf, flat, n);
    free(flat);
    return g;
}

void* resid_growbuf_finish(void* buf, const char* type) {
    GrowBuf* g = (GrowBuf*)buf;
    void* out = resid_list_new(g->count, g->slots, type);
    free(g->slots);
    free(g);
    return out;
}

/* Precise free for heap-allocated composites (List/Map/Set/Struct/Box).
 * Called by codegen at the exact last unique use of a tracked root
 * (ownership oracle, resid-type::analyze_ownership). */
static int box_is_interned(const void* p);

/* Frees one element box (not what its slots point at). A scalar box is a
 * single allocation (see resid_box_scalar_alloc); a composite box's slot
 * array is a separate block unless it was laid out inline. */
static void box_free_shallow(ResidVal* val) {
    if (box_is_interned(val)) return;
    free(val);
}

static void free_pvec_node(void* node, int shift) {
    if (!node) return;
    PVecNode* n = (PVecNode*)node;
    if (shift == 0) {
        for (int64_t i = 0; i < n->cap; i++) {
            void* slot = n->items[i];
            if (slot) box_free_shallow((ResidVal*)slot);
        }
    } else {
        for (int64_t i = 0; i < n->cap; i++) {
            free_pvec_node(n->items[i], shift - 5);
        }
    }
    free(n);
}

void resid_list_free(void* b) {
    if (!b) return;
    ResidList* v = (ResidList*)b;
    /* A FlatBuf can be shared by several headers (see the flat-list
     * comment), so only the header is freed. */
    if (v->root && v->shift != FLAT_SHIFT) free_pvec_node(v->root, v->shift);
    free(v);
}

/* resid_map_free / resid_set_free live further down (after HMTrie/HMNode
 * are declared — see the Persistent Map/Set section). */

void resid_struct_free(void* b) {
    if (!b) return;
    ResidVal* v = (ResidVal*)b;
    for (int64_t i = 0; i < v->count; i++) {
        void* slot = RV_SLOTS(v)[i];
        if (slot) box_free_shallow((ResidVal*)slot);
    }
    free(v);
}

void resid_box_free(void* b) {
    if (!b) return;
    ResidVal* v = (ResidVal*)b;
    /* Scalar box (tag == -1, see resid_box_scalar_alloc): struct, slots
     * array, and payload are one combined allocation starting at `v` —
     * a single free() covers all of it. */
    if (box_is_interned(v)) return;
    if (v->tag == -1) { free(v); return; }
    for (int64_t i = 0; i < v->count; i++) {
        void* slot = RV_SLOTS(v)[i];
        if (slot && !box_is_interned(slot)) free(slot);
    }
    free(v);
}

/* Scalar boxes: ResidVal with tag=-1 and one slot holding the value.
 *
 * A scalar box used to be 3 separate mallocs (the ResidVal struct, a
 * 1-element `slots` array, and the payload) for as little as 1 byte of
 * real payload — under glibc's ptmalloc, each malloc carries its own
 * ~16-byte chunk header/alignment overhead, so a boxed bool cost ~3x the
 * allocation count and a large multiple of the payload in overhead alone.
 * Scalars are the hottest allocation in the runtime (every Int/Float/Bool
 * value gets boxed), and this runtime never frees, so that overhead is
 * never reclaimed. Fix: one combined allocation — struct, slots array,
 * and payload laid out contiguously — same external `RV_SLOTS(r)[0]`
 * contract, 1/3 the malloc call count and per-call overhead. */
/* Layout: header, the one-entry slot array, then the payload at
 * SCALAR_PAYLOAD_OFF (8-byte aligned; Int(128) payloads are accessed with
 * memcpy, so they need no more). Every scalar box of every width keeps its payload at the same
 * fixed offset, which lets resid_unbox_* read it without going through
 * slots[0], and keeps a narrower unbox of a wider box (e.g. an Int(128)
 * box read as Int) reading the same low bytes the slots[0] path did. */
#define SCALAR_PAYLOAD_OFF (sizeof(ResidVal) + sizeof(void*))

static void* resid_box_scalar_alloc(size_t payload_size, size_t payload_align, void** out_payload) {
    (void)payload_align;
    char* block = (char*)resid_alloc(SCALAR_PAYLOAD_OFF + ((payload_size + 7) & ~(size_t)7));
    if (!block) resid_abort("resid_box_scalar: out of memory");
    ResidVal* r = (ResidVal*)block;
    r->tag = -1;
    r->count = 1;
    void* payload = block + SCALAR_PAYLOAD_OFF;
    RV_SLOTS(r)[0] = payload;
    *out_payload = payload;
    return r;
}

/* Interned scalar boxes. Boxes are immutable once built, so every box of
 * the same small integer (and each Bool) can be one shared, static object
 * instead of a fresh allocation: list elements and struct slots holding
 * small counters, positions, flags and byte values are by far the most
 * common boxes in real programs. Layout matches resid_box_scalar_alloc
 * exactly (struct, payload, 1-slot array), so unboxing is unchanged. */
#define BOX_I64_LO (-256)
#define BOX_I64_HI 4096
typedef struct { ResidVal v; void* slot; int64_t payload; } InternedI64;
typedef struct { ResidVal v; void* slot; int8_t payload; } InternedBool;
_Static_assert(offsetof(InternedI64, payload) == SCALAR_PAYLOAD_OFF, "interned i64 layout");
_Static_assert(offsetof(InternedBool, payload) == SCALAR_PAYLOAD_OFF, "interned bool layout");
static InternedI64 g_box_i64[BOX_I64_HI - BOX_I64_LO];
static InternedBool g_box_bool[2];

__attribute__((constructor)) static void box_intern_init(void) {
    for (int64_t i = 0; i < BOX_I64_HI - BOX_I64_LO; i++) {
        InternedI64* b = &g_box_i64[i];
        b->v.tag = -1;
        b->v.count = 1;
        b->v.type = "i64";
        b->payload = i + BOX_I64_LO;
        b->slot = &b->payload;
    }
    for (int i = 0; i < 2; i++) {
        InternedBool* b = &g_box_bool[i];
        b->v.tag = -1;
        b->v.count = 1;
        b->v.type = "bool";
        b->payload = (int8_t)i;
        b->slot = &b->payload;
    }
}

static int box_is_interned(const void* p) {
    const char* c = (const char*)p;
    return (c >= (const char*)g_box_i64 && c < (const char*)(g_box_i64 + (BOX_I64_HI - BOX_I64_LO)))
        || (c >= (const char*)g_box_bool && c < (const char*)(g_box_bool + 2));
}

void* resid_box_i64(int64_t v) {
    if (v >= BOX_I64_LO && v < BOX_I64_HI) return &g_box_i64[v - BOX_I64_LO].v;
    void* payload;
    ResidVal* r = (ResidVal*)resid_box_scalar_alloc(sizeof(int64_t), _Alignof(int64_t), &payload);
    r->type = "i64";
    *(int64_t*)payload = v;
    return r;
}
/* Unboxing reads the payload at its fixed offset (see
 * resid_box_scalar_alloc) instead of through slots[0], which drops a
 * dependent load from every element read of a List(Int) / List(Float). */
int64_t resid_unbox_i64(void* p) {
    return *(const int64_t*)((const char*)p + SCALAR_PAYLOAD_OFF);
}

void* resid_box_f64(double v) {
    void* payload;
    ResidVal* r = (ResidVal*)resid_box_scalar_alloc(sizeof(double), _Alignof(double), &payload);
    r->type = "f64";
    *(double*)payload = v;
    return r;
}
double resid_unbox_f64(void* p) {
    return *(const double*)((const char*)p + SCALAR_PAYLOAD_OFF);
}

void* resid_box_bool(int8_t v) {
    if (v == 0 || v == 1) return &g_box_bool[v].v;
    void* payload;
    ResidVal* r = (ResidVal*)resid_box_scalar_alloc(sizeof(int8_t), _Alignof(int8_t), &payload);
    r->type = "bool";
    *(int8_t*)payload = v;
    return r;
}
int8_t resid_unbox_bool(void* p) {
    return *(const int8_t*)((const char*)p + SCALAR_PAYLOAD_OFF);
}

void* resid_box_i128(__int128 v) {
    void* payload;
    ResidVal* r = (ResidVal*)resid_box_scalar_alloc(sizeof(__int128), _Alignof(__int128), &payload);
    r->type = "i128";
    memcpy(payload, &v, sizeof v);
    return r;
}
__int128 resid_unbox_i128(void* p) {
    __int128 v;
    memcpy(&v, (const char*)p + SCALAR_PAYLOAD_OFF, sizeof v);
    return v;
}

void* resid_box_u128(unsigned __int128 v) {
    void* payload;
    ResidVal* r = (ResidVal*)resid_box_scalar_alloc(sizeof(unsigned __int128), _Alignof(unsigned __int128), &payload);
    r->type = "u128";
    memcpy(payload, &v, sizeof v);
    return r;
}
unsigned __int128 resid_unbox_u128(void* p) {
    unsigned __int128 v;
    memcpy(&v, (const char*)p + SCALAR_PAYLOAD_OFF, sizeof v);
    return v;
}

/*
 * Debug/diagnostics helpers so a program can talk about its own values before
 * the standard library's `Show` exists.
 */
char* IntToString(int64_t v) {
    char buf[32];
    snprintf(buf, sizeof(buf), "%lld", (long long)v);
    return resid_box_str(buf);
}

char* UIntToString(uint64_t v) {
    char buf[32];
    snprintf(buf, sizeof(buf), "%llu", (unsigned long long)v);
    return resid_box_str(buf);
}

/* 128-bit integer stringification (wide numeric family, spec §6).
 * LLVM lowers Int(128)/UInt(128) to native i128; the C runtime takes
 * `__int128` / `unsigned __int128` directly (i128 is the C ABI for both). */
char* Int128ToString(__int128 v) {
    char buf[48];
    int neg = v < 0;
    unsigned __int128 u = neg ? (unsigned __int128)(-(v + 1)) + 1 : (unsigned __int128)v;
    char tmp[48];
    int i = 0;
    if (u == 0) {
        tmp[i++] = '0';
    } else {
        while (u > 0) {
            tmp[i++] = (char)('0' + (int)(u % 10));
            u /= 10;
        }
    }
    if (neg) tmp[i++] = '-';
    int j = 0;
    while (i > 0) buf[j++] = tmp[--i];
    buf[j] = '\0';
    return resid_box_str(buf);
}

char* UInt128ToString(unsigned __int128 u) {
    char buf[48];
    char tmp[48];
    int i = 0;
    if (u == 0) {
        tmp[i++] = '0';
    } else {
        while (u > 0) {
            tmp[i++] = (char)('0' + (int)(u % 10));
            u /= 10;
        }
    }
    int j = 0;
    while (i > 0) buf[j++] = tmp[--i];
    buf[j] = '\0';
    return resid_box_str(buf);
}

/* 256/512-bit decimal stringification via u64-limb long division.
 * LLVM lowers Int(256)/Int(512) to arbitrary-width integers; codegen
 * truncates the value into little-endian u64 limbs before calling these,
 * since the C ABI has no native 256-bit type. */
static char* u64_limbs_to_str(const uint64_t* limbs, int count, int neg) {
    char buf[200];
    uint64_t work[8];
    int k;
    for (k = 0; k < count; k++) work[k] = limbs[k];
    if (neg) {
        uint64_t carry = 1;
        for (k = 0; k < count; k++) {
            uint64_t inv = ~work[k];
            work[k] = inv + carry;
            carry = (carry && inv == UINT64_MAX) ? 1 : 0;
        }
    }
    int allzero = 1;
    for (k = 0; k < count; k++) {
        if (work[k]) { allzero = 0; break; }
    }
    char tmp[200];
    int i = 0;
    if (allzero) {
        tmp[i++] = '0';
    } else {
        while (!allzero) {
            uint64_t r = 0;
            for (k = count - 1; k >= 0; k--) {
                __uint128_t cur = ((__uint128_t)r << 64) | work[k];
                work[k] = (uint64_t)(cur / 10);
                r = (uint64_t)(cur % 10);
            }
            tmp[i++] = (char)('0' + (int)r);
            allzero = 1;
            for (k = 0; k < count; k++) {
                if (work[k]) { allzero = 0; break; }
            }
        }
    }
    if (neg) tmp[i++] = '-';
    int j = 0;
    while (i > 0) buf[j++] = tmp[--i];
    buf[j] = '\0';
    return resid_box_str(buf);
}

char* Int256ToString(uint64_t l0, uint64_t l1, uint64_t l2, uint64_t l3) {
    uint64_t limbs[4] = {l0, l1, l2, l3};
    return u64_limbs_to_str(limbs, 4, (int)(l3 >> 63));
}

char* UInt256ToString(uint64_t l0, uint64_t l1, uint64_t l2, uint64_t l3) {
    uint64_t limbs[4] = {l0, l1, l2, l3};
    return u64_limbs_to_str(limbs, 4, 0);
}

char* Int512ToString(uint64_t l0, uint64_t l1, uint64_t l2, uint64_t l3,
                     uint64_t l4, uint64_t l5, uint64_t l6, uint64_t l7) {
    uint64_t limbs[8] = {l0, l1, l2, l3, l4, l5, l6, l7};
    return u64_limbs_to_str(limbs, 8, (int)(l7 >> 63));
}

char* UInt512ToString(uint64_t l0, uint64_t l1, uint64_t l2, uint64_t l3,
                      uint64_t l4, uint64_t l5, uint64_t l6, uint64_t l7) {
    uint64_t limbs[8] = {l0, l1, l2, l3, l4, l5, l6, l7};
    return u64_limbs_to_str(limbs, 8, 0);
}

char* FloatToString(double v) {
    char buf[64];
    snprintf(buf, sizeof(buf), "%.17g", v);
    return resid_box_str(buf);
}

/* ── Float(128) stringification (spec §6.2 — Float(128) is the widest) ───
 * IEEE 754 quadruple: 1 sign + 15 exponent + 112 fraction. Printed as
 * %.36g-style decimal (round-trip for quad) via binary bignum — no
 * libquadmath dependency. */
#define F128_WORDS 260 /* >= 16384/64 + slack: covers the full exponent range */

static void f128_zero(uint64_t* w) { memset(w, 0, F128_WORDS * 8); }

static int f128_is_zero(uint64_t* w) {
    int i;
    for (i = 0; i < F128_WORDS; i++)
        if (w[i]) return 0;
    return 1;
}

static void f128_shl(uint64_t* w, int bits) {
    int ws = bits / 64, bs = bits % 64;
    int i;
    if (bs == 0) {
        for (i = F128_WORDS - 1; i >= ws; i--) w[i] = w[i - ws];
        for (i = 0; i < ws; i++) w[i] = 0;
    } else {
        for (i = F128_WORDS - 1; i >= ws; i--) {
            uint64_t hi = (i - ws - 1 >= 0) ? (w[i - ws - 1] >> (64 - bs)) : 0;
            w[i] = (w[i - ws] << bs) | hi;
        }
        for (i = 0; i < ws; i++) w[i] = 0;
    }
}

static void f128_shr(uint64_t* w, int bits) {
    int ws = bits / 64, bs = bits % 64;
    int i;
    if (bs == 0) {
        for (i = 0; i + ws < F128_WORDS; i++) w[i] = w[i + ws];
        for (i = F128_WORDS - ws; i < F128_WORDS; i++) w[i] = 0;
    } else {
        for (i = 0; i + ws < F128_WORDS; i++) {
            uint64_t lo = (i + ws + 1 < F128_WORDS) ? (w[i + ws + 1] << (64 - bs)) : 0;
            w[i] = (w[i + ws] >> bs) | lo;
        }
        for (i = F128_WORDS - ws; i < F128_WORDS; i++) w[i] = 0;
    }
}

/* w *= 10, keeping the low bits (top carry is dropped). */
static void f128_mul10(uint64_t* w) {
    uint64_t carry = 0;
    int i;
    for (i = 0; i < F128_WORDS; i++) {
        __uint128_t t = (__uint128_t)w[i] * 10 + carry;
        w[i] = (uint64_t)t;
        carry = (uint64_t)(t >> 64);
    }
}

/* Divide w by 10 in place, returning the remainder digit. */
static uint64_t f128_div10(uint64_t* w) {
    uint64_t r = 0;
    int i;
    for (i = F128_WORDS - 1; i >= 0; i--) {
        __uint128_t cur = ((__uint128_t)r << 64) | w[i];
        w[i] = (uint64_t)(cur / 10);
        r = (uint64_t)(cur % 10);
    }
    return r;
}

/* Copy a small (<= 128-bit) value into the bignum. */
static void f128_load(uint64_t* w, unsigned __int128 v) {
    f128_zero(w);
    w[0] = (uint64_t)v;
    w[1] = (uint64_t)(v >> 64);
}

char* Float128ToString(_Float128 v) {
    unsigned __int128 u;
    memcpy(&u, &v, 16);
    int neg = (int)(u >> 127);
    unsigned expf = (unsigned)((u >> 112) & 0x7FFF);
    unsigned __int128 mask = (((unsigned __int128)1) << 112) - 1;
    unsigned __int128 frac = u & mask;

    char buf[96];
    if (expf == 0x7FFF) {
        snprintf(buf, sizeof(buf), frac ? "nan" : (neg ? "-inf" : "inf"));
        return resid_box_str(buf);
    }

    unsigned __int128 M;
    int E;
    if (expf == 0) { /* zero or subnormal */
        M = frac;
        E = -16382 - 112;
    } else {
        M = (((unsigned __int128)1) << 112) | frac;
        E = (int)expf - 16383 - 112;
    }

    uint64_t m[F128_WORDS];
    f128_load(m, M);

    char ibuf[5000]; /* integer digits, reversed; 2^16384 ~= 10^4932 digits max */
    int ilen = 0;
    int dec_exp; /* decimal exponent of the leading digit (units = 0) */
    char fdig[64]; /* fraction digits */
    int flen = 0;

    if (E >= 0) {
        f128_shl(m, E);
        if (f128_is_zero(m)) {
            return resid_box_str("0");
        }
        while (!f128_is_zero(m) && ilen < 5000) {
            ibuf[ilen++] = (char)('0' + (int)f128_div10(m));
        }
        dec_exp = ilen - 1;
    } else {
        int nb = -E;
        uint64_t ipart[F128_WORDS];
        uint64_t rem[F128_WORDS];
        f128_zero(rem);
        f128_load(rem, M);
        f128_shr(rem, nb);
        if (f128_is_zero(rem)) {
            /* no integer part */
            dec_exp = -1;
            /* fraction = M mod 2^nb */
            f128_zero(m);
            f128_load(m, M);
            {
                int widx = nb / 64, rem = nb % 64;
                for (int i = widx + 1; i < F128_WORDS; i++) m[i] = 0;
                if (rem != 0) m[widx] &= ((((uint64_t)1) << rem) - 1);
            }
            /* else nb >= 128: M < 2^113 so the whole M is the fraction */
        } else {
            memcpy(ipart, rem, F128_WORDS * 8);
            while (!f128_is_zero(ipart) && ilen < 5000) {
                ibuf[ilen++] = (char)('0' + (int)f128_div10(ipart));
            }
            dec_exp = ilen - 1;
            /* fraction = M mod 2^nb */
            f128_zero(m);
            f128_load(m, M);
            {
                int widx = nb / 64, rem = nb % 64;
                for (int i = widx + 1; i < F128_WORDS; i++) m[i] = 0;
                if (rem != 0) m[widx] &= ((((uint64_t)1) << rem) - 1);
            }
        }
        /* generate fraction digits from m (remainder scaled by 2^nb) */
        if (!f128_is_zero(m)) {
            int widx = nb / 64, rem = nb % 64;
            for (int k = 0; k < 44; k++) {
                f128_mul10(m);
                /* digit = (m*10) >> nb  (top bits, in [0,9]) */
                uint64_t hi;
                if (rem == 0) hi = m[widx];
                else hi = (m[widx] >> rem) | (m[widx + 1] << (64 - rem));
                fdig[flen++] = (char)('0' + (int)(hi & 0xF));
                /* m &= (2^nb - 1) */
                {
                    int i;
                    for (i = widx + 1; i < F128_WORDS; i++) m[i] = 0;
                    if (rem != 0) m[widx] &= ((((uint64_t)1) << rem) - 1);
                }
                if (f128_is_zero(m)) break;
            }
        }
    }

    /* Now: ilen integer digits (reversed in ibuf), flen fraction digits.
     * For the no-integer-part case dec_exp was set to -1; if the fraction
     * starts with zeros, adjust dec_exp accordingly. */
    (void)ilen;
    if (ilen == 0) {
        /* leading zeros in fraction */
        int lead = 0;
        while (lead < flen && fdig[lead] == '0') lead++;
        if (lead == flen) {
            return resid_box_str(neg ? "-0" : "0");
        }
        dec_exp = -lead - 1;
        /* shift fraction digits left by `lead` */
        for (int k = lead; k < flen; k++) fdig[k - lead] = fdig[k];
        flen -= lead;
    }

    /* Assemble up to 36 significant digits (round-trip for quad) with rounding
     * (half away from zero). */
    char digits[40];
    int ndig = 0;
    /* integer digits */
    for (int k = ilen - 1; k >= 0 && ndig < 37; k--) digits[ndig++] = ibuf[k];
    /* fraction digits */
    for (int k = 0; k < flen && ndig < 37; k++) digits[ndig++] = fdig[k];
    if (ndig > 36) {
        /* round 37th */
        if (digits[36] >= '5') {
            int k = 35;
            while (k >= 0) {
                if (digits[k] == '9') { digits[k] = '0'; k--; }
                else { digits[k]++; break; }
            }
            if (k < 0) {
                /* all 9s: 9.999... -> 1.000... with dec_exp+1 */
                digits[0] = '1';
                for (int j = 1; j < 36; j++) digits[j] = '0';
                dec_exp++;
            }
        }
        ndig = 36;
    }
    /* strip trailing zeros */
    while (ndig > 1 && digits[ndig - 1] == '0') ndig--;

    /* format like %.36g */
    char out[96];
    int o = 0;
    if (neg) out[o++] = '-';
    if (dec_exp >= -6 && dec_exp <= 36) {
        /* fixed notation */
        if (dec_exp < 0) {
            out[o++] = '0'; out[o++] = '.';
            for (int z = 0; z < -dec_exp - 1 && o < 90; z++) out[o++] = '0';
            for (int k = 0; k < ndig; k++) out[o++] = digits[k];
        } else {
            for (int k = 0; k <= dec_exp; k++) {
                out[o++] = (k < ndig) ? digits[k] : '0';
            }
            if (dec_exp + 1 < ndig) {
                out[o++] = '.';
                for (int k = dec_exp + 1; k < ndig; k++) out[o++] = digits[k];
            }
        }
    } else {
        /* scientific: d.ddd...E±ee */
        out[o++] = digits[0];
        if (ndig > 1) {
            out[o++] = '.';
            for (int k = 1; k < ndig; k++) out[o++] = digits[k];
        }
        out[o++] = 'E';
        if (dec_exp >= 0) out[o++] = '+';
        else { out[o++] = '-'; dec_exp = -dec_exp; }
        if (dec_exp < 10) out[o++] = '0';
        snprintf(out + o, sizeof(out) - o, "%d", dec_exp);
        o = (int)strlen(out);
    }
    out[o] = '\0';
    return resid_box_str(out);
}

char* BoolToString(int8_t v) {
    char buf[16];
    snprintf(buf, sizeof(buf), "%s", v ? "true" : "false");
    return resid_box_str(buf);
}

/*
 * Format a boxed composite value (Option/Some/None/List/Struct) as a
 * human-readable string: `[Some 42]`, `42`, `[1, 2, 3]`, etc.
 *
 * Tag conventions (must match resid-codegen build_constructor):
 *   0 = list or anonymous struct,
 *   1 = Some, 2 = None, etc.
 *
 * This is a bootstrap helper — the real stdlib will use a Show typeclass.
 */
char* ToString(void* boxed) {
    ResidVal* val = (ResidVal*)boxed;
    if (!val || val->count <= 0) {
        return resid_box_str("null");
    }

    /* Scalar box (tag -1): the value IS the content, not a container of
     * slots. Without this case a boxed Int fell through to the struct
     * branch below and rendered as "i64(...)" — which is what every
     * expectation diff over a scalar used to show. */
    if (val->tag == -1) {
        char s[64];
        if (val->type && strcmp(val->type, "i128") == 0) {
            return Int128ToString(resid_unbox_i128(boxed));
        }
        if (val->type && strcmp(val->type, "u128") == 0) {
            return UInt128ToString((unsigned __int128)resid_unbox_i128(boxed));
        }
        if (val->type && val->type[0] == 'f') {
            snprintf(s, sizeof s, "%.17g", resid_unbox_f64(boxed));
        } else if (val->type && val->type[0] == 'b') {
            snprintf(s, sizeof s, "%s", resid_unbox_bool(boxed) ? "true" : "false");
        } else {
            snprintf(s, sizeof s, "%lld", (long long)resid_unbox_i64(boxed));
        }
        return resid_box_str(s);
    }

    /* Tag 1 = Some, tag 2 = None (built-in Option). */
    if (val->tag == 1 && val->count == 1 && RV_SLOTS(val)[0]) {
        /* Some(x) — unbox the inner value and format it. */
        int64_t inner_tag = resid_box_tag(RV_SLOTS(val)[0]);
        if (inner_tag == -1) {
            ResidVal* sv = (ResidVal*)RV_SLOTS(val)[0];
            char inner_buf[64];
            if (sv->type[0] == 'f') {
                double dv = resid_unbox_f64(RV_SLOTS(val)[0]);
                snprintf(inner_buf, sizeof(inner_buf), "%.17g", dv);
            } else if (sv->type[0] == 'b') {
                int8_t bv = resid_unbox_bool(RV_SLOTS(val)[0]);
                snprintf(inner_buf, sizeof(inner_buf), "%s", bv ? "true" : "false");
            } else {
                int64_t iv = resid_unbox_i64(RV_SLOTS(val)[0]);
                snprintf(inner_buf, sizeof(inner_buf), "%lld", (long long)iv);
            }
            char* out = (char*)malloc(strlen(inner_buf) + 10);
            sprintf(out, "Some(%s)", inner_buf);
            return out;
        }
        /* Nested composite — just print the tag. */
        char* out = (char*)malloc(strlen(val->type) + 20);
        sprintf(out, "Some<%s>", val->type);
        return out;
    }
    if (val->tag == 2) {
        /* None */
        return resid_box_str("None");
    }

    /* List or struct: iterate slots. */
    size_t len = strlen(val->type);
    size_t buf_size = len + 64 + (val->count * 48);
    char* buf = (char*)malloc(buf_size);
    snprintf(buf, buf_size, "%s(", val->type);
    for (int64_t i = 0; i < val->count; i++) {
        if (i > 0) strcat(buf, ", ");
        void* slot = RV_SLOTS(val)[i];
        if (!slot) {
            strcat(buf, "null");
            continue;
        }
        int64_t tag = resid_box_tag(slot);
        if (tag == -1) {
            ResidVal* sv = (ResidVal*)slot;
            if (sv->type[0] == 'f') {
                double dv = resid_unbox_f64(slot);
                char s[64];
                snprintf(s, sizeof(s), "%.17g", dv);
                strcat(buf, s);
            } else if (sv->type[0] == 'b') {
                int8_t bv = resid_unbox_bool(slot);
                strcat(buf, bv ? "true" : "false");
            } else {
                int64_t iv = resid_unbox_i64(slot);
                char s[32];
                snprintf(s, sizeof(s), "%lld", (long long)iv);
                strcat(buf, s);
            }
        } else {
            strcat(buf, "…");
        }
    }
    strcat(buf, ")");
    return buf;
}

/* Format a List value as "Type(e1, e2, ...)" — same scalar-vs-nested
 * formatting as ToString's iterate-slots branch above, but over the trie:
 * lists are ResidList, not ResidVal, so they can't share that function's
 * direct slot access. (Nested list-in-list elements fall through to "…"
 * the same imprecise way nested struct/sum elements already do above —
 * this bootstrap formatter was never a real recursive Show.) */
char* resid_list_to_string(void* boxed) {
    if (!boxed) return resid_box_str("null");
    ResidList* val = (ResidList*)boxed;
    size_t len = strlen(val->type);
    size_t buf_size = len + 64 + (size_t)val->count * 48;
    char* buf = (char*)malloc(buf_size);
    snprintf(buf, buf_size, "%s(", val->type);
    for (int64_t i = 0; i < val->count; i++) {
        if (i > 0) strcat(buf, ", ");
        void* slot = list_at(val, i);
        if (!slot) {
            strcat(buf, "null");
            continue;
        }
        int64_t tag = resid_box_tag(slot);
        if (tag == -1) {
            ResidVal* sv = (ResidVal*)slot;
            if (sv->type[0] == 'f') {
                double dv = resid_unbox_f64(slot);
                char s[64];
                snprintf(s, sizeof(s), "%.17g", dv);
                strcat(buf, s);
            } else if (sv->type[0] == 'b') {
                int8_t bv = resid_unbox_bool(slot);
                strcat(buf, bv ? "true" : "false");
            } else {
                int64_t iv = resid_unbox_i64(slot);
                char s[32];
                snprintf(s, sizeof(s), "%lld", (long long)iv);
                strcat(buf, s);
            }
        } else {
            strcat(buf, "…");
        }
    }
    strcat(buf, ")");
    return buf;
}

/*
 * Conversion helpers (spec §6.7): cast to target width, then back to the
 * default scalar width (i64 for integers, double for floats) for the return.
 * The LLVM type of the return matches the target width so the caller's
 * widening logic can handle any subsequent widening correctly.
 *
 * Wide types (128+ bit) are software-emulated; for now they are not
 * directly callable — the codegen raises an error.
 */

/* ── Signed integer helpers ────────────────────────────────────── */
int8_t i8(int64_t v) { return (int8_t)v; }
int16_t i16(int64_t v) { return (int16_t)v; }
int32_t i32(int64_t v) { return (int32_t)v; }
int64_t i64(int64_t v) { return v; }
/* i128 — __int128 is a GCC/Clang extension. i256, i512 not supported. */
#ifdef __SIZEOF_INT128__
__int128 i128(int64_t v) { return (__int128)v; }
#else
__int128 i128(int64_t v) { return v; }
#endif

/* ── Unsigned integer helpers ──────────────────────────────────── */
uint8_t u8(uint64_t v) { return (uint8_t)v; }
uint16_t u16(uint64_t v) { return (uint16_t)v; }
uint32_t u32(uint64_t v) { return (uint32_t)v; }
uint64_t u64(uint64_t v) { return v; }
/* u128, u256, u512 — not supported in C natively (software-emulated). */

/* ── Float helpers (receive double, return target-width float) ─── */
_Float16 f16(double v) { return (_Float16)(float)v; }
float f32(double v) { return (float)v; }
double f64(double v) { return v; }
_Float128 f128(double v) { return (_Float128)v; }

/* ── Pointer-sized helpers ─────────────────────────────────────── */
int64_t isize(int64_t v) { return v; }
uint64_t usize(uint64_t v) { return v; }

/*
 * Checked/wrapping/saturating arithmetic (spec §6.5).
 *
 * Checked arithmetic for the default operators (+, -, *, /, %) is handled
 * in LLVM codegen: overflow is detected with icmp + select/branch, and on
 * overflow the runtime calls resid_abort.
 *
 * Wrapping and saturating variants are exposed here as extern functions.
 * They are callable from Resid source (e.g. `wrapping_add(a, b)`).
 */

/* Default-operator checked arithmetic trap (spec §6.5): codegen computes
 * narrow add/sub with llvm.{s,u}{add,sub}.with.overflow and passes the
 * overflow flag here, so no extra basic block is needed at the use site. */
void resid_overflow_check(int8_t overflowed) {
    if (overflowed) resid_abort("integer overflow in checked arithmetic");
}
void resid_div_check(int8_t zero) {
    if (zero) resid_abort("integer division by zero");
}
void resid_conv_check(int8_t bad) {
    if (bad) resid_abort("numeric conversion out of range");
}

/* ── Wrapping operations (C integer overflow is well-defined: wrap) ─ */
int64_t wrapping_add(int64_t a, int64_t b) { return a + b; }
int64_t wrapping_sub(int64_t a, int64_t b) { return a - b; }
int64_t wrapping_mul(int64_t a, int64_t b) { return a * b; }
int64_t wrapping_div(int64_t a, int64_t b) {
    if (b == 0) resid_abort("wrapping_div: division by zero");
    return a / b;
}
uint64_t wrapping_uadd(uint64_t a, uint64_t b) { return a + b; }
uint64_t wrapping_usub(uint64_t a, uint64_t b) { return a - b; }
uint64_t wrapping_umul(uint64_t a, uint64_t b) { return a * b; }
uint64_t wrapping_udiv(uint64_t a, uint64_t b) {
    if (b == 0) resid_abort("wrapping_udiv: division by zero");
    return a / b;
}

/* ── Saturating operations ─────────────────────────────────────── */
int64_t saturating_add(int64_t a, int64_t b) {
    if (b > 0 && a > INT64_MAX - b) return INT64_MAX;
    if (b < 0 && a < INT64_MIN - b) return INT64_MIN;
    return a + b;
}
int64_t saturating_sub(int64_t a, int64_t b) {
    if (b < 0 && a > INT64_MAX + b) return INT64_MAX;
    if (b > 0 && a < INT64_MIN + b) return INT64_MIN;
    return a - b;
}
int64_t saturating_mul(int64_t a, int64_t b) {
    if (a == 0 || b == 0) return 0;
    int64_t r = a * b;
    /* Check overflow: if (a > 0 && b > 0 && r < 0) || (a < 0 && b < 0 && r > 0) ||
       (a > 0 && b < 0 && r > 0) || (a < 0 && b > 0 && r < 0) */
    if ((a > 0 && b > 0 && r < 0) || (a < 0 && b < 0 && r > 0) ||
        (a > 0 && b < 0 && r > 0) || (a < 0 && b > 0 && r < 0)) {
        return (a > 0) == (b > 0) ? INT64_MAX : INT64_MIN;
    }
    return r;
}
uint64_t saturating_uadd(uint64_t a, uint64_t b) {
    if (b > 0 && a > UINT64_MAX - b) return UINT64_MAX;
    return a + b;
}
uint64_t saturating_usub(uint64_t a, uint64_t b) {
    if (b > a) return 0;
    return a - b;
}
uint64_t saturating_umul(uint64_t a, uint64_t b) {
    if (a == 0 || b == 0) return 0;
    uint64_t r = a * b;
    if (a != 0 && r / a != b) return UINT64_MAX;
    return r;
}

/* ── Checked operations (returns result; caller checks via overflow flag) ─ */
/* These return the computation result; the caller must have emitted an
   overflow check before calling. For division by zero, resid_abort is called. */
int64_t checked_add(int64_t a, int64_t b) { return a + b; }
int64_t checked_sub(int64_t a, int64_t b) { return a - b; }
int64_t checked_mul(int64_t a, int64_t b) { return a * b; }
int64_t checked_div(int64_t a, int64_t b) {
    if (b == 0) resid_abort("checked_div: division by zero");
    return a / b;
}
uint64_t checked_uadd(uint64_t a, uint64_t b) { return a + b; }
uint64_t checked_usub(uint64_t a, uint64_t b) { return a - b; }
uint64_t checked_umul(uint64_t a, uint64_t b) { return a * b; }
uint64_t checked_udiv(uint64_t a, uint64_t b) {
    if (b == 0) resid_abort("checked_udiv: division by zero");
    return a / b;
}
/*
 * Range and Slice runtime support (spec §15).
 *
 * Range: a boxed value with start, end, and closed flag.
 * Slice: a boxed value pointing into a list's data with start/end indices.
 */
void* resid_range_new(int64_t start, int64_t end, int8_t closed) {
    int64_t* s = (int64_t*)malloc(sizeof(int64_t));
    *s = start;
    int64_t* e = (int64_t*)malloc(sizeof(int64_t));
    *e = end;
    int8_t* c = (int8_t*)malloc(sizeof(int8_t));
    *c = closed;
    void* slots[3] = { s, e, c };
    return resid_box_new(10, 3, slots, "Range");
}

void* resid_slice_new(void* target, int64_t start, int64_t end) {
    void* t = target;
    int64_t* s = (int64_t*)malloc(sizeof(int64_t));
    *s = start;
    int64_t* e = (int64_t*)malloc(sizeof(int64_t));
    *e = end;
    void* slots[3] = { t, s, e };
    return resid_box_new(11, 3, slots, "Slice");
}

/*
 * Trusted providers (spec §32): filesystem, environment, git.
 *
 * Bootstrap: the kernel allows these unconditionally (a real build will gate
 * them behind capability authorization). Verbaturn links backward to the
 * `PROVIDER_VERBS` table in resid-type; adding a verb here must be mirrored
 * there and in resid-codegen's `lower_provider_call`.
 */
/* Is `path` a directory? `filesystem.list_dir` cannot tell (it shells out
 * to `ls -1`, names only); a recursive directory walker needs this. */
int8_t resid_fs_is_dir(const char* path) {
    if (!resid_path_is_safe(path)) return 0;
    struct stat st;
    if (stat(path, &st) != 0) return 0;
    return S_ISDIR(st.st_mode) ? 1 : 0;
}

/* mkdir -p: create `path` and every missing parent directory. Returns 1 on
 * success (including "already exists as a directory"), 0 on failure. */
int8_t resid_fs_create_dir_all(const char* path) {
    if (!resid_path_is_safe(path)) return 0;
    size_t len = strlen(path);
    if (len == 0) return 0;
    char buf[4096];
    if (len >= sizeof(buf)) return 0;
    memcpy(buf, path, len + 1);
    for (size_t i = 1; i < len; i++) {
        if (buf[i] == '/') {
            buf[i] = '\0';
            if (buf[0] != '\0' && mkdir(buf, 0777) != 0 && errno != EEXIST) return 0;
            buf[i] = '/';
        }
    }
    if (mkdir(buf, 0777) != 0 && errno != EEXIST) return 0;
    struct stat st;
    if (stat(buf, &st) != 0) return 0;
    return S_ISDIR(st.st_mode) ? 1 : 0;
}

int8_t resid_fs_exists(const char* path) {
    if (!resid_path_is_safe(path)) return 0;
    FILE* f = fopen(path, "rb");
    if (!f) return 0;
    fclose(f);
    return 1;
}

/* Read an entire file into a NUL-terminated Str (bootstrap lexer input).
 * On error, returns an empty string (mirrors the env/empty-string default).
 * A regular file is read in one piece at its stat size; anything else (a
 * pipe, a terminal, /dev/stdin on a pipe) is read to end of file into a
 * geometrically grown buffer. */
char* resid_fs_read_all(const char* path) {
    if (!resid_path_is_safe(path)) return resid_box_str("");
    FILE* f = fopen(path, "rb");
    if (!f) return resid_box_str("");
    struct stat st;
    size_t cap = 0;
    if (fstat(fileno(f), &st) == 0 && S_ISREG(st.st_mode) && st.st_size > 0) {
        /* Reads start at the file's current offset (0 for a fresh open; an
         * inherited stdin may have been read already). */
        off_t pos = lseek(fileno(f), 0, SEEK_CUR);
        cap = (size_t)st.st_size - (pos > 0 && pos < st.st_size ? (size_t)pos : 0);
    }
    if (cap == 0) cap = 65536;
    char* p = (char*)malloc(cap + 1);
    if (!p) {
        fclose(f);
        return resid_box_str("");
    }
    size_t n = 0;
    for (;;) {
        size_t got = fread(p + n, 1, cap - n, f);
        n += got;
        if (n < cap) break;              /* EOF or error */
        int c = fgetc(f);                /* at the expected size: any more? */
        if (c == EOF) break;
        if (cap > SIZE_MAX / 2 - 1) break;
        size_t ncap = cap * 2;
        char* np = (char*)realloc(p, ncap + 1);
        if (!np) break;
        p = np;
        cap = ncap;
        p[n++] = (char)c;
    }
    fclose(f);
    p[n] = '\0';
    return p;
}

/* Write `contents` to `path`, truncating if it exists. Returns 1 on success,
 * 0 on failure (M6 P1 — the self-hosted compiler emits `.ll` files). */
int8_t resid_fs_write_all(const char* path, const char* contents) {
    if (!resid_path_is_safe(path)) return 0;
    FILE* f = fopen(path, "wb");
    if (!f) return 0;
    size_t n = fwrite(contents, 1, strlen(contents), f);
    int ok = (n == strlen(contents)) && (fclose(f) == 0);
    if (!ok) fclose(f);
    return ok ? 1 : 0;
}

/* Write raw bytes (List(Int), each element 0-255) to `path`, truncating if
 * it exists. Returns 1 on success, 0 on failure. `Str` always UTF-8-encodes
 * on write (a codepoint like 153 serializes as two bytes, c2 99) so any
 * format needing exact byte control (e.g. a CBOR sidecar) must go through
 * this instead of resid_fs_write_all. */
int8_t resid_fs_write_bytes(const char* path, void* list_box) {
    if (!resid_path_is_safe(path)) return 0;
    int64_t n = resid_list_len(list_box);
    unsigned char* buf = (unsigned char*)malloc((size_t)(n > 0 ? n : 1));
    for (int64_t i = 0; i < n; i++) {
        buf[i] = (unsigned char)(resid_unbox_i64(resid_list_get(list_box, i)) & 0xFF);
    }
    FILE* f = fopen(path, "wb");
    if (!f) { free(buf); return 0; }
    size_t written = fwrite(buf, 1, (size_t)n, f);
    int closed = fclose(f) == 0;
    free(buf);
    return (written == (size_t)n && closed) ? 1 : 0;
}

/* print_bytes(List(Int)): each element's low 8 bits, as raw bytes, to
 * stdout (the stream print writes; no NUL or UTF-8 restrictions). */
int8_t resid_print_bytes(void* list_box) {
    ResidList* v = (ResidList*)list_box;
    int64_t n = v->count;
    unsigned char buf[8192];
    int64_t i = 0;
    while (i < n) {
        int64_t k = 0;
        for (; k < (int64_t)sizeof buf && i < n; k++, i++)
            buf[k] = (unsigned char)(resid_unbox_i64(list_at(v, i)) & 0xFF);
        if (fwrite(buf, 1, (size_t)k, stdout) != (size_t)k) return 0;
    }
    return fflush(stdout) == EOF ? 0 : 1;
}

/* Read `path` as raw bytes into a List(Int) (each element 0-255), or an
 * empty list on failure/missing file — the read-side counterpart to
 * resid_fs_write_bytes. */
void* resid_fs_read_bytes(const char* path) {
    if (!resid_path_is_safe(path)) return resid_list_new(0, NULL, "List(Int(64))");
    FILE* f = fopen(path, "rb");
    if (!f) return resid_list_new(0, NULL, "List(Int(64))");
    if (fseek(f, 0, SEEK_END) != 0) { fclose(f); return resid_list_new(0, NULL, "List(Int(64))"); }
    long sz = ftell(f);
    if (sz < 0 || fseek(f, 0, SEEK_SET) != 0) { fclose(f); return resid_list_new(0, NULL, "List(Int(64))"); }
    unsigned char* buf = (unsigned char*)malloc((size_t)(sz > 0 ? sz : 1));
    size_t n = fread(buf, 1, (size_t)sz, f);
    fclose(f);
    void** slots = (void**)malloc((size_t)(n > 0 ? n : 1) * sizeof(void*));
    for (size_t i = 0; i < n; i++) slots[i] = resid_box_i64((int64_t)buf[i]);
    void* out = resid_list_new((int64_t)n, slots, "List(Int(64))");
    free(slots);
    free(buf);
    return out;
}

void* resid_fs_list_dir(const char* path) {
    DIR* d = opendir(path);
    if (!d) {
        return resid_list_new(0, NULL, "List(Str)");
    }
    void** slots = NULL;
    size_t cap = 0;
    size_t n = 0;
    struct dirent* e;
    while ((e = readdir(d)) != NULL) {
        if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0) continue;
        if (n >= cap) {
            cap = cap == 0 ? 64 : cap * 2;
            void** ns = (void**)realloc(slots, cap * sizeof(void*));
            if (!ns) break;
            slots = ns;
        }
        slots[n++] = resid_box_str(e->d_name);
    }
    closedir(d);
    void* out = resid_list_new((int64_t)n, slots, "List(Str)");
    free(slots);
    return out;
}

/* ─────────────────────────────────────────────────────────────
 * Handles (spec §16).
 *
 * A handle is an identity-bearing resource box. A File handle (tag 12) wraps
 * a `FILE*` in slot 0. `with` blocks release their handles automatically via
 * `resid_handle_release` (reverse binding order); `filesystem.close` releases
 * one explicitly.
 * ───────────────────────────────────────────────────────────── */
#define FILE_HANDLE_TAG 12

void* resid_fs_open(const char* path) {
    /* Handle boxes are released with free() (resid_handle_release,
     * resid_fs_close), so they always come from the plain heap. */
    FILE* f = resid_path_is_safe(path) ? fopen(path, "rb") : NULL;
    void* slots[1] = { f };
    AllocSuspend sus = alloc_suspend();
    void* h = resid_box_new(FILE_HANDLE_TAG, 1, slots, "File");
    alloc_resume(sus);
    return h;
}

/* Read the whole file from a File handle (rewinding first). Returns a
 * NUL-terminated Str; empty on failure. Exercises the handle's identity: the
 * data is read through the handle, not by re-opening the path. */
char* resid_fs_read_handle(void* b) {
    if (!b) return resid_box_str("");
    ResidVal* v = (ResidVal*)b;
    if (v->tag != FILE_HANDLE_TAG || v->count < 1) return resid_box_str("");
    FILE* f = (FILE*)RV_SLOTS(v)[0];
    if (!f) return resid_box_str("");
    if (fseek(f, 0, SEEK_END) != 0) return resid_box_str("");
    long sz = ftell(f);
    if (sz < 0 || fseek(f, 0, SEEK_SET) != 0) return resid_box_str("");
    char* p = (char*)malloc((size_t)sz + 1);
    if (!p) return resid_box_str("");
    size_t n = fread(p, 1, (size_t)sz, f);
    p[n] = '\0';
    return p;
}

/* Explicit close of one File handle. Returns 1 on success, 0 if the handle is
 * null or was already released. Frees the handle box. */
int8_t resid_fs_close(void* b) {
    if (!b) return 0;
    ResidVal* v = (ResidVal*)b;
    if (v->tag == FILE_HANDLE_TAG && v->count >= 1) {
        FILE* f = (FILE*)RV_SLOTS(v)[0];
        if (f) fclose(f);
    }
    free(v);
    return 1;
}

/* RAII release: closes any wrapped FILE* (tag 12) and frees the handle box.
 * Called by `with` cleanup. Safe on null; does not recurse into slot payloads
 * (handles are identity-bearing, single-owner values). */
void resid_handle_release(void* b) {
    if (!b) return;
    ResidVal* v = (ResidVal*)b;
    if (v->tag == FILE_HANDLE_TAG && v->count >= 1) {
        FILE* f = (FILE*)RV_SLOTS(v)[0];
        if (f) fclose(f);
    }
    free(v);
}

char* resid_env_get(const char* name) {
    const char* v = getenv(name);
    return v ? resid_box_str(v) : resid_box_str("");
}

int8_t resid_env_has(const char* name) {
    return getenv(name) != NULL ? 1 : 0;
}

/* Command-line arguments (`args` provider, spec §32). glibc passes
 * (argc, argv, envp) to ELF .init_array constructors, so a constructor
 * captures them without any change to the generated entry point. */
static int g_resid_argc = 0;
static char** g_resid_argv = 0;

__attribute__((constructor)) static void resid_capture_args(int argc, char** argv) {
    g_resid_argc = argc;
    g_resid_argv = argv;
}

/* Runs `cmd` via fork+execvp on a whitespace-split argv — never through a
 * shell. This defuses shell-metacharacter injection (;, &&, $(...), `...`,
 * |, etc. all become inert literal argv bytes instead of being interpreted)
 * without disabling the primitive the self-hosted compiler needs to invoke
 * `clang` for its own link step. Tokens are split on plain ASCII spaces —
 * no quoting support, since every current caller (the driver's clang
 * invocation, resid-manifest) builds its command from single-token paths. */
#define RESID_PROC_MAX_ARGS 64

int64_t resid_process_run(const char* cmd) {
    if (!cmd) return -1;
    size_t len = strlen(cmd);
    char* buf = malloc(len + 1);
    if (!buf) return -1;
    memcpy(buf, cmd, len + 1);

    char* argv[RESID_PROC_MAX_ARGS + 1];
    int argc = 0;
    char* p = buf;
    while (*p != '\0' && argc < RESID_PROC_MAX_ARGS) {
        while (*p == ' ') p++;
        if (*p == '\0') break;
        argv[argc++] = p;
        while (*p != '\0' && *p != ' ') p++;
        if (*p == ' ') { *p = '\0'; p++; }
    }
    argv[argc] = NULL;
    if (argc == 0) { free(buf); return -1; }

    pid_t pid = fork();
    if (pid < 0) { free(buf); return -1; }
    if (pid == 0) {
        execvp(argv[0], argv);
        _exit(127);
    }
    int status = 0;
    if (waitpid(pid, &status, 0) < 0) { free(buf); return -1; }
    free(buf);
    if (WIFEXITED(status)) return WEXITSTATUS(status);
    return -1;
}

int64_t resid_args_count(void) { return g_resid_argc; }

/* Program entry trampoline. The compiler emits the program's `main` as
 * resid_user_main and a C-level main that calls this: the program runs on
 * a thread with a large stack (default 1 GiB of reserved address space,
 * committed only as it is touched; RESID_STACK_MB overrides). Resid loops
 * are written as recursion and the generated code keeps every local in
 * its frame, so the default 8 MiB main-thread stack is a real limit on
 * how deep a program — or the compiler's compile-time evaluator — can go.
 * Falls back to a direct call if the thread cannot be created. */
typedef int32_t (*resid_main_fn)(void);
static void* resid_main_thread(void* arg) {
    resid_main_fn fn = *(resid_main_fn*)arg;
    int32_t rc = fn();
    return (void*)(intptr_t)rc;
}

int32_t resid_run_main(resid_main_fn fn) {
    size_t mb = 1024;
    const char* env = getenv("RESID_STACK_MB");
    if (env && *env) {
        long v = strtol(env, NULL, 10);
        if (v >= 8 && v <= 1048576) mb = (size_t)v;
    }
    pthread_attr_t attr;
    pthread_t t;
    if (pthread_attr_init(&attr) != 0) return fn();
    if (pthread_attr_setstacksize(&attr, mb * 1024 * 1024) != 0 ||
        pthread_create(&t, &attr, resid_main_thread, &fn) != 0) {
        pthread_attr_destroy(&attr);
        return fn();
    }
    pthread_attr_destroy(&attr);
    void* ret = NULL;
    pthread_join(t, &ret);
    return (int32_t)(intptr_t)ret;
}

char* resid_args_get(int64_t i) {
    if (i < 0 || i >= g_resid_argc) return resid_box_str("");
    return resid_box_str(g_resid_argv[i]);
}

char* resid_git_rev(const char* ref) {
    if (!ref || ref[0] == '\0') return resid_box_str("");
    for (const char* p = ref; *p; p++) {
        if (!((*p >= 'a' && *p <= 'z') || (*p >= 'A' && *p <= 'Z') ||
              (*p >= '0' && *p <= '9') || *p == '-' || *p == '_' || *p == '/' || *p == '.')) {
            return resid_box_str("");
        }
    }
    char cmd[4096];
    snprintf(cmd, sizeof(cmd), "git rev-parse %.4000s 2>/dev/null", ref);
    FILE* p = popen(cmd, "r");
    if (!p) return resid_box_str("");
    char line[256];
    if (!fgets(line, sizeof(line), p)) {
        pclose(p);
        return resid_box_str("");
    }
    pclose(p);
    size_t len = strlen(line);
    if (len > 0 && line[len - 1] == '\n') line[len - 1] = '\0';
    return resid_box_str(line);
}

char* resid_git_branch(void) {
    FILE* p = popen("git rev-parse --abbrev-ref HEAD 2>/dev/null", "r");
    if (!p) return resid_box_str("");
    char line[256];
    if (!fgets(line, sizeof(line), p)) {
        pclose(p);
        return resid_box_str("");
    }
    pclose(p);
    size_t len = strlen(line);
    if (len > 0 && line[len - 1] == '\n') line[len - 1] = '\0';
    for (size_t i = 0; i < len; i++) {
        if (!((line[i] >= 'a' && line[i] <= 'z') || (line[i] >= 'A' && line[i] <= 'Z') ||
              (line[i] >= '0' && line[i] <= '9') || line[i] == '-' || line[i] == '_' || line[i] == '/' || line[i] == '.')) {
            line[i] = '_';
        }
    }
    return resid_box_str(line);
}

/*
 * ─────────────────────────────────────────────────────────────
 * Dec(N) exact-decimal runtime (spec §6.6a).
 *
 * A Dec value is an immutable DecV:
 *
 *     value = sign * coef * 10^exp
 *
 * where coef is a non-negative integer held as `n` little-endian limbs in
 * base 10^19 (no zero limb at the top; zero is n == 0, sign == 0) and has
 * `nd` decimal digits, nd <= prec. `prec` is the value's N. The spec's
 * representation (exactly N significant digits and an exponent) is this
 * coefficient padded with N - nd trailing zeros:
 *
 *     digits = coef followed by (N - nd) zeros
 *     E      = exp - (N - nd)          must lie in [-1_000_000, 1_000_000]
 *
 * so the cost of an operation follows the digits a value actually has, not
 * N, and N is not capped. Narrowing to N digits rounds half away from zero
 * (spec §6.6a); addition, subtraction and multiplication round the exact
 * result once; division truncates to N + 2 digits, then rounds once.
 * There is no NaN and no Inf; division by zero, exponent overflow and a
 * non-integral Dec-to-Int conversion are errors (resid_abort).
 *
 * Display is fixed notation with all N significant digits; trailing zeros
 * are preserved: `Dec(4) 1.5` prints as "1.500".
 *
 * Results are allocated with resid_gmalloc (so a resid_bulk_push scope
 * releases them in bulk); every temporary buffer is malloc'd and freed.
 */
#define RESID_DEC_MAX_EXP 1000000
#define DEC_B 10000000000000000000ULL          /* limb base 10^19 */
#define DEC_BINV 15581492618384294730ULL       /* floor((2^128-1)/B) - 2^64 */
#define DEC_LD 19                              /* digits per limb */

typedef unsigned __int128 dec_u128;

typedef struct {
    int8_t sign;     /* -1, 0, +1 */
    int32_t prec;    /* N */
    int32_t exp;
    int32_t n;       /* limbs */
    int32_t nd;      /* digits of coef */
    uint64_t l[];
} DecV;

static const uint64_t dec_p10[20] = {
    1ULL, 10ULL, 100ULL, 1000ULL, 10000ULL, 100000ULL, 1000000ULL, 10000000ULL,
    100000000ULL, 1000000000ULL, 10000000000ULL, 100000000000ULL, 1000000000000ULL,
    10000000000000ULL, 100000000000000ULL, 1000000000000000ULL, 10000000000000000ULL,
    100000000000000000ULL, 1000000000000000000ULL, 10000000000000000000ULL};

/* v / B and v % B for v < B^2 (Moller-Granlund division by the
 * normalized invariant B > 2^63). */
static inline uint64_t dec_divB(dec_u128 v, uint64_t* rem) {
    uint64_t u1 = (uint64_t)(v >> 64), u0 = (uint64_t)v;
    dec_u128 q = (dec_u128)DEC_BINV * u1 + v;
    uint64_t q1 = (uint64_t)(q >> 64) + 1, q0 = (uint64_t)q;
    uint64_t r = u0 - q1 * DEC_B;
    if (r > q0) { q1--; r += DEC_B; }
    if (r >= DEC_B) { q1++; r -= DEC_B; }
    *rem = r;
    return q1;
}

static int32_t dec_ndig64(uint64_t x) {
    int32_t d = 1;
    while (d < 20 && x >= dec_p10[d]) d++;
    return d;
}

static int64_t dec_ndig(const uint64_t* l, int64_t n) {
    if (n == 0) return 0;
    return (int64_t)DEC_LD * (n - 1) + dec_ndig64(l[n - 1]);
}

static void* dec_tmp(int64_t limbs) {
    void* p = malloc((size_t)(limbs > 0 ? limbs : 1) * sizeof(uint64_t));
    if (!p) resid_abort("dec: out of memory");
    return p;
}

static DecV* dec_alloc(int64_t cap) {
    if (cap < 0 || cap > ((int64_t)1 << 40)) resid_abort("dec: value too large");
    DecV* v = (DecV*)resid_gmalloc((int64_t)(sizeof(DecV) + (size_t)cap * sizeof(uint64_t)));
    if (!v) resid_abort("dec: out of memory");
    return v;
}

static DecV* dec_zero_v(int64_t prec) {
    DecV* v = dec_alloc(0);
    v->sign = 0;
    v->prec = (int32_t)prec;
    v->exp = 0;
    v->n = 0;
    v->nd = 0;
    return v;
}

/* Finish r in place: strip top zero limbs, round the coefficient to `prec`
 * digits (half away from zero), check the exponent range. r->l holds `n`
 * limbs; `exp` may be anything representable in i64. */
static DecV* dec_finish(DecV* r, int sign, int64_t n, int64_t exp, int64_t prec) {
    if (prec < 1 || prec > INT32_MAX / 2) resid_abort("dec: precision out of range");
    while (n > 0 && r->l[n - 1] == 0) n--;
    r->prec = (int32_t)prec;
    if (n == 0 || sign == 0) {
        r->sign = 0; r->exp = 0; r->n = 0; r->nd = 0;
        return r;
    }
    int64_t nd = dec_ndig(r->l, n);
    if (nd > prec) {
        int64_t k = nd - prec;              /* digits dropped */
        int64_t rp = k - 1;                 /* rounding digit position */
        int up = (r->l[rp / DEC_LD] / dec_p10[rp % DEC_LD]) % 10 >= 5;
        int64_t q = k / DEC_LD;
        int32_t s = (int32_t)(k % DEC_LD);
        int64_t on = n - q;                 /* limbs after the shift */
        if (s == 0) {
            for (int64_t i = 0; i < on; i++) r->l[i] = r->l[i + q];
        } else {
            uint64_t dv = dec_p10[s], mu = dec_p10[DEC_LD - s];
            for (int64_t i = 0; i < on; i++) {
                uint64_t lo = r->l[i + q] / dv;
                uint64_t hi = (i + q + 1 < n) ? (r->l[i + q + 1] % dv) * mu : 0;
                r->l[i] = lo + hi;
            }
        }
        n = on;
        while (n > 0 && r->l[n - 1] == 0) n--;
        exp += k;
        if (up) {
            int64_t i = 0;
            for (; i < n; i++) {
                if (r->l[i] + 1 < DEC_B) { r->l[i]++; break; }
                r->l[i] = 0;
            }
            if (i == n) r->l[n++] = 1;      /* capacity: on >= n before */
        }
        nd = dec_ndig(r->l, n);
        if (nd > prec) {
            /* 99..9 rounded up to 10^prec: one digit, prec zeros. */
            n = 1;
            r->l[0] = 1;
            nd = 1;
            exp += prec;
        }
    }
    int64_t E = exp - (prec - nd);
    if (E > RESID_DEC_MAX_EXP || E < -RESID_DEC_MAX_EXP) resid_abort("dec: exponent out of range");
    r->sign = (int8_t)(sign < 0 ? -1 : 1);
    r->exp = (int32_t)exp;
    r->n = (int32_t)n;
    r->nd = (int32_t)nd;
    return r;
}

/* A fresh value from limbs l[0..n) (copied), rounded to prec. */
static DecV* dec_from_limbs(int sign, const uint64_t* l, int64_t n, int64_t exp, int64_t prec) {
    while (n > 0 && l[n - 1] == 0) n--;
    if (n == 0 || sign == 0) return dec_zero_v(prec);
    DecV* r = dec_alloc(n + 1);
    memcpy(r->l, l, (size_t)n * sizeof(uint64_t));
    return dec_finish(r, sign, n, exp, prec);
}

/* r[0..n+1) = a[0..n) * m (m < B); returns the limb count. */
__attribute__((noinline)) static int64_t dec_mul1(uint64_t* r, const uint64_t* a, int64_t n, uint64_t m) {
    /* Each product splits into (hi, lo) independently of the others; the
     * carry out of r[i] = lo + hi_prev is folded into hi, so nothing but
     * a rarely taken branch runs along the limbs. hi + 1 < B always. */
    uint64_t hprev = 0;
    if (m < ((uint64_t)1 << 32)) {
        /* Small multiplier: hi = floor(a*m / B) < 2^32 is estimated in
         * double precision, biased low by 2^-15 (more than the estimate's
         * error, < 2^-17), so it is exact or one short, and one short only
         * when the remainder is below 2^-14 * B. The wrap-around u64
         * remainder lo + hprev is then below 2B and exact, and one
         * rarely taken correction finishes the limb. */
        const double mb = (double)m * 2e-19;
        /* Scalar is fastest here; -O3's vectorized form of this loop is
         * slower (measured on pidigits). */
#if defined(__clang__)
#pragma clang loop vectorize(disable) interleave(disable)
#endif
        for (int64_t i = 0; i < n; i++) {
            uint64_t ai = a[i];
            uint64_t hi = (uint64_t)(int64_t)((double)(int64_t)(ai >> 1) * mb - 0.000030517578125);
            uint64_t s = ai * m - hi * DEC_B + hprev;
            if (__builtin_expect(s >= DEC_B, 0)) { s -= DEC_B; hi++; }
            r[i] = s;
            hprev = hi;
        }
    } else {
        for (int64_t i = 0; i < n; i++) {
            uint64_t lo;
            uint64_t hi = dec_divB((dec_u128)a[i] * m, &lo);
            uint64_t t = DEC_B - hprev;
            if (lo >= t) { r[i] = lo - t; hi++; } else { r[i] = lo + hprev; }
            hprev = hi;
        }
    }
    r[n] = hprev;
    return n + 1;
}

/* a * 10^k as fresh malloc'd limbs; *on receives the count. */
static uint64_t* dec_scale(const uint64_t* a, int64_t n, int64_t k, int64_t* on) {
    int64_t q = k / DEC_LD;
    int32_t s = (int32_t)(k % DEC_LD);
    uint64_t* r = (uint64_t*)dec_tmp(n + q + 1);
    memset(r, 0, (size_t)q * sizeof(uint64_t));
    if (s == 0) {
        memcpy(r + q, a, (size_t)n * sizeof(uint64_t));
        r[q + n] = 0;
    } else {
        dec_mul1(r + q, a, n, dec_p10[s]);
    }
    *on = n + q + 1;
    while (*on > 0 && r[*on - 1] == 0) (*on)--;
    return r;
}

static int dec_cmp_n(const uint64_t* a, int64_t na, const uint64_t* b, int64_t nb) {
    while (na > 0 && a[na - 1] == 0) na--;
    while (nb > 0 && b[nb - 1] == 0) nb--;
    if (na != nb) return na > nb ? 1 : -1;
    for (int64_t i = na - 1; i >= 0; i--)
        if (a[i] != b[i]) return a[i] > b[i] ? 1 : -1;
    return 0;
}

/* |a| * 10^ea vs |b| * 10^eb (both coefficients nonzero, nd given). */
static int dec_cmp_mag(const uint64_t* a, int64_t na, int64_t nda, int64_t ea,
                       const uint64_t* b, int64_t nb, int64_t ndb, int64_t eb) {
    int64_t ma = ea + nda, mb = eb + ndb;
    if (ma != mb) return ma > mb ? 1 : -1;
    if (ea == eb) return dec_cmp_n(a, na, b, nb);
    int64_t sn;
    int c;
    if (ea > eb) {
        uint64_t* s = dec_scale(a, na, ea - eb, &sn);
        c = dec_cmp_n(s, sn, b, nb);
        free(s);
    } else {
        uint64_t* s = dec_scale(b, nb, eb - ea, &sn);
        c = dec_cmp_n(a, na, s, sn);
        free(s);
    }
    return c;
}

/* r = a + b (na >= nb); r has room for na + 1 limbs. */
static int64_t dec_add_n(uint64_t* r, const uint64_t* a, int64_t na, const uint64_t* b, int64_t nb) {
    uint64_t c = 0;
    int64_t i = 0;
    for (; i < nb; i++) {
        /* a[i] + b[i] can exceed 2^64 (2B > 2^64): compare against B - b[i]. */
        uint64_t x = a[i] + c, t = DEC_B - b[i];
        c = x >= t;
        r[i] = c ? x - t : x + b[i];
    }
    for (; i < na && c; i++) {
        uint64_t s = a[i] + 1;
        c = s == DEC_B;
        r[i] = c ? 0 : s;
    }
    if (r != a) for (; i < na; i++) r[i] = a[i];
    r[na] = c;
    return na + 1;
}

/* r = a - b, requires a >= b (as integers); r has room for na limbs. */
static int64_t dec_sub_n(uint64_t* r, const uint64_t* a, int64_t na, const uint64_t* b, int64_t nb) {
    uint64_t br = 0;
    int64_t i = 0;
    for (; i < nb; i++) {
        uint64_t x = a[i], y = b[i] + br;
        br = x < y;
        r[i] = br ? x + (DEC_B - y) : x - y;
    }
    for (; i < na && br; i++) {
        uint64_t x = a[i];
        br = x == 0;
        r[i] = br ? DEC_B - 1 : x - 1;
    }
    if (r != a) for (; i < na; i++) r[i] = a[i];
    return na;
}

static DecV* dec_round_v(const DecV* v, int64_t prec, int negate) {
    int s = negate ? -v->sign : v->sign;
    if (v->sign == 0) return dec_zero_v(prec);
    if (v->nd <= prec) {
        /* Exact: keep the coefficient, only the precision changes. */
        DecV* r = dec_alloc(v->n);
        memcpy(r->l, v->l, (size_t)v->n * sizeof(uint64_t));
        return dec_finish(r, s, v->n, v->exp, prec);
    }
    /* Only the limbs from the one holding the rounding digit upward can
     * affect the result (half away from zero looks at that digit alone),
     * so narrowing a wide value costs O(prec), not O(nd). */
    int64_t q0 = (v->nd - prec - 1) / DEC_LD;
    return dec_from_limbs(s, v->l + q0, v->n - q0, (int64_t)v->exp + (int64_t)DEC_LD * q0, prec);
}

/* a + (negb ? -b : b), rounded once to prec. */
static DecV* dec_addsub(const DecV* a, const DecV* b, int negb, int64_t prec) {
    int sb = negb ? -b->sign : b->sign;
    if (a->sign == 0) return dec_round_v(b, prec, negb);
    if (b->sign == 0) return dec_round_v(a, prec, 0);
    int64_t ea = a->exp, eb = b->exp;
    int64_t mxa = ea + a->nd - 1, mxb = eb + b->nd - 1;
    /* An operand whose digits all lie two or more places below the guard
     * digit of the other cannot change the rounded result (the other has
     * at most prec digits, so its guard digit is 0 and the sum stays
     * strictly inside the rounding interval). */
    if (mxb <= mxa - prec - 2) return dec_round_v(a, prec, 0);
    if (mxa <= mxb - prec - 2) return dec_round_v(b, prec, negb);
    const uint64_t* A = a->l;
    const uint64_t* B = b->l;
    int64_t na = a->n, nb = b->n;
    uint64_t* tA = NULL;
    uint64_t* tB = NULL;
    int64_t e = ea < eb ? ea : eb;
    if (ea > e) { tA = dec_scale(A, na, ea - e, &na); A = tA; }
    if (eb > e) { tB = dec_scale(B, nb, eb - e, &nb); B = tB; }
    DecV* r;
    int sign;
    int64_t rn;
    if (a->sign == sb) {
        sign = a->sign;
        int64_t cap = (na > nb ? na : nb) + 1;
        r = dec_alloc(cap);
        rn = na >= nb ? dec_add_n(r->l, A, na, B, nb) : dec_add_n(r->l, B, nb, A, na);
    } else {
        int c = dec_cmp_n(A, na, B, nb);
        if (c == 0) {
            free(tA); free(tB);
            return dec_zero_v(prec);
        }
        int64_t cap = (na > nb ? na : nb) + 1;
        r = dec_alloc(cap);
        if (c > 0) { sign = a->sign; rn = dec_sub_n(r->l, A, na, B, nb); }
        else { sign = sb; rn = dec_sub_n(r->l, B, nb, A, na); }
    }
    free(tA); free(tB);
    return dec_finish(r, sign, rn, e, prec);
}

static DecV* dec_mul_v(const DecV* a, const DecV* b, int64_t prec) {
    if (a->sign == 0 || b->sign == 0) return dec_zero_v(prec);
    int sign = a->sign == b->sign ? 1 : -1;
    int64_t exp = (int64_t)a->exp + b->exp;
    int64_t na = a->n, nb = b->n;
    DecV* r = dec_alloc(na + nb + 1);
    int64_t rn;
    if (nb == 1) {
        rn = dec_mul1(r->l, a->l, na, b->l[0]);
    } else if (na == 1) {
        rn = dec_mul1(r->l, b->l, nb, a->l[0]);
    } else {
        const uint64_t* x = a->l;
        const uint64_t* y = b->l;
        memset(r->l, 0, (size_t)(na + nb) * sizeof(uint64_t));
        for (int64_t i = 0; i < na; i++) {
            uint64_t xi = x[i];
            if (xi == 0) continue;
            uint64_t* ri = r->l + i;
            /* ri += xi * y, carries split as in dec_mul1 */
            uint64_t hprev = 0, cb = 0;
            for (int64_t j = 0; j < nb; j++) {
                uint64_t lo;
                uint64_t hi = dec_divB((dec_u128)xi * y[j] + ri[j], &lo);
                uint64_t xx = lo + cb, t = DEC_B - hprev;
                cb = xx >= t;
                ri[j] = cb ? xx - t : xx + hprev;
                hprev = hi;
            }
            ri[nb] = hprev + cb;
        }
        rn = na + nb;
    }
    return dec_finish(r, sign, rn, exp, prec);
}

/* q = floor(u / v) for multi-limb v (Knuth, TAOCP 4.3.1 Algorithm D, in
 * base 10^19). u has m + n limbs, v has n >= 2 limbs with v[n-1] != 0.
 * q receives m + 1 limbs. u and v are consumed (normalized in place);
 * u needs room for m + n + 1 limbs. */
static void dec_divmod_n(uint64_t* u, int64_t un, uint64_t* v, int64_t n, uint64_t* q) {
    int64_t m = un - n;
    uint64_t f = DEC_B / (v[n - 1] + 1);
    if (f > 1) {
        dec_mul1(u, u, un, f);             /* in place: reads a[i] before writing r[i] */
        uint64_t* tv = (uint64_t*)dec_tmp(n + 1);
        dec_mul1(tv, v, n, f);
        memcpy(v, tv, (size_t)n * sizeof(uint64_t));
        free(tv);
    } else {
        u[un] = 0;
    }
    uint64_t vt = v[n - 1], vs = v[n - 2];
    for (int64_t j = m; j >= 0; j--) {
        dec_u128 num = (dec_u128)u[j + n] * DEC_B + u[j + n - 1];
        dec_u128 qh = num / vt;
        dec_u128 rh = num - qh * vt;
        while (qh >= DEC_B || qh * vs > rh * DEC_B + u[j + n - 2]) {
            qh--;
            rh += vt;
            if (rh >= DEC_B) break;
        }
        uint64_t qd = (uint64_t)qh;
        /* u[j..j+n] -= qd * v */
        uint64_t c = 0, br = 0;
        for (int64_t i = 0; i < n; i++) {
            uint64_t lo;
            c = dec_divB((dec_u128)qd * v[i] + c, &lo);
            uint64_t x = u[i + j], y = lo + br;
            if (x >= y) { u[i + j] = x - y; br = 0; } else { u[i + j] = x + (DEC_B - y); br = 1; }
        }
        uint64_t x = u[j + n], y = c + br;
        if (x >= y) {
            u[j + n] = x - y;
        } else {
            /* Went negative: add v back once. */
            u[j + n] = x + (DEC_B - y);
            qd--;
            uint64_t cc = 0;
            for (int64_t i = 0; i < n; i++) {
                uint64_t x2 = u[i + j] + cc, t = DEC_B - v[i];
                if (x2 >= t) { u[i + j] = x2 - t; cc = 1; } else { u[i + j] = x2 + v[i]; cc = 0; }
            }
            u[j + n] = (u[j + n] + cc) % DEC_B;
        }
        q[j] = qd;
    }
}

/* value(a) / value(b): the quotient truncated to prec + 2 significant
 * digits, then rounded once to prec (spec §6.6a). */
static DecV* dec_div_v(const DecV* a, const DecV* b, int64_t prec) {
    if (b->sign == 0) resid_abort("dec: division by zero");
    if (a->sign == 0) return dec_zero_v(prec);
    int64_t K = prec + 2;
    int64_t da = a->nd, db = b->nd;
    /* P = floor(log10(coef_a / coef_b)). */
    int c = dec_cmp_mag(a->l, a->n, da, 0, b->l, b->n, db, da - db);
    int64_t P = da - db - (c < 0 ? 1 : 0);
    int64_t s = K - 1 - P;                  /* floor(coef_a * 10^s / coef_b) has K digits */
    uint64_t *U, *V;
    int64_t un, vn;
    if (s >= 0) {
        U = dec_scale(a->l, a->n, s, &un);
        V = (uint64_t*)dec_tmp(b->n);
        memcpy(V, b->l, (size_t)b->n * sizeof(uint64_t));
        vn = b->n;
    } else {
        U = (uint64_t*)dec_tmp(a->n + 1);
        memcpy(U, a->l, (size_t)a->n * sizeof(uint64_t));
        un = a->n;
        V = dec_scale(b->l, b->n, -s, &vn);
    }
    int64_t qn = un - vn + 1;
    if (qn < 1) qn = 1;
    DecV* r = dec_alloc(qn + 1);
    memset(r->l, 0, (size_t)(qn + 1) * sizeof(uint64_t));
    if (un < vn) {
        /* quotient 0 cannot happen (K >= 3 digits) */
        resid_abort("dec: internal");
    } else if (vn == 1) {
        uint64_t d = V[0];
        dec_u128 rem = 0;
        for (int64_t i = un - 1; i >= 0; i--) {
            dec_u128 t = rem * DEC_B + U[i];
            r->l[i] = (uint64_t)(t / d);
            rem = t % d;
        }
    } else {
        uint64_t* U2 = (uint64_t*)dec_tmp(un + 1);
        memcpy(U2, U, (size_t)un * sizeof(uint64_t));
        U2[un] = 0;
        dec_divmod_n(U2, un, V, vn, r->l);
        free(U2);
    }
    free(U); free(V);
    int sign = a->sign == b->sign ? 1 : -1;
    int64_t exp = (int64_t)a->exp - b->exp - s;
    /* Exactly K digits by construction; finish rounds K -> prec. */
    return dec_finish(r, sign, qn + 1, exp, prec);
}

/* Decimal digits of the coefficient, most significant first (malloc'd,
 * NUL-terminated, nd chars). */
static char* dec_coef_digits(const DecV* v) {
    char* s = (char*)malloc((size_t)v->nd + 1);
    if (!s) resid_abort("dec: out of memory");
    int64_t k = v->nd;
    s[k] = '\0';
    for (int64_t i = 0; i < v->n; i++) {
        uint64_t x = v->l[i];
        int32_t w = (i == v->n - 1) ? dec_ndig64(x) : DEC_LD;
        for (int32_t j = 0; j < w; j++) { s[--k] = (char)('0' + x % 10); x /= 10; }
    }
    return s;
}

/* Parse digits (a run of '0'..'9', `len` chars, leading zeros allowed)
 * into fresh limbs. */
static uint64_t* dec_parse_digits(const char* d, int64_t len, int64_t* on) {
    int64_t n = (len + DEC_LD - 1) / DEC_LD;
    uint64_t* l = (uint64_t*)dec_tmp(n + 1);
    int64_t end = len;
    for (int64_t i = 0; i < n; i++) {
        int64_t st = end - DEC_LD;
        if (st < 0) st = 0;
        uint64_t x = 0;
        for (int64_t j = st; j < end; j++) x = x * 10 + (uint64_t)(d[j] - '0');
        l[i] = x;
        end = st;
    }
    while (n > 0 && l[n - 1] == 0) n--;
    *on = n;
    return l;
}

/* Exact decimal parse of a plain or `e`-notation string (the latter from
 * binary-float %.17g casts), rounded to prec. */
static DecV* dec_from_str_v(const char* s, int64_t prec) {
    const char* p = s;
    int sign = 1;
    if (*p == '-') { sign = -1; p++; }
    else if (*p == '+') p++;
    size_t cap = strlen(p) + 1;
    char* digs = (char*)malloc(cap);
    if (!digs) resid_abort("dec: out of memory");
    int64_t dn = 0;
    while (*p >= '0' && *p <= '9') digs[dn++] = *p++;
    int64_t exp = 0;
    if (*p == '.') {
        p++;
        int64_t frac = 0;
        while (*p >= '0' && *p <= '9') { digs[dn++] = *p++; frac++; }
        exp = -frac;
    }
    if (*p == 'e' || *p == 'E') {
        p++;
        int64_t esign = 1;
        if (*p == '-') { esign = -1; p++; }
        else if (*p == '+') p++;
        int64_t ev = 0;
        while (*p >= '0' && *p <= '9') {
            if (ev > RESID_DEC_MAX_EXP / 10) resid_abort("dec: exponent out of range");
            ev = ev * 10 + (*p - '0');
            p++;
        }
        exp += esign * ev;
    }
    if (dn == 0 || *p != '\0') resid_abort("dec: bad decimal string");
    int64_t n;
    uint64_t* l = dec_parse_digits(digs, dn, &n);
    free(digs);
    DecV* r = dec_from_limbs(sign, l, n, exp, prec);
    free(l);
    return r;
}

static DecV* dec_from_i64_v(int64_t v, int64_t prec) {
    if (v == 0) return dec_zero_v(prec);
    uint64_t u = v < 0 ? (uint64_t)(-(v + 1)) + 1 : (uint64_t)v; /* < B */
    return dec_from_limbs(v < 0 ? -1 : 1, &u, 1, 0, prec);
}

static DecV* dec_from_i128_v(__int128 v, int64_t prec) {
    if (v == 0) return dec_zero_v(prec);
    dec_u128 u = v < 0 ? (dec_u128)(-(v + 1)) + 1 : (dec_u128)v;
    uint64_t l[3];
    l[0] = (uint64_t)(u % DEC_B); u /= DEC_B;
    l[1] = (uint64_t)(u % DEC_B); u /= DEC_B;
    l[2] = (uint64_t)u;
    return dec_from_limbs(v < 0 ? -1 : 1, l, 3, 0, prec);
}

static int dec_cmp_v(const DecV* a, const DecV* b) {
    if (a->sign != b->sign) return a->sign > b->sign ? 1 : -1;
    if (a->sign == 0) return 0;
    int c = dec_cmp_mag(a->l, a->n, a->nd, a->exp, b->l, b->n, b->nd, b->exp);
    return a->sign < 0 ? -c : c;
}

/* Fixed notation with all N significant digits (trim == 0), or with the
 * trailing fractional zeros and a bare '.' dropped (trim != 0, the
 * f-string `:.` spec). Returns a malloc'd string. */
static char* dec_format(const DecV* v, int trim) {
    int64_t N = v->prec;
    if (v->sign == 0) {
        if (trim) { char* z = (char*)malloc(2); z[0] = '0'; z[1] = 0; return z; }
        char* z = (char*)malloc((size_t)N + 3);
        if (!z) resid_abort("dec: out of memory");
        z[0] = '0'; z[1] = '.';
        memset(z + 2, '0', (size_t)N);
        z[N + 2] = 0;
        return z;
    }
    char* cd = dec_coef_digits(v);
    int64_t nd = v->nd;
    int64_t ipos = nd + v->exp;             /* integer digit count (N + E) */
    /* last: digits 0..last-1 of the N-digit string are printed */
    int64_t last = N;
    if (trim && ipos < N) {
        int64_t m = nd;
        while (m > 0 && cd[m - 1] == '0') m--;
        last = m > ipos ? m : (ipos > 0 ? ipos : m);
    }
    int64_t len = 1 + (ipos > 0 ? ipos : 1) + 1 + (ipos > 0 ? 0 : -ipos) + (last > 0 ? last : 0) + 1;
    char* t = (char*)malloc((size_t)len + 1);
    if (!t) resid_abort("dec: out of memory");
    int64_t k = 0;
    if (v->sign < 0) t[k++] = '-';
#define DEC_DIGIT(i) ((i) < nd ? cd[(i)] : '0')
    if (ipos > 0) {
        for (int64_t i = 0; i < ipos; i++) t[k++] = DEC_DIGIT(i);
        if (ipos < last) {
            t[k++] = '.';
            for (int64_t i = ipos; i < last; i++) t[k++] = DEC_DIGIT(i);
        }
    } else {
        t[k++] = '0';
        t[k++] = '.';
        for (int64_t i = 0; i < -ipos; i++) t[k++] = '0';
        for (int64_t i = 0; i < last; i++) t[k++] = DEC_DIGIT(i);
    }
#undef DEC_DIGIT
    t[k] = '\0';
    free(cd);
    return t;
}

/* Integral value in [lo, hi], else an error. */
static int64_t dec_to_int_v(const DecV* v, int64_t lo, int64_t hi) {
    if (v->sign == 0) return 0;
    const uint64_t* l = v->l;
    int64_t sh = 0;                         /* digits to drop */
    if (v->exp < 0) {
        int64_t f = -(int64_t)v->exp;
        if (f >= v->nd) resid_abort("dec: non-integer to Int");
        for (int64_t i = 0; i < f / DEC_LD; i++)
            if (l[i] != 0) resid_abort("dec: non-integer to Int");
        if (l[f / DEC_LD] % dec_p10[f % DEC_LD] != 0) resid_abort("dec: non-integer to Int");
        sh = f;
    }
    int64_t idig = v->nd + v->exp;          /* integer digits */
    if (idig > 20) resid_abort("dec: value out of range for Int");
    dec_u128 r = 0;
    char* cd = dec_coef_digits(v);
    int64_t keep = v->nd - sh;
    for (int64_t i = 0; i < keep; i++) r = r * 10 + (dec_u128)(cd[i] - '0');
    free(cd);
    for (int64_t i = 0; i < v->exp; i++) r *= 10;
    dec_u128 lim = v->sign < 0 ? (dec_u128)INT64_MAX + 1 : (dec_u128)INT64_MAX;
    if (r > lim) resid_abort("dec: value out of range for Int");
    int64_t out = v->sign < 0 ? (int64_t)(0 - (uint64_t)r) : (int64_t)r;
    if (out < lo || out > hi) resid_abort("dec: value out of range for Int");
    return out;
}

/* Nearest double (strtod of the leading 40 digits; exact for any value
 * with at most 40 significant digits). */
static double dec_to_f64_v(const DecV* v) {
    if (v->sign == 0) return 0.0;
    char* cd = dec_coef_digits(v);
    int64_t nd = v->nd;
    int64_t keep = nd < 40 ? nd : 40;
    int64_t e = (int64_t)v->exp + (nd - keep);
    char buf[80];
    int k = 0;
    if (v->sign < 0) buf[k++] = '-';
    memcpy(buf + k, cd, (size_t)keep);
    k += (int)keep;
    snprintf(buf + k, sizeof(buf) - (size_t)k, "e%lld", (long long)e);
    free(cd);
    return strtod(buf, NULL);
}

/* ── Legacy fixed-size ABI (the archived Rust pipeline) ─────────────
 * value = sign * int(digits[0..nd)) * 10^exp, digits as ASCII. Kept as
 * adapters over DecV, so it is limited to 512 digits. */
#define RESID_DEC_LEGACY_DIGITS 512
typedef struct {
    int8_t sign;
    uint16_t nd;
    uint8_t digits[RESID_DEC_LEGACY_DIGITS];
    int32_t exp;
} resid_dec;

static DecV* dec_from_legacy(const resid_dec* d) {
    if (d->sign == 0) return dec_zero_v(d->nd ? d->nd : 1);
    int64_t n;
    uint64_t* l = dec_parse_digits((const char*)d->digits, d->nd, &n);
    DecV* r = dec_from_limbs(d->sign, l, n, d->exp, d->nd);
    free(l);
    return r;
}

static void dec_to_legacy(const DecV* v, resid_dec* out) {
    if (v->prec > RESID_DEC_LEGACY_DIGITS) resid_abort("dec: precision too large");
    int32_t N = v->prec;
    out->nd = (uint16_t)N;
    if (v->sign == 0) {
        out->sign = 0; out->exp = 0;
        memset(out->digits, '0', (size_t)N);
        return;
    }
    char* cd = dec_coef_digits(v);
    out->sign = v->sign;
    for (int32_t i = 0; i < N; i++) out->digits[i] = (uint8_t)(i < v->nd ? cd[i] : '0');
    out->exp = v->exp - (N - v->nd);
    free(cd);
}

void resid_dec_div(resid_dec* out, const resid_dec* a, const resid_dec* b) {
    int32_t prec = a->nd > b->nd ? a->nd : b->nd;
    dec_to_legacy(dec_div_v(dec_from_legacy(a), dec_from_legacy(b), prec), out);
}

void resid_dec_from_digits(resid_dec* out, const char* digits, int32_t exp, uint16_t prec) {
    int64_t n;
    uint64_t* l = dec_parse_digits(digits, (int64_t)strlen(digits), &n);
    dec_to_legacy(dec_from_limbs(1, l, n, exp, prec), out);
    free(l);
}

void resid_dec_from_int(resid_dec* out, int64_t v, uint16_t prec) {
    dec_to_legacy(dec_from_i64_v(v, prec), out);
}

void resid_dec_from_i128(resid_dec* out, __int128 v, uint16_t prec) {
    dec_to_legacy(dec_from_i128_v(v, prec), out);
}

void resid_dec_from_str(resid_dec* out, const char* s, uint16_t prec) {
    dec_to_legacy(dec_from_str_v(s, prec), out);
}

char* resid_dec_to_string(const resid_dec* v) {
    char* t = dec_format(dec_from_legacy(v), 0);
    char* boxed = resid_box_str(t);
    free(t);
    return boxed;
}

void resid_dec_round(resid_dec* out, const resid_dec* v, uint16_t prec) {
    dec_to_legacy(dec_round_v(dec_from_legacy(v), prec, 0), out);
}

void resid_dec_neg(resid_dec* out, const resid_dec* v) {
    *out = *v;
    out->sign = (int8_t)-v->sign;
}

void resid_dec_add(resid_dec* out, const resid_dec* a, const resid_dec* b) {
    int32_t prec = a->nd > b->nd ? a->nd : b->nd;
    dec_to_legacy(dec_addsub(dec_from_legacy(a), dec_from_legacy(b), 0, prec), out);
}

void resid_dec_sub(resid_dec* out, const resid_dec* a, const resid_dec* b) {
    int32_t prec = a->nd > b->nd ? a->nd : b->nd;
    dec_to_legacy(dec_addsub(dec_from_legacy(a), dec_from_legacy(b), 1, prec), out);
}

void resid_dec_mul(resid_dec* out, const resid_dec* a, const resid_dec* b) {
    int32_t prec = a->nd > b->nd ? a->nd : b->nd;
    dec_to_legacy(dec_mul_v(dec_from_legacy(a), dec_from_legacy(b), prec), out);
}

int32_t resid_dec_cmp(const resid_dec* a, const resid_dec* b) {
    return (int32_t)dec_cmp_v(dec_from_legacy(a), dec_from_legacy(b));
}

int64_t resid_dec_to_int(const resid_dec* v, int64_t lo, int64_t hi) {
    return dec_to_int_v(dec_from_legacy(v), lo, hi);
}

double resid_dec_to_f64(const resid_dec* v) {
    return dec_to_f64_v(dec_from_legacy(v));
}

/* Binary float -> Dec via %.17g (exact decimal of the double). */
void resid_dec_from_f64(resid_dec* out, double v, uint16_t prec) {
    if (v == 0.0) { dec_to_legacy(dec_zero_v(prec), out); return; }
    if (!(v > -1e308 && v < 1e308)) resid_abort("dec: value out of range");
    char buf[40];
    snprintf(buf, sizeof(buf), "%.17g", v);
    resid_dec_from_str(out, buf, prec);
}

/* ── Dec(N) for the self-hosted code generator ─────────────────────────
 * Values are immutable DecV pointers. `prec` is the static N of the result
 * type; for the binary operators it is max(N, M) of the operands (spec
 * §6.6a), and the result is rounded to it once. */
static int64_t decp_opprec(const DecV* a, const DecV* b, int64_t prec) {
    (void)prec;
    return a->prec > b->prec ? a->prec : b->prec;
}

static void* decp_fit(DecV* r, int64_t prec) {
    if (r->prec == prec) return r;
    return dec_round_v(r, prec, 0);
}

void* resid_decp_from_str(const char* s, int64_t prec) {
    return dec_from_str_v(s, prec);
}

void* resid_decp_from_i64(int64_t v, int64_t prec) {
    return dec_from_i64_v(v, prec);
}

void* resid_decp_round(void* v, int64_t prec) {
    return dec_round_v((DecV*)v, prec, 0);
}

void* resid_decp_add(void* a, void* b, int64_t prec) {
    DecV *x = (DecV*)a, *y = (DecV*)b;
    return decp_fit(dec_addsub(x, y, 0, decp_opprec(x, y, prec)), prec);
}

void* resid_decp_sub(void* a, void* b, int64_t prec) {
    DecV *x = (DecV*)a, *y = (DecV*)b;
    return decp_fit(dec_addsub(x, y, 1, decp_opprec(x, y, prec)), prec);
}

void* resid_decp_mul(void* a, void* b, int64_t prec) {
    DecV *x = (DecV*)a, *y = (DecV*)b;
    return decp_fit(dec_mul_v(x, y, decp_opprec(x, y, prec)), prec);
}

void* resid_decp_div(void* a, void* b, int64_t prec) {
    DecV *x = (DecV*)a, *y = (DecV*)b;
    return decp_fit(dec_div_v(x, y, decp_opprec(x, y, prec)), prec);
}

void* resid_decp_neg(void* a) {
    DecV* v = (DecV*)a;
    DecV* r = dec_alloc(v->n);
    memcpy(r, v, sizeof(DecV) + (size_t)v->n * sizeof(uint64_t));
    r->sign = (int8_t)-v->sign;
    return r;
}

/* resid_dec_persist(x): x, copied out of the innermost resid_bulk_push
 * scope into the enclosing one (or onto the heap when there is none), so
 * it survives that scope's resid_bulk_pop. Outside any bulk scope values
 * already live on the heap and are returned as they are (values are
 * immutable and have no identity). */
void* resid_decp_persist(void* a) {
    DecV* v = (DecV*)a;
    if (!g_bulk_arena) return v;
    size_t sz = sizeof(DecV) + (size_t)v->n * sizeof(uint64_t);
    g_alloc_bytes += sz;
    DecV* r;
    if (g_bulk_arena->prev) {
        r = (DecV*)arena_bump_alloc(g_bulk_arena->prev, sz);
    } else {
        r = (DecV*)malloc(sz);
        if (!r) resid_abort("dec: out of memory");
    }
    memcpy(r, v, sz);
    return r;
}

int64_t resid_decp_cmp(void* a, void* b) {
    return (int64_t)dec_cmp_v((DecV*)a, (DecV*)b);
}

/* trim != 0: drop trailing fractional zeros (the f-string `:.` spec). */
char* resid_decp_to_str(void* v, int8_t trim) {
    char* t = dec_format((DecV*)v, trim);
    char* boxed = resid_box_str(t);
    free(t);
    return boxed;
}

int64_t resid_decp_to_i64(void* v) {
    return dec_to_int_v((DecV*)v, INT64_MIN, INT64_MAX);
}

double resid_decp_to_f64(void* v) {
    return dec_to_f64_v((DecV*)v);
}

/* ════════════════════════════════════════════════════════════════
   Stdlib v1: string verbs (spec §14 semantics, codepoint-based).
   Lists use the ResidVal box layout (see stdlib v1.3 below).
   ════════════════════════════════════════════════════════════════ */

static int str_is_space(unsigned char c) {
    return c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\v' || c == '\f';
}

/* Trim leading/trailing ASCII whitespace. */
char* str_trim(const char* s) {
    const char* b = s;
    const char* e = s + strlen(s);
    while (b < e && str_is_space((unsigned char)*b)) b++;
    while (e > b && str_is_space((unsigned char)e[-1])) e--;
    int64_t n = e - b;
    char* p = (char*)malloc(n + 1);
    if (!p) resid_abort("str_trim: out of memory");
    memcpy(p, b, n);
    p[n] = '\0';
    return p;
}

/* Does `s` contain `needle`? Empty needle is always true. */
int8_t str_contains(const char* s, const char* needle) {
    return strstr(s, needle) != NULL;
}

int8_t str_starts_with(const char* s, const char* pre) {
    size_t lp = strlen(pre);
    return strncmp(s, pre, lp) == 0;
}

int8_t str_ends_with(const char* s, const char* suf) {
    size_t ls = strlen(s), lf = strlen(suf);
    if (lf > ls) return 0;
    return strcmp(s + ls - lf, suf) == 0;
}

/* ─── Unicode simple case mapping ───
   Covers ASCII, Latin-1 Supplement, Latin Extended-A, Greek, and Cyrillic —
   the algorithmic ranges of Unicode's simple case mapping. Scripts with
   irregular pairs (Latin Extended-B, deset letters, full SpecialCasing) are
   mapped through an explicit pair table below; anything else passes through.
   UTF-8 aware: operates per codepoint. */

// BEGIN CASE TABLES — generated by tools/gen_case_tables.py; do not edit
/* lower: 1459 pairs, upper: 1450 pairs, special-upper: 83 expansions. */
static const uint32_t CASE_TO_LOWER[] = {
    0x0041,0x0061, 0x0042,0x0062, 0x0043,0x0063, 0x0044,0x0064,
    0x0045,0x0065, 0x0046,0x0066, 0x0047,0x0067, 0x0048,0x0068,
    0x0049,0x0069, 0x004A,0x006A, 0x004B,0x006B, 0x004C,0x006C,
    0x004D,0x006D, 0x004E,0x006E, 0x004F,0x006F, 0x0050,0x0070,
    0x0051,0x0071, 0x0052,0x0072, 0x0053,0x0073, 0x0054,0x0074,
    0x0055,0x0075, 0x0056,0x0076, 0x0057,0x0077, 0x0058,0x0078,
    0x0059,0x0079, 0x005A,0x007A, 0x00C0,0x00E0, 0x00C1,0x00E1,
    0x00C2,0x00E2, 0x00C3,0x00E3, 0x00C4,0x00E4, 0x00C5,0x00E5,
    0x00C6,0x00E6, 0x00C7,0x00E7, 0x00C8,0x00E8, 0x00C9,0x00E9,
    0x00CA,0x00EA, 0x00CB,0x00EB, 0x00CC,0x00EC, 0x00CD,0x00ED,
    0x00CE,0x00EE, 0x00CF,0x00EF, 0x00D0,0x00F0, 0x00D1,0x00F1,
    0x00D2,0x00F2, 0x00D3,0x00F3, 0x00D4,0x00F4, 0x00D5,0x00F5,
    0x00D6,0x00F6, 0x00D8,0x00F8, 0x00D9,0x00F9, 0x00DA,0x00FA,
    0x00DB,0x00FB, 0x00DC,0x00FC, 0x00DD,0x00FD, 0x00DE,0x00FE,
    0x0100,0x0101, 0x0102,0x0103, 0x0104,0x0105, 0x0106,0x0107,
    0x0108,0x0109, 0x010A,0x010B, 0x010C,0x010D, 0x010E,0x010F,
    0x0110,0x0111, 0x0112,0x0113, 0x0114,0x0115, 0x0116,0x0117,
    0x0118,0x0119, 0x011A,0x011B, 0x011C,0x011D, 0x011E,0x011F,
    0x0120,0x0121, 0x0122,0x0123, 0x0124,0x0125, 0x0126,0x0127,
    0x0128,0x0129, 0x012A,0x012B, 0x012C,0x012D, 0x012E,0x012F,
    0x0132,0x0133, 0x0134,0x0135, 0x0136,0x0137, 0x0139,0x013A,
    0x013B,0x013C, 0x013D,0x013E, 0x013F,0x0140, 0x0141,0x0142,
    0x0143,0x0144, 0x0145,0x0146, 0x0147,0x0148, 0x014A,0x014B,
    0x014C,0x014D, 0x014E,0x014F, 0x0150,0x0151, 0x0152,0x0153,
    0x0154,0x0155, 0x0156,0x0157, 0x0158,0x0159, 0x015A,0x015B,
    0x015C,0x015D, 0x015E,0x015F, 0x0160,0x0161, 0x0162,0x0163,
    0x0164,0x0165, 0x0166,0x0167, 0x0168,0x0169, 0x016A,0x016B,
    0x016C,0x016D, 0x016E,0x016F, 0x0170,0x0171, 0x0172,0x0173,
    0x0174,0x0175, 0x0176,0x0177, 0x0178,0x00FF, 0x0179,0x017A,
    0x017B,0x017C, 0x017D,0x017E, 0x0181,0x0253, 0x0182,0x0183,
    0x0184,0x0185, 0x0186,0x0254, 0x0187,0x0188, 0x0189,0x0256,
    0x018A,0x0257, 0x018B,0x018C, 0x018E,0x01DD, 0x018F,0x0259,
    0x0190,0x025B, 0x0191,0x0192, 0x0193,0x0260, 0x0194,0x0263,
    0x0196,0x0269, 0x0197,0x0268, 0x0198,0x0199, 0x019C,0x026F,
    0x019D,0x0272, 0x019F,0x0275, 0x01A0,0x01A1, 0x01A2,0x01A3,
    0x01A4,0x01A5, 0x01A6,0x0280, 0x01A7,0x01A8, 0x01A9,0x0283,
    0x01AC,0x01AD, 0x01AE,0x0288, 0x01AF,0x01B0, 0x01B1,0x028A,
    0x01B2,0x028B, 0x01B3,0x01B4, 0x01B5,0x01B6, 0x01B7,0x0292,
    0x01B8,0x01B9, 0x01BC,0x01BD, 0x01C4,0x01C6, 0x01C5,0x01C6,
    0x01C7,0x01C9, 0x01C8,0x01C9, 0x01CA,0x01CC, 0x01CB,0x01CC,
    0x01CD,0x01CE, 0x01CF,0x01D0, 0x01D1,0x01D2, 0x01D3,0x01D4,
    0x01D5,0x01D6, 0x01D7,0x01D8, 0x01D9,0x01DA, 0x01DB,0x01DC,
    0x01DE,0x01DF, 0x01E0,0x01E1, 0x01E2,0x01E3, 0x01E4,0x01E5,
    0x01E6,0x01E7, 0x01E8,0x01E9, 0x01EA,0x01EB, 0x01EC,0x01ED,
    0x01EE,0x01EF, 0x01F1,0x01F3, 0x01F2,0x01F3, 0x01F4,0x01F5,
    0x01F6,0x0195, 0x01F7,0x01BF, 0x01F8,0x01F9, 0x01FA,0x01FB,
    0x01FC,0x01FD, 0x01FE,0x01FF, 0x0200,0x0201, 0x0202,0x0203,
    0x0204,0x0205, 0x0206,0x0207, 0x0208,0x0209, 0x020A,0x020B,
    0x020C,0x020D, 0x020E,0x020F, 0x0210,0x0211, 0x0212,0x0213,
    0x0214,0x0215, 0x0216,0x0217, 0x0218,0x0219, 0x021A,0x021B,
    0x021C,0x021D, 0x021E,0x021F, 0x0220,0x019E, 0x0222,0x0223,
    0x0224,0x0225, 0x0226,0x0227, 0x0228,0x0229, 0x022A,0x022B,
    0x022C,0x022D, 0x022E,0x022F, 0x0230,0x0231, 0x0232,0x0233,
    0x023A,0x2C65, 0x023B,0x023C, 0x023D,0x019A, 0x023E,0x2C66,
    0x0241,0x0242, 0x0243,0x0180, 0x0244,0x0289, 0x0245,0x028C,
    0x0246,0x0247, 0x0248,0x0249, 0x024A,0x024B, 0x024C,0x024D,
    0x024E,0x024F, 0x0370,0x0371, 0x0372,0x0373, 0x0376,0x0377,
    0x037F,0x03F3, 0x0386,0x03AC, 0x0388,0x03AD, 0x0389,0x03AE,
    0x038A,0x03AF, 0x038C,0x03CC, 0x038E,0x03CD, 0x038F,0x03CE,
    0x0391,0x03B1, 0x0392,0x03B2, 0x0393,0x03B3, 0x0394,0x03B4,
    0x0395,0x03B5, 0x0396,0x03B6, 0x0397,0x03B7, 0x0398,0x03B8,
    0x0399,0x03B9, 0x039A,0x03BA, 0x039B,0x03BB, 0x039C,0x03BC,
    0x039D,0x03BD, 0x039E,0x03BE, 0x039F,0x03BF, 0x03A0,0x03C0,
    0x03A1,0x03C1, 0x03A3,0x03C3, 0x03A4,0x03C4, 0x03A5,0x03C5,
    0x03A6,0x03C6, 0x03A7,0x03C7, 0x03A8,0x03C8, 0x03A9,0x03C9,
    0x03AA,0x03CA, 0x03AB,0x03CB, 0x03CF,0x03D7, 0x03D8,0x03D9,
    0x03DA,0x03DB, 0x03DC,0x03DD, 0x03DE,0x03DF, 0x03E0,0x03E1,
    0x03E2,0x03E3, 0x03E4,0x03E5, 0x03E6,0x03E7, 0x03E8,0x03E9,
    0x03EA,0x03EB, 0x03EC,0x03ED, 0x03EE,0x03EF, 0x03F4,0x03B8,
    0x03F7,0x03F8, 0x03F9,0x03F2, 0x03FA,0x03FB, 0x03FD,0x037B,
    0x03FE,0x037C, 0x03FF,0x037D, 0x0400,0x0450, 0x0401,0x0451,
    0x0402,0x0452, 0x0403,0x0453, 0x0404,0x0454, 0x0405,0x0455,
    0x0406,0x0456, 0x0407,0x0457, 0x0408,0x0458, 0x0409,0x0459,
    0x040A,0x045A, 0x040B,0x045B, 0x040C,0x045C, 0x040D,0x045D,
    0x040E,0x045E, 0x040F,0x045F, 0x0410,0x0430, 0x0411,0x0431,
    0x0412,0x0432, 0x0413,0x0433, 0x0414,0x0434, 0x0415,0x0435,
    0x0416,0x0436, 0x0417,0x0437, 0x0418,0x0438, 0x0419,0x0439,
    0x041A,0x043A, 0x041B,0x043B, 0x041C,0x043C, 0x041D,0x043D,
    0x041E,0x043E, 0x041F,0x043F, 0x0420,0x0440, 0x0421,0x0441,
    0x0422,0x0442, 0x0423,0x0443, 0x0424,0x0444, 0x0425,0x0445,
    0x0426,0x0446, 0x0427,0x0447, 0x0428,0x0448, 0x0429,0x0449,
    0x042A,0x044A, 0x042B,0x044B, 0x042C,0x044C, 0x042D,0x044D,
    0x042E,0x044E, 0x042F,0x044F, 0x0460,0x0461, 0x0462,0x0463,
    0x0464,0x0465, 0x0466,0x0467, 0x0468,0x0469, 0x046A,0x046B,
    0x046C,0x046D, 0x046E,0x046F, 0x0470,0x0471, 0x0472,0x0473,
    0x0474,0x0475, 0x0476,0x0477, 0x0478,0x0479, 0x047A,0x047B,
    0x047C,0x047D, 0x047E,0x047F, 0x0480,0x0481, 0x048A,0x048B,
    0x048C,0x048D, 0x048E,0x048F, 0x0490,0x0491, 0x0492,0x0493,
    0x0494,0x0495, 0x0496,0x0497, 0x0498,0x0499, 0x049A,0x049B,
    0x049C,0x049D, 0x049E,0x049F, 0x04A0,0x04A1, 0x04A2,0x04A3,
    0x04A4,0x04A5, 0x04A6,0x04A7, 0x04A8,0x04A9, 0x04AA,0x04AB,
    0x04AC,0x04AD, 0x04AE,0x04AF, 0x04B0,0x04B1, 0x04B2,0x04B3,
    0x04B4,0x04B5, 0x04B6,0x04B7, 0x04B8,0x04B9, 0x04BA,0x04BB,
    0x04BC,0x04BD, 0x04BE,0x04BF, 0x04C0,0x04CF, 0x04C1,0x04C2,
    0x04C3,0x04C4, 0x04C5,0x04C6, 0x04C7,0x04C8, 0x04C9,0x04CA,
    0x04CB,0x04CC, 0x04CD,0x04CE, 0x04D0,0x04D1, 0x04D2,0x04D3,
    0x04D4,0x04D5, 0x04D6,0x04D7, 0x04D8,0x04D9, 0x04DA,0x04DB,
    0x04DC,0x04DD, 0x04DE,0x04DF, 0x04E0,0x04E1, 0x04E2,0x04E3,
    0x04E4,0x04E5, 0x04E6,0x04E7, 0x04E8,0x04E9, 0x04EA,0x04EB,
    0x04EC,0x04ED, 0x04EE,0x04EF, 0x04F0,0x04F1, 0x04F2,0x04F3,
    0x04F4,0x04F5, 0x04F6,0x04F7, 0x04F8,0x04F9, 0x04FA,0x04FB,
    0x04FC,0x04FD, 0x04FE,0x04FF, 0x0500,0x0501, 0x0502,0x0503,
    0x0504,0x0505, 0x0506,0x0507, 0x0508,0x0509, 0x050A,0x050B,
    0x050C,0x050D, 0x050E,0x050F, 0x0510,0x0511, 0x0512,0x0513,
    0x0514,0x0515, 0x0516,0x0517, 0x0518,0x0519, 0x051A,0x051B,
    0x051C,0x051D, 0x051E,0x051F, 0x0520,0x0521, 0x0522,0x0523,
    0x0524,0x0525, 0x0526,0x0527, 0x0528,0x0529, 0x052A,0x052B,
    0x052C,0x052D, 0x052E,0x052F, 0x0531,0x0561, 0x0532,0x0562,
    0x0533,0x0563, 0x0534,0x0564, 0x0535,0x0565, 0x0536,0x0566,
    0x0537,0x0567, 0x0538,0x0568, 0x0539,0x0569, 0x053A,0x056A,
    0x053B,0x056B, 0x053C,0x056C, 0x053D,0x056D, 0x053E,0x056E,
    0x053F,0x056F, 0x0540,0x0570, 0x0541,0x0571, 0x0542,0x0572,
    0x0543,0x0573, 0x0544,0x0574, 0x0545,0x0575, 0x0546,0x0576,
    0x0547,0x0577, 0x0548,0x0578, 0x0549,0x0579, 0x054A,0x057A,
    0x054B,0x057B, 0x054C,0x057C, 0x054D,0x057D, 0x054E,0x057E,
    0x054F,0x057F, 0x0550,0x0580, 0x0551,0x0581, 0x0552,0x0582,
    0x0553,0x0583, 0x0554,0x0584, 0x0555,0x0585, 0x0556,0x0586,
    0x10A0,0x2D00, 0x10A1,0x2D01, 0x10A2,0x2D02, 0x10A3,0x2D03,
    0x10A4,0x2D04, 0x10A5,0x2D05, 0x10A6,0x2D06, 0x10A7,0x2D07,
    0x10A8,0x2D08, 0x10A9,0x2D09, 0x10AA,0x2D0A, 0x10AB,0x2D0B,
    0x10AC,0x2D0C, 0x10AD,0x2D0D, 0x10AE,0x2D0E, 0x10AF,0x2D0F,
    0x10B0,0x2D10, 0x10B1,0x2D11, 0x10B2,0x2D12, 0x10B3,0x2D13,
    0x10B4,0x2D14, 0x10B5,0x2D15, 0x10B6,0x2D16, 0x10B7,0x2D17,
    0x10B8,0x2D18, 0x10B9,0x2D19, 0x10BA,0x2D1A, 0x10BB,0x2D1B,
    0x10BC,0x2D1C, 0x10BD,0x2D1D, 0x10BE,0x2D1E, 0x10BF,0x2D1F,
    0x10C0,0x2D20, 0x10C1,0x2D21, 0x10C2,0x2D22, 0x10C3,0x2D23,
    0x10C4,0x2D24, 0x10C5,0x2D25, 0x10C7,0x2D27, 0x10CD,0x2D2D,
    0x13A0,0xAB70, 0x13A1,0xAB71, 0x13A2,0xAB72, 0x13A3,0xAB73,
    0x13A4,0xAB74, 0x13A5,0xAB75, 0x13A6,0xAB76, 0x13A7,0xAB77,
    0x13A8,0xAB78, 0x13A9,0xAB79, 0x13AA,0xAB7A, 0x13AB,0xAB7B,
    0x13AC,0xAB7C, 0x13AD,0xAB7D, 0x13AE,0xAB7E, 0x13AF,0xAB7F,
    0x13B0,0xAB80, 0x13B1,0xAB81, 0x13B2,0xAB82, 0x13B3,0xAB83,
    0x13B4,0xAB84, 0x13B5,0xAB85, 0x13B6,0xAB86, 0x13B7,0xAB87,
    0x13B8,0xAB88, 0x13B9,0xAB89, 0x13BA,0xAB8A, 0x13BB,0xAB8B,
    0x13BC,0xAB8C, 0x13BD,0xAB8D, 0x13BE,0xAB8E, 0x13BF,0xAB8F,
    0x13C0,0xAB90, 0x13C1,0xAB91, 0x13C2,0xAB92, 0x13C3,0xAB93,
    0x13C4,0xAB94, 0x13C5,0xAB95, 0x13C6,0xAB96, 0x13C7,0xAB97,
    0x13C8,0xAB98, 0x13C9,0xAB99, 0x13CA,0xAB9A, 0x13CB,0xAB9B,
    0x13CC,0xAB9C, 0x13CD,0xAB9D, 0x13CE,0xAB9E, 0x13CF,0xAB9F,
    0x13D0,0xABA0, 0x13D1,0xABA1, 0x13D2,0xABA2, 0x13D3,0xABA3,
    0x13D4,0xABA4, 0x13D5,0xABA5, 0x13D6,0xABA6, 0x13D7,0xABA7,
    0x13D8,0xABA8, 0x13D9,0xABA9, 0x13DA,0xABAA, 0x13DB,0xABAB,
    0x13DC,0xABAC, 0x13DD,0xABAD, 0x13DE,0xABAE, 0x13DF,0xABAF,
    0x13E0,0xABB0, 0x13E1,0xABB1, 0x13E2,0xABB2, 0x13E3,0xABB3,
    0x13E4,0xABB4, 0x13E5,0xABB5, 0x13E6,0xABB6, 0x13E7,0xABB7,
    0x13E8,0xABB8, 0x13E9,0xABB9, 0x13EA,0xABBA, 0x13EB,0xABBB,
    0x13EC,0xABBC, 0x13ED,0xABBD, 0x13EE,0xABBE, 0x13EF,0xABBF,
    0x13F0,0x13F8, 0x13F1,0x13F9, 0x13F2,0x13FA, 0x13F3,0x13FB,
    0x13F4,0x13FC, 0x13F5,0x13FD, 0x1C89,0x1C8A, 0x1C90,0x10D0,
    0x1C91,0x10D1, 0x1C92,0x10D2, 0x1C93,0x10D3, 0x1C94,0x10D4,
    0x1C95,0x10D5, 0x1C96,0x10D6, 0x1C97,0x10D7, 0x1C98,0x10D8,
    0x1C99,0x10D9, 0x1C9A,0x10DA, 0x1C9B,0x10DB, 0x1C9C,0x10DC,
    0x1C9D,0x10DD, 0x1C9E,0x10DE, 0x1C9F,0x10DF, 0x1CA0,0x10E0,
    0x1CA1,0x10E1, 0x1CA2,0x10E2, 0x1CA3,0x10E3, 0x1CA4,0x10E4,
    0x1CA5,0x10E5, 0x1CA6,0x10E6, 0x1CA7,0x10E7, 0x1CA8,0x10E8,
    0x1CA9,0x10E9, 0x1CAA,0x10EA, 0x1CAB,0x10EB, 0x1CAC,0x10EC,
    0x1CAD,0x10ED, 0x1CAE,0x10EE, 0x1CAF,0x10EF, 0x1CB0,0x10F0,
    0x1CB1,0x10F1, 0x1CB2,0x10F2, 0x1CB3,0x10F3, 0x1CB4,0x10F4,
    0x1CB5,0x10F5, 0x1CB6,0x10F6, 0x1CB7,0x10F7, 0x1CB8,0x10F8,
    0x1CB9,0x10F9, 0x1CBA,0x10FA, 0x1CBD,0x10FD, 0x1CBE,0x10FE,
    0x1CBF,0x10FF, 0x1E00,0x1E01, 0x1E02,0x1E03, 0x1E04,0x1E05,
    0x1E06,0x1E07, 0x1E08,0x1E09, 0x1E0A,0x1E0B, 0x1E0C,0x1E0D,
    0x1E0E,0x1E0F, 0x1E10,0x1E11, 0x1E12,0x1E13, 0x1E14,0x1E15,
    0x1E16,0x1E17, 0x1E18,0x1E19, 0x1E1A,0x1E1B, 0x1E1C,0x1E1D,
    0x1E1E,0x1E1F, 0x1E20,0x1E21, 0x1E22,0x1E23, 0x1E24,0x1E25,
    0x1E26,0x1E27, 0x1E28,0x1E29, 0x1E2A,0x1E2B, 0x1E2C,0x1E2D,
    0x1E2E,0x1E2F, 0x1E30,0x1E31, 0x1E32,0x1E33, 0x1E34,0x1E35,
    0x1E36,0x1E37, 0x1E38,0x1E39, 0x1E3A,0x1E3B, 0x1E3C,0x1E3D,
    0x1E3E,0x1E3F, 0x1E40,0x1E41, 0x1E42,0x1E43, 0x1E44,0x1E45,
    0x1E46,0x1E47, 0x1E48,0x1E49, 0x1E4A,0x1E4B, 0x1E4C,0x1E4D,
    0x1E4E,0x1E4F, 0x1E50,0x1E51, 0x1E52,0x1E53, 0x1E54,0x1E55,
    0x1E56,0x1E57, 0x1E58,0x1E59, 0x1E5A,0x1E5B, 0x1E5C,0x1E5D,
    0x1E5E,0x1E5F, 0x1E60,0x1E61, 0x1E62,0x1E63, 0x1E64,0x1E65,
    0x1E66,0x1E67, 0x1E68,0x1E69, 0x1E6A,0x1E6B, 0x1E6C,0x1E6D,
    0x1E6E,0x1E6F, 0x1E70,0x1E71, 0x1E72,0x1E73, 0x1E74,0x1E75,
    0x1E76,0x1E77, 0x1E78,0x1E79, 0x1E7A,0x1E7B, 0x1E7C,0x1E7D,
    0x1E7E,0x1E7F, 0x1E80,0x1E81, 0x1E82,0x1E83, 0x1E84,0x1E85,
    0x1E86,0x1E87, 0x1E88,0x1E89, 0x1E8A,0x1E8B, 0x1E8C,0x1E8D,
    0x1E8E,0x1E8F, 0x1E90,0x1E91, 0x1E92,0x1E93, 0x1E94,0x1E95,
    0x1E9E,0x00DF, 0x1EA0,0x1EA1, 0x1EA2,0x1EA3, 0x1EA4,0x1EA5,
    0x1EA6,0x1EA7, 0x1EA8,0x1EA9, 0x1EAA,0x1EAB, 0x1EAC,0x1EAD,
    0x1EAE,0x1EAF, 0x1EB0,0x1EB1, 0x1EB2,0x1EB3, 0x1EB4,0x1EB5,
    0x1EB6,0x1EB7, 0x1EB8,0x1EB9, 0x1EBA,0x1EBB, 0x1EBC,0x1EBD,
    0x1EBE,0x1EBF, 0x1EC0,0x1EC1, 0x1EC2,0x1EC3, 0x1EC4,0x1EC5,
    0x1EC6,0x1EC7, 0x1EC8,0x1EC9, 0x1ECA,0x1ECB, 0x1ECC,0x1ECD,
    0x1ECE,0x1ECF, 0x1ED0,0x1ED1, 0x1ED2,0x1ED3, 0x1ED4,0x1ED5,
    0x1ED6,0x1ED7, 0x1ED8,0x1ED9, 0x1EDA,0x1EDB, 0x1EDC,0x1EDD,
    0x1EDE,0x1EDF, 0x1EE0,0x1EE1, 0x1EE2,0x1EE3, 0x1EE4,0x1EE5,
    0x1EE6,0x1EE7, 0x1EE8,0x1EE9, 0x1EEA,0x1EEB, 0x1EEC,0x1EED,
    0x1EEE,0x1EEF, 0x1EF0,0x1EF1, 0x1EF2,0x1EF3, 0x1EF4,0x1EF5,
    0x1EF6,0x1EF7, 0x1EF8,0x1EF9, 0x1EFA,0x1EFB, 0x1EFC,0x1EFD,
    0x1EFE,0x1EFF, 0x1F08,0x1F00, 0x1F09,0x1F01, 0x1F0A,0x1F02,
    0x1F0B,0x1F03, 0x1F0C,0x1F04, 0x1F0D,0x1F05, 0x1F0E,0x1F06,
    0x1F0F,0x1F07, 0x1F18,0x1F10, 0x1F19,0x1F11, 0x1F1A,0x1F12,
    0x1F1B,0x1F13, 0x1F1C,0x1F14, 0x1F1D,0x1F15, 0x1F28,0x1F20,
    0x1F29,0x1F21, 0x1F2A,0x1F22, 0x1F2B,0x1F23, 0x1F2C,0x1F24,
    0x1F2D,0x1F25, 0x1F2E,0x1F26, 0x1F2F,0x1F27, 0x1F38,0x1F30,
    0x1F39,0x1F31, 0x1F3A,0x1F32, 0x1F3B,0x1F33, 0x1F3C,0x1F34,
    0x1F3D,0x1F35, 0x1F3E,0x1F36, 0x1F3F,0x1F37, 0x1F48,0x1F40,
    0x1F49,0x1F41, 0x1F4A,0x1F42, 0x1F4B,0x1F43, 0x1F4C,0x1F44,
    0x1F4D,0x1F45, 0x1F59,0x1F51, 0x1F5B,0x1F53, 0x1F5D,0x1F55,
    0x1F5F,0x1F57, 0x1F68,0x1F60, 0x1F69,0x1F61, 0x1F6A,0x1F62,
    0x1F6B,0x1F63, 0x1F6C,0x1F64, 0x1F6D,0x1F65, 0x1F6E,0x1F66,
    0x1F6F,0x1F67, 0x1F88,0x1F80, 0x1F89,0x1F81, 0x1F8A,0x1F82,
    0x1F8B,0x1F83, 0x1F8C,0x1F84, 0x1F8D,0x1F85, 0x1F8E,0x1F86,
    0x1F8F,0x1F87, 0x1F98,0x1F90, 0x1F99,0x1F91, 0x1F9A,0x1F92,
    0x1F9B,0x1F93, 0x1F9C,0x1F94, 0x1F9D,0x1F95, 0x1F9E,0x1F96,
    0x1F9F,0x1F97, 0x1FA8,0x1FA0, 0x1FA9,0x1FA1, 0x1FAA,0x1FA2,
    0x1FAB,0x1FA3, 0x1FAC,0x1FA4, 0x1FAD,0x1FA5, 0x1FAE,0x1FA6,
    0x1FAF,0x1FA7, 0x1FB8,0x1FB0, 0x1FB9,0x1FB1, 0x1FBA,0x1F70,
    0x1FBB,0x1F71, 0x1FBC,0x1FB3, 0x1FC8,0x1F72, 0x1FC9,0x1F73,
    0x1FCA,0x1F74, 0x1FCB,0x1F75, 0x1FCC,0x1FC3, 0x1FD8,0x1FD0,
    0x1FD9,0x1FD1, 0x1FDA,0x1F76, 0x1FDB,0x1F77, 0x1FE8,0x1FE0,
    0x1FE9,0x1FE1, 0x1FEA,0x1F7A, 0x1FEB,0x1F7B, 0x1FEC,0x1FE5,
    0x1FF8,0x1F78, 0x1FF9,0x1F79, 0x1FFA,0x1F7C, 0x1FFB,0x1F7D,
    0x1FFC,0x1FF3, 0x2126,0x03C9, 0x212A,0x006B, 0x212B,0x00E5,
    0x2132,0x214E, 0x2160,0x2170, 0x2161,0x2171, 0x2162,0x2172,
    0x2163,0x2173, 0x2164,0x2174, 0x2165,0x2175, 0x2166,0x2176,
    0x2167,0x2177, 0x2168,0x2178, 0x2169,0x2179, 0x216A,0x217A,
    0x216B,0x217B, 0x216C,0x217C, 0x216D,0x217D, 0x216E,0x217E,
    0x216F,0x217F, 0x2183,0x2184, 0x24B6,0x24D0, 0x24B7,0x24D1,
    0x24B8,0x24D2, 0x24B9,0x24D3, 0x24BA,0x24D4, 0x24BB,0x24D5,
    0x24BC,0x24D6, 0x24BD,0x24D7, 0x24BE,0x24D8, 0x24BF,0x24D9,
    0x24C0,0x24DA, 0x24C1,0x24DB, 0x24C2,0x24DC, 0x24C3,0x24DD,
    0x24C4,0x24DE, 0x24C5,0x24DF, 0x24C6,0x24E0, 0x24C7,0x24E1,
    0x24C8,0x24E2, 0x24C9,0x24E3, 0x24CA,0x24E4, 0x24CB,0x24E5,
    0x24CC,0x24E6, 0x24CD,0x24E7, 0x24CE,0x24E8, 0x24CF,0x24E9,
    0x2C00,0x2C30, 0x2C01,0x2C31, 0x2C02,0x2C32, 0x2C03,0x2C33,
    0x2C04,0x2C34, 0x2C05,0x2C35, 0x2C06,0x2C36, 0x2C07,0x2C37,
    0x2C08,0x2C38, 0x2C09,0x2C39, 0x2C0A,0x2C3A, 0x2C0B,0x2C3B,
    0x2C0C,0x2C3C, 0x2C0D,0x2C3D, 0x2C0E,0x2C3E, 0x2C0F,0x2C3F,
    0x2C10,0x2C40, 0x2C11,0x2C41, 0x2C12,0x2C42, 0x2C13,0x2C43,
    0x2C14,0x2C44, 0x2C15,0x2C45, 0x2C16,0x2C46, 0x2C17,0x2C47,
    0x2C18,0x2C48, 0x2C19,0x2C49, 0x2C1A,0x2C4A, 0x2C1B,0x2C4B,
    0x2C1C,0x2C4C, 0x2C1D,0x2C4D, 0x2C1E,0x2C4E, 0x2C1F,0x2C4F,
    0x2C20,0x2C50, 0x2C21,0x2C51, 0x2C22,0x2C52, 0x2C23,0x2C53,
    0x2C24,0x2C54, 0x2C25,0x2C55, 0x2C26,0x2C56, 0x2C27,0x2C57,
    0x2C28,0x2C58, 0x2C29,0x2C59, 0x2C2A,0x2C5A, 0x2C2B,0x2C5B,
    0x2C2C,0x2C5C, 0x2C2D,0x2C5D, 0x2C2E,0x2C5E, 0x2C2F,0x2C5F,
    0x2C60,0x2C61, 0x2C62,0x026B, 0x2C63,0x1D7D, 0x2C64,0x027D,
    0x2C67,0x2C68, 0x2C69,0x2C6A, 0x2C6B,0x2C6C, 0x2C6D,0x0251,
    0x2C6E,0x0271, 0x2C6F,0x0250, 0x2C70,0x0252, 0x2C72,0x2C73,
    0x2C75,0x2C76, 0x2C7E,0x023F, 0x2C7F,0x0240, 0x2C80,0x2C81,
    0x2C82,0x2C83, 0x2C84,0x2C85, 0x2C86,0x2C87, 0x2C88,0x2C89,
    0x2C8A,0x2C8B, 0x2C8C,0x2C8D, 0x2C8E,0x2C8F, 0x2C90,0x2C91,
    0x2C92,0x2C93, 0x2C94,0x2C95, 0x2C96,0x2C97, 0x2C98,0x2C99,
    0x2C9A,0x2C9B, 0x2C9C,0x2C9D, 0x2C9E,0x2C9F, 0x2CA0,0x2CA1,
    0x2CA2,0x2CA3, 0x2CA4,0x2CA5, 0x2CA6,0x2CA7, 0x2CA8,0x2CA9,
    0x2CAA,0x2CAB, 0x2CAC,0x2CAD, 0x2CAE,0x2CAF, 0x2CB0,0x2CB1,
    0x2CB2,0x2CB3, 0x2CB4,0x2CB5, 0x2CB6,0x2CB7, 0x2CB8,0x2CB9,
    0x2CBA,0x2CBB, 0x2CBC,0x2CBD, 0x2CBE,0x2CBF, 0x2CC0,0x2CC1,
    0x2CC2,0x2CC3, 0x2CC4,0x2CC5, 0x2CC6,0x2CC7, 0x2CC8,0x2CC9,
    0x2CCA,0x2CCB, 0x2CCC,0x2CCD, 0x2CCE,0x2CCF, 0x2CD0,0x2CD1,
    0x2CD2,0x2CD3, 0x2CD4,0x2CD5, 0x2CD6,0x2CD7, 0x2CD8,0x2CD9,
    0x2CDA,0x2CDB, 0x2CDC,0x2CDD, 0x2CDE,0x2CDF, 0x2CE0,0x2CE1,
    0x2CE2,0x2CE3, 0x2CEB,0x2CEC, 0x2CED,0x2CEE, 0x2CF2,0x2CF3,
    0xA640,0xA641, 0xA642,0xA643, 0xA644,0xA645, 0xA646,0xA647,
    0xA648,0xA649, 0xA64A,0xA64B, 0xA64C,0xA64D, 0xA64E,0xA64F,
    0xA650,0xA651, 0xA652,0xA653, 0xA654,0xA655, 0xA656,0xA657,
    0xA658,0xA659, 0xA65A,0xA65B, 0xA65C,0xA65D, 0xA65E,0xA65F,
    0xA660,0xA661, 0xA662,0xA663, 0xA664,0xA665, 0xA666,0xA667,
    0xA668,0xA669, 0xA66A,0xA66B, 0xA66C,0xA66D, 0xA680,0xA681,
    0xA682,0xA683, 0xA684,0xA685, 0xA686,0xA687, 0xA688,0xA689,
    0xA68A,0xA68B, 0xA68C,0xA68D, 0xA68E,0xA68F, 0xA690,0xA691,
    0xA692,0xA693, 0xA694,0xA695, 0xA696,0xA697, 0xA698,0xA699,
    0xA69A,0xA69B, 0xA722,0xA723, 0xA724,0xA725, 0xA726,0xA727,
    0xA728,0xA729, 0xA72A,0xA72B, 0xA72C,0xA72D, 0xA72E,0xA72F,
    0xA732,0xA733, 0xA734,0xA735, 0xA736,0xA737, 0xA738,0xA739,
    0xA73A,0xA73B, 0xA73C,0xA73D, 0xA73E,0xA73F, 0xA740,0xA741,
    0xA742,0xA743, 0xA744,0xA745, 0xA746,0xA747, 0xA748,0xA749,
    0xA74A,0xA74B, 0xA74C,0xA74D, 0xA74E,0xA74F, 0xA750,0xA751,
    0xA752,0xA753, 0xA754,0xA755, 0xA756,0xA757, 0xA758,0xA759,
    0xA75A,0xA75B, 0xA75C,0xA75D, 0xA75E,0xA75F, 0xA760,0xA761,
    0xA762,0xA763, 0xA764,0xA765, 0xA766,0xA767, 0xA768,0xA769,
    0xA76A,0xA76B, 0xA76C,0xA76D, 0xA76E,0xA76F, 0xA779,0xA77A,
    0xA77B,0xA77C, 0xA77D,0x1D79, 0xA77E,0xA77F, 0xA780,0xA781,
    0xA782,0xA783, 0xA784,0xA785, 0xA786,0xA787, 0xA78B,0xA78C,
    0xA78D,0x0265, 0xA790,0xA791, 0xA792,0xA793, 0xA796,0xA797,
    0xA798,0xA799, 0xA79A,0xA79B, 0xA79C,0xA79D, 0xA79E,0xA79F,
    0xA7A0,0xA7A1, 0xA7A2,0xA7A3, 0xA7A4,0xA7A5, 0xA7A6,0xA7A7,
    0xA7A8,0xA7A9, 0xA7AA,0x0266, 0xA7AB,0x025C, 0xA7AC,0x0261,
    0xA7AD,0x026C, 0xA7AE,0x026A, 0xA7B0,0x029E, 0xA7B1,0x0287,
    0xA7B2,0x029D, 0xA7B3,0xAB53, 0xA7B4,0xA7B5, 0xA7B6,0xA7B7,
    0xA7B8,0xA7B9, 0xA7BA,0xA7BB, 0xA7BC,0xA7BD, 0xA7BE,0xA7BF,
    0xA7C0,0xA7C1, 0xA7C2,0xA7C3, 0xA7C4,0xA794, 0xA7C5,0x0282,
    0xA7C6,0x1D8E, 0xA7C7,0xA7C8, 0xA7C9,0xA7CA, 0xA7CB,0x0264,
    0xA7CC,0xA7CD, 0xA7D0,0xA7D1, 0xA7D6,0xA7D7, 0xA7D8,0xA7D9,
    0xA7DA,0xA7DB, 0xA7DC,0x019B, 0xA7F5,0xA7F6, 0xFF21,0xFF41,
    0xFF22,0xFF42, 0xFF23,0xFF43, 0xFF24,0xFF44, 0xFF25,0xFF45,
    0xFF26,0xFF46, 0xFF27,0xFF47, 0xFF28,0xFF48, 0xFF29,0xFF49,
    0xFF2A,0xFF4A, 0xFF2B,0xFF4B, 0xFF2C,0xFF4C, 0xFF2D,0xFF4D,
    0xFF2E,0xFF4E, 0xFF2F,0xFF4F, 0xFF30,0xFF50, 0xFF31,0xFF51,
    0xFF32,0xFF52, 0xFF33,0xFF53, 0xFF34,0xFF54, 0xFF35,0xFF55,
    0xFF36,0xFF56, 0xFF37,0xFF57, 0xFF38,0xFF58, 0xFF39,0xFF59,
    0xFF3A,0xFF5A, 0x10400,0x10428, 0x10401,0x10429, 0x10402,0x1042A,
    0x10403,0x1042B, 0x10404,0x1042C, 0x10405,0x1042D, 0x10406,0x1042E,
    0x10407,0x1042F, 0x10408,0x10430, 0x10409,0x10431, 0x1040A,0x10432,
    0x1040B,0x10433, 0x1040C,0x10434, 0x1040D,0x10435, 0x1040E,0x10436,
    0x1040F,0x10437, 0x10410,0x10438, 0x10411,0x10439, 0x10412,0x1043A,
    0x10413,0x1043B, 0x10414,0x1043C, 0x10415,0x1043D, 0x10416,0x1043E,
    0x10417,0x1043F, 0x10418,0x10440, 0x10419,0x10441, 0x1041A,0x10442,
    0x1041B,0x10443, 0x1041C,0x10444, 0x1041D,0x10445, 0x1041E,0x10446,
    0x1041F,0x10447, 0x10420,0x10448, 0x10421,0x10449, 0x10422,0x1044A,
    0x10423,0x1044B, 0x10424,0x1044C, 0x10425,0x1044D, 0x10426,0x1044E,
    0x10427,0x1044F, 0x104B0,0x104D8, 0x104B1,0x104D9, 0x104B2,0x104DA,
    0x104B3,0x104DB, 0x104B4,0x104DC, 0x104B5,0x104DD, 0x104B6,0x104DE,
    0x104B7,0x104DF, 0x104B8,0x104E0, 0x104B9,0x104E1, 0x104BA,0x104E2,
    0x104BB,0x104E3, 0x104BC,0x104E4, 0x104BD,0x104E5, 0x104BE,0x104E6,
    0x104BF,0x104E7, 0x104C0,0x104E8, 0x104C1,0x104E9, 0x104C2,0x104EA,
    0x104C3,0x104EB, 0x104C4,0x104EC, 0x104C5,0x104ED, 0x104C6,0x104EE,
    0x104C7,0x104EF, 0x104C8,0x104F0, 0x104C9,0x104F1, 0x104CA,0x104F2,
    0x104CB,0x104F3, 0x104CC,0x104F4, 0x104CD,0x104F5, 0x104CE,0x104F6,
    0x104CF,0x104F7, 0x104D0,0x104F8, 0x104D1,0x104F9, 0x104D2,0x104FA,
    0x104D3,0x104FB, 0x10570,0x10597, 0x10571,0x10598, 0x10572,0x10599,
    0x10573,0x1059A, 0x10574,0x1059B, 0x10575,0x1059C, 0x10576,0x1059D,
    0x10577,0x1059E, 0x10578,0x1059F, 0x10579,0x105A0, 0x1057A,0x105A1,
    0x1057C,0x105A3, 0x1057D,0x105A4, 0x1057E,0x105A5, 0x1057F,0x105A6,
    0x10580,0x105A7, 0x10581,0x105A8, 0x10582,0x105A9, 0x10583,0x105AA,
    0x10584,0x105AB, 0x10585,0x105AC, 0x10586,0x105AD, 0x10587,0x105AE,
    0x10588,0x105AF, 0x10589,0x105B0, 0x1058A,0x105B1, 0x1058C,0x105B3,
    0x1058D,0x105B4, 0x1058E,0x105B5, 0x1058F,0x105B6, 0x10590,0x105B7,
    0x10591,0x105B8, 0x10592,0x105B9, 0x10594,0x105BB, 0x10595,0x105BC,
    0x10C80,0x10CC0, 0x10C81,0x10CC1, 0x10C82,0x10CC2, 0x10C83,0x10CC3,
    0x10C84,0x10CC4, 0x10C85,0x10CC5, 0x10C86,0x10CC6, 0x10C87,0x10CC7,
    0x10C88,0x10CC8, 0x10C89,0x10CC9, 0x10C8A,0x10CCA, 0x10C8B,0x10CCB,
    0x10C8C,0x10CCC, 0x10C8D,0x10CCD, 0x10C8E,0x10CCE, 0x10C8F,0x10CCF,
    0x10C90,0x10CD0, 0x10C91,0x10CD1, 0x10C92,0x10CD2, 0x10C93,0x10CD3,
    0x10C94,0x10CD4, 0x10C95,0x10CD5, 0x10C96,0x10CD6, 0x10C97,0x10CD7,
    0x10C98,0x10CD8, 0x10C99,0x10CD9, 0x10C9A,0x10CDA, 0x10C9B,0x10CDB,
    0x10C9C,0x10CDC, 0x10C9D,0x10CDD, 0x10C9E,0x10CDE, 0x10C9F,0x10CDF,
    0x10CA0,0x10CE0, 0x10CA1,0x10CE1, 0x10CA2,0x10CE2, 0x10CA3,0x10CE3,
    0x10CA4,0x10CE4, 0x10CA5,0x10CE5, 0x10CA6,0x10CE6, 0x10CA7,0x10CE7,
    0x10CA8,0x10CE8, 0x10CA9,0x10CE9, 0x10CAA,0x10CEA, 0x10CAB,0x10CEB,
    0x10CAC,0x10CEC, 0x10CAD,0x10CED, 0x10CAE,0x10CEE, 0x10CAF,0x10CEF,
    0x10CB0,0x10CF0, 0x10CB1,0x10CF1, 0x10CB2,0x10CF2, 0x10D50,0x10D70,
    0x10D51,0x10D71, 0x10D52,0x10D72, 0x10D53,0x10D73, 0x10D54,0x10D74,
    0x10D55,0x10D75, 0x10D56,0x10D76, 0x10D57,0x10D77, 0x10D58,0x10D78,
    0x10D59,0x10D79, 0x10D5A,0x10D7A, 0x10D5B,0x10D7B, 0x10D5C,0x10D7C,
    0x10D5D,0x10D7D, 0x10D5E,0x10D7E, 0x10D5F,0x10D7F, 0x10D60,0x10D80,
    0x10D61,0x10D81, 0x10D62,0x10D82, 0x10D63,0x10D83, 0x10D64,0x10D84,
    0x10D65,0x10D85, 0x118A0,0x118C0, 0x118A1,0x118C1, 0x118A2,0x118C2,
    0x118A3,0x118C3, 0x118A4,0x118C4, 0x118A5,0x118C5, 0x118A6,0x118C6,
    0x118A7,0x118C7, 0x118A8,0x118C8, 0x118A9,0x118C9, 0x118AA,0x118CA,
    0x118AB,0x118CB, 0x118AC,0x118CC, 0x118AD,0x118CD, 0x118AE,0x118CE,
    0x118AF,0x118CF, 0x118B0,0x118D0, 0x118B1,0x118D1, 0x118B2,0x118D2,
    0x118B3,0x118D3, 0x118B4,0x118D4, 0x118B5,0x118D5, 0x118B6,0x118D6,
    0x118B7,0x118D7, 0x118B8,0x118D8, 0x118B9,0x118D9, 0x118BA,0x118DA,
    0x118BB,0x118DB, 0x118BC,0x118DC, 0x118BD,0x118DD, 0x118BE,0x118DE,
    0x118BF,0x118DF, 0x16E40,0x16E60, 0x16E41,0x16E61, 0x16E42,0x16E62,
    0x16E43,0x16E63, 0x16E44,0x16E64, 0x16E45,0x16E65, 0x16E46,0x16E66,
    0x16E47,0x16E67, 0x16E48,0x16E68, 0x16E49,0x16E69, 0x16E4A,0x16E6A,
    0x16E4B,0x16E6B, 0x16E4C,0x16E6C, 0x16E4D,0x16E6D, 0x16E4E,0x16E6E,
    0x16E4F,0x16E6F, 0x16E50,0x16E70, 0x16E51,0x16E71, 0x16E52,0x16E72,
    0x16E53,0x16E73, 0x16E54,0x16E74, 0x16E55,0x16E75, 0x16E56,0x16E76,
    0x16E57,0x16E77, 0x16E58,0x16E78, 0x16E59,0x16E79, 0x16E5A,0x16E7A,
    0x16E5B,0x16E7B, 0x16E5C,0x16E7C, 0x16E5D,0x16E7D, 0x16E5E,0x16E7E,
    0x16E5F,0x16E7F, 0x1E900,0x1E922, 0x1E901,0x1E923, 0x1E902,0x1E924,
    0x1E903,0x1E925, 0x1E904,0x1E926, 0x1E905,0x1E927, 0x1E906,0x1E928,
    0x1E907,0x1E929, 0x1E908,0x1E92A, 0x1E909,0x1E92B, 0x1E90A,0x1E92C,
    0x1E90B,0x1E92D, 0x1E90C,0x1E92E, 0x1E90D,0x1E92F, 0x1E90E,0x1E930,
    0x1E90F,0x1E931, 0x1E910,0x1E932, 0x1E911,0x1E933, 0x1E912,0x1E934,
    0x1E913,0x1E935, 0x1E914,0x1E936, 0x1E915,0x1E937, 0x1E916,0x1E938,
    0x1E917,0x1E939, 0x1E918,0x1E93A, 0x1E919,0x1E93B, 0x1E91A,0x1E93C,
    0x1E91B,0x1E93D, 0x1E91C,0x1E93E, 0x1E91D,0x1E93F, 0x1E91E,0x1E940,
    0x1E91F,0x1E941, 0x1E920,0x1E942, 0x1E921,0x1E943,
};
#define CASE_TO_LOWER_N 1459  /* pairs */

static const uint32_t CASE_TO_UPPER[] = {
    0x0061,0x0041, 0x0062,0x0042, 0x0063,0x0043, 0x0064,0x0044,
    0x0065,0x0045, 0x0066,0x0046, 0x0067,0x0047, 0x0068,0x0048,
    0x0069,0x0049, 0x006A,0x004A, 0x006B,0x004B, 0x006C,0x004C,
    0x006D,0x004D, 0x006E,0x004E, 0x006F,0x004F, 0x0070,0x0050,
    0x0071,0x0051, 0x0072,0x0052, 0x0073,0x0053, 0x0074,0x0054,
    0x0075,0x0055, 0x0076,0x0056, 0x0077,0x0057, 0x0078,0x0058,
    0x0079,0x0059, 0x007A,0x005A, 0x00B5,0x039C, 0x00E0,0x00C0,
    0x00E1,0x00C1, 0x00E2,0x00C2, 0x00E3,0x00C3, 0x00E4,0x00C4,
    0x00E5,0x00C5, 0x00E6,0x00C6, 0x00E7,0x00C7, 0x00E8,0x00C8,
    0x00E9,0x00C9, 0x00EA,0x00CA, 0x00EB,0x00CB, 0x00EC,0x00CC,
    0x00ED,0x00CD, 0x00EE,0x00CE, 0x00EF,0x00CF, 0x00F0,0x00D0,
    0x00F1,0x00D1, 0x00F2,0x00D2, 0x00F3,0x00D3, 0x00F4,0x00D4,
    0x00F5,0x00D5, 0x00F6,0x00D6, 0x00F8,0x00D8, 0x00F9,0x00D9,
    0x00FA,0x00DA, 0x00FB,0x00DB, 0x00FC,0x00DC, 0x00FD,0x00DD,
    0x00FE,0x00DE, 0x00FF,0x0178, 0x0101,0x0100, 0x0103,0x0102,
    0x0105,0x0104, 0x0107,0x0106, 0x0109,0x0108, 0x010B,0x010A,
    0x010D,0x010C, 0x010F,0x010E, 0x0111,0x0110, 0x0113,0x0112,
    0x0115,0x0114, 0x0117,0x0116, 0x0119,0x0118, 0x011B,0x011A,
    0x011D,0x011C, 0x011F,0x011E, 0x0121,0x0120, 0x0123,0x0122,
    0x0125,0x0124, 0x0127,0x0126, 0x0129,0x0128, 0x012B,0x012A,
    0x012D,0x012C, 0x012F,0x012E, 0x0131,0x0049, 0x0133,0x0132,
    0x0135,0x0134, 0x0137,0x0136, 0x013A,0x0139, 0x013C,0x013B,
    0x013E,0x013D, 0x0140,0x013F, 0x0142,0x0141, 0x0144,0x0143,
    0x0146,0x0145, 0x0148,0x0147, 0x014B,0x014A, 0x014D,0x014C,
    0x014F,0x014E, 0x0151,0x0150, 0x0153,0x0152, 0x0155,0x0154,
    0x0157,0x0156, 0x0159,0x0158, 0x015B,0x015A, 0x015D,0x015C,
    0x015F,0x015E, 0x0161,0x0160, 0x0163,0x0162, 0x0165,0x0164,
    0x0167,0x0166, 0x0169,0x0168, 0x016B,0x016A, 0x016D,0x016C,
    0x016F,0x016E, 0x0171,0x0170, 0x0173,0x0172, 0x0175,0x0174,
    0x0177,0x0176, 0x017A,0x0179, 0x017C,0x017B, 0x017E,0x017D,
    0x017F,0x0053, 0x0180,0x0243, 0x0183,0x0182, 0x0185,0x0184,
    0x0188,0x0187, 0x018C,0x018B, 0x0192,0x0191, 0x0195,0x01F6,
    0x0199,0x0198, 0x019A,0x023D, 0x019B,0xA7DC, 0x019E,0x0220,
    0x01A1,0x01A0, 0x01A3,0x01A2, 0x01A5,0x01A4, 0x01A8,0x01A7,
    0x01AD,0x01AC, 0x01B0,0x01AF, 0x01B4,0x01B3, 0x01B6,0x01B5,
    0x01B9,0x01B8, 0x01BD,0x01BC, 0x01BF,0x01F7, 0x01C5,0x01C4,
    0x01C6,0x01C4, 0x01C8,0x01C7, 0x01C9,0x01C7, 0x01CB,0x01CA,
    0x01CC,0x01CA, 0x01CE,0x01CD, 0x01D0,0x01CF, 0x01D2,0x01D1,
    0x01D4,0x01D3, 0x01D6,0x01D5, 0x01D8,0x01D7, 0x01DA,0x01D9,
    0x01DC,0x01DB, 0x01DD,0x018E, 0x01DF,0x01DE, 0x01E1,0x01E0,
    0x01E3,0x01E2, 0x01E5,0x01E4, 0x01E7,0x01E6, 0x01E9,0x01E8,
    0x01EB,0x01EA, 0x01ED,0x01EC, 0x01EF,0x01EE, 0x01F2,0x01F1,
    0x01F3,0x01F1, 0x01F5,0x01F4, 0x01F9,0x01F8, 0x01FB,0x01FA,
    0x01FD,0x01FC, 0x01FF,0x01FE, 0x0201,0x0200, 0x0203,0x0202,
    0x0205,0x0204, 0x0207,0x0206, 0x0209,0x0208, 0x020B,0x020A,
    0x020D,0x020C, 0x020F,0x020E, 0x0211,0x0210, 0x0213,0x0212,
    0x0215,0x0214, 0x0217,0x0216, 0x0219,0x0218, 0x021B,0x021A,
    0x021D,0x021C, 0x021F,0x021E, 0x0223,0x0222, 0x0225,0x0224,
    0x0227,0x0226, 0x0229,0x0228, 0x022B,0x022A, 0x022D,0x022C,
    0x022F,0x022E, 0x0231,0x0230, 0x0233,0x0232, 0x023C,0x023B,
    0x023F,0x2C7E, 0x0240,0x2C7F, 0x0242,0x0241, 0x0247,0x0246,
    0x0249,0x0248, 0x024B,0x024A, 0x024D,0x024C, 0x024F,0x024E,
    0x0250,0x2C6F, 0x0251,0x2C6D, 0x0252,0x2C70, 0x0253,0x0181,
    0x0254,0x0186, 0x0256,0x0189, 0x0257,0x018A, 0x0259,0x018F,
    0x025B,0x0190, 0x025C,0xA7AB, 0x0260,0x0193, 0x0261,0xA7AC,
    0x0263,0x0194, 0x0264,0xA7CB, 0x0265,0xA78D, 0x0266,0xA7AA,
    0x0268,0x0197, 0x0269,0x0196, 0x026A,0xA7AE, 0x026B,0x2C62,
    0x026C,0xA7AD, 0x026F,0x019C, 0x0271,0x2C6E, 0x0272,0x019D,
    0x0275,0x019F, 0x027D,0x2C64, 0x0280,0x01A6, 0x0282,0xA7C5,
    0x0283,0x01A9, 0x0287,0xA7B1, 0x0288,0x01AE, 0x0289,0x0244,
    0x028A,0x01B1, 0x028B,0x01B2, 0x028C,0x0245, 0x0292,0x01B7,
    0x029D,0xA7B2, 0x029E,0xA7B0, 0x0345,0x0399, 0x0371,0x0370,
    0x0373,0x0372, 0x0377,0x0376, 0x037B,0x03FD, 0x037C,0x03FE,
    0x037D,0x03FF, 0x03AC,0x0386, 0x03AD,0x0388, 0x03AE,0x0389,
    0x03AF,0x038A, 0x03B1,0x0391, 0x03B2,0x0392, 0x03B3,0x0393,
    0x03B4,0x0394, 0x03B5,0x0395, 0x03B6,0x0396, 0x03B7,0x0397,
    0x03B8,0x0398, 0x03B9,0x0399, 0x03BA,0x039A, 0x03BB,0x039B,
    0x03BC,0x039C, 0x03BD,0x039D, 0x03BE,0x039E, 0x03BF,0x039F,
    0x03C0,0x03A0, 0x03C1,0x03A1, 0x03C2,0x03A3, 0x03C3,0x03A3,
    0x03C4,0x03A4, 0x03C5,0x03A5, 0x03C6,0x03A6, 0x03C7,0x03A7,
    0x03C8,0x03A8, 0x03C9,0x03A9, 0x03CA,0x03AA, 0x03CB,0x03AB,
    0x03CC,0x038C, 0x03CD,0x038E, 0x03CE,0x038F, 0x03D0,0x0392,
    0x03D1,0x0398, 0x03D5,0x03A6, 0x03D6,0x03A0, 0x03D7,0x03CF,
    0x03D9,0x03D8, 0x03DB,0x03DA, 0x03DD,0x03DC, 0x03DF,0x03DE,
    0x03E1,0x03E0, 0x03E3,0x03E2, 0x03E5,0x03E4, 0x03E7,0x03E6,
    0x03E9,0x03E8, 0x03EB,0x03EA, 0x03ED,0x03EC, 0x03EF,0x03EE,
    0x03F0,0x039A, 0x03F1,0x03A1, 0x03F2,0x03F9, 0x03F3,0x037F,
    0x03F5,0x0395, 0x03F8,0x03F7, 0x03FB,0x03FA, 0x0430,0x0410,
    0x0431,0x0411, 0x0432,0x0412, 0x0433,0x0413, 0x0434,0x0414,
    0x0435,0x0415, 0x0436,0x0416, 0x0437,0x0417, 0x0438,0x0418,
    0x0439,0x0419, 0x043A,0x041A, 0x043B,0x041B, 0x043C,0x041C,
    0x043D,0x041D, 0x043E,0x041E, 0x043F,0x041F, 0x0440,0x0420,
    0x0441,0x0421, 0x0442,0x0422, 0x0443,0x0423, 0x0444,0x0424,
    0x0445,0x0425, 0x0446,0x0426, 0x0447,0x0427, 0x0448,0x0428,
    0x0449,0x0429, 0x044A,0x042A, 0x044B,0x042B, 0x044C,0x042C,
    0x044D,0x042D, 0x044E,0x042E, 0x044F,0x042F, 0x0450,0x0400,
    0x0451,0x0401, 0x0452,0x0402, 0x0453,0x0403, 0x0454,0x0404,
    0x0455,0x0405, 0x0456,0x0406, 0x0457,0x0407, 0x0458,0x0408,
    0x0459,0x0409, 0x045A,0x040A, 0x045B,0x040B, 0x045C,0x040C,
    0x045D,0x040D, 0x045E,0x040E, 0x045F,0x040F, 0x0461,0x0460,
    0x0463,0x0462, 0x0465,0x0464, 0x0467,0x0466, 0x0469,0x0468,
    0x046B,0x046A, 0x046D,0x046C, 0x046F,0x046E, 0x0471,0x0470,
    0x0473,0x0472, 0x0475,0x0474, 0x0477,0x0476, 0x0479,0x0478,
    0x047B,0x047A, 0x047D,0x047C, 0x047F,0x047E, 0x0481,0x0480,
    0x048B,0x048A, 0x048D,0x048C, 0x048F,0x048E, 0x0491,0x0490,
    0x0493,0x0492, 0x0495,0x0494, 0x0497,0x0496, 0x0499,0x0498,
    0x049B,0x049A, 0x049D,0x049C, 0x049F,0x049E, 0x04A1,0x04A0,
    0x04A3,0x04A2, 0x04A5,0x04A4, 0x04A7,0x04A6, 0x04A9,0x04A8,
    0x04AB,0x04AA, 0x04AD,0x04AC, 0x04AF,0x04AE, 0x04B1,0x04B0,
    0x04B3,0x04B2, 0x04B5,0x04B4, 0x04B7,0x04B6, 0x04B9,0x04B8,
    0x04BB,0x04BA, 0x04BD,0x04BC, 0x04BF,0x04BE, 0x04C2,0x04C1,
    0x04C4,0x04C3, 0x04C6,0x04C5, 0x04C8,0x04C7, 0x04CA,0x04C9,
    0x04CC,0x04CB, 0x04CE,0x04CD, 0x04CF,0x04C0, 0x04D1,0x04D0,
    0x04D3,0x04D2, 0x04D5,0x04D4, 0x04D7,0x04D6, 0x04D9,0x04D8,
    0x04DB,0x04DA, 0x04DD,0x04DC, 0x04DF,0x04DE, 0x04E1,0x04E0,
    0x04E3,0x04E2, 0x04E5,0x04E4, 0x04E7,0x04E6, 0x04E9,0x04E8,
    0x04EB,0x04EA, 0x04ED,0x04EC, 0x04EF,0x04EE, 0x04F1,0x04F0,
    0x04F3,0x04F2, 0x04F5,0x04F4, 0x04F7,0x04F6, 0x04F9,0x04F8,
    0x04FB,0x04FA, 0x04FD,0x04FC, 0x04FF,0x04FE, 0x0501,0x0500,
    0x0503,0x0502, 0x0505,0x0504, 0x0507,0x0506, 0x0509,0x0508,
    0x050B,0x050A, 0x050D,0x050C, 0x050F,0x050E, 0x0511,0x0510,
    0x0513,0x0512, 0x0515,0x0514, 0x0517,0x0516, 0x0519,0x0518,
    0x051B,0x051A, 0x051D,0x051C, 0x051F,0x051E, 0x0521,0x0520,
    0x0523,0x0522, 0x0525,0x0524, 0x0527,0x0526, 0x0529,0x0528,
    0x052B,0x052A, 0x052D,0x052C, 0x052F,0x052E, 0x0561,0x0531,
    0x0562,0x0532, 0x0563,0x0533, 0x0564,0x0534, 0x0565,0x0535,
    0x0566,0x0536, 0x0567,0x0537, 0x0568,0x0538, 0x0569,0x0539,
    0x056A,0x053A, 0x056B,0x053B, 0x056C,0x053C, 0x056D,0x053D,
    0x056E,0x053E, 0x056F,0x053F, 0x0570,0x0540, 0x0571,0x0541,
    0x0572,0x0542, 0x0573,0x0543, 0x0574,0x0544, 0x0575,0x0545,
    0x0576,0x0546, 0x0577,0x0547, 0x0578,0x0548, 0x0579,0x0549,
    0x057A,0x054A, 0x057B,0x054B, 0x057C,0x054C, 0x057D,0x054D,
    0x057E,0x054E, 0x057F,0x054F, 0x0580,0x0550, 0x0581,0x0551,
    0x0582,0x0552, 0x0583,0x0553, 0x0584,0x0554, 0x0585,0x0555,
    0x0586,0x0556, 0x10D0,0x1C90, 0x10D1,0x1C91, 0x10D2,0x1C92,
    0x10D3,0x1C93, 0x10D4,0x1C94, 0x10D5,0x1C95, 0x10D6,0x1C96,
    0x10D7,0x1C97, 0x10D8,0x1C98, 0x10D9,0x1C99, 0x10DA,0x1C9A,
    0x10DB,0x1C9B, 0x10DC,0x1C9C, 0x10DD,0x1C9D, 0x10DE,0x1C9E,
    0x10DF,0x1C9F, 0x10E0,0x1CA0, 0x10E1,0x1CA1, 0x10E2,0x1CA2,
    0x10E3,0x1CA3, 0x10E4,0x1CA4, 0x10E5,0x1CA5, 0x10E6,0x1CA6,
    0x10E7,0x1CA7, 0x10E8,0x1CA8, 0x10E9,0x1CA9, 0x10EA,0x1CAA,
    0x10EB,0x1CAB, 0x10EC,0x1CAC, 0x10ED,0x1CAD, 0x10EE,0x1CAE,
    0x10EF,0x1CAF, 0x10F0,0x1CB0, 0x10F1,0x1CB1, 0x10F2,0x1CB2,
    0x10F3,0x1CB3, 0x10F4,0x1CB4, 0x10F5,0x1CB5, 0x10F6,0x1CB6,
    0x10F7,0x1CB7, 0x10F8,0x1CB8, 0x10F9,0x1CB9, 0x10FA,0x1CBA,
    0x10FD,0x1CBD, 0x10FE,0x1CBE, 0x10FF,0x1CBF, 0x13F8,0x13F0,
    0x13F9,0x13F1, 0x13FA,0x13F2, 0x13FB,0x13F3, 0x13FC,0x13F4,
    0x13FD,0x13F5, 0x1C80,0x0412, 0x1C81,0x0414, 0x1C82,0x041E,
    0x1C83,0x0421, 0x1C84,0x0422, 0x1C85,0x0422, 0x1C86,0x042A,
    0x1C87,0x0462, 0x1C88,0xA64A, 0x1C8A,0x1C89, 0x1D79,0xA77D,
    0x1D7D,0x2C63, 0x1D8E,0xA7C6, 0x1E01,0x1E00, 0x1E03,0x1E02,
    0x1E05,0x1E04, 0x1E07,0x1E06, 0x1E09,0x1E08, 0x1E0B,0x1E0A,
    0x1E0D,0x1E0C, 0x1E0F,0x1E0E, 0x1E11,0x1E10, 0x1E13,0x1E12,
    0x1E15,0x1E14, 0x1E17,0x1E16, 0x1E19,0x1E18, 0x1E1B,0x1E1A,
    0x1E1D,0x1E1C, 0x1E1F,0x1E1E, 0x1E21,0x1E20, 0x1E23,0x1E22,
    0x1E25,0x1E24, 0x1E27,0x1E26, 0x1E29,0x1E28, 0x1E2B,0x1E2A,
    0x1E2D,0x1E2C, 0x1E2F,0x1E2E, 0x1E31,0x1E30, 0x1E33,0x1E32,
    0x1E35,0x1E34, 0x1E37,0x1E36, 0x1E39,0x1E38, 0x1E3B,0x1E3A,
    0x1E3D,0x1E3C, 0x1E3F,0x1E3E, 0x1E41,0x1E40, 0x1E43,0x1E42,
    0x1E45,0x1E44, 0x1E47,0x1E46, 0x1E49,0x1E48, 0x1E4B,0x1E4A,
    0x1E4D,0x1E4C, 0x1E4F,0x1E4E, 0x1E51,0x1E50, 0x1E53,0x1E52,
    0x1E55,0x1E54, 0x1E57,0x1E56, 0x1E59,0x1E58, 0x1E5B,0x1E5A,
    0x1E5D,0x1E5C, 0x1E5F,0x1E5E, 0x1E61,0x1E60, 0x1E63,0x1E62,
    0x1E65,0x1E64, 0x1E67,0x1E66, 0x1E69,0x1E68, 0x1E6B,0x1E6A,
    0x1E6D,0x1E6C, 0x1E6F,0x1E6E, 0x1E71,0x1E70, 0x1E73,0x1E72,
    0x1E75,0x1E74, 0x1E77,0x1E76, 0x1E79,0x1E78, 0x1E7B,0x1E7A,
    0x1E7D,0x1E7C, 0x1E7F,0x1E7E, 0x1E81,0x1E80, 0x1E83,0x1E82,
    0x1E85,0x1E84, 0x1E87,0x1E86, 0x1E89,0x1E88, 0x1E8B,0x1E8A,
    0x1E8D,0x1E8C, 0x1E8F,0x1E8E, 0x1E91,0x1E90, 0x1E93,0x1E92,
    0x1E95,0x1E94, 0x1E9B,0x1E60, 0x1EA1,0x1EA0, 0x1EA3,0x1EA2,
    0x1EA5,0x1EA4, 0x1EA7,0x1EA6, 0x1EA9,0x1EA8, 0x1EAB,0x1EAA,
    0x1EAD,0x1EAC, 0x1EAF,0x1EAE, 0x1EB1,0x1EB0, 0x1EB3,0x1EB2,
    0x1EB5,0x1EB4, 0x1EB7,0x1EB6, 0x1EB9,0x1EB8, 0x1EBB,0x1EBA,
    0x1EBD,0x1EBC, 0x1EBF,0x1EBE, 0x1EC1,0x1EC0, 0x1EC3,0x1EC2,
    0x1EC5,0x1EC4, 0x1EC7,0x1EC6, 0x1EC9,0x1EC8, 0x1ECB,0x1ECA,
    0x1ECD,0x1ECC, 0x1ECF,0x1ECE, 0x1ED1,0x1ED0, 0x1ED3,0x1ED2,
    0x1ED5,0x1ED4, 0x1ED7,0x1ED6, 0x1ED9,0x1ED8, 0x1EDB,0x1EDA,
    0x1EDD,0x1EDC, 0x1EDF,0x1EDE, 0x1EE1,0x1EE0, 0x1EE3,0x1EE2,
    0x1EE5,0x1EE4, 0x1EE7,0x1EE6, 0x1EE9,0x1EE8, 0x1EEB,0x1EEA,
    0x1EED,0x1EEC, 0x1EEF,0x1EEE, 0x1EF1,0x1EF0, 0x1EF3,0x1EF2,
    0x1EF5,0x1EF4, 0x1EF7,0x1EF6, 0x1EF9,0x1EF8, 0x1EFB,0x1EFA,
    0x1EFD,0x1EFC, 0x1EFF,0x1EFE, 0x1F00,0x1F08, 0x1F01,0x1F09,
    0x1F02,0x1F0A, 0x1F03,0x1F0B, 0x1F04,0x1F0C, 0x1F05,0x1F0D,
    0x1F06,0x1F0E, 0x1F07,0x1F0F, 0x1F10,0x1F18, 0x1F11,0x1F19,
    0x1F12,0x1F1A, 0x1F13,0x1F1B, 0x1F14,0x1F1C, 0x1F15,0x1F1D,
    0x1F20,0x1F28, 0x1F21,0x1F29, 0x1F22,0x1F2A, 0x1F23,0x1F2B,
    0x1F24,0x1F2C, 0x1F25,0x1F2D, 0x1F26,0x1F2E, 0x1F27,0x1F2F,
    0x1F30,0x1F38, 0x1F31,0x1F39, 0x1F32,0x1F3A, 0x1F33,0x1F3B,
    0x1F34,0x1F3C, 0x1F35,0x1F3D, 0x1F36,0x1F3E, 0x1F37,0x1F3F,
    0x1F40,0x1F48, 0x1F41,0x1F49, 0x1F42,0x1F4A, 0x1F43,0x1F4B,
    0x1F44,0x1F4C, 0x1F45,0x1F4D, 0x1F51,0x1F59, 0x1F53,0x1F5B,
    0x1F55,0x1F5D, 0x1F57,0x1F5F, 0x1F60,0x1F68, 0x1F61,0x1F69,
    0x1F62,0x1F6A, 0x1F63,0x1F6B, 0x1F64,0x1F6C, 0x1F65,0x1F6D,
    0x1F66,0x1F6E, 0x1F67,0x1F6F, 0x1F70,0x1FBA, 0x1F71,0x1FBB,
    0x1F72,0x1FC8, 0x1F73,0x1FC9, 0x1F74,0x1FCA, 0x1F75,0x1FCB,
    0x1F76,0x1FDA, 0x1F77,0x1FDB, 0x1F78,0x1FF8, 0x1F79,0x1FF9,
    0x1F7A,0x1FEA, 0x1F7B,0x1FEB, 0x1F7C,0x1FFA, 0x1F7D,0x1FFB,
    0x1FB0,0x1FB8, 0x1FB1,0x1FB9, 0x1FBE,0x0399, 0x1FD0,0x1FD8,
    0x1FD1,0x1FD9, 0x1FE0,0x1FE8, 0x1FE1,0x1FE9, 0x1FE5,0x1FEC,
    0x214E,0x2132, 0x2170,0x2160, 0x2171,0x2161, 0x2172,0x2162,
    0x2173,0x2163, 0x2174,0x2164, 0x2175,0x2165, 0x2176,0x2166,
    0x2177,0x2167, 0x2178,0x2168, 0x2179,0x2169, 0x217A,0x216A,
    0x217B,0x216B, 0x217C,0x216C, 0x217D,0x216D, 0x217E,0x216E,
    0x217F,0x216F, 0x2184,0x2183, 0x24D0,0x24B6, 0x24D1,0x24B7,
    0x24D2,0x24B8, 0x24D3,0x24B9, 0x24D4,0x24BA, 0x24D5,0x24BB,
    0x24D6,0x24BC, 0x24D7,0x24BD, 0x24D8,0x24BE, 0x24D9,0x24BF,
    0x24DA,0x24C0, 0x24DB,0x24C1, 0x24DC,0x24C2, 0x24DD,0x24C3,
    0x24DE,0x24C4, 0x24DF,0x24C5, 0x24E0,0x24C6, 0x24E1,0x24C7,
    0x24E2,0x24C8, 0x24E3,0x24C9, 0x24E4,0x24CA, 0x24E5,0x24CB,
    0x24E6,0x24CC, 0x24E7,0x24CD, 0x24E8,0x24CE, 0x24E9,0x24CF,
    0x2C30,0x2C00, 0x2C31,0x2C01, 0x2C32,0x2C02, 0x2C33,0x2C03,
    0x2C34,0x2C04, 0x2C35,0x2C05, 0x2C36,0x2C06, 0x2C37,0x2C07,
    0x2C38,0x2C08, 0x2C39,0x2C09, 0x2C3A,0x2C0A, 0x2C3B,0x2C0B,
    0x2C3C,0x2C0C, 0x2C3D,0x2C0D, 0x2C3E,0x2C0E, 0x2C3F,0x2C0F,
    0x2C40,0x2C10, 0x2C41,0x2C11, 0x2C42,0x2C12, 0x2C43,0x2C13,
    0x2C44,0x2C14, 0x2C45,0x2C15, 0x2C46,0x2C16, 0x2C47,0x2C17,
    0x2C48,0x2C18, 0x2C49,0x2C19, 0x2C4A,0x2C1A, 0x2C4B,0x2C1B,
    0x2C4C,0x2C1C, 0x2C4D,0x2C1D, 0x2C4E,0x2C1E, 0x2C4F,0x2C1F,
    0x2C50,0x2C20, 0x2C51,0x2C21, 0x2C52,0x2C22, 0x2C53,0x2C23,
    0x2C54,0x2C24, 0x2C55,0x2C25, 0x2C56,0x2C26, 0x2C57,0x2C27,
    0x2C58,0x2C28, 0x2C59,0x2C29, 0x2C5A,0x2C2A, 0x2C5B,0x2C2B,
    0x2C5C,0x2C2C, 0x2C5D,0x2C2D, 0x2C5E,0x2C2E, 0x2C5F,0x2C2F,
    0x2C61,0x2C60, 0x2C65,0x023A, 0x2C66,0x023E, 0x2C68,0x2C67,
    0x2C6A,0x2C69, 0x2C6C,0x2C6B, 0x2C73,0x2C72, 0x2C76,0x2C75,
    0x2C81,0x2C80, 0x2C83,0x2C82, 0x2C85,0x2C84, 0x2C87,0x2C86,
    0x2C89,0x2C88, 0x2C8B,0x2C8A, 0x2C8D,0x2C8C, 0x2C8F,0x2C8E,
    0x2C91,0x2C90, 0x2C93,0x2C92, 0x2C95,0x2C94, 0x2C97,0x2C96,
    0x2C99,0x2C98, 0x2C9B,0x2C9A, 0x2C9D,0x2C9C, 0x2C9F,0x2C9E,
    0x2CA1,0x2CA0, 0x2CA3,0x2CA2, 0x2CA5,0x2CA4, 0x2CA7,0x2CA6,
    0x2CA9,0x2CA8, 0x2CAB,0x2CAA, 0x2CAD,0x2CAC, 0x2CAF,0x2CAE,
    0x2CB1,0x2CB0, 0x2CB3,0x2CB2, 0x2CB5,0x2CB4, 0x2CB7,0x2CB6,
    0x2CB9,0x2CB8, 0x2CBB,0x2CBA, 0x2CBD,0x2CBC, 0x2CBF,0x2CBE,
    0x2CC1,0x2CC0, 0x2CC3,0x2CC2, 0x2CC5,0x2CC4, 0x2CC7,0x2CC6,
    0x2CC9,0x2CC8, 0x2CCB,0x2CCA, 0x2CCD,0x2CCC, 0x2CCF,0x2CCE,
    0x2CD1,0x2CD0, 0x2CD3,0x2CD2, 0x2CD5,0x2CD4, 0x2CD7,0x2CD6,
    0x2CD9,0x2CD8, 0x2CDB,0x2CDA, 0x2CDD,0x2CDC, 0x2CDF,0x2CDE,
    0x2CE1,0x2CE0, 0x2CE3,0x2CE2, 0x2CEC,0x2CEB, 0x2CEE,0x2CED,
    0x2CF3,0x2CF2, 0x2D00,0x10A0, 0x2D01,0x10A1, 0x2D02,0x10A2,
    0x2D03,0x10A3, 0x2D04,0x10A4, 0x2D05,0x10A5, 0x2D06,0x10A6,
    0x2D07,0x10A7, 0x2D08,0x10A8, 0x2D09,0x10A9, 0x2D0A,0x10AA,
    0x2D0B,0x10AB, 0x2D0C,0x10AC, 0x2D0D,0x10AD, 0x2D0E,0x10AE,
    0x2D0F,0x10AF, 0x2D10,0x10B0, 0x2D11,0x10B1, 0x2D12,0x10B2,
    0x2D13,0x10B3, 0x2D14,0x10B4, 0x2D15,0x10B5, 0x2D16,0x10B6,
    0x2D17,0x10B7, 0x2D18,0x10B8, 0x2D19,0x10B9, 0x2D1A,0x10BA,
    0x2D1B,0x10BB, 0x2D1C,0x10BC, 0x2D1D,0x10BD, 0x2D1E,0x10BE,
    0x2D1F,0x10BF, 0x2D20,0x10C0, 0x2D21,0x10C1, 0x2D22,0x10C2,
    0x2D23,0x10C3, 0x2D24,0x10C4, 0x2D25,0x10C5, 0x2D27,0x10C7,
    0x2D2D,0x10CD, 0xA641,0xA640, 0xA643,0xA642, 0xA645,0xA644,
    0xA647,0xA646, 0xA649,0xA648, 0xA64B,0xA64A, 0xA64D,0xA64C,
    0xA64F,0xA64E, 0xA651,0xA650, 0xA653,0xA652, 0xA655,0xA654,
    0xA657,0xA656, 0xA659,0xA658, 0xA65B,0xA65A, 0xA65D,0xA65C,
    0xA65F,0xA65E, 0xA661,0xA660, 0xA663,0xA662, 0xA665,0xA664,
    0xA667,0xA666, 0xA669,0xA668, 0xA66B,0xA66A, 0xA66D,0xA66C,
    0xA681,0xA680, 0xA683,0xA682, 0xA685,0xA684, 0xA687,0xA686,
    0xA689,0xA688, 0xA68B,0xA68A, 0xA68D,0xA68C, 0xA68F,0xA68E,
    0xA691,0xA690, 0xA693,0xA692, 0xA695,0xA694, 0xA697,0xA696,
    0xA699,0xA698, 0xA69B,0xA69A, 0xA723,0xA722, 0xA725,0xA724,
    0xA727,0xA726, 0xA729,0xA728, 0xA72B,0xA72A, 0xA72D,0xA72C,
    0xA72F,0xA72E, 0xA733,0xA732, 0xA735,0xA734, 0xA737,0xA736,
    0xA739,0xA738, 0xA73B,0xA73A, 0xA73D,0xA73C, 0xA73F,0xA73E,
    0xA741,0xA740, 0xA743,0xA742, 0xA745,0xA744, 0xA747,0xA746,
    0xA749,0xA748, 0xA74B,0xA74A, 0xA74D,0xA74C, 0xA74F,0xA74E,
    0xA751,0xA750, 0xA753,0xA752, 0xA755,0xA754, 0xA757,0xA756,
    0xA759,0xA758, 0xA75B,0xA75A, 0xA75D,0xA75C, 0xA75F,0xA75E,
    0xA761,0xA760, 0xA763,0xA762, 0xA765,0xA764, 0xA767,0xA766,
    0xA769,0xA768, 0xA76B,0xA76A, 0xA76D,0xA76C, 0xA76F,0xA76E,
    0xA77A,0xA779, 0xA77C,0xA77B, 0xA77F,0xA77E, 0xA781,0xA780,
    0xA783,0xA782, 0xA785,0xA784, 0xA787,0xA786, 0xA78C,0xA78B,
    0xA791,0xA790, 0xA793,0xA792, 0xA794,0xA7C4, 0xA797,0xA796,
    0xA799,0xA798, 0xA79B,0xA79A, 0xA79D,0xA79C, 0xA79F,0xA79E,
    0xA7A1,0xA7A0, 0xA7A3,0xA7A2, 0xA7A5,0xA7A4, 0xA7A7,0xA7A6,
    0xA7A9,0xA7A8, 0xA7B5,0xA7B4, 0xA7B7,0xA7B6, 0xA7B9,0xA7B8,
    0xA7BB,0xA7BA, 0xA7BD,0xA7BC, 0xA7BF,0xA7BE, 0xA7C1,0xA7C0,
    0xA7C3,0xA7C2, 0xA7C8,0xA7C7, 0xA7CA,0xA7C9, 0xA7CD,0xA7CC,
    0xA7D1,0xA7D0, 0xA7D7,0xA7D6, 0xA7D9,0xA7D8, 0xA7DB,0xA7DA,
    0xA7F6,0xA7F5, 0xAB53,0xA7B3, 0xAB70,0x13A0, 0xAB71,0x13A1,
    0xAB72,0x13A2, 0xAB73,0x13A3, 0xAB74,0x13A4, 0xAB75,0x13A5,
    0xAB76,0x13A6, 0xAB77,0x13A7, 0xAB78,0x13A8, 0xAB79,0x13A9,
    0xAB7A,0x13AA, 0xAB7B,0x13AB, 0xAB7C,0x13AC, 0xAB7D,0x13AD,
    0xAB7E,0x13AE, 0xAB7F,0x13AF, 0xAB80,0x13B0, 0xAB81,0x13B1,
    0xAB82,0x13B2, 0xAB83,0x13B3, 0xAB84,0x13B4, 0xAB85,0x13B5,
    0xAB86,0x13B6, 0xAB87,0x13B7, 0xAB88,0x13B8, 0xAB89,0x13B9,
    0xAB8A,0x13BA, 0xAB8B,0x13BB, 0xAB8C,0x13BC, 0xAB8D,0x13BD,
    0xAB8E,0x13BE, 0xAB8F,0x13BF, 0xAB90,0x13C0, 0xAB91,0x13C1,
    0xAB92,0x13C2, 0xAB93,0x13C3, 0xAB94,0x13C4, 0xAB95,0x13C5,
    0xAB96,0x13C6, 0xAB97,0x13C7, 0xAB98,0x13C8, 0xAB99,0x13C9,
    0xAB9A,0x13CA, 0xAB9B,0x13CB, 0xAB9C,0x13CC, 0xAB9D,0x13CD,
    0xAB9E,0x13CE, 0xAB9F,0x13CF, 0xABA0,0x13D0, 0xABA1,0x13D1,
    0xABA2,0x13D2, 0xABA3,0x13D3, 0xABA4,0x13D4, 0xABA5,0x13D5,
    0xABA6,0x13D6, 0xABA7,0x13D7, 0xABA8,0x13D8, 0xABA9,0x13D9,
    0xABAA,0x13DA, 0xABAB,0x13DB, 0xABAC,0x13DC, 0xABAD,0x13DD,
    0xABAE,0x13DE, 0xABAF,0x13DF, 0xABB0,0x13E0, 0xABB1,0x13E1,
    0xABB2,0x13E2, 0xABB3,0x13E3, 0xABB4,0x13E4, 0xABB5,0x13E5,
    0xABB6,0x13E6, 0xABB7,0x13E7, 0xABB8,0x13E8, 0xABB9,0x13E9,
    0xABBA,0x13EA, 0xABBB,0x13EB, 0xABBC,0x13EC, 0xABBD,0x13ED,
    0xABBE,0x13EE, 0xABBF,0x13EF, 0xFF41,0xFF21, 0xFF42,0xFF22,
    0xFF43,0xFF23, 0xFF44,0xFF24, 0xFF45,0xFF25, 0xFF46,0xFF26,
    0xFF47,0xFF27, 0xFF48,0xFF28, 0xFF49,0xFF29, 0xFF4A,0xFF2A,
    0xFF4B,0xFF2B, 0xFF4C,0xFF2C, 0xFF4D,0xFF2D, 0xFF4E,0xFF2E,
    0xFF4F,0xFF2F, 0xFF50,0xFF30, 0xFF51,0xFF31, 0xFF52,0xFF32,
    0xFF53,0xFF33, 0xFF54,0xFF34, 0xFF55,0xFF35, 0xFF56,0xFF36,
    0xFF57,0xFF37, 0xFF58,0xFF38, 0xFF59,0xFF39, 0xFF5A,0xFF3A,
    0x10428,0x10400, 0x10429,0x10401, 0x1042A,0x10402, 0x1042B,0x10403,
    0x1042C,0x10404, 0x1042D,0x10405, 0x1042E,0x10406, 0x1042F,0x10407,
    0x10430,0x10408, 0x10431,0x10409, 0x10432,0x1040A, 0x10433,0x1040B,
    0x10434,0x1040C, 0x10435,0x1040D, 0x10436,0x1040E, 0x10437,0x1040F,
    0x10438,0x10410, 0x10439,0x10411, 0x1043A,0x10412, 0x1043B,0x10413,
    0x1043C,0x10414, 0x1043D,0x10415, 0x1043E,0x10416, 0x1043F,0x10417,
    0x10440,0x10418, 0x10441,0x10419, 0x10442,0x1041A, 0x10443,0x1041B,
    0x10444,0x1041C, 0x10445,0x1041D, 0x10446,0x1041E, 0x10447,0x1041F,
    0x10448,0x10420, 0x10449,0x10421, 0x1044A,0x10422, 0x1044B,0x10423,
    0x1044C,0x10424, 0x1044D,0x10425, 0x1044E,0x10426, 0x1044F,0x10427,
    0x104D8,0x104B0, 0x104D9,0x104B1, 0x104DA,0x104B2, 0x104DB,0x104B3,
    0x104DC,0x104B4, 0x104DD,0x104B5, 0x104DE,0x104B6, 0x104DF,0x104B7,
    0x104E0,0x104B8, 0x104E1,0x104B9, 0x104E2,0x104BA, 0x104E3,0x104BB,
    0x104E4,0x104BC, 0x104E5,0x104BD, 0x104E6,0x104BE, 0x104E7,0x104BF,
    0x104E8,0x104C0, 0x104E9,0x104C1, 0x104EA,0x104C2, 0x104EB,0x104C3,
    0x104EC,0x104C4, 0x104ED,0x104C5, 0x104EE,0x104C6, 0x104EF,0x104C7,
    0x104F0,0x104C8, 0x104F1,0x104C9, 0x104F2,0x104CA, 0x104F3,0x104CB,
    0x104F4,0x104CC, 0x104F5,0x104CD, 0x104F6,0x104CE, 0x104F7,0x104CF,
    0x104F8,0x104D0, 0x104F9,0x104D1, 0x104FA,0x104D2, 0x104FB,0x104D3,
    0x10597,0x10570, 0x10598,0x10571, 0x10599,0x10572, 0x1059A,0x10573,
    0x1059B,0x10574, 0x1059C,0x10575, 0x1059D,0x10576, 0x1059E,0x10577,
    0x1059F,0x10578, 0x105A0,0x10579, 0x105A1,0x1057A, 0x105A3,0x1057C,
    0x105A4,0x1057D, 0x105A5,0x1057E, 0x105A6,0x1057F, 0x105A7,0x10580,
    0x105A8,0x10581, 0x105A9,0x10582, 0x105AA,0x10583, 0x105AB,0x10584,
    0x105AC,0x10585, 0x105AD,0x10586, 0x105AE,0x10587, 0x105AF,0x10588,
    0x105B0,0x10589, 0x105B1,0x1058A, 0x105B3,0x1058C, 0x105B4,0x1058D,
    0x105B5,0x1058E, 0x105B6,0x1058F, 0x105B7,0x10590, 0x105B8,0x10591,
    0x105B9,0x10592, 0x105BB,0x10594, 0x105BC,0x10595, 0x10CC0,0x10C80,
    0x10CC1,0x10C81, 0x10CC2,0x10C82, 0x10CC3,0x10C83, 0x10CC4,0x10C84,
    0x10CC5,0x10C85, 0x10CC6,0x10C86, 0x10CC7,0x10C87, 0x10CC8,0x10C88,
    0x10CC9,0x10C89, 0x10CCA,0x10C8A, 0x10CCB,0x10C8B, 0x10CCC,0x10C8C,
    0x10CCD,0x10C8D, 0x10CCE,0x10C8E, 0x10CCF,0x10C8F, 0x10CD0,0x10C90,
    0x10CD1,0x10C91, 0x10CD2,0x10C92, 0x10CD3,0x10C93, 0x10CD4,0x10C94,
    0x10CD5,0x10C95, 0x10CD6,0x10C96, 0x10CD7,0x10C97, 0x10CD8,0x10C98,
    0x10CD9,0x10C99, 0x10CDA,0x10C9A, 0x10CDB,0x10C9B, 0x10CDC,0x10C9C,
    0x10CDD,0x10C9D, 0x10CDE,0x10C9E, 0x10CDF,0x10C9F, 0x10CE0,0x10CA0,
    0x10CE1,0x10CA1, 0x10CE2,0x10CA2, 0x10CE3,0x10CA3, 0x10CE4,0x10CA4,
    0x10CE5,0x10CA5, 0x10CE6,0x10CA6, 0x10CE7,0x10CA7, 0x10CE8,0x10CA8,
    0x10CE9,0x10CA9, 0x10CEA,0x10CAA, 0x10CEB,0x10CAB, 0x10CEC,0x10CAC,
    0x10CED,0x10CAD, 0x10CEE,0x10CAE, 0x10CEF,0x10CAF, 0x10CF0,0x10CB0,
    0x10CF1,0x10CB1, 0x10CF2,0x10CB2, 0x10D70,0x10D50, 0x10D71,0x10D51,
    0x10D72,0x10D52, 0x10D73,0x10D53, 0x10D74,0x10D54, 0x10D75,0x10D55,
    0x10D76,0x10D56, 0x10D77,0x10D57, 0x10D78,0x10D58, 0x10D79,0x10D59,
    0x10D7A,0x10D5A, 0x10D7B,0x10D5B, 0x10D7C,0x10D5C, 0x10D7D,0x10D5D,
    0x10D7E,0x10D5E, 0x10D7F,0x10D5F, 0x10D80,0x10D60, 0x10D81,0x10D61,
    0x10D82,0x10D62, 0x10D83,0x10D63, 0x10D84,0x10D64, 0x10D85,0x10D65,
    0x118C0,0x118A0, 0x118C1,0x118A1, 0x118C2,0x118A2, 0x118C3,0x118A3,
    0x118C4,0x118A4, 0x118C5,0x118A5, 0x118C6,0x118A6, 0x118C7,0x118A7,
    0x118C8,0x118A8, 0x118C9,0x118A9, 0x118CA,0x118AA, 0x118CB,0x118AB,
    0x118CC,0x118AC, 0x118CD,0x118AD, 0x118CE,0x118AE, 0x118CF,0x118AF,
    0x118D0,0x118B0, 0x118D1,0x118B1, 0x118D2,0x118B2, 0x118D3,0x118B3,
    0x118D4,0x118B4, 0x118D5,0x118B5, 0x118D6,0x118B6, 0x118D7,0x118B7,
    0x118D8,0x118B8, 0x118D9,0x118B9, 0x118DA,0x118BA, 0x118DB,0x118BB,
    0x118DC,0x118BC, 0x118DD,0x118BD, 0x118DE,0x118BE, 0x118DF,0x118BF,
    0x16E60,0x16E40, 0x16E61,0x16E41, 0x16E62,0x16E42, 0x16E63,0x16E43,
    0x16E64,0x16E44, 0x16E65,0x16E45, 0x16E66,0x16E46, 0x16E67,0x16E47,
    0x16E68,0x16E48, 0x16E69,0x16E49, 0x16E6A,0x16E4A, 0x16E6B,0x16E4B,
    0x16E6C,0x16E4C, 0x16E6D,0x16E4D, 0x16E6E,0x16E4E, 0x16E6F,0x16E4F,
    0x16E70,0x16E50, 0x16E71,0x16E51, 0x16E72,0x16E52, 0x16E73,0x16E53,
    0x16E74,0x16E54, 0x16E75,0x16E55, 0x16E76,0x16E56, 0x16E77,0x16E57,
    0x16E78,0x16E58, 0x16E79,0x16E59, 0x16E7A,0x16E5A, 0x16E7B,0x16E5B,
    0x16E7C,0x16E5C, 0x16E7D,0x16E5D, 0x16E7E,0x16E5E, 0x16E7F,0x16E5F,
    0x1E922,0x1E900, 0x1E923,0x1E901, 0x1E924,0x1E902, 0x1E925,0x1E903,
    0x1E926,0x1E904, 0x1E927,0x1E905, 0x1E928,0x1E906, 0x1E929,0x1E907,
    0x1E92A,0x1E908, 0x1E92B,0x1E909, 0x1E92C,0x1E90A, 0x1E92D,0x1E90B,
    0x1E92E,0x1E90C, 0x1E92F,0x1E90D, 0x1E930,0x1E90E, 0x1E931,0x1E90F,
    0x1E932,0x1E910, 0x1E933,0x1E911, 0x1E934,0x1E912, 0x1E935,0x1E913,
    0x1E936,0x1E914, 0x1E937,0x1E915, 0x1E938,0x1E916, 0x1E939,0x1E917,
    0x1E93A,0x1E918, 0x1E93B,0x1E919, 0x1E93C,0x1E91A, 0x1E93D,0x1E91B,
    0x1E93E,0x1E91C, 0x1E93F,0x1E91D, 0x1E940,0x1E91E, 0x1E941,0x1E91F,
    0x1E942,0x1E920, 0x1E943,0x1E921,
};
#define CASE_TO_UPPER_N 1450  /* pairs */

static const struct { uint32_t cp; const char* up; } SPECIAL_UPPER[] = {
    {0x00DF, "\x53""\x53"},
    {0x0149, "\xCA""\xBC""\x4E"},
    {0x01F0, "\x4A""\xCC""\x8C"},
    {0x0390, "\xCE""\x99""\xCC""\x88""\xCC""\x81"},
    {0x03B0, "\xCE""\xA5""\xCC""\x88""\xCC""\x81"},
    {0x1E96, "\x48""\xCC""\xB1"},
    {0x1E97, "\x54""\xCC""\x88"},
    {0x1E98, "\x57""\xCC""\x8A"},
    {0x1E99, "\x59""\xCC""\x8A"},
    {0x1E9A, "\x41""\xCA""\xBE"},
    {0x1F80, "\xE1""\xBC""\x88""\xCE""\x99"},
    {0x1F81, "\xE1""\xBC""\x89""\xCE""\x99"},
    {0x1F82, "\xE1""\xBC""\x8A""\xCE""\x99"},
    {0x1F83, "\xE1""\xBC""\x8B""\xCE""\x99"},
    {0x1F84, "\xE1""\xBC""\x8C""\xCE""\x99"},
    {0x1F85, "\xE1""\xBC""\x8D""\xCE""\x99"},
    {0x1F86, "\xE1""\xBC""\x8E""\xCE""\x99"},
    {0x1F87, "\xE1""\xBC""\x8F""\xCE""\x99"},
    {0x1F88, "\xE1""\xBC""\x88""\xCE""\x99"},
    {0x1F89, "\xE1""\xBC""\x89""\xCE""\x99"},
    {0x1F8A, "\xE1""\xBC""\x8A""\xCE""\x99"},
    {0x1F8B, "\xE1""\xBC""\x8B""\xCE""\x99"},
    {0x1F8C, "\xE1""\xBC""\x8C""\xCE""\x99"},
    {0x1F8D, "\xE1""\xBC""\x8D""\xCE""\x99"},
    {0x1F8E, "\xE1""\xBC""\x8E""\xCE""\x99"},
    {0x1F8F, "\xE1""\xBC""\x8F""\xCE""\x99"},
    {0x1F90, "\xE1""\xBE""\x98""\xCE""\x99"},
    {0x1F91, "\xE1""\xBE""\x99""\xCE""\x99"},
    {0x1F92, "\xE1""\xBE""\x9A""\xCE""\x99"},
    {0x1F93, "\xE1""\xBE""\x9B""\xCE""\x99"},
    {0x1F94, "\xE1""\xBE""\x9C""\xCE""\x99"},
    {0x1F95, "\xE1""\xBE""\x9D""\xCE""\x99"},
    {0x1F96, "\xE1""\xBE""\x9E""\xCE""\x99"},
    {0x1F97, "\xE1""\xBE""\x9F""\xCE""\x99"},
    {0x1F98, "\xE1""\xBE""\x98""\xCE""\x99"},
    {0x1F99, "\xE1""\xBE""\x99""\xCE""\x99"},
    {0x1F9A, "\xE1""\xBE""\x9A""\xCE""\x99"},
    {0x1F9B, "\xE1""\xBE""\x9B""\xCE""\x99"},
    {0x1F9C, "\xE1""\xBE""\x9C""\xCE""\x99"},
    {0x1F9D, "\xE1""\xBE""\x9D""\xCE""\x99"},
    {0x1F9E, "\xE1""\xBE""\x9E""\xCE""\x99"},
    {0x1F9F, "\xE1""\xBE""\x9F""\xCE""\x99"},
    {0x1FA0, "\xE1""\xBE""\xA8""\xCE""\x99"},
    {0x1FA1, "\xE1""\xBE""\xA9""\xCE""\x99"},
    {0x1FA2, "\xE1""\xBE""\xAA""\xCE""\x99"},
    {0x1FA3, "\xE1""\xBE""\xAB""\xCE""\x99"},
    {0x1FA4, "\xE1""\xBE""\xAC""\xCE""\x99"},
    {0x1FA5, "\xE1""\xBE""\xAD""\xCE""\x99"},
    {0x1FA6, "\xE1""\xBE""\xAE""\xCE""\x99"},
    {0x1FA7, "\xE1""\xBE""\xAF""\xCE""\x99"},
    {0x1FA8, "\xE1""\xBE""\xA8""\xCE""\x99"},
    {0x1FA9, "\xE1""\xBE""\xA9""\xCE""\x99"},
    {0x1FAA, "\xE1""\xBE""\xAA""\xCE""\x99"},
    {0x1FAB, "\xE1""\xBE""\xAB""\xCE""\x99"},
    {0x1FAC, "\xE1""\xBE""\xAC""\xCE""\x99"},
    {0x1FAD, "\xE1""\xBE""\xAD""\xCE""\x99"},
    {0x1FAE, "\xE1""\xBE""\xAE""\xCE""\x99"},
    {0x1FAF, "\xE1""\xBE""\xAF""\xCE""\x99"},
    {0x1FB2, "\xE1""\xBE""\xBA""\xCD""\x85"},
    {0x1FB3, "\xCE""\x91""\xCD""\x85"},
    {0x1FB4, "\xCE""\x86""\xCD""\x85"},
    {0x1FB6, "\xCE""\x91""\xCD""\x82"},
    {0x1FB7, "\xCE""\x91""\xCD""\x82""\xCD""\x85"},
    {0x1FBC, "\xCE""\x91""\xCE""\x99"},
    {0x1FC2, "\xE1""\xBF""\x8A""\xCD""\x85"},
    {0x1FC3, "\xCE""\x97""\xCD""\x85"},
    {0x1FC4, "\xCE""\x89""\xCD""\x85"},
    {0x1FC6, "\xCE""\x97""\xCD""\x82"},
    {0x1FC7, "\xCE""\x97""\xCD""\x82""\xCD""\x85"},
    {0x1FCC, "\xCE""\x97""\xCE""\x99"},
    {0x1FF2, "\xE1""\xBF""\xBA""\xCD""\x85"},
    {0x1FF3, "\xCE""\xA9""\xCD""\x85"},
    {0x1FF4, "\xCE""\x8F""\xCD""\x85"},
    {0x1FF6, "\xCE""\xA9""\xCD""\x82"},
    {0x1FF7, "\xCE""\xA9""\xCD""\x82""\xCD""\x85"},
    {0x1FFC, "\xCE""\xA9""\xCE""\x99"},
    {0xFB00, "\x46""\x46"},
    {0xFB01, "\x46""\x49"},
    {0xFB02, "\x46""\x4C"},
    {0xFB03, "\x46""\x46""\x49"},
    {0xFB04, "\x46""\x46""\x4C"},
    {0xFB05, "\x53""\x54"},
    {0xFB06, "\x53""\x54"},
};
#define SPECIAL_UPPER_N 83
// END CASE TABLES



/* Encode a codepoint as UTF-8; returns bytes written. */
static int utf8_encode(char* out, uint32_t cp) {
    if (cp < 0x80) {
        out[0] = (char)cp;
        return 1;
    }
    if (cp < 0x800) {
        out[0] = (char)(0xC0 | (cp >> 6));
        out[1] = (char)(0x80 | (cp & 0x3F));
        return 2;
    }
    if (cp < 0x10000) {
        out[0] = (char)(0xE0 | (cp >> 12));
        out[1] = (char)(0x80 | ((cp >> 6) & 0x3F));
        out[2] = (char)(0x80 | (cp & 0x3F));
        return 3;
    }
    out[0] = (char)(0xF0 | (cp >> 18));
    out[1] = (char)(0x80 | ((cp >> 12) & 0x3F));
    out[2] = (char)(0x80 | ((cp >> 6) & 0x3F));
    out[3] = (char)(0x80 | (cp & 0x3F));
    return 4;
}

/* Binary search a generated (from,to) pair table; 0 when absent. */
static uint32_t case_map_lookup(const uint32_t* tab, int n, uint32_t cp) {
    int lo = 0, hi = n - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        uint32_t from = tab[mid * 2];
        if (cp == from) return tab[mid * 2 + 1];
        if (cp < from) hi = mid - 1; else lo = mid + 1;
    }
    return 0;
}

uint32_t resid_case_simple(uint32_t cp, int to_lower) {
    if (to_lower) {
        uint32_t m = case_map_lookup(CASE_TO_LOWER, CASE_TO_LOWER_N, cp);
        if (m != 0) return m;
    } else {
        uint32_t m = case_map_lookup(CASE_TO_UPPER, CASE_TO_UPPER_N, cp);
        if (m != 0) return m;
    }
    /* Generated tables cover ASCII/Latin/Greek/Cyrillic and every other
       simple pair; anything absent is caseless. */
    return cp;
}

/* SpecialCasing uppercase expansion for cp, or NULL. */
static const char* special_upper_lookup(uint32_t cp) {
    int lo = 0, hi = SPECIAL_UPPER_N - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (cp == SPECIAL_UPPER[mid].cp) return SPECIAL_UPPER[mid].up;
        if (cp < SPECIAL_UPPER[mid].cp) hi = mid - 1; else lo = mid + 1;
    }
    return 0;
}

/* A codepoint is "cased" when it has a case mapping in either direction
   (SpecialCasing.txt's Cased property, approximated from the tables).
   ASCII letters are covered by the tables; digits/punct/space are not. */
static int resid_case_is_cased(uint32_t cp) {
    if (case_map_lookup(CASE_TO_LOWER, CASE_TO_LOWER_N, cp) != 0) return 1;
    if (case_map_lookup(CASE_TO_UPPER, CASE_TO_UPPER_N, cp) != 0) return 1;
    uint32_t up = case_map_lookup(CASE_TO_LOWER, CASE_TO_LOWER_N,
                                  case_map_lookup(CASE_TO_UPPER, CASE_TO_UPPER_N, cp));
    (void)up;
    return 0;
}

/* Case-ignorable: not itself cased but must be skipped when scanning for
   the preceding/following cased character (approximation: combining marks
   in the common ranges plus any non-cased, non-ASCII-letter char). */
static int resid_case_is_ignorable(uint32_t cp) {
    if (resid_case_is_cased(cp)) return 0;
    /* Combining marks (Mn/Mc/Me broad ranges): transparent. */
    if ((cp >= 0x0300 && cp <= 0x036F) || (cp >= 0x0483 && cp <= 0x0489) ||
        (cp >= 0x0591 && cp <= 0x05BD) || (cp >= 0x0610 && cp <= 0x061A) ||
        (cp >= 0x064B && cp <= 0x065F) || (cp >= 0x0E31 && cp <= 0x0E3A) ||
        (cp >= 0x200C && cp <= 0x200F) || (cp >= 0xFE00 && cp <= 0xFE0F))
        return 1;
    /* Everything else that is uncased is treated as a boundary instead of
       transparent — matches the common cases (digits, punctuation). */
    return 0;
}

char* str_to_lower(const char* s) {
    int64_t n = str_len(s);
    char* out = (char*)malloc((size_t)(n * 4 + 8));
    char* w = out;
    const unsigned char* p = (const unsigned char*)s;
    /* Final_Sigma context: walk a lookahead pointer past the current
       character to find the next cased char (skipping ignorables). */
    while (*p) {
        int len = utf8_seq_len(*p);
        uint32_t cp = utf8_decode(p, len);
        uint32_t mapped;
        if (cp == 0x03A3) { /* Σ */
            /* Preceded by cased? */
            const unsigned char* q = p;
            int prev_cased = 0, scanned = 0;
            while (q > (const unsigned char*)s && !scanned) {
                /* step back one UTF-8 char */
                const unsigned char* r = q - 1;
                int back = 1;
                if (*r & 0x80) {
                    while (r > (const unsigned char*)s && (*(r - 1) & 0xC0) == 0x80) { r--; back++; }
                    if (back < 4 && utf8_seq_len(*(q - back)) == back) { }
                }
                uint32_t pcp = utf8_decode(r, back);
                if (!resid_case_is_ignorable(pcp)) {
                    prev_cased = resid_case_is_cased(pcp);
                    scanned = 1;
                }
                q = r;
            }
            /* Followed by cased? */
            const unsigned char* nx = p + len;
            int next_cased = 0;
            scanned = 0;
            while (*nx && !scanned) {
                int nl = utf8_seq_len(*nx);
                uint32_t ncp = utf8_decode(nx, nl);
                if (!resid_case_is_ignorable(ncp)) {
                    next_cased = resid_case_is_cased(ncp);
                    scanned = 1;
                }
                nx += nl;
            }
            mapped = (prev_cased && !next_cased) ? 0x03C2 : 0x03C3;
        } else {
            mapped = resid_case_simple(cp, 1);
        }
        w += utf8_encode(w, mapped);
        p += len;
    }
    *w = '\0';
    return out;
}

char* str_to_upper(const char* s) {
    int64_t n = str_len(s);
    char* out = (char*)malloc((size_t)(n * 4 + 8));
    char* w = out;
    const unsigned char* p = (const unsigned char*)s;
    while (*p) {
        int len = utf8_seq_len(*p);
        uint32_t cp = utf8_decode(p, len);
        const char* sp = special_upper_lookup(cp);
        if (sp) {
            while (*sp) *w++ = *sp++;
        } else {
            uint32_t mapped = resid_case_simple(cp, 0);
            w += utf8_encode(w, mapped);
        }
        p += len;
    }
    *w = '\0';
    return out;
}

/* Concatenate `times` copies (`times <= 0` → empty string). */
char* str_repeat(const char* s, int64_t times) {
    if (times < 0) times = 0;
    size_t ls = strlen(s);
    if (ls > 0 && (size_t)times > SIZE_MAX / ls) return resid_box_str("");
    char* p = (char*)malloc(ls * (size_t)times + 1);
    if (!p) return resid_box_str("");
    char* w = p;
    for (int64_t i = 0; i < times; i++) {
        memcpy(w, s, ls);
        w += ls;
    }
    *w = '\0';
    return p;
}

/* Replace all occurrences of `from` with `to` (empty `from` → unchanged). */
char* str_replace(const char* s, const char* from, const char* to) {
    size_t lf = strlen(from), lt = strlen(to);
    if (lf == 0) { size_t n = strlen(s); char* c = (char*)malloc(n + 1); if (!c) return resid_box_str(""); memcpy(c, s, n + 1); return c; }
    /* count */
    int64_t hits = 0;
    const char* q = s;
    while ((q = strstr(q, from)) != NULL) { hits++; q += lf; }
    size_t ls = strlen(s);
    if (lt > lf && (size_t)hits > SIZE_MAX / (lt - lf)) return resid_box_str("");
    size_t add = (lt > lf) ? (size_t)hits * (lt - lf) : 0;
    if (ls > SIZE_MAX - add) return resid_box_str("");
    char* p = (char*)malloc(ls + add + 1);
    if (!p) return resid_box_str("");
    char* w = p;
    q = s;
    const char* hit;
    while ((hit = strstr(q, from)) != NULL) {
        memcpy(w, q, hit - q); w += hit - q;
        memcpy(w, to, lt); w += lt;
        q = hit + lf;
    }
    strcpy(w, q);
    return p;
}

static void* rt_list_from(const void** items, int64_t n, const char* type_str);

/* Build a boxed List(Str) from a C string array. */
static void* rt_str_list(const char** items, int64_t n) {
    return rt_list_from((const void**)items, n, "List(Str)");
}

/* Split `s` on `sep` into a boxed List(Str). Empty sep → [s]. */
void* str_split(const char* s, const char* sep) {
    size_t lsep = strlen(sep);
    if (lsep == 0) {
        const char* one[1] = { s };
        return rt_str_list(one, 1);
    }
    int64_t parts = 1;
    const char* q = s;
    while ((q = strstr(q, sep)) != NULL) { parts++; q += lsep; }
    char** parts_arr = (char**)malloc((size_t)parts * sizeof(char*));
    int64_t i = 0;
    q = s;
    const char* hit;
    while ((hit = strstr(q, sep)) != NULL) {
        int64_t len = hit - q;
        char* part = (char*)malloc(len + 1);
        memcpy(part, q, len);
        part[len] = '\0';
        parts_arr[i++] = part;
        q = hit + lsep;
    }
    parts_arr[i] = strdup(q);
    void* out = rt_str_list((const char**)parts_arr, parts);
    free(parts_arr);
    return out;
}

/* Join a boxed List(Str) with separator `sep`. */
char* str_join(void* list_box, const char* sep) {
    int64_t n = resid_list_len(list_box);
    const char** items = (const char**)resid_list_to_array(list_box);
    size_t lsep = strlen(sep), total = 0;
    for (int64_t i = 0; i < n; i++) total += strlen(items[i]);
    if (n > 0) total += lsep * (size_t)(n - 1);
    char* p = (char*)malloc(total + 1);
    char* w = p;
    for (int64_t i = 0; i < n; i++) {
        if (i > 0) { memcpy(w, sep, lsep); w += lsep; }
        size_t li = strlen(items[i]);
        memcpy(w, items[i], li); w += li;
    }
    *w = '\0';
    free((void*)items);
    return p;
}

/* ─── Stdlib v1.3: list verbs ───
   Lists are persistent tries (see resid_list_new/get/... above): slots
   hold boxed scalars (resid_box_i64) for List(Int) and raw char* for
   List(Str). Verbs flatten, operate, and rebuild fresh lists. */

static void* rt_list_from(const void** items, int64_t n, const char* type_str) {
    return resid_list_new(n, (void**)items, type_str);
}

void* list_reverse_ints(void* box) {
    int64_t n = resid_list_len(box);
    void** items = resid_list_to_array(box);
    void** rev = (void**)malloc((size_t)(n > 0 ? n : 1) * sizeof(void*));
    for (int64_t i = 0; i < n; i++) rev[i] = items[n - 1 - i];
    void* out = resid_list_new(n, rev, resid_list_type(box));
    free(items);
    free(rev);
    return out;
}

void* list_reverse_strs(void* box) {
    return list_reverse_ints(box);
}

int8_t list_contains_int(void* box, int64_t v) {
    int64_t n = resid_list_len(box);
    for (int64_t i = 0; i < n; i++)
        if (resid_unbox_i64(resid_list_get(box, i)) == v) return 1;
    return 0;
}

int8_t list_contains_str(void* box, const char* v) {
    int64_t n = resid_list_len(box);
    for (int64_t i = 0; i < n; i++)
        if (strcmp((const char*)resid_list_get(box, i), v) == 0) return 1;
    return 0;
}

__attribute__((unused)) static int rt_cmp_i64(const void* a, const void* b) {
    int64_t x = *(const int64_t*)a, y = *(const int64_t*)b;
    return x < y ? -1 : x > y;
}

static int rt_cmp_boxed_i64(const void* a, const void* b) {
    int64_t x = resid_unbox_i64(*(void* const*)a);
    int64_t y = resid_unbox_i64(*(void* const*)b);
    return x < y ? -1 : x > y;
}

static int rt_cmp_str_slot(const void* a, const void* b) {
    return strcmp((const char*)*(void* const*)a, (const char*)*(void* const*)b);
}

void rt_stable_sort(void** items, int64_t n, int (*cmp)(const void*, const void*));

static void* rt_list_sorted_copy(void* box, int (*cmp)(const void*, const void*)) {
    int64_t n = resid_list_len(box);
    void** items = resid_list_to_array(box);
    rt_stable_sort(items, n, cmp);
    void* out = resid_list_new(n, items, resid_list_type(box));
    free(items);
    return out;
}

void* list_sort_ints(void* box) {
    return rt_list_sorted_copy(box, rt_cmp_boxed_i64);
}

void* list_sort_strs(void* box) {
    return rt_list_sorted_copy(box, rt_cmp_str_slot);
}

int64_t list_sum(void* box) {
    int64_t n = resid_list_len(box);
    int64_t s = 0;
    for (int64_t i = 0; i < n; i++) s += resid_unbox_i64(resid_list_get(box, i));
    return s;
}

/* ─── Stdlib v1.1: parsing + integer math ─── */

int8_t str_is_int(const char* s) {
    if (*s == '\0') return 0;
    const char* p = s;
    if (*p == '-' || *p == '+') p++;
    if (*p == '\0') return 0;
    while (*p) {
        if (*p < '0' || *p > '9') return 0;
        p++;
    }
    return 1;
}

int64_t str_parse_int(const char* s) {
    if (!str_is_int(s)) return 0;
    return (int64_t)strtoll(s, NULL, 10);
}

int64_t abs_i64(int64_t x) { return x < 0 ? -x : x; }
int64_t min_i64(int64_t a, int64_t b) { return a < b ? a : b; }
int64_t max_i64(int64_t a, int64_t b) { return a > b ? a : b; }

int64_t clamp_i64(int64_t x, int64_t lo, int64_t hi) {
    if (x < lo) return lo;
    if (x > hi) return hi;
    return x;
}

/* ─── Stdlib v1.2: float parsing + misc string helpers ─── */

int8_t str_is_float(const char* s) {
    if (*s == '\0') return 0;
    char* end = NULL;
    strtod(s, &end);
    while (*end == ' ' || *end == '\t') end++;
    return *end == '\0' && end != s;
}

double str_parse_float(const char* s) {
    if (!str_is_float(s)) return 0.0;
    return strtod(s, NULL);
}

int64_t str_count(const char* s, const char* needle) {
    size_t ln = strlen(needle);
    if (ln == 0) return 0;
    int64_t hits = 0;
    const char* q = s;
    while ((q = strstr(q, needle)) != NULL) { hits++; q += ln; }
    return hits;
}

char* str_reverse(const char* s) {
    int64_t n = str_len(s);
    const unsigned char* p = (const unsigned char*)s;
    int64_t* off = (int64_t*)malloc((n + 1) * sizeof(int64_t));
    int64_t i = 0;
    while (*p) {
        off[i++] = (int64_t)((const char*)p - s);
        p += utf8_seq_len(*p);
    }
    off[i] = (int64_t)strlen(s);
    char* out = (char*)malloc(off[n] + 1);
    int64_t w = 0;
    for (int64_t k = n - 1; k >= 0; k--) {
        int64_t len = off[k + 1] - off[k];
        memcpy(out + w, s + off[k], len);
        w += len;
    }
    out[w] = '\0';
    free(off);
    return out;
}

/* ─── Stdlib v1.4: List(Float) verbs (slots hold resid_box_f64 boxes) ─── */

void* list_reverse_floats(void* box) {
    return list_reverse_ints(box);
}

int8_t list_contains_float(void* box, double v) {
    int64_t n = resid_list_len(box);
    for (int64_t i = 0; i < n; i++)
        if (resid_unbox_f64(resid_list_get(box, i)) == v) return 1;
    return 0;
}

static int rt_cmp_boxed_f64(const void* a, const void* b) {
    double x = resid_unbox_f64(*(void* const*)a);
    double y = resid_unbox_f64(*(void* const*)b);
    return x < y ? -1 : x > y;
}

void* list_sort_floats(void* box) {
    return rt_list_sorted_copy(box, rt_cmp_boxed_f64);
}

double list_sumf(void* box) {
    int64_t n = resid_list_len(box);
    double s = 0.0;
    for (int64_t i = 0; i < n; i++) s += resid_unbox_f64(resid_list_get(box, i));
    return s;
}

/* ─── Bootstrap-layout list verbs ───
   The bootstrap compilers build lists as { int64_t n; raw slots[n] } with
   unboxed elements (i64 / double / char*). These twins serve that layout;
   the Rust pipeline uses the persistent-list variants above. Names are
   prefixed bl_ so both conventions coexist. */

static void* bl_alloc(int64_t n) {
    int64_t* m = (int64_t*)malloc(8 + (size_t)n * 8);
    m[0] = n;
    return m;
}

void* bl_reverse_i64(void* box) {
    int64_t n = ((int64_t*)box)[0];
    int64_t* out = (int64_t*)bl_alloc(n);
    const int64_t* in = (const int64_t*)box + 1;
    for (int64_t i = 0; i < n; i++) out[1 + i] = in[n - 1 - i];
    return out;
}

void* bl_reverse_str(void* box) {
    int64_t n = ((int64_t*)box)[0];
    char** out = (char**)bl_alloc(n);
    const char** in = (const char**)((int64_t*)box + 1);
    for (int64_t i = 0; i < n; i++) out[1 + i] = (char*)in[n - 1 - i];
    return out;
}

void* bl_reverse_f64(void* box) {
    int64_t n = ((int64_t*)box)[0];
    double* out = (double*)bl_alloc(n);
    const double* in = (const double*)((int64_t*)box + 1);
    for (int64_t i = 0; i < n; i++) out[1 + i] = in[n - 1 - i];
    return out;
}

int8_t bl_contains_i64(void* box, int64_t v) {
    int64_t n = ((int64_t*)box)[0];
    const int64_t* a = (const int64_t*)box + 1;
    for (int64_t i = 0; i < n; i++)
        if (a[i] == v) return 1;
    return 0;
}

int8_t bl_contains_str(void* box, const char* v) {
    int64_t n = ((int64_t*)box)[0];
    const char** a = (const char**)((int64_t*)box + 1);
    for (int64_t i = 0; i < n; i++)
        if (strcmp(a[i], v) == 0) return 1;
    return 0;
}

int8_t bl_contains_f64(void* box, double v) {
    int64_t n = ((int64_t*)box)[0];
    const double* a = (const double*)((int64_t*)box + 1);
    for (int64_t i = 0; i < n; i++)
        if (a[i] == v) return 1;
    return 0;
}

static int bl_cmp_i64(const void* a, const void* b) {
    int64_t x = *(const int64_t*)a, y = *(const int64_t*)b;
    return x < y ? -1 : x > y;
}

static int bl_cmp_str(const void* a, const void* b) {
    return strcmp(*(const char* const*)a, *(const char* const*)b);
}

static int bl_cmp_f64(const void* a, const void* b) {
    double x = *(const double*)a, y = *(const double*)b;
    return x < y ? -1 : x > y;
}

static void* bl_sorted_copy(void* box, size_t nbytes, int (*cmp)(const void*, const void*)) {
    (void)nbytes;
    int64_t n = ((int64_t*)box)[0];
    int64_t* out = (int64_t*)malloc(8 + (size_t)n * 8);
    memcpy(out, box, 8 + (size_t)n * 8);
    rt_stable_sort((void**)(out + 1), n, cmp);
    return out;
}

/* Stable bottom-up mergesort over an array of n pointers. O(n log n),
 * stable: equal keys keep their original relative order. One scratch
 * buffer, no recursion. This is the single sort primitive for both
 * pipelines (boxed slots and flat buffers alike). */
void rt_stable_sort(void** items, int64_t n, int (*cmp)(const void*, const void*)) {
    if (n < 2) return;
    void** scratch = (void**)malloc((size_t)n * sizeof(void*));
    void** src = items;
    void** tmp = scratch;
    for (int64_t width = 1; width < n; width *= 2) {
        for (int64_t lo = 0; lo < n; lo += 2 * width) {
            int64_t mid = lo + width < n ? lo + width : n;
            int64_t hi = lo + 2 * width < n ? lo + 2 * width : n;
            int64_t i = lo, j = mid, k = lo;
            while (i < mid && j < hi) {
                /* <= keeps the left run first: stability. */
                if (cmp(&src[i], &src[j]) <= 0) tmp[k++] = src[i++];
                else tmp[k++] = src[j++];
            }
            while (i < mid) tmp[k++] = src[i++];
            while (j < hi) tmp[k++] = src[j++];
        }
        void** swap = src; src = tmp; tmp = swap;
    }
    if (src != items) memcpy(items, src, (size_t)n * sizeof(void*));
    free(scratch);
}

void* list_sort_by(void* box, int (*cmp)(const void*, const void*)) {
    return rt_list_sorted_copy(box, cmp);
}

void* bl_sort_i64(void* box) { return bl_sorted_copy(box, 8, bl_cmp_i64); }
void* bl_sort_str(void* box) { return bl_sorted_copy(box, 8, bl_cmp_str); }
void* bl_sort_f64(void* box) { return bl_sorted_copy(box, 8, bl_cmp_f64); }

/* Behavior-dispatched stable sort over a flat [len:i64][elem×8] buffer
 * (stage-2 ABI). Elements are compared via cmp(&a, &b); a fresh sorted
 * copy is returned. */
void* bl_sort_by(void* box, int (*cmp)(const void*, const void*)) {
    return bl_sorted_copy(box, 8, cmp);
}

int64_t bl_sum(void* box) {
    int64_t n = ((int64_t*)box)[0];
    const int64_t* a = (const int64_t*)box + 1;
    int64_t s = 0;
    for (int64_t i = 0; i < n; i++) s += a[i];
    return s;
}

double bl_sumf(void* box) {
    int64_t n = ((int64_t*)box)[0];
    const double* a = (const double*)((int64_t*)box + 1);
    double s = 0.0;
    for (int64_t i = 0; i < n; i++) s += a[i];
    return s;
}

/* Split into a bootstrap-layout List(Str). */
/* Despite the `bl_` name, these two build/read genuine persistent
 * ResidList values (resid_list_new/_len/_get) — the codegen.resid
 * front end calls them for the `str_split`/`str_join` builtins, and
 * every other list operation it emits (indexing, .len(), .concat())
 * targets that same persistent representation. They used to build a
 * distinct flat `{i64 n; slots[n]}` layout, which silently corrupted
 * any split result the moment it was indexed or lengthed — see the
 * self-compile segfault this was fixed for. */
void* bl_str_split(const char* s, const char* sep) {
    size_t lsep = strlen(sep);
    if (lsep == 0) {
        void* one = (void*)s;
        return resid_list_new(1, &one, "Str");
    }
    int64_t parts = 1;
    const char* q = s;
    while ((q = strstr(q, sep)) != NULL) { parts++; q += lsep; }
    char** tmp = (char**)malloc((size_t)parts * sizeof(char*));
    int64_t i = 0;
    q = s;
    const char* hit;
    while ((hit = strstr(q, sep)) != NULL) {
        int64_t len = hit - q;
        char* part = (char*)malloc(len + 1);
        memcpy(part, q, len);
        part[len] = '\0';
        tmp[i++] = part;
        q = hit + lsep;
    }
    tmp[i] = strdup(q);
    void* out = resid_list_new(parts, (void**)tmp, "Str");
    free(tmp);
    return out;
}

char* bl_str_join(void* box, const char* sep) {
    int64_t n = resid_list_len(box);
    size_t lsep = strlen(sep), total = 0;
    for (int64_t i = 0; i < n; i++) total += strlen((const char*)resid_list_get(box, i));
    if (n > 0) total += lsep * (size_t)(n - 1);
    char* p = (char*)malloc(total + 1);
    char* w = p;
    for (int64_t i = 0; i < n; i++) {
        if (i > 0) { memcpy(w, sep, lsep); w += lsep; }
        const char* item = (const char*)resid_list_get(box, i);
        size_t li = strlen(item);
        memcpy(w, item, li); w += li;
    }
    *w = '\0';
    return p;
}


/* ─── Stdlib v1.6: OS entropy hook ───
   The only crypto piece allowed in C: entropy must come from the operating
   system. One byte per call; everything else is assembled in Resid. */
int64_t resid_crypto_random_byte(void) {
    unsigned char b = 0;
    if (getrandom(&b, 1, 0) != 1) {
        /* fallback: /dev/urandom */
        FILE* f = fopen("/dev/urandom", "rb");
        if (!f) resid_abort("crypto_random_byte: no entropy source");
        if (fread(&b, 1, 1, f) != 1) resid_abort("crypto_random_byte: read failed");
        fclose(f);
    }
    return (int64_t)b;
}

/* CPU feature query for hardware crypto dispatch (spec/PROGRESS §"hardware
   crypto"): reports whether AES-NI is present so Resid library code can
   choose between the LLVM-intrinsic-backed block cipher and the pure-Resid
   fallback. This is a capability query only, same category as the entropy
   hook above — the AES computation itself is never done in C; it's emitted
   directly as `llvm.x86.aesni.*` intrinsic calls by resid-codegen. */
int8_t resid_cpu_has_aesni(void) {
#if defined(__x86_64__) || defined(__i386__)
    return __builtin_cpu_supports("aes") ? 1 : 0;
#else
    return 0;
#endif
}

/* Bounds-check failure helper with diagnostics. `at` is a source-location
 * C string (`file:line:col`) baked in by codegen, so out-of-range list
 * indexing reports where it happened (spec §34 diagnostics). */
_Noreturn void resid_index_abort(int64_t idx, int64_t len, const char* at) {
    char buf[192];
    if (at && at[0]) {
        snprintf(buf, sizeof(buf),
                 "list index out of bounds: index %lld, length %lld (%s)",
                 (long long)idx, (long long)len, at);
    } else {
        snprintf(buf, sizeof(buf),
                 "list index out of bounds: index %lld, length %lld",
                 (long long)idx, (long long)len);
    }
    resid_abort(buf);
}

/* ─── TCP transport (spec §32 provider-adjacent externs) ─────────
   Minimal blocking sockets so the Resid-level HTTP stack (lib/http.res)
   can do all protocol work: URL parsing, request building, response
   parsing stay in pure Resid. recv reads until the peer closes (our
   client always sends `Connection: close`) or a 4 MB cap. */

int64_t resid_tcp_connect(const char* host, int64_t port) {
    if (!host || host[0] == '\0') return -1;
    if (port <= 0 || port > 65535) return -1;
    for (const char* p = host; *p; p++) {
        if (!((*p >= 'a' && *p <= 'z') || (*p >= 'A' && *p <= 'Z') ||
              (*p >= '0' && *p <= '9') || *p == '-' || *p == '.' || *p == ':')) {
            return -1;
        }
    }
    struct addrinfo hints, *res = NULL;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    char portstr[16];
    snprintf(portstr, sizeof(portstr), "%lld", (long long)port);
    if (getaddrinfo(host, portstr, &hints, &res) != 0 || !res) return -1;
    int fd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (fd < 0) { freeaddrinfo(res); return -1; }
    if (connect(fd, res->ai_addr, res->ai_addrlen) != 0) {
        freeaddrinfo(res);
        close(fd);
        return -1;
    }
    freeaddrinfo(res);
    struct timeval tmo = { 30, 0 };
    setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tmo, sizeof(tmo));
    return (int64_t)fd;
}

int8_t resid_tcp_send(int64_t fd, const char* data) {
    size_t len = strlen(data);
    const char* p = data;
    while (len > 0) {
        ssize_t n = send((int)fd, p, len, MSG_NOSIGNAL);
        if (n <= 0) return 0;
        p += n;
        len -= (size_t)n;
    }
    return 1;
}

char* resid_tcp_recv_all(int64_t fd) {
    size_t cap = 65536, len = 0;
    char* out = (char*)malloc(cap);
    if (!out) return resid_box_str("");
    for (;;) {
        if (len + 4096 > cap) {
            if (cap >= 4u * 1024 * 1024) break; /* 4 MB cap */
            if (cap > SIZE_MAX / 2) break;
            cap *= 2;
            char* nb = (char*)realloc(out, cap);
            if (!nb) break;
            out = nb;
        }
        ssize_t n = recv((int)fd, out + len, cap - len - 1, 0);
        if (n <= 0) break;
        len += (size_t)n;
    }
    out[len] = '\0';
    return out;
}

int8_t resid_tcp_close(int64_t fd) {
    return close((int)fd) == 0 ? 1 : 0;
}

/* ─── Binary-safe TCP (TLS transport) ─────────────────────────────
 * List(Int) ABI: i64 count at offset 0, i64 elements after. send_bin
 * writes count bytes (values truncated to u8); recv_bin reads exactly
 * `n` bytes into a fresh list and stores the byte count as its length
 * (0 on error/EOF). */

int8_t resid_tcp_send_bin(int64_t fd, void* lst) {
    int64_t n = resid_list_len(lst);
    if (n <= 0) return 1;
    if (n > 1024 * 1024) return 0; /* 1 MB max */
    char* buf = (char*)malloc((size_t)n);
    if (!buf) return 0;
    for (int64_t i = 0; i < n; i++) {
        /* scalar elements are boxed: element -> ResidVal -> slots[0] -> i64 */
        ResidVal* bx = (ResidVal*)resid_list_get(lst, i);
        buf[i] = (char)(*(int64_t*)RV_SLOTS(bx)[0] & 0xFF);
    }
    const char* p2 = buf;
    size_t left = (size_t)n;
    while (left > 0) {
        ssize_t w = send((int)fd, p2, left, MSG_NOSIGNAL);
        if (w <= 0) { free(buf); return 0; }
        p2 += w; left -= (size_t)w;
    }
    free(buf);
    return 1;
}

/* receive exactly n bytes into a fresh List(Int): slots 0..n-1 = bytes.
 * On EOF/error fewer slots may be filled (remaining stay 0). */
void* resid_tcp_recv_bin(int64_t fd, int64_t n) {
    if (n < 0) n = 0;
    if (n > 1024 * 1024) n = 1024 * 1024; /* 1 MB max */
    char* buf = (char*)malloc((size_t)(n > 0 ? n : 1));
    if (!buf) return resid_list_new(0, NULL, "List");
    void** slots = (void**)malloc(sizeof(void*) * (size_t)n);
    if (!slots) { free(buf); return resid_list_new(0, NULL, "List"); }
    int64_t got = 0;
    while (got < n) {
        ssize_t r = recv((int)fd, buf + got, (size_t)(n - got), 0);
        if (r <= 0) break;
        got += r;
    }
    for (int64_t i = 0; i < n; i++) {
        char bv = (i < got) ? buf[i] : 0;
        slots[i] = resid_box_i64((int64_t)(unsigned char)bv);
    }
    free(buf);
    void* out = resid_list_new(n, slots, "List");
    free(slots);
    return out;
}

/* UTC wall clock as a civil timestamp YYYYMMDDHHMMSS (i64), for x509
   validity checks. Uses gmtime_r so it is locale/timezone independent. */
int64_t resid_utc_now_civil(void) {
    time_t t = time(NULL);
    struct tm tmv;
    gmtime_r(&t, &tmv);
    return (int64_t)(tmv.tm_year + 1900) * 10000000000LL
         + (int64_t)(tmv.tm_mon + 1) * 100000000LL
         + (int64_t)tmv.tm_mday * 1000000LL
         + (int64_t)tmv.tm_hour * 10000LL
         + (int64_t)tmv.tm_min * 100LL
         + (int64_t)tmv.tm_sec;
}

/* Checked integer add/sub overflow trap (spec v3.2 §6.1). */
_Noreturn void resid_arith_overflow(void) {
    fprintf(stderr, "resid: arithmetic overflow\n");
    abort();
}

/* ─── Immutable Map / Set (spec §32 core types) ────────────────────
 *
 * Maps and sets are immutable values backed by a persistent hash table
 * (separate chaining). Every mutation (insert/remove) allocates a new
 * table — no COW, no refcounting. Simple and correct.
 *
 * Keys are opaque pointers (compared by address for integers and
 * compared as NUL-terminated C strings for Str). All Resid values
 * passed as keys are string-ified via resid_val_str for hashing and
 * comparison — this works because integers are boxed and pointer-
 * comparable strings are interned.
 */

/* ─── Persistent Map / Set (Hash Array Mapped Trie) ──────────────────
 * Slots hold boxed keys and values (resid_box_*), exactly like the flat
 * table they replace. Strings hash by content; integers/booleans are
 * string-ified (see resid_hash) — so hash/key-eq stay consistent for all
 * key shapes.
 *
 * Representation: a shallow 32-way hash trie. Each map/set value is a
 * persistent HMTrie { count, root }. Insert/remove copy only the nodes on
 * the root-to-leaf path (O(log32 n)); all other nodes are shared by
 * pointer, so the old value is never mutated — identical observable
 * immutability to the prior whole-table copy, but O(log n) instead of
 * O(n) per operation.
 *
 * Nodes: an INDEX node holds up to 32 children reached by 5 bits of the
 * key hash per trie level. A slot holds either a leaf (HMPair) or a
 * subnode (HMNode). On a full-hash collision the shared bits run out,
 * so at HT_MAX_LEVEL the slot becomes a COLLISION node (a small bucket of
 * pairs sharing a full hash). `kind` distinguishes the two.
 */

#define HT_DEGREE 32
#define HT_SHIFT 5
#define HT_MASK 31
#define HT_MAX_LEVEL 12 /* 13 levels x 5 bits = 65 >= 64-bit hash */

typedef struct {
    void* key; /* boxed key */
    void* val; /* boxed value (1 for set entries) */
} HMPair;

typedef struct HMNode {
    uint32_t kind;   /* 0 = index node, 1 = collision node */
    uint32_t used;   /* index: bitmap of occupied slots;
                        collision: number of pairs */
    void*    slot[32]; /* index: HMPair* (leaf) or HMNode* (sub);
                          collision: pairs packed key,val,key,val,... */
    uint32_t sub[32];  /* index: 1 if slot[i] is a subnode pointer */
} HMNode;

/* The map/set value handed out to Resid: a persistent trie root + size. */
typedef struct MapTab MapTab;

/* The map/set value handed out to Resid. Two representations:
 *   - trie mode (tab == NULL): the persistent hash trie above;
 *   - table mode (tab != NULL): a flat open-addressing table, produced only
 *     for a map the compiler proved is a linear accumulator (a parameter
 *     consumed solely by `m.insert(..)`/`m.remove(..)` feeding the same
 *     parameter of a self tail call, see the driver's linear-map analysis).
 *     While `transient` is set, exactly one loop owns the table and updates
 *     it in place; returning it freezes it, after which it is immutable like
 *     any other map value.
 * Every observable result is identical in both modes: order-dependent
 * operations (keys, values, format, set algebra) and persistent updates run
 * on the canonical trie the table materializes to (cached once frozen), and
 * that trie's shape depends only on the key set. */
typedef struct {
    int64_t count;
    HMNode* root;   /* trie mode: NULL for the empty container;
                       table mode: cached materialized trie (frozen only) */
    MapTab* tab;
    int64_t transient;
} HMTrie;

static uint64_t fnv1a(const char* s);

/* A bare string key is a raw char* whose first byte is a normal character.
 * A boxed value is a ResidVal whose tag is -1 = 0xFF...FF, so its first byte
 * is 0xFF (never a valid UTF-8/ASCII lead byte, so never a string's first
 * byte). Reading a single byte is safe for both, so we can branch without
 * over-reading a short malloc'd string the way resid_box_tag would. */
static int is_boxed(const void* v) {
    return ((const unsigned char*)v)[0] == 0xFF;
}

/* Precise free for Map/Set (E.4: ownership oracle integration). Frees a
 * boxed key/val slot (bare C string keys are not owned by the trie — only
 * boxed values are ours to free; see is_boxed). */
static void free_boxed_slot(void* v) {
    if (!v) return;
    if (!is_boxed(v)) return; /* bare C string key: not our allocation to walk */
    box_free_shallow((ResidVal*)v);
}

static void free_hmnode(HMNode* n) {
    if (!n) return;
    if (n->kind == 1) {
        /* Collision node: `used` pairs packed key,val,key,val,... in slot[]. */
        for (uint32_t i = 0; i < n->used; i++) {
            HMPair* p = (HMPair*)n->slot[i];
            free_boxed_slot(p->key);
            free_boxed_slot(p->val);
            free(p);
        }
    } else {
        for (int i = 0; i < 32; i++) {
            if (!n->slot[i]) continue;
            if (n->sub[i]) {
                free_hmnode((HMNode*)n->slot[i]);
            } else {
                HMPair* p = (HMPair*)n->slot[i];
                free_boxed_slot(p->key);
                free_boxed_slot(p->val);
                free(p);
            }
        }
    }
    free(n);
}

static void map_free_parts(HMTrie* m);

void resid_map_free(void* b) {
    if (!b) return;
    HMTrie* m = (HMTrie*)b;
    map_free_parts(m);
    free(m);
}

void resid_set_free(void* b) {
    if (!b) return;
    HMTrie* m = (HMTrie*)b;
    map_free_parts(m);
    free(m);
}

/* Hash a Resid value for use as a map/set key. Bare strings hash by content;
 * scalar boxes (box `type` "i64", "f64", "bool", "i128", "u128") hash by
 * their numeric value formatted canonically; other boxes hash their type
 * name. Hashing and equality agree, so this stays in lock-step with
 * resid_key_eq. */
static uint64_t resid_hash(void* v) {
    if (!is_boxed(v)) {
        /* Bare C string key. */
        return fnv1a((const char*)v);
    }
    ResidVal* b = (ResidVal*)v;
    int64_t tag = b->tag;
    if (tag == -1) {
        /* Scalar box — dispatch on the box type string. */
        const char* t = b->type;
        void* raw = resid_box_slot(v, 0);
        char buf[64];
        if (t && strcmp(t, "i64") == 0) {
            snprintf(buf, sizeof(buf), "%lld", (long long)*(int64_t*)raw);
            return fnv1a(buf);
        }
        if (t && strcmp(t, "f64") == 0) {
            snprintf(buf, sizeof(buf), "%.17g", *(double*)raw);
            return fnv1a(buf);
        }
        if (t && strcmp(t, "bool") == 0) {
            return fnv1a(*(int8_t*)raw ? "t" : "f");
        }
        if (t && strcmp(t, "i128") == 0) {
            snprintf(buf, sizeof(buf), "%lld", (long long)ld_i128(raw));
            return fnv1a(buf);
        }
        if (t && strcmp(t, "u128") == 0) {
            snprintf(buf, sizeof(buf), "%llu", (unsigned long long)(unsigned __int128)ld_i128(raw));
            return fnv1a(buf);
        }
        return fnv1a(t ? t : "?");
    }
    /* Boxed composite: handle Str specially — hash its content. */
    if (b->type && strcmp(b->type, "Str") == 0) {
        const char* s = (const char*)resid_box_slot(v, 0);
        return fnv1a(s ? s : "");
    }
    /* Other boxed composites — hash their type name. */
    return fnv1a(b->type ? b->type : "?");
}

/* Compare two Resid values for key equality. Returns 1 if equal. */
static int resid_key_eq(void* a, void* b) {
    if (a == b) return 1;
    int ab = is_boxed(a);
    int bb2 = is_boxed(b);
    if (ab && bb2) {
        ResidVal* ba = (ResidVal*)a;
        ResidVal* bb = (ResidVal*)b;
        if (ba->tag == -1 && bb->tag == -1) {
            /* Both scalar boxes — compare by extracted numeric value. */
            const char* ta = ba->type;
            const char* tb = bb->type;
            if (ta && tb && strcmp(ta, tb) == 0) {
                void* ra = resid_box_slot(a, 0);
                void* rb = resid_box_slot(b, 0);
                if (ra == rb) return 1;
                if (strcmp(ta, "i64") == 0) return *(int64_t*)ra == *(int64_t*)rb;
                if (strcmp(ta, "f64") == 0) return *(double*)ra == *(double*)rb;
                if (strcmp(ta, "bool") == 0) return *(int8_t*)ra == *(int8_t*)rb;
                if (strcmp(ta, "i128") == 0) return ld_i128(ra) == ld_i128(rb);
                if (strcmp(ta, "u128") == 0) return ld_i128(ra) == ld_i128(rb);
                return 0;
            }
            return 0;
        }
        /* Boxed composites: handle Str specially — compare content. */
        if (ba->type && bb->type && strcmp(ba->type, "Str") == 0 && strcmp(bb->type, "Str") == 0) {
            const char* sa = (const char*)resid_box_slot(a, 0);
            const char* sb = (const char*)resid_box_slot(b, 0);
            if (!sa || !sb) return sa == sb;
            return strcmp(sa, sb) == 0;
        }
        /* Other boxed composites: identical pointer is equal; otherwise not. */
        return ba == bb;
    }
    if (!ab && !bb2) {
        /* Both bare C strings. */
        return strcmp((const char*)a, (const char*)b) == 0;
    }
    return 0;
}

/* Build a Str from a List(Int) of Unicode codepoints.
 * Iterates the persistent List trie once, UTF-8-encodes each codepoint,
 * and returns a freshly malloc'd NUL-terminated string. The List itself
 * is not mutated — this is a read-only snapshot. */
char* resid_str_from_codepoints(void* list) {
    ResidList* l = (ResidList*)list;
    int64_t n = l->count;
    if (n <= 0) return resid_box_str("");

    /* Allocate max possible (4 bytes per codepoint) + NUL. */
    if ((size_t)n > SIZE_MAX / 4) resid_abort("resid_str_from_codepoints: size overflow");
    char* buf = (char*)malloc((size_t)(4 * n + 1));
    if (!buf) resid_abort("resid_str_from_codepoints: out of memory");
    int64_t total_bytes = 0;
    for (int64_t i = 0; i < n; i++) {
        void* elem = resid_list_get(list, i);
        int64_t cp = resid_unbox_i64(elem);
        if (cp < 0x80) {
            buf[total_bytes++] = (char)cp;
        } else if (cp < 0x800) {
            buf[total_bytes++] = (char)(0xC0 | (cp >> 6));
            buf[total_bytes++] = (char)(0x80 | (cp & 0x3F));
        } else if (cp < 0x10000) {
            buf[total_bytes++] = (char)(0xE0 | (cp >> 12));
            buf[total_bytes++] = (char)(0x80 | ((cp >> 6) & 0x3F));
            buf[total_bytes++] = (char)(0x80 | (cp & 0x3F));
        } else {
            buf[total_bytes++] = (char)(0xF0 | (cp >> 18));
            buf[total_bytes++] = (char)(0x80 | ((cp >> 12) & 0x3F));
            buf[total_bytes++] = (char)(0x80 | ((cp >> 6) & 0x3F));
            buf[total_bytes++] = (char)(0x80 | (cp & 0x3F));
        }
    }
    buf[total_bytes] = '\0';
    return buf;
}

/* FNV-1a hash for a string. */
static uint64_t fnv1a(const char* s) {
    uint64_t h = 14695981039346656037ULL;
    for (const unsigned char* p = (const unsigned char*)s; *p; p++) {
        h ^= *p;
        h *= 1099511628211ULL;
    }
    return h;
}

static HMNode* node_index_new(void) {
    HMNode* n = (HMNode*)calloc(1, sizeof(HMNode));
    if (!n) resid_abort("node_index_new: out of memory");
    n->kind = 0;
    return n;
}

/* Shallow-copy a node: the slot/sub arrays are copied but child nodes are
 * shared by pointer — this is exactly the path-copying that makes every
 * update persistent without mutating the old value. */
static HMNode* node_clone(const HMNode* src) {
    HMNode* n = (HMNode*)malloc(sizeof(HMNode));
    if (!n) resid_abort("node_clone: out of memory");
    *n = *src;
    return n;
}

static HMPair* pair_new(void* key, void* val) {
    HMPair* p = (HMPair*)malloc(sizeof(HMPair));
    if (!p) resid_abort("pair_new: out of memory");
    p->key = key;
    p->val = val;
    return p;
}

static HMTrie* trie_new(int64_t count, HMNode* root) {
    HMTrie* t = (HMTrie*)malloc(sizeof(HMTrie));
    if (!t) resid_abort("trie_new: out of memory");
    t->count = count;
    t->root = root;
    t->tab = NULL;
    t->transient = 0;
    return t;
}

/* Insert key/val into `node` at `level`, returning a new persistent node.
 * `isnew` (out) is 1 if a brand-new key was inserted (so count grows). */
static HMNode* trie_insert(HMNode* node, int level, uint64_t h,
                           void* key, void* val, int* isnew) {
    if (node == NULL) {
        HMNode* n = node_index_new();
        uint32_t idx = (uint32_t)((h >> (level * HT_SHIFT)) & HT_MASK);
        n->used = (1u << idx);
        n->slot[idx] = pair_new(key, val);
        n->sub[idx] = 0;
        *isnew = 1;
        return n;
    }
    if (node->kind == 1) {
        /* collision node: pairs packed key,val,key,val,... */
        int cnt = (int)node->used;
        for (int i = 0; i < cnt; i++) {
            if (resid_key_eq(node->slot[2 * i], key)) {
                HMNode* n = node_clone(node);
                n->slot[2 * i + 1] = val; /* replace value in-place (copy) */
                *isnew = 0;
                return n;
            }
        }
        HMNode* n = node_clone(node);
        n->used = (uint32_t)(cnt + 1);
        n->slot[2 * cnt] = key;
        n->slot[2 * cnt + 1] = val;
        *isnew = 1;
        return n;
    }
    /* index node */
    uint32_t idx = (uint32_t)((h >> (level * HT_SHIFT)) & HT_MASK);
    uint32_t bit = (1u << idx);
    if (!(node->used & bit)) {
        HMNode* n = node_clone(node);
        n->used |= bit;
        n->slot[idx] = pair_new(key, val);
        n->sub[idx] = 0;
        *isnew = 1;
        return n;
    }
    if (node->sub[idx]) {
        HMNode* child = trie_insert((HMNode*)node->slot[idx], level + 1, h, key, val, isnew);
        HMNode* n = node_clone(node);
        n->slot[idx] = child;
        return n;
    }
    /* existing leaf in this slot */
    HMPair* p = (HMPair*)node->slot[idx];
    if (resid_key_eq(p->key, key)) {
        HMNode* n = node_clone(node);
        n->slot[idx] = pair_new(key, val);
        *isnew = 0;
        return n;
    }
    /* two different keys collide into the same slot */
    if (level >= HT_MAX_LEVEL) {
        /* no hash bits left: promote to a collision node holding both keys. */
        HMNode* n = node_clone(node);
        HMNode* c = node_index_new();
        c->kind = 1;
        c->used = 2;
        c->slot[0] = p->key;
        c->slot[1] = p->val;
        c->slot[2] = key;
        c->slot[3] = val;
        n->sub[idx] = 1;
        n->slot[idx] = c;
        *isnew = 1;
        return n;
    }
    /* descend: put the old leaf and the new key into a child index node. */
    uint64_t ho = resid_hash(p->key);
    HMNode* child = trie_insert(NULL, level + 1, ho, p->key, p->val, isnew);
    child = trie_insert(child, level + 1, h, key, val, isnew);
    HMNode* n = node_clone(node);
    n->sub[idx] = 1;
    n->slot[idx] = child;
    return n;
}

/* Return the value for key, or NULL if absent. */
static void* trie_get(HMNode* node, int level, uint64_t h, void* key) {
    while (node != NULL) {
        if (node->kind == 1) {
            int cnt = (int)node->used;
            for (int i = 0; i < cnt; i++) {
                if (resid_key_eq(node->slot[2 * i], key))
                    return node->slot[2 * i + 1];
            }
            return NULL;
        }
        uint32_t idx = (uint32_t)((h >> (level * HT_SHIFT)) & HT_MASK);
        uint32_t bit = (1u << idx);
        if (!(node->used & bit)) return NULL;
        if (node->sub[idx]) {
            node = (HMNode*)node->slot[idx];
            level++;
            continue;
        }
        HMPair* p = (HMPair*)node->slot[idx];
        return resid_key_eq(p->key, key) ? p->val : NULL;
    }
    return NULL;
}

static int trie_contains(HMNode* node, int level, uint64_t h, void* key) {
    while (node != NULL) {
        if (node->kind == 1) {
            int cnt = (int)node->used;
            for (int i = 0; i < cnt; i++) {
                if (resid_key_eq(node->slot[2 * i], key)) return 1;
            }
            return 0;
        }
        uint32_t idx = (uint32_t)((h >> (level * HT_SHIFT)) & HT_MASK);
        uint32_t bit = (1u << idx);
        if (!(node->used & bit)) return 0;
        if (node->sub[idx]) {
            node = (HMNode*)node->slot[idx];
            level++;
            continue;
        }
        return resid_key_eq(((HMPair*)node->slot[idx])->key, key);
    }
    return 0;
}

/* Remove key from `node` at `level`, returning a new persistent node.
 * `did` (out) is 1 if the key was actually removed. If absent, returns
 * the ORIGINAL node unchanged (shared) and *did = 0. */
static HMNode* trie_remove(HMNode* node, int level, uint64_t h, void* key, int* did) {
    if (node == NULL) { *did = 0; return NULL; }
    if (node->kind == 1) {
        int cnt = (int)node->used;
        for (int i = 0; i < cnt; i++) {
            if (resid_key_eq(node->slot[2 * i], key)) {
                HMNode* n = node_clone(node);
                for (int j = i; j < cnt - 1; j++) {
                    n->slot[2 * j] = n->slot[2 * (j + 1)];
                    n->slot[2 * j + 1] = n->slot[2 * (j + 1) + 1];
                }
                n->used = (uint32_t)(cnt - 1);
                *did = 1;
                return n;
            }
        }
        *did = 0;
        return node;
    }
    uint32_t idx = (uint32_t)((h >> (level * HT_SHIFT)) & HT_MASK);
    uint32_t bit = (1u << idx);
    if (!(node->used & bit)) { *did = 0; return node; }
    if (node->sub[idx]) {
        HMNode* child = (HMNode*)node->slot[idx];
        HMNode* newchild = trie_remove(child, level + 1, h, key, did);
        if (!*did) return node;
        HMNode* n = node_clone(node);
        if (newchild == NULL || newchild->used == 0) {
            n->used &= ~bit; /* collapsed child: drop the slot */
            n->sub[idx] = 0;
            n->slot[idx] = NULL;
        } else {
            n->slot[idx] = newchild;
        }
        return n;
    }
    HMPair* p = (HMPair*)node->slot[idx];
    if (resid_key_eq(p->key, key)) {
        HMNode* n = node_clone(node);
        n->used &= ~bit;
        n->sub[idx] = 0;
        n->slot[idx] = NULL;
        *did = 1;
        return n;
    }
    *did = 0;
    return node;
}

/* Collect all (key, val) into flat arrays starting at *idx. Pass NULL for
 * either array to skip that field. */
static void trie_collect(HMNode* node, void** keys, void** vals, int64_t* idx) {
    if (node == NULL) return;
    if (node->kind == 1) {
        int cnt = (int)node->used;
        for (int i = 0; i < cnt; i++) {
            if (keys) keys[*idx] = node->slot[2 * i];
            if (vals) vals[*idx] = node->slot[2 * i + 1];
            (*idx)++;
        }
        return;
    }
    for (int i = 0; i < HT_DEGREE; i++) {
        if (node->used & (1u << i)) {
            if (node->sub[i]) {
                trie_collect((HMNode*)node->slot[i], keys, vals, idx);
            } else {
                HMPair* p = (HMPair*)node->slot[i];
                if (keys) keys[*idx] = p->key;
                if (vals) vals[*idx] = p->val;
                (*idx)++;
            }
        }
    }
}

/* ── Table mode (see HMTrie) ──────────────────────────────────────────
 *
 * Keys and values are 64-bit words tagged by a kind the compiler passes
 * from the static types: key kind 1 = raw Int, 0 = boxed value pointer;
 * value kind 1 = raw Int, 2 = raw Float bits, 3 = raw Bool, 0 = boxed
 * pointer (or a set's opaque marker); -1 = not decided yet (empty table:
 * the first update decides). A request in another kind is converted, so a
 * mismatch is only ever slower, never wrong.
 *
 * Layout: open addressing with linear probing over a dense key array and a
 * parallel value array, at most half full. Free and deleted slots are
 * marked by sentinel keys (0 / 1 for pointers, which are never those
 * values; INT64_MIN / INT64_MIN + 1 for raw Ints, whose entries, if those
 * keys are ever used, live in two out-of-band slots). */
struct MapTab {
    int64_t cap;   /* power of two */
    int64_t live;  /* entries, including out-of-band ones */
    int64_t tombs;
    int8_t kkind;
    int8_t vkind;
    uint64_t* keys; /* NULL while kkind is undecided */
    uint64_t* vals;
    int8_t oob_has[2];
    uint64_t oob_val[2];
    /* Last raw-key probe (lvalid): `m.insert(k, (m.get(k) else {..}) + 1)`
     * then reuses the lookup's slot instead of probing again. Only the
     * owning loop's transient table uses it; any other change clears it. */
    int8_t lvalid;
    uint64_t lkey;
    int64_t lres; /* slot of lkey, or -(free slot + 1) when absent */
};

#define MT_RAW_EMPTY 0x8000000000000000ULL
#define MT_RAW_TOMB 0x8000000000000001ULL

static HMNode* map_root(HMTrie* m);
void* resid_map_insert(void* map, void* key, void* val);
void* resid_map_remove(void* map, void* key);

static inline uint64_t mt_empty(const MapTab* t) { return t->kkind == 1 ? MT_RAW_EMPTY : 0; }
static inline uint64_t mt_tomb(const MapTab* t) { return t->kkind == 1 ? MT_RAW_TOMB : 1; }

static inline uint64_t mt_mix(uint64_t k) {
    k ^= k >> 33;
    k *= 0xff51afd7ed558ccdULL;
    k ^= k >> 33;
    return k;
}

static int box_is_i64(const void* p) {
    const ResidVal* b = (const ResidVal*)p;
    return is_boxed(p) && b->tag == -1 && b->type && strcmp(b->type, "i64") == 0;
}

static inline uint64_t mt_hash(const MapTab* t, uint64_t kb) {
    return t->kkind == 1 ? mt_mix(kb) : resid_hash((void*)(uintptr_t)kb);
}

static inline int mt_keq(const MapTab* t, uint64_t a, uint64_t b) {
    if (t->kkind == 1) return a == b;
    return resid_key_eq((void*)(uintptr_t)a, (void*)(uintptr_t)b);
}

/* Out-of-band index (0/1) of a raw key equal to a sentinel, else -1. */
static inline int mt_oob(const MapTab* t, uint64_t k) {
    if (t->kkind != 1) return -1;
    if (k == MT_RAW_EMPTY) return 0;
    if (k == MT_RAW_TOMB) return 1;
    return -1;
}

static void mt_alloc(MapTab* t, int64_t cap) {
    t->cap = cap;
    t->keys = (uint64_t*)malloc((size_t)cap * sizeof(uint64_t));
    t->vals = (uint64_t*)malloc((size_t)cap * sizeof(uint64_t));
    if (!t->keys || !t->vals) resid_abort("map table: out of memory");
    uint64_t e = mt_empty(t);
    for (int64_t i = 0; i < cap; i++) t->keys[i] = e;
}

static MapTab* mt_new(int64_t cap, int8_t kk, int8_t vk) {
    MapTab* t = (MapTab*)calloc(1, sizeof(MapTab));
    if (!t) resid_abort("map table: out of memory");
    t->cap = cap;
    t->kkind = kk;
    t->vkind = vk;
    if (kk != -1) mt_alloc(t, cap);
    return t;
}

/* Slot of key `k` (already in the table's key kind, not a sentinel), or
 * -(first free slot + 1). */
static inline int64_t mt_probe(const MapTab* t, uint64_t k) {
    uint64_t mask = (uint64_t)t->cap - 1;
    uint64_t e = mt_empty(t), tb = mt_tomb(t);
    for (uint64_t i = mt_hash(t, k) & mask;; i = (i + 1) & mask) {
        uint64_t s = t->keys[i];
        if (s == e) return -(int64_t)i - 1;
        if (s != tb && mt_keq(t, s, k)) return (int64_t)i;
    }
}

/* mt_probe for a raw Int table, through the last-probe cache. */
static inline int64_t mt_probe_raw_cached(MapTab* t, uint64_t k) {
    if (t->lvalid && t->lkey == k) return t->lres;
    uint64_t mask = (uint64_t)t->cap - 1;
    int64_t r;
    for (uint64_t i = mt_mix(k) & mask;; i = (i + 1) & mask) {
        uint64_t s = t->keys[i];
        if (s == MT_RAW_EMPTY) { r = -(int64_t)i - 1; break; }
        if (s == k) { r = (int64_t)i; break; }
    }
    t->lvalid = 1;
    t->lkey = k;
    t->lres = r;
    return r;
}

/* Iterate live entries: *idx starts at 0; returns 0 when done. */
static int mt_next(const MapTab* t, int64_t* idx, uint64_t* k, uint64_t* v) {
    while (*idx < t->cap) {
        int64_t i = (*idx)++;
        if (!t->keys) { *idx = t->cap; break; }
        uint64_t s = t->keys[i];
        if (s == mt_empty(t) || s == mt_tomb(t)) continue;
        *k = s;
        *v = t->vals[i];
        return 1;
    }
    while (*idx < t->cap + 2) {
        int o = (int)((*idx)++ - t->cap);
        if (!t->oob_has[o]) continue;
        *k = o == 0 ? MT_RAW_EMPTY : MT_RAW_TOMB;
        *v = t->oob_val[o];
        return 1;
    }
    return 0;
}

static void mt_insert_new(MapTab* t, uint64_t k, uint64_t v);

/* Rebuild into `cap` slots with key kind `kk` (keys already converted by
 * `conv`, which may be NULL). */
static void mt_rebuild(MapTab* t, int64_t cap, int8_t kk, uint64_t (*conv)(int8_t, uint64_t)) {
    MapTab old = *t;
    t->kkind = kk;
    t->live = 0;
    t->tombs = 0;
    t->oob_has[0] = t->oob_has[1] = 0;
    t->lvalid = 0;
    mt_alloc(t, cap);
    int64_t it = 0;
    uint64_t k, v;
    while (mt_next(&old, &it, &k, &v)) mt_insert_new(t, conv ? conv(old.kkind, k) : k, v);
    free(old.keys);
    free(old.vals);
}

/* Insert a key known to be absent. */
static void mt_insert_new(MapTab* t, uint64_t k, uint64_t v) {
    int o = mt_oob(t, k);
    if (o >= 0) { t->oob_has[o] = 1; t->oob_val[o] = v; t->live++; return; }
    if ((t->live + t->tombs + 1) * 2 > t->cap) mt_rebuild(t, t->live * 4 > t->cap ? t->cap * 2 : t->cap, t->kkind, NULL);
    int64_t r = mt_probe(t, k);
    t->keys[-r - 1] = k;
    t->vals[-r - 1] = v;
    t->live++;
    t->lvalid = 0;
}

/* Box a stored word of kind `k` into a Resid value pointer. */
static uint64_t mt_box(int8_t k, uint64_t w) {
    switch (k) {
    case 1: return (uint64_t)(uintptr_t)resid_box_i64((int64_t)w);
    case 2: { double d; memcpy(&d, &w, 8); return (uint64_t)(uintptr_t)resid_box_f64(d); }
    case 3: return (uint64_t)(uintptr_t)resid_box_bool((int8_t)(w != 0));
    default: return w;
    }
}

/* Unbox a boxed value pointer to kind `k` (1/2/3), or 0 when the box does
 * not hold that kind. */
static int mt_unbox(int8_t k, uint64_t w, uint64_t* out) {
    void* p = (void*)(uintptr_t)w;
    if (!p || !is_boxed(p) || ((ResidVal*)p)->tag != -1 || !((ResidVal*)p)->type) return 0;
    const char* ty = ((ResidVal*)p)->type;
    if (k == 1 && strcmp(ty, "i64") == 0) { *out = (uint64_t)resid_unbox_i64(p); return 1; }
    if (k == 2 && strcmp(ty, "f64") == 0) { double d = resid_unbox_f64(p); memcpy(out, &d, 8); return 1; }
    if (k == 3 && strcmp(ty, "bool") == 0) { *out = (uint64_t)resid_unbox_bool(p); return 1; }
    return 0;
}

static void mt_decide(MapTab* t, int8_t kk, int8_t vk) {
    if (t->vkind == -1) t->vkind = vk;
    if (t->kkind == -1) { t->kkind = kk; mt_alloc(t, t->cap); }
}

/* Store every value boxed from now on. */
static void mt_vals_boxed(MapTab* t) {
    int64_t it = 0;
    uint64_t k, v;
    for (int64_t i = 0; i < t->cap; i++) {
        uint64_t s = t->keys[i];
        if (s != mt_empty(t) && s != mt_tomb(t)) t->vals[i] = mt_box(t->vkind, t->vals[i]);
    }
    for (int o = 0; o < 2; o++) if (t->oob_has[o]) t->oob_val[o] = mt_box(t->vkind, t->oob_val[o]);
    (void)it; (void)k; (void)v;
    t->vkind = 0;
}

/* Bring a request key of kind `rk` to the table's key kind. */
static uint64_t mt_key_in(MapTab* t, int8_t rk, uint64_t kb) {
    if (t->kkind == rk) return kb;
    if (t->kkind == 0) return mt_box(rk, kb);
    uint64_t raw;
    if (mt_unbox(t->kkind, kb, &raw)) return raw;
    mt_rebuild(t, t->cap, 0, mt_box); /* keys of another type: go boxed */
    return kb;
}

static uint64_t mt_val_in(MapTab* t, int8_t rk, uint64_t vb) {
    if (t->vkind == rk) return vb;
    if (t->vkind == 0) return mt_box(rk, vb);
    uint64_t raw;
    if (rk == 0 && mt_unbox(t->vkind, vb, &raw)) return raw;
    mt_vals_boxed(t);
    return mt_box(rk, vb);
}

static uint64_t mt_val_out(const MapTab* t, int8_t want, uint64_t w) {
    if (t->vkind == want || t->vkind == -1) return w;
    if (want == 0) return mt_box(t->vkind, w);
    uint64_t raw = 0;
    if (t->vkind == 0 && mt_unbox(want, w, &raw)) return raw;
    return w;
}

/* Pointer to the value of a request key, or NULL. Never converts. */
static uint64_t* mt_vref(MapTab* t, int8_t rk, uint64_t kb) {
    if (t->live == 0 || !t->keys) return NULL;
    uint64_t k = kb;
    if (t->kkind != rk) {
        if (t->kkind == 0) {
            if (rk != 1) return NULL;
            k = (uint64_t)(uintptr_t)resid_box_i64((int64_t)kb);
        } else if (!mt_unbox(t->kkind, kb, &k)) {
            return NULL;
        }
    }
    int o = mt_oob(t, k);
    if (o >= 0) return t->oob_has[o] ? &t->oob_val[o] : NULL;
    int64_t r = mt_probe(t, k);
    return r >= 0 ? &t->vals[r] : NULL;
}

static void mt_put(MapTab* t, int8_t kk, uint64_t kb, int8_t vk, uint64_t vb) {
    mt_decide(t, kk, vk);
    uint64_t k = mt_key_in(t, kk, kb);
    uint64_t v = mt_val_in(t, vk, vb);
    uint64_t* at = mt_vref(t, t->kkind, k);
    if (at) { *at = v; return; }
    mt_insert_new(t, k, v);
}

static int mt_del(MapTab* t, int8_t kk, uint64_t kb) {
    if (t->live == 0 || !t->keys) return 0;
    uint64_t k = kb;
    if (t->kkind != kk) {
        if (t->kkind == 0) k = mt_box(kk, kb);
        else if (!mt_unbox(t->kkind, kb, &k)) return 0;
    }
    t->lvalid = 0;
    int o = mt_oob(t, k);
    if (o >= 0) {
        if (!t->oob_has[o]) return 0;
        t->oob_has[o] = 0;
        t->live--;
        return 1;
    }
    int64_t r = mt_probe(t, k);
    if (r < 0) return 0;
    t->keys[r] = mt_tomb(t);
    t->live--;
    t->tombs++;
    return 1;
}

/* The canonical trie holding the same entries: cached on a frozen table,
 * rebuilt for a transient one (whose table may still change). */
static HMNode* map_root(HMTrie* m) {
    if (!m->tab) return m->root;
    if (!m->transient) {
        HMNode* c = __atomic_load_n(&m->root, __ATOMIC_ACQUIRE);
        if (c || m->count == 0) return c;
    }
    MapTab* t = m->tab;
    HMNode* root = NULL;
    int64_t it = 0;
    uint64_t kw, vw;
    /* A frozen table caches the trie on itself, so it must outlive any
     * arena or scalar scope open now: build it on the plain heap. */
    int cache = !m->transient;
    AllocSuspend sus;
    if (cache) sus = alloc_suspend();
    while (mt_next(t, &it, &kw, &vw)) {
        void* k = (void*)(uintptr_t)mt_box(t->kkind, kw);
        void* v = (void*)(uintptr_t)mt_box(t->vkind, vw);
        int isnew = 0;
        root = trie_insert(root, 0, resid_hash(k), k, v, &isnew);
    }
    if (cache) alloc_resume(sus);
    if (!m->transient) {
        HMNode* expect = NULL;
        if (!__atomic_compare_exchange_n(&m->root, &expect, root, 0, __ATOMIC_ACQ_REL, __ATOMIC_ACQUIRE))
            root = expect; /* another thread cached an identical trie first */
    }
    return root;
}

static void map_free_parts(HMTrie* m) {
    if (m->tab) {
        free(m->tab->keys);
        free(m->tab->vals);
        free(m->tab);
    }
    free_hmnode(m->root);
}

#define MAP_TRANSIENT_COPY_MAX 64

/* Entry of a proven linear accumulator loop: an exclusively owned, mutable
 * table holding the same entries as `map`. `map` itself is untouched. */
void* resid_map_transient(void* map) {
    HMTrie* src = (HMTrie*)map;
    /* Entering the loop copies the incoming map. For a big trie that copy
     * could cost more than the loop saves (a few inserts into a large map),
     * so such a loop just keeps using ordinary persistent updates: handing
     * back the untouched persistent map makes every owned update take the
     * persistent path. */
    if (!src->tab && src->count > MAP_TRANSIENT_COPY_MAX) return map;
    HMTrie* m = trie_new(src->count, NULL);
    m->transient = 1;
    if (src->tab) {
        MapTab* s = src->tab;
        MapTab* t = (MapTab*)malloc(sizeof(MapTab));
        if (!t) resid_abort("map table: out of memory");
        *t = *s;
        t->lvalid = 0;
        if (s->keys) {
            t->keys = (uint64_t*)malloc((size_t)s->cap * sizeof(uint64_t));
            t->vals = (uint64_t*)malloc((size_t)s->cap * sizeof(uint64_t));
            if (!t->keys || !t->vals) resid_abort("map table: out of memory");
            memcpy(t->keys, s->keys, (size_t)s->cap * sizeof(uint64_t));
            memcpy(t->vals, s->vals, (size_t)s->cap * sizeof(uint64_t));
        }
        m->tab = t;
        return m;
    }
    int64_t n = src->count;
    int64_t cap = 16;
    while (cap < (n + 1) * 2) cap *= 2;
    m->tab = mt_new(cap, n == 0 ? -1 : 0, n == 0 ? -1 : 0);
    if (n > 0) {
        void** ks = (void**)malloc((size_t)n * sizeof(void*));
        void** vs = (void**)malloc((size_t)n * sizeof(void*));
        int64_t j = 0;
        trie_collect(src->root, ks, vs, &j);
        for (int64_t i = 0; i < n; i++)
            mt_put(m->tab, 0, (uint64_t)(uintptr_t)ks[i], 0, (uint64_t)(uintptr_t)vs[i]);
        free(ks);
        free(vs);
    }
    return m;
}

/* The loop is done with it: from here on the table is an ordinary
 * immutable map value. */
void* resid_map_freeze(void* map) {
    HMTrie* m = (HMTrie*)map;
    if (m->transient) m->transient = 0;
    return map;
}

static __attribute__((noinline)) void* map_put_slow(HMTrie* m, int8_t owned, int8_t kk, int64_t kb, int8_t vk, int64_t vb) {
    if (owned && m->transient) {
        m->tab->lvalid = 0;
        mt_put(m->tab, kk, (uint64_t)kb, vk, (uint64_t)vb);
        m->count = m->tab->live;
        return m;
    }
    return resid_map_insert(m, (void*)(uintptr_t)mt_box(kk, (uint64_t)kb), (void*)(uintptr_t)mt_box(vk, (uint64_t)vb));
}

/* Typed insert. `owned` is set by codegen only for the consuming update of
 * a proven linear accumulator; on a transient table that updates in place.
 * Every other case is the ordinary persistent insert. */
__attribute__((always_inline)) void* resid_map_put(void* map, int8_t owned, int8_t kk, int64_t kb, int8_t vk, int64_t vb) {
    HMTrie* m = (HMTrie*)map;
    MapTab* t = m->tab;
    uint64_t k = (uint64_t)kb;
    if (owned && m->transient && kk == 1 && t->kkind == 1 && t->vkind == vk && (k >> 1) != (MT_RAW_EMPTY >> 1)) {
        int64_t r = mt_probe_raw_cached(t, k);
        if (r >= 0) { t->vals[r] = (uint64_t)vb; return m; }
        if ((t->live + t->tombs + 1) * 2 <= t->cap) {
            t->keys[-r - 1] = k;
            t->vals[-r - 1] = (uint64_t)vb;
            t->live++;
            t->lres = -r - 1; /* the cached key now lives there */
            m->count = t->live;
            return m;
        }
    }
    return map_put_slow(m, owned, kk, kb, vk, vb);
}

void* resid_map_del(void* map, int8_t owned, int8_t kk, int64_t kb) {
    HMTrie* m = (HMTrie*)map;
    if (owned && m->transient) {
        mt_del(m->tab, kk, (uint64_t)kb);
        m->count = m->tab->live;
        return m;
    }
    return resid_map_remove(map, (void*)(uintptr_t)mt_box(kk, (uint64_t)kb));
}

void* resid_set_put(void* set, int8_t owned, int8_t kk, int64_t kb) {
    return resid_map_put(set, owned, kk, kb, 0, 1);
}

/* Typed lookup: {value word of kind `vk`, found}. No allocation on the
 * table path, so `m.get(k) else { d }` on an Int-keyed map is a probe. */
typedef struct { int64_t val; int64_t found; } MapFind;

static __attribute__((noinline)) MapFind map_find_slow(HMTrie* m, int8_t kk, int64_t kb, int8_t vk) {
    MapFind r = { 0, 0 };
    if (m->tab) {
        uint64_t* at = mt_vref(m->tab, kk, (uint64_t)kb);
        if (!at) return r;
        r.val = (int64_t)mt_val_out(m->tab, vk, *at);
        r.found = 1;
        return r;
    }
    void* key = (void*)(uintptr_t)mt_box(kk, (uint64_t)kb);
    void* v = trie_get(m->root, 0, resid_hash(key), key);
    if (!v) return r;
    uint64_t w = (uint64_t)(uintptr_t)v;
    if (vk != 0 && !mt_unbox(vk, w, &w)) return r;
    r.val = (int64_t)w;
    r.found = 1;
    return r;
}

__attribute__((always_inline)) MapFind resid_map_find(void* map, int8_t kk, int64_t kb, int8_t vk) {
    HMTrie* m = (HMTrie*)map;
    MapTab* t = m->tab;
    uint64_t k = (uint64_t)kb;
    /* A frozen table may be read by several threads, so only the owning
     * loop's transient table goes through the last-probe cache. */
    if (m->transient && kk == 1 && t->kkind == 1 && t->vkind == vk && (k >> 1) != (MT_RAW_EMPTY >> 1)) {
        MapFind r = { 0, 0 };
        int64_t at = mt_probe_raw_cached(t, k);
        if (at >= 0) { r.val = (int64_t)t->vals[at]; r.found = 1; }
        return r;
    }
    return map_find_slow(m, kk, kb, vk);
}

int8_t resid_map_has(void* map, int8_t kk, int64_t kb) {
    HMTrie* m = (HMTrie*)map;
    if (m->tab) return mt_vref(m->tab, kk, (uint64_t)kb) != NULL;
    void* key = (void*)(uintptr_t)mt_box(kk, (uint64_t)kb);
    return trie_contains(m->root, 0, resid_hash(key), key) ? 1 : 0;
}

/* Lookup a key in the map. Returns the value or NULL. */
void* resid_map_get(void* map, void* key) {
    HMTrie* t = (HMTrie*)map;
    if (t->tab) {
        uint64_t* at = mt_vref(t->tab, 0, (uint64_t)(uintptr_t)key);
        return at ? (void*)(uintptr_t)mt_val_out(t->tab, 0, *at) : NULL;
    }
    uint64_t h = resid_hash(key);
    return trie_get(map_root(t), 0, h, key);
}

/* Insert a key-value pair, returning a NEW map (immutable). */
void* resid_map_insert(void* map, void* key, void* val) {
    HMTrie* t = (HMTrie*)map;
    uint64_t h = resid_hash(key);
    int isnew = 0;
    HMNode* root = trie_insert(map_root(t), 0, h, key, val, &isnew);
    return trie_new(t->count + (isnew ? 1 : 0), root);
}

/* Remove a key, returning a NEW map (or the same map if key absent). */
void* resid_map_remove(void* map, void* key) {
    HMTrie* t = (HMTrie*)map;
    uint64_t h = resid_hash(key);
    int did = 0;
    HMNode* base = map_root(t);
    HMNode* root = trie_remove(base, 0, h, key, &did);
    /* unchanged: share — but never hand out a transient table itself, which
     * its owning loop may still update in place */
    if (!did) return t->transient ? (void*)trie_new(t->count, base) : map;
    return trie_new(t->count - 1, root);
}

/* Check if a key exists. Returns 1/0. */
int8_t resid_map_contains(void* map, void* key) {
    HMTrie* t = (HMTrie*)map;
    if (t->tab) return mt_vref(t->tab, 0, (uint64_t)(uintptr_t)key) != NULL;
    uint64_t h = resid_hash(key);
    return trie_contains(map_root(t), 0, h, key) ? 1 : 0;
}

/* Number of entries. */
int64_t resid_map_len(void* map) {
    return ((HMTrie*)map)->count;
}

/* Build a List of keys. Returns a trie-backed list. */
void* resid_map_keys(void* map) {
    HMTrie* m = (HMTrie*)map;
    int64_t n = m->count;
    void** ks = NULL;
    if (n > 0) ks = (void**)malloc((size_t)n * sizeof(void*));
    int64_t j = 0;
    trie_collect(map_root(m), ks, NULL, &j);
    void* r = resid_list_new(n, ks, "list");
    free(ks);
    return r;
}

/* Build a List of values. */
void* resid_map_values(void* map) {
    HMTrie* m = (HMTrie*)map;
    int64_t n = m->count;
    void** vs = NULL;
    if (n > 0) vs = (void**)malloc((size_t)n * sizeof(void*));
    int64_t j = 0;
    trie_collect(map_root(m), NULL, vs, &j);
    void* r = resid_list_new(n, vs, "list");
    free(vs);
    return r;
}

/* Format a map as a string: {key1: val1, key2: val2}. Uses resid_format_val
 * on each entry. Caller must free the returned string. */
char* resid_map_format(void* map) {
    HMTrie* m = (HMTrie*)map;
    if (m->count == 0) {
        char* r = (char*)malloc(3);
        r[0] = '{'; r[1] = '}'; r[2] = '\0';
        return r;
    }
    /* Estimate: ~20 chars per entry. */
    size_t cap = 2 + (size_t)m->count * 40 + 1;
    char* buf = (char*)malloc(cap);
    size_t pos = 0;
    buf[pos++] = '{';
    int64_t n = m->count;
    void** ks = (void**)malloc((size_t)n * sizeof(void*));
    void** vs = (void**)malloc((size_t)n * sizeof(void*));
    int64_t j = 0;
    trie_collect(map_root(m), ks, vs, &j);
    for (int64_t i = 0; i < n; i++) {
        if (i > 0) { buf[pos++] = ','; buf[pos++] = ' '; }
        /* Key: assume string. */
        const char* ks0 = (const char*)ks[i];
        if (resid_box_tag(ks[i]) == -1) {
            ks0 = (const char*)resid_box_slot(ks[i], 0);
        }
        size_t kl = strlen(ks0);
        if (pos + kl + 4 >= cap) { cap = cap * 2 + kl; buf = realloc(buf, cap); }
        memcpy(buf + pos, ks0, kl); pos += kl;
        buf[pos++] = ':';
        buf[pos++] = ' ';
        /* Value: assume string. */
        const char* vs0 = (const char*)vs[i];
        if (resid_box_tag(vs[i]) == -1) {
            vs0 = (const char*)resid_box_slot(vs[i], 0);
        }
        size_t vl = strlen(vs0);
        if (pos + vl + 2 >= cap) {
            if (cap > SIZE_MAX / 2) resid_abort("resid_map_format: size overflow");
            cap = cap * 2 + vl;
            char* nb = (char*)realloc(buf, cap);
            if (!nb) resid_abort("resid_map_format: out of memory");
            buf = nb;
        }
        memcpy(buf + pos, vs0, vl); pos += vl;
    }
    free(ks);
    free(vs);
    buf[pos++] = '}';
    buf[pos] = '\0';
    return buf;
}

/* ─── Set operations (sets are maps with value 1) ─────────────────── */

void* resid_set_new(void) {
    return trie_new(0, NULL);
}

/* Insert an element into a set. Returns a NEW set. */
void* resid_set_insert(void* set, void* elem) {
    return resid_map_insert(set, elem, (void*)(intptr_t)1);
}

void* resid_set_remove(void* set, void* elem) {
    return resid_map_remove(set, elem);
}

int8_t resid_set_contains(void* set, void* elem) {
    return resid_map_contains(set, elem);
}

int64_t resid_set_len(void* set) {
    return resid_map_len(set);
}

/* Set union: elements from both sets. */
void* resid_set_union(void* a, void* b) {
    HMTrie* tb = (HMTrie*)b;
    int64_t n = tb->count;
    void** ks = NULL;
    if (n > 0) ks = (void**)malloc((size_t)n * sizeof(void*));
    int64_t j = 0;
    trie_collect(map_root(tb), ks, NULL, &j);
    void* result = a;
    for (int64_t i = 0; i < n; i++) {
        result = resid_set_insert(result, ks[i]);
    }
    free(ks);
    return result;
}

/* Set difference: elements in a but not in b. */
void* resid_set_difference(void* a, void* b) {
    HMTrie* tb = (HMTrie*)b;
    int64_t n = tb->count;
    void** ks = NULL;
    if (n > 0) ks = (void**)malloc((size_t)n * sizeof(void*));
    int64_t j = 0;
    trie_collect(map_root(tb), ks, NULL, &j);
    void* result = a;
    for (int64_t i = 0; i < n; i++) {
        result = resid_set_remove(result, ks[i]);
    }
    free(ks);
    return result;
}

/* Set intersection: elements in both sets. */
void* resid_set_intersection(void* a, void* b) {
    HMTrie* ta = (HMTrie*)a;
    HMTrie* tb = (HMTrie*)b;
    /* Iterate over the smaller set. */
    HMTrie* smaller = ta->count <= tb->count ? ta : tb;
    HMTrie* larger = ta->count <= tb->count ? tb : ta;
    int64_t n = smaller->count;
    void** ks = NULL;
    if (n > 0) ks = (void**)malloc((size_t)n * sizeof(void*));
    int64_t j = 0;
    trie_collect(map_root(smaller), ks, NULL, &j);
    void* result = (void*)smaller;
    for (int64_t i = 0; i < n; i++) {
        if (!resid_map_contains(larger, ks[i])) {
            result = resid_set_remove(result, ks[i]);
        }
    }
    free(ks);
    return result;
}

/* Convert a set to a list. */
void* resid_set_to_list(void* set) {
    return resid_map_keys(set);
}

/* Format a set as a string: {elem1, elem2, ...}. */
char* resid_set_format(void* set) {
    HMTrie* m = (HMTrie*)set;
    if (m->count == 0) {
        char* r = (char*)malloc(3);
        r[0] = '{'; r[1] = '}'; r[2] = '\0';
        return r;
    }
    size_t cap = 2 + (size_t)m->count * 20 + 1;
    char* buf = (char*)malloc(cap);
    size_t pos = 0;
    buf[pos++] = '{';
    int64_t n = m->count;
    void** ks = (void**)malloc((size_t)n * sizeof(void*));
    int64_t j = 0;
    trie_collect(map_root(m), ks, NULL, &j);
    for (int64_t i = 0; i < n; i++) {
        if (i > 0) { buf[pos++] = ','; buf[pos++] = ' '; }
        const char* es = (const char*)ks[i];
        if (resid_box_tag(ks[i]) == -1) {
            es = (const char*)resid_box_slot(ks[i], 0);
        }
        size_t el = strlen(es);
        if (pos + el + 2 >= cap) {
            if (cap > SIZE_MAX / 2) resid_abort("resid_set_format: size overflow");
            cap = cap * 2 + el;
            char* nb = (char*)realloc(buf, cap);
            if (!nb) resid_abort("resid_set_format: out of memory");
            buf = nb;
        }
        memcpy(buf + pos, es, el); pos += el;
    }
    free(ks);
    buf[pos++] = '}';
    buf[pos] = '\0';
    return buf;
}
