/* runtime/rt/malloc.resid: a secret-mode lock refused by RLIMIT_MEMLOCK
 * is counted (resid_secret_unlocked), and a big block whose mapping
 * mremap will not grow is copied into a new one instead of failing. */
#include <errno.h>
#include <linux/filter.h>
#include <linux/seccomp.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/resource.h>
#include <sys/syscall.h>
#include <unistd.h>

int8_t resid_secret_mode_set(int on);
int64_t resid_secret_unlocked(void);
void* resid_gmalloc(int64_t n);
void* resid_xrealloc(void* p, int64_t n);

/* mremap fails with ENOMEM from here on. */
static int deny_mremap(void) {
    struct sock_filter f[] = {
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, nr)),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, SYS_mremap, 0, 1),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ERRNO | ENOMEM),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
    };
    struct sock_fprog prog = {sizeof f / sizeof f[0], f};
    return prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) == 0 && prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) == 0;
}

int main(void) {
    int fails = 0;
    struct rlimit none = {0, 0};
    if (setrlimit(RLIMIT_MEMLOCK, &none) != 0) { printf("setrlimit failed\n"); return 1; }
    if (resid_secret_unlocked() != 0) { printf("control: a refusal counted before secret mode\n"); fails++; }
    resid_secret_mode_set(1);
    unsigned char* p = resid_gmalloc(1 << 20);
    /* Root keeps CAP_IPC_LOCK and is not refused. */
    if (geteuid() != 0 && resid_secret_unlocked() == 0) { printf("a refused lock was not counted\n"); fails++; }
    memset(p, 0x5A, 1 << 20);
    if (!deny_mremap()) { printf("seccomp failed\n"); return 1; }
    unsigned char* q = resid_xrealloc(p, 4 << 20);
    int64_t kept = 0;
    for (int64_t i = 0; i < (1 << 20); i++) kept += q[i] == 0x5A;
    if (kept != (1 << 20)) { printf("realloc kept %lld of %d bytes\n", (long long)kept, 1 << 20); fails++; }
    memset(q, 0x33, 4 << 20);
    if (fails == 0) printf("secret_lock ok\n");
    return fails != 0;
}
