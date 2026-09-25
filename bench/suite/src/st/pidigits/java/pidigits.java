// pidigits, single-threaded reference algorithm (Benchmarks Game description),
// using java.math.BigInteger.
import java.math.BigInteger;

public final class pidigits {
    static BigInteger acc = BigInteger.ZERO, den = BigInteger.ONE, num = BigInteger.ONE;
    static final BigInteger THREE = BigInteger.valueOf(3), FOUR = BigInteger.valueOf(4);

    static int extract(BigInteger nth) {
        return num.multiply(nth).add(acc).divide(den).intValue();
    }

    static void nextTerm(long k) {
        long k2 = k * 2 + 1;
        acc = acc.add(num.shiftLeft(1)).multiply(BigInteger.valueOf(k2));
        den = den.multiply(BigInteger.valueOf(k2));
        num = num.multiply(BigInteger.valueOf(k));
    }

    static void eliminate(int d) {
        acc = acc.subtract(den.multiply(BigInteger.valueOf(d))).multiply(BigInteger.TEN);
        num = num.multiply(BigInteger.TEN);
    }

    public static void main(String[] args) {
        int n = Integer.parseInt(args[0]);
        StringBuilder out = new StringBuilder();
        StringBuilder line = new StringBuilder();
        int i = 0;
        long k = 0;
        while (i < n) {
            k++;
            nextTerm(k);
            if (num.compareTo(acc) > 0) continue;
            int d = extract(THREE);
            if (d != extract(FOUR)) continue;
            line.append((char) ('0' + d));
            i++;
            if (i % 10 == 0) {
                out.append(line).append("\t:").append(i).append('\n');
                line.setLength(0);
            }
            eliminate(d);
        }
        if (line.length() > 0) {
            while (line.length() < 10) line.append(' ');
            out.append(line).append("\t:").append(i).append('\n');
        }
        System.out.print(out);
    }
}
