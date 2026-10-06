/* The display shared mapping (runtime/rt/unix.resid): a handle is opaque to
 * the program, real shared memory underneath, and the bytes a program puts
 * through it are the bytes a second mapping of the same descriptor sees --
 * which is the whole point, since the descriptor is what goes to the
 * window server.
 *
 * The bytes go in through `resid_disp_shm_put`, so the list is built the
 * way the runtime builds one: 8-byte slots holding immediate-boxed bytes. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#define IMM_OFF (1ULL << 54)

int64_t resid_disp_shm_new(int64_t bytes);
int64_t resid_disp_shm_fd(int64_t h);
int64_t resid_disp_shm_put(int64_t h, int64_t off, void *list, int64_t len);
int64_t resid_disp_shm_free(int64_t h);
void *resid_list_new(int64_t n, void *items, const char *ty);

/* A List(Int) of byte values, as the runtime lays one out. */
static void *byte_list(const unsigned char *b, int64_t n) {
    uint64_t *slots = malloc((size_t)n * 8);
    for (int64_t i = 0; i < n; i++) slots[i] = b[i] + IMM_OFF;
    return resid_list_new(n, slots, "List");
}

int main(void) {
    int bad = 0;
    int64_t h = resid_disp_shm_new(4096);
    int64_t fd = resid_disp_shm_fd(h);
    if (h == 0 || fd < 0) { printf("shm_new failed\n"); return 1; }

    /* The program never sees the address, so the test maps the descriptor
     * itself: if the runtime mapped anything but shared memory, the write
     * below and the read here would not agree. */
    unsigned char *mine = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, (int)fd, 0);
    if (mine == MAP_FAILED) { printf("second mapping failed\n"); return 1; }

    unsigned char frame[300];
    for (int i = 0; i < 300; i++) frame[i] = (unsigned char)(i * 7 + 3);
    if (!resid_disp_shm_put(h, 0, byte_list(frame, 300), 300)) { printf("put failed\n"); bad++; }
    if (memcmp(mine, frame, 300) != 0) { printf("mapping mismatch\n"); bad++; }

    /* A second put at an offset, and past the end refused. */
    if (!resid_disp_shm_put(h, 4090, byte_list(frame, 6), 6)) { printf("tail put refused\n"); bad++; }
    if (resid_disp_shm_put(h, 4090, byte_list(frame, 7), 7)) { printf("past end accepted\n"); bad++; }
    if (resid_disp_shm_put(h, -1, byte_list(frame, 1), 1)) { printf("negative offset accepted\n"); bad++; }

    /* The descriptor is the server's handle on the same bytes. */
    if (lseek((int)fd, 200, SEEK_SET) != 200) { printf("seek failed\n"); bad++; }
    unsigned char back[8];
    if (read((int)fd, back, 8) != 8 || memcmp(back, frame + 200, 8) != 0) { printf("read back mismatch\n"); bad++; }

    if (!resid_disp_shm_free(h)) { printf("free failed\n"); bad++; }
    if (resid_disp_shm_free(h)) { printf("double free accepted\n"); bad++; }
    if (resid_disp_shm_fd(0) != -1) { printf("null handle gave a descriptor\n"); bad++; }
    if (resid_disp_shm_new(0) != 0 || resid_disp_shm_new(-1) != 0) { printf("empty mapping accepted\n"); bad++; }
    if (resid_disp_shm_new(268435457) != 0) { printf("oversized mapping accepted\n"); bad++; }

    munmap(mine, 4096);
    return bad == 0 ? 0 : 1;
}
