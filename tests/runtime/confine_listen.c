// resid_sandbox_confine forbids binding any TCP port (Landlock ABI 4,
// BIND_TCP handled with no port allowed), so a confined program cannot
// open a listener; resid_sandbox_confine_listening confines the same way
// but leaves TCP bind possible, for a server that listens on ports it
// picks later (pylond's -R forwards): there a loopback resid_tcp_listen
// succeeds and accepts a connection. Each confinement runs in a child of
// its own (the call forks and the original process exits with the
// confined copy's status). Before Landlock ABI 4 the kernel cannot forbid
// a bind and the test passes trivially.
#define _GNU_SOURCE
#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/wait.h>
void* resid_list_new(int64_t n, void** items, const char* ty);
int64_t resid_sandbox_confine(void* rw, void* ro);
int64_t resid_sandbox_confine_listening(void* rw, void* ro);
int64_t resid_tcp_listen(int64_t port);
int64_t resid_tcp_bound_port(int64_t fd);
int64_t resid_tcp_connect(const char* host, int64_t port);
int64_t resid_tcp_accept(int64_t fd);

// Confines (listening or not), then listens on a loopback port and
// accepts one connection. Exit status: 10 + (listener made) * 2 + (a
// connection accepted); 3 when confinement did not take.
static int run(int listening) {
    pid_t pid = fork();
    if (pid < 0) return -1;
    if (pid == 0) {
        void* none = resid_list_new(0, (void*[1]){0}, "List(Str)");
        int64_t c = listening ? resid_sandbox_confine_listening(none, none) : resid_sandbox_confine(none, none);
        if (c != 1) _exit(3);
        int64_t l = resid_tcp_listen(0);
        if (l < 0) _exit(10);
        int64_t port = resid_tcp_bound_port(l);
        int64_t fd = resid_tcp_connect("127.0.0.1", port);
        int64_t a = fd >= 0 ? resid_tcp_accept(l) : -1;
        _exit(12 + (a >= 0));
    }
    int st = 0;
    if (waitpid(pid, &st, 0) != pid || !WIFEXITED(st)) return -1;
    return WEXITSTATUS(st);
}

int main(void) {
    long abi = syscall(444, NULL, 0, 1);   // landlock_create_ruleset(NULL, 0, VERSION)
    printf("landlock abi=%ld\n", abi);
    if (abi < 4) return 0;
    int plain = run(0);
    int listening = run(1);
    printf("confine: %d (want 10: no listener)\n", plain);
    printf("confine_listening: %d (want 13: listener, connection accepted)\n", listening);
    return plain == 10 && listening == 13 ? 0 : 1;
}
