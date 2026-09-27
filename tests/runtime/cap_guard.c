/* Force-time capability guard (spec §21.3): a region grants only its
 * listed families, nested regions meet, a read-only grant refuses a write
 * ("family!"), and the empty grant "_" refuses everything. */
#include "../../runtime/resid_rt.c"

static int granted(const char* cap) { return resid_cap_granted(cap); }

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
    /* More entries than a frame holds are dropped (denied), not read past. */
    const char* many[70];
    for (int i = 0; i < 70; i++) many[i] = i == 69 ? "network" : "filesystem";
    resid_cap_enter(many, 70);
    if (granted("network")) bad++;
    resid_cap_leave();
    printf("cap_guard: %s\n", bad ? "FAIL" : "ok");
    return bad != 0;
}
