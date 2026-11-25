/* A session: one device host kept alive for many accesses to a PCI
 * function's resource (runtime/rt/device.resid, kinds 11 to 13;
 * PLAN-hardware-access.md §11).
 *
 * As device_pci.c, the host runs in self-test mode 30 against a tree of
 * plain files under /dev/shm in place of /sys/bus/pci/devices, and this
 * program is its own device host. */
#include <dirent.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

void* resid_box_i64(int64_t v);
int64_t resid_unbox_i64(void* p);
void* resid_list_new(int64_t n, void** items, const char* ty);
int64_t resid_list_len(void* l);
void* resid_list_get(void* l, int64_t i);
void* resid_device_call(void* req);
void* resid_device_call_w(void* req);
void resid_device_host_test(int64_t argc, char** argv, char** envp, int64_t mode, const char* root);

static char exe[4096];

static void mode_path(char* out) {
    ssize_t n = readlink("/proc/self/exe", out, 4000);
    out[n < 0 ? 0 : n] = 0;
    strcat(out, ".mode");
}

static void set_mode(int mode, const char* root) {
    FILE* f = fopen(exe, "w");
    if (!f) return;
    fprintf(f, "%d %s\n", mode, root ? root : "-");
    fclose(f);
}

typedef struct { uint8_t b[4096]; int n; } Req;
typedef struct { int n; uint8_t b[65536]; } Rep;

static void u(Req* r, uint64_t v, int n) { for (int i = 0; i < n; i++) r->b[r->n++] = (v >> (8 * i)) & 255; }
static void str(Req* r, const char* s) { u(r, strlen(s), 2); memcpy(r->b + r->n, s, strlen(s)); r->n += strlen(s); }

static void head(Req* r, int kind, int write, const char* name, const char* path) {
    r->n = 0;
    u(r, 'R', 1); u(r, 'D', 1); u(r, 'V', 1); u(r, 1, 1); u(r, kind, 1); u(r, write, 1);
    str(r, name); str(r, path);
}

/* Open a session on resource `res` of the function at `addr`, which must
 * have the ids `ven`:`dev`: kind 9's request with a load of one byte. */
static void req_open(Req* r, int write, const char* addr, uint32_t size, int res, int ven, int dev) {
    char path[512];
    snprintf(path, sizeof path, "/sys/bus/pci/devices/%s", addr);
    head(r, 11, write, "fx.sess", path);
    u(r, size, 4); u(r, 0, 1); u(r, 0, 4); u(r, 1, 1); u(r, 0, 8);
    u(r, res, 1); u(r, ven, 2); u(r, dev, 2);
    u(r, 0, 1);   /* no other resource */
}
/* The same with a second resource, `res2`, mapped for `size2` bytes. */
static void req_open2(Req* r, int write, const char* addr, uint32_t size, int res, int ven, int dev, int res2, uint32_t size2) {
    req_open(r, write, addr, size, res, ven, dev);
    r->n--;
    u(r, 1, 1); u(r, res2, 1); u(r, size2, 4);
}
/* A session with `dma` bytes of memory for the device at address `iova`
 * (kind 14): the open's request, then the two. Under self-test 30 the
 * host holds plain memory there, as the last of the session's resources. */
