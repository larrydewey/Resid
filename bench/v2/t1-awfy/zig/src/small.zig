// The nine small Are We Fast Yet benchmarks, after the Java reference, with
// the C++ port's memory strategy: what the reference allocates is allocated
// and freed; Bounce, NBody and Sieve live on the stack.
const std = @import("std");
const Allocator = std.mem.Allocator;
const Random = @import("som.zig").Random;

fn repeat(gpa: Allocator, n: u32, comptime body: fn (Allocator) anyerror!bool) !bool {
    var i: u32 = 0;
    while (i < n) : (i += 1) {
        if (!try body(gpa)) return false;
    }
    return true;
}

// ---- Bounce -----------------------------------------------------------------

const Ball = struct {
    x: i32,
    y: i32,
    x_vel: i32,
    y_vel: i32,

    fn init(r: *Random) Ball {
        const x = @rem(r.next(), 500);
        const y = @rem(r.next(), 500);
        const xv = @rem(r.next(), 300) - 150;
        const yv = @rem(r.next(), 300) - 150;
        return .{ .x = x, .y = y, .x_vel = xv, .y_vel = yv };
    }

    fn bounce(b: *Ball) bool {
        const x_limit = 500;
        const y_limit = 500;
        var bounced = false;
        b.x += b.x_vel;
        b.y += b.y_vel;
        if (b.x > x_limit) {
            b.x = x_limit;
            b.x_vel = 0 - @as(i32, @intCast(@abs(b.x_vel)));
            bounced = true;
        }
        if (b.x < 0) {
            b.x = 0;
            b.x_vel = @intCast(@abs(b.x_vel));
            bounced = true;
        }
        if (b.y > y_limit) {
            b.y = y_limit;
            b.y_vel = 0 - @as(i32, @intCast(@abs(b.y_vel)));
            bounced = true;
        }
        if (b.y < 0) {
            b.y = 0;
            b.y_vel = @intCast(@abs(b.y_vel));
            bounced = true;
        }
        return bounced;
    }
};

fn bounceOnce(_: Allocator) !bool {
    var random = Random{};
    var balls: [100]Ball = undefined;
    for (&balls) |*b| b.* = Ball.init(&random);
    var bounces: i32 = 0;
    var i: u32 = 0;
    while (i < 50) : (i += 1) {
        for (&balls) |*b| {
            if (b.bounce()) bounces += 1;
        }
    }
    return bounces == 1331;
}

pub fn bounce(gpa: Allocator, n: u32) !bool {
    return repeat(gpa, n, bounceOnce);
}

// ---- List -------------------------------------------------------------------

const Element = struct {
    val: i32,
    next: ?*Element = null,

    fn length(e: *const Element) i32 {
        return if (e.next) |n| 1 + n.length() else 1;
    }

    fn destroy(e: *Element, gpa: Allocator) void {
        if (e.next) |n| n.destroy(gpa);
        gpa.destroy(e);
    }
};

fn makeList(gpa: Allocator, len: i32) !?*Element {
    if (len == 0) return null;
    const e = try gpa.create(Element);
    e.* = .{ .val = len };
    e.next = try makeList(gpa, len - 1);
    return e;
}

fn isShorterThan(x: ?*Element, y: ?*Element) bool {
    var x_tail = x;
    var y_tail = y;
    while (y_tail) |yt| {
        const xt = x_tail orelse return true;
        x_tail = xt.next;
        y_tail = yt.next;
    }
    return false;
}

fn tail(x: ?*Element, y: ?*Element, z: ?*Element) ?*Element {
    if (isShorterThan(y, x)) {
        return tail(tail(x.?.next, y, z), tail(y.?.next, z, x), tail(z.?.next, x, y));
    }
    return z;
}

fn listOnce(gpa: Allocator) !bool {
    const x = try makeList(gpa, 15);
    const y = try makeList(gpa, 10);
    const z = try makeList(gpa, 6);
    const result = tail(x, y, z).?.length();
    x.?.destroy(gpa);
    y.?.destroy(gpa);
    z.?.destroy(gpa);
    return result == 10;
}

pub fn list(gpa: Allocator, n: u32) !bool {
    return repeat(gpa, n, listOnce);
}

// ---- Mandelbrot -------------------------------------------------------------

