/* Device entries (spec §49.4, runtime/rt/device.resid): the read entry
 * resid_device_call, which the force-time guard checks only as `device`,
 * refuses a request whose write byte is not 0 (and one too short to say)
 * with Denied (error code 2); the write entry resid_device_call_w, checked
 * as `device!`, takes both. A request that gets past the write byte but
 * does not parse (these stop after the name) is refused (10) before any
 * device host starts; tests/runtime/device_host.c drives the host. */
#include <stdint.h>
#include <stdio.h>

void* resid_box_i64(int64_t v);
int64_t resid_unbox_i64(void* p);
void* resid_list_new(int64_t n, void** items, const char* ty);
int64_t resid_list_len(void* l);
void* resid_list_get(void* l, int64_t i);
void* resid_device_call(void* req);
void* resid_device_call_w(void* req);

/* "RDV", version 1, kind 3 (read_attr), the write byte, then a name. */
static void* request(int64_t write, int64_t n) {
    int64_t bytes[] = {82, 68, 86, 1, 3, write, 1, 0, 120};
    void* items[9];
    for (int64_t i = 0; i < n; i++) items[i] = resid_box_i64(bytes[i]);
    return resid_list_new(n, items, "List(Int(64))");
}

/* The reply's error code, or -1 when it is not an error reply. */
static int64_t code(void* reply) {
    if (resid_list_len(reply) != 10 || resid_unbox_i64(resid_list_get(reply, 0)) != 1) return -1;
    return resid_unbox_i64(resid_list_get(reply, 1));
}

int main(void) {
    int bad = 0;
    if (code(resid_device_call(request(0, 9))) != 10) { puts("read entry: a truncated read is not refused"); bad++; }
    if (code(resid_device_call(request(1, 9))) != 2) { puts("read entry: a write is not Denied"); bad++; }
    if (code(resid_device_call(request(7, 9))) != 2) { puts("read entry: write byte 7 is not Denied"); bad++; }
    if (code(resid_device_call(request(0, 5))) != 2) { puts("read entry: a short request is not Denied"); bad++; }
    if (code(resid_device_call_w(request(0, 9))) != 10) { puts("write entry: a truncated read is not refused"); bad++; }
    if (code(resid_device_call_w(request(1, 9))) != 10) { puts("write entry: a truncated write is not refused"); bad++; }
    return bad != 0;
}
