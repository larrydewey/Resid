/* fees.c -- an untrusted native fee schedule (spec §47).
 *
 * Exactly one scalar crosses each way: the caller sends a fee class (an
 * Int) and the module answers with basis points (an Int). The module is
 * built as freestanding LLVM IR text (fees.ll) and every call runs in a
 * fresh, seccomp-confined copy of the program, so this code sees only its
 * argument, keeps nothing between calls, and holds no authority.
 */
#include <stdint.h>

int64_t esc_bps(int64_t klass) {
    if (klass <= 0) { return 25; }
    if (klass == 1) { return 50; }
    return 100;
}