fn mandelbrotRun(size: i32) i32 {
    var sum: i32 = 0;
    var byte_acc: i32 = 0;
    var bit_num: i32 = 0;
    const fsize: f64 = @floatFromInt(size);
    var y: i32 = 0;
    while (y < size) : (y += 1) {
        const ci = (2.0 * @as(f64, @floatFromInt(y)) / fsize) - 1.0;
        var x: i32 = 0;
        while (x < size) : (x += 1) {
            var zrzr: f64 = 0.0;
            var zi: f64 = 0.0;
            var zizi: f64 = 0.0;
            const cr = (2.0 * @as(f64, @floatFromInt(x)) / fsize) - 1.5;
            var z: i32 = 0;
            var not_done = true;
            var escape: i32 = 0;
            while (not_done and z < 50) {
                const zr = zrzr - zizi + cr;
                zi = 2.0 * zr * zi + ci;
                zrzr = zr * zr;
                zizi = zi * zi;
                if (zrzr + zizi > 4.0) {
                    not_done = false;
                    escape = 1;
                }
                z += 1;
            }
            byte_acc = (byte_acc << 1) + escape;
            bit_num += 1;
            if (bit_num == 8) {
                sum ^= byte_acc;
                byte_acc = 0;
                bit_num = 0;
            } else if (x == size - 1) {
                byte_acc <<= @intCast(8 - bit_num);
                sum ^= byte_acc;
                byte_acc = 0;
                bit_num = 0;
            }
        }
    }
    return sum;
}

pub fn mandelbrot(_: Allocator, n: u32) !bool {
    const r = mandelbrotRun(@intCast(n));
    return switch (n) {
        500 => r == 191,
        750 => r == 50,
        1 => r == 128,
        else => blk: {
            std.debug.print("No verification result for {d} found; result {d}\n", .{ n, r });
            break :blk false;
        },
    };
}

// ---- NBody ------------------------------------------------------------------

const solar_mass = 4 * std.math.pi * std.math.pi;
const days_per_year = 365.24;

const Body = struct {
    x: f64,
    y: f64,
    z: f64,
    vx: f64,
    vy: f64,
    vz: f64,
    mass: f64,

    fn init(x: f64, y: f64, z: f64, vx: f64, vy: f64, vz: f64, mass: f64) Body {
        return .{ .x = x, .y = y, .z = z, .vx = vx * days_per_year, .vy = vy * days_per_year, .vz = vz * days_per_year, .mass = mass * solar_mass };
    }
};

fn createBodies() [5]Body {
    var bodies = [5]Body{
        Body.init(0, 0, 0, 0, 0, 0, 1),
        Body.init(4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01, 1.66007664274403694e-03, 7.69901118419740425e-03, -6.90460016972063023e-05, 9.54791938424326609e-04),
        Body.init(8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01, -2.76742510726862411e-03, 4.99852801234917238e-03, 2.30417297573763929e-05, 2.85885980666130812e-04),
        Body.init(1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01, 2.96460137564761618e-03, 2.37847173959480950e-03, -2.96589568540237556e-05, 4.36624404335156298e-05),
        Body.init(1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01, 2.68067772490389322e-03, 1.62824170038242295e-03, -9.51592254519715870e-05, 5.15138902046611451e-05),
    };
    var px: f64 = 0.0;
    var py: f64 = 0.0;
    var pz: f64 = 0.0;
    for (bodies) |b| {
        px += b.vx * b.mass;
        py += b.vy * b.mass;
        pz += b.vz * b.mass;
    }
    bodies[0].vx = 0.0 - (px / solar_mass);
    bodies[0].vy = 0.0 - (py / solar_mass);
    bodies[0].vz = 0.0 - (pz / solar_mass);
    return bodies;
}

fn advance(bodies: []Body, dt: f64) void {
    for (bodies, 0..) |*ib, i| {
        for (bodies[i + 1 ..]) |*jb| {
            const dx = ib.x - jb.x;
            const dy = ib.y - jb.y;
            const dz = ib.z - jb.z;
            const d_squared = dx * dx + dy * dy + dz * dz;
            const distance = @sqrt(d_squared);
            const mag = dt / (d_squared * distance);
            ib.vx = ib.vx - (dx * jb.mass * mag);
            ib.vy = ib.vy - (dy * jb.mass * mag);
            ib.vz = ib.vz - (dz * jb.mass * mag);
            jb.vx = jb.vx + (dx * ib.mass * mag);
            jb.vy = jb.vy + (dy * ib.mass * mag);
            jb.vz = jb.vz + (dz * ib.mass * mag);
        }
    }
    for (bodies) |*b| {
        b.x = b.x + dt * b.vx;
        b.y = b.y + dt * b.vy;
        b.z = b.z + dt * b.vz;
    }
}

