/* Force-time capability guard (spec §21.3): a region grants only its
 * listed families, nested regions meet, a read-only grant refuses a write
 * ("family!"), and the empty grant "_" refuses everything. */
#include <stdint.h>
#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
/* The guard lives in runtime/rt/caps.resid (linked as rt.ll). */
int8_t resid_cap_granted(const char* cap);
void resid_cap_enter(const char* const* caps, int64_t n);
void resid_cap_leave(void);

static int granted(const char* cap) { return resid_cap_granted(cap) != 0; }

int main(void) {
    int bad = 0;
    if (!granted("filesystem")) bad++; /* outside every region */
    const char* fs_ro[] = {"filesystem:ro"};
    resid_cap_enter(fs_ro, 1);
    if (!granted("filesystem")) bad++;
    if (granted("filesystem!")) bad++;
    if (granted("network")) bad++;
    const char* net[] = {"network"};
    resid_cap_enter(net, 1);
    if (granted("network") || granted("filesystem")) bad++; /* meet is empty */
    resid_cap_leave();
    resid_cap_leave();
    const char* none[] = {"_"};
    resid_cap_enter(none, 1);
    if (granted("filesystem") || granted("process") || granted("_x")) bad++;
    resid_cap_leave();
    const char* rw[] = {"filesystem", "process"};
    resid_cap_enter(rw, 2);
    if (!granted("filesystem!") || !granted("process!")) bad++;
    resid_cap_leave();
    /* clock: reading time is observation, sleeping consumes it, so a
     * read-only grant covers now_ns/now_sec/monotonic_ns but not the
     * "clock!" the sleep verb asks for (spec §20). */
    const char* clk_ro[] = {"clock:ro"};
    resid_cap_enter(clk_ro, 1);
    if (!granted("clock")) bad++;
    if (granted("clock!")) bad++;
    if (granted("filesystem")) bad++;
    resid_cap_leave();
    const char* clk[] = {"clock"};
    resid_cap_enter(clk, 1);
    if (!granted("clock") || !granted("clock!")) bad++;
    resid_cap_leave();
    /* clock meets to nothing with a frame that never grants it. */
    resid_cap_enter(clk, 1);
    resid_cap_enter(rw, 2);
    if (granted("clock")) bad++;
    resid_cap_leave();
    resid_cap_leave();
    /* A frame holds 64 entries; the 64th is honoured. */
    const char* many[65];
    for (int i = 0; i < 65; i++) many[i] = i == 63 ? "network" : "filesystem";
    resid_cap_enter(many, 64);
    if (!granted("network")) bad++;
    resid_cap_leave();
    /* Native module families are distinct by their whole name: native_a is
     * neither native_ab nor a bare native. */
    const char* na[] = {"native_a"};
    resid_cap_enter(na, 1);
    if (!granted("native_a!") || granted("native_ab!") || granted("native!") || granted("native_b!")) bad++;
    resid_cap_leave();
    /* A longer set aborts rather than dropping grants (in a child, since an
     * abort ends the process). */
    fflush(stdout);
    pid_t pid = fork();
    if (pid == 0) { resid_cap_enter(many, 65); _exit(0); }
    int st = 0;
    waitpid(pid, &st, 0);
    if (WIFEXITED(st) && WEXITSTATUS(st) == 0) bad++;
    printf("cap_guard: %s\n", bad ? "FAIL" : "ok");
    return bad != 0;
}
