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
 * 13 the host checks that it zeroed its secrets; 14 a bad exit status;
 * 15 and 16 the host pretends AT_SECURE or a capability its parent lacks;
 * 17 to 19 a ConfigfsReport on the fake configfs whose host is killed,
 * never answers, or sees another writer before its first read; 20 a
 * write into the guard page before a region; 21 a shared mapping and 22
 * an munmap after the filter; 23 to 26 a kernel that follows Nested
 * pointers (fills them; 24 past the length, 25 into the guard page; 26
 * writes a needed length and fails with EIO); 27 a ConfigfsReport on a
 * fake configfs without service_guid and service_manifest_version, 28 one
 * that keeps what was written to them.
 *
 * The parent's side of a test (a shorter wall-clock limit, the fake
 * configfs root it cleans up) is set with resid_device_test_parent, which
 * no Resid program can name either. */
#include <dirent.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <time.h>
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
void resid_device_test_parent(int64_t ms, const char* root);
void* resid_malloc(int64_t n);

static char exe[4096];
static char self[4096];

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

/* /dev/zero as a request/response device: max 16 bytes each way. A
 * Transact writes its command, so it is a write request. */
static void req_zero(Req* r, int secret) {
    head(r, 2, 1, "fx.zero", "/dev/zero");
    u(r, 16, 4); u(r, 16, 4); u(r, secret, 1);
    u(r, 3, 4); u(r, 1, 1); u(r, 2, 1); u(r, 3, 1);
}

static void req_attr(Req* r) {
    head(r, 3, 0, "fx.cpu_online", "/sys/devices/system/cpu/online");
    u(r, 256, 4);
}

/* A pty master answers nothing until someone writes to its slave: a read
 * that blocks forever. */
static void req_ptmx_read(Req* r) {
    head(r, 2, 1, "fx.ptmx", "/dev/ptmx");
    u(r, 16, 4); u(r, 16, 4); u(r, 0, 1);
    u(r, 0, 4);
}

/* An ioctl with a Buffer whose length field is `lw` bytes wide, and a
 * second Buffer sharing it when `shared`. */
static void req_lenfield(Req* r, int lw, int shared) {
    head(r, 1, 0, "fx.len", "/dev/ptmx");
    uint32_t num = (3u << 30) | (24u << 16) | ('x' << 8) | 1;
    u(r, 2, 1); u(r, 0, 1); u(r, num, 4); u(r, 1, 1); u(r, num, 4);
    u(r, 24, 4); u(r, shared ? 3 : 2, 1);
    u(r, 2, 1); u(r, 0, 4); u(r, 8, 4); u(r, 256, 4); u(r, 2, 1); u(r, 0, 1);   /* Buffer(0, 8, 256, Out) */
    u(r, 0, 1); u(r, 8, 4); u(r, lw, 4); u(r, 3, 1);                            /* Scalar(8, lw, InOut) */
    if (shared) { u(r, 2, 1); u(r, 16, 4); u(r, 8, 4); u(r, 16, 4); u(r, 2, 1); u(r, 0, 1); }   /* Buffer(16, 8, 16, Out) */
    u(r, 0, 1); u(r, 0, 1);
    u(r, 0, 1);
}

/* A Nested buffer (spec §49): a 32-byte struct whose Buffer at 0 (64
 * bytes, `pdir`) holds the Nested pointer at 16 and its 4-byte length at
 * 24 (max 4096, Out), a Scalar out at 8, and an Errno field when `errno_f`.
 * The program's input is the parent's 64 bytes, with `len` at 24. No
 * device any user can open follows such a pointer: modes 23-26 play the
 * kernel (the ioctl itself, an unknown request on /dev/ptmx, is ENOTTY). */