fn energy(bodies: []const Body) f64 {
    var e: f64 = 0.0;
    for (bodies, 0..) |ib, i| {
        e += 0.5 * ib.mass * (ib.vx * ib.vx + ib.vy * ib.vy + ib.vz * ib.vz);
        for (bodies[i + 1 ..]) |jb| {
            const dx = ib.x - jb.x;
            const dy = ib.y - jb.y;
            const dz = ib.z - jb.z;
            e -= (ib.mass * jb.mass) / @sqrt(dx * dx + dy * dy + dz * dz);
        }
    }
    return e;
}

pub fn nbody(_: Allocator, n: u32) !bool {
    var system = createBodies();
    var i: u32 = 0;
    while (i < n) : (i += 1) advance(&system, 0.01);
    const r = energy(&system);
    return switch (n) {
        250000 => r == -0.1690859889909308,
        1 => r == -0.16907495402506745,
        else => blk: {
            std.debug.print("No verification result for {d} found\n", .{n});
            break :blk false;
        },
    };
}

// ---- Permute ----------------------------------------------------------------

const Permuter = struct {
    count: i32 = 0,
    v: []i32 = &.{},

    fn permute(p: *Permuter, n: i32) void {
        p.count += 1;
        if (n != 0) {
            const n1 = n - 1;
            p.permute(n1);
            var i = n1;
            while (i >= 0) : (i -= 1) {
                p.swap(n1, i);
                p.permute(n1);
                p.swap(n1, i);
            }
        }
    }

    fn swap(p: *Permuter, i: i32, j: i32) void {
        std.mem.swap(i32, &p.v[@intCast(i)], &p.v[@intCast(j)]);
    }
};

fn permuteOnce(gpa: Allocator) !bool {
    var p = Permuter{};
    p.v = try gpa.alloc(i32, 6);
    @memset(p.v, 0);
    p.permute(6);
    gpa.free(p.v);
    return p.count == 8660;
}

pub fn permute(gpa: Allocator, n: u32) !bool {
    return repeat(gpa, n, permuteOnce);
}

// ---- Queens -----------------------------------------------------------------

const Queens = struct {
    free_maxs: []bool = &.{},
    free_rows: []bool = &.{},
    free_mins: []bool = &.{},
    queen_rows: []i32 = &.{},

    fn queens(q: *Queens, gpa: Allocator) !bool {
        q.free_rows = try gpa.alloc(bool, 8);
        @memset(q.free_rows, true);
        q.free_maxs = try gpa.alloc(bool, 16);
        @memset(q.free_maxs, true);
        q.free_mins = try gpa.alloc(bool, 16);
        @memset(q.free_mins, true);
        q.queen_rows = try gpa.alloc(i32, 8);
        @memset(q.queen_rows, -1);
        const result = q.placeQueen(0);
        gpa.free(q.free_rows);
        gpa.free(q.free_maxs);
        gpa.free(q.free_mins);
        gpa.free(q.queen_rows);
        return result;
    }

    fn placeQueen(q: *Queens, c: i32) bool {
        var r: i32 = 0;
        while (r < 8) : (r += 1) {
            if (q.getRowColumn(r, c)) {
                q.queen_rows[@intCast(r)] = c;
                q.setRowColumn(r, c, false);
                if (c == 7) return true;
                if (q.placeQueen(c + 1)) return true;
                q.setRowColumn(r, c, true);
            }
        }
        return false;
    }

    fn getRowColumn(q: *const Queens, r: i32, c: i32) bool {
        return q.free_rows[@intCast(r)] and q.free_maxs[@intCast(c + r)] and q.free_mins[@intCast(c - r + 7)];
    }

    fn setRowColumn(q: *Queens, r: i32, c: i32, v: bool) void {
        q.free_rows[@intCast(r)] = v;
        q.free_maxs[@intCast(c + r)] = v;
        q.free_mins[@intCast(c - r + 7)] = v;
    }
};

fn queensOnce(gpa: Allocator) !bool {
    var q = Queens{};
    var result = true;
    var i: u32 = 0;
    while (i < 10) : (i += 1) result = result and try q.queens(gpa);
    return result;
}

