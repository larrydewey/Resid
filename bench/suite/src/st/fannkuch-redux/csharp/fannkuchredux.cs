// fannkuch-redux, single-threaded reference algorithm (Benchmarks Game description).
using System;

public static class FannkuchRedux
{
    public static void Main(string[] args)
    {
        int n = int.Parse(args[0]);
        int[] perm = new int[n], perm1 = new int[n], count = new int[n];
        int maxFlips = 0, checksum = 0, permCount = 0, r = n;
        for (int i = 0; i < n; i++) perm1[i] = i;
        while (true)
        {
            while (r != 1) { count[r - 1] = r; r--; }
            Array.Copy(perm1, perm, n);
            int flips = 0, k;
            while ((k = perm[0]) != 0)
            {
                for (int i = 0, j = k; i < j; i++, j--) { int t = perm[i]; perm[i] = perm[j]; perm[j] = t; }
                flips++;
            }
            if (flips > maxFlips) maxFlips = flips;
            checksum += (permCount & 1) == 0 ? flips : -flips;
            while (true)
            {
                if (r == n)
                {
                    Console.Write(checksum + "\nPfannkuchen(" + n + ") = " + maxFlips + "\n");
                    return;
                }
                int p0 = perm1[0];
                for (int i = 0; i < r; i++) perm1[i] = perm1[i + 1];
                perm1[r] = p0;
                if (--count[r] > 0) break;
                r++;
            }
            permCount++;
        }
    }
}
