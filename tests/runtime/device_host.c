/* The isolated device host's fault paths (spec §49, PLAN-device-access.md
 * §4-§6, runtime/rt/device.resid).
 *
 * This program is its own device host: the parent calls resid_device_call
 * (or _w), which re-executes /proc/self/exe as "resid-device-host" with an
 * empty environment and the call's socket as fd 3; main below sees that
 * argv and hands over to resid_device_host_test with the self-test mode the
 * parent left in "<this program>.mode". That entry exists only for a C
 * harness: no Resid program can name it, and the mode reaches the host
 * through neither the environment nor argv.
 *
 * Modes: 0 none; 1 a system call the filter does not allow; 2 a spoiled
 * canary; 3 a read that runs into the guard page; 4 a write into the guard
 * page; 5 the host killed; 6 a reply that does not parse; 7 an output
 * longer than its bytes; 8 more bytes than any reply; 9 to 12 a
 * ConfigfsReport against a fake configfs at the given root (10 another
 * writer changes the generation, 11 no Landlock, 12 no outblob);
 * 13 the host checks that it zeroed its secrets; 14 a bad exit status. */
#include <dirent.h>
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
void* resid_device_secret(int64_t k);
void resid_device_host_test(int64_t argc, char** argv, char** envp, int64_t mode, const char* root);

static char exe[4096];

static void mode_path(char* out) {
    ssize_t n = readlink("/proc/self/exe", out, 4000);
    out[n < 0 ? 0 : n] = 0;
    strcat(out, ".mode");
}

static void set_mode(int mode, const char* root) {
    char p[4096];
    mode_path(p);
    FILE* f = fopen(p, "w");
    fprintf(f, "%d %s\n", mode, root ? root : "-");
    fclose(f);
}

/* ─── Requests (lib/dev/device.resid's "Serialization") ─── */

typedef struct { uint8_t b[4096]; int n; } Req;

static void u(Req* r, uint64_t v, int n) { for (int i = 0; i < n; i++) r->b[r->n++] = (v >> (8 * i)) & 255; }
static void str(Req* r, const char* s) { u(r, strlen(s), 2); memcpy(r->b + r->n, s, strlen(s)); r->n += strlen(s); }

static void head(Req* r, int kind, int write, const char* name, const char* path) {
    r->n = 0;
    u(r, 'R', 1); u(r, 'D', 1); u(r, 'V', 1); u(r, 1, 1); u(r, kind, 1); u(r, write, 1);
    str(r, name); str(r, path);
}

static void* list_of(Req* r) {
    void* items[4096];
    for (int i = 0; i < r->n; i++) items[i] = resid_box_i64(r->b[i]);
    return resid_list_new(r->n, items, "List(Int(64))");
}

/* TIOCGPTN on /dev/ptmx: one Scalar out. */
static void req_ptn(Req* r) {
    head(r, 1, 0, "fx.tiocgptn", "/dev/ptmx");
    u(r, 2, 1); u(r, 0, 1); u(r, 0x80045430, 4); u(r, 1, 1); u(r, 0x80045430, 4);
    u(r, 4, 4); u(r, 1, 1);
    u(r, 0, 1); u(r, 0, 4); u(r, 4, 4); u(r, 2, 1);   /* Scalar(0, 4, Out) */
    u(r, 0, 1); u(r, 0, 1);                           /* unversioned, uapi */
    u(r, 0, 1);                                       /* no inputs */
}

/* /dev/zero as a request/response device: max 16 bytes each way. */
static void req_zero(Req* r, int secret) {
    head(r, 2, 0, "fx.zero", "/dev/zero");
    u(r, 16, 4); u(r, 16, 4); u(r, secret, 1);
    u(r, 3, 4); u(r, 1, 1); u(r, 2, 1); u(r, 3, 1);
}

static void req_attr(Req* r) {
    head(r, 3, 0, "fx.cpu_online", "/sys/devices/system/cpu/online");
    u(r, 256, 4);
}

static void req_report(Req* r, const char* provider, int64_t privlevel) {
    head(r, 4, 0, "fx.report", "/sys/kernel/config/tsm/report");
    u(r, 1, 1); str(r, provider);
    u(r, 64, 4); u(r, 64, 4); u(r, 64, 4); u(r, 64, 4);
    u(r, 4, 4); u(r, 'n', 1); u(r, 'o', 1); u(r, 'n', 1); u(r, 'c', 1);
    u(r, (uint64_t)privlevel, 8);
    u(r, 0, 2);
}

