/* mandelbrot, single-threaded reference implementation.
 * Writes a binary PBM (P4) of the Mandelbrot set, as described by the
 * Computer Language Benchmarks Game (50 iterations, escape radius 2). */
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    int w = argc > 1 ? atoi(argv[1]) : 200;
    int h = w;
    const int iter = 50;
    const double limit2 = 4.0;
    int row_bytes = (w + 7) / 8;
    unsigned char *row = malloc(row_bytes);

    printf("P4\n%d %d\n", w, h);
    for (int y = 0; y < h; y++) {
        double ci = 2.0 * y / h - 1.0;
        int bit_num = 0, idx = 0;
        unsigned char byte_acc = 0;
        for (int x = 0; x < w; x++) {
            double cr = 2.0 * x / w - 1.5;
            double zr = 0.0, zi = 0.0, tr = 0.0, ti = 0.0;
            for (int i = 0; i < iter && tr + ti <= limit2; i++) {
                zi = 2.0 * zr * zi + ci;
                zr = tr - ti + cr;
                tr = zr * zr;
                ti = zi * zi;
            }
            byte_acc <<= 1;
            if (tr + ti <= limit2)
                byte_acc |= 0x01;
            bit_num++;
            if (bit_num == 8) {
                row[idx++] = byte_acc;
                byte_acc = 0;
                bit_num = 0;
            } else if (x == w - 1) {
                byte_acc <<= (8 - w % 8);
                row[idx++] = byte_acc;
                byte_acc = 0;
                bit_num = 0;
            }
        }
        fwrite(row, 1, row_bytes, stdout);
    }
    free(row);
    return 0;
}
