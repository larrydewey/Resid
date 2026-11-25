/* A PCI function's memory by its address, and the listing of functions,
 * through the isolated device host (runtime/rt/device.resid, kinds 9 and
 * 10; PLAN-hardware-access.md §11).
 *
 * No test machine is sure to have a function whose resource it may map,
 * so most of this runs the host in self-test mode 30, which takes the
 * directory of functions from a tree of plain files the test makes under
 * /dev/shm in place of /sys/bus/pci/devices. The listing is also run
 * against the real directory.
 *
 * Like device_host.c this program is its own device host: the parent
 * calls resid_device_call (or _w), which re-executes /proc/self/exe as
 * "resid-device-host"; main sees that argv and hands over to
 * resid_device_host_test with the mode and root the parent left in
 * "<this program>.mode". */
#include <dirent.h>
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

/* An access to resource `res` of the function at `addr`, which must have
 * the ids `ven`:`dev`. */
static void req_pci(Req* r, int write, const char* addr, uint32_t size, int store, uint32_t off, int width, uint64_t v, int res, int ven, int dev) {
    char path[512];
    snprintf(path, sizeof path, "/sys/bus/pci/devices/%s", addr);
    head(r, 9, write, "fx.pci", path);
    u(r, size, 4); u(r, store, 1); u(r, off, 4); u(r, width, 1); u(r, v, 8);
    u(r, res, 1); u(r, ven, 2); u(r, dev, 2);
}

