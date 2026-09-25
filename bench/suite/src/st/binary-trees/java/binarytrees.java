// binary-trees, single-threaded reference algorithm (Benchmarks Game description).
public final class binarytrees {
    static final class Node {
        final Node left, right;
        Node(Node l, Node r) { left = l; right = r; }
        int check() { return left == null ? 1 : 1 + left.check() + right.check(); }
    }

    static Node bottomUp(int depth) {
        return depth > 0 ? new Node(bottomUp(depth - 1), bottomUp(depth - 1)) : new Node(null, null);
    }

    public static void main(String[] args) {
        int n = Integer.parseInt(args[0]);
        int minDepth = 4;
        int maxDepth = Math.max(minDepth + 2, n);
        int stretch = maxDepth + 1;
        StringBuilder sb = new StringBuilder();
        sb.append("stretch tree of depth ").append(stretch).append("\t check: ")
          .append(bottomUp(stretch).check()).append('\n');
        Node longLived = bottomUp(maxDepth);
        for (int d = minDepth; d <= maxDepth; d += 2) {
            int iters = 1 << (maxDepth - d + minDepth);
            int check = 0;
            for (int i = 0; i < iters; i++) check += bottomUp(d).check();
            sb.append(iters).append("\t trees of depth ").append(d).append("\t check: ").append(check).append('\n');
        }
        sb.append("long lived tree of depth ").append(maxDepth).append("\t check: ")
          .append(longLived.check()).append('\n');
        System.out.print(sb);
    }
}
