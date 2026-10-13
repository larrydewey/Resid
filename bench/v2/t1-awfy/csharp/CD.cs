// AWFY CD (collision detection), after the Java reference: the reference's
// red-black tree, generic over IComparable keys; vectors and call signs are
// readonly structs.
using System;
using System.Collections.Generic;

namespace Awfy.CD {

public sealed class CDBench : Benchmark {
  static int Run(int numAircrafts) {
    int numFrames = 200;
    Simulator simulator = new Simulator(numAircrafts);
    CollisionDetector detector = new CollisionDetector();
    int actualCollisions = 0;
    for (int i = 0; i < numFrames; i++) {
      double time = i / 10.0;
      actualCollisions += detector.HandleNewFrame(simulator.Simulate(time)).Count;
    }
    return actualCollisions;
  }

  public override bool InnerBenchmarkLoop(int inner) {
    int actual = Run(inner);
    switch (inner) {
      case 1000: case 500: return actual == 14484;
      case 250: return actual == 10830;
      case 200: return actual == 8655;
      case 100: return actual == 4305;
      case 10: return actual == 390;
      case 2: return actual == 42;
    }
    Console.WriteLine("No verification result for " + inner + " found; result " + actual);
    return false;
  }
}

static class Constants {
  public const double MinX = 0.0, MinY = 0.0, MaxX = 1000.0, MaxY = 1000.0, MinZ = 0.0, MaxZ = 10.0;
  public const double ProximityRadius = 1.0;
  public const double GoodVoxelSize = ProximityRadius * 2.0;
}

readonly struct Vector2D : IComparable<Vector2D> {
  public readonly double X, Y;
  public Vector2D(double x, double y) { X = x; Y = y; }
  public Vector2D Plus(Vector2D o) { return new Vector2D(X + o.X, Y + o.Y); }
  public Vector2D Minus(Vector2D o) { return new Vector2D(X - o.X, Y - o.Y); }
  public int CompareTo(Vector2D o) {
    int result = CompareNumbers(X, o.X);
    return result != 0 ? result : CompareNumbers(Y, o.Y);
  }
  static int CompareNumbers(double a, double b) {
    if (a == b) { return 0; }
    if (a < b) { return -1; }
    if (a > b) { return 1; }
    if (!double.IsNaN(a)) { return 1; }
    return -1;
  }
}

readonly struct Vector3D {
  public readonly double X, Y, Z;
  public Vector3D(double x, double y, double z) { X = x; Y = y; Z = z; }
  public Vector3D Plus(Vector3D o) { return new Vector3D(X + o.X, Y + o.Y, Z + o.Z); }
  public Vector3D Minus(Vector3D o) { return new Vector3D(X - o.X, Y - o.Y, Z - o.Z); }
  public double Dot(Vector3D o) { return X * o.X + Y * o.Y + Z * o.Z; }
  public double SquaredMagnitude() { return Dot(this); }
  public double Magnitude() { return Math.Sqrt(SquaredMagnitude()); }
  public Vector3D Times(double amount) { return new Vector3D(X * amount, Y * amount, Z * amount); }
}

readonly struct CallSign : IComparable<CallSign> {
  readonly int value;
  public CallSign(int v) { value = v; }
  public int CompareTo(CallSign o) { return value == o.value ? 0 : (value < o.value ? -1 : 1); }
}

readonly struct Aircraft {
  public readonly CallSign Callsign;
  public readonly Vector3D Position;
  public Aircraft(CallSign c, Vector3D p) { Callsign = c; Position = p; }
}

readonly struct Collision {
  public readonly CallSign AircraftA, AircraftB;
  public readonly Vector3D Position;
  public Collision(CallSign a, CallSign b, Vector3D p) { AircraftA = a; AircraftB = b; Position = p; }
}

sealed class Motion {
  public readonly CallSign Callsign;
  public readonly Vector3D PosOne, PosTwo;
  public Motion(CallSign c, Vector3D p1, Vector3D p2) { Callsign = c; PosOne = p1; PosTwo = p2; }
  Vector3D Delta() { return PosTwo.Minus(PosOne); }

