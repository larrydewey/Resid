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
#include <fcntl.h>
#include <errno.h>
#include <dirent.h>
#include <libgen.h>
#include <sys/wait.h>
#include <sys/ptrace.h>
#include <sys/user.h>
#include <sys/personality.h>
#include <signal.h>

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
void resid_str_index_popped(void);
#define str_index_arena_popped resid_str_index_popped

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

int8_t resid_rt_arena_contains(const void* p);
static int arena_contains(const void* p) {
    /* Every active arena, not just the innermost (a string from an outer
     * arena must not enter the persistent cache either), the bulk arenas,
     * and the scalar-scope region. */
    return arena_chain_contains(g_current_arena, p) || arena_chain_contains(g_bulk_arena, p) || scope_contains(p);
}

int8_t resid_rt_arena_contains(const void* p) { return (int8_t)arena_contains(p); }

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

/* Struct records. Each carries a header word before its fields: a tag
 * (REC_TAG << 32), its size in bytes << 1, and a UNIQUE bit, set when the
 * compiler's ownership analysis proved the record referred to from one
 * place only (the literal starts an ownership chain) and cleared when it
 * leaves one (resid_rec_share). A returned literal may then take over a
 * dead variable's unique record instead of allocating (resid_rec_reuse).
 * A struct stored inline in a sum value has no header; the tag keeps these
 * from ever being read as unique or written. */
#define REC_TAG 0x5245C0DEULL

void* resid_rec_new(int64_t size, int8_t unique) {
    uint64_t* h = (uint64_t*)resid_gmalloc(size + 8);
    h[0] = (REC_TAG << 32) | ((uint64_t)size << 1) | (uint64_t)(unique != 0);
    return h + 1;
}

void* resid_rec_reuse(void* old, int64_t size) {
    uint64_t* h = (uint64_t*)old - 1;
    if (*h == ((REC_TAG << 32) | ((uint64_t)size << 1) | 1)) return old;
    return resid_rec_new(size, 1);
}

void resid_rec_share(void* rec) {
    uint64_t* h = (uint64_t*)rec - 1;
    uint64_t v = *h;
    if ((v >> 32) == REC_TAG && (v & 1)) *h = v & ~(uint64_t)1;
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

/* resid_alloc and the arena test for the Resid runtime. */
void* resid_rt_alloc(int64_t n) { return resid_alloc((size_t)n); }
int8_t resid_rt_arena_contains(const void* p);



/* print / println / eprintln: runtime/rt/io.resid. */

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

/* The quiet / internals / runtime-module flags: runtime/rt/io.resid. */
int8_t resid_regex_match(const char* pattern, const char* text);

/* The regex subset (resid_regex_match): runtime/rt/regex.resid. */

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

/* The force-time capability guard: runtime/rt/caps.resid. */

static char* resid_box_str(const char* s) {
    size_t n = strlen(s);
    char* p = (char*)malloc(n + 1);
    if (!p) resid_abort("resid_box_str: out of memory");
    memcpy(p, s, n + 1);
    return p;
}

/* resid_str_concat, the resid_sacc_* accumulators, resid_str_to_fixed,
 * resid_bytes_to_fixed and resid_str_eq: runtime/rt/text.resid. */
char* resid_str_concat(const char* a, const char* b);
int64_t str_len(const char* s);
int64_t str_char_at(const char* s, int64_t i);
char* str_slice(const char* s, int64_t start, int64_t end);
int64_t str_index_of(const char* s, const char* needle, int64_t from);
char* str_from_code(int64_t cp);
void resid_str_index_popped(void);
#define str_index_arena_popped resid_str_index_popped

/* UTF-8 decoding helpers for the string introspection functions. */
static int utf8_seq_len(const unsigned char c) {
    if (c < 0x80) return 1;
    if ((c & 0xE0) == 0xC0) return 2;
    if ((c & 0xF0) == 0xE0) return 3;
    if ((c & 0xF8) == 0xF0) return 4;
    return 1; /* invalid continuation byte — treat as 1 */
}

/* The length of the sequence at `p`, cut short at the first byte that is
 * not a continuation byte: a truncated or invalid sequence (including one
 * cut off by the terminating NUL) never steps past the string's end. */
static inline int utf8_len_at(const unsigned char* p) {
    int n = utf8_seq_len(p[0]);
    for (int k = 1; k < n; k++)
        if ((p[k] & 0xC0) != 0x80) return k;
    return n;
}


/* The per-string codepoint index, str_len, str_char_at, str_from_code,
 * the str_sb_* builders, resid_sb_print, str_slice and str_index_of:
 * runtime/rt/text.resid. */

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

/* Int and Float boxes are usually immediate words, not pointers. User
 * space pointers stay below 2^48 (Linux maps above 2^47 only on request;
 * resid_check_address_space enforces it), so no pointer reads as one:
 *   [2^48, 2^48 + 2^55)  an Int v in [-2^54, 2^54), stored as v + IMM_OFF;
 *   [2^56, 2^64)         a Float, its own bits (all but +0.0 and positive
 *                        magnitudes below 2^-975).
 * Other values get heap boxes. */
#define IMM_LO ((uint64_t)1 << 48)
#define IMM_OFF (IMM_LO + ((uint64_t)1 << 54))
#define FIMM_LO ((uint64_t)1 << 56)
#define IMM_MIN (-((int64_t)1 << 54))
#define IMM_MAX (((int64_t)1 << 54) - 1)
static inline int box_imm(const void* p) { return (uint64_t)(uintptr_t)p - IMM_LO < ((uint64_t)1 << 55); }
static inline int box_fimm(const void* p) { return (uint64_t)(uintptr_t)p >= FIMM_LO; }
static inline int64_t imm_val(const void* p) { return (int64_t)((uint64_t)(uintptr_t)p - IMM_OFF); }
static inline void* imm_box(int64_t v) { return (void*)(uintptr_t)((uint64_t)v + IMM_OFF); }
static inline double fimm_val(const void* p) {
    uint64_t b = (uint64_t)(uintptr_t)p;
    double d;
    memcpy(&d, &b, 8);
    return d;
}

/* A scalar box's type name ("i64", "f64", "bool", ...), or NULL. */
static inline const char* scalar_type(const void* p) {
    if (box_imm(p)) return "i64";
    if (box_fimm(p)) return "f64";
    const ResidVal* b = (const ResidVal*)p;
    return b->tag == -1 ? b->type : NULL;
}

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

int64_t resid_box_tag(void* b) { return box_imm(b) || box_fimm(b) ? -1 : ((ResidVal*)b)->tag; }

int64_t resid_box_count(void* b) { return box_imm(b) || box_fimm(b) ? 1 : ((ResidVal*)b)->count; }

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
    /* Nonzero: the `own` stamp of the one transient map slot holding this
     * header, which may then append to it in place (resid_map_list_push).
     * It fills the padding, so a header stays 32 bytes. */
    uint32_t stamp;
    PVecNode* root;
    const char* type;
} ResidList;

static ResidList* list_hdr(void) {
    ResidList* l = (ResidList*)resid_alloc(sizeof(ResidList));
    if (!l) resid_abort("list: out of memory");
    l->stamp = 0;
    return l;
}

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
    int64_t kept; /* leading slots known to hold no scope-region element */
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
    f->kept = 0;
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

static ResidList* pvec_append_into(ResidList* into, ResidList* v, void** elems, int64_t m);

static ResidList* pvec_append(ResidList* v, void** elems, int64_t m) {
    return pvec_append_into(NULL, v, elems, m);
}

/* `v` with `m` elements appended, written into the header `into` (which
 * may be `v` itself: an append in place), or a new header when NULL. */
