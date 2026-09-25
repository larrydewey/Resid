// fannkuch-redux, single-threaded reference algorithm (Benchmarks Game description).
public final class fannkuchredux {
    public static void main(String[] args) {
        int n = Integer.parseInt(args[0]);
        int[] perm = new int[n], perm1 = new int[n], count = new int[n];
        int maxFlips = 0, checksum = 0, permCount = 0, r = n;
        for (int i = 0; i < n; i++) perm1[i] = i;
        outer:
        while (true) {
            while (r != 1) { count[r - 1] = r; r--; }
            System.arraycopy(perm1, 0, perm, 0, n);
            int flips = 0, k;
            while ((k = perm[0]) != 0) {
                for (int i = 0, j = k; i < j; i++, j--) { int t = perm[i]; perm[i] = perm[j]; perm[j] = t; }
                flips++;
            }
            if (flips > maxFlips) maxFlips = flips;
            checksum += (permCount & 1) == 0 ? flips : -flips;
            while (true) {
                if (r == n) break outer;
                int p0 = perm1[0];
                for (int i = 0; i < r; i++) perm1[i] = perm1[i + 1];
                perm1[r] = p0;
                if (--count[r] > 0) break;
                r++;
            }
            permCount++;
        }
        System.out.println(checksum + "\nPfannkuchen(" + n + ") = " + maxFlips);
    }
}