/* ─── Replies ─── */

typedef struct { int n; uint8_t b[8192]; } Rep;

static Rep reply(void* l) {
    Rep r;
    r.n = (int)resid_list_len(l);
    for (int i = 0; i < r.n && i < 8192; i++) r.b[i] = (uint8_t)resid_unbox_i64(resid_list_get(l, i));
    return r;
}

/* The error code, or 0 for a success reply. */
static int code(Rep* r) { return r->n >= 10 && r->b[0] == 1 ? r->b[1] : 0; }

static int64_t value(Rep* r) {
    int64_t v = 0;
    for (int i = 7; i >= 0; i--) v = (v << 8) | r->b[2 + i];
    return v;
}

static int bad = 0;

static void check(const char* name, int ok) {
    printf("%s %s\n", ok ? "PASS" : "FAIL", name);
    if (!ok) bad++;
}

static Rep call_mode(int mode, const char* root, Req* q, int write) {
    set_mode(mode, root);
    Rep r = reply(write ? resid_device_call_w(list_of(q)) : resid_device_call(list_of(q)));
    set_mode(0, NULL);
    return r;
}

static int count_fds(void) {
    int n = 0;
    DIR* d = opendir("/proc/self/fd");
    while (readdir(d)) n++;
    closedir(d);
    return n;
}

static int dir_empty(const char* p) {
    int n = 0;
    DIR* d = opendir(p);
    struct dirent* e;
    while ((e = readdir(d))) if (strcmp(e->d_name, ".") && strcmp(e->d_name, "..")) n++;
    closedir(d);
    return n == 0;
}

