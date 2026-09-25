// reverse-complement: single-threaded, plain JavaScript (Benchmarks Game
// algorithm: read FASTA from stdin, write each sequence's reverse complement
// in 60-column lines). Ignores argv.
'use strict';
const fs = require('fs');

const comp = new Uint8Array(256);
for (let i = 0; i < 256; i++) comp[i] = i;
const from = 'ACGTUMRWSYKVHDBN', to = 'TGCAAKYWSRMBDHVN';
for (let i = 0; i < from.length; i++) {
  comp[from.charCodeAt(i)] = to.charCodeAt(i);
  comp[from.toLowerCase().charCodeAt(i)] = to.charCodeAt(i);
}

const input = fs.readFileSync(0);
const out = Buffer.allocUnsafe(input.length + (input.length / 60 | 0) + 64);
let o = 0;
const seq = Buffer.allocUnsafe(input.length);

function emit(len) {
  let col = 0;
  for (let i = len - 1; i >= 0; i--) {
    out[o++] = comp[seq[i]];
    if (++col === 60) { out[o++] = 10; col = 0; }
  }
  if (col !== 0) out[o++] = 10;
}

let p = 0, seqLen = 0, inSeq = false;
const n = input.length;
while (p < n) {
  let e = input.indexOf(10, p);
  if (e < 0) e = n;
  if (input[p] === 62) { // '>'
    if (inSeq) emit(seqLen);
    seqLen = 0; inSeq = true;
    input.copy(out, o, p, e); o += e - p; out[o++] = 10;
  } else {
    input.copy(seq, seqLen, p, e); seqLen += e - p;
  }
  p = e + 1;
}
if (inSeq) emit(seqLen);
fs.writeSync(1, out, 0, o);
