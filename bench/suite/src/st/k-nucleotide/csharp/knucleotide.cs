// k-nucleotide, single-threaded reference algorithm (Benchmarks Game description):
// hash-table counting of every k-length substring using
// System.Collections.Generic.Dictionary.
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;

public static class KNucleotide
{
    sealed class Counter { public int n; }

    static Dictionary<string, Counter> Count(string seq, int k)
    {
        var m = new Dictionary<string, Counter>();
        for (int i = 0, end = seq.Length - k; i <= end; i++)
        {
            string key = seq.Substring(i, k);
            if (!m.TryGetValue(key, out var c)) m[key] = c = new Counter();
            c.n++;
        }
        return m;
    }

    static void Frequencies(StringBuilder o, string seq, int k)
    {
        var m = Count(seq, k);
        double total = seq.Length - k + 1;
        foreach (var e in m.OrderByDescending(e => e.Value.n).ThenBy(e => e.Key, StringComparer.Ordinal))
            o.Append(e.Key).Append(' ')
             .Append((e.Value.n * 100.0 / total).ToString("F3", CultureInfo.InvariantCulture)).Append('\n');
        o.Append('\n');
    }

    public static void Main(string[] args)
    {
        using var input = new StreamReader(Console.OpenStandardInput(), Encoding.Latin1, false, 1 << 16);
        string line;
        while ((line = input.ReadLine()) != null && !line.StartsWith(">THREE", StringComparison.Ordinal)) { }
        var sb = new StringBuilder();
        while ((line = input.ReadLine()) != null && !line.StartsWith(">", StringComparison.Ordinal)) sb.Append(line);
        string seq = sb.ToString().ToUpperInvariant();

        var o = new StringBuilder();
        Frequencies(o, seq, 1);
        Frequencies(o, seq, 2);
        foreach (var s in new[] { "GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT" })
        {
            Count(seq, s.Length).TryGetValue(s, out var c);
            o.Append(c == null ? 0 : c.n).Append('\t').Append(s).Append('\n');
        }
        Console.Write(o.ToString());
    }
}
