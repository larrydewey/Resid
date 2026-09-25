// regex-redux, single-threaded reference algorithm (Benchmarks Game description),
// using java.util.regex.
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class regexredux {
    public static void main(String[] args) throws IOException {
        String input = new String(System.in.readAllBytes(), StandardCharsets.ISO_8859_1);
        int initialLength = input.length();
        String seq = Pattern.compile(">.*\n|\n").matcher(input).replaceAll("");
        int codeLength = seq.length();

        String[] variants = {
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
        StringBuilder out = new StringBuilder();
        for (String v : variants) {
            Matcher m = Pattern.compile(v).matcher(seq);
            int c = 0;
            while (m.find()) c++;
            out.append(v).append(' ').append(c).append('\n');
        }

        String[][] subst = {
            {"tHa[Nt]", "<4>"},
            {"aND|caN|Ha[DS]|WaS", "<3>"},
            {"a[NSt]|BY", "<2>"},
            {"<[^>]*>", "|"},
            {"\\|[^|][^|]*\\|", "-"},
        };
        String s = seq;
        for (String[] p : subst) s = Pattern.compile(p[0]).matcher(s).replaceAll(p[1]);

        out.append('\n').append(initialLength).append('\n').append(codeLength).append('\n')
           .append(s.length()).append('\n');
        System.out.print(out);
    }
}