static ResidList* pvec_append_into(ResidList* into, ResidList* v, void** elems, int64_t m) {
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
            ResidList* out = into ? into : list_hdr();
            out->type = v->type;
            out->count = n + m;
            out->shift = FLAT_SHIFT;
            out->root = (PVecNode*)dst;
            return out;
        }
    }
    ResidList* out = into ? into : list_hdr();
    if (out != v) {
        out->type = v->type;
        out->count = v->count;
        out->shift = v->shift;
        out->root = v->root;
    }
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
    ResidList* out = list_hdr();
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
    ResidList v = { 0, 0, 0, NULL, type };
    if (count == 0) {
        ResidList* e = list_hdr();
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

/* An element whose index the compiler proved in bounds (range facts). */
void* resid_list_get_nc(void* b, int64_t i) {
    return list_at((ResidList*)b, i);
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


/* ListBuf(T) (spec §45): a list header whose flat buffer is appended in
 * place. The checker guarantees each builder value is used once, so no
 * other header ever sees the buffer while it grows. */
void* resid_listbuf_new(void) {
    ResidList* l = list_hdr();
    l->count = 0;
    l->shift = FLAT_SHIFT;
    l->root = NULL;
    l->type = NULL;
    return l;
}

void* resid_listbuf_push(void* b, void* elem) {
    ResidList* l = (ResidList*)b;
    FlatBuf* f = (FlatBuf*)l->root;
    if (!f || l->count >= f->cap) {
        int64_t cap = l->count < 4 ? 8 : l->count * 2;
        FlatBuf* nf = flatbuf_new(cap);
        if (l->count > 0) memcpy(nf->items, f->items, (size_t)l->count * sizeof(void*));
        l->root = (PVecNode*)nf;
        f = nf;
    }
    f->items[l->count] = elem;
    l->count += 1;
    f->used = l->count;
    return l;
}

void* resid_listbuf_finish(void* b, const char* type) {
    ResidList* l = (ResidList*)b;
    l->type = type;
    if (l->root == NULL) l->shift = 0;
    return l;
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
    /* hi - lo in unsigned arithmetic: it may exceed INT64_MAX. */
    uint64_t un = hi > lo ? (uint64_t)hi - (uint64_t)lo : 0;
    if (un > (uint64_t)(SIZE_MAX / sizeof(void*)) / 2) resid_abort("range too large to materialize");
    int64_t n = (int64_t)un;
    void** flat = (void**)malloc((size_t)(n > 0 ? n : 1) * sizeof(void*));
    if (!flat) resid_abort("resid_range_list: out of memory");
    for (int64_t i = 0; i < n; i++) flat[i] = resid_box_i64(lo + i);
    void* out = resid_list_new(n, flat, "List(Int(64))");
    free(flat);
    return out;
}

/* lo..=hi: hi + 1 would wrap at the top of Int. */
void* resid_range_list_incl(int64_t lo, int64_t hi) {
    if (hi == INT64_MAX) resid_abort("range too large to materialize");
    return resid_range_list(lo, hi + 1);
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

/* resid_map_free / resid_set_free live in the Map/Set section. */

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
typedef struct { ResidVal v; void* slot; int8_t payload; } InternedBool;
typedef struct { ResidVal v; void* slot; double payload; } InternedF64;
_Static_assert(offsetof(InternedBool, payload) == SCALAR_PAYLOAD_OFF, "interned bool layout");
_Static_assert(offsetof(InternedF64, payload) == SCALAR_PAYLOAD_OFF, "interned f64 layout");
static InternedBool g_box_bool[2];
static InternedF64 g_box_f64z; /* 0.0 */

/* Immediate boxes need every pointer below IMM_LO: abort at startup on a
 * system that maps the stack, the heap or the program above it. */
static void resid_check_address_space(void) {
    int local = 0;
    void* heap = malloc(1);
    void* big = malloc((size_t)1 << 20); /* an mmap'd block */
    uint64_t top = (uint64_t)(uintptr_t)&local | (uint64_t)(uintptr_t)heap
        | (uint64_t)(uintptr_t)big | (uint64_t)(uintptr_t)&g_box_bool;
    free(heap);
    free(big);
    if (top >= IMM_LO) {
        fputs("resid: address space above 2^48 is not supported\n", stderr);
        abort();
    }
}

__attribute__((constructor)) static void box_intern_init(void) {
    resid_check_address_space();
    g_box_f64z.v.tag = -1;
    g_box_f64z.v.count = 1;
    g_box_f64z.v.type = "f64";
    g_box_f64z.payload = 0.0;
    g_box_f64z.slot = &g_box_f64z.payload;
    for (int i = 0; i < 2; i++) {
        InternedBool* b = &g_box_bool[i];
        b->v.tag = -1;
        b->v.count = 1;
        b->v.type = "bool";
        b->payload = (int8_t)i;
        b->slot = &b->payload;
    }
}

/* Static or immediate: nothing to free or move. */
static int box_is_interned(const void* p) {
    const char* c = (const char*)p;
    return box_imm(p) || box_fimm(p) || (c >= (const char*)g_box_bool && c < (const char*)(g_box_bool + 2))
        || c == (const char*)&g_box_f64z;
}

/* Values outside the immediate range (|v| >= 2^62) get a heap box. */
void* resid_box_i64(int64_t v) {
    if (v >= IMM_MIN && v <= IMM_MAX) return imm_box(v);
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
    if (__builtin_expect(box_imm(p), 1)) return imm_val(p);
    return *(const int64_t*)((const char*)p + SCALAR_PAYLOAD_OFF);
}

void* resid_box_f64(double v) {
    uint64_t b;
    memcpy(&b, &v, 8);
    if (b >= FIMM_LO) return (void*)(uintptr_t)b;
    if (b == 0) return &g_box_f64z.v;
    void* payload;
    ResidVal* r = (ResidVal*)resid_box_scalar_alloc(sizeof(double), _Alignof(double), &payload);
    r->type = "f64";
    *(double*)payload = v;
    return r;
}
double resid_unbox_f64(void* p) {
    if (__builtin_expect(box_fimm(p), 1)) return fimm_val(p);
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
    if (box_imm(p)) return imm_val(p);
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
    if (box_imm(p)) return (unsigned __int128)(__int128)imm_val(p);
    unsigned __int128 v;
    memcpy(&v, (const char*)p + SCALAR_PAYLOAD_OFF, sizeof v);
    return v;
}

/* IntToString, UIntToString, the wide integer family, FloatToString,
 * Float128ToString and BoolToString: runtime/rt/numfmt.resid. */
char* IntToString(int64_t v);
char* UIntToString(uint64_t v);
char* Int128ToString(__int128 v);
char* UInt128ToString(unsigned __int128 u);
char* FloatToString(double v);
char* Float128ToString(_Float128 v);
char* BoolToString(int8_t v);

/* ToString and resid_list_to_string: runtime/rt/show.resid. */
char* ToString(void* boxed);
char* resid_list_to_string(void* boxed);

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

/* The checked-arithmetic traps and the wrapping / saturating / checked
 * builtins are in the Resid runtime (runtime/rt/arith.resid). */
/*
 * Trusted providers (spec §32): filesystem, environment, git.
 *
 * Bootstrap: the kernel allows these unconditionally (a real build will gate
 * them behind capability authorization). Verbaturn links backward to the
 * `PROVIDER_VERBS` table in resid-type; adding a verb here must be mirrored
 * there and in resid-codegen's `lower_provider_call`.
 */
/* The providers (filesystem with File handles, environment, args,
 * process, git), resid_read_line, resid_print_bytes, SHA-256, the native
 * debugger and the entry trampoline resid_run_main: runtime/rt/sys.resid. */

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

/* str_trim / str_contains / str_starts_with / str_ends_with:
 * runtime/rt/strutil.resid. */

/* Case mapping (str_to_lower, str_to_upper), str_repeat, str_replace,
 * str_split and str_join: runtime/rt/case.resid, runtime/rt/strutil.resid. */

/* ─── Stdlib v1.3: list verbs ───
   Lists are persistent tries (see resid_list_new/get/... above): slots
   hold boxed scalars (resid_box_i64) for List(Int) and raw char* for
   List(Str). Verbs flatten, operate, and rebuild fresh lists. */


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

/* str_is_int / str_parse_int: runtime/rt/strutil.resid. */

/* abs_i64 / min_i64 / max_i64 / clamp_i64: runtime/rt/arith.resid. */

/* ─── Stdlib v1.2: float parsing + misc string helpers ─── */

/* str_is_float, str_parse_float, str_count, str_reverse:
 * runtime/rt/strutil.resid. */

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
    if (n < 0 || (uint64_t)n > (SIZE_MAX - 8) / 8) resid_abort("list too large");
    int64_t* m = (int64_t*)malloc(8 + (size_t)n * 8);
    if (!m) resid_abort("out of memory");
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
        buf[i] = (char)(resid_unbox_i64(resid_list_get(lst, i)) & 0xFF);
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

/* ─── Immutable Map / Set (spec §32 core types) ─────────────────────
 *
 * A map or set value (a set is a map whose values are the marker 1) is an
 * HMTrie handle in one of two representations:
 *
 *   - trie mode (tab == NULL): a persistent 32-way hash trie. Updates copy
 *     the nodes on the root-to-leaf path and share the rest, so an older
 *     value is never changed.
 *   - table mode (tab != NULL): a flat open-addressing table (MapTab).
 *
 * Either one can be TRANSIENT: owned by exactly one place in the program,
 * which the compiler proved never observes an older version (its linear
 * ownership analysis; such updates pass `owned`). A transient value is
 * updated in place: a table directly, a trie through edit tokens (a node
 * stamped with the handle's token belongs to it and is written in place;
 * any other node is copied into it first, as in Clojure's transients).
 * The first owned update of a shared value makes the transient: a small
 * value is copied into a table, a big one becomes a trie transient that
 * shares every node until it writes it. Freezing a transient (a call
 * result leaving the ownership chain) makes it an ordinary immutable value
 * again.
 *
 * Keys and values are 64-bit words of a kind fixed per map: key kind 1 = a
 * raw Int, 0 = a boxed value pointer (a bare C string or a ResidVal);
 * value kind 1 = a raw Int, 2 = raw Float bits, 3 = a raw Bool, 0 = a
 * boxed pointer (or a set's marker); -1 = not decided yet (an empty map:
 * its first update decides). A request in another kind is converted, so a
 * mismatch is only ever slower, never wrong.
 *
 * Order: keys(), values(), formatting and set algebra see entries in the
 * CANONICAL order, which depends only on the key set: ascending by the key
 * hash's 5-bit chunks, lowest chunk first (the trie's slot order), with
 * entries whose full hashes are equal in insertion order. A trie walk
 * yields it directly; a table sorts its entries into it.
 */

#define HT_SHIFT 5
#define HT_MASK 31
#define HT_MAX_LEVEL 12 /* 13 levels x 5 bits = 65 >= 64-bit hash */

/* A trie node. An INDEX node maps slot bits to entries (dmap) and to
 * subnodes (nmap); its words are the entries' (key, value) pairs in slot
 * order, then the subnode pointers in slot order. A COLLISION node
 * (ncoll > 0) holds ncoll pairs whose full hashes are equal, in insertion
 * order. `edit` is the token of the transient that owns the node (0 or a
 * frozen token: shared). */
typedef struct HMNode {
    uint32_t dmap;
    uint32_t nmap;
    uint32_t ncoll;
    uint32_t cap;   /* words allocated */
    uint64_t edit;
    uint64_t w[];
} HMNode;

typedef struct MapTab MapTab;

typedef struct {
    int64_t count;
    HMNode* root;   /* trie mode: NULL when empty; table mode: the cached
                       canonical trie (frozen only) */
    MapTab* tab;
    int64_t transient;
    uint64_t edit;  /* transient trie: its token */
    uint32_t own;   /* transient: stamp of the list headers only it holds */
    int8_t kk;      /* trie mode: key / value kinds */
    int8_t vk;
} HMTrie;

static uint64_t fnv1a(const char* s);

/* A bare string key is a raw char* whose first byte is a normal character.
 * A boxed value is a ResidVal whose tag is -1 = 0xFF...FF, so its first byte
 * is 0xFF (never a valid UTF-8/ASCII lead byte, so never a string's first
 * byte). Reading a single byte is safe for both, so we can branch without
 * over-reading a short malloc'd string the way resid_box_tag would. */
static int is_boxed(const void* v) {
    return box_imm(v) || box_fimm(v) || ((const unsigned char*)v)[0] == 0xFF;
}

/* Maps are never freed piecemeal: their nodes are shared between versions. */
void resid_map_free(void* b) { (void)b; }
void resid_set_free(void* b) { (void)b; }

/* FNV-1a of the decimal text of v (what `%lld` prints), without printing. */
static uint64_t fnv1a_i64(int64_t v) {
    char buf[24];
    int n = 0;
    uint64_t mag = v < 0 ? 0 - (uint64_t)v : (uint64_t)v;
    do {
        buf[n++] = (char)('0' + mag % 10);
        mag /= 10;
    } while (mag);
    uint64_t h = 14695981039346656037ULL;
    if (v < 0) {
        h ^= (unsigned char)'-';
        h *= 1099511628211ULL;
    }
    while (n) {
        h ^= (unsigned char)buf[--n];
        h *= 1099511628211ULL;
    }
    return h;
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
    if (box_imm(v)) return fnv1a_i64(imm_val(v));
    if (box_fimm(v)) {
        char fb[64];
        snprintf(fb, sizeof(fb), "%.17g", fimm_val(v));
        return fnv1a(fb);
    }
    ResidVal* b = (ResidVal*)v;
    int64_t tag = b->tag;
    if (tag == -1) {
        /* Scalar box — dispatch on the box type string. */
        const char* t = b->type;
        void* raw = resid_box_slot(v, 0);
        char buf[64];
        if (t && strcmp(t, "i64") == 0) return fnv1a_i64(*(int64_t*)raw);
        if (t && strcmp(t, "f64") == 0) {
            snprintf(buf, sizeof(buf), "%.17g", *(double*)raw);
            return fnv1a(buf);
        }
        if (t && strcmp(t, "bool") == 0) {
            return fnv1a(*(int8_t*)raw ? "t" : "f");
        }
        if (t && strcmp(t, "i128") == 0) return fnv1a_i64((int64_t)ld_i128(raw));
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
    /* Immediates first: a NaN Float is not equal to itself. */
    if (box_imm(a) || box_imm(b) || box_fimm(a) || box_fimm(b)) {
        /* An immediate equals only a scalar of its own type and value. */
        const char* ta = is_boxed(a) ? scalar_type(a) : NULL;
        const char* tb = is_boxed(b) ? scalar_type(b) : NULL;
        if (!ta || !tb || strcmp(ta, tb) != 0) return 0;
        if (strcmp(ta, "i64") == 0) return resid_unbox_i64(a) == resid_unbox_i64(b);
        return strcmp(ta, "f64") == 0 && resid_unbox_f64(a) == resid_unbox_f64(b);
    }
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

/* Scratch memory, freed by its user. */
static void* map_tmp(size_t n) {
    void* p = malloc(n);
    if (!p) resid_abort("map: out of memory");
    return p;
}

/* Map memory (handles, nodes, tables) lives where its map does. A new
 * map made inside a scope region lives in the region, so a loop
 * iteration's dead maps go with it; an update that writes into an older
 * map (g_map_heap) allocates on the heap, like the map itself. A loop
 * carrying a map moves the region parts it made to the heap at each back
 * edge (resid_map_evac). */
static _Thread_local int g_map_heap = 0;

static inline int in_region(const void* p) { return g_sc_depth && scope_contains(p); }

static void* map_obj(size_t n) {
    if (!g_map_heap && g_sc_depth) return scope_alloc(n);
    void* p = malloc(n);
    if (!p) resid_abort("map: out of memory");
    return p;
}

static void map_obj_free(void* p) {
    if (p && !in_region(p)) free(p);
}

/* ── Words ──────────────────────────────────────────────────────────── */

/* Box a stored word of kind `k` into a Resid value pointer. */
static uint64_t mt_box_any(int8_t k, uint64_t w);

/* A box stored into an older map must live on the heap as the map does. */
static uint64_t mt_box(int8_t k, uint64_t w) {
    if (k < 1 || k > 3 || !g_map_heap || !g_sc_depth) return mt_box_any(k, w);
    int64_t d = g_sc_depth;
    g_sc_depth = 0;
    uint64_t r = mt_box_any(k, w);
    g_sc_depth = d;
    return r;
}

static uint64_t mt_box_any(int8_t k, uint64_t w) {
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
    if (w < 4096 || !is_boxed(p)) return 0;
    const char* ty = scalar_type(p);
    if (!ty) return 0;
    if (k == 1 && strcmp(ty, "i64") == 0) { *out = (uint64_t)resid_unbox_i64(p); return 1; }
    if (k == 2 && strcmp(ty, "f64") == 0) { double d = resid_unbox_f64(p); memcpy(out, &d, 8); return 1; }
    if (k == 3 && strcmp(ty, "bool") == 0) { *out = (uint64_t)resid_unbox_bool(p); return 1; }
    return 0;
}

/* The kind a boxed value pointer is best stored as, and that word. */
static int8_t word_of_box(void* p, uint64_t* out, int for_key) {
    uint64_t w = (uint64_t)(uintptr_t)p;
    /* (A set's value is the marker 1, not a pointer.) */
    const char* ty = w >= 4096 && is_boxed(p) ? scalar_type(p) : NULL;
    if (ty) {
        if (strcmp(ty, "i64") == 0) { *out = (uint64_t)resid_unbox_i64(p); return 1; }
        if (!for_key && strcmp(ty, "f64") == 0) { double d = resid_unbox_f64(p); memcpy(out, &d, 8); return 2; }
        if (!for_key && strcmp(ty, "bool") == 0) { *out = (uint64_t)resid_unbox_bool(p); return 3; }
    }
    *out = w;
    return 0;
}

/* A string about to be stored in a map or set, which lives on the heap:
 * copied out of a scope region (a loop iteration's region is popped while
 * the map lives on). The compiler calls it for Str keys and values. */
void* resid_list_keep(void* l);

/* Allocation as it would be outside every scope region (an arena, or the
 * heap): where a value moved out of a loop region belongs. */
static void* outer_alloc(size_t n) {
    int64_t d = g_sc_depth;
    g_sc_depth = 0;
    void* p = resid_alloc(n);
    g_sc_depth = d;
    return p;
}

char* resid_str_keep(char* p) {
    if (!g_sc_depth || !scope_contains(p)) return p;
    size_t n = strlen(p) + 1;
    char* q = (char*)outer_alloc(n);
    memcpy(q, p, n);
    return q;
}

/* The canonical hash of a key word. */
static inline uint64_t key_hash(int8_t kk, uint64_t k) {
    return kk == 1 ? fnv1a_i64((int64_t)k) : resid_hash((void*)(uintptr_t)k);
}

static inline int key_eq(int8_t kk, uint64_t a, uint64_t b) {
    if (kk == 1) return a == b;
    return resid_key_eq((void*)(uintptr_t)a, (void*)(uintptr_t)b);
}

/* A hash as a number whose order is the canonical order: the lowest 5-bit
 * chunk most significant (12 chunks of 5 bits, then the top 4 bits). */
static inline uint64_t canon_rank(uint64_t h) {
    uint64_t r = 0;
    for (int l = 0; l < HT_MAX_LEVEL; l++) r = (r << 5) | ((h >> (l * HT_SHIFT)) & HT_MASK);
    return (r << 4) | (h >> 60);
}

static uint64_t g_edit_seq = 0;

static uint64_t new_edit_token(void) {
    return __atomic_add_fetch(&g_edit_seq, 1, __ATOMIC_RELAXED);
}

/* ── Trie nodes ─────────────────────────────────────────────────────── */

static inline int popc(uint32_t x) { return __builtin_popcount(x); }
static inline int node_nd(const HMNode* n) { return n->ncoll ? (int)n->ncoll : popc(n->dmap); }
static inline int node_nn(const HMNode* n) { return n->ncoll ? 0 : popc(n->nmap); }
static inline int node_words(const HMNode* n) { return 2 * node_nd(n) + node_nn(n); }
static inline uint32_t slot_bit(uint64_t h, int level) { return 1u << ((h >> (level * HT_SHIFT)) & HT_MASK); }

static HMNode* node_new(uint32_t capw, uint64_t edit) {
    HMNode* n = (HMNode*)map_obj(sizeof(HMNode) + (size_t)capw * 8);
    n->dmap = 0;
    n->nmap = 0;
    n->ncoll = 0;
    n->cap = capw;
    n->edit = edit;
    return n;
}

/* The node to write, with room for `add` more words: `n` itself when the
 * transient `edit` owns it and it has room, else a copy owned by `edit`
 * (a transient's copy gets some spare room). */
static HMNode* node_room(HMNode* n, int add, uint64_t edit) {
    int used = node_words(n);
    if (edit && n->edit == edit && used + add <= (int)n->cap) return n;
    int extra = add > 0 ? add : 0;
    if (edit) extra += 4;
    HMNode* m = node_new((uint32_t)(used + extra), edit);
    m->dmap = n->dmap;
    m->nmap = n->nmap;
    m->ncoll = n->ncoll;
    memcpy(m->w, n->w, (size_t)used * 8);
    return m;
}

static HMNode* node_leaf(int level, uint64_t h, uint64_t k, uint64_t v, uint64_t edit) {
    HMNode* m = node_new(edit ? 6 : 2, edit);
    m->dmap = slot_bit(h, level);
    m->w[0] = k;
    m->w[1] = v;
    return m;
}

static HMNode* node_coll2(uint64_t k1, uint64_t v1, uint64_t k2, uint64_t v2, uint64_t edit) {
    HMNode* m = node_new(edit ? 8 : 4, edit);
    m->ncoll = 2;
    m->w[0] = k1;
    m->w[1] = v1;
    m->w[2] = k2;
    m->w[3] = v2;
    return m;
}

/* A node at `level` holding two keys with different words; entry 1 is the
 * older one (it goes first in a collision). */
static HMNode* node_pair(int level, uint64_t h1, uint64_t k1, uint64_t v1, uint64_t h2, uint64_t k2, uint64_t v2, uint64_t edit) {
    /* Past the last level the full hashes are equal. */
    if (level > HT_MAX_LEVEL) return node_coll2(k1, v1, k2, v2, edit);
    uint32_t b1 = slot_bit(h1, level), b2 = slot_bit(h2, level);
    if (b1 == b2) {
        HMNode* sub = node_pair(level + 1, h1, k1, v1, h2, k2, v2, edit);
        HMNode* m = node_new(edit ? 5 : 1, edit);
        m->nmap = b1;
        m->w[0] = (uint64_t)(uintptr_t)sub;
        return m;
    }
    HMNode* m = node_new(edit ? 8 : 4, edit);
    m->dmap = b1 | b2;
    int first1 = b1 < b2;
    m->w[0] = first1 ? k1 : k2;
    m->w[1] = first1 ? v1 : v2;
    m->w[2] = first1 ? k2 : k1;
    m->w[3] = first1 ? v2 : v1;
    return m;
}

static HMNode* node_ins_data(HMNode* n, uint32_t bit, uint64_t k, uint64_t v, uint64_t edit) {
    int di = popc(n->dmap & (bit - 1));
    int used = node_words(n);
    HMNode* m = node_room(n, 2, edit);
    memmove(&m->w[2 * di + 2], &m->w[2 * di], (size_t)(used - 2 * di) * 8);
    m->w[2 * di] = k;
    m->w[2 * di + 1] = v;
    m->dmap |= bit;
    return m;
}

static HMNode* node_data_to_sub(HMNode* n, uint32_t bit, HMNode* sub, uint64_t edit) {
    int di = popc(n->dmap & (bit - 1));
    int nd = popc(n->dmap), nn = popc(n->nmap);
    int ni = popc(n->nmap & (bit - 1));
    HMNode* m = node_room(n, 0, edit);
    uint64_t* w = m->w;
    memmove(&w[2 * di], &w[2 * di + 2], (size_t)(2 * (nd - di - 1)) * 8);
    memmove(&w[2 * (nd - 1)], &w[2 * nd], (size_t)ni * 8);
    memmove(&w[2 * (nd - 1) + ni + 1], &w[2 * nd + ni], (size_t)(nn - ni) * 8);
    w[2 * (nd - 1) + ni] = (uint64_t)(uintptr_t)sub;
    m->dmap &= ~bit;
    m->nmap |= bit;
    return m;
}

static HMNode* node_sub_to_data(HMNode* n, uint32_t bit, uint64_t k, uint64_t v, uint64_t edit) {
    int di = popc(n->dmap & (bit - 1));
    int nd = popc(n->dmap), nn = popc(n->nmap);
    int ni = popc(n->nmap & (bit - 1));
    HMNode* m = node_room(n, 1, edit);
    uint64_t* w = m->w;
    memmove(&w[2 * nd + 2 + ni], &w[2 * nd + ni + 1], (size_t)(nn - ni - 1) * 8);
    memmove(&w[2 * nd + 2], &w[2 * nd], (size_t)ni * 8);
    memmove(&w[2 * di + 2], &w[2 * di], (size_t)(2 * (nd - di)) * 8);
    w[2 * di] = k;
    w[2 * di + 1] = v;
    m->dmap |= bit;
    m->nmap &= ~bit;
    return m;
}

/* Insert into `n` (NULL: empty) at `level`. The result is `n` itself when
 * it was written in place (or nothing changed), else a new node.
 * *added is 1 when the key was new. */
static HMNode* hn_insert(HMNode* n, int level, uint64_t h, int8_t kk, uint64_t k, uint64_t v, uint64_t edit, int* added) {
    if (!n) {
        *added = 1;
        return node_leaf(level, h, k, v, edit);
    }
    if (n->ncoll) {
        int cnt = (int)n->ncoll;
        for (int i = 0; i < cnt; i++) {
            if (key_eq(kk, n->w[2 * i], k)) {
                *added = 0;
                if (n->w[2 * i + 1] == v && n->w[2 * i] == k) return n;
                HMNode* m = node_room(n, 0, edit);
                m->w[2 * i] = k;
                m->w[2 * i + 1] = v;
                return m;
            }
        }
        HMNode* m = node_room(n, 2, edit);
        m->w[2 * cnt] = k;
        m->w[2 * cnt + 1] = v;
        m->ncoll = (uint32_t)(cnt + 1);
        *added = 1;
        return m;
    }
    uint32_t bit = slot_bit(h, level);
    if (n->nmap & bit) {
        int ni = popc(n->nmap & (bit - 1));
        int nd = popc(n->dmap);
        HMNode* c = (HMNode*)(uintptr_t)n->w[2 * nd + ni];
        HMNode* c2 = hn_insert(c, level + 1, h, kk, k, v, edit, added);
        if (c2 == c) return n;
        HMNode* m = node_room(n, 0, edit);
        m->w[2 * nd + ni] = (uint64_t)(uintptr_t)c2;
        return m;
    }
    if (n->dmap & bit) {
        int di = popc(n->dmap & (bit - 1));
        uint64_t ok = n->w[2 * di], ov = n->w[2 * di + 1];
        if (key_eq(kk, ok, k)) {
            *added = 0;
            if (ov == v && ok == k) return n;
            HMNode* m = node_room(n, 0, edit);
            m->w[2 * di] = k;
            m->w[2 * di + 1] = v;
            return m;
        }
        *added = 1;
        HMNode* sub = level >= HT_MAX_LEVEL ? node_coll2(ok, ov, k, v, edit)
                                            : node_pair(level + 1, key_hash(kk, ok), ok, ov, h, k, v, edit);
        return node_data_to_sub(n, bit, sub, edit);
    }
    *added = 1;
    return node_ins_data(n, bit, k, v, edit);
}

/* The value word of key `k`, or NULL. */
static uint64_t* hn_find(HMNode* n, uint64_t h, int8_t kk, uint64_t k) {
    int level = 0;
    while (n) {
        if (n->ncoll) {
            for (uint32_t i = 0; i < n->ncoll; i++)
                if (key_eq(kk, n->w[2 * i], k)) return &n->w[2 * i + 1];
            return NULL;
        }
        uint32_t bit = slot_bit(h, level);
        if (n->dmap & bit) {
            int di = popc(n->dmap & (bit - 1));
            return key_eq(kk, n->w[2 * di], k) ? &n->w[2 * di + 1] : NULL;
        }
        if (!(n->nmap & bit)) return NULL;
        n = (HMNode*)(uintptr_t)n->w[2 * popc(n->dmap) + popc(n->nmap & (bit - 1))];
        level++;
    }
    return NULL;
}

/* A node holding exactly one entry and no subnodes (it folds into its
 * parent's slot). */
static inline int node_single(const HMNode* n) {
    return n->ncoll == 1 || (!n->ncoll && n->nmap == 0 && popc(n->dmap) == 1);
}

/* Remove `k` from `n`. NULL when the node empties; `n` itself when
 * unchanged (*did = 0) or written in place. */
static HMNode* hn_remove(HMNode* n, int level, uint64_t h, int8_t kk, uint64_t k, uint64_t edit, int* did) {
    *did = 0;
    if (!n) return NULL;
    if (n->ncoll) {
        int cnt = (int)n->ncoll;
        for (int i = 0; i < cnt; i++) {
            if (!key_eq(kk, n->w[2 * i], k)) continue;
            *did = 1;
            if (cnt == 1) return NULL;
            HMNode* m = node_room(n, 0, edit);
            memmove(&m->w[2 * i], &m->w[2 * i + 2], (size_t)(2 * (cnt - i - 1)) * 8);
            m->ncoll = (uint32_t)(cnt - 1);
            return m;
        }
        return n;
    }
    uint32_t bit = slot_bit(h, level);
    if (n->nmap & bit) {
        int nd = popc(n->dmap), nn = popc(n->nmap);
        int ni = popc(n->nmap & (bit - 1));
        HMNode* c = (HMNode*)(uintptr_t)n->w[2 * nd + ni];
        HMNode* c2 = hn_remove(c, level + 1, h, kk, k, edit, did);
        if (!*did) return n;
        if (c2 == NULL) {
            if (nd == 0 && nn == 1) return NULL;
            HMNode* m = node_room(n, 0, edit);
            memmove(&m->w[2 * nd + ni], &m->w[2 * nd + ni + 1], (size_t)(nn - ni - 1) * 8);
            m->nmap &= ~bit;
            return m;
        }
        if (node_single(c2)) return node_sub_to_data(n, bit, c2->w[0], c2->w[1], edit);
        if (c2 == c) return n;
        HMNode* m = node_room(n, 0, edit);
        m->w[2 * nd + ni] = (uint64_t)(uintptr_t)c2;
        return m;
    }
    if (n->dmap & bit) {
        int di = popc(n->dmap & (bit - 1));
        if (!key_eq(kk, n->w[2 * di], k)) return n;
        *did = 1;
        if (n->dmap == bit && n->nmap == 0) return NULL;
        int used = node_words(n);
        HMNode* m = node_room(n, 0, edit);
        memmove(&m->w[2 * di], &m->w[2 * di + 2], (size_t)(used - 2 * di - 2) * 8);
        m->dmap &= ~bit;
        return m;
    }
    return n;
}

/* Entries in canonical order into ks / vs (either may be NULL). */
static void hn_collect(const HMNode* n, uint64_t* ks, uint64_t* vs, int64_t* idx) {
    if (!n) return;
    if (n->ncoll) {
        for (uint32_t i = 0; i < n->ncoll; i++) {
            if (ks) ks[*idx] = n->w[2 * i];
            if (vs) vs[*idx] = n->w[2 * i + 1];
            (*idx)++;
        }
        return;
    }
    int nd = popc(n->dmap);
    uint32_t all = n->dmap | n->nmap;
    while (all) {
        uint32_t bit = all & (0u - all);
        all &= all - 1;
        if (n->dmap & bit) {
            int di = popc(n->dmap & (bit - 1));
            if (ks) ks[*idx] = n->w[2 * di];
            if (vs) vs[*idx] = n->w[2 * di + 1];
            (*idx)++;
        } else {
            hn_collect((const HMNode*)(uintptr_t)n->w[2 * nd + popc(n->nmap & (bit - 1))], ks, vs, idx);
        }
    }
}

static HMTrie* trie_new(int64_t count, HMNode* root, int8_t kk, int8_t vk) {
    HMTrie* t = (HMTrie*)map_obj(sizeof(HMTrie));
    t->count = count;
    t->root = root;
    t->tab = NULL;
    t->transient = 0;
    t->edit = 0;
    t->own = 0;
    t->kk = kk;
    t->vk = vk;
    return t;
}

/* ── Table mode ─────────────────────────────────────────────────────────
 *
 * Open addressing with linear probing over a dense key array and a
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
    int8_t nov;     /* no value array: every value is the word 1 (a set) */
    uint64_t* keys; /* NULL while kkind is undecided */
    uint64_t* vals; /* NULL while undecided or `nov` */
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

static inline uint64_t mt_empty(const MapTab* t) { return t->kkind == 1 ? MT_RAW_EMPTY : 0; }
static inline uint64_t mt_tomb(const MapTab* t) { return t->kkind == 1 ? MT_RAW_TOMB : 1; }

static inline uint64_t mt_mix(uint64_t k) {
    k ^= k >> 33;
    k *= 0xff51afd7ed558ccdULL;
    k ^= k >> 33;
    return k;
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
    t->keys = (uint64_t*)map_obj((size_t)cap * sizeof(uint64_t));
    t->vals = t->nov ? NULL : (uint64_t*)map_obj((size_t)cap * sizeof(uint64_t));
    uint64_t e = mt_empty(t);
    for (int64_t i = 0; i < cap; i++) t->keys[i] = e;
}

static MapTab* mt_new(int64_t cap, int8_t kk, int8_t vk, int8_t nov) {
    MapTab* t = (MapTab*)map_obj(sizeof(MapTab));
    memset(t, 0, sizeof(MapTab));
    t->cap = cap;
    t->kkind = kk;
    t->vkind = vk;
    t->nov = nov;
    if (kk != -1) mt_alloc(t, cap);
    return t;
}

/* Whether `used` slots (live + deleted) overfill `cap` (half at most:
 * fuller tables cost probe-heavy loops like k-nucleotide ~10%). */
#define MT_OVER(used, cap) ((used) * 2 > (cap))

/* Slots for `n` entries: a power of two, at most half full. */
static int64_t mt_cap_for(int64_t n) {
    int64_t cap = 16;
    while (MT_OVER(n + 1, cap)) cap *= 2;
    return cap;
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
        *v = t->vals ? t->vals[i] : 1;
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
    map_obj_free(old.keys);
    map_obj_free(old.vals);
}

/* Insert a key known to be absent. */
static void mt_insert_new(MapTab* t, uint64_t k, uint64_t v) {
    int o = mt_oob(t, k);
    if (o >= 0) { t->oob_has[o] = 1; t->oob_val[o] = v; t->live++; return; }
    /* Full: twice the slots, or the same number when deleted slots are
     * most of it. */
    if (MT_OVER(t->live + t->tombs + 1, t->cap)) mt_rebuild(t, t->live * 4 > t->cap ? t->cap * 2 : t->cap, t->kkind, NULL);
    int64_t r = mt_probe(t, k);
    t->keys[-r - 1] = k;
    if (t->vals) t->vals[-r - 1] = v;
    t->live++;
    t->lvalid = 0;
}

/* The first update decides the kinds, and whether the table keeps
 * values (a set's first value is the marker 1). */
static void mt_decide(MapTab* t, int8_t kk, int8_t vk, uint64_t vb) {
    if (t->vkind == -1) t->vkind = vk;
    if (t->kkind == -1) {
        t->kkind = kk;
        t->nov = vk == 0 && vb == 1;
        mt_alloc(t, t->cap);
    }
}

/* A value other than 1 for a value-less table: give it its values. */
static void mt_vals_make(MapTab* t) {
    t->vals = (uint64_t*)map_obj((size_t)t->cap * sizeof(uint64_t));
    for (int64_t i = 0; i < t->cap; i++) t->vals[i] = 1;
    t->nov = 0;
}

static uint64_t g_map_one = 1;

/* Store every value boxed from now on. */
static void mt_vals_boxed(MapTab* t) {
    for (int64_t i = 0; i < t->cap; i++) {
        uint64_t s = t->keys[i];
        if (s != mt_empty(t) && s != mt_tomb(t)) t->vals[i] = mt_box(t->vkind, t->vals[i]);
    }
    for (int o = 0; o < 2; o++) if (t->oob_has[o]) t->oob_val[o] = mt_box(t->vkind, t->oob_val[o]);
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

/* A stored value word of kind `have` as kind `want`. */
static uint64_t word_out(int8_t have, int8_t want, uint64_t w) {
    if (have == want || have == -1) return w;
    if (want == 0) return mt_box(have, w);
    uint64_t raw = 0;
    if (have == 0 && mt_unbox(want, w, &raw)) return raw;
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
    if (r < 0) return NULL;
    return t->vals ? &t->vals[r] : &g_map_one;
}

/* `ks` / `vs`: the key / value is a string to copy out of any scope
 * region when it is stored (resid_str_keep). */
static inline uint64_t word_keep(int k, uint64_t w);

static void mt_put_s(MapTab* t, int8_t kk, uint64_t kb, int8_t vk, uint64_t vb, int ks, int vs) {
    mt_decide(t, kk, vk, vb);
    uint64_t k = mt_key_in(t, kk, kb);
    uint64_t v = mt_val_in(t, vk, vb);
    if (t->nov && v != 1) mt_vals_make(t);
    uint64_t* at = mt_vref(t, t->kkind, k);
    if (vs) v = word_keep(vs, v);
    if (at) { if (!t->nov) *at = v; return; }
    if (ks) k = word_keep(4, k);
    mt_insert_new(t, k, v);
}

static void mt_put(MapTab* t, int8_t kk, uint64_t kb, int8_t vk, uint64_t vb) {
    mt_put_s(t, kk, kb, vk, vb, 0, 0);
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

/* ── Either mode ────────────────────────────────────────────────────── */

static inline int8_t map_kk(const HMTrie* m) { return m->tab ? m->tab->kkind : m->kk; }
static inline int8_t map_vk(const HMTrie* m) { return m->tab ? m->tab->vkind : m->vk; }

/* A trie over the words of ks / vs (entries with equal hashes keep this
 * order), shared once built: it is built in place under a token that is
 * never used again. */
static HMNode* trie_build(const uint64_t* ks, const uint64_t* vs, int64_t n, int8_t kk) {
    HMNode* root = NULL;
    uint64_t edit = new_edit_token();
    for (int64_t i = 0; i < n; i++) {
        int added = 0;
        root = hn_insert(root, 0, key_hash(kk, ks[i]), kk, ks[i], vs ? vs[i] : 1, edit, &added);
    }
    return root;
}

typedef struct { uint64_t rank; int64_t ord; uint64_t k; uint64_t v; } CanonEnt;

static int canon_cmp(const void* a, const void* b) {
    const CanonEnt* x = (const CanonEnt*)a;
    const CanonEnt* y = (const CanonEnt*)b;
    if (x->rank != y->rank) return x->rank < y->rank ? -1 : 1;
    return x->ord < y->ord ? -1 : (x->ord > y->ord ? 1 : 0);
}

/* A table's entries in canonical order (entries with equal full hashes
 * keep table order, as the trie built from the table would). */
static void mt_entries(const MapTab* t, uint64_t* ks, uint64_t* vs) {
    int64_t n = t->live;
    if (n == 0) return;
    CanonEnt* es = (CanonEnt*)map_tmp((size_t)n * sizeof(CanonEnt));
    int64_t it = 0, j = 0;
    uint64_t k, v;
    while (mt_next(t, &it, &k, &v)) {
        es[j].rank = canon_rank(key_hash(t->kkind, k));
        es[j].ord = j;
        es[j].k = k;
        es[j].v = v;
        j++;
    }
    qsort(es, (size_t)n, sizeof(CanonEnt), canon_cmp);
    for (int64_t i = 0; i < n; i++) {
        if (ks) ks[i] = es[i].k;
        if (vs) vs[i] = es[i].v;
    }
    free(es);
}

/* A map's entries as words of its kinds, in canonical order. */
static void map_entries(HMTrie* m, uint64_t* ks, uint64_t* vs) {
    if (m->tab) { mt_entries(m->tab, ks, vs); return; }
    int64_t j = 0;
    hn_collect(m->root, ks, vs, &j);
}

/* The canonical trie holding the same entries: cached on a frozen table,
 * built afresh for a transient one (whose table may still change). */
static HMNode* map_root(HMTrie* m) {
    if (!m->tab) return m->root;
    if (!m->transient) {
        HMNode* c = __atomic_load_n(&m->root, __ATOMIC_ACQUIRE);
        if (c || m->count == 0) return c;
    }
    MapTab* t = m->tab;
    int64_t n = t->live;
    /* A frozen table caches the trie on itself, so it must outlive any
     * arena or scalar scope open now: build it on the plain heap. */
    int cache = !m->transient;
    AllocSuspend sus;
    if (cache) sus = alloc_suspend();
    uint64_t* ks = (uint64_t*)map_tmp((size_t)(n ? n : 1) * 8);
    uint64_t* vs = (uint64_t*)map_tmp((size_t)(n ? n : 1) * 8);
    int64_t it = 0, j = 0;
    uint64_t kw, vw;
    while (mt_next(t, &it, &kw, &vw)) { ks[j] = kw; vs[j] = vw; j++; }
    HMNode* root = trie_build(ks, vs, n, t->kkind);
    free(ks);
    free(vs);
    if (cache) alloc_resume(sus);
    if (!m->transient) {
        HMNode* expect = NULL;
        if (!__atomic_compare_exchange_n(&m->root, &expect, root, 0, __ATOMIC_ACQ_REL, __ATOMIC_ACQUIRE))
            root = expect; /* another thread cached an identical trie first */
    }
    return root;
}

/* The trie-mode base of a persistent update: kinds and a root that no
 * transient will write (a transient trie's own nodes may still change, so
 * it is rebuilt). */
typedef struct { HMNode* root; int8_t kk; int8_t vk; } TrieBase;

static void map_exit(HMTrie* m);

static TrieBase map_base(HMTrie* m) {
    map_exit(m);
    TrieBase b = { NULL, map_kk(m), map_vk(m) };
    if (m->tab || !m->transient) { b.root = map_root(m); return b; }
    int64_t n = m->count;
    uint64_t* ks = (uint64_t*)map_tmp((size_t)(n ? n : 1) * 8);
    uint64_t* vs = (uint64_t*)map_tmp((size_t)(n ? n : 1) * 8);
    map_entries(m, ks, vs);
    b.root = trie_build(ks, vs, n, b.kk);
    free(ks);
    free(vs);
    return b;
}

/* A trie base whose words are all boxed (a request of another kind). */
static TrieBase base_boxed(TrieBase b, int64_t n, int keys, int vals) {
    uint64_t* ks = (uint64_t*)map_tmp((size_t)(n ? n : 1) * 8);
    uint64_t* vs = (uint64_t*)map_tmp((size_t)(n ? n : 1) * 8);
    int64_t j = 0;
    hn_collect(b.root, ks, vs, &j);
    int8_t kk = keys ? 0 : b.kk, vk = vals ? 0 : b.vk;
    for (int64_t i = 0; i < n; i++) {
        if (keys) ks[i] = mt_box(b.kk, ks[i]);
        if (vals) vs[i] = mt_box(b.vk, vs[i]);
    }
    TrieBase r = { trie_build(ks, vs, n, kk), kk, vk };
    free(ks);
    free(vs);
    return r;
}

/* Bring a request word of kind `rk` to kind `have`; 0 when it cannot be. */
static int word_in(int8_t have, int8_t rk, uint64_t w, uint64_t* out) {
    if (have == rk) { *out = w; return 1; }
    if (have == 0) { *out = mt_box(rk, w); return 1; }
    if (rk == 0) return mt_unbox(have, w, out);
    return 0;
}

/* Persistent insert: a new frozen trie-mode map. */
static HMTrie* map_insert_p(HMTrie* m, int8_t rk, uint64_t kb, int8_t rv, uint64_t vb) {
    TrieBase b = map_base(m);
    if (m->count == 0) { b.root = NULL; b.kk = rk; b.vk = rv; }
    if (b.kk == -1) b.kk = rk;
    if (b.vk == -1) b.vk = rv;
    uint64_t k, v;
    if (!word_in(b.kk, rk, kb, &k)) { b = base_boxed(b, m->count, 1, 0); k = mt_box(rk, kb); }
    if (!word_in(b.vk, rv, vb, &v)) { b = base_boxed(b, m->count, 0, 1); v = mt_box(rv, vb); }
    int added = 0;
    HMNode* root = hn_insert(b.root, 0, key_hash(b.kk, k), b.kk, k, v, 0, &added);
    return trie_new(m->count + added, root, b.kk, b.vk);
}

/* A request key as a word of the map's key kind; 0 when no entry can
 * have it. */
static int key_lookup_word(int8_t kk, int8_t rk, uint64_t kb, uint64_t* out) {
    if (kk == rk) { *out = kb; return 1; }
    if (kk == 0) { *out = mt_box(rk, kb); return 1; }
    return mt_unbox(kk, kb, out);
}

/* Persistent remove: `m` itself when the key is absent (unless it is
 * transient: that is never handed out as is). */
static HMTrie* map_remove_p(HMTrie* m, int8_t rk, uint64_t kb) {
    uint64_t k;
    if (m->count == 0 || !key_lookup_word(map_kk(m), rk, kb, &k)) {
        return m->transient ? trie_new(m->count, map_base(m).root, map_kk(m), map_vk(m)) : m;
    }
    TrieBase b = map_base(m);
    int did = 0;
    HMNode* root = hn_remove(b.root, 0, key_hash(b.kk, k), b.kk, k, 0, &did);
    if (!did) return m->transient ? trie_new(m->count, b.root, b.kk, b.vk) : m;
    return trie_new(m->count - 1, root, b.kk, b.vk);
}

/* Stamps are unique process-wide: each thread takes blocks of them from
 * a global counter. Once 2^32 are used up, new stamps are 0 and appends
 * are never in place again (a stamp is never reused). */
static uint64_t g_own_seq = 0;
static _Thread_local uint64_t g_own_next = 0, g_own_end = 0;

static uint32_t new_own(void) {
    if (g_own_next == g_own_end) {
        g_own_next = __atomic_fetch_add(&g_own_seq, 65536, __ATOMIC_RELAXED) + 1;
        g_own_end = g_own_next + 65535;
    }
    if (g_own_next > 0xFFFFFFFFu) return 0;
    return (uint32_t)g_own_next++;
}

/* A value word may leave a transient map (a lookup, an entry list, a
 * persistent update sharing its words): no list header it holds is its
 * alone any more. */
static inline void map_exit(HMTrie* m) {
    /* Raw Int, Float or Bool values are never list headers. */
    if (m->transient && (m->tab ? m->tab->vkind : m->vk) <= 0) m->own = new_own();
}

static uint64_t* map_vref_raw(HMTrie* m, int8_t rk, uint64_t kb);

static uint64_t* map_vref(HMTrie* m, int8_t rk, uint64_t kb) {
    map_exit(m);
    return map_vref_raw(m, rk, kb);
}

/* The value word (of the map's value kind) of a request key, or NULL. */
static uint64_t* map_vref_raw(HMTrie* m, int8_t rk, uint64_t kb) {
    if (m->count == 0) return NULL;
    if (m->tab) return mt_vref(m->tab, rk, kb);
    uint64_t k;
    if (!key_lookup_word(m->kk, rk, kb, &k)) return NULL;
    return hn_find(m->root, key_hash(m->kk, k), m->kk, k);
}

#define MAP_TRANSIENT_COPY_MAX 64

/* An exclusively owned, mutable copy of `map` for the first owned update
 * of a shared map; `map` itself is untouched. A small map is copied into a
 * table (fast in-place growth). A big one becomes a transient trie sharing
 * all of `map`'s nodes (its canonical trie, for a table), copying a node
 * only when it first writes it. A transient source (owned elsewhere) is
 * copied in full. */
void* resid_map_transient(void* map) {
    HMTrie* src = (HMTrie*)map;
    int64_t n = src->count;
    if (n > MAP_TRANSIENT_COPY_MAX && !src->transient) {
        HMTrie* m = trie_new(n, map_root(src), map_kk(src), map_vk(src));
        m->transient = 1;
        m->edit = new_edit_token();
        m->own = new_own();
        return m;
    }
    /* A transient source keeps its words too. */
    map_exit(src);
    HMTrie* m = trie_new(n, NULL, -1, -1);
    m->transient = 1;
    m->own = new_own();
    if (src->tab) {
        MapTab* s = src->tab;
        MapTab* t = (MapTab*)map_obj(sizeof(MapTab));
        *t = *s;
        t->lvalid = 0;
        if (s->keys) {
            t->keys = (uint64_t*)map_obj((size_t)s->cap * sizeof(uint64_t));
            t->vals = s->vals ? (uint64_t*)map_obj((size_t)s->cap * sizeof(uint64_t)) : NULL;
            memcpy(t->keys, s->keys, (size_t)s->cap * sizeof(uint64_t));
            if (s->vals) memcpy(t->vals, s->vals, (size_t)s->cap * sizeof(uint64_t));
        }
        m->tab = t;
        return m;
    }
    m->tab = mt_new(mt_cap_for(n), -1, -1, 0);
    if (n > 0) {
        uint64_t* ks = (uint64_t*)map_tmp((size_t)n * 8);
        uint64_t* vs = (uint64_t*)map_tmp((size_t)n * 8);
        map_entries(src, ks, vs);
        for (int64_t i = 0; i < n; i++) mt_put(m->tab, src->kk, ks[i], src->vk, vs[i]);
        free(ks);
        free(vs);
    }
    return m;
}

/* The owner is done with it: from here on the value is an ordinary
 * immutable map. */
void* resid_map_freeze(void* map) {
    HMTrie* m = (HMTrie*)map;
    if (m->transient) m->transient = 0;
    return map;
}

/* An owned update of a transient trie, in place. */
static void* trie_put_owned(HMTrie* m, int8_t rk, uint64_t kb, int8_t rv, uint64_t vb) {
    if (m->count == 0) { m->kk = rk; m->vk = rv; }
    uint64_t k, v;
    if (!word_in(m->kk, rk, kb, &k) || !word_in(m->vk, rv, vb, &v)) {
        /* Words of another kind: go boxed (a fresh transient trie). */
        TrieBase b = base_boxed((TrieBase){ m->root, m->kk, m->vk }, m->count, 1, 1);
        m->root = b.root;
        m->kk = 0;
        m->vk = 0;
        m->edit = new_edit_token();
        k = mt_box(rk, kb);
        v = mt_box(rv, vb);
    }
    int added = 0;
    m->root = hn_insert(m->root, 0, key_hash(m->kk, k), m->kk, k, v, m->edit, &added);
    m->count += added;
    return m;
}

/* Kinds 4 and 5 (from the compiler): a string, and a list of Int, Float,
 * Bool or Str, stored as kind 0 but moved out of any scope region when
 * stored (loop regions: resid_str_keep, resid_list_keep). */
static inline uint64_t word_keep(int k, uint64_t w) {
    if (k == 4) return (uint64_t)(uintptr_t)resid_str_keep((char*)(uintptr_t)w);
    if (k == 5) return (uint64_t)(uintptr_t)resid_list_keep((void*)(uintptr_t)w);
    return w;
}

static __attribute__((noinline)) void* map_put_slow(HMTrie* m, int8_t owned, int8_t kk, int64_t kb, int8_t vk, int64_t vb) {
    int ks = kk == 4, vs = vk;
    if (ks) kk = 0;
    if (vk == 4 || vk == 5) vk = 0; else vs = 0;
    /* The first owned update of a shared map takes a private copy. */
    if (owned && !m->transient) m = (HMTrie*)resid_map_transient(m);
    if (owned && m->transient) {
        /* In place: allocate where the map lives. */
        int saved = g_map_heap;
        g_map_heap = !in_region(m);
        if (m->tab) {
            m->tab->lvalid = 0;
            mt_put_s(m->tab, kk, (uint64_t)kb, vk, (uint64_t)vb, ks, vs);
            m->count = m->tab->live;
        } else {
            m = (HMTrie*)trie_put_owned(m, kk, word_keep(ks ? 4 : 0, (uint64_t)kb), vk, word_keep(vs, (uint64_t)vb));
        }
        g_map_heap = saved;
        return m;
    }
    return map_insert_p(m, kk, word_keep(ks ? 4 : 0, (uint64_t)kb), vk, word_keep(vs, (uint64_t)vb));
}

/* Typed insert. `owned` is set by codegen only for an update the
 * compiler proved nothing else observes (the old version is dead): on a
 * transient it updates in place, and a shared map is first made into one
 * (resid_map_transient). Every other case is the ordinary persistent
 * insert. */
__attribute__((always_inline)) void* resid_map_put(void* map, int8_t owned, int8_t kk, int64_t kb, int8_t vk, int64_t vb) {
    HMTrie* m = (HMTrie*)map;
    MapTab* t = m->tab;
    uint64_t k = (uint64_t)kb;
    if (owned && m->transient && t && kk == 1 && t->kkind == 1 && t->vkind == vk && (t->vals || vb == 1) && (k >> 1) != (MT_RAW_EMPTY >> 1)) {
        int64_t r = mt_probe_raw_cached(t, k);
        if (r >= 0) { if (t->vals) t->vals[r] = (uint64_t)vb; return m; }
        if (!MT_OVER(t->live + t->tombs + 1, t->cap)) {
            t->keys[-r - 1] = k;
            if (t->vals) t->vals[-r - 1] = (uint64_t)vb;
            t->live++;
            t->lres = -r - 1; /* the cached key now lives there */
            m->count = t->live;
            return m;
        }
    }
    return map_put_slow(m, owned, kk, kb, vk, vb);
}

static void* elem_keep(void* p);

/* `m.insert(k, (m.get(k) else { d }).concat([e]))` for a map of lists
 * (value kind 5), fused by the compiler when the looked-up list has no
 * other use. On an owned transient map whose slot holds a header stamped
 * with the map's current `own`, the element is appended in place: no new
 * header, and the buffer grows by doubling. Otherwise it is exactly the
 * lookup, append and insert, and the stored header is stamped. */
void* resid_map_list_push(void* map, int8_t owned, int8_t kk, int64_t kb, void* elem, void* dflt) {
    HMTrie* m = (HMTrie*)map;
    int8_t lk = kk == 4 ? 0 : kk;
    int heap = !in_region(m);
    if (owned && m->transient && m->own) {
        uint64_t* at = map_vref_raw(m, lk, (uint64_t)kb);
        ResidList* h = at ? (ResidList*)(uintptr_t)*at : NULL;
        if (h && h->stamp == m->own) {
            /* Allocate and keep as the map does: outside the region. */
            int64_t d = g_sc_depth;
            void* e = heap ? elem_keep(elem) : elem;
            if (heap) g_sc_depth = 0;
            pvec_append_into(h, h, &e, 1);
            g_sc_depth = d;
            return m;
        }
    }
    /* The looked-up header only seeds the new one: it does not leave. */
    uint64_t* at = map_vref_raw(m, lk, (uint64_t)kb);
    ResidList* base = at ? (ResidList*)(uintptr_t)word_out(map_vk(m), 0, *at) : (ResidList*)dflt;
    ResidList* nv;
    if (base->count == 0) {
        /* A new list gets room for a few appends. */
        int64_t d = g_sc_depth;
        if (heap && owned) g_sc_depth = 0;
        FlatBuf* f = flatbuf_new(4);
        f->items[0] = heap ? elem_keep(elem) : elem;
        f->used = 1;
        nv = list_hdr();
        nv->type = base->type;
        nv->count = 1;
        nv->shift = FLAT_SHIFT;
        nv->root = (PVecNode*)f;
        g_sc_depth = d;
    } else {
        nv = pvec_push_raw(base, elem);
    }
    HMTrie* r = (HMTrie*)resid_map_put(m, owned, kk, kb, 5, (int64_t)(uintptr_t)nv);
    if (owned && r->transient && r->own) {
        uint64_t* slot = map_vref_raw(r, lk, (uint64_t)kb);
        if (slot) ((ResidList*)(uintptr_t)*slot)->stamp = r->own;
    }
    return r;
}

void* resid_map_del(void* map, int8_t owned, int8_t kk, int64_t kb) {
    HMTrie* m = (HMTrie*)map;
    if (kk == 4) kk = 0;
    if (owned && !m->transient && m->count > 0) m = (HMTrie*)resid_map_transient(m);
    if (owned && m->transient && !m->tab) {
        int saved = g_map_heap;
        g_map_heap = !in_region(m);
        uint64_t k;
        if (m->count > 0 && key_lookup_word(m->kk, kk, (uint64_t)kb, &k)) {
            int did = 0;
            m->root = hn_remove(m->root, 0, key_hash(m->kk, k), m->kk, k, m->edit, &did);
            m->count -= did;
        }
        g_map_heap = saved;
        return m;
    }
    if (owned && m->transient) {
        if (m->tab) {
            mt_del(m->tab, kk, (uint64_t)kb);
            m->count = m->tab->live;
            return m;
        }
        uint64_t k;
        if (m->count == 0 || !key_lookup_word(m->kk, kk, (uint64_t)kb, &k)) return m;
        int did = 0;
        m->root = hn_remove(m->root, 0, key_hash(m->kk, k), m->kk, k, m->edit, &did);
        m->count -= did;
        return m;
    }
    return map_remove_p(m, kk, (uint64_t)kb);
}

void* resid_set_put(void* set, int8_t owned, int8_t kk, int64_t kb) {
    return resid_map_put(set, owned, kk, kb, 0, 1);
}

/* Typed lookup: {value word of kind `vk`, found}. No allocation on the
 * table path, so `m.get(k) else { d }` on an Int-keyed map is a probe. */
typedef struct { int64_t val; int64_t found; } MapFind;

static __attribute__((noinline)) MapFind map_find_slow(HMTrie* m, int8_t kk, int64_t kb, int8_t vk) {
    MapFind r = { 0, 0 };
    uint64_t* at = map_vref(m, kk, (uint64_t)kb);
    if (!at) return r;
    uint64_t w = word_out(map_vk(m), vk, *at);
    if (vk != 0 && map_vk(m) == 0 && !mt_unbox(vk, *at, &w)) return r;
    r.val = (int64_t)w;
    r.found = 1;
    return r;
}

__attribute__((always_inline)) MapFind resid_map_find(void* map, int8_t kk, int64_t kb, int8_t vk) {
    HMTrie* m = (HMTrie*)map;
    if (kk == 4) kk = 0;
    if (vk == 4) vk = 0;
    MapTab* t = m->tab;
    uint64_t k = (uint64_t)kb;
    /* A frozen table may be read by several threads, so only the owning
     * loop's transient table goes through the last-probe cache. */
    if (m->transient && t && kk == 1 && t->kkind == 1 && t->vkind == vk && (k >> 1) != (MT_RAW_EMPTY >> 1)) {
        MapFind r = { 0, 0 };
        map_exit(m);
        int64_t at = mt_probe_raw_cached(t, k);
        if (at >= 0) { r.val = t->vals ? (int64_t)t->vals[at] : 1; r.found = 1; }
        return r;
    }
    return map_find_slow(m, kk, kb, vk);
}

int8_t resid_map_has(void* map, int8_t kk, int64_t kb) {
    if (kk == 4) kk = 0;
    return map_vref((HMTrie*)map, kk, (uint64_t)kb) != NULL;
}

/* ── Boxed-value API (keys and values as Resid value pointers) ──────── */

/* Lookup a key in the map. Returns the value or NULL. */
void* resid_map_get(void* map, void* key) {
    HMTrie* m = (HMTrie*)map;
    uint64_t kb;
    int8_t rk = word_of_box(key, &kb, 1);
    uint64_t* at = map_vref(m, rk, kb);
    return at ? (void*)(uintptr_t)word_out(map_vk(m), 0, *at) : NULL;
}

/* Insert a key-value pair, returning a NEW map (immutable). */
void* resid_map_insert(void* map, void* key, void* val) {
    uint64_t kb, vb;
    int8_t rk = word_of_box(key, &kb, 1);
    int8_t rv = word_of_box(val, &vb, 0);
    return map_insert_p((HMTrie*)map, rk, kb, rv, vb);
}

/* Remove a key, returning a NEW map (or the same map if key absent). */
void* resid_map_remove(void* map, void* key) {
    uint64_t kb;
    int8_t rk = word_of_box(key, &kb, 1);
    return map_remove_p((HMTrie*)map, rk, kb);
}

/* Check if a key exists. Returns 1/0. */
int8_t resid_map_contains(void* map, void* key) {
    uint64_t kb;
    int8_t rk = word_of_box(key, &kb, 1);
    return map_vref((HMTrie*)map, rk, kb) != NULL;
}

/* Number of entries. */
int64_t resid_map_len(void* map) {
    return ((HMTrie*)map)->count;
}

/* Keys or values (or both) as boxed pointers in canonical order; the
 * caller frees the arrays. */
static int64_t map_boxed_entries(HMTrie* m, void*** ks, void*** vs) {
    int64_t n = m->count;
    uint64_t* kw = (uint64_t*)map_tmp((size_t)(n ? n : 1) * 8);
    uint64_t* vw = (uint64_t*)map_tmp((size_t)(n ? n : 1) * 8);
    map_exit(m);
    map_entries(m, kw, vw);
    int8_t kk = map_kk(m), vk = map_vk(m);
    for (int64_t i = 0; i < n; i++) {
        if (ks) kw[i] = mt_box(kk, kw[i]);
        if (vs) vw[i] = mt_box(vk, vw[i]);
    }
    if (ks) *ks = (void**)kw; else free(kw);
    if (vs) *vs = (void**)vw; else free(vw);
    return n;
}

/* Build a List of keys. */
void* resid_map_keys(void* map) {
    void** ks;
    int64_t n = map_boxed_entries((HMTrie*)map, &ks, NULL);
    void* r = resid_list_new(n, ks, "list");
    free(ks);
    return r;
}

/* Build a List of values. */
void* resid_map_values(void* map) {
    void** vs;
    int64_t n = map_boxed_entries((HMTrie*)map, NULL, &vs);
    void* r = resid_list_new(n, vs, "list");
    free(vs);
    return r;
}

/* A map entry's text: a string as is, a scalar formatted into `tmp`. */
static const char* entry_text(void* p, char* tmp) {
    const char* st = is_boxed(p) ? scalar_type(p) : NULL;
    if (!st) return (const char*)p;
    if (st[0] == 'f') snprintf(tmp, 64, "%.17g", resid_unbox_f64(p));
    else if (st[0] == 'b') snprintf(tmp, 64, "%s", resid_unbox_bool(p) ? "true" : "false");
    else snprintf(tmp, 64, "%lld", (long long)resid_unbox_i64(p));
    return tmp;
}

/* Format a map as a string: {key1: val1, key2: val2}. Keys and values
 * print as strings (a scalar box shows its first slot). Caller must free
 * the returned string. */
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
    void** ks;
    void** vs;
    int64_t n = map_boxed_entries(m, &ks, &vs);
    for (int64_t i = 0; i < n; i++) {
        if (i > 0) { buf[pos++] = ','; buf[pos++] = ' '; }
        /* Key: assume string. */
        char kt[64];
        const char* ks0 = entry_text(ks[i], kt);
        size_t kl = strlen(ks0);
        if (pos + kl + 4 >= cap) { cap = cap * 2 + kl; buf = realloc(buf, cap); }
        memcpy(buf + pos, ks0, kl); pos += kl;
        buf[pos++] = ':';
        buf[pos++] = ' ';
        /* Value: assume string. */
        char vt[64];
        const char* vs0 = entry_text(vs[i], vt);
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
    return trie_new(0, NULL, -1, -1);
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

/* A set's element words (of its key kind) in no particular order; the
 * caller frees them. */
static uint64_t* set_words(HMTrie* s) {
    uint64_t* ks = (uint64_t*)map_tmp((size_t)(s->count ? s->count : 1) * 8);
    if (s->tab) {
        int64_t it = 0, j = 0;
        uint64_t k, v;
        while (mt_next(s->tab, &it, &k, &v)) ks[j++] = k;
    } else {
        int64_t j = 0;
        hn_collect(s->root, ks, NULL, &j);
    }
    return ks;
}

/* A new frozen set of the given element words: a table. */
static HMTrie* set_of_words(const uint64_t* ks, int64_t n, int8_t kk) {
    HMTrie* r = trie_new(0, NULL, -1, -1);
    if (n == 0) return r;
    r->tab = mt_new(mt_cap_for(n), kk, 0, 1);
    for (int64_t i = 0; i < n; i++) mt_insert_new(r->tab, ks[i], 1);
    r->count = r->tab->live;
    return r;
}

/* Every element of `s` put into the transient `t` (owned updates). */
static HMTrie* set_put_all(HMTrie* t, HMTrie* s) {
    uint64_t* ks = set_words(s);
    int8_t kk = map_kk(s);
    for (int64_t i = 0; i < s->count; i++) t = (HMTrie*)map_put_slow(t, 1, kk, (int64_t)ks[i], 0, 1);
    free(ks);
    return t;
}

/* Set union: elements from both sets. */
void* resid_set_union(void* a, void* b) {
    HMTrie* ta = (HMTrie*)a;
    HMTrie* tb = (HMTrie*)b;
    if (tb->count == 0) return ta;
    if (ta->count == 0) return tb;
    HMTrie* big = ta->count >= tb->count ? ta : tb;
    HMTrie* small = big == ta ? tb : ta;
    if (!big->tab && small->count * 8 < big->count) {
        /* A few more elements for a big trie: a transient sharing it. */
        HMTrie* t = (HMTrie*)resid_map_transient(big);
        return resid_map_freeze(set_put_all(t, small));
    }
    /* Otherwise one new table holding both. */
    HMTrie* r = trie_new(0, NULL, -1, -1);
    r->tab = mt_new(mt_cap_for(big->count + small->count), map_kk(big), 0, 1);
    uint64_t* ks = set_words(big);
    for (int64_t i = 0; i < big->count; i++) mt_insert_new(r->tab, ks[i], 1);
    free(ks);
    ks = set_words(small);
    int8_t kk = map_kk(small);
    for (int64_t i = 0; i < small->count; i++) mt_put(r->tab, kk, ks[i], 0, 1);
    free(ks);
    r->count = r->tab->live;
    return r;
}

/* Set difference: elements in a but not in b. */
void* resid_set_difference(void* a, void* b) {
    HMTrie* ta = (HMTrie*)a;
    HMTrie* tb = (HMTrie*)b;
    if (ta->count == 0 || tb->count == 0) return ta;
    if (tb->count * 4 < ta->count) {
        /* Few removals: a private copy of `a` without them. */
        HMTrie* t = (HMTrie*)resid_map_transient(ta);
        uint64_t* ks = set_words(tb);
        int8_t kk = map_kk(tb);
        for (int64_t i = 0; i < tb->count; i++) t = (HMTrie*)resid_map_del(t, 1, kk, (int64_t)ks[i]);
        free(ks);
        return resid_map_freeze(t);
    }
    uint64_t* ks = set_words(ta);
    int8_t kk = map_kk(ta);
    int64_t j = 0;
    for (int64_t i = 0; i < ta->count; i++)
        if (!map_vref(tb, kk, ks[i])) ks[j++] = ks[i];
    HMTrie* r = j == ta->count ? ta : set_of_words(ks, j, kk);
    free(ks);
    return r;
}

/* Set intersection: elements in both sets. */
void* resid_set_intersection(void* a, void* b) {
    HMTrie* ta = (HMTrie*)a;
    HMTrie* tb = (HMTrie*)b;
    /* Iterate over the smaller set. */
    HMTrie* smaller = ta->count <= tb->count ? ta : tb;
    HMTrie* larger = ta->count <= tb->count ? tb : ta;
    if (smaller->count == 0) return smaller;
    uint64_t* ks = set_words(smaller);
    int8_t kk = map_kk(smaller);
    int64_t j = 0;
    for (int64_t i = 0; i < smaller->count; i++)
        if (map_vref(larger, kk, ks[i])) ks[j++] = ks[i];
    HMTrie* r = j == smaller->count ? smaller : set_of_words(ks, j, kk);
    free(ks);
    return r;
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
    void** ks;
    int64_t n = map_boxed_entries(m, &ks, NULL);
    for (int64_t i = 0; i < n; i++) {
        if (i > 0) { buf[pos++] = ','; buf[pos++] = ' '; }
        char et[64];
        const char* es = entry_text(ks[i], et);
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

/* ── Moving loop-region values to the heap ──────────────────────────────
 * A loop region (the compiler's lr_region) frees an iteration's memory at
 * its back edge. Values the loop carries on, and values stored into maps
 * that outlive the region, are first moved out: only their parts that
 * live in a region are copied (older parts are shared), so a map or list
 * that grew by a little costs a little. They hold Int, Float, Bool or Str
 * words, or lists of them (the compiler checks the types). */

/* A list element (a scalar box or a string), on the heap. */
static void* elem_keep(void* p) {
    if (!p || (uintptr_t)p < 4096 || !in_region(p)) return p;
    if (is_boxed(p)) {
        uint64_t raw;
        int8_t k = word_of_box(p, &raw, 0);
        if (k == 0) return p;
        int64_t d = g_sc_depth;
        g_sc_depth = 0;
        void* r = (void*)(uintptr_t)mt_box_any(k, raw);
        g_sc_depth = d;
        return r;
    }
    return resid_str_keep((char*)p);
}

static PVecNode* pvec_keep(PVecNode* n, int32_t level) {
    if (!n || !in_region(n)) return n;
    PVecNode* c = (PVecNode*)outer_alloc(sizeof(PVecNode) + (size_t)n->cap * sizeof(void*));
    c->cap = n->cap;
    for (int64_t i = 0; i < n->cap; i++)
        c->items[i] = level > 0 ? (void*)pvec_keep((PVecNode*)n->items[i], level - PVEC_BITS) : elem_keep(n->items[i]);
    return c;
}

/* A list with no part in a scope region. */
void* resid_list_keep(void* l) {
    ResidList* v = (ResidList*)l;
    if (!v || !g_sc_depth) return l;
    PVecNode* root = v->root;
    PVecNode* nroot = root;
    if (v->shift == FLAT_SHIFT && root) {
        FlatBuf* f = (FlatBuf*)root;
        if (in_region(f)) {
            /* Same capacity: the next appends still fit in place. */
            int64_t cap = f->cap > v->count ? f->cap : (v->count ? v->count : 1);
            FlatBuf* g = (FlatBuf*)outer_alloc(sizeof(FlatBuf) + (size_t)cap * sizeof(void*));
            g->used = v->count;
            g->cap = cap;
            g->kept = v->count;
            for (int64_t i = 0; i < v->count; i++) g->items[i] = elem_keep(f->items[i]);
            nroot = (PVecNode*)g;
        } else if (f->kept < v->count) {
            /* An older buffer: only slots appended since its last move can
             * hold region elements, and no older list sees them. */
            for (int64_t i = f->kept; i < v->count; i++) f->items[i] = elem_keep(f->items[i]);
            f->kept = v->count;
        }
    } else if (root) {
        nroot = pvec_keep(root, v->shift);
    }
    if (nroot == root && !in_region(v)) return l;
    ResidList* out = (ResidList*)outer_alloc(sizeof(ResidList));
    *out = *v;
    out->root = nroot;
    return out;
}

void* resid_list_evac(void* l) { return resid_list_keep(l); }

/* A loop-carried copy the loop replaced and nothing else holds (the
 * compiler's lr_frees); memory of a region or an arena is left alone. */
void resid_carry_free(int8_t dead, void* p) {
    if (!dead || !p || scope_contains(p) || arena_chain_contains(g_bulk_arena, p) || arena_chain_contains(g_current_arena, p)) return;
    free(p);
}

/* A pointer-form Dec a loop carries: copied out of the region it was made
 * in (a Dec holds no pointers). */
void* resid_dec_evac(void* p) {
    DecV* v = (DecV*)p;
    if (!v || !in_region(v)) return p;
    size_t sz = sizeof(DecV) + (size_t)v->n * sizeof(uint64_t);
    int64_t d = g_sc_depth;
    g_sc_depth = 0;
    DecV* r = (DecV*)resid_gmalloc((int64_t)sz); /* as resid_gfree expects */
    g_sc_depth = d;
    memcpy(r, v, sz);
    return r;
}

static HMNode* hnode_evac(HMNode* n, int kf, int vf) {
    if (!n || !in_region(n)) return n;
    int nd = node_nd(n), nn = node_nn(n);
    HMNode* c = (HMNode*)map_tmp(sizeof(HMNode) + (size_t)n->cap * 8);
    memcpy(c, n, sizeof(HMNode) + (size_t)(2 * nd + nn) * 8);
    for (int i = 0; i < nd; i++) {
        c->w[2 * i] = word_keep(kf, c->w[2 * i]);
        c->w[2 * i + 1] = word_keep(vf, c->w[2 * i + 1]);
    }
    for (int i = 0; i < nn; i++) c->w[2 * nd + i] = (uint64_t)(uintptr_t)hnode_evac((HMNode*)(uintptr_t)c->w[2 * nd + i], kf, vf);
    return c;
}

/* A map a loop carries across its back edge, with no part in a scope
 * region. kf / vf: the kinds of its keys / values (4: strings, 5: lists,
 * else plain words). */
void* resid_map_evac(void* map, int8_t kf, int8_t vf) {
    HMTrie* m = (HMTrie*)map;
    if (!m || !g_sc_depth) return map;
    MapTab* t = m->tab;
    MapTab* nt = t;
    HMNode* nr = m->root;
    if (t) {
        int tt = in_region(t);
        int kt = t->keys && in_region(t->keys);
        int vt = t->vals && in_region(t->vals);
        if (tt || kt || vt) {
            nt = (MapTab*)map_tmp(sizeof(MapTab));
            *nt = *t;
            if (kt) { nt->keys = (uint64_t*)map_tmp((size_t)t->cap * 8); memcpy(nt->keys, t->keys, (size_t)t->cap * 8); }
            if (vt) { nt->vals = (uint64_t*)map_tmp((size_t)t->cap * 8); memcpy(nt->vals, t->vals, (size_t)t->cap * 8); }
            /* A table made in the region may hold region words. */
            if (nt->keys && (kf == 4 || (vf >= 4 && nt->vals))) {
                for (int64_t i = 0; i < nt->cap; i++) {
                    uint64_t k = nt->keys[i];
                    if (k == mt_empty(nt) || k == mt_tomb(nt)) continue;
                    if (kt && kf == 4) nt->keys[i] = word_keep(4, k);
                    if (vt && vf >= 4) nt->vals[i] = word_keep(vf, nt->vals[i]);
                }
            }
        }
    } else {
        nr = hnode_evac(m->root, kf, vf);
    }
    if (nt == t && nr == m->root && !in_region(m)) return map;
    HMTrie* out = (HMTrie*)map_tmp(sizeof(HMTrie));
    *out = *m;
    out->tab = nt;
    out->root = nr;
    return out;
}
