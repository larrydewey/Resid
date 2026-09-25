// mandelbrot, single-threaded reference algorithm (Benchmarks Game description).
using System;
using System.IO;
using System.Text;

public static class Mandelbrot
{
    public static void Main(string[] args)
    {
        int n = int.Parse(args[0]);
        int rowBytes = (n + 7) / 8;
        byte[] row = new byte[rowBytes];
        using var stdout = Console.OpenStandardOutput();
        using var output = new BufferedStream(stdout, 1 << 16);
        byte[] header = Encoding.ASCII.GetBytes("P4\n" + n + " " + n + "\n");
        output.Write(header, 0, header.Length);
        for (int y = 0; y < n; y++)
        {
            double ci = 2.0 * y / n - 1.0;
            int bits = 0, bitNum = 0, idx = 0;
            for (int x = 0; x < n; x++)
            {
                double cr = 2.0 * x / n - 1.5;
                double zr = 0, zi = 0, tr = 0, ti = 0;
                for (int i = 0; i < 50 && tr + ti <= 4.0; i++)
                {
                    zi = 2.0 * zr * zi + ci;
                    zr = tr - ti + cr;
                    tr = zr * zr;
                    ti = zi * zi;
                }
                bits <<= 1;
                if (tr + ti <= 4.0) bits |= 1;
                bitNum++;
                if (bitNum == 8)
                {
                    row[idx++] = (byte)bits;
                    bits = 0; bitNum = 0;
                }
            }
            if (bitNum != 0)
            {
                bits <<= (8 - bitNum);
                row[idx++] = (byte)bits;
            }
            output.Write(row, 0, rowBytes);
        }
        output.Flush();
    }
}
