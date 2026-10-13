// The nine small Are We Fast Yet benchmarks, after the Java reference.
using System;

namespace Awfy {

public abstract class RepeatingBenchmark : Benchmark {
  public abstract object Run();
  public abstract bool Verify(object result);
  public override bool InnerBenchmarkLoop(int inner) {
    for (int i = 0; i < inner; i++) {
      if (!Verify(Run())) { return false; }
    }
    return true;
  }
}

// ---- Bounce -----------------------------------------------------------------

public sealed class Bounce : RepeatingBenchmark {
  sealed class Ball {
    int x, y, xVel, yVel;
    public Ball(Random r) {
      x = r.Next() % 500;
      y = r.Next() % 500;
      xVel = (r.Next() % 300) - 150;
      yVel = (r.Next() % 300) - 150;
    }
    public bool DoBounce() {
      int xLimit = 500, yLimit = 500;
      bool bounced = false;
      x += xVel;
      y += yVel;
      if (x > xLimit) { x = xLimit; xVel = 0 - Math.Abs(xVel); bounced = true; }
      if (x < 0) { x = 0; xVel = Math.Abs(xVel); bounced = true; }
      if (y > yLimit) { y = yLimit; yVel = 0 - Math.Abs(yVel); bounced = true; }
      if (y < 0) { y = 0; yVel = Math.Abs(yVel); bounced = true; }
      return bounced;
    }
  }

  public override object Run() {
    Random random = new Random();
    int ballCount = 100;
    int bounces = 0;
    Ball[] balls = new Ball[ballCount];
    for (int i = 0; i < ballCount; i++) { balls[i] = new Ball(random); }
    for (int i = 0; i < 50; i++) {
      foreach (Ball b in balls) {
        if (b.DoBounce()) { bounces++; }
      }
    }
    return bounces;
  }
  public override bool Verify(object r) { return (int) r == 1331; }
}

// ---- List -------------------------------------------------------------------

public sealed class ListBench : RepeatingBenchmark {
  sealed class Element {
    public int Val;
    public Element Next;
    public Element(int v) { Val = v; }
    public int Length() { return Next == null ? 1 : 1 + Next.Length(); }
  }

  static Element MakeList(int length) {
    if (length == 0) { return null; }
    Element e = new Element(length);
    e.Next = MakeList(length - 1);
    return e;
  }

  static bool IsShorterThan(Element x, Element y) {
    Element xTail = x, yTail = y;
    while (yTail != null) {
      if (xTail == null) { return true; }
      xTail = xTail.Next;
      yTail = yTail.Next;
    }
    return false;
  }

  static Element Tail(Element x, Element y, Element z) {
    if (IsShorterThan(y, x)) {
      return Tail(Tail(x.Next, y, z), Tail(y.Next, z, x), Tail(z.Next, x, y));
    }
    return z;
  }

  public override object Run() { return Tail(MakeList(15), MakeList(10), MakeList(6)).Length(); }
  public override bool Verify(object r) { return (int) r == 10; }
}

// ---- Mandelbrot -------------------------------------------------------------

public sealed class Mandelbrot : Benchmark {
  public override bool InnerBenchmarkLoop(int inner) {
    int r = Run(inner);
    if (inner == 500) { return r == 191; }
    if (inner == 750) { return r == 50; }
    if (inner == 1) { return r == 128; }
    Console.WriteLine("No verification result for " + inner + " found; result " + r);
    return false;
  }

  static int Run(int size) {
    int sum = 0, byteAcc = 0, bitNum = 0;
    for (int y = 0; y < size; y++) {
      double ci = (2.0 * y / size) - 1.0;
      for (int x = 0; x < size; x++) {
        double zrzr = 0.0, zi = 0.0, zizi = 0.0;
        double cr = (2.0 * x / size) - 1.5;
        int z = 0;
        bool notDone = true;
        int escape = 0;
        while (notDone && z < 50) {
          double zr = zrzr - zizi + cr;
          zi = 2.0 * zr * zi + ci;
          zrzr = zr * zr;
          zizi = zi * zi;
          if (zrzr + zizi > 4.0) { notDone = false; escape = 1; }
          z += 1;
        }
        byteAcc = (byteAcc << 1) + escape;
        bitNum += 1;
        if (bitNum == 8) {
          sum ^= byteAcc;
          byteAcc = 0;
          bitNum = 0;
        } else if (x == size - 1) {
          byteAcc <<= (8 - bitNum);
          sum ^= byteAcc;
          byteAcc = 0;
          bitNum = 0;
        }
      }
    }
    return sum;
  }
}

// ---- NBody ------------------------------------------------------------------

public sealed class NBody : Benchmark {
  const double SolarMass = 4 * Math.PI * Math.PI;
  const double DaysPerYear = 365.24;