  public bool FindIntersection(Motion other, out Vector3D result) {
    Vector3D init1 = PosOne, init2 = other.PosOne;
    Vector3D vec1 = Delta(), vec2 = other.Delta();
    double radius = Constants.ProximityRadius;
    double a = vec2.Minus(vec1).SquaredMagnitude();
    result = default;
    if (a != 0.0) {
      double b = 2.0 * init1.Minus(init2).Dot(vec1.Minus(vec2));
      double c = -radius * radius + init2.Minus(init1).SquaredMagnitude();
      double discr = b * b - 4.0 * a * c;
      if (discr < 0.0) { return false; }
      double v1 = (-b - Math.Sqrt(discr)) / (2.0 * a);
      double v2 = (-b + Math.Sqrt(discr)) / (2.0 * a);
      if (v1 <= v2 && ((v1 <= 1.0 && 1.0 <= v2) || (v1 <= 0.0 && 0.0 <= v2) || (0.0 <= v1 && v2 <= 1.0))) {
        double v = v1 <= 0.0 ? 0.0 : v1;
        Vector3D result1 = init1.Plus(vec1.Times(v));
        Vector3D result2 = init2.Plus(vec2.Times(v));
        Vector3D r = result1.Plus(result2).Times(0.5);
        if (r.X >= Constants.MinX && r.X <= Constants.MaxX && r.Y >= Constants.MinY &&
            r.Y <= Constants.MaxY && r.Z >= Constants.MinZ && r.Z <= Constants.MaxZ) {
          result = r;
          return true;
        }
      }
      return false;
    }
    if (init2.Minus(init1).Magnitude() <= radius) {
      result = init1.Plus(init2).Times(0.5);
      return true;
    }
    return false;
  }
}

sealed class RedBlackTree<K, V> where K : IComparable<K> {
  sealed class Node {
    public readonly K Key;
    public V Value;
    public Node Left, Right, Parent;
    public bool Red = true;
    public Node(K key, V value) { Key = key; Value = value; }
    public Node Successor() {
      Node x = this;
      if (x.Right != null) { return TreeMinimum(x.Right); }
      Node y = x.Parent;
      while (y != null && x == y.Right) {
        x = y;
        y = y.Parent;
      }
      return y;
    }
  }

  Node root;

  static Node TreeMinimum(Node x) {
    Node current = x;
    while (current.Left != null) { current = current.Left; }
    return current;
  }

  static bool IsRed(Node n) { return n != null && n.Red; }

  // Put returns whether there was a previous value, and it in `old`.
  public bool Put(K key, V value, out V old) {
    Node y = null, x = root;
    while (x != null) {
      y = x;
      int c = key.CompareTo(x.Key);
      if (c < 0) {
        x = x.Left;
      } else if (c > 0) {
        x = x.Right;
      } else {
        old = x.Value;
        x.Value = value;
        return true;
      }
    }
    Node z = new Node(key, value) { Parent = y };
    if (y == null) {
      root = z;
    } else if (key.CompareTo(y.Key) < 0) {
      y.Left = z;
    } else {
      y.Right = z;
    }
    x = z;
    while (x != root && x.Parent.Red) {
      if (x.Parent == x.Parent.Parent.Left) {
        Node u = x.Parent.Parent.Right;
        if (IsRed(u)) {
          x.Parent.Red = false;
          u.Red = false;
          x.Parent.Parent.Red = true;
          x = x.Parent.Parent;
        } else {
          if (x == x.Parent.Right) {
            x = x.Parent;
            LeftRotate(x);
          }
          x.Parent.Red = false;
          x.Parent.Parent.Red = true;
          RightRotate(x.Parent.Parent);
        }
      } else {
        Node u = x.Parent.Parent.Left;
        if (IsRed(u)) {
          x.Parent.Red = false;
          u.Red = false;
          x.Parent.Parent.Red = true;
          x = x.Parent.Parent;
        } else {
          if (x == x.Parent.Left) {
            x = x.Parent;
            RightRotate(x);
          }
          x.Parent.Red = false;
          x.Parent.Parent.Red = true;
          LeftRotate(x.Parent.Parent);
        }
      }
    }
    root.Red = false;
    old = default;
    return false;
  }

