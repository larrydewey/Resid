// pidigits, single-threaded reference algorithm (Benchmarks Game description),
// using System.Numerics.BigInteger.
using System;
using System.Numerics;
using System.Text;

public static class PiDigits
{
    static BigInteger acc = BigInteger.Zero, den = BigInteger.One, num = BigInteger.One;

    static int Extract(int nth) => (int)((num * nth + acc) / den);

    static void NextTerm(long k)
    {
        long k2 = k * 2 + 1;
        acc = (acc + (num << 1)) * k2;
        den *= k2;
        num *= k;
    }

    static void Eliminate(int d)
    {
        acc = (acc - den * d) * 10;
        num *= 10;
    }

    public static void Main(string[] args)
    {
        int n = int.Parse(args[0]);
        var o = new StringBuilder();
        var line = new StringBuilder();
        int i = 0;
        long k = 0;
        while (i < n)
        {
            k++;
            NextTerm(k);
            if (num > acc) continue;
            int d = Extract(3);
            if (d != Extract(4)) continue;
            line.Append((char)('0' + d));
            i++;
            if (i % 10 == 0)
            {
                o.Append(line).Append("\t:").Append(i).Append('\n');
                line.Clear();
            }
            Eliminate(d);
        }
        if (line.Length > 0)
        {
            while (line.Length < 10) line.Append(' ');
            o.Append(line).Append("\t:").Append(i).Append('\n');
        }
        Console.Write(o.ToString());
    }
}
