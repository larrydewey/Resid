// AWFY DeltaBlue, after the Java reference: the constraint classes are one
// struct switched on its kind, variables and constraints a pointer graph.
// Each test's graph lives in an arena freed at its end (the C++ port's
// object_tracker).
const std = @import("std");
const Allocator = std.mem.Allocator;

// Arithmetic values of the reference's strength table: smaller is stronger.
const required: i32 = -800;
const preferred: i32 = -400;
const strong_default: i32 = -200;
const default: i32 = 0;
const absolute_weakest: i32 = 10000;

fn stronger(a: i32, b: i32) bool {
    return a < b;
}
fn weaker(a: i32, b: i32) bool {
    return a > b;
}
fn weakest(a: i32, b: i32) i32 {
    return if (weaker(b, a)) b else a;
}

const Kind = enum { stay, edit, equality, scale };
const Direction = enum { none, forward, backward };

const List = std.ArrayList(*Constraint);

const Variable = struct {
    value: i32,
    constraints: List = .empty,
    determined_by: ?*Constraint = null,
    mark: i32 = 0,
    walk_strength: i32 = absolute_weakest,
    stay: bool = true,

    fn removeConstraint(v: *Variable, c: *Constraint) void {
        var j: usize = 0;
        for (v.constraints.items) |x| {
            if (x != c) {
                v.constraints.items[j] = x;
                j += 1;
            }
        }
        v.constraints.shrinkRetainingCapacity(j);
        if (v.determined_by == c) v.determined_by = null;
    }
};

const Constraint = struct {
    kind: Kind,
    strength: i32,
    v1: *Variable, // unary: the output
    v2: ?*Variable = null,
    scale: ?*Variable = null,
    offset: ?*Variable = null,
    direction: Direction = .none,
    satisfied: bool = false,

    fn unary(c: *const Constraint) bool {
        return c.kind == .stay or c.kind == .edit;
    }
    fn isInput(c: *const Constraint) bool {
        return c.kind == .edit;
    }
    fn isSatisfied(c: *const Constraint) bool {
        return if (c.unary()) c.satisfied else c.direction != .none;
    }

    fn addToGraph(c: *Constraint, a: Allocator) !void {
        try c.v1.constraints.append(a, c);
        if (c.unary()) {
            c.satisfied = false;
            return;
        }
        try c.v2.?.constraints.append(a, c);
        if (c.kind == .scale) {
            try c.scale.?.constraints.append(a, c);
            try c.offset.?.constraints.append(a, c);
        }
        c.direction = .none;
    }

    fn removeFromGraph(c: *Constraint) void {
        c.v1.removeConstraint(c);
        if (c.unary()) {
            c.satisfied = false;
            return;
        }
        c.v2.?.removeConstraint(c);
        if (c.kind == .scale) {
            c.scale.?.removeConstraint(c);
            c.offset.?.removeConstraint(c);
        }
        c.direction = .none;
    }

    fn chooseMethod(c: *Constraint, mark: i32) void {
        if (c.unary()) {
            c.satisfied = c.v1.mark != mark and stronger(c.strength, c.v1.walk_strength);
            return;
        }
        const v1 = c.v1;
        const v2 = c.v2.?;
        c.direction = .none;
        if (v1.mark == mark) {
            if (v2.mark != mark and stronger(c.strength, v2.walk_strength)) c.direction = .forward;
        } else if (v2.mark == mark) {
            if (v1.mark != mark and stronger(c.strength, v1.walk_strength)) c.direction = .backward;
        } else if (weaker(v1.walk_strength, v2.walk_strength)) {
            if (stronger(c.strength, v1.walk_strength)) c.direction = .backward;
        } else {
            if (stronger(c.strength, v2.walk_strength)) c.direction = .forward;
        }
    }

    fn execute(c: *Constraint) void {
        switch (c.kind) {
            .equality => if (c.direction == .forward) {
                c.v2.?.value = c.v1.value;
            } else {
                c.v1.value = c.v2.?.value;
            },
            .scale => if (c.direction == .forward) {
                c.v2.?.value = c.v1.value * c.scale.?.value + c.offset.?.value;
            } else {
                c.v1.value = @divTrunc(c.v2.?.value - c.offset.?.value, c.scale.?.value);
            },
            else => {},
        }
    }

    fn input(c: *const Constraint) *Variable {
        return if (c.direction == .forward) c.v1 else c.v2.?;
    }

    fn output(c: *const Constraint) *Variable {
        return if (c.unary() or c.direction != .forward) c.v1 else c.v2.?;
    }

    // The reference's inputsHasOne tests only v1/v2 (BinaryConstraint), even for scale.
    fn inputsKnown(c: *const Constraint, mark: i32) bool {
        if (c.unary()) return true;
        const v = c.input();
        return v.mark == mark or v.stay or v.determined_by == null;
    }

    fn markInputs(c: *Constraint, mark: i32) void {
        if (c.unary()) return;
        c.input().mark = mark;
        if (c.kind == .scale) {
            c.scale.?.mark = mark;
            c.offset.?.mark = mark;
        }
    }

    fn markUnsatisfied(c: *Constraint) void {
        if (c.unary()) c.satisfied = false else c.direction = .none;
    }

    fn recalculate(c: *Constraint) void {
        if (c.unary()) {
            c.v1.walk_strength = c.strength;
            c.v1.stay = !c.isInput();
            if (c.v1.stay) c.execute();
            return;
        }
        const in = c.input();
        const out = c.output();
        out.walk_strength = weakest(c.strength, in.walk_strength);
        out.stay = if (c.kind == .scale) in.stay and c.scale.?.stay and c.offset.?.stay else in.stay;
        if (out.stay) c.execute();
    }
};