  sealed class Body {
    public double X, Y, Z, VX, VY, VZ, Mass;
    public Body(double x, double y, double z, double vx, double vy, double vz, double mass) {
      X = x; Y = y; Z = z;
      VX = vx * DaysPerYear; VY = vy * DaysPerYear; VZ = vz * DaysPerYear;
      Mass = mass * SolarMass;
    }
  }

  static Body[] CreateBodies() {
    Body[] bodies = {
      new Body(0, 0, 0, 0, 0, 0, 1),
      new Body(4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
               1.66007664274403694e-03, 7.69901118419740425e-03, -6.90460016972063023e-05, 9.54791938424326609e-04),
      new Body(8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
               -2.76742510726862411e-03, 4.99852801234917238e-03, 2.30417297573763929e-05, 2.85885980666130812e-04),
      new Body(1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
               2.96460137564761618e-03, 2.37847173959480950e-03, -2.96589568540237556e-05, 4.36624404335156298e-05),
      new Body(1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
               2.68067772490389322e-03, 1.62824170038242295e-03, -9.51592254519715870e-05, 5.15138902046611451e-05),
    };
    double px = 0.0, py = 0.0, pz = 0.0;
    foreach (Body b in bodies) {
      px += b.VX * b.Mass;
      py += b.VY * b.Mass;
      pz += b.VZ * b.Mass;
    }
    bodies[0].VX = 0.0 - (px / SolarMass);
    bodies[0].VY = 0.0 - (py / SolarMass);
    bodies[0].VZ = 0.0 - (pz / SolarMass);
    return bodies;
  }

  static void Advance(Body[] bodies, double dt) {
    for (int i = 0; i < bodies.Length; i++) {
      Body ib = bodies[i];
      for (int j = i + 1; j < bodies.Length; j++) {
        Body jb = bodies[j];
        double dx = ib.X - jb.X, dy = ib.Y - jb.Y, dz = ib.Z - jb.Z;
        double dSquared = dx * dx + dy * dy + dz * dz;
        double distance = Math.Sqrt(dSquared);
        double mag = dt / (dSquared * distance);
        ib.VX = ib.VX - (dx * jb.Mass * mag);
        ib.VY = ib.VY - (dy * jb.Mass * mag);
        ib.VZ = ib.VZ - (dz * jb.Mass * mag);
        jb.VX = jb.VX + (dx * ib.Mass * mag);
        jb.VY = jb.VY + (dy * ib.Mass * mag);
        jb.VZ = jb.VZ + (dz * ib.Mass * mag);
      }
    }
    foreach (Body b in bodies) {
      b.X = b.X + dt * b.VX;
      b.Y = b.Y + dt * b.VY;
      b.Z = b.Z + dt * b.VZ;
    }
  }

  static double Energy(Body[] bodies) {
    double e = 0.0;
    for (int i = 0; i < bodies.Length; i++) {
      Body ib = bodies[i];
      e += 0.5 * ib.Mass * (ib.VX * ib.VX + ib.VY * ib.VY + ib.VZ * ib.VZ);
      for (int j = i + 1; j < bodies.Length; j++) {
        Body jb = bodies[j];
        double dx = ib.X - jb.X, dy = ib.Y - jb.Y, dz = ib.Z - jb.Z;
        e -= (ib.Mass * jb.Mass) / Math.Sqrt(dx * dx + dy * dy + dz * dz);
      }
    }
    return e;
  }

  public override bool InnerBenchmarkLoop(int inner) {
    Body[] system = CreateBodies();
    for (int i = 0; i < inner; i++) { Advance(system, 0.01); }
    double r = Energy(system);
    if (inner == 250000) { return r == -0.1690859889909308; }
    if (inner == 1) { return r == -0.16907495402506745; }
    Console.WriteLine("No verification result for " + inner + " found");
    return false;
  }
}

// ---- Permute ----------------------------------------------------------------

public sealed class Permute : RepeatingBenchmark {
  int count;
  int[] v;

  public override object Run() {
    count = 0;
    v = new int[6];
    DoPermute(6);
    return count;
  }

  void DoPermute(int n) {
    count++;
    if (n != 0) {
      int n1 = n - 1;
      DoPermute(n1);
      for (int i = n1; i >= 0; i--) {
        Swap(n1, i);
        DoPermute(n1);
        Swap(n1, i);
      }
    }
  }

