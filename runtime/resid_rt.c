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

/* resid_alloc and the arena test for the Resid runtime. */
void* resid_rt_alloc(int64_t n) { return resid_alloc((size_t)n); }
int8_t resid_rt_arena_contains(const void* p);



/* print / println / eprintln: runtime/rt/io.resid. */

/* resid_abort / resid_abort_at, the catchable-abort machinery, structured
 * spawn, expectation failures and the test runner: runtime/rt/ctl.resid. */
_Noreturn void resid_abort_at(const char* msg, const char* at);
int8_t resid_regex_match(const char* pattern, const char* text);

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
