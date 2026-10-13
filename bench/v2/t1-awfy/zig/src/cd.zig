// AWFY CD (collision detection), after the Java reference: a generic
// red-black tree over value keys, vectors and call signs as plain values.
// Memory is the C++ port's: trees free their nodes, the voxel map its
// vectors, each frame its motions and collisions.
const std = @import("std");
const Allocator = std.mem.Allocator;

const min_x = 0.0;
const min_y = 0.0;
const max_x = 1000.0;
const max_y = 1000.0;
const min_z = 0.0;
const max_z = 10.0;
const proximity_radius = 1.0;
const good_voxel_size = proximity_radius * 2.0;

const Vector2D = struct {
    x: f64,
    y: f64,

    fn plus(a: Vector2D, b: Vector2D) Vector2D {
        return .{ .x = a.x + b.x, .y = a.y + b.y };
    }
    fn minus(a: Vector2D, b: Vector2D) Vector2D {
        return .{ .x = a.x - b.x, .y = a.y - b.y };
    }
    fn compare(a: Vector2D, b: Vector2D) i32 {
        const r = compareNumbers(a.x, b.x);
        return if (r != 0) r else compareNumbers(a.y, b.y);
    }
};

fn compareNumbers(a: f64, b: f64) i32 {
    if (a == b) return 0;
    if (a < b) return -1;
    if (a > b) return 1;
    if (!std.math.isNan(a)) return 1;
    return -1;
}

const Vector3D = struct {
    x: f64,
    y: f64,
    z: f64,

    fn plus(a: Vector3D, b: Vector3D) Vector3D {
        return .{ .x = a.x + b.x, .y = a.y + b.y, .z = a.z + b.z };
    }
    fn minus(a: Vector3D, b: Vector3D) Vector3D {
        return .{ .x = a.x - b.x, .y = a.y - b.y, .z = a.z - b.z };
    }
    fn dot(a: Vector3D, b: Vector3D) f64 {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }
    fn squaredMagnitude(a: Vector3D) f64 {
        return a.dot(a);
    }
    fn magnitude(a: Vector3D) f64 {
        return @sqrt(a.squaredMagnitude());
    }
    fn times(a: Vector3D, s: f64) Vector3D {
        return .{ .x = a.x * s, .y = a.y * s, .z = a.z * s };
    }
};

const CallSign = struct {
    value: i32,

    fn compare(a: CallSign, b: CallSign) i32 {
        if (a.value == b.value) return 0;
        return if (a.value < b.value) -1 else 1;
    }
};

// ---- Red-black tree ---------------------------------------------------------