  public void Remove(K key) {
    Node z = FindNode(key);
    if (z == null) { return; }
    Node y = (z.Left == null || z.Right == null) ? z : z.Successor();
    Node x = y.Left != null ? y.Left : y.Right;
    Node xParent;
    if (x != null) {
      x.Parent = y.Parent;
      xParent = x.Parent;
    } else {
      xParent = y.Parent;
    }
    if (y.Parent == null) {
      root = x;
    } else if (y == y.Parent.Left) {
      y.Parent.Left = x;
    } else {
      y.Parent.Right = x;
    }
    if (y != z) {
      if (!y.Red) { RemoveFixup(x, xParent); }
      y.Parent = z.Parent;
      y.Red = z.Red;
      y.Left = z.Left;
      y.Right = z.Right;
      if (z.Left != null) { z.Left.Parent = y; }
      if (z.Right != null) { z.Right.Parent = y; }
      if (z.Parent != null) {
        if (z.Parent.Left == z) { z.Parent.Left = y; } else { z.Parent.Right = y; }
      } else {
        root = y;
      }
    } else if (!y.Red) {
      RemoveFixup(x, xParent);
    }
  }

  public bool Get(K key, out V value) {
    Node node = FindNode(key);
    if (node == null) {
      value = default;
      return false;
    }
    value = node.Value;
    return true;
  }

  public void ForEach(Action<K, V> fn) {
    if (root == null) { return; }
    for (Node current = TreeMinimum(root); current != null; current = current.Successor()) {
      fn(current.Key, current.Value);
    }
  }

  Node FindNode(K key) {
    Node current = root;
    while (current != null) {
      int c = key.CompareTo(current.Key);
      if (c == 0) { return current; }
      current = c < 0 ? current.Left : current.Right;
    }
    return null;
  }

  void LeftRotate(Node x) {
    Node y = x.Right;
    x.Right = y.Left;
    if (y.Left != null) { y.Left.Parent = x; }
    y.Parent = x.Parent;
    if (x.Parent == null) {
      root = y;
    } else if (x == x.Parent.Left) {
      x.Parent.Left = y;
    } else {
      x.Parent.Right = y;
    }
    y.Left = x;
    x.Parent = y;
  }

  void RightRotate(Node y) {
    Node x = y.Left;
    y.Left = x.Right;
    if (x.Right != null) { x.Right.Parent = y; }
    x.Parent = y.Parent;
    if (y.Parent == null) {
      root = x;
    } else if (y == y.Parent.Left) {
      y.Parent.Left = x;
    } else {
      y.Parent.Right = x;
    }
    x.Right = y;
    y.Parent = x;
  }

