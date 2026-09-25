// reverse-complement, single-threaded reference algorithm (Benchmarks Game description).
using System;
using System.IO;

public static class RevComp
{
    static readonly byte[] Map = BuildMap();

    static byte[] BuildMap()
    {
        var m = new byte[256];
        for (int i = 0; i < 256; i++) m[i] = (byte)i;
        const string from = "ACGTUMRWSYKVHDBN", to = "TGCAAKYWSRMBDHVN";
        for (int i = 0; i < from.Length; i++)
        {
            m[from[i]] = (byte)to[i];
            m[char.ToLowerInvariant(from[i])] = (byte)to[i];
        }
        return m;
    }

    static void Flush(Stream o, byte[] seq, int len, byte[] line)
    {
        int col = 0, p = 0;
        for (int i = len - 1; i >= 0; i--)
        {
            line[p++] = Map[seq[i]];
            if (++col == 60) { line[p++] = (byte)'\n'; col = 0; }
        }
        if (col != 0) line[p++] = (byte)'\n';
        o.Write(line, 0, p);
    }

    public static void Main(string[] args)
    {
        byte[] data;
        using (var stdin = Console.OpenStandardInput())
        using (var ms = new MemoryStream(1 << 20))
        {
            stdin.CopyTo(ms);
            data = ms.ToArray();
        }
        int n = data.Length;
        byte[] seq = new byte[n];
        byte[] line = new byte[n + n / 60 + 2];
        using var stdout = Console.OpenStandardOutput();
        using var o = new BufferedStream(stdout, 1 << 16);
        int i = 0, len = 0;
        bool inSeq = false;
        while (i < n)
        {
            if (data[i] == '>')
            {
                if (inSeq) Flush(o, seq, len, line);
                int s = i;
                while (i < n && data[i] != '\n') i++;
                o.Write(data, s, Math.Min(i + 1, n) - s);
                i++;
                len = 0;
                inSeq = true;
            }
            else
            {
                byte b = data[i++];
                if (b != '\n') seq[len++] = b;
            }
        }
        if (inSeq) Flush(o, seq, len, line);
        o.Flush();
    }
}