fn RedBlackTree(comptime K: type, comptime V: type) type {
    return struct {
        const Self = @This();
        const Node = struct {
            key: K,
            value: V,
            left: ?*Node = null,
            right: ?*Node = null,
            parent: ?*Node = null,
            red: bool = true,

            fn successor(n: *Node) ?*Node {
                if (n.right) |r| return treeMinimum(r);
                var x = n;
                var y = n.parent;
                while (y) |yy| {
                    if (x != yy.right) break;
                    x = yy;
                    y = yy.parent;
                }
                return y;
            }
        };

        gpa: Allocator,
        root: ?*Node = null,

        fn treeMinimum(n: *Node) *Node {
            var x = n;
            while (x.left) |l| x = l;
            return x;
        }

        fn isRed(n: ?*Node) bool {
            return if (n) |x| x.red else false;
        }

        fn deinitNode(t: *Self, n: ?*Node) void {
            const x = n orelse return;
            t.deinitNode(x.left);
            t.deinitNode(x.right);
            t.gpa.destroy(x);
        }

        fn deinit(t: *Self) void {
            t.deinitNode(t.root);
            t.root = null;
        }

        /// Returns the previous value, if there was one.
        fn put(t: *Self, key: K, value: V) !?V {
            var y: ?*Node = null;
            var cur = t.root;
            while (cur) |x| {
                y = x;
                const c = key.compare(x.key);
                if (c < 0) {
                    cur = x.left;
                } else if (c > 0) {
                    cur = x.right;
                } else {
                    const old = x.value;
                    x.value = value;
                    return old;
                }
            }
            const z = try t.gpa.create(Node);
            z.* = .{ .key = key, .value = value, .parent = y };
            if (y) |yy| {
                if (key.compare(yy.key) < 0) yy.left = z else yy.right = z;
            } else {
                t.root = z;
            }
            var x = z;
            while (x != t.root.? and x.parent.?.red) {
                const p = x.parent.?;
                const g = p.parent.?;
                if (p == g.left) {
                    const u = g.right;
                    if (isRed(u)) {
                        p.red = false;
                        u.?.red = false;
                        g.red = true;
                        x = g;
                    } else {
                        if (x == p.right) {
                            x = p;
                            t.leftRotate(x);
                        }
                        x.parent.?.red = false;
                        x.parent.?.parent.?.red = true;
                        t.rightRotate(x.parent.?.parent.?);
                    }
                } else {
                    const u = g.left;
                    if (isRed(u)) {
                        p.red = false;
                        u.?.red = false;
                        g.red = true;
                        x = g;
                    } else {
                        if (x == p.left) {
                            x = p;
                            t.rightRotate(x);
                        }
                        x.parent.?.red = false;
                        x.parent.?.parent.?.red = true;
                        t.leftRotate(x.parent.?.parent.?);
                    }
                }
            }
            t.root.?.red = false;
            return null;
        }

        fn findNode(t: *const Self, key: K) ?*Node {
            var cur = t.root;
            while (cur) |x| {
                const c = key.compare(x.key);
                if (c == 0) return x;
                cur = if (c < 0) x.left else x.right;
            }
            return null;
        }

        fn get(t: *const Self, key: K) ?V {
            return if (t.findNode(key)) |n| n.value else null;
        }

        fn remove(t: *Self, key: K) void {
            const z = t.findNode(key) orelse return;
            const y = if (z.left == null or z.right == null) z else z.successor().?;
            const x = if (y.left != null) y.left else y.right;
            const x_parent = y.parent;
            if (x) |xx| xx.parent = y.parent;
            if (y.parent) |yp| {
                if (y == yp.left) yp.left = x else yp.right = x;
            } else {
                t.root = x;
            }
            if (y != z) {
                if (!y.red) t.removeFixup(x, x_parent);
                y.parent = z.parent;
                y.red = z.red;
                y.left = z.left;
                y.right = z.right;
                if (z.left) |l| l.parent = y;
                if (z.right) |r| r.parent = y;
                if (z.parent) |zp| {
                    if (zp.left == z) zp.left = y else zp.right = y;
                } else {
                    t.root = y;
                }
            } else if (!y.red) {
                t.removeFixup(x, x_parent);
            }
            t.gpa.destroy(z);
        }

        fn leftRotate(t: *Self, x: *Node) void {
            const y = x.right.?;
            x.right = y.left;
            if (y.left) |l| l.parent = x;
            y.parent = x.parent;
            if (x.parent) |xp| {
                if (x == xp.left) xp.left = y else xp.right = y;
            } else {
                t.root = y;
            }
            y.left = x;
            x.parent = y;
        }

        fn rightRotate(t: *Self, y: *Node) void {
            const x = y.left.?;
            y.left = x.right;
            if (x.right) |r| r.parent = y;
            x.parent = y.parent;
            if (y.parent) |yp| {
                if (y == yp.left) yp.left = x else yp.right = x;
            } else {
                t.root = x;
            }
            x.right = y;
            y.parent = x;
        }

        fn removeFixup(t: *Self, x0: ?*Node, xp0: ?*Node) void {
            var x = x0;
            var x_parent = xp0;
            while (x != t.root and !isRed(x)) {
                const xp = x_parent.?;
                if (x == xp.left) {
                    var w = xp.right.?;
                    if (w.red) {
                        w.red = false;
                        xp.red = true;
                        t.leftRotate(xp);
                        w = xp.right.?;
                    }
                    if (!isRed(w.left) and !isRed(w.right)) {
                        w.red = true;
                        x = xp;
                        x_parent = xp.parent;
                    } else {
                        if (!isRed(w.right)) {
                            w.left.?.red = false;
                            w.red = true;
                            t.rightRotate(w);
                            w = xp.right.?;
                        }
                        w.red = xp.red;
                        xp.red = false;
                        if (w.right) |r| r.red = false;
                        t.leftRotate(xp);
                        x = t.root;
                        x_parent = x.?.parent;
                    }
                } else {
                    var w = xp.left.?;
                    if (w.red) {
                        w.red = false;
                        xp.red = true;
                        t.rightRotate(xp);
                        w = xp.left.?;
                    }
                    if (!isRed(w.right) and !isRed(w.left)) {
                        w.red = true;
                        x = xp;
                        x_parent = xp.parent;
                    } else {
                        if (!isRed(w.left)) {
                            w.right.?.red = false;
                            w.red = true;
                            t.leftRotate(w);
                            w = xp.left.?;
                        }
                        w.red = xp.red;
                        xp.red = false;
                        if (w.left) |l| l.red = false;
                        t.rightRotate(xp);
                        x = t.root;
                        x_parent = x.?.parent;
                    }
                }
            }
            if (x) |xx| xx.red = false;
        }

        const Iterator = struct {
            cur: ?*Node,
            fn next(it: *Iterator) ?*Node {
                const n = it.cur orelse return null;
                it.cur = n.successor();
                return n;
            }
        };

        fn iterator(t: *const Self) Iterator {
            return .{ .cur = if (t.root) |r| treeMinimum(r) else null };
        }
    };
}

