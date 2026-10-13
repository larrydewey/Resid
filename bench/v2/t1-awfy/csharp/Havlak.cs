// AWFY Havlak, after the Java reference: loop recognition on a synthetic
// control-flow graph. The block-number dictionary is a Dictionary keyed by
// block (reference identity), as the reference's IdentityDictionary.
using System;
using System.Collections.Generic;

namespace Awfy.Havlak {

public sealed class HavlakBench : Benchmark {
  public override bool InnerBenchmarkLoop(int inner) {
    (int loops, int nodes) = new LoopTesterApp().Main(inner, 50, 10, 10, 5);
    switch (inner) {
      case 15000: return loops == 46602 && nodes == 5213;
      case 1500: return loops == 6102 && nodes == 5213;
      case 150: return loops == 2052 && nodes == 5213;
      case 15: return loops == 1647 && nodes == 5213;
      case 1: return loops == 1605 && nodes == 5213;
    }
    Console.WriteLine("No verification result for " + inner + " found; result " + loops + ", " + nodes);
    return false;
  }
}

sealed class BasicBlock {
  public readonly List<BasicBlock> InEdges = new List<BasicBlock>(2);
  public readonly List<BasicBlock> OutEdges = new List<BasicBlock>(2);
  public readonly int Name;
  public BasicBlock(int name) { Name = name; }
}

sealed class ControlFlowGraph {
  public readonly List<BasicBlock> BasicBlockMap = new List<BasicBlock>();
  public BasicBlock StartNode;
  readonly List<(BasicBlock, BasicBlock)> edgeList = new List<(BasicBlock, BasicBlock)>();

  public BasicBlock CreateNode(int name) {
    while (BasicBlockMap.Count <= name) { BasicBlockMap.Add(null); }
    BasicBlock node = BasicBlockMap[name];
    if (node == null) {
      node = new BasicBlock(name);
      BasicBlockMap[name] = node;
    }
    if (BasicBlockMap.Count == 1) { StartNode = node; }
    return node;
  }

  public void AddEdge(int fromName, int toName) {
    BasicBlock from = CreateNode(fromName);
    BasicBlock to = CreateNode(toName);
    from.OutEdges.Add(to);
    to.InEdges.Add(from);
    edgeList.Add((from, to));
  }
}

sealed class SimpleLoop {
  readonly List<BasicBlock> basicBlocks = new List<BasicBlock>();
  public readonly List<SimpleLoop> Children = new List<SimpleLoop>();
  public SimpleLoop Parent;
  readonly BasicBlock header;
  readonly bool isReducible;
  public bool IsRoot;
  public int NestingLevel;
  public int Counter;
  public int DepthLevel;

  public SimpleLoop(BasicBlock bb, bool isReducible) {
    this.isReducible = isReducible;
    if (bb != null) { basicBlocks.Add(bb); }
    header = bb;
  }

  public void AddNode(BasicBlock bb) {
    if (!basicBlocks.Contains(bb)) { basicBlocks.Add(bb); }
  }

  public void SetParent(SimpleLoop p) {
    Parent = p;
    if (!p.Children.Contains(this)) { p.Children.Add(this); }
  }

  public void SetNestingLevel(int level) {
    NestingLevel = level;
    if (level == 0) { IsRoot = true; }
  }
}

sealed class LoopStructureGraph {
  readonly SimpleLoop root;
  public readonly List<SimpleLoop> Loops = new List<SimpleLoop>();
  int loopCounter;

  public LoopStructureGraph() {
    root = new SimpleLoop(null, true);
    root.SetNestingLevel(0);
    root.Counter = loopCounter++;
    Loops.Add(root);
  }

  public SimpleLoop CreateNewLoop(BasicBlock bb, bool isReducible) {
    SimpleLoop loop = new SimpleLoop(bb, isReducible);
    loop.Counter = loopCounter++;
    Loops.Add(loop);
    return loop;
  }

  public void CalculateNestingLevel() {
    foreach (SimpleLoop l in Loops) {
      if (!l.IsRoot && l.Parent == null) { l.SetParent(root); }
    }
    CalculateNestingLevelRec(root, 0);
  }

