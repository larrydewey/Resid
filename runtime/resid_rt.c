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

/* Allocation as it would be outside every scope region (an arena, or the
 * heap). */
static void* outer_alloc(size_t n) {
    int64_t d = g_sc_depth;
    g_sc_depth = 0;
    void* p = resid_alloc(n);
    g_sc_depth = d;
    return p;
}

/* Allocator state for the Resid runtime's maps. */
int64_t resid_rt_sc_depth(void) { return g_sc_depth; }
void resid_rt_sc_depth_set(int64_t d) { g_sc_depth = d; }
int8_t resid_rt_in_scope(const void* p) { return (int8_t)scope_contains(p); }
void* resid_rt_scope_alloc(int64_t n) { return scope_alloc((size_t)n); }
void* resid_rt_outer_alloc(int64_t n) { return outer_alloc((size_t)n); }
void resid_rt_suspend(int64_t* s) {
    AllocSuspend a = alloc_suspend();
    s[0] = (int64_t)(intptr_t)a.cur;
    s[1] = (int64_t)(intptr_t)a.bulk;
    s[2] = a.depth;
}
void resid_rt_resume(const int64_t* s) {
    AllocSuspend a = { (Arena*)(intptr_t)s[0], (Arena*)(intptr_t)s[1], s[2] };
    alloc_resume(a);
}
/* Scope, bulk or current arena memory (never passed to free). */
int8_t resid_rt_in_arenas(const void* p) {
    return (int8_t)(scope_contains(p) || arena_chain_contains(g_bulk_arena, p) || arena_chain_contains(g_current_arena, p));
}

/* resid_alloc and the arena test for the Resid runtime. */
void* resid_rt_alloc(int64_t n) { return resid_alloc((size_t)n); }
int8_t resid_rt_arena_contains(const void* p);



/* print / println / eprintln: runtime/rt/io.resid. */

/* resid_abort / resid_abort_at, the catchable-abort machinery, structured
 * spawn, expectation failures and the test runner: runtime/rt/ctl.resid. */
_Noreturn void resid_abort_at(const char* msg, const char* at);
int8_t resid_regex_match(const char* pattern, const char* text);

/* The force-time capability guard: runtime/rt/caps.resid. */


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



/* resid_box_new / resid_box_alloc, the box accessors and resid_malloc:
 * runtime/rt/list.resid. */
void* resid_box_new(int64_t tag, int64_t count, void** src, const char* type);
int64_t resid_box_tag(void* b);
void* resid_box_slot(void* b, int64_t i);

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

/* The list code: runtime/rt/list.resid. Its helpers the map code still
 * uses are exported as resid_rt_*. */
ResidList* resid_rt_list_hdr(void);
FlatBuf* resid_rt_flatbuf_new(int64_t cap);
ResidList* resid_rt_pvec_append_into(ResidList* into, ResidList* v, void** elems, int64_t m);
ResidList* resid_rt_pvec_push(ResidList* v, void* elem);
#define list_hdr resid_rt_list_hdr
#define flatbuf_new resid_rt_flatbuf_new
#define pvec_append_into resid_rt_pvec_append_into
#define pvec_push_raw resid_rt_pvec_push
void* resid_list_new(int64_t count, void** src, const char* type);
int64_t resid_list_len(void* b);
void* resid_list_get(void* b, int64_t i);
const char* resid_list_type(void* b);
void** resid_list_to_array(void* b);


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
int8_t resid_rt_box_interned(const void* p) { return (int8_t)box_is_interned(p); }

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
/* The Dec arithmetic: runtime/rt/dec.resid. The block layout is shared
 * with resid_decp_persist and resid_dec_evac below. */
typedef struct {
    int8_t sign;     /* -1, 0, +1 */
    int32_t prec;    /* N */
    int32_t exp;
    int32_t n;       /* limbs */
    int32_t nd;      /* digits of coef */
    uint64_t l[];
} DecV;

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

/* ════════════════════════════════════════════════════════════════
   Stdlib v1: string verbs (spec §14 semantics, codepoint-based).
   Lists use the ResidVal box layout (see stdlib v1.3 below).
   ════════════════════════════════════════════════════════════════ */

/* str_trim / str_contains / str_starts_with / str_ends_with:
 * runtime/rt/strutil.resid. */

/* Case mapping (str_to_lower, str_to_upper), str_repeat, str_replace,
 * str_split and str_join: runtime/rt/case.resid, runtime/rt/strutil.resid. */

/* The list verbs (contains / reverse / sum / sort, list_sort_by):
 * runtime/rt/lists.resid. */

/* OS entropy, the AES-NI query, resid_index_abort and the TCP externs:
 * runtime/rt/net.resid. */
_Noreturn void resid_index_abort(int64_t idx, int64_t len, const char* at);

/* Maps and sets, the loop-region evacuation (resid_list_keep,
 * resid_map_evac, resid_dec_evac, resid_carry_free), resid_str_keep and
 * resid_str_from_codepoints: runtime/rt/map.resid, runtime/rt/text.resid. */
