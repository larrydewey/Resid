/* String walkers never step past the terminating NUL on truncated or
 * invalid UTF-8 (each test string sits at the very end of a page, so an
 * over-read faults). */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
/* In runtime/rt/ (Resid, linked as rt.ll). */
int64_t str_len(const char* s);
int64_t str_char_at(const char* s, int64_t i);
char* str_slice(const char* s, int64_t start, int64_t end);
char* str_reverse(const char* s);
char* str_to_lower(const char* s);
char* str_to_upper(const char* s);
#include <sys/mman.h>

static const char* at_page_end(const char* s) {
    size_t n = strlen(s) + 1;
    long pg = sysconf(_SC_PAGESIZE);
    char* m = mmap(NULL, (size_t)pg * 2, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    mprotect(m + pg, (size_t)pg, PROT_NONE);
    char* p = m + pg - n;
    memcpy(p, s, n);
    return p;
}

int main(void) {
    const char* cases[] = {"\xF0", "a\xE2\x82", "\xC3", "ab\xF0\x9F\x98", "\x80\x80", "ok \xE2\x82\xAC"};
    int64_t want[] = {1, 2, 1, 3, 2, 4};
    int bad = 0;
    for (int i = 0; i < 6; i++) {
        const char* s = at_page_end(cases[i]);
        int64_t n = str_len(s);
        if (n != want[i]) { bad++; printf("len %d: %lld\n", i, (long long)n); }
        for (int64_t k = 0; k < n; k++) (void)str_char_at(s, k);
        free(str_reverse(s));
        free(str_to_lower(s));
        free(str_to_upper(s));
        (void)str_slice(s, 0, n);
    }
    printf("utf8_bounds: %s\n", bad ? "FAIL" : "ok");
    return bad != 0;
}