  void CalculateNestingLevelRec(SimpleLoop loop, int depth) {
    loop.DepthLevel = depth;
    foreach (SimpleLoop child in loop.Children) {
      CalculateNestingLevelRec(child, depth + 1);
      loop.SetNestingLevel(Math.Max(loop.NestingLevel, 1 + child.NestingLevel));
    }
  }
}

sealed class UnionFindNode {
  public UnionFindNode Parent;
  public BasicBlock Bb;
  public SimpleLoop Loop;
  public int DfsNumber;

  public void InitNode(BasicBlock bb, int dfsNumber) {
    Parent = this;
    Bb = bb;
    DfsNumber = dfsNumber;
    Loop = null;
  }

  public UnionFindNode FindSet() {
    List<UnionFindNode> nodeList = new List<UnionFindNode>();
    UnionFindNode node = this;
    while (node != node.Parent) {
      if (node.Parent != node.Parent.Parent) { nodeList.Add(node); }
      node = node.Parent;
    }
    // The reference unions each with the starting node's parent.
    foreach (UnionFindNode it in nodeList) { it.Parent = Parent; }
    return node;
  }
}

sealed class HavlakLoopFinder {
  const int Unvisited = int.MaxValue;
  const int MaxNonBackPreds = 32 * 1024;
  enum BbClass { Top, NonHeader, Reducible, Self, Irreducible, Dead }

  readonly ControlFlowGraph cfg;
  readonly LoopStructureGraph lsg;
  readonly List<List<int>> nonBackPreds = new List<List<int>>();
  readonly List<List<int>> backPreds = new List<List<int>>();
  readonly Dictionary<BasicBlock, int> number = new Dictionary<BasicBlock, int>();
  int[] header;
  BbClass[] type;
  int[] last;
  UnionFindNode[] nodes;

  public HavlakLoopFinder(ControlFlowGraph cfg, LoopStructureGraph lsg) {
    this.cfg = cfg;
    this.lsg = lsg;
  }

  bool IsAncestor(int w, int v) { return w <= v && v <= last[w]; }

  int DoDFS(BasicBlock currentNode, int current) {
    nodes[current].InitNode(currentNode, current);
    number[currentNode] = current;
    int lastId = current;
    foreach (BasicBlock target in currentNode.OutEdges) {
      if (number[target] == Unvisited) { lastId = DoDFS(target, lastId + 1); }
    }
    last[current] = lastId;
    return lastId;
  }

  static void AddToSet(List<int> s, int v) {
    if (!s.Contains(v)) { s.Add(v); }
  }

  public void FindLoops() {
    if (cfg.StartNode == null) { return; }
    int size = cfg.BasicBlockMap.Count;
    header = new int[size];
    type = new BbClass[size];
    last = new int[size];
    nodes = new UnionFindNode[size];
    for (int i = 0; i < size; i++) {
      nonBackPreds.Add(new List<int>());
      backPreds.Add(new List<int>());
      nodes[i] = new UnionFindNode();
    }
    foreach (BasicBlock bb in cfg.BasicBlockMap) { number[bb] = Unvisited; }
    DoDFS(cfg.StartNode, 0);
    for (int w = 0; w < size; w++) {
      header[w] = 0;
      type[w] = BbClass.NonHeader;
      BasicBlock nodeW = nodes[w].Bb;
      if (nodeW == null) {
        type[w] = BbClass.Dead;
        continue;
      }
      foreach (BasicBlock nodeV in nodeW.InEdges) {
        int v = number[nodeV];
        if (v != Unvisited) {
          if (IsAncestor(w, v)) {
            backPreds[w].Add(v);
          } else {
            AddToSet(nonBackPreds[w], v);
          }
        }
      }
    }
    header[0] = 0;
    for (int w = size - 1; w >= 0; w--) {
      BasicBlock nodeW = nodes[w].Bb;
      if (nodeW == null) { continue; }
      List<UnionFindNode> nodePool = new List<UnionFindNode>();
      foreach (int v in backPreds[w]) {
        if (v != w) {
          nodePool.Add(nodes[v].FindSet());
        } else {
          type[w] = BbClass.Self;
        }
      }
      Queue<UnionFindNode> workList = new Queue<UnionFindNode>(nodePool);
      if (nodePool.Count != 0) { type[w] = BbClass.Reducible; }
      while (workList.Count > 0) {
        UnionFindNode x = workList.Dequeue();
        List<int> preds = nonBackPreds[x.DfsNumber];
        if (preds.Count > MaxNonBackPreds) { return; }
        // The set may grow while it is walked.
        for (int k = 0; k < preds.Count; k++) {
          UnionFindNode ydash = nodes[preds[k]].FindSet();
          int yd = ydash.DfsNumber;
          if (!IsAncestor(w, yd)) {
            type[w] = BbClass.Irreducible;
            AddToSet(nonBackPreds[w], yd);
          } else if (yd != w && !nodePool.Contains(ydash)) {
            workList.Enqueue(ydash);
            nodePool.Add(ydash);
          }
        }
      }
      if (nodePool.Count > 0 || type[w] == BbClass.Self) {
        SimpleLoop loop = lsg.CreateNewLoop(nodeW, type[w] != BbClass.Irreducible);
        nodes[w].Loop = loop;
        foreach (UnionFindNode node in nodePool) {
          header[node.DfsNumber] = w;
          node.Parent = nodes[w];
          if (node.Loop != null) {
            node.Loop.SetParent(loop);
          } else {
            loop.AddNode(node.Bb);
          }
        }
      }
    }
  }
}

sealed class LoopTesterApp {
  readonly ControlFlowGraph cfg = new ControlFlowGraph();
  readonly LoopStructureGraph lsg = new LoopStructureGraph();

