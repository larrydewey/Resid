/* n-body, single-threaded reference implementation.
 * Algorithm as described by the Computer Language Benchmarks Game. */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define PI 3.141592653589793
#define SOLAR_MASS (4 * PI * PI)
#define DAYS_PER_YEAR 365.24
#define NBODIES 5

struct body {
    double x, y, z, vx, vy, vz, mass;
};

static struct body bodies[NBODIES] = {
    /* sun */
    {0, 0, 0, 0, 0, 0, SOLAR_MASS},
    /* jupiter */
    {4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
     1.66007664274403694e-03 * DAYS_PER_YEAR, 7.69901118419740425e-03 * DAYS_PER_YEAR,
     -6.90460016972063023e-05 * DAYS_PER_YEAR, 9.54791938424326609e-04 * SOLAR_MASS},
    /* saturn */
    {8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
     -2.76742510726862411e-03 * DAYS_PER_YEAR, 4.99852801234917238e-03 * DAYS_PER_YEAR,
     2.30417297573763929e-05 * DAYS_PER_YEAR, 2.85885980666130812e-04 * SOLAR_MASS},
    /* uranus */
    {1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
     2.96460137564761618e-03 * DAYS_PER_YEAR, 2.37847173959480950e-03 * DAYS_PER_YEAR,
     -2.96589568540237556e-05 * DAYS_PER_YEAR, 4.36624404335156298e-05 * SOLAR_MASS},
    /* neptune */
    {1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
     2.68067772490389322e-03 * DAYS_PER_YEAR, 1.62824170038242295e-03 * DAYS_PER_YEAR,
     -9.51592254519715870e-05 * DAYS_PER_YEAR, 5.15138902046611451e-05 * SOLAR_MASS},
};

static void advance(struct body *b, int n, double dt) {
    for (int i = 0; i < n; i++) {
        struct body *bi = &b[i];
        for (int j = i + 1; j < n; j++) {
            struct body *bj = &b[j];
            double dx = bi->x - bj->x;
            double dy = bi->y - bj->y;
            double dz = bi->z - bj->z;
            double d2 = dx * dx + dy * dy + dz * dz;
            double mag = dt / (d2 * sqrt(d2));
            bi->vx -= dx * bj->mass * mag;
            bi->vy -= dy * bj->mass * mag;
            bi->vz -= dz * bj->mass * mag;
            bj->vx += dx * bi->mass * mag;
            bj->vy += dy * bi->mass * mag;
            bj->vz += dz * bi->mass * mag;
        }
    }
    for (int i = 0; i < n; i++) {
        b[i].x += dt * b[i].vx;
        b[i].y += dt * b[i].vy;
        b[i].z += dt * b[i].vz;
    }
}

static double energy(const struct body *b, int n) {
    double e = 0.0;
    for (int i = 0; i < n; i++) {
        const struct body *bi = &b[i];
        e += 0.5 * bi->mass * (bi->vx * bi->vx + bi->vy * bi->vy + bi->vz * bi->vz);
        for (int j = i + 1; j < n; j++) {
            const struct body *bj = &b[j];
            double dx = bi->x - bj->x;
            double dy = bi->y - bj->y;
            double dz = bi->z - bj->z;
            e -= (bi->mass * bj->mass) / sqrt(dx * dx + dy * dy + dz * dz);
        }
    }
    return e;
}

static void offset_momentum(struct body *b, int n) {
    double px = 0.0, py = 0.0, pz = 0.0;
    for (int i = 0; i < n; i++) {
        px += b[i].vx * b[i].mass;
        py += b[i].vy * b[i].mass;
        pz += b[i].vz * b[i].mass;
    }
    b[0].vx = -px / SOLAR_MASS;
    b[0].vy = -py / SOLAR_MASS;
    b[0].vz = -pz / SOLAR_MASS;
}

int main(int argc, char **argv) {
    int n = argc > 1 ? atoi(argv[1]) : 1000;
    offset_momentum(bodies, NBODIES);
    printf("%.9f\n", energy(bodies, NBODIES));
    for (int i = 0; i < n; i++)
        advance(bodies, NBODIES, 0.01);
    printf("%.9f\n", energy(bodies, NBODIES));
    return 0;
}
