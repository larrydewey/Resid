// n-body, single-threaded reference algorithm (Benchmarks Game description).
using System;
using System.Globalization;

public static class NBody
{
    const double PI = 3.141592653589793;
    const double SolarMass = 4 * PI * PI;
    const double DaysPerYear = 365.24;

    sealed class Body
    {
        public double x, y, z, vx, vy, vz, mass;
        public Body(double x, double y, double z, double vx, double vy, double vz, double mass)
        {
            this.x = x; this.y = y; this.z = z;
            this.vx = vx * DaysPerYear; this.vy = vy * DaysPerYear; this.vz = vz * DaysPerYear;
            this.mass = mass * SolarMass;
        }
    }

    static Body[] Bodies() => new[]
    {
        new Body(0, 0, 0, 0, 0, 0, 1),
        new Body(4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
                 1.66007664274403694e-03, 7.69901118419740425e-03, -6.90460016972063023e-05,
                 9.54791938424326609e-04),
        new Body(8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
                 -2.76742510726862411e-03, 4.99852801234917238e-03, 2.30417297573763929e-05,
                 2.85885980666130812e-04),
        new Body(1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
                 2.96460137564761618e-03, 2.37847173959480950e-03, -2.96589568540237556e-05,
                 4.36624404335156298e-05),
        new Body(1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
                 2.68067772490389322e-03, 1.62824170038242295e-03, -9.51592254519715870e-05,
                 5.15138902046611451e-05),
    };

    static void OffsetMomentum(Body[] b)
    {
        double px = 0, py = 0, pz = 0;
        foreach (var x in b) { px += x.vx * x.mass; py += x.vy * x.mass; pz += x.vz * x.mass; }
        b[0].vx = -px / SolarMass; b[0].vy = -py / SolarMass; b[0].vz = -pz / SolarMass;
    }

    static double Energy(Body[] b)
    {
        double e = 0;
        for (int i = 0; i < b.Length; i++)
        {
            var bi = b[i];
            e += 0.5 * bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz);
            for (int j = i + 1; j < b.Length; j++)
            {
                var bj = b[j];
                double dx = bi.x - bj.x, dy = bi.y - bj.y, dz = bi.z - bj.z;
                e -= (bi.mass * bj.mass) / Math.Sqrt(dx * dx + dy * dy + dz * dz);
            }
        }
        return e;
    }

    static void Advance(Body[] b, double dt)
    {
        int n = b.Length;
        for (int i = 0; i < n; i++)
        {
            var bi = b[i];
            for (int j = i + 1; j < n; j++)
            {
                var bj = b[j];
                double dx = bi.x - bj.x, dy = bi.y - bj.y, dz = bi.z - bj.z;
                double d2 = dx * dx + dy * dy + dz * dz;
                double mag = dt / (d2 * Math.Sqrt(d2));
                bi.vx -= dx * bj.mass * mag; bi.vy -= dy * bj.mass * mag; bi.vz -= dz * bj.mass * mag;
                bj.vx += dx * bi.mass * mag; bj.vy += dy * bi.mass * mag; bj.vz += dz * bi.mass * mag;
            }
        }
        foreach (var x in b) { x.x += dt * x.vx; x.y += dt * x.vy; x.z += dt * x.vz; }
    }

    public static void Main(string[] args)
    {
        int n = int.Parse(args[0]);
        var b = Bodies();
        OffsetMomentum(b);
        Console.WriteLine(Energy(b).ToString("F9", CultureInfo.InvariantCulture));
        for (int i = 0; i < n; i++) Advance(b, 0.01);
        Console.WriteLine(Energy(b).ToString("F9", CultureInfo.InvariantCulture));
    }
}
