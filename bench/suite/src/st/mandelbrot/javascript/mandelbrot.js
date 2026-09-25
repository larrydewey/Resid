// mandelbrot: single-threaded, plain JavaScript (Benchmarks Game algorithm:
// 50 iterations, escape when |z|^2 > 4, binary PBM on stdout).
'use strict';
const n = +process.argv[2] || 200;
const bytesPerRow = (n + 7) >> 3;
const header = Buffer.from('P4\n' + n + ' ' + n + '\n', 'ascii');
const out = Buffer.alloc(header.length + bytesPerRow * n);
header.copy(out, 0);
let pos = header.length;
for (let y = 0; y < n; y++) {
  const ci = 2.0 * y / n - 1.0;
  let bits = 0, bitNum = 0;
  for (let x = 0; x < n; x++) {
    const cr = 2.0 * x / n - 1.5;
    let zr = 0, zi = 0, tr = 0, ti = 0, i = 0;
    for (; i < 50 && tr + ti <= 4.0; i++) {
      zi = 2.0 * zr * zi + ci;
      zr = tr - ti + cr;
      tr = zr * zr;
      ti = zi * zi;
    }
    bits = (bits << 1) | (tr + ti <= 4.0 ? 1 : 0);
    bitNum++;
    if (bitNum === 8) {
      out[pos++] = bits;
      bits = 0; bitNum = 0;
    }
  }
  if (bitNum !== 0) {
    out[pos++] = bits << (8 - bitNum);
    bits = 0; bitNum = 0;
  }
}
process.stdout.write(out);
