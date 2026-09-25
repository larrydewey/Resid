/* Immutable-string semantics, as a language without mutation implements
 * them: every `acc + piece` allocates a new string and copies both parts;
 * the old one is freed (what a GC or refcount would do). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static char* cat(const char* a, const char* b) {
    size_t la = strlen(a), lb = strlen(b);
    char* p = malloc(la + lb + 1);
    memcpy(p, a, la); memcpy(p + la, b, lb + 1);
    return p;
}
int main(int argc, char** argv) {
    long n = atol(argv[1]);
    char* s = strdup("");
    char buf[32];
    for (long i = 0; i < n; i++) {
        snprintf(buf, sizeof buf, "%ld", i);
        char* t = cat(s, buf); free(s);
        s = cat(t, ","); free(t);
    }
    printf("%zu\n", strlen(s));
    return 0;
}
