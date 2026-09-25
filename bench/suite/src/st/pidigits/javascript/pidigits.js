// pidigits: single-threaded, plain JavaScript with BigInt (Benchmarks Game
// step-by-step unbounded spigot, as in the reference C/GMP program).
'use strict';
const n = +process.argv[2] || 30;
let acc = 0n, den = 1n, num = 1n;

function extractDigit(nth) { return (num * nth + acc) / den; }

let out = '', line = '', i = 0, k = 0;
while (i < n) {
  k++;
  const k2 = BigInt(k * 2 + 1);
  acc = (acc + num * 2n) * k2;
  den *= k2;
  num *= BigInt(k);
  if (num > acc) continue;
  const d = extractDigit(3n);
  if (d !== extractDigit(4n)) continue;
  line += d.toString();
  i++;
  if (i % 10 === 0) { out += line + '\t:' + i + '\n'; line = ''; }
  acc = (acc - den * d) * 10n;
  num *= 10n;
}
if (line.length > 0) out += line.padEnd(10, ' ') + '\t:' + i + '\n';
process.stdout.write(out);
