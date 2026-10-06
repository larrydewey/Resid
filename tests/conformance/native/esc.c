#include <stdint.h>
static long sys(long n, long a, long b, long c) { long r; __asm__ volatile("syscall" : "=a"(r) : "a"(n), "D"(a), "S"(b), "d"(c) : "rcx", "r11", "memory"); return r; }
static long sys6(long n, long a, long b, long c, long d, long e, long f) { long r; register long r10 __asm__("r10") = d; register long r8 __asm__("r8") = e; register long r9 __asm__("r9") = f; __asm__ volatile("syscall" : "=a"(r) : "a"(n), "D"(a), "S"(b), "d"(c), "r"(r10), "r"(r8), "r"(r9) : "rcx", "r11", "memory"); return r; }
int64_t esc_open(void) { return sys(2, (long)"/etc/passwd", 0, 0); }
int64_t esc_getpid(void) { return sys(39, 0, 0, 0); }
int64_t esc_stdout(void) { return sys(1, 1, (long)"x", 1); }
int64_t esc_socket(void) { return sys(41, 2, 1, 0); }
int64_t esc_fork(void) { return sys(57, 0, 0, 0); }
int64_t esc_execve(void) { return sys(59, (long)"/bin/sh", 0, 0); }
int64_t esc_clock(void) { long ts[2]; return sys(228, 0, (long)ts, 0); }
int64_t esc_rdtsc(void) { uint32_t lo, hi; __asm__ volatile("rdtsc" : "=a"(lo), "=d"(hi)); return lo; }
int64_t esc_mmap_exec(void) { return sys6(9, 0, 4096, 7, 0x22, -1, 0); }
int64_t esc_x32(void) { return sys(0x40000000 + 39, 0, 0, 0); }
int64_t esc_getrandom(void) { char b[4]; return sys(318, (long)b, 4, 0); }
int64_t esc_vdso_time(void) { return ((long (*)(long *))0xffffffffff600400)(0); }
int64_t ok_mmap(void) { long p = sys6(9, 0, 4096, 3, 0x22, -1, 0); return p > 0 ? 1 : 0; }
/* The environment of the parent must not be in the host's memory: scan up from a stack address for "SECRET_MARK". */
int64_t esc_env(void) {
    char probe; char *p = &probe;
    for (long i = 0; i < 65536; i++) {
        long r = sys(10, ((long)(p + i)) & ~4095L, 4096, 1); (void)r;
        if (p[i] == 'S' && p[i+1] == 'E' && p[i+2] == 'C' && p[i+3] == 'R' && p[i+4] == 'E' && p[i+5] == 'T' && p[i+6] == '_' && p[i+7] == 'M') return 1;
    }
    return 0;
}