  void RemoveFixup(Node x, Node xParent) {
    while (x != root && !IsRed(x)) {
      if (x == xParent.Left) {
        Node w = xParent.Right;
        if (w.Red) {
          w.Red = false;
          xParent.Red = true;
          LeftRotate(xParent);
          w = xParent.Right;
        }
        if (!IsRed(w.Left) && !IsRed(w.Right)) {
          w.Red = true;
          x = xParent;
          xParent = x.Parent;
        } else {
          if (!IsRed(w.Right)) {
            w.Left.Red = false;
            w.Red = true;
            RightRotate(w);
            w = xParent.Right;
          }
          w.Red = xParent.Red;
          xParent.Red = false;
          if (w.Right != null) { w.Right.Red = false; }
          LeftRotate(xParent);
          x = root;
          xParent = x.Parent;
        }
      } else {
        Node w = xParent.Left;
        if (w.Red) {
          w.Red = false;
          xParent.Red = true;
          RightRotate(xParent);
          w = xParent.Left;
        }
        if (!IsRed(w.Right) && !IsRed(w.Left)) {
          w.Red = true;
          x = xParent;
          xParent = x.Parent;
        } else {
          if (!IsRed(w.Left)) {
            w.Right.Red = false;
            w.Red = true;
            LeftRotate(w);
            w = xParent.Left;
          }
          w.Red = xParent.Red;
          xParent.Red = false;
          if (w.Left != null) { w.Left.Red = false; }
          RightRotate(xParent);
          x = root;
          xParent = x.Parent;
        }
      }
    }
    if (x != null) { x.Red = false; }
  }
}

sealed class CollisionDetector {
  readonly RedBlackTree<CallSign, Vector3D> state = new RedBlackTree<CallSign, Vector3D>();

  public List<Collision> HandleNewFrame(List<Aircraft> frame) {
    List<Motion> motions = new List<Motion>();
    RedBlackTree<CallSign, bool> seen = new RedBlackTree<CallSign, bool>();
    foreach (Aircraft aircraft in frame) {
      Vector3D newPosition = aircraft.Position;
      if (!state.Put(aircraft.Callsign, aircraft.Position, out Vector3D oldPosition)) {
        oldPosition = newPosition;
      }
      seen.Put(aircraft.Callsign, true, out _);
      motions.Add(new Motion(aircraft.Callsign, oldPosition, newPosition));
    }
    List<CallSign> toRemove = new List<CallSign>();
    state.ForEach((k, _) => {
      seen.Get(k, out bool s);
      if (!s) { toRemove.Add(k); }
    });
    foreach (CallSign k in toRemove) { state.Remove(k); }
    List<Collision> collisions = new List<Collision>();
    foreach (List<Motion> reduced in ReduceCollisionSet(motions)) {
      for (int i = 0; i < reduced.Count; i++) {
        Motion motion1 = reduced[i];
        for (int j = i + 1; j < reduced.Count; j++) {
          Motion motion2 = reduced[j];
          if (motion1.FindIntersection(motion2, out Vector3D collision)) {
            collisions.Add(new Collision(motion1.Callsign, motion2.Callsign, collision));
          }
        }
      }
    }
    return collisions;
  }

  static bool IsInVoxel(Vector2D voxel, Motion motion) {
    if (voxel.X > Constants.MaxX || voxel.X < Constants.MinX || voxel.Y > Constants.MaxY || voxel.Y < Constants.MinY) {
      return false;
    }
    Vector3D init = motion.PosOne, fin = motion.PosTwo;
    double vS = Constants.GoodVoxelSize;
    double r = Constants.ProximityRadius / 2.0;
    double vX = voxel.X, x0 = init.X, xv = fin.X - init.X;
    double vY = voxel.Y, y0 = init.Y, yv = fin.Y - init.Y;
    double lowX = (vX - r - x0) / xv;
    double highX = (vX + vS + r - x0) / xv;
    if (xv < 0.0) { (lowX, highX) = (highX, lowX); }
    double lowY = (vY - r - y0) / yv;
    double highY = (vY + vS + r - y0) / yv;
    if (yv < 0.0) { (lowY, highY) = (highY, lowY); }
    return ((xv == 0.0 && vX <= x0 + r && x0 - r <= vX + vS) ||
            (lowX <= 1.0 && 1.0 <= highX) || (lowX <= 0.0 && 0.0 <= highX) ||
            (0.0 <= lowX && highX <= 1.0)) &&
           ((yv == 0.0 && vY <= y0 + r && y0 - r <= vY + vS) ||
            ((lowY <= 1.0 && 1.0 <= highY) || (lowY <= 0.0 && 0.0 <= highY) ||
             (0.0 <= lowY && highY <= 1.0))) &&
           (xv == 0.0 || yv == 0.0 ||
            (lowY <= highX && highX <= highY) ||
            (lowY <= lowX && lowX <= highY) ||
            (lowX <= lowY && highY <= highX));
  }