static void req_list(Req* r, int write, const char* path, uint32_t max) {
    head(r, 10, write, "fx.pci_list", path);
    u(r, max, 4);
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

/* A listing's answer: [0, one output, bytes, their length, the names a
 * line each]. Copies the text out; -1 when it is not one. */
static int listed(Rep* r, char* out, int cap) {
    if (r->n < 10 || r->b[0] != 0 || r->b[1] != 1 || r->b[5] != 1) return -1;
    int len = r->b[6] | (r->b[7] << 8) | (r->b[8] << 16) | (r->b[9] << 24);
    if (len < 0 || len + 10 != r->n || len >= cap) return -1;
    memcpy(out, r->b + 10, len);
    out[len] = 0;
    return len;
}
static int has_line(const char* text, const char* name) {
    char want[300];
    snprintf(want, sizeof want, "%s\n", name);
    const char* p = strstr(text, want);
    return p && (p == text || p[-1] == '\n');
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
    snprintf(root, sizeof root, "/dev/shm/resid_fx_pci_%d", (int)getpid());
    if (mkdir(root, 0700) != 0) { printf("SKIP device_pci (no /dev/shm)\n"); return 0; }
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

    /* The function with the descriptor's ids: its resource is read and written. */
    req_pci(&q, 0, "0000:00:04.0", 4096, 0, 16, 4, 0, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    memcpy(&w32, blk + 16, 4);
    check("pci_load", loaded(&r, w32));
    req_pci(&q, 0, "0000:00:04.0", 8092, 0, 8080, 8, 0, 4, 0x1af4, 0x1041);
    r = call(&q, 0);
    memcpy(&w64, blk + 100 + 8080, 8);
    check("pci_load_resource4", loaded(&r, w64));
    req_pci(&q, 1, "0000:00:04.0", 4096, 1, 0x70, 4, 0xdeadbeef, 0, 0x1af4, 0x1041);
    r = call(&q, 1);
    snprintf(p, sizeof p, "%s/resource0", d4);
    int fd = open(p, O_RDONLY);
    uint32_t got = 0;
    int rd = fd >= 0 && pread(fd, &got, 4, 0x70) == 4;
    check("pci_store", stored(&r) && rd && got == 0xdeadbeefu);
    /* A domain of more than four digits, a bus, device and function at their tops. */
    req_pci(&q, 0, "0001:3b:1f.7", 100, 0, 96, 4, 0, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    memcpy(&w32, blk + 96, 4);
    check("pci_load_other_domain", loaded(&r, w32));

    /* Another device at that address, or the descriptor's device at
     * another: Unsupported, and nothing written. */
    req_pci(&q, 1, "0000:00:04.0", 4096, 1, 0x80, 4, 0x55555555, 0, 0x1af4, 0x1042);
    r = call(&q, 1);
    rd = fd >= 0 && pread(fd, &got, 4, 0x80) == 4;
    memcpy(&w32, blk + 0x80, 4);
    check("pci_wrong_device_id", code(&r) == 6 && rd && got == w32);
    req_pci(&q, 1, "0000:00:04.0", 4096, 1, 0x80, 4, 0x55555555, 0, 0x1af5, 0x1041);
    r = call(&q, 1);
    rd = fd >= 0 && pread(fd, &got, 4, 0x80) == 4;
    check("pci_wrong_vendor_id", code(&r) == 6 && rd && got == w32);
    req_pci(&q, 0, "0000:00:05.0", 4096, 0, 16, 4, 0, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("pci_other_function", code(&r) == 6);
    if (fd >= 0) close(fd);

    /* No such function, no such resource, a resource the block does not fit. */
    req_pci(&q, 0, "0000:00:09.0", 4096, 0, 16, 4, 0, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("pci_absent_function", code(&r) == 1);
    req_pci(&q, 0, "0000:00:04.0", 4096, 0, 16, 4, 0, 5, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("pci_absent_resource", code(&r) == 1);
    req_pci(&q, 0, "0001:3b:1f.7", 4096, 0, 16, 4, 0, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("pci_resource_too_small", code(&r) == 6);

    /* Refused before anything is opened: a path that is not an address,
     * a resource past 5, an access outside the block, a store as a read. */
    req_pci(&q, 0, "0000:00:04.0/x", 4096, 0, 16, 4, 0, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("pci_refuses_longer_path", code(&r) == 10 && value(&r) == 65);
    req_pci(&q, 0, "0000:00:0g.0", 4096, 0, 16, 4, 0, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("pci_refuses_not_hex", code(&r) == 10 && value(&r) == 65);
    req_pci(&q, 0, "0000:00:04.8", 4096, 0, 16, 4, 0, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("pci_refuses_function_8", code(&r) == 10 && value(&r) == 65);
    req_pci(&q, 0, "0000:00:04.0", 4096, 0, 16, 4, 0, 6, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("pci_refuses_resource_6", code(&r) == 10 && value(&r) == 66);
    req_pci(&q, 0, "0000:00:04.0", 4096, 0, 4096, 4, 0, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("pci_refuses_past_block", code(&r) == 10 && value(&r) == 62);
    req_pci(&q, 0, "0000:00:04.0", 4096, 1, 0, 4, 1, 0, 0x1af4, 0x1041);
    r = call(&q, 0);
    check("pci_store_needs_write", code(&r) == 10 && value(&r) == 19);

    /* The functions present, a line each; names that start with a dot are
     * not functions. */
    char text[65536];
    req_list(&q, 0, "/sys/bus/pci/devices", 4096);
    r = call(&q, 0);
    int ln = listed(&r, text, sizeof text);
    check("pci_list_fake", ln == 39 && has_line(text, "0000:00:04.0") && has_line(text, "0000:00:05.0") && has_line(text, "0001:3b:1f.7") && !strstr(text, "hidden"));
    req_list(&q, 0, "/sys/bus/pci/devices", 20);
    r = call(&q, 0);
    check("pci_list_too_long", code(&r) == 4);
    req_list(&q, 0, "/sys/bus/pci", 4096);
    r = call(&q, 0);
    check("pci_list_refuses_other_path", code(&r) == 10 && value(&r) == 65);
    req_list(&q, 1, "/sys/bus/pci/devices", 4096);
    r = call(&q, 1);
    check("pci_list_is_a_read", code(&r) == 10 && value(&r) == 13);

    /* The real directory, when this machine has one: every name the
     * kernel lists is in the answer. */
    set_mode(0, NULL);
    DIR* dir = opendir("/sys/bus/pci/devices");
    req_list(&q, 0, "/sys/bus/pci/devices", 60000);
    r = call(&q, 0);
    if (!dir) {
        check("pci_list_real_absent", code(&r) == 1);
    } else {
        ln = listed(&r, text, sizeof text);
        int all = ln >= 0, count = 0;
        struct dirent* e;
        while ((e = readdir(dir)) != NULL) {
            if (e->d_name[0] == '.') continue;
            count++;
            if (ln < 0 || !has_line(text, e->d_name)) all = 0;
        }
        closedir(dir);
        int lines = 0;
        for (int i = 0; i < ln; i++) if (text[i] == '\n') lines++;
        check("pci_list_real", all && lines == count);
        /* A real function with other ids than asked for is refused, and one
         * that is not there is absent. */
        req_pci(&q, 0, "ffff:ff:1f.7", 4096, 0, 0, 4, 0, 0, 0x1af4, 0x1041);
        r = call(&q, 0);
        check("pci_real_absent_function", code(&r) == 1);
    }

    rm_tree(root);
    unlink(exe);
    return bad != 0;
}
