// regex-redux: single-threaded, plain JavaScript RegExp (Benchmarks Game
// algorithm). Reads stdin, ignores argv.
'use strict';
const fs = require('fs');

let seq = fs.readFileSync(0, 'latin1');
const initialLength = seq.length;
seq = seq.replace(/>.*\n|\n/g, '');
const cleanLength = seq.length;

const variants = [
  'agggtaaa|tttaccct',
  '[cgt]gggtaaa|tttaccc[acg]',
  'a[act]ggtaaa|tttacc[agt]t',
  'ag[act]gtaaa|tttac[agt]ct',
  'agg[act]taaa|ttta[agt]cct',
  'aggg[acg]aaa|ttt[cgt]ccct',
  'agggt[cgt]aa|tt[acg]accct',
  'agggta[cgt]a|t[acg]taccct',
  'agggtaa[cgt]|[acg]ttaccct',
];
let out = '';
for (const v of variants) {
  const m = seq.match(new RegExp(v, 'g'));
  out += v + ' ' + (m ? m.length : 0) + '\n';
}

const subs = [
  [/tHa[Nt]/g, '<4>'],
  [/aND|caN|Ha[DS]|WaS/g, '<3>'],
  [/a[NSt]|BY/g, '<2>'],
  [/<[^>]*>/g, '|'],
  [/\|[^|][^|]*\|/g, '-'],
];
for (const [re, rep] of subs) seq = seq.replace(re, rep);

out += '\n' + initialLength + '\n' + cleanLength + '\n' + seq.length + '\n';
process.stdout.write(out);