static void req_nested(Req* r, uint32_t len, int errno_f, int pdir) {
    head(r, 1, 1, "fx.nested", "/dev/ptmx");
    uint32_t num = (3u << 30) | (32u << 16) | ('T' << 8) | 0x7f;
    u(r, 2, 1); u(r, 0, 1); u(r, num, 4); u(r, 1, 1); u(r, num, 4);
    u(r, 32, 4); u(r, errno_f ? 4 : 3, 1);
    u(r, 2, 1); u(r, 0, 4); u(r, 0xffffffff, 4); u(r, 64, 4); u(r, pdir, 1); u(r, 0, 1);              /* Buffer(0, -1, 64, pdir) */
    u(r, 3, 1); u(r, 0, 4); u(r, 16, 4); u(r, 24, 4); u(r, 4, 1); u(r, 4096, 4); u(r, 2, 1); u(r, 0, 1); /* Nested(0, 16, 24, 4, 4096, Out) */
    u(r, 0, 1); u(r, 8, 4); u(r, 8, 4); u(r, 2, 1);                                                   /* Scalar(8, 8, Out) */
    if (errno_f) u(r, 4, 1);                                                                          /* Errno */
    u(r, 0, 1); u(r, 0, 1);
    u(r, 1, 1); u(r, 1, 1); u(r, 64, 4);
    for (int i = 0; i < 64; i++) u(r, i == 24 ? (len & 255) : i == 25 ? ((len >> 8) & 255) : i == 26 ? ((len >> 16) & 255) : i == 27 ? (len >> 24) : 0x11, 1);
}

static uint32_t le32(const uint8_t* p) { return p[0] | (p[1] << 8) | (p[2] << 16) | ((uint32_t)p[3] << 24); }

static const char* report_root = "/sys/kernel/config/tsm/report";

/* A report with a service provider, a service GUID ("" for none) and a
 * manifest version (-1 for none). */
static void req_report_svc(Req* r, const char* provider, int64_t privlevel, const char* sp, const char* guid, int64_t version) {
    head(r, 4, 0, "fx.report", report_root);
    u(r, 1, 1); str(r, provider);
    u(r, 64, 4); u(r, 64, 4); u(r, 64, 4); u(r, 64, 4);
    u(r, 4, 4); u(r, 'n', 1); u(r, 'o', 1); u(r, 'n', 1); u(r, 'c', 1);
    u(r, (uint64_t)privlevel, 8);
    str(r, sp);
    str(r, guid);
    u(r, (uint64_t)version, 8);
}

static void req_report(Req* r, const char* provider, int64_t privlevel) {
    req_report_svc(r, provider, privlevel, "", "", -1);
}

/* What self-test 28 kept of attribute `name`: root/kept_<name>, read into
 * out and removed. */
