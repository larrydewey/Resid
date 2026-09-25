// mandelbrot, single-threaded C++ implementation.
// Writes a binary PBM (P4), 50 iterations, escape radius 2, as described by
// the Computer Language Benchmarks Game.
#include <cstdio>
#include <cstdlib>
#include <vector>

int main(int argc, char **argv) {
    const int w = argc > 1 ? std::atoi(argv[1]) : 200;
    const int h = w;
    const int iter = 50;
    const double limit2 = 4.0;
    const int row_bytes = (w + 7) / 8;
    std::vector<unsigned char> image(static_cast<std::size_t>(row_bytes) * h);

    for (int y = 0; y < h; ++y) {
        const double ci = 2.0 * y / h - 1.0;
        unsigned char *row = &image[static_cast<std::size_t>(y) * row_bytes];
        for (int x = 0; x < w; ++x) {
            const double cr = 2.0 * x / w - 1.5;
            double zr = 0.0, zi = 0.0, tr = 0.0, ti = 0.0;
            for (int i = 0; i < iter && tr + ti <= limit2; ++i) {
                zi = 2.0 * zr * zi + ci;
                zr = tr - ti + cr;
                tr = zr * zr;
                ti = zi * zi;
            }
            if (tr + ti <= limit2)
                row[x >> 3] |= static_cast<unsigned char>(0x80 >> (x & 7));
        }
    }
    std::printf("P4\n%d %d\n", w, h);
    std::fwrite(image.data(), 1, image.size(), stdout);
}
