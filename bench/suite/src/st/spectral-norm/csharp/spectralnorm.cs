// spectral-norm, single-threaded reference algorithm (Benchmarks Game description).
using System;
using System.Globalization;

public static class SpectralNorm
{
    static double A(int i, int j) => 1.0 / ((i + j) * (i + j + 1) / 2 + i + 1);

    static void MulAv(double[] v, double[] av, int n)
    {
        for (int i = 0; i < n; i++)
        {
            double s = 0;
            for (int j = 0; j < n; j++) s += A(i, j) * v[j];
            av[i] = s;
        }
    }

    static void MulAtv(double[] v, double[] atv, int n)
    {
        for (int i = 0; i < n; i++)
        {
            double s = 0;
            for (int j = 0; j < n; j++) s += A(j, i) * v[j];
            atv[i] = s;
        }
    }

    static void MulAtAv(double[] v, double[] outv, double[] tmp, int n)
    {
        MulAv(v, tmp, n);
        MulAtv(tmp, outv, n);
    }

    public static void Main(string[] args)
    {
        int n = int.Parse(args[0]);
        double[] u = new double[n], v = new double[n], tmp = new double[n];
        Array.Fill(u, 1.0);
        for (int i = 0; i < 10; i++)
        {
            MulAtAv(u, v, tmp, n);
            MulAtAv(v, u, tmp, n);
        }
        double vBv = 0, vv = 0;
        for (int i = 0; i < n; i++) { vBv += u[i] * v[i]; vv += v[i] * v[i]; }
        Console.WriteLine(Math.Sqrt(vBv / vv).ToString("F9", CultureInfo.InvariantCulture));
    }
}