// ---- Collision detection ----------------------------------------------------

const Aircraft = struct { callsign: CallSign, position: Vector3D };
const Motion = struct { callsign: CallSign, pos_one: Vector3D, pos_two: Vector3D };
const Collision = struct { a: CallSign, b: CallSign, position: Vector3D };

fn delta(m: *const Motion) Vector3D {
    return m.pos_two.minus(m.pos_one);
}

fn findIntersection(m: *const Motion, other: *const Motion) ?Vector3D {
    const init1 = m.pos_one;
    const init2 = other.pos_one;
    const vec1 = delta(m);
    const vec2 = delta(other);
    const radius = proximity_radius;
    const a = vec2.minus(vec1).squaredMagnitude();
    if (a != 0.0) {
        const b = 2.0 * init1.minus(init2).dot(vec1.minus(vec2));
        const c = -radius * radius + init2.minus(init1).squaredMagnitude();
        const discr = b * b - 4.0 * a * c;
        if (discr < 0.0) return null;
        const v1 = (-b - @sqrt(discr)) / (2.0 * a);
        const v2 = (-b + @sqrt(discr)) / (2.0 * a);
        if (v1 <= v2 and ((v1 <= 1.0 and 1.0 <= v2) or (v1 <= 0.0 and 0.0 <= v2) or (0.0 <= v1 and v2 <= 1.0))) {
            const v = if (v1 <= 0.0) 0.0 else v1;
            const result1 = init1.plus(vec1.times(v));
            const result2 = init2.plus(vec2.times(v));
            const result = result1.plus(result2).times(0.5);
            if (result.x >= min_x and result.x <= max_x and result.y >= min_y and result.y <= max_y and
                result.z >= min_z and result.z <= max_z) return result;
        }
        return null;
    }
    if (init2.minus(init1).magnitude() <= radius) return init1.plus(init2).times(0.5);
    return null;
}

const MotionList = std.ArrayList(*const Motion);
const VoxelMap = RedBlackTree(Vector2D, *MotionList);