static void req_dma(Req* r, const char* addr, uint32_t size, int res, int ven, int dev, uint32_t dma, uint64_t iova) {
    req_open(r, 1, addr, size, res, ven, dev);
    r->b[4] = 14;
    u(r, dma, 4); u(r, iova, 8);
}
/* Bytes of that memory read (kind 15) or written (kind 16) whole. */
static void req_bulk(Req* r, uint64_t id, int map, uint32_t off, uint32_t len, const uint8_t* data) {
    r->n = 0;
    u(r, 'R', 1); u(r, 'D', 1); u(r, 'V', 1); u(r, 1, 1); u(r, data ? 16 : 15, 1); u(r, data ? 1 : 0, 1);
    u(r, id, 8); u(r, map, 1); u(r, off, 4); u(r, len, 4);
    if (data) { memcpy(r->b + r->n, data, len); r->n += len; }
}
/* A reply of one run of bytes equal to `want`. */
static int bytes_are(Rep* r, const uint8_t* want, int len) {
    if (r->n != 10 + len || r->b[0] != 0 || r->b[1] != 1 || r->b[5] != 1) return 0;
    return (r->b[6] | (r->b[7] << 8)) == len && memcmp(r->b + 10, want, len) == 0;
}
/* A batch (kind 18): begun for session `id`, then operations added. */
static void batch_begin(Req* r, uint64_t id, int write) {
    r->n = 0;
    u(r, 'R', 1); u(r, 'D', 1); u(r, 'V', 1); u(r, 1, 1); u(r, 18, 1); u(r, write, 1);
    u(r, id, 8);
}
static void batch_op(Req* r, int op, int width, int map, uint32_t off, uint64_t v, const uint8_t* data) {
    u(r, op, 1); u(r, width, 1); u(r, map, 1); u(r, 0, 1); u(r, off, 4); u(r, v, 8);
    if (data) { memcpy(r->b + r->n, data, v); r->n += v; }
}
static int map_index = 0;   /* which of the session's resources the next accesses name */
static void req_access(Req* r, uint64_t id, int store, uint32_t off, int width, uint64_t v) {
    r->n = 0;
    u(r, 'R', 1); u(r, 'D', 1); u(r, 'V', 1); u(r, 1, 1); u(r, 12, 1); u(r, store, 1);
    u(r, id, 8); u(r, off, 4); u(r, width, 1); u(r, v, 8); u(r, map_index, 1);
}
static void req_close(Req* r, uint64_t id) {
    r->n = 0;
    u(r, 'R', 1); u(r, 'D', 1); u(r, 'V', 1); u(r, 1, 1); u(r, 13, 1); u(r, 0, 1);
    u(r, id, 8);
}

static void* list_of(Req* r) {
    void* items[4096];
    for (int i = 0; i < r->n; i++) items[i] = resid_box_i64(r->b[i]);
    return resid_list_new(r->n, items, "List(Int(64))");
}

static Rep reply(void* l) {
    Rep r;
    r.n = (int)resid_list_len(l);
    for (int i = 0; i < r.n && i < 65536; i++) r.b[i] = (uint8_t)resid_unbox_i64(resid_list_get(l, i));
    return r;
}

static Rep call(Req* q, int write) { return reply(write ? resid_device_call_w(list_of(q)) : resid_device_call(list_of(q))); }

static int code(Rep* r) { return r->n >= 10 && r->b[0] == 1 ? r->b[1] : 0; }
static int64_t value(Rep* r) {
    int64_t v = 0;
    for (int i = 7; i >= 0; i--) v = (v << 8) | r->b[2 + i];
    return v;
}
static int loaded(Rep* r, uint64_t want) {
    if (r->n != 14 || r->b[0] != 0 || r->b[1] != 1 || r->b[5] != 0) return 0;
    uint64_t v = 0;
    for (int i = 7; i >= 0; i--) v = (v << 8) | r->b[6 + i];
    return v == want;
}
static int stored(Rep* r) { return r->n == 5 && r->b[0] == 0 && r->b[1] == 0; }

/* A reply of one number (a session's, or a word loaded); 0 when it is not one. */
static uint64_t number(Rep* r) {
    if (r->n != 14 || r->b[0] != 0 || r->b[1] != 1 || r->b[5] != 0) return 0;
    uint64_t v = 0;
    for (int i = 7; i >= 0; i--) v = (v << 8) | r->b[6 + i];
    return v;
}

static int bad = 0;
static void check(const char* name, int ok) {
    printf("%s %s\n", ok ? "PASS" : "FAIL", name);
    if (!ok) bad++;
}

