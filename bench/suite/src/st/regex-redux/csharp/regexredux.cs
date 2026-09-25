// regex-redux, single-threaded reference algorithm (Benchmarks Game description),
// using System.Text.RegularExpressions (RegexOptions.Compiled, as the Benchmarks
// Game C# programs do).
using System;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

public static class RegexRedux
{
    const RegexOptions Opts = RegexOptions.Compiled;

    public static void Main(string[] args)
    {
        string input;
        using (var r = new StreamReader(Console.OpenStandardInput(), Encoding.Latin1))
            input = r.ReadToEnd();
        int initialLength = input.Length;
        string seq = new Regex(">.*\n|\n", Opts).Replace(input, "");
        int codeLength = seq.Length;

        string[] variants = {
            "agggtaaa|tttaccct",
            "[cgt]gggtaaa|tttaccc[acg]",
            "a[act]ggtaaa|tttacc[agt]t",
            "ag[act]gtaaa|tttac[agt]ct",
            "agg[act]taaa|ttta[agt]cct",
            "aggg[acg]aaa|ttt[cgt]ccct",
            "agggt[cgt]aa|tt[acg]accct",
            "agggta[cgt]a|t[acg]taccct",
            "agggtaa[cgt]|[acg]ttaccct",
        };
        var o = new StringBuilder();
        foreach (var v in variants)
        {
            int c = 0;
            for (var m = new Regex(v, Opts).Match(seq); m.Success; m = m.NextMatch()) c++;
            o.Append(v).Append(' ').Append(c).Append('\n');
        }

        string[,] subst = {
            { "tHa[Nt]", "<4>" },
            { "aND|caN|Ha[DS]|WaS", "<3>" },
            { "a[NSt]|BY", "<2>" },
            { "<[^>]*>", "|" },
            { "\\|[^|][^|]*\\|", "-" },
        };
        string s = seq;
        for (int i = 0; i < subst.GetLength(0); i++) s = new Regex(subst[i, 0], Opts).Replace(s, subst[i, 1]);

        o.Append('\n').Append(initialLength).Append('\n').Append(codeLength).Append('\n')
         .Append(s.Length).Append('\n');
        Console.Write(o.ToString());
    }
}