// A FIFO over an ArrayList (the reference's Vector with removeFirst).
fn Queue(comptime T: type) type {
    return struct {
        items: std.ArrayList(T) = .empty,
        head: usize = 0,

        fn push(q: *@This(), a: Allocator, x: T) !void {
            try q.items.append(a, x);
        }
        fn pop(q: *@This()) ?T {
            if (q.head == q.items.items.len) return null;
            q.head += 1;
            return q.items.items[q.head - 1];
        }
    };
}

const Planner = struct {
    a: Allocator,
    current_mark: i32 = 1,

    fn newMark(p: *Planner) i32 {
        p.current_mark += 1;
        return p.current_mark;
    }

    fn newVariable(p: *Planner, value: i32) !*Variable {
        const v = try p.a.create(Variable);
        v.* = .{ .value = value };
        return v;
    }

    fn newConstraint(p: *Planner, c: Constraint) !*Constraint {
        const n = try p.a.create(Constraint);
        n.* = c;
        try n.addToGraph(p.a);
        try p.incrementalAdd(n);
        return n;
    }

    fn satisfy(p: *Planner, c: *Constraint, mark: i32) !?*Constraint {
        c.chooseMethod(mark);
        if (!c.isSatisfied()) {
            if (c.strength == required) @panic("Could not satisfy a required constraint");
            return null;
        }
        c.markInputs(mark);
        const out = c.output();
        const overridden = out.determined_by;
        if (overridden) |o| o.markUnsatisfied();
        out.determined_by = c;
        if (!try p.addPropagate(c, mark)) @panic("Cycle encountered");
        out.mark = mark;
        return overridden;
    }

    fn incrementalAdd(p: *Planner, c: *Constraint) anyerror!void {
        const mark = p.newMark();
        var overridden = try p.satisfy(c, mark);
        while (overridden) |o| overridden = try p.satisfy(o, mark);
    }

    fn incrementalRemove(p: *Planner, c: *Constraint) !void {
        const out = c.output();
        c.markUnsatisfied();
        c.removeFromGraph();
        const unsatisfied = try p.removePropagateFrom(out);
        for (unsatisfied.items) |u| try p.incrementalAdd(u);
    }

    fn destroyConstraint(p: *Planner, c: *Constraint) !void {
        if (c.isSatisfied()) try p.incrementalRemove(c);
        c.removeFromGraph();
    }

    fn addConstraintsConsumingTo(p: *Planner, v: *Variable, coll: *Queue(*Constraint)) !void {
        const determining = v.determined_by;
        for (v.constraints.items) |c| {
            if (c != determining and c.isSatisfied()) try coll.push(p.a, c);
        }
    }

    fn addPropagate(p: *Planner, c: *Constraint, mark: i32) !bool {
        var todo = Queue(*Constraint){};
        try todo.push(p.a, c);
        while (todo.pop()) |d| {
            if (d.output().mark == mark) {
                try p.incrementalRemove(c);
                return false;
            }
            d.recalculate();
            try p.addConstraintsConsumingTo(d.output(), &todo);
        }
        return true;
    }

    fn removePropagateFrom(p: *Planner, out: *Variable) !List {
        var unsatisfied: List = .empty;
        out.determined_by = null;
        out.walk_strength = absolute_weakest;
        out.stay = true;
        var todo = Queue(*Variable){};
        try todo.push(p.a, out);
        while (todo.pop()) |v| {
            for (v.constraints.items) |c| {
                if (!c.isSatisfied()) try unsatisfied.append(p.a, c);
            }
            const determining = v.determined_by;
            for (v.constraints.items) |c| {
                if (c != determining and c.isSatisfied()) {
                    c.recalculate();
                    try todo.push(p.a, c.output());
                }
            }
        }
        // The reference sorts strongest first with a Vector.sort that
        // implements no swap: it only ever sees lists already in that order.
        return unsatisfied;
    }

    fn makePlan(p: *Planner, sources: Queue(*Constraint)) !List {
        const mark = p.newMark();
        var plan = try List.initCapacity(p.a, 15);
        var todo = sources;
        while (todo.pop()) |c| {
            if (c.output().mark != mark and c.inputsKnown(mark)) {
                try plan.append(p.a, c);
                c.output().mark = mark;
                try p.addConstraintsConsumingTo(c.output(), &todo);
            }
        }
        return plan;
    }

    fn extractPlanFromConstraints(p: *Planner, constraints: []const *Constraint) !List {
        var sources = Queue(*Constraint){};
        for (constraints) |c| {
            if (c.isInput() and c.isSatisfied()) try sources.push(p.a, c);
        }
        return p.makePlan(sources);
    }

    fn change(p: *Planner, v: *Variable, new_value: i32) !void {
        const edit = try p.newConstraint(.{ .kind = .edit, .strength = preferred, .v1 = v });
        const plan = try p.extractPlanFromConstraints(&.{edit});
        var i: u32 = 0;
        while (i < 10) : (i += 1) {
            v.value = new_value;
            executePlan(plan);
        }
        try p.destroyConstraint(edit);
    }
};

