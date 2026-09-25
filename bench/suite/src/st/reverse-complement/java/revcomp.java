// reverse-complement, single-threaded reference algorithm (Benchmarks Game description).
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public final class revcomp {
    static final byte[] MAP = new byte[256];
    static {
        for (int i = 0; i < 256; i++) MAP[i] = (byte) i;
        String from = "ACGTUMRWSYKVHDBN", to = "TGCAAKYWSRMBDHVN";
        for (int i = 0; i < from.length(); i++) {
            MAP[from.charAt(i)] = (byte) to.charAt(i);
            MAP[Character.toLowerCase(from.charAt(i))] = (byte) to.charAt(i);
        }
    }

    static void flush(OutputStream out, byte[] seq, int len, byte[] line) throws IOException {
        int col = 0, o = 0;
        for (int i = len - 1; i >= 0; i--) {
            line[o++] = MAP[seq[i] & 0xff];
            if (++col == 60) { line[o++] = '\n'; col = 0; }
        }
        if (col != 0) line[o++] = '\n';
        out.write(line, 0, o);
    }

    public static void main(String[] args) throws IOException {
        InputStream in = System.in;
        ByteArrayOutputStream bo = new ByteArrayOutputStream(1 << 20);
        in.transferTo(bo);
        byte[] data = bo.toByteArray();
        int n = data.length;
        byte[] seq = new byte[n];
        byte[] line = new byte[n + n / 60 + 2];
        OutputStream out = new java.io.BufferedOutputStream(System.out, 1 << 16);
        int i = 0, len = 0;
        boolean inSeq = false;
        while (i < n) {
            if (data[i] == '>') {
                if (inSeq) flush(out, seq, len, line);
                int s = i;
                while (i < n && data[i] != '\n') i++;
                out.write(data, s, Math.min(i + 1, n) - s);
                i++;
                len = 0;
                inSeq = true;
            } else {
                byte b = data[i++];
                if (b != '\n') seq[len++] = b;
            }
        }
        if (inSeq) flush(out, seq, len, line);
        out.flush();
    }
}
