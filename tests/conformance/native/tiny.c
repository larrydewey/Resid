#include <stdint.h>
#include <stdbool.h>
int64_t tiny_add(int64_t a, int64_t b) { return a + b + 1; }
double tiny_half(double x) { return x / 2; }
bool tiny_neg(bool b) { return !b; }
int8_t tiny_i8(int8_t x) { return (int8_t)(x * 2); }
uint16_t tiny_u16(uint16_t x) { return x + 1; }
float tiny_f32(float x) { return x * 3; }
void tiny_upper(const char *s, int64_t cap, char *out, int64_t ocap) {
    for (int64_t i = 0; i < cap && i < ocap && s[i]; i++) out[i] = (s[i] >= 'a' && s[i] <= 'z') ? s[i] - 32 : s[i];
}
void tiny_rev(const uint8_t *b, int64_t n, uint8_t *out, int64_t on) { for (int64_t i = 0; i < n; i++) out[i] = b[n - 1 - i]; }
static int counter;
int64_t tiny_count(void) { return ++counter; }
/* A reply the thunk could never produce: written straight to the host's
 * socket, then exit. The parent must refuse it (a Bool of 2, a text that is
 * not UTF-8). */
#if defined(__aarch64__)
static long sys3(long n, long a, long b, long c) { register long x8 __asm__("x8") = n; register long x0 __asm__("x0") = a; register long x1 __asm__("x1") = b; register long x2 __asm__("x2") = c; __asm__ volatile("svc #0" : "+r"(x0) : "r"(x8), "r"(x1), "r"(x2) : "memory"); return x0; }
bool tiny_forged_bool(void) { int64_t two = 2; sys3(64, 3, (long)&two, 8); sys3(94, 0, 0, 0); return 0; }
#else
static long sys3(long n, long a, long b, long c) { long r; __asm__ volatile("syscall" : "=a"(r) : "a"(n), "D"(a), "S"(b), "d"(c) : "rcx", "r11", "memory"); return r; }
bool tiny_forged_bool(void) { int64_t two = 2; sys3(1, 3, (long)&two, 8); sys3(231, 0, 0, 0); return 0; }
#endif
void tiny_bad_text(char *out, int64_t cap) { out[0] = (char)0xff; out[1] = 'a'; }
int64_t tiny_crash(int64_t x) { volatile int64_t *p = 0; return *p + x; }