int main(int argc, char** argv, char** envp) {
    if (argc == 1 && strcmp(argv[0], "resid-device-host") == 0) {
        char p[4096], root[4096];
        int mode = 0;
        mode_path(p);
        FILE* f = fopen(p, "r");
        if (f) { if (fscanf(f, "%d %4000s", &mode, root) != 2) mode = 0; fclose(f); }
        resid_device_host_test(argc, argv, envp, mode, strcmp(root, "-") ? root : NULL);
        return 125;   /* not a host after all */
    }
    mode_path(exe);
    Req q;
    Rep r;

    /* A plain call works, so the faults below are the self-tests'. */
    req_ptn(&q);
    r = call_mode(0, NULL, &q, 0);
    check("device_ioctl_plain", code(&r) == 0 && r.n == 14 && r.b[5] == 0);

    /* The filter kills the host on any call it does not allow (SIGSYS). */
    req_attr(&q);
    r = call_mode(1, NULL, &q, 0);
    check("device_seccomp_kills", code(&r) == 11 && value(&r) == 256 + 31);

    /* A kernel write into a buffer's slack spoils the canary: Overrun. */
    req_ptn(&q);
    r = call_mode(2, NULL, &q, 0);
    check("device_overrun_canary", code(&r) == 8);
    req_zero(&q, 0);
    r = call_mode(2, NULL, &q, 0);
    check("device_overrun_canary_transact", code(&r) == 8);

    /* A read past the buffer stops at the guard page (the kernel faults or
     * returns short of it), and a write into the guard faults the host:
     * Overrun either way. */
    req_zero(&q, 0);
    r = call_mode(3, NULL, &q, 0);
    check("device_overrun_guard_page", code(&r) == 8);
    req_ptn(&q);
    r = call_mode(4, NULL, &q, 0);
    check("device_overrun_guard_page_fault", code(&r) == 8);

    /* A killed host or a bad exit is an error value, not an abort. */
    req_ptn(&q);
    r = call_mode(5, NULL, &q, 0);
    check("device_host_killed", code(&r) == 11 && value(&r) == 256 + 9);
    r = call_mode(14, NULL, &q, 0);
    check("device_host_bad_exit", code(&r) == 11 && value(&r) == 512 + 42);

    /* A reply that does not parse, an output longer than its bytes, more
     * bytes than the descriptor allows: malformed. */
    req_attr(&q);
    r = call_mode(6, NULL, &q, 0);
    check("device_reply_malformed", code(&r) == 11 && value(&r) == 1024);
    r = call_mode(7, NULL, &q, 0);
    check("device_reply_length_checked", code(&r) == 11 && value(&r) == 1024);
    r = call_mode(8, NULL, &q, 0);
    check("device_reply_oversized", code(&r) == 11 && (value(&r) == 1024 || value(&r) == 256 + 13));

    /* Secret output: only its length is in the reply; the bytes come once
     * from resid_device_secret; the host zeroed its copies (mode 13 checks,
     * exiting 99 if not). */
    req_zero(&q, 1);
    r = call_mode(13, NULL, &q, 0);
    int ok = code(&r) == 0 && r.n == 10 && r.b[5] == 2 && r.b[6] == 16;
    void* s = resid_device_secret(0);
    ok = ok && resid_list_len(s) == 16;
    for (int i = 0; ok && i < 16; i++) ok = resid_unbox_i64(resid_list_get(s, i)) == 0;
    ok = ok && resid_list_len(resid_device_secret(0)) == 0 && resid_list_len(resid_device_secret(1)) == 0;
    check("device_secret_out", ok);

    /* ConfigfsReport: the real root is not here; then the whole flow on a
     * fake configfs, under Landlock. */
    req_report(&q, "fake_tsm", -1);
    r = call_mode(0, NULL, &q, 0);
    check("configfs_absent", code(&r) == 1);
    char root[] = "/tmp/resid-devhost-XXXXXX";
    if (!mkdtemp(root)) { puts("FAIL no temporary directory"); return 1; }
    r = call_mode(9, root, &q, 0);
    ok = code(&r) == 0 && r.n > 5 && r.b[0] == 0 && r.b[1] == 5;
    /* outblob "fake report", auxblob "fake aux", no manifestblob,
     * provider "fake_tsm", generation 1 */
    ok = ok && r.n == 5 + 5 + 11 + 5 + 8 + 5 + 5 + 8 + 9;
    ok = ok && memcmp(r.b + 10, "fake report", 11) == 0 && memcmp(r.b + 26, "fake aux", 8) == 0;
    ok = ok && memcmp(r.b + 44, "fake_tsm", 8) == 0 && r.b[52] == 0 && r.b[53] == 1;
    check("configfs_report_fake", ok && dir_empty(root));
    req_report(&q, "fake_tsm", 2);
    r = call_mode(9, root, &q, 0);
    check("configfs_report_privlevel", code(&r) == 0 && dir_empty(root));
    req_report(&q, "sev_guest", -1);
    r = call_mode(9, root, &q, 0);
    check("configfs_unknown_provider_err", code(&r) == 9 && value(&r) == 8 && r.n == 18 && memcmp(r.b + 10, "fake_tsm", 8) == 0 && dir_empty(root));
    req_report(&q, "fake_tsm", -1);
    r = call_mode(10, root, &q, 0);
    check("configfs_generation_changed", code(&r) == 5 && dir_empty(root));
    r = call_mode(11, root, &q, 0);
    check("configfs_no_landlock_fails_closed", code(&r) == 6 && dir_empty(root));
    r = call_mode(12, root, &q, 0);
    check("configfs_missing_attr_err", code(&r) == 6 && dir_empty(root));
    rmdir(root);

    /* Stateless, and nothing left open in the program. */
    int before = count_fds();
    req_ptn(&q);
    Rep a = call_mode(0, NULL, &q, 0);
    Rep b = call_mode(0, NULL, &q, 0);
    req_attr(&q);
    Rep c = call_mode(0, NULL, &q, 0);
    check("device_stateless", code(&a) == 0 && code(&b) == 0 && code(&c) == 0 && count_fds() == before);

    /* The parent's own checks: a write through the read entry, and a
     * request that does not parse, never start a host. */
    req_ptn(&q);
    q.b[5] = 1;
    r = reply(resid_device_call(list_of(&q)));
    check("device_read_entry_refuses_write", code(&r) == 2);
    req_ptn(&q);
    q.b[q.n - 1] = 1;   /* an input the descriptor does not take */
    r = reply(resid_device_call(list_of(&q)));
    check("device_request_refused", code(&r) == 10);
    req_ptn(&q);
    q.b[q.n - 8] = 9;   /* the Scalar's width: 9 bytes */
    r = reply(resid_device_call(list_of(&q)));
    check("device_layout_refused", code(&r) == 10);

    char p[4096];
    mode_path(p);
    unlink(p);
    return bad != 0;
}
