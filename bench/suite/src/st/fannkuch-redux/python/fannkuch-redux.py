# fannkuch-redux: single-threaded, pure CPython (Benchmarks Game algorithm:
# permutations in the order of the reference C program, alternating-sign
# checksum).
import sys


def fannkuch(n):
    perm1 = list(range(n))
    count = [0] * n
    max_flips = 0
    checksum = 0
    perm_count = 0
    r = n
    while True:
        while r != 1:
            count[r - 1] = r
            r -= 1
        perm = perm1[:]
        flips = 0
        k = perm[0]
        while k:
            perm[:k + 1] = perm[k::-1]
            flips += 1
            k = perm[0]
        if flips > max_flips:
            max_flips = flips
        checksum += -flips if perm_count & 1 else flips
        while True:
            if r == n:
                return checksum, max_flips
            p0 = perm1.pop(0)
            perm1.insert(r, p0)
            count[r] -= 1
            if count[r] > 0:
                break
            r += 1
        perm_count += 1


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 7
    checksum, max_flips = fannkuch(n)
    print("%d\nPfannkuchen(%d) = %d" % (checksum, n, max_flips))


main()