fn executePlan(plan: List) void {
    for (plan.items) |c| c.execute();
}

fn chainTest(gpa: Allocator, n: u32) !void {
    var arena = std.heap.ArenaAllocator.init(gpa);
    defer arena.deinit();
    var p = Planner{ .a = arena.allocator() };
    const vars = try p.a.alloc(*Variable, n + 1);
    for (vars) |*v| v.* = try p.newVariable(0);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        _ = try p.newConstraint(.{ .kind = .equality, .strength = required, .v1 = vars[i], .v2 = vars[i + 1] });
    }
    _ = try p.newConstraint(.{ .kind = .stay, .strength = strong_default, .v1 = vars[n] });
    const edit = try p.newConstraint(.{ .kind = .edit, .strength = preferred, .v1 = vars[0] });
    const plan = try p.extractPlanFromConstraints(&.{edit});
    var k: i32 = 0;
    while (k < 100) : (k += 1) {
        vars[0].value = k;
        executePlan(plan);
        if (vars[n].value != k) @panic("Chain test failed!");
    }
    try p.destroyConstraint(edit);
}

fn projectionTest(gpa: Allocator, n: u32) !void {
    var arena = std.heap.ArenaAllocator.init(gpa);
    defer arena.deinit();
    var p = Planner{ .a = arena.allocator() };
    var dests: std.ArrayList(*Variable) = .empty;
    const scale = try p.newVariable(10);
    const offset = try p.newVariable(1000);
    var src: *Variable = undefined;
    var dst: *Variable = undefined;
    var i: i32 = 1;
    while (i <= n) : (i += 1) {
        src = try p.newVariable(i);
        dst = try p.newVariable(i);
        try dests.append(p.a, dst);
        _ = try p.newConstraint(.{ .kind = .stay, .strength = default, .v1 = src });
        _ = try p.newConstraint(.{ .kind = .scale, .strength = required, .v1 = src, .v2 = dst, .scale = scale, .offset = offset });
    }
    try p.change(src, 17);
    if (dst.value != 1170) @panic("Projection test 1 failed!");
    try p.change(dst, 1050);
    if (src.value != 5) @panic("Projection test 2 failed!");
    try p.change(scale, 5);
    for (dests.items[0 .. n - 1], 0..) |d, j| {
        if (d.value != @as(i32, @intCast(j + 1)) * 5 + 1000) @panic("Projection test 3 failed!");
    }
    try p.change(offset, 2000);
    for (dests.items[0 .. n - 1], 0..) |d, j| {
        if (d.value != @as(i32, @intCast(j + 1)) * 5 + 2000) @panic("Projection test 4 failed!");
    }
}

pub fn inner(gpa: Allocator, n: u32) !bool {
    try chainTest(gpa, n);
    try projectionTest(gpa, n);
    return true;
}