fn isInVoxel(voxel: Vector2D, m: *const Motion) bool {
    if (voxel.x > max_x or voxel.x < min_x or voxel.y > max_y or voxel.y < min_y) return false;
    const init = m.pos_one;
    const fin = m.pos_two;
    const v_s = good_voxel_size;
    const r = proximity_radius / 2.0;
    const v_x = voxel.x;
    const x0 = init.x;
    const xv = fin.x - init.x;
    const v_y = voxel.y;
    const y0 = init.y;
    const yv = fin.y - init.y;
    var low_x = (v_x - r - x0) / xv;
    var high_x = (v_x + v_s + r - x0) / xv;
    if (xv < 0.0) std.mem.swap(f64, &low_x, &high_x);
    var low_y = (v_y - r - y0) / yv;
    var high_y = (v_y + v_s + r - y0) / yv;
    if (yv < 0.0) std.mem.swap(f64, &low_y, &high_y);
    return ((xv == 0.0 and v_x <= x0 + r and x0 - r <= v_x + v_s) or
        (low_x <= 1.0 and 1.0 <= high_x) or (low_x <= 0.0 and 0.0 <= high_x) or
        (0.0 <= low_x and high_x <= 1.0)) and
        ((yv == 0.0 and v_y <= y0 + r and y0 - r <= v_y + v_s) or
            ((low_y <= 1.0 and 1.0 <= high_y) or (low_y <= 0.0 and 0.0 <= high_y) or
                (0.0 <= low_y and high_y <= 1.0))) and
        (xv == 0.0 or yv == 0.0 or
            (low_y <= high_x and high_x <= high_y) or
            (low_y <= low_x and low_x <= high_y) or
            (low_x <= low_y and high_y <= high_x));
}

const horizontal = Vector2D{ .x = good_voxel_size, .y = 0.0 };
const vertical = Vector2D{ .x = 0.0, .y = good_voxel_size };

fn putIntoMap(gpa: Allocator, vm: *VoxelMap, voxel: Vector2D, m: *const Motion) !void {
    const array = vm.get(voxel) orelse blk: {
        const a = try gpa.create(MotionList);
        a.* = .empty;
        _ = try vm.put(voxel, a);
        break :blk a;
    };
    try array.append(gpa, m);
}

fn recurse(gpa: Allocator, vm: *VoxelMap, seen: *RedBlackTree(Vector2D, bool), next_voxel: Vector2D, m: *const Motion) !void {
    if (!isInVoxel(next_voxel, m)) return;
    if ((try seen.put(next_voxel, true)) orelse false) return;
    try putIntoMap(gpa, vm, next_voxel, m);
    try recurse(gpa, vm, seen, next_voxel.minus(horizontal), m);
    try recurse(gpa, vm, seen, next_voxel.plus(horizontal), m);
    try recurse(gpa, vm, seen, next_voxel.minus(vertical), m);
    try recurse(gpa, vm, seen, next_voxel.plus(vertical), m);
    try recurse(gpa, vm, seen, next_voxel.minus(horizontal).minus(vertical), m);
    try recurse(gpa, vm, seen, next_voxel.minus(horizontal).plus(vertical), m);
    try recurse(gpa, vm, seen, next_voxel.plus(horizontal).minus(vertical), m);
    try recurse(gpa, vm, seen, next_voxel.plus(horizontal).plus(vertical), m);
}

fn voxelHash(position: Vector3D) Vector2D {
    const x_div: i32 = @intFromFloat(position.x / good_voxel_size);
    const y_div: i32 = @intFromFloat(position.y / good_voxel_size);
    var x = good_voxel_size * @as(f64, @floatFromInt(x_div));
    var y = good_voxel_size * @as(f64, @floatFromInt(y_div));
    if (position.x < 0) x -= good_voxel_size;
    if (position.y < 0) y -= good_voxel_size;
    return .{ .x = x, .y = y };
}

