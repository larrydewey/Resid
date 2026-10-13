
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>
int main(int argc, char **argv) {
    if (argc < 3) { fprintf(stderr, "usage: memrun RESULT argv...\n"); return 2; }
    struct timespec a, b;
    clock_gettime(CLOCK_MONOTONIC, &a);
    pid_t pid = fork();
    if (pid < 0) { perror("fork"); return 2; }
    if (pid == 0) {
        execvp(argv[2], argv + 2);
        fprintf(stderr, "[memrun] exec %s failed: %s\n", argv[2], strerror(errno));
        _exit(127);
    }
    int st; struct rusage ru;
    while (wait4(pid, &st, 0, &ru) < 0) { if (errno != EINTR) { perror("wait4"); return 2; } }
    clock_gettime(CLOCK_MONOTONIC, &b);
    long long ns = (long long)(b.tv_sec - a.tv_sec) * 1000000000LL + (b.tv_nsec - a.tv_nsec);
    FILE *f = fopen(argv[1], "w");
    if (!f) { perror("fopen"); return 2; }
    fprintf(f, "%lld %d %ld %ld %ld %ld %ld\n", ns, st,
            (long)ru.ru_utime.tv_sec, (long)ru.ru_utime.tv_usec,
            (long)ru.ru_stime.tv_sec, (long)ru.ru_stime.tv_usec, ru.ru_maxrss);
    fclose(f);
    return 0;
}
