// resid_sandbox_confine (runtime/rt/sys.resid) leaves no way out of the
// file tree it allows: after it, code that took over the confined process
// cannot make a Unix socket (a session bus or a container daemon's socket
// would run commands on request; Landlock does not mediate connect), reach
// another process with tgkill or prlimit64, or push input into a terminal
// with TIOCSTI. What it is for still works: files beneath the allowed
// directory, Internet sockets, FIONBIO. Without Landlock the call changes
// nothing and the test passes trivially.
#define _GNU_SOURCE
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <errno.h>
#include <sys/socket.h>
#include <sys/syscall.h>
#include <sys/ioctl.h>
#include <sys/resource.h>
#include <sys/wait.h>
void* resid_list_new(int64_t n, void** items, const char* ty);
int64_t resid_sandbox_confine(void* rw, void* ro);

static int bad = 0;
static void want(const char* what, int ok) {
    printf("%s: %s\n", what, ok ? "ok" : "FAILED");
    if (!ok) bad = 1;
}

int main(void) {
    char dir[] = "/tmp/resid_confine_XXXXXX";
    if (!mkdtemp(dir)) return 2;
    // An unrelated process of the same user, blocked until we are gone.
    int pp[2];
    if (pipe(pp) != 0) return 2;
    pid_t victim = fork();
    if (victim == 0) { char c; close(pp[1]); (void)read(pp[0], &c, 1); _exit(0); }
    close(pp[0]);
    void* items[1] = { (void*)dir };
    void* rw = resid_list_new(1, items, "List(Str)");
    void* ro = resid_list_new(0, items, "List(Str)");
    int64_t c = resid_sandbox_confine(rw, ro);
    printf("confine=%ld\n", (long)c);
    if (c == 0) return 0;   // no Landlock: nothing to check
    want("confined", c == 1);
    char p[256];
    snprintf(p, sizeof p, "%s/ok.txt", dir);
    int fd = open(p, O_RDWR | O_CREAT, 0600);
    want("a file beneath the allowed directory", fd >= 0);
    want("a file outside it is refused", open("/etc/passwd", O_RDONLY) < 0);
    errno = 0;
    want("no Unix socket", socket(AF_UNIX, SOCK_STREAM, 0) < 0 && errno == EPERM);
    want("no Unix socket pair", syscall(SYS_socketpair, AF_UNIX, SOCK_STREAM, 0, (int[2]){0, 0}) != 0);
    int s = socket(AF_INET, SOCK_STREAM, 0);
    want("an Internet socket", s >= 0);
    int on = 1;
    want("FIONBIO", s >= 0 && ioctl(s, FIONBIO, &on) == 0);
    errno = 0;
    want("no signal to another process", syscall(SYS_tgkill, victim, victim, SIGKILL) != 0 && errno == EPERM);
    want("a signal to itself", syscall(SYS_tgkill, getpid(), getpid(), 0) == 0);
    struct rlimit nl = {0, 0}, cur;
    errno = 0;
    want("no prlimit64 on another process", syscall(SYS_prlimit64, getppid(), RLIMIT_NOFILE, &nl, 0) != 0 && errno == EPERM);
    want("prlimit64 on itself", syscall(SYS_prlimit64, 0, RLIMIT_NOFILE, 0, &cur) == 0);
    char ch = '#';
    errno = 0;
    want("no TIOCSTI", ioctl(0, TIOCSTI, &ch) != 0 && errno == EPERM);
    errno = 0;
    want("nothing executed", syscall(SYS_execve, "/bin/true", (char*[]){"/bin/true", 0}, (char*[]){0}) != 0);
    return bad;
}
