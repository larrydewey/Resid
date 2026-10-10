/* Secret mode turns core dumps off (spec §48, runtime/rt/malloc.resid
 * rt_secret_mode_set): a core would hold the registers (vector registers
 * keep AES round keys), static data and the initial stack, which no
 * MADV_DONTDUMP on the heap covers. Once resid_secret_mode_set(1) runs:
 *   - the process is not dumpable (PR_GET_DUMPABLE is 0),
 *   - RLIMIT_CORE is {0, 0},
 *   - the initial stack mapping carries the dd (do not dump) flag,
 *   - an abort prints its message and exits with status 134 instead of
 *     raising SIGABRT,
 *   - a fatal signal (SIGSEGV) leaves no core, even with RLIMIT_CORE
 *     raised as far as the process can before the mode is set.
 * The controls run without the mode: an abort is SIGABRT, and the process
 * starts dumpable. Whether a control's core is actually written depends on
 * the host's core_pattern, so only the secret side checks WCOREDUMP. */
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <unistd.h>

int8_t resid_secret_mode_set(int on);
void resid_abort(const char* msg);

/* Whether the "[stack]" entry of /proc/self/smaps lists the dd flag. */
static int stack_dd(void) {
    FILE* f = fopen("/proc/self/smaps", "r");
    if (!f) return -1;
    char line[512];
    int in_stack = 0, dd = 0;
    while (fgets(line, sizeof line, f)) {
        /* A mapping's header line starts with its lowercase-hex address;
         * every field line starts with a capital letter. */
        if (line[0] && strchr("0123456789abcdef", line[0]))
            in_stack = strstr(line, "[stack]") != NULL;
        if (in_stack && strncmp(line, "VmFlags:", 8) == 0) dd = strstr(line, " dd") != NULL;
    }
    fclose(f);
    return dd;
}

/* Run what(mode) in a child with stderr captured; its wait status. */
static int child(void (*what)(int), int mode, char* err, size_t cap) {
    int fds[2];
    if (pipe(fds) != 0) return -1;
    pid_t pid = fork();
    if (pid == 0) {
        close(fds[0]);
        dup2(fds[1], 2);
        what(mode);
        _exit(0);
    }
    close(fds[1]);
    size_t n = 0;
    ssize_t r;
    while (n + 1 < cap && (r = read(fds[0], err + n, cap - 1 - n)) > 0) n += (size_t)r;
    err[n] = 0;
    close(fds[0]);
    int st = 0;
    waitpid(pid, &st, 0);
    return st;
}

static void do_abort(int mode) {
    if (mode) resid_secret_mode_set(1);
    resid_abort("secret abort probe");
}

static void do_segv(int mode) {
    struct rlimit rl;
    if (getrlimit(RLIMIT_CORE, &rl) == 0) { rl.rlim_cur = rl.rlim_max; setrlimit(RLIMIT_CORE, &rl); }
    if (mode) resid_secret_mode_set(1);
    raise(SIGSEGV);
}

int main(void) {
    int fails = 0;
    char err[256];
    /* Controls: without the mode the process is dumpable and an abort is a
     * real SIGABRT. */
    if (prctl(PR_GET_DUMPABLE) != 1) { printf("control: not dumpable before secret mode\n"); fails++; }
    int st = child(do_abort, 0, err, sizeof err);
    if (!(WIFSIGNALED(st) && WTERMSIG(st) == SIGABRT)) { printf("control: abort was not SIGABRT (status %#x)\n", st); fails++; }
    if (!strstr(err, "resid: abort: secret abort probe")) { printf("control: abort message lost: %s\n", err); fails++; }

    /* In secret mode an abort is exit(134), with the message. */
    st = child(do_abort, 1, err, sizeof err);
    if (!(WIFEXITED(st) && WEXITSTATUS(st) == 134)) { printf("secret abort: not exit 134 (status %#x)\n", st); fails++; }
    if (!strstr(err, "resid: abort: secret abort probe")) { printf("secret abort: message lost: %s\n", err); fails++; }

    /* A fatal signal in secret mode dumps no core. */
    st = child(do_segv, 1, err, sizeof err);
    if (!(WIFSIGNALED(st) && WTERMSIG(st) == SIGSEGV)) { printf("secret segv: not SIGSEGV (status %#x)\n", st); fails++; }
    else if (WCOREDUMP(st)) { printf("secret segv: core dumped\n"); fails++; }

    resid_secret_mode_set(1);
    if (prctl(PR_GET_DUMPABLE) != 0) { printf("secret mode: still dumpable\n"); fails++; }
    struct rlimit rl;
    if (getrlimit(RLIMIT_CORE, &rl) != 0 || rl.rlim_cur != 0 || rl.rlim_max != 0) {
        printf("secret mode: RLIMIT_CORE is not {0, 0}\n"); fails++;
    }
    int dd = stack_dd();
    if (dd == 0) { printf("secret mode: initial stack not marked do-not-dump\n"); fails++; }
    if (fails == 0) printf("secret_nodump ok\n");
    return fails != 0;
}
