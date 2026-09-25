// k-nucleotide, single-threaded reference algorithm (Benchmarks Game description):
// hash-table counting of every k-length substring using java.util.HashMap.
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public final class knucleotide {
    static final class Counter { int n; }

    static Map<String, Counter> count(String seq, int k) {
        Map<String, Counter> m = new HashMap<>();
        for (int i = 0, end = seq.length() - k; i <= end; i++) {
            String key = seq.substring(i, i + k);
            Counter c = m.get(key);
            if (c == null) m.put(key, c = new Counter());
            c.n++;
        }
        return m;
    }

    static void frequencies(StringBuilder out, String seq, int k) {
        Map<String, Counter> m = count(seq, k);
        List<Map.Entry<String, Counter>> list = new ArrayList<>(m.entrySet());
        list.sort((a, b) -> {
            int c = Integer.compare(b.getValue().n, a.getValue().n);
            return c != 0 ? c : a.getKey().compareTo(b.getKey());
        });
        double total = seq.length() - k + 1;
        for (Map.Entry<String, Counter> e : list)
            out.append(String.format(Locale.ROOT, "%s %.3f\n", e.getKey(), e.getValue().n * 100.0 / total));
        out.append('\n');
    }

    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in, StandardCharsets.ISO_8859_1), 1 << 16);
        String line;
        while ((line = in.readLine()) != null && !line.startsWith(">THREE")) { }
        StringBuilder sb = new StringBuilder();
        while ((line = in.readLine()) != null && !line.startsWith(">")) sb.append(line);
        String seq = sb.toString().toUpperCase(Locale.ROOT);

        StringBuilder out = new StringBuilder();
        frequencies(out, seq, 1);
        frequencies(out, seq, 2);
        for (String s : new String[] {"GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"}) {
            Counter c = count(seq, s.length()).get(s);
            out.append(c == null ? 0 : c.n).append('\t').append(s).append('\n');
        }
        System.out.print(out);
    }
}
