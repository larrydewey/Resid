// k-nucleotide: single-threaded, plain JavaScript (Benchmarks Game algorithm:
// extract sequence THREE, count every k-nucleotide with a hash table keyed by
// the k-length substring). Reads stdin, ignores argv.
'use strict';
const fs = require('fs');

function readSequence() {
  const data = fs.readFileSync(0, 'latin1');
  const start = data.indexOf('>THREE');
  const bodyStart = data.indexOf('\n', start) + 1;
  let end = data.indexOf('>', bodyStart);
  if (end < 0) end = data.length;
  return data.slice(bodyStart, end).replace(/\n/g, '').toUpperCase();
}

function frequencies(seq, k) {
  const counts = new Map();
  const last = seq.length - k;
  for (let i = 0; i <= last; i++) {
    const key = seq.substring(i, i + k);
    counts.set(key, (counts.get(key) || 0) + 1);
  }
  return counts;
}

function sortedFrequencies(seq, k) {
  const counts = frequencies(seq, k);
  const total = seq.length - k + 1;
  const entries = Array.from(counts.entries());
  entries.sort((a, b) => (b[1] - a[1]) || (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));
  let out = '';
  for (const [key, c] of entries) out += key + ' ' + (c * 100 / total).toFixed(3) + '\n';
  return out + '\n';
}

function specificCount(seq, fragment) {
  const counts = frequencies(seq, fragment.length);
  return (counts.get(fragment) || 0) + '\t' + fragment + '\n';
}

const seq = readSequence();
let out = sortedFrequencies(seq, 1) + sortedFrequencies(seq, 2);
for (const f of ['GGT', 'GGTA', 'GGTATT', 'GGTATTTTAATT', 'GGTATTTTAATTTATAGT']) {
  out += specificCount(seq, f);
}
process.stdout.write(out);
