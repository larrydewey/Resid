// binary-trees: single-threaded, plain JavaScript (Benchmarks Game algorithm:
// allocate full trees of nodes, walk them to count nodes).
'use strict';
function Node(left, right) { this.left = left; this.right = right; }
function bottomUp(depth) {
  return depth > 0 ? new Node(bottomUp(depth - 1), bottomUp(depth - 1)) : new Node(null, null);
}
function check(t) { return t.left === null ? 1 : 1 + check(t.left) + check(t.right); }

const maxDepth = Math.max(6, +process.argv[2] || 10);
const out = [];
const stretchDepth = maxDepth + 1;
out.push('stretch tree of depth ' + stretchDepth + '\t check: ' + check(bottomUp(stretchDepth)));
const longLived = bottomUp(maxDepth);
for (let d = 4; d <= maxDepth; d += 2) {
  const iterations = 1 << (maxDepth - d + 4);
  let c = 0;
  for (let i = 0; i < iterations; i++) c += check(bottomUp(d));
  out.push(iterations + '\t trees of depth ' + d + '\t check: ' + c);
}
out.push('long lived tree of depth ' + maxDepth + '\t check: ' + check(longLived));
console.log(out.join('\n'));
