// spectral-norm: single-threaded, plain JavaScript (Benchmarks Game algorithm).
'use strict';
function A(i, j) { return 1 / (((i + j) * (i + j + 1) >>> 1) + i + 1); }
function Au(u, v, n) {
  for (let i = 0; i < n; i++) {
    let s = 0;
    for (let j = 0; j < n; j++) s += A(i, j) * u[j];
    v[i] = s;
  }
}
function Atu(u, v, n) {
  for (let i = 0; i < n; i++) {
    let s = 0;
    for (let j = 0; j < n; j++) s += A(j, i) * u[j];
    v[i] = s;
  }
}
function AtAu(u, v, w, n) { Au(u, w, n); Atu(w, v, n); }
const n = +process.argv[2] || 100;
const u = new Float64Array(n).fill(1), v = new Float64Array(n), w = new Float64Array(n);
for (let i = 0; i < 10; i++) { AtAu(u, v, w, n); AtAu(v, u, w, n); }
let vBv = 0, vv = 0;
for (let i = 0; i < n; i++) { vBv += u[i] * v[i]; vv += v[i] * v[i]; }
console.log(Math.sqrt(vBv / vv).toFixed(9));