const CollisionDetector = struct {
    gpa: Allocator,
    state: RedBlackTree(CallSign, Vector3D),

    /// Returns the frame's collisions; the caller frees them.
    fn handleNewFrame(d: *CollisionDetector, frame: []const Aircraft) !std.ArrayList(Collision) {
        const gpa = d.gpa;
        const motions = try gpa.alloc(Motion, frame.len);
        defer gpa.free(motions);
        var seen = RedBlackTree(CallSign, bool){ .gpa = gpa };
        defer seen.deinit();
        for (frame, motions) |a, *m| {
            const old_position = (try d.state.put(a.callsign, a.position)) orelse a.position;
            _ = try seen.put(a.callsign, true);
            m.* = .{ .callsign = a.callsign, .pos_one = old_position, .pos_two = a.position };
        }
        var to_remove: std.ArrayList(CallSign) = .empty;
        defer to_remove.deinit(gpa);
        var it = d.state.iterator();
        while (it.next()) |n| {
            if (!(seen.get(n.key) orelse false)) try to_remove.append(gpa, n.key);
        }
        for (to_remove.items) |k| d.state.remove(k);

        var vm = VoxelMap{ .gpa = gpa };
        defer {
            var vit = vm.iterator();
            while (vit.next()) |n| {
                n.value.deinit(gpa);
                gpa.destroy(n.value);
            }
            vm.deinit();
        }
        for (motions) |*m| {
            var voxel_seen = RedBlackTree(Vector2D, bool){ .gpa = gpa };
            defer voxel_seen.deinit();
            try recurse(gpa, &vm, &voxel_seen, voxelHash(m.pos_one), m);
        }
        var collisions: std.ArrayList(Collision) = .empty;
        var vit = vm.iterator();
        while (vit.next()) |n| {
            const reduced = n.value.items;
            if (reduced.len <= 1) continue;
            for (reduced, 0..) |m1, i| {
                for (reduced[i + 1 ..]) |m2| {
                    if (findIntersection(m1, m2)) |c| {
                        try collisions.append(gpa, .{ .a = m1.callsign, .b = m2.callsign, .position = c });
                    }
                }
            }
        }
        return collisions;
    }
};

fn simulate(gpa: Allocator, num_aircraft: u32, time: f64) ![]Aircraft {
    const frame = try gpa.alloc(Aircraft, num_aircraft);
    var i: u32 = 0;
    while (i < num_aircraft) : (i += 2) {
        const fi: f64 = @floatFromInt(i);
        frame[i] = .{ .callsign = .{ .value = @intCast(i) }, .position = .{ .x = time, .y = @cos(time) * 2 + fi * 3, .z = 10 } };
        frame[i + 1] = .{ .callsign = .{ .value = @intCast(i + 1) }, .position = .{ .x = time, .y = @sin(time) * 2 + fi * 3, .z = 10 } };
    }
    return frame;
}

fn benchmark(gpa: Allocator, num_aircrafts: u32) !usize {
    var detector = CollisionDetector{ .gpa = gpa, .state = .{ .gpa = gpa } };
    defer detector.state.deinit();
    var actual: usize = 0;
    var i: u32 = 0;
    while (i < 200) : (i += 1) {
        const time = @as(f64, @floatFromInt(i)) / 10.0;
        const frame = try simulate(gpa, num_aircrafts, time);
        defer gpa.free(frame);
        var collisions = try detector.handleNewFrame(frame);
        actual += collisions.items.len;
        collisions.deinit(gpa);
    }
    return actual;
}

pub fn inner(gpa: Allocator, n: u32) !bool {
    const actual = try benchmark(gpa, n);
    return switch (n) {
        1000, 500 => actual == 14484,
        250 => actual == 10830,
        200 => actual == 8655,
        100 => actual == 4305,
        10 => actual == 390,
        2 => actual == 42,
        else => blk: {
            std.debug.print("No verification result for {d} found; result {d}\n", .{ n, actual });
            break :blk false;
        },
    };
}