  void Swap(int i, int j) {
    int tmp = v[i];
    v[i] = v[j];
    v[j] = tmp;
  }

  public override bool Verify(object r) { return (int) r == 8660; }
}

// ---- Queens -----------------------------------------------------------------

public sealed class Queens : RepeatingBenchmark {
  bool[] freeMaxs, freeRows, freeMins;
  int[] queenRows;

  public override object Run() {
    bool result = true;
    for (int i = 0; i < 10; i++) { result = result && DoQueens(); }
    return result;
  }

  bool DoQueens() {
    freeRows = new bool[8];
    Array.Fill(freeRows, true);
    freeMaxs = new bool[16];
    Array.Fill(freeMaxs, true);
    freeMins = new bool[16];
    Array.Fill(freeMins, true);
    queenRows = new int[8];
    Array.Fill(queenRows, -1);
    return PlaceQueen(0);
  }

  bool PlaceQueen(int c) {
    for (int r = 0; r < 8; r++) {
      if (GetRowColumn(r, c)) {
        queenRows[r] = c;
        SetRowColumn(r, c, false);
        if (c == 7) { return true; }
        if (PlaceQueen(c + 1)) { return true; }
        SetRowColumn(r, c, true);
      }
    }
    return false;
  }

  bool GetRowColumn(int r, int c) { return freeRows[r] && freeMaxs[c + r] && freeMins[c - r + 7]; }

  void SetRowColumn(int r, int c, bool v) {
    freeRows[r] = v;
    freeMaxs[c + r] = v;
    freeMins[c - r + 7] = v;
  }

  public override bool Verify(object r) { return (bool) r; }
}

// ---- Sieve ------------------------------------------------------------------

public sealed class Sieve : RepeatingBenchmark {
  public override object Run() {
    bool[] flags = new bool[5000];
    Array.Fill(flags, true);
    return DoSieve(flags, 5000);
  }

  static int DoSieve(bool[] flags, int size) {
    int primeCount = 0;
    for (int i = 2; i <= size; i++) {
      if (flags[i - 1]) {
        primeCount++;
        for (int k = i + i; k <= size; k += i) { flags[k - 1] = false; }
      }
    }
    return primeCount;
  }

  public override bool Verify(object r) { return (int) r == 669; }
}

// ---- Storage ----------------------------------------------------------------

public sealed class Storage : RepeatingBenchmark {
  int count;

  public override object Run() {
    Random random = new Random();
    count = 0;
    BuildTreeDepth(7, random);
    return count;
  }

  object BuildTreeDepth(int depth, Random random) {
    count++;
    if (depth == 1) { return new object[random.Next() % 10 + 1]; }
    object[] arr = new object[4];
    for (int i = 0; i < 4; i++) { arr[i] = BuildTreeDepth(depth - 1, random); }
    return arr;
  }

  public override bool Verify(object r) { return (int) r == 5461; }
}

// ---- Towers -----------------------------------------------------------------

public sealed class Towers : RepeatingBenchmark {
  sealed class TowersDisk {
    public readonly int Size;
    public TowersDisk Next;
    public TowersDisk(int size) { Size = size; }
  }

  TowersDisk[] piles;
  int movesDone;

  public override object Run() {
    piles = new TowersDisk[3];
    BuildTowerAt(0, 13);
    movesDone = 0;
    MoveDisks(13, 0, 1);
    return movesDone;
  }

  void PushDisk(TowersDisk disk, int pile) {
    TowersDisk top = piles[pile];
    if (top != null && disk.Size >= top.Size) {
      throw new Exception("Cannot put a big disk on a smaller one");
    }
    disk.Next = top;
    piles[pile] = disk;
  }

  TowersDisk PopDiskFrom(int pile) {
    TowersDisk top = piles[pile];
    if (top == null) { throw new Exception("Attempting to remove a disk from an empty pile"); }
    piles[pile] = top.Next;
    top.Next = null;
    return top;
  }

  void MoveTopDisk(int from, int to) {
    PushDisk(PopDiskFrom(from), to);
    movesDone++;
  }

  void BuildTowerAt(int pile, int disks) {
    for (int i = disks; i >= 0; i--) { PushDisk(new TowersDisk(i), pile); }
  }

  void MoveDisks(int disks, int from, int to) {
    if (disks == 1) {
      MoveTopDisk(from, to);
    } else {
      int other = (3 - from) - to;
      MoveDisks(disks - 1, from, other);
      MoveTopDisk(from, to);
      MoveDisks(disks - 1, other, to);
    }
  }

  public override bool Verify(object r) { return (int) r == 8191; }
}

}
