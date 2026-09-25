// fasta, single-threaded reference algorithm (Benchmarks Game description).
using System;
using System.IO;
using System.Text;

public static class Fasta
{
    const int Line = 60;
    const int IM = 139968, IA = 3877, IC = 29573;
    static int last = 42;

    const string Alu =
        "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" +
        "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" +
        "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" +
        "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" +
        "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" +
        "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" +
        "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

    static readonly byte[] IubC = Encoding.ASCII.GetBytes("acgtBDHKMNRSVWY");
    static readonly double[] IubP = { 0.27, 0.12, 0.12, 0.27,
        0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02 };
    static readonly byte[] HsC = Encoding.ASCII.GetBytes("acgt");
    static readonly double[] HsP = { 0.3029549426680, 0.1979883004921, 0.1975473066391, 0.3015094502008 };

    static double Random(double max)
    {
        last = (last * IA + IC) % IM;
        return max * last / IM;
    }

    static void WriteAscii(Stream o, string s)
    {
        var b = Encoding.ASCII.GetBytes(s);
        o.Write(b, 0, b.Length);
    }

    static void Repeat(Stream o, string header, string src, int n)
    {
        WriteAscii(o, header);
        byte[] s = Encoding.ASCII.GetBytes(src);
        int k = 0;
        byte[] line = new byte[Line + 1];
        while (n > 0)
        {
            int len = Math.Min(n, Line);
            for (int i = 0; i < len; i++)
            {
                line[i] = s[k];
                if (++k == s.Length) k = 0;
            }
            line[len] = (byte)'\n';
            o.Write(line, 0, len + 1);
            n -= len;
        }
    }

    static void RandomSeq(Stream o, string header, byte[] chars, double[] probs, int n)
    {
        WriteAscii(o, header);
        double[] cum = new double[probs.Length];
        double acc = 0;
        for (int i = 0; i < probs.Length; i++) { acc += probs[i]; cum[i] = acc; }
        byte[] line = new byte[Line + 1];
        while (n > 0)
        {
            int len = Math.Min(n, Line);
            for (int i = 0; i < len; i++)
            {
                double r = Random(1.0);
                int j = 0;
                while (j < cum.Length - 1 && r >= cum[j]) j++;
                line[i] = chars[j];
            }
            line[len] = (byte)'\n';
            o.Write(line, 0, len + 1);
            n -= len;
        }
    }

    public static void Main(string[] args)
    {
        int n = int.Parse(args[0]);
        using var stdout = Console.OpenStandardOutput();
        using var o = new BufferedStream(stdout, 1 << 16);
        Repeat(o, ">ONE Homo sapiens alu\n", Alu, n * 2);
        RandomSeq(o, ">TWO IUB ambiguity codes\n", IubC, IubP, n * 3);
        RandomSeq(o, ">THREE Homo sapiens frequency\n", HsC, HsP, n * 5);
        o.Flush();
    }
}
