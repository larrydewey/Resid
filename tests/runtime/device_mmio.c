/* One load or store in a device's mapped memory through the isolated
 * device host (runtime/rt/device.resid, kind 8; PLAN-hardware-access.md
 * §11). The device here is a file under /dev/shm, the fixture a host
 * accepts beside a PCI function's sysfs resource.
 *
 * Like device_host.c this program is its own device host: the parent
 * calls resid_device_call (or _w), which re-executes /proc/self/exe as
 * "resid-device-host"; main sees that argv and hands over to
 * resid_device_host_test with no self-test mode. */
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

void* resid_box_i64(int64_t v);
int64_t resid_unbox_i64(void* p);
void* resid_list_new(int64_t n, void** items, const char* ty);
int64_t resid_list_len(void* l);
void* resid_list_get(void* l, int64_t i);
void* resid_device_call(void* req);
void* resid_device_call_w(void* req);
void resid_device_host_test(int64_t argc, char** argv, char** envp, int64_t mode, const char* root);

typedef struct { uint8_t b[4096]; int n; } Req;
typedef struct { int n; uint8_t b[8192]; } Rep;

static void u(Req* r, uint64_t v, int n) { for (int i = 0; i < n; i++) r->b[r->n++] = (v >> (8 * i)) & 255; }
static void str(Req* r, const char* s) { u(r, strlen(s), 2); memcpy(r->b + r->n, s, strlen(s)); r->n += strlen(s); }

/* An Mmio request: the block's size, then the access (0 a load, 1 a
 * store), its offset, its width in bytes and the value to store. */
static void req_mmio(Req* r, int write, const char* path, uint32_t size, int store, uint32_t off, int width, uint64_t v) {
    r->n = 0;
    u(r, 'R', 1); u(r, 'D', 1); u(r, 'V', 1); u(r, 1, 1); u(r, 8, 1); u(r, write, 1);
    str(r, "fx.mmio"); str(r, path);
    u(r, size, 4); u(r, store, 1); u(r, off, 4); u(r, width, 1); u(r, v, 8);
}

static void* list_of(Req* r) {
    void* items[4096];
    for (int i = 0; i < r->n; i++) items[i] = resid_box_i64(r->b[i]);
    return resid_list_new(r->n, items, "List(Int(64))");
}

static Rep reply(void* l) {
    Rep r;
    r.n = (int)resid_list_len(l);
    for (int i = 0; i < r.n && i < 8192; i++) r.b[i] = (uint8_t)resid_unbox_i64(resid_list_get(l, i));
    return r;
}

static Rep call(Req* q, int write) { return reply(write ? resid_device_call_w(list_of(q)) : resid_device_call(list_of(q))); }

/* The error code, or 0 for a success reply; an error's value. */
static int code(Rep* r) { return r->n >= 10 && r->b[0] == 1 ? r->b[1] : 0; }
static int64_t value(Rep* r) {
    int64_t v = 0;
    for (int i = 7; i >= 0; i--) v = (v << 8) | r->b[2 + i];
    return v;
}

/* A load's answer: [0, one output, a number, its 8 bytes]. */
static int loaded(Rep* r, uint64_t want) {
    if (r->n != 14 || r->b[0] != 0 || r->b[1] != 1 || r->b[5] != 0) return 0;
    uint64_t v = 0;
    for (int i = 7; i >= 0; i--) v = (v << 8) | r->b[6 + i];
    return v == want;
}
/* A store's answer: [0, no output]. */
static int stored(Rep* r) { return r->n == 5 && r->b[0] == 0 && r->b[1] == 0; }

static int bad = 0;
static void check(const char* name, int ok) {
    printf("%s %s\n", ok ? "PASS" : "FAIL", name);
    if (!ok) bad++;
}