pub fn queens(gpa: Allocator, n: u32) !bool {
    return repeat(gpa, n, queensOnce);
}

// ---- Sieve ------------------------------------------------------------------

fn sieveRun(flags: []bool, size: usize) i32 {
    var prime_count: i32 = 0;
    var i: usize = 2;
    while (i <= size) : (i += 1) {
        if (flags[i - 1]) {
            prime_count += 1;
            var k = i + i;
            while (k <= size) : (k += i) flags[k - 1] = false;
        }
    }
    return prime_count;
}

fn sieveOnce(_: Allocator) !bool {
    var flags: [5000]bool = undefined;
    @memset(&flags, true);
    return sieveRun(&flags, 5000) == 669;
}

pub fn sieve(gpa: Allocator, n: u32) !bool {
    return repeat(gpa, n, sieveOnce);
}

// ---- Storage ----------------------------------------------------------------

const ArrayTree = struct {
    children: []ArrayTree = &.{},

    fn deinit(t: *ArrayTree, gpa: Allocator) void {
        for (t.children) |*c| c.deinit(gpa);
        gpa.free(t.children);
    }
};

const Storage = struct {
    count: i32 = 0,

    fn buildTreeDepth(s: *Storage, gpa: Allocator, depth: i32, random: *Random) ![]ArrayTree {
        s.count += 1;
        if (depth == 1) {
            const leaf = try gpa.alloc(ArrayTree, @intCast(@rem(random.next(), 10) + 1));
            for (leaf) |*c| c.* = .{};
            return leaf;
        }
        const arr = try gpa.alloc(ArrayTree, 4);
        for (arr) |*c| c.* = .{ .children = try s.buildTreeDepth(gpa, depth - 1, random) };
        return arr;
    }
};

fn storageOnce(gpa: Allocator) !bool {
    var random = Random{};
    var s = Storage{};
    var root = ArrayTree{ .children = try s.buildTreeDepth(gpa, 7, &random) };
    root.deinit(gpa);
    return s.count == 5461;
}

pub fn storage(gpa: Allocator, n: u32) !bool {
    return repeat(gpa, n, storageOnce);
}

// ---- Towers -----------------------------------------------------------------

const TowersDisk = struct {
    size: i32,
    next: ?*TowersDisk = null,
};

const Towers = struct {
    piles: [3]?*TowersDisk = .{ null, null, null },
    moves_done: i32 = 0,

    fn pushDisk(t: *Towers, disk: *TowersDisk, pile: usize) void {
        if (t.piles[pile]) |top| {
            if (disk.size >= top.size) @panic("Cannot put a big disk on a smaller one");
        }
        disk.next = t.piles[pile];
        t.piles[pile] = disk;
    }

    fn popDiskFrom(t: *Towers, pile: usize) *TowersDisk {
        const top = t.piles[pile] orelse @panic("Attempting to remove a disk from an empty pile");
        t.piles[pile] = top.next;
        top.next = null;
        return top;
    }

    fn moveTopDisk(t: *Towers, from: usize, to: usize) void {
        t.pushDisk(t.popDiskFrom(from), to);
        t.moves_done += 1;
    }

    fn buildTowerAt(t: *Towers, gpa: Allocator, pile: usize, disks: i32) !void {
        var i = disks;
        while (i >= 0) : (i -= 1) {
            const d = try gpa.create(TowersDisk);
            d.* = .{ .size = i };
            t.pushDisk(d, pile);
        }
    }

    fn moveDisks(t: *Towers, disks: i32, from: usize, to: usize) void {
        if (disks == 1) {
            t.moveTopDisk(from, to);
        } else {
            const other = (3 - from) - to;
            t.moveDisks(disks - 1, from, other);
            t.moveTopDisk(from, to);
            t.moveDisks(disks - 1, other, to);
        }
    }

    fn deinit(t: *Towers, gpa: Allocator) void {
        for (t.piles) |p| {
            var d = p;
            while (d) |disk| {
                d = disk.next;
                gpa.destroy(disk);
            }
        }
    }
};

fn towersOnce(gpa: Allocator) !bool {
    var t = Towers{};
    try t.buildTowerAt(gpa, 0, 13);
    t.moves_done = 0;
    t.moveDisks(13, 0, 1);
    t.deinit(gpa);
    return t.moves_done == 8191;
}

pub fn towers(gpa: Allocator, n: u32) !bool {
    return repeat(gpa, n, towersOnce);
}
