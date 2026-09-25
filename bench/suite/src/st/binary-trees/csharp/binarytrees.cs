// binary-trees, single-threaded reference algorithm (Benchmarks Game description).
using System;
using System.Text;

public static class BinaryTrees
{
    sealed class Node
    {
        public readonly Node left, right;
        public Node(Node l, Node r) { left = l; right = r; }
        public int Check() => left == null ? 1 : 1 + left.Check() + right.Check();
    }

    static Node BottomUp(int depth) =>
        depth > 0 ? new Node(BottomUp(depth - 1), BottomUp(depth - 1)) : new Node(null, null);

    public static void Main(string[] args)
    {
        int n = int.Parse(args[0]);
        int minDepth = 4;
        int maxDepth = Math.Max(minDepth + 2, n);
        int stretch = maxDepth + 1;
        var sb = new StringBuilder();
        sb.Append("stretch tree of depth ").Append(stretch).Append("\t check: ")
          .Append(BottomUp(stretch).Check()).Append('\n');
        var longLived = BottomUp(maxDepth);
        for (int d = minDepth; d <= maxDepth; d += 2)
        {
            int iters = 1 << (maxDepth - d + minDepth);
            int check = 0;
            for (int i = 0; i < iters; i++) check += BottomUp(d).Check();
            sb.Append(iters).Append("\t trees of depth ").Append(d).Append("\t check: ").Append(check).Append('\n');
        }
        sb.Append("long lived tree of depth ").Append(maxDepth).Append("\t check: ")
          .Append(longLived.Check()).Append('\n');
        Console.Write(sb.ToString());
    }
}