  static readonly Vector2D Horizontal = new Vector2D(Constants.GoodVoxelSize, 0.0);
  static readonly Vector2D Vertical = new Vector2D(0.0, Constants.GoodVoxelSize);

  static void PutIntoMap(RedBlackTree<Vector2D, List<Motion>> voxelMap, Vector2D voxel, Motion motion) {
    if (!voxelMap.Get(voxel, out List<Motion> array)) {
      array = new List<Motion>();
      voxelMap.Put(voxel, array, out _);
    }
    array.Add(motion);
  }

  static void Recurse(RedBlackTree<Vector2D, List<Motion>> voxelMap, RedBlackTree<Vector2D, bool> seen,
                      Vector2D nextVoxel, Motion motion) {
    if (!IsInVoxel(nextVoxel, motion)) { return; }
    if (seen.Put(nextVoxel, true, out bool old) && old) { return; }
    PutIntoMap(voxelMap, nextVoxel, motion);
    Recurse(voxelMap, seen, nextVoxel.Minus(Horizontal), motion);
    Recurse(voxelMap, seen, nextVoxel.Plus(Horizontal), motion);
    Recurse(voxelMap, seen, nextVoxel.Minus(Vertical), motion);
    Recurse(voxelMap, seen, nextVoxel.Plus(Vertical), motion);
    Recurse(voxelMap, seen, nextVoxel.Minus(Horizontal).Minus(Vertical), motion);
    Recurse(voxelMap, seen, nextVoxel.Minus(Horizontal).Plus(Vertical), motion);
    Recurse(voxelMap, seen, nextVoxel.Plus(Horizontal).Minus(Vertical), motion);
    Recurse(voxelMap, seen, nextVoxel.Plus(Horizontal).Plus(Vertical), motion);
  }

  static List<List<Motion>> ReduceCollisionSet(List<Motion> motions) {
    RedBlackTree<Vector2D, List<Motion>> voxelMap = new RedBlackTree<Vector2D, List<Motion>>();
    foreach (Motion motion in motions) {
      Recurse(voxelMap, new RedBlackTree<Vector2D, bool>(), VoxelHash(motion.PosOne), motion);
    }
    List<List<Motion>> result = new List<List<Motion>>();
    voxelMap.ForEach((_, v) => {
      if (v.Count > 1) { result.Add(v); }
    });
    return result;
  }

  static Vector2D VoxelHash(Vector3D position) {
    int xDiv = (int) (position.X / Constants.GoodVoxelSize);
    int yDiv = (int) (position.Y / Constants.GoodVoxelSize);
    double x = Constants.GoodVoxelSize * xDiv;
    double y = Constants.GoodVoxelSize * yDiv;
    if (position.X < 0) { x -= Constants.GoodVoxelSize; }
    if (position.Y < 0) { y -= Constants.GoodVoxelSize; }
    return new Vector2D(x, y);
  }
}

sealed class Simulator {
  readonly List<CallSign> aircraft = new List<CallSign>();

  public Simulator(int numAircraft) {
    for (int i = 0; i < numAircraft; i++) { aircraft.Add(new CallSign(i)); }
  }

  public List<Aircraft> Simulate(double time) {
    List<Aircraft> frame = new List<Aircraft>();
    for (int i = 0; i < aircraft.Count; i += 2) {
      frame.Add(new Aircraft(aircraft[i], new Vector3D(time, Math.Cos(time) * 2 + i * 3, 10)));
      frame.Add(new Aircraft(aircraft[i + 1], new Vector3D(time, Math.Sin(time) * 2 + i * 3, 10)));
    }
    return frame;
  }
}

}