static int read_kept(const char* root, const char* name, char* out, int cap) {
    char f[4600];
    snprintf(f, sizeof f, "%s/kept_%s", root, name);
    FILE* fp = fopen(f, "r");
    int n = fp ? (int)fread(out, 1, cap - 1, fp) : -1;
    if (fp) fclose(fp);
    if (n >= 0) out[n] = 0;
    unlink(f);
    return n;
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

static double now_s(void) {
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec + t.tv_nsec / 1e9;
}

/* Start this program as a device host by hand, as anyone who can run it
 * could, with the request written into its socket beforehand: through
 * bash (`bash_parent`: another executable), else from a child of this
 * program that makes the socket itself and then never answers the host's
 * challenge. The host's exit status; *n the bytes it sent. */
static int host_by_hand(int bash_parent, Req* q, uint8_t* out, int* n) {
    int pp[2];
    pipe(pp);
    pid_t x = fork();
    if (x == 0) {
        close(pp[0]);
        int sv[2];
        socketpair(AF_UNIX, SOCK_STREAM, 0, sv);
        uint64_t len = q->n;
        write(sv[0], &len, 8);
        write(sv[0], q->b, q->n);
        pid_t y = fork();
        if (y == 0) {
            close(sv[0]);
            dup2(sv[1], 3);
            if (sv[1] != 3) close(sv[1]);
            if (bash_parent) {
                execl("/bin/bash", "bash", "-c", "(exec -c -a resid-device-host \"$0\"); exit $?", self, (char*)0);
            } else {
                char* av[] = {"resid-device-host", NULL};
                char* ev[] = {NULL};
                execve("/proc/self/exe", av, ev);
            }
            _exit(127);
        }
        close(sv[1]);
        int st;
        waitpid(y, &st, 0);
        int k, got = 0;
        while ((k = read(sv[0], out + got, 4096 - got)) > 0) got += k;
        write(pp[1], &got, sizeof got);
        _exit(WIFEXITED(st) ? WEXITSTATUS(st) : 128 + WTERMSIG(st));
    }
    close(pp[1]);
    *n = -1;
    read(pp[0], n, sizeof *n);
    close(pp[0]);
    int st;
    waitpid(x, &st, 0);
    return WIFEXITED(st) ? WEXITSTATUS(st) : 128 + WTERMSIG(st);
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
    ssize_t sl = readlink("/proc/self/exe", self, 4000);
    self[sl < 0 ? 0 : sl] = 0;
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
    r = call_mode(2, NULL, &q, 1);
    check("device_overrun_canary_transact", code(&r) == 8);

    /* A read past the buffer stops at the guard page (the kernel faults or
     * returns short of it), and a write into the guard faults the host:
     * Overrun either way. */
    req_zero(&q, 0);
    r = call_mode(3, NULL, &q, 1);
    check("device_overrun_guard_page", code(&r) == 8);
    req_ptn(&q);
    r = call_mode(4, NULL, &q, 0);
    check("device_overrun_guard_page_fault", code(&r) == 8);
    /* Every region has a guard page of its own before it too. */
    r = call_mode(20, NULL, &q, 0);
    check("device_overrun_guard_page_before", code(&r) == 8);

    /* After the filter: memory only private, anonymous and not
     * executable; no munmap (a guard page stays). */
    r = call_mode(21, NULL, &q, 0);
    check("device_seccomp_mmap_shared", code(&r) == 11 && value(&r) == 256 + 31);
    r = call_mode(22, NULL, &q, 0);
    check("device_seccomp_munmap", code(&r) == 11 && value(&r) == 256 + 31);

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
    r = call_mode(13, NULL, &q, 1);
    int ok = code(&r) == 0 && r.n == 10 && r.b[5] == 2 && r.b[6] == 16;
    void* s = resid_device_secret(0);
    ok = ok && resid_list_len(s) == 16;
    for (int i = 0; ok && i < 16; i++) ok = resid_unbox_i64(resid_list_get(s, i)) == 0;
    ok = ok && resid_list_len(resid_device_secret(0)) == 0 && resid_list_len(resid_device_secret(1)) == 0;
    check("device_secret_out", ok);

    /* ConfigfsReport: a report root that exists nowhere (on an SNP or TDX
     * guest /sys/kernel/config/tsm/report does); then the whole flow on a
     * fake configfs, under Landlock. */
    report_root = "/sys/kernel/config/resid-no-such-tsm/report";
    req_report(&q, "fake_tsm", -1);
    r = call_mode(0, NULL, &q, 0);
    check("configfs_absent", code(&r) == 1);
    report_root = "/sys/kernel/config/tsm/report";
    char root[] = "/tmp/resid-devhost-XXXXXX";
    if (!mkdtemp(root)) { puts("FAIL no temporary directory"); return 1; }
    resid_device_test_parent(0, root);
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
    /* An SVSM report of one service in one manifest version: service_provider,
     * service_guid and service_manifest_version each one store, so the
     * generation is 4 with inblob's. */
    const char* guid = "c0b406a4-a803-4952-9743-3fb6014cd0ae";
    req_report_svc(&q, "fake_tsm", -1, "svsm", guid, 3);
    r = call_mode(9, root, &q, 0);
    check("configfs_report_service_guid", code(&r) == 0 && r.n == 61 && r.b[52] == 0 && r.b[53] == 4 && dir_empty(root));
    /* What reached the attributes (self-test 28 leaves them). */
    char got[128], gotv[32];
    r = call_mode(28, root, &q, 0);
    int gn = read_kept(root, "service_guid", got, sizeof got);
    int vn = read_kept(root, "service_manifest_version", gotv, sizeof gotv);
    check("configfs_service_written", code(&r) == 0 && gn == 36 && strcmp(got, guid) == 0 && vn == 2 && strcmp(gotv, "3\n") == 0 && dir_empty(root));
    /* A provider without the attributes (an SNP guest with no SVSM). */
    r = call_mode(27, root, &q, 0);
    check("configfs_service_guid_missing_attr", code(&r) == 6 && dir_empty(root));
    /* The parent refuses a malformed GUID, a version past a u32, and
     * either without a service provider: no host starts. */
    req_report_svc(&q, "fake_tsm", -1, "svsm", "c0b406a4-a803-4952-9743-3fb6014cd0aZ", -1);
    r = call_mode(9, root, &q, 0);
    int bad1 = code(&r) == 10 && value(&r) == 24;
    req_report_svc(&q, "fake_tsm", -1, "svsm", "", 4294967296LL);
    r = call_mode(9, root, &q, 0);
    int bad2 = code(&r) == 10 && value(&r) == 24;
    req_report_svc(&q, "fake_tsm", -1, "", guid, -1);
    r = call_mode(9, root, &q, 0);
    int bad3 = code(&r) == 10 && value(&r) == 24;
    check("configfs_service_options_refused", bad1 && bad2 && bad3 && dir_empty(root));
    req_report(&q, "fake_tsm", -1);
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
    /* Both generation reads agree, but on more stores than this host made:
     * someone else wrote to the entry before the first read. */
    r = call_mode(19, root, &q, 0);
    check("configfs_generation_foreign_write", code(&r) == 5 && dir_empty(root));
    /* A host killed after it made the entry, or one that never answers:
     * the parent removes the entry (it chose the name). */
    r = call_mode(17, root, &q, 0);
    check("configfs_killed_entry_removed", code(&r) == 11 && value(&r) == 256 + 9 && dir_empty(root));
    resid_device_test_parent(1500, root);
    double t0 = now_s();
    r = call_mode(18, root, &q, 0);
    check("configfs_timeout_entry_removed", code(&r) == 12 && now_s() - t0 < 10 && dir_empty(root));
    resid_device_test_parent(0, NULL);
    /* No symbolic link on the way to the report root (openat2). */
    char real[4200], ln[4200], via[4200];
    snprintf(real, sizeof real, "%s/real", root);
    snprintf(ln, sizeof ln, "%s/ln", root);
    snprintf(via, sizeof via, "%s/ln/sub", root);
    mkdir(real, 0700);
    snprintf(via, sizeof via, "%s/real/sub", root);
    mkdir(via, 0700);
    symlink(real, ln);
    snprintf(via, sizeof via, "%s/ln/sub", root);
    resid_device_test_parent(0, via);
    r = call_mode(9, via, &q, 0);
    check("configfs_root_symlink_refused", code(&r) == 6);
    resid_device_test_parent(0, NULL);
    unlink(ln);
    snprintf(via, sizeof via, "%s/real/sub", root);
    rmdir(via);
    rmdir(real);
    rmdir(root);

    /* A call that never finishes (a pty master read with no writer) is
     * Timeout once the wall-clock limit passes, not a hang. */
    resid_device_test_parent(1500, NULL);
    req_ptmx_read(&q);
    t0 = now_s();
    r = call_mode(0, NULL, &q, 1);
    check("device_timeout", code(&r) == 12 && now_s() - t0 < 10);
    resid_device_test_parent(0, NULL);

    /* With SIGCHLD ignored (inherited), the host's status is still read:
     * the runtime puts the default disposition back. */
    signal(SIGCHLD, SIG_IGN);
    req_ptn(&q);
    r = call_mode(0, NULL, &q, 0);
    check("device_sigchld_ignored", code(&r) == 0);
    signal(SIGCHLD, SIG_DFL);

    /* A host started by hand: refused before it reads a request -- from
     * another executable, and from this one when the parent does not
     * answer the challenge (the request written beforehand). Then the
     * host refuses AT_SECURE and a capability beyond its parent's. */
    uint8_t hb[4096];
    int hn;
    req_attr(&q);
    int hst = host_by_hand(1, &q, hb, &hn);
    check("device_host_by_hand_other_exe", hst == 124 && hn == 0);
    hst = host_by_hand(0, &q, hb, &hn);
    check("device_host_by_hand_no_answer", hst == 124 && hn == 16);
    req_ptn(&q);
    r = call_mode(15, NULL, &q, 0);
    check("device_host_at_secure", code(&r) == 11 && value(&r) == 512 + 124);
    r = call_mode(16, NULL, &q, 0);
    check("device_host_capability", code(&r) == 11 && value(&r) == 512 + 124);

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
    /* A Transact writes: refused as a read, by both entries. */
    req_zero(&q, 0);
    q.b[5] = 0;
    r = reply(resid_device_call_w(list_of(&q)));
    check("device_transact_read_refused", code(&r) == 10 && value(&r) == 19);
    /* A length field too narrow for its buffer's maximum (one byte for
     * 256), and one length field for two buffers. */
    req_lenfield(&q, 4, 0);
    r = reply(resid_device_call(list_of(&q)));
    int ok_wide = code(&r) != 10;
    req_lenfield(&q, 1, 0);
    r = reply(resid_device_call(list_of(&q)));
    check("device_length_field_narrow_refused", ok_wide && code(&r) == 10 && value(&r) == 42);
    req_lenfield(&q, 4, 1);
    r = reply(resid_device_call(list_of(&q)));
    check("device_length_field_shared_refused", code(&r) == 10 && value(&r) == 42);

    /* Nested buffers: the host places each in its own guarded region,
     * writes its address into the parent buffer and its length (as the
     * program wrote it, at most the maximum) beside it, and zeroes the
     * address in the parent's output -- the pointer never reaches the
     * program. Reply: parent (5 + 64), nested (5 + 100), Scalar (9). */
    req_nested(&q, 100, 0, 3);
    r = call_mode(23, NULL, &q, 1);
    ok = code(&r) == 0 && r.n == 5 + 69 + 105 + 9 && r.b[5] == 1 && le32(r.b + 6) == 64;
    for (int i = 0; ok && i < 8; i++) ok = r.b[10 + 16 + i] == 0;
    ok = ok && le32(r.b + 10 + 24) == 100 && r.b[10] == 0x11 && r.b[10 + 63] == 0x11;
    ok = ok && r.b[74] == 1 && le32(r.b + 75) == 100;
    for (int i = 0; ok && i < 100; i++) ok = r.b[79 + i] == 0xa5;
    check("device_nested_placed", ok);
    check("device_nested_pointer_never_leaks", ok && r.b[10 + 16] == 0 && r.b[10 + 23] == 0);
    /* A kernel that writes past the Nested buffer: the canary after its
     * length, or the guard page after its region. */
    r = call_mode(24, NULL, &q, 1);
    check("device_nested_overrun_canary", code(&r) == 8);
    r = call_mode(25, NULL, &q, 1);
    check("device_nested_overrun_guard_page", code(&r) == 8);
    /* A length the program wrote past the maximum: refused (60). */
    req_nested(&q, 5000, 0, 3);
    r = call_mode(23, NULL, &q, 1);
    check("device_nested_length_refused", code(&r) == 10 && value(&r) == 60);
    /* The parent must go to the kernel: an Out parent is refused (42). */
    req_nested(&q, 100, 0, 2);
    r = reply(resid_device_call_w(list_of(&q)));
    check("device_nested_out_parent_refused", code(&r) == 10 && value(&r) == 42);
    /* Errno: a failed ioctl (EIO, the needed length written back) gives the
     * outputs with the errno, so a wrapper can retry; without the field
     * it is Kernel(EIO). */
    req_nested(&q, 100, 1, 3);
    r = call_mode(26, NULL, &q, 1);
    ok = code(&r) == 0 && r.n == 5 + 69 + 105 + 9 + 9 && le32(r.b + 10 + 24) == 8192 && r.b[10 + 16] == 0;
    ok = ok && r.b[188] == 0 && r.b[189] == 5;
    check("device_errno_outputs", ok);
    req_nested(&q, 100, 0, 3);
    r = call_mode(26, NULL, &q, 1);
    check("device_errno_opt_in", code(&r) == 3 && value(&r) == 5);
    /* ENOTTY stays Unsupported with an Errno field: another layout. */
    req_nested(&q, 100, 1, 3);
    r = call_mode(0, NULL, &q, 1);
    check("device_errno_enotty_unsupported", code(&r) == 6);

    /* The request (the program's inputs) is wiped before it is freed: the
     * next block of its size holds none of it. */
    req_attr(&q);
    r = reply(resid_device_call(list_of(&q)));
    uint8_t* again = resid_malloc(q.n);
    int leaked = 0;
    for (int i = 0; i + 5 <= q.n; i++) if (memcmp(again + i, "/sys/", 5) == 0) leaked = 1;
    check("device_request_wiped", code(&r) == 0 && !leaked);

    char p[4096];
    mode_path(p);
    unlink(p);
    return bad != 0;
}