  public LoopTesterApp() { cfg.CreateNode(0); }

  int BuildDiamond(int start) {
    int bb0 = start;
    cfg.AddEdge(bb0, bb0 + 1);
    cfg.AddEdge(bb0, bb0 + 2);
    cfg.AddEdge(bb0 + 1, bb0 + 3);
    cfg.AddEdge(bb0 + 2, bb0 + 3);
    return bb0 + 3;
  }

  void BuildConnect(int start, int end) { cfg.AddEdge(start, end); }

  int BuildStraight(int start, int n) {
    for (int i = 0; i < n; i++) { BuildConnect(start + i, start + i + 1); }
    return start + n;
  }

  int BuildBaseLoop(int from) {
    int header = BuildStraight(from, 1);
    int diamond1 = BuildDiamond(header);
    int d11 = BuildStraight(diamond1, 1);
    int diamond2 = BuildDiamond(d11);
    int footer = BuildStraight(diamond2, 1);
    BuildConnect(diamond2, d11);
    BuildConnect(diamond1, header);
    BuildConnect(footer, from);
    return BuildStraight(footer, 1);
  }

  void FindLoops(LoopStructureGraph loopStructure) {
    new HavlakLoopFinder(cfg, loopStructure).FindLoops();
  }

  public (int, int) Main(int numDummyLoops, int findLoopIterations, int parLoops, int pparLoops, int ppparLoops) {
    cfg.CreateNode(0);
    BuildBaseLoop(0);
    cfg.CreateNode(1);
    cfg.AddEdge(0, 2);
    for (int i = 0; i < numDummyLoops; i++) { FindLoops(lsg); }
    int n = 2;
    for (int p = 0; p < parLoops; p++) {
      cfg.CreateNode(n + 1);
      BuildConnect(2, n + 1);
      n += 1;
      for (int i = 0; i < pparLoops; i++) {
        int top = n;
        n = BuildStraight(n, 1);
        for (int j = 0; j < ppparLoops; j++) { n = BuildBaseLoop(n); }
        int bottom = BuildStraight(n, 1);
        BuildConnect(n, top);
        n = bottom;
      }
      BuildConnect(n, 1);
    }
    FindLoops(lsg);
    // The reference discards these results; their loop counts are summed
    // so no compiler can drop the work (as in the Resid port).
    int extra = 0;
    for (int i = 0; i < findLoopIterations; i++) {
      LoopStructureGraph l = new LoopStructureGraph();
      FindLoops(l);
      extra += l.Loops.Count;
    }
    if (extra == 0 && findLoopIterations > 0) { throw new Exception("findLoops found nothing"); }
    lsg.CalculateNestingLevel();
    return (lsg.Loops.Count, cfg.BasicBlockMap.Count);
  }
}

}
