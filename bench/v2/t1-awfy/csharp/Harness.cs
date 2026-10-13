// Are We Fast Yet, C# port: `harness <Benchmark> [outer [inner]]`, the
// reference harness's interface and output (Run.java).
using System;
using System.Diagnostics;

namespace Awfy {

public abstract class Benchmark {
  public abstract bool InnerBenchmarkLoop(int inner);
}

// som.Random
public sealed class Random {
  private int seed = 74755;
  public int Next() {
    seed = ((seed * 1309) + 13849) & 65535;
    return seed;
  }
}

public static class Harness {
  static Benchmark Create(string name) {
    switch (name) {
      case "Bounce": return new Bounce();
      case "List": return new ListBench();
      case "Mandelbrot": return new Mandelbrot();
      case "NBody": return new NBody();
      case "Permute": return new Permute();
      case "Queens": return new Queens();
      case "Sieve": return new Sieve();
      case "Storage": return new Storage();
      case "Towers": return new Towers();
      case "Richards": return new Richards.RichardsBench();
      case "DeltaBlue": return new DeltaBlue.DeltaBlueBench();
      case "Json": return new Json.JsonBench();
      case "CD": return new CD.CDBench();
      case "Havlak": return new Havlak.HavlakBench();
    }
    throw new Exception("No benchmark found with the name: " + name);
  }

  public static int Main(string[] args) {
    if (args.Length < 1) {
      Console.WriteLine("harness benchmark [num-iterations [inner-iter]]");
      return 1;
    }
    string name = args[0];
    int outer = args.Length > 1 ? int.Parse(args[1]) : 1;
    int inner = args.Length > 2 ? int.Parse(args[2]) : 1;
    Benchmark bench = Create(name);
    Console.WriteLine("Starting " + name + " benchmark ...");
    long total = 0;
    for (int i = 0; i < outer; i++) {
      long t0 = Stopwatch.GetTimestamp();
      if (!bench.InnerBenchmarkLoop(inner)) {
        Console.WriteLine("Benchmark failed with incorrect result");
        return 1;
      }
      long us = (Stopwatch.GetTimestamp() - t0) * 1000000 / Stopwatch.Frequency;
      Console.WriteLine(name + ": iterations=1 runtime: " + us + "us");
      total += us;
    }
    Console.WriteLine(name + ": iterations=" + outer + " average: " + (total / outer) + "us total: " + total + "us\n");
    Console.WriteLine("Total Runtime: " + total + "us");
    return 0;
  }
}

}