static void put(const char* dir, const char* file, const void* data, int n) {
    char p[600];
    snprintf(p, sizeof p, "%s/%s", dir, file);
    int fd = open(p, O_WRONLY | O_CREAT | O_TRUNC, 0600);
    if (fd >= 0) { if (write(fd, data, n) != n) bad++; close(fd); }
}

static void rm_tree(const char* root) {
    static const char* fns[] = {"0000:00:04.0", "0000:00:05.0", "0001:3b:1f.7", NULL};
    static const char* files[] = {"vendor", "device", "resource0", "resource4", NULL};
    char p[700];
    for (int i = 0; fns[i]; i++) {
        for (int j = 0; files[j]; j++) { snprintf(p, sizeof p, "%s/%s/%s", root, fns[i], files[j]); unlink(p); }
        snprintf(p, sizeof p, "%s/%s", root, fns[i]);
        rmdir(p);
    }
    snprintf(p, sizeof p, "%s/.hidden", root);
    unlink(p);
    rmdir(root);
}

int main(int argc, char** argv, char** envp) {
    if (argc == 1 && strcmp(argv[0], "resid-device-host") == 0) {
        char p[4096], root[4096];
        int mode = 0;
        mode_path(p);
        root[0] = 0;
        FILE* f = fopen(p, "r");
        if (f) { if (fscanf(f, "%d %4000s", &mode, root) != 2) mode = 0; fclose(f); }
        resid_device_host_test(argc, argv, envp, mode, (mode != 0 && strcmp(root, "-")) ? root : NULL);
        return 125;   /* not a host after all */
    }
    mode_path(exe);
    char root[256], d4[320], d5[320], d7[320];
    snprintf(root, sizeof root, "/dev/shm/resid_fx_sess_%d", (int)getpid());
    if (mkdir(root, 0700) != 0) { printf("SKIP device_session (no /dev/shm)\n"); return 0; }
    snprintf(d4, sizeof d4, "%s/0000:00:04.0", root);
    snprintf(d5, sizeof d5, "%s/0000:00:05.0", root);
    snprintf(d7, sizeof d7, "%s/0001:3b:1f.7", root);
    mkdir(d4, 0700); mkdir(d5, 0700); mkdir(d7, 0700);
    uint8_t blk[8192];
    for (int i = 0; i < 8192; i++) blk[i] = (uint8_t)(i * 5 + 1);
    put(d4, "vendor", "0x1af4\n", 7); put(d4, "device", "0x1041\n", 7);
    put(d4, "resource0", blk, 4096); put(d4, "resource4", blk + 100, 8092);
    put(d5, "vendor", "0x8086\n", 7); put(d5, "device", "0x1234\n", 7);
    put(d5, "resource0", blk, 4096);
    put(d7, "vendor", "0x1af4\n", 7); put(d7, "device", "0x1041\n", 7);
    put(d7, "resource0", blk, 100);
    put(root, ".hidden", "x", 1);
    Req q;
    Rep r;
    char p[700];
    uint32_t w32;
    uint64_t w64;
    set_mode(30, root);

    /* A session that only loads. */
    req_open(&q, 0, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    uint64_t ro = number(&r);
    check("session_open", ro > 0);
    req_access(&q, ro, 0, 16, 4, 0);
    r = call(&q, 0);
    memcpy(&w32, blk + 16, 4);
    check("session_load", loaded(&r, w32));
    req_access(&q, ro, 0, 4088, 8, 0);
    r = call(&q, 0);
    memcpy(&w64, blk + 4088, 8);
    check("session_load_wide", loaded(&r, w64));
    req_access(&q, ro, 0, 3, 1, 0);
    r = call(&q, 0);
    check("session_load_byte", loaded(&r, blk[3]));
    /* A store is a write: the read entry refuses it, and the host refuses
     * one in a session that was opened to load. Neither ends the session. */
    req_access(&q, ro, 1, 0x70, 4, 0x11111111);
    r = call(&q, 0);
    check("session_store_needs_write_grant", code(&r) == 2);
    r = call(&q, 1);
    check("session_store_needs_write_session", code(&r) == 10 && value(&r) == 72);
    req_access(&q, ro, 0, 4096, 4, 0);
    r = call(&q, 0);
    check("session_refuses_past_block", code(&r) == 10 && value(&r) == 72);
    req_access(&q, ro, 0, 2, 4, 0);
    r = call(&q, 0);
    check("session_refuses_unaligned", code(&r) == 10 && value(&r) == 72);
    req_access(&q, ro, 0, 16, 4, 0);
    r = call(&q, 0);
    check("session_survives_refusals", loaded(&r, w32));

    /* A second session, at the same time, that writes. */
    req_open(&q, 1, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041);
    r = call(&q, 1);
    uint64_t rw = number(&r);
    check("session_open_write", rw > 0 && rw != ro);
    req_access(&q, rw, 1, 0x70, 4, 0xdeadbeef);
    r = call(&q, 1);
    check("session_store", stored(&r));
    req_access(&q, rw, 0, 0x70, 4, 0);
    r = call(&q, 0);
    check("session_store_read_back", loaded(&r, 0xdeadbeefu));
    req_access(&q, ro, 0, 0x70, 4, 0);
    r = call(&q, 0);
    check("session_other_sees_store", loaded(&r, 0xdeadbeefu));
    snprintf(p, sizeof p, "%s/resource0", d4);
    int fd = open(p, O_RDONLY);
    uint32_t got = 0;
    check("session_store_reached_file", fd >= 0 && pread(fd, &got, 4, 0x70) == 4 && got == 0xdeadbeefu);
    if (fd >= 0) close(fd);

    /* Many accesses through one host. Timed as the best of five passes:
     * one pass is at the mercy of whatever else the machine is doing. */
    struct timespec t0, t1;
    int same = 1;
    double us = 1e9;
    for (int pass = 0; pass < 5; pass++) {
        clock_gettime(CLOCK_MONOTONIC, &t0);
        for (int i = 0; i < 2000; i++) {
            req_access(&q, ro, 0, 16, 4, 0);
            r = call(&q, 0);
            if (!loaded(&r, w32)) same = 0;
        }
        clock_gettime(CLOCK_MONOTONIC, &t1);
        double one = ((t1.tv_sec - t0.tv_sec) * 1e9 + (t1.tv_nsec - t0.tv_nsec)) / 2000.0 / 1000.0;
        fprintf(stderr, "note: pass %d: %.1f microseconds a load through a session\n", pass + 1, one);
        if (one < us) us = one;
    }
    check("session_2000_loads", same);
    fprintf(stderr, "note: %.1f microseconds a load through a session (best of five)\n", us);

    /* Ended: its number names nothing, and ending it again is refused. */
    req_close(&q, ro);
    r = call(&q, 0);
    check("session_close", stored(&r));
    req_access(&q, ro, 0, 16, 4, 0);
    r = call(&q, 0);
    check("session_ended_is_refused", code(&r) == 10 && value(&r) == 71);
    req_close(&q, ro);
    r = call(&q, 0);
    check("session_close_twice", code(&r) == 10 && value(&r) == 71);
    req_access(&q, rw, 0, 16, 4, 0);
    r = call(&q, 0);
    check("session_other_still_open", loaded(&r, w32));
    req_close(&q, rw);
    r = call(&q, 0);
    check("session_close_write", stored(&r));
    req_access(&q, 12345, 0, 16, 4, 0);
    r = call(&q, 0);
    check("session_unknown_number", code(&r) == 10 && value(&r) == 71);

    /* Not opened: another device there, no function, a resource too small,
     * a bad address, a write session under the read entry. */
    req_open(&q, 0, "0000:00:05.0", 4096, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("session_wrong_ids", code(&r) == 6);
    req_open(&q, 0, "0000:00:09.0", 4096, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("session_absent_function", code(&r) == 1);
    req_open(&q, 0, "0001:3b:1f.7", 4096, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("session_resource_too_small", code(&r) == 6);
    req_open(&q, 0, "0000:00:04.0/x", 4096, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("session_refuses_bad_address", code(&r) == 10 && value(&r) == 65);
    req_open(&q, 1, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("session_write_needs_grant", code(&r) == 2);

    /* One session over two of the function's resources: each access names
     * its resource and is held to that one's size. */
    req_open2(&q, 0, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041, 4, 8092);
    r = call(&q, 0);
    uint64_t two = number(&r);
    check("session_two_resources", two > 0);
    req_access(&q, two, 0, 16, 4, 0);
    r = call(&q, 0);
    memcpy(&w32, blk + 16, 4);
    check("session_first_resource", loaded(&r, w32));
    map_index = 1;
    req_access(&q, two, 0, 8080, 8, 0);
    r = call(&q, 0);
    memcpy(&w64, blk + 100 + 8080, 8);
    check("session_second_resource", loaded(&r, w64));
    req_access(&q, two, 0, 8092, 4, 0);
    r = call(&q, 0);
    check("session_second_resource_bound", code(&r) == 10 && value(&r) == 72);
    map_index = 2;
    req_access(&q, two, 0, 0, 4, 0);
    r = call(&q, 0);
    check("session_unknown_resource", code(&r) == 10 && value(&r) == 72);
    map_index = 0;
    req_access(&q, two, 0, 8080, 8, 0);
    r = call(&q, 0);
    check("session_first_resource_bound", code(&r) == 10 && value(&r) == 72);
    req_close(&q, two);
    r = call(&q, 0);
    check("session_two_closed", stored(&r));
    req_open2(&q, 0, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041, 5, 4096);
    r = call(&q, 0);
    check("session_second_resource_absent", code(&r) == 1);
    req_open2(&q, 0, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041, 6, 4096);
    r = call(&q, 0);
    check("session_refuses_resource_6", code(&r) == 10 && value(&r) == 67);

    /* A session with memory for the device: its words and whole runs of
     * its bytes are read and written; a register is not read by the run. */
    req_dma(&q, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041, 8192, 0x100000);
    r = call(&q, 1);
    uint64_t dm = number(&r);
    check("dma_open", dm > 0);
    r = call(&q, 0);
    check("dma_open_needs_write_grant", code(&r) == 2);
    uint8_t pat[300];
    for (int i = 0; i < 300; i++) pat[i] = (uint8_t)(i * 7 + 3);
    req_bulk(&q, dm, 1, 50, 300, pat);
    r = call(&q, 1);
    check("dma_write_bytes", stored(&r));
    req_bulk(&q, dm, 1, 50, 300, NULL);
    r = call(&q, 0);
    check("dma_read_bytes", bytes_are(&r, pat, 300));
    map_index = 1;
    req_access(&q, dm, 0, 52, 4, 0);
    r = call(&q, 0);
    memcpy(&w32, pat + 2, 4);
    check("dma_load_word", loaded(&r, w32));
    req_access(&q, dm, 1, 4096, 8, 0x1122334455667788ull);
    r = call(&q, 1);
    req_access(&q, dm, 0, 4096, 8, 0);
    r = call(&q, 0);
    check("dma_store_word", loaded(&r, 0x1122334455667788ull));
    map_index = 0;
    req_access(&q, dm, 0, 16, 4, 0);
    r = call(&q, 0);
    memcpy(&w32, blk + 16, 4);
    check("dma_register_load", loaded(&r, w32));
    req_bulk(&q, dm, 0, 0, 16, NULL);
    r = call(&q, 0);
    check("dma_no_run_from_register", code(&r) == 10 && value(&r) == 72);
    req_bulk(&q, dm, 1, 8000, 300, NULL);
    r = call(&q, 0);
    check("dma_run_past_end", code(&r) == 10 && value(&r) == 72);
    req_bulk(&q, dm, 1, 0, 300, pat);
    r = call(&q, 0);
    check("dma_write_bytes_needs_grant", code(&r) == 2);
    req_bulk(&q, dm, 1, 0, 8, NULL);
    r = call(&q, 0);
    uint8_t zero[8] = {0};
    check("dma_untouched_is_zero", bytes_are(&r, zero, 8));
    /* Several operations in one message: bytes in, a word stored, the
     * word and the bytes read back, a register loaded, a short wait. */
    uint8_t run[40];
    for (int i = 0; i < 40; i++) run[i] = (uint8_t)(200 - i);
    batch_begin(&q, dm, 1);
    batch_op(&q, 4, 0, 1, 1000, 40, run);
    batch_op(&q, 2, 4, 1, 2000, 0xcafef00d, NULL);
    batch_op(&q, 1, 4, 1, 2000, 0, NULL);
    batch_op(&q, 3, 0, 1, 1000, 40, NULL);
    batch_op(&q, 1, 4, 0, 16, 0, NULL);
    batch_op(&q, 5, 0, 0, 0, 20, NULL);
    r = call(&q, 1);
    memcpy(&w32, blk + 16, 4);
    int bok = r.n == 5 + 9 + (5 + 40) + 9 + 9 && r.b[0] == 0 && r.b[1] == 4;
    uint32_t b1 = 0, b3 = 0;
    if (bok) { memcpy(&b1, r.b + 6, 4); memcpy(&b3, r.b + 14 + 45 + 1, 4); }
    check("batch_six_operations", bok && b1 == 0xcafef00du && r.b[14] == 1 && memcmp(r.b + 19, run, 40) == 0 && b3 == w32 && r.b[14 + 45 + 9] == 0);
    r = call(&q, 0);
    check("batch_with_stores_needs_write_grant", code(&r) == 2);
    q.b[5] = 0;
    r = call(&q, 0);
    check("batch_must_say_it_writes", code(&r) == 10 && value(&r) == 76);
    /* The third operation is past the memory: refused by number, and the
     * store before it was made. */
    batch_begin(&q, dm, 1);
    batch_op(&q, 2, 4, 1, 3000, 0x12345678, NULL);
    batch_op(&q, 1, 4, 1, 3000, 0, NULL);
    batch_op(&q, 1, 4, 1, 8192, 0, NULL);
    r = call(&q, 1);
    check("batch_refused_at_third", code(&r) == 10 && value(&r) == 1002);
    map_index = 1;
    req_access(&q, dm, 0, 3000, 4, 0);
    r = call(&q, 0);
    check("batch_earlier_store_made", loaded(&r, 0x12345678u));
    map_index = 0;
    /* A run of bytes is never a register's; an unknown operation. */
    batch_begin(&q, dm, 0);
    batch_op(&q, 3, 0, 0, 0, 16, NULL);
    r = call(&q, 0);
    check("batch_no_run_from_register", code(&r) == 10 && value(&r) == 1000);
    batch_begin(&q, dm, 0);
    batch_op(&q, 9, 0, 0, 0, 0, NULL);
    r = call(&q, 0);
    check("batch_unknown_operation", code(&r) == 10 && value(&r) == 76);
    /* Many loads in one message, timed: the best of five passes. */
    int bsame = 1;
    double bus = 1e9;
    for (int pass = 0; pass < 5; pass++) {
        clock_gettime(CLOCK_MONOTONIC, &t0);
        for (int k = 0; k < 200; k++) {
            batch_begin(&q, dm, 0);
            for (int i = 0; i < 10; i++) batch_op(&q, 1, 4, 0, 16, 0, NULL);
            r = call(&q, 0);
            if (r.n != 5 + 90 || memcmp(r.b + 6, &w32, 4) != 0) bsame = 0;
        }
        clock_gettime(CLOCK_MONOTONIC, &t1);
        double one = ((t1.tv_sec - t0.tv_sec) * 1e9 + (t1.tv_nsec - t0.tv_nsec)) / 2000.0 / 1000.0;
        if (one < bus) bus = one;
    }
    check("batch_2000_loads", bsame);
    fprintf(stderr, "note: %.1f microseconds a load in a batch of ten (best of five)\n", bus);

    /* Waiting for an interrupt: none comes here, so the time passes; a
     * plain session has none to wait for. */
    q.n = 0;
    u(&q, 'R', 1); u(&q, 'D', 1); u(&q, 'V', 1); u(&q, 1, 1); u(&q, 17, 1); u(&q, 0, 1); u(&q, dm, 8); u(&q, 150, 4);
    clock_gettime(CLOCK_MONOTONIC, &t0);
    r = call(&q, 0);
    clock_gettime(CLOCK_MONOTONIC, &t1);
    double waited = (t1.tv_sec - t0.tv_sec) * 1e3 + (t1.tv_nsec - t0.tv_nsec) / 1e6;
    check("dma_wait_times_out", r.n == 14 && r.b[0] == 0 && number(&r) == 0 && waited >= 140 && waited < 2000);
    q.b[q.n - 4] = 0x61; q.b[q.n - 3] = 0xea;   /* 60001 ms */
    r = call(&q, 0);
    check("dma_wait_refuses_long", code(&r) == 10 && value(&r) == 74);
    req_access(&q, dm, 0, 16, 4, 0);
    r = call(&q, 0);
    check("dma_alive_after_wait", loaded(&r, w32));
    req_close(&q, dm);
    r = call(&q, 0);
    check("dma_close", stored(&r));
    req_open(&q, 0, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    uint64_t plain = number(&r);
    q.n = 0;
    u(&q, 'R', 1); u(&q, 'D', 1); u(&q, 'V', 1); u(&q, 1, 1); u(&q, 17, 1); u(&q, 0, 1); u(&q, plain, 8); u(&q, 10, 4);
    r = call(&q, 0);
    check("session_has_no_interrupt", code(&r) == 10 && value(&r) == 75);
    req_close(&q, plain);
    r = call(&q, 0);
    req_dma(&q, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041, 5000, 0x100000);
    r = call(&q, 1);
    check("dma_refuses_part_page", code(&r) == 10 && value(&r) == 68);
    req_dma(&q, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041, 8192, 0x100800);
    r = call(&q, 1);
    check("dma_refuses_unaligned_address", code(&r) == 10 && value(&r) == 68);
    req_dma(&q, "0000:00:05.0", 4096, 0, 0x1af4, 0x1041, 8192, 0x100000);
    r = call(&q, 1);
    check("dma_wrong_ids", code(&r) == 6);

    /* Eight at once on a thread, and no ninth; all end. */
    uint64_t ids[9];
    int opened = 0;
    for (int i = 0; i < 8; i++) {
        req_open(&q, 0, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041);
        r = call(&q, 0);
        ids[i] = number(&r);
        if (ids[i] > 0) opened++;
    }
    req_open(&q, 0, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("session_eight_at_once", opened == 8 && code(&r) == 10 && value(&r) == 70);
    int closed = 0;
    for (int i = 0; i < 8; i++) {
        req_close(&q, ids[i]);
        r = call(&q, 0);
        if (stored(&r)) closed++;
    }
    check("session_all_closed", closed == 8);
    /* The slots are free again. */
    req_open(&q, 0, "0000:00:04.0", 4096, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    uint64_t again = number(&r);
    check("session_slot_reused_number_not", again > ids[7]);
    req_close(&q, again);
    r = call(&q, 0);

    rm_tree(root);
    unlink(exe);
    return bad != 0;
}
