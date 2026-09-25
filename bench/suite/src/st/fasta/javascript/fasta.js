// fasta: single-threaded, plain JavaScript (Benchmarks Game algorithm:
// LCG IM=139968 IA=3877 IC=29573 seed 42, cumulative-probability lookup,
// 60-column lines).
'use strict';
const fs = require('fs');

const IM = 139968, IA = 3877, IC = 29573;
let last = 42;
function random() {
  last = (last * IA + IC) % IM;
  return last / IM;
}

const ALU =
  'GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG' +
  'GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA' +
  'CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT' +
  'ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA' +
  'GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG' +
  'AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC' +
  'AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA';

const IUB = [
  ['a', 0.27], ['c', 0.12], ['g', 0.12], ['t', 0.27],
  ['B', 0.02], ['D', 0.02], ['H', 0.02], ['K', 0.02],
  ['M', 0.02], ['N', 0.02], ['R', 0.02], ['S', 0.02],
  ['V', 0.02], ['W', 0.02], ['Y', 0.02],
];
const HOMO_SAPIENS = [
  ['a', 0.3029549426680], ['c', 0.1979883004921],
  ['g', 0.1975473066391], ['t', 0.3015094502008],
];

const WIDTH = 60;
const BUF_SIZE = 1 << 16;
const buf = Buffer.alloc(BUF_SIZE);
let pos = 0;
function flush() { if (pos > 0) { fs.writeSync(1, buf, 0, pos); pos = 0; } }
function putByte(b) { if (pos === BUF_SIZE) flush(); buf[pos++] = b; }
function putString(s) { for (let i = 0; i < s.length; i++) putByte(s.charCodeAt(i)); }

function repeatFasta(header, src, n) {
  putString(header);
  const len = src.length;
  let k = 0;
  for (let i = 0; i < n; i++) {
    putByte(src.charCodeAt(k));
    k++; if (k === len) k = 0;
    if ((i + 1) % WIDTH === 0) putByte(10);
  }
  if (n % WIDTH !== 0) putByte(10);
}

function randomFasta(header, table, n) {
  putString(header);
  const m = table.length;
  const chars = new Uint8Array(m), probs = new Float64Array(m);
  let acc = 0;
  for (let i = 0; i < m; i++) {
    acc += table[i][1];
    probs[i] = acc;
    chars[i] = table[i][0].charCodeAt(0);
  }
  probs[m - 1] = 1.0;
  for (let i = 0; i < n; i++) {
    const r = random();
    let j = 0;
    while (r >= probs[j]) j++;
    putByte(chars[j]);
    if ((i + 1) % WIDTH === 0) putByte(10);
  }
  if (n % WIDTH !== 0) putByte(10);
}

const n = +process.argv[2] || 1000;
repeatFasta('>ONE Homo sapiens alu\n', ALU, 2 * n);
randomFasta('>TWO IUB ambiguity codes\n', IUB, 3 * n);
randomFasta('>THREE Homo sapiens frequency\n', HOMO_SAPIENS, 5 * n);
flush();
