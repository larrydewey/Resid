// fannkuch-redux: single-threaded, plain JavaScript (Benchmarks Game algorithm:
// permutations in the order of the reference C program, checksum alternating sign).
'use strict';
function fannkuch(n) {
  const perm = new Int32Array(n), perm1 = new Int32Array(n), count = new Int32Array(n);
  let maxFlips = 0, checksum = 0, permCount = 0, r = n;
  for (let i = 0; i < n; i++) perm1[i] = i;
  for (;;) {
    while (r !== 1) { count[r - 1] = r; r--; }
    for (let i = 0; i < n; i++) perm[i] = perm1[i];
    let flips = 0, k;
    while ((k = perm[0]) !== 0) {
      for (let i = 0, j = k; i < j; i++, j--) {
        const t = perm[i]; perm[i] = perm[j]; perm[j] = t;
      }
      flips++;
    }
    if (flips > maxFlips) maxFlips = flips;
    checksum += (permCount % 2 === 0) ? flips : -flips;
    for (;;) {
      if (r === n) return [checksum, maxFlips];
      const p0 = perm1[0];
      for (let i = 0; i < r; i++) perm1[i] = perm1[i + 1];
      perm1[r] = p0;
      count[r]--;
      if (count[r] > 0) break;
      r++;
    }
    permCount++;
  }
}
const n = +process.argv[2] || 7;
const [checksum, maxFlips] = fannkuch(n);
console.log(checksum + '\nPfannkuchen(' + n + ') = ' + maxFlips);