int main(int argc, char** argv, char** envp) {
    if (argc == 1 && strcmp(argv[0], "resid-device-host") == 0) {
        resid_device_host_test(argc, argv, envp, 0, NULL);
        return 125;   /* not a host after all */
    }
    char path[256], small[256];
    snprintf(path, sizeof path, "/dev/shm/resid_fx_mmio_%d", (int)getpid());
    snprintf(small, sizeof small, "/dev/shm/resid_fx_mmio_small_%d", (int)getpid());
    int fd = open(path, O_RDWR | O_CREAT | O_TRUNC, 0600);
    if (fd < 0) { printf("SKIP device_mmio (no /dev/shm)\n"); return 0; }
    uint8_t blk[4096];
    for (int i = 0; i < 4096; i++) blk[i] = (uint8_t)(i * 7 + 3);
    if (write(fd, blk, 4096) != 4096) return 2;
    Req q;
    Rep r;

    /* Loads of each width read the file's bytes, little endian. */
    req_mmio(&q, 0, path, 4096, 0, 16, 4, 0);
    r = call(&q, 0);
    uint32_t w32; memcpy(&w32, blk + 16, 4);
    check("mmio_load_32", loaded(&r, w32));
    req_mmio(&q, 0, path, 4096, 0, 33, 1, 0);
    r = call(&q, 0);
    check("mmio_load_8", loaded(&r, blk[33]));
    req_mmio(&q, 0, path, 4096, 0, 34, 2, 0);
    r = call(&q, 0);
    uint16_t w16; memcpy(&w16, blk + 34, 2);
    check("mmio_load_16", loaded(&r, w16));
    req_mmio(&q, 0, path, 4096, 0, 4088, 8, 0);
    r = call(&q, 0);
    uint64_t w64; memcpy(&w64, blk + 4088, 8);
    check("mmio_load_64_last", loaded(&r, w64));

    /* A store reaches the file, as wide as asked and no wider. */
    req_mmio(&q, 1, path, 4096, 1, 0x70, 4, 0x1122334455667788ull);
    r = call(&q, 1);
    uint8_t got[8];
    int rd = pread(fd, got, 8, 0x70) == 8;
    uint32_t s32; memcpy(&s32, got, 4);
    check("mmio_store_32", stored(&r) && rd && s32 == 0x55667788u && got[4] == blk[0x74] && got[7] == blk[0x77]);
    req_mmio(&q, 1, path, 4096, 1, 0x80, 8, 0xfedcba9876543210ull);
    r = call(&q, 1);
    uint64_t s64 = 0;
    rd = pread(fd, &s64, 8, 0x80) == 8;
    check("mmio_store_64", stored(&r) && rd && s64 == 0xfedcba9876543210ull);
    req_mmio(&q, 1, path, 4096, 1, 0x91, 1, 0xab);
    r = call(&q, 1);
    rd = pread(fd, got, 3, 0x90) == 3;
    check("mmio_store_8", stored(&r) && rd && got[0] == blk[0x90] && got[1] == 0xab && got[2] == blk[0x92]);
    /* ...and the next load sees it. */
    req_mmio(&q, 0, path, 4096, 0, 0x70, 4, 0);
    r = call(&q, 0);
    check("mmio_load_after_store", loaded(&r, 0x55667788u));
    /* A load may travel under a write too (a register read by a driver that writes). */
    req_mmio(&q, 1, path, 4096, 0, 0x80, 8, 0);
    r = call(&q, 1);
    check("mmio_load_under_write", loaded(&r, 0xfedcba9876543210ull));

    /* Refused before anything is opened: an offset that is not a multiple
     * of the width, an access past the block, a width that is no word, a
     * store that travels as a read. */
    req_mmio(&q, 0, path, 4096, 0, 6, 4, 0);
    r = call(&q, 0);
    check("mmio_refuses_unaligned", code(&r) == 10 && value(&r) == 62);
    req_mmio(&q, 0, path, 4096, 0, 4096, 4, 0);
    r = call(&q, 0);
    check("mmio_refuses_past_block", code(&r) == 10 && value(&r) == 62);
    req_mmio(&q, 0, path, 4096, 0, 4092, 8, 0);
    r = call(&q, 0);
    check("mmio_refuses_straddle", code(&r) == 10 && value(&r) == 62);
    req_mmio(&q, 0, path, 4096, 0, 0, 3, 0);
    r = call(&q, 0);
    check("mmio_refuses_width", code(&r) == 10 && value(&r) == 61);
    req_mmio(&q, 0, path, 4096, 1, 0, 4, 1);
    r = call(&q, 0);
    check("mmio_store_needs_write", code(&r) == 10 && value(&r) == 19);
    req_mmio(&q, 0, path, 4096, 2, 0, 4, 0);
    r = call(&q, 0);
    check("mmio_refuses_access_kind", code(&r) == 10 && value(&r) == 63);
    /* The read entry never carries a write (Denied), whatever the access. */
    req_mmio(&q, 1, path, 4096, 1, 0, 4, 1);
    r = call(&q, 0);
    uint32_t still; memcpy(&still, blk, 4);
    uint32_t now0 = 0;
    rd = pread(fd, &now0, 4, 0) == 4;
    check("mmio_read_entry_no_store", code(&r) == 2 && rd && now0 == still);

    /* A block the file does not hold, a character device and a missing
     * file are answers, not faults. */
    int sfd = open(small, O_RDWR | O_CREAT | O_TRUNC, 0600);
    if (sfd >= 0 && write(sfd, blk, 100) == 100) {
        req_mmio(&q, 0, small, 4096, 0, 0, 4, 0);
        r = call(&q, 0);
        check("mmio_file_too_small", code(&r) == 6);
        close(sfd);
    }
    unlink(small);
    req_mmio(&q, 0, "/dev/zero", 4096, 0, 0, 4, 0);
    r = call(&q, 0);
    check("mmio_not_a_char_device", code(&r) == 6);
    req_mmio(&q, 0, "/dev/shm/resid_fx_mmio_missing", 4096, 0, 0, 4, 0);
    r = call(&q, 0);
    check("mmio_absent", code(&r) == 1);
    /* A file that may not be written is still read, and a store is Denied. */
    fchmod(fd, 0400);
    req_mmio(&q, 0, path, 4096, 0, 16, 4, 0);
    r = call(&q, 0);
    check("mmio_load_read_only_file", loaded(&r, w32));
    if (geteuid() != 0) {
        req_mmio(&q, 1, path, 4096, 1, 16, 4, 9);
        r = call(&q, 1);
        check("mmio_store_read_only_file", code(&r) == 2);
    }

    close(fd);
    unlink(path);
    return bad != 0;
}
