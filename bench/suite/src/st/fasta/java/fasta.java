// fasta, single-threaded reference algorithm (Benchmarks Game description).
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;

public final class fasta {
    static final int LINE = 60;
    static final int IM = 139968, IA = 3877, IC = 29573;
    static int last = 42;

    static final String ALU =
        "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" +
        "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" +
        "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" +
        "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" +
        "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" +
        "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" +
        "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

    static final byte[] IUB_C = "acgtBDHKMNRSVWY".getBytes();
    static final double[] IUB_P = {0.27, 0.12, 0.12, 0.27,
        0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02};
    static final byte[] HS_C = "acgt".getBytes();
    static final double[] HS_P = {0.3029549426680, 0.1979883004921, 0.1975473066391, 0.3015094502008};

    static double random(double max) {
        last = (last * IA + IC) % IM;
        return max * last / IM;
    }

    static void repeat(OutputStream out, String header, String src, int n) throws IOException {
        out.write(header.getBytes());
        byte[] s = src.getBytes();
        int k = 0;
        byte[] line = new byte[LINE + 1];
        while (n > 0) {
            int len = Math.min(n, LINE);
            for (int i = 0; i < len; i++) {
                line[i] = s[k];
                if (++k == s.length) k = 0;
            }
            line[len] = '\n';
            out.write(line, 0, len + 1);
            n -= len;
        }
    }

    static void random(OutputStream out, String header, byte[] chars, double[] probs, int n) throws IOException {
        out.write(header.getBytes());
        double[] cum = new double[probs.length];
        double acc = 0;
        for (int i = 0; i < probs.length; i++) { acc += probs[i]; cum[i] = acc; }
        byte[] line = new byte[LINE + 1];
        while (n > 0) {
            int len = Math.min(n, LINE);
            for (int i = 0; i < len; i++) {
                double r = random(1.0);
                int j = 0;
                while (j < cum.length - 1 && r >= cum[j]) j++;
                line[i] = chars[j];
            }
            line[len] = '\n';
            out.write(line, 0, len + 1);
            n -= len;
        }
    }

    public static void main(String[] args) throws IOException {
        int n = Integer.parseInt(args[0]);
        OutputStream out = new BufferedOutputStream(System.out, 1 << 16);
        repeat(out, ">ONE Homo sapiens alu\n", ALU, n * 2);
        random(out, ">TWO IUB ambiguity codes\n", IUB_C, IUB_P, n * 3);
        random(out, ">THREE Homo sapiens frequency\n", HS_C, HS_P, n * 5);
        out.flush();
    }
}
