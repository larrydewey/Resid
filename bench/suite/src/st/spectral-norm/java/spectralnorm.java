// spectral-norm, single-threaded reference algorithm (Benchmarks Game description).
public final class spectralnorm {
    static double a(int i, int j) { return 1.0 / ((i + j) * (i + j + 1) / 2 + i + 1); }

    static void mulAv(double[] v, double[] av, int n) {
        for (int i = 0; i < n; i++) {
            double s = 0;
            for (int j = 0; j < n; j++) s += a(i, j) * v[j];
            av[i] = s;
        }
    }

    static void mulAtv(double[] v, double[] atv, int n) {
        for (int i = 0; i < n; i++) {
            double s = 0;
            for (int j = 0; j < n; j++) s += a(j, i) * v[j];
            atv[i] = s;
        }
    }

    static void mulAtAv(double[] v, double[] out, double[] tmp, int n) {
        mulAv(v, tmp, n);
        mulAtv(tmp, out, n);
    }

    public static void main(String[] args) {
        int n = Integer.parseInt(args[0]);
        double[] u = new double[n], v = new double[n], tmp = new double[n];
        java.util.Arrays.fill(u, 1.0);
        for (int i = 0; i < 10; i++) {
            mulAtAv(u, v, tmp, n);
            mulAtAv(v, u, tmp, n);
        }
        double vBv = 0, vv = 0;
        for (int i = 0; i < n; i++) { vBv += u[i] * v[i]; vv += v[i] * v[i]; }
        System.out.printf("%.9f%n", Math.sqrt(vBv / vv));
    }
}
