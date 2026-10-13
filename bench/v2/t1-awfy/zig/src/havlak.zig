// AWFY Havlak, after the Java reference: loop recognition on a synthetic
// control-flow graph, as a pointer graph. Memory is the C++ port's: the
// graph owns its blocks, the loop structure its loops, the finder its
// union-find nodes. The block-number dictionary is a hash map keyed by
// block, as the reference's IdentityDictionary.
const std = @import("std");
const Allocator = std.mem.Allocator;

const unvisited: i32 = std.math.maxInt(i32);
const max_non_back_preds = 32 * 1024;

const BbClass = enum { top, non_header, reducible, self, irreducible, dead };

const BasicBlock = struct {
    in_edges: std.ArrayList(*BasicBlock) = .empty,
    out_edges: std.ArrayList(*BasicBlock) = .empty,
    name: usize,
};

const Cfg = struct {
    gpa: Allocator,
    basic_block_map: std.ArrayList(?*BasicBlock) = .empty,
    start_node: ?*BasicBlock = null,
    edge_list: std.ArrayList([2]*BasicBlock) = .empty,

    fn deinit(c: *Cfg) void {
        for (c.basic_block_map.items) |b| {
            const bb = b orelse continue;
            bb.in_edges.deinit(c.gpa);
            bb.out_edges.deinit(c.gpa);
            c.gpa.destroy(bb);
        }
        c.basic_block_map.deinit(c.gpa);
        c.edge_list.deinit(c.gpa);
    }

    fn createNode(c: *Cfg, name: usize) !*BasicBlock {
        while (c.basic_block_map.items.len <= name) try c.basic_block_map.append(c.gpa, null);
        const node = c.basic_block_map.items[name] orelse blk: {
            const n = try c.gpa.create(BasicBlock);
            n.* = .{ .name = name };
            try n.in_edges.ensureTotalCapacity(c.gpa, 2);
            try n.out_edges.ensureTotalCapacity(c.gpa, 2);
            c.basic_block_map.items[name] = n;
            break :blk n;
        };
        if (c.basic_block_map.items.len == 1) c.start_node = node;
        return node;
    }

    fn addEdge(c: *Cfg, from_name: usize, to_name: usize) !void {
        const from = try c.createNode(from_name);
        const to = try c.createNode(to_name);
        try from.out_edges.append(c.gpa, to);
        try to.in_edges.append(c.gpa, from);
        try c.edge_list.append(c.gpa, .{ from, to });
    }
};

const SimpleLoop = struct {
    basic_blocks: std.ArrayList(*BasicBlock) = .empty,
    children: std.ArrayList(*SimpleLoop) = .empty,
    parent: ?*SimpleLoop = null,
    header: ?*BasicBlock,
    is_reducible: bool,
    is_root: bool = false,
    nesting_level: i32 = 0,
    counter: i32 = 0,
    depth_level: i32 = 0,

    fn addNode(l: *SimpleLoop, gpa: Allocator, bb: *BasicBlock) !void {
        for (l.basic_blocks.items) |b| if (b == bb) return;
        try l.basic_blocks.append(gpa, bb);
    }

    fn setParent(l: *SimpleLoop, gpa: Allocator, p: *SimpleLoop) !void {
        l.parent = p;
        for (p.children.items) |c| if (c == l) return;
        try p.children.append(gpa, l);
    }

    fn setNestingLevel(l: *SimpleLoop, level: i32) void {
        l.nesting_level = level;
        if (level == 0) l.is_root = true;
    }
};

const Lsg = struct {
    gpa: Allocator,
    root: *SimpleLoop,
    loops: std.ArrayList(*SimpleLoop) = .empty,
    loop_counter: i32 = 0,

    fn init(gpa: Allocator) !Lsg {
        var g = Lsg{ .gpa = gpa, .root = undefined };
        g.root = try g.newLoop(null, true);
        g.root.setNestingLevel(0);
        return g;
    }

    fn deinit(g: *Lsg) void {
        for (g.loops.items) |l| {
            l.basic_blocks.deinit(g.gpa);
            l.children.deinit(g.gpa);
            g.gpa.destroy(l);
        }
        g.loops.deinit(g.gpa);
    }

    fn newLoop(g: *Lsg, bb: ?*BasicBlock, is_reducible: bool) !*SimpleLoop {
        const l = try g.gpa.create(SimpleLoop);
        l.* = .{ .header = bb, .is_reducible = is_reducible, .counter = g.loop_counter };
        if (bb) |b| try l.basic_blocks.append(g.gpa, b);
        g.loop_counter += 1;
        try g.loops.append(g.gpa, l);
        return l;
    }

    fn calculateNestingLevel(g: *Lsg) !void {
        for (g.loops.items) |l| {
            if (!l.is_root and l.parent == null) try l.setParent(g.gpa, g.root);
        }
        calculateNestingLevelRec(g.root, 0);
    }

    fn calculateNestingLevelRec(l: *SimpleLoop, depth: i32) void {
        l.depth_level = depth;
        for (l.children.items) |c| {
            calculateNestingLevelRec(c, depth + 1);
            l.setNestingLevel(@max(l.nesting_level, 1 + c.nesting_level));
        }
    }
};

const UnionFindNode = struct {
    parent: *UnionFindNode = undefined,
    bb: ?*BasicBlock = null,
    loop: ?*SimpleLoop = null,
    dfs_number: usize = 0,

    fn initNode(n: *UnionFindNode, bb: *BasicBlock, dfs_number: usize) void {
        n.* = .{ .parent = n, .bb = bb, .dfs_number = dfs_number };
    }

    fn findSet(n: *UnionFindNode, gpa: Allocator) !*UnionFindNode {
        var node_list: std.ArrayList(*UnionFindNode) = .empty;
        defer node_list.deinit(gpa);
        var node = n;
        while (node != node.parent) {
            if (node.parent != node.parent.parent) try node_list.append(gpa, node);
            node = node.parent;
        }
        // The reference unions each with the starting node's parent.
        for (node_list.items) |it| it.parent = n.parent;
        return node;
    }
};

const IntSet = std.ArrayList(usize);

fn addToSet(gpa: Allocator, s: *IntSet, v: usize) !void {
    for (s.items) |x| if (x == v) return;
    try s.append(gpa, v);
}

const Finder = struct {
    gpa: Allocator,
    cfg: *const Cfg,
    lsg: *Lsg,
    non_back_preds: []IntSet = &.{},
    back_preds: []IntSet = &.{},
    number: std.AutoHashMapUnmanaged(*BasicBlock, i32) = .empty,
    header: []usize = &.{},
    typ: []BbClass = &.{},
    last: []usize = &.{},
    nodes: []UnionFindNode = &.{},

    fn deinit(f: *Finder) void {
        for (f.non_back_preds) |*s| s.deinit(f.gpa);
        for (f.back_preds) |*s| s.deinit(f.gpa);
        f.gpa.free(f.non_back_preds);
        f.gpa.free(f.back_preds);
        f.number.deinit(f.gpa);
        f.gpa.free(f.header);
        f.gpa.free(f.typ);
        f.gpa.free(f.last);
        f.gpa.free(f.nodes);
    }

    fn isAncestor(f: *const Finder, w: usize, v: usize) bool {
        return w <= v and v <= f.last[w];
    }

    fn doDFS(f: *Finder, current_node: *BasicBlock, current: usize) !usize {
        f.nodes[current].initNode(current_node, current);
        try f.number.put(f.gpa, current_node, @intCast(current));
        var last_id = current;
        for (current_node.out_edges.items) |target| {
            if (f.number.get(target).? == unvisited) last_id = try f.doDFS(target, last_id + 1);
        }
        f.last[current] = last_id;
        return last_id;
    }

    fn findLoops(f: *Finder) !void {
        const start = f.cfg.start_node orelse return;
        const gpa = f.gpa;
        const size = f.cfg.basic_block_map.items.len;
        f.non_back_preds = try gpa.alloc(IntSet, size);
        f.back_preds = try gpa.alloc(IntSet, size);
        for (f.non_back_preds, f.back_preds) |*a, *b| {
            a.* = .empty;
            b.* = .empty;
        }
        f.header = try gpa.alloc(usize, size);
        f.typ = try gpa.alloc(BbClass, size);
        f.last = try gpa.alloc(usize, size);
        f.nodes = try gpa.alloc(UnionFindNode, size);
        for (f.nodes) |*n| n.* = .{};
        for (f.cfg.basic_block_map.items) |b| try f.number.put(gpa, b.?, unvisited);
        _ = try f.doDFS(start, 0);

        for (0..size) |w| {
            f.header[w] = 0;
            f.typ[w] = .non_header;
            const node_w = f.nodes[w].bb orelse {
                f.typ[w] = .dead;
                continue;
            };
            for (node_w.in_edges.items) |node_v| {
                const v = f.number.get(node_v).?;
                if (v != unvisited) {
                    const vu: usize = @intCast(v);
                    if (f.isAncestor(w, vu)) {
                        try f.back_preds[w].append(gpa, vu);
                    } else {
                        try addToSet(gpa, &f.non_back_preds[w], vu);
                    }
                }
            }
        }
        f.header[0] = 0;

        var node_pool: std.ArrayList(*UnionFindNode) = .empty;
        defer node_pool.deinit(gpa);
        var work_list: std.ArrayList(*UnionFindNode) = .empty;
        defer work_list.deinit(gpa);
        var w = size;
        while (w > 0) {
            w -= 1;
            const node_w = f.nodes[w].bb orelse continue;
            node_pool.clearRetainingCapacity();
            for (f.back_preds[w].items) |v| {
                if (v != w) {
                    try node_pool.append(gpa, try f.nodes[v].findSet(gpa));
                } else {
                    f.typ[w] = .self;
                }
            }
            work_list.clearRetainingCapacity();
            try work_list.appendSlice(gpa, node_pool.items);
            if (node_pool.items.len != 0) f.typ[w] = .reducible;
            var head: usize = 0;
            while (head < work_list.items.len) {
                const x = work_list.items[head];
                head += 1;
                const xd = x.dfs_number;
                if (f.non_back_preds[xd].items.len > max_non_back_preds) return;
                // The set may grow while it is walked.
                var k: usize = 0;
                while (k < f.non_back_preds[xd].items.len) : (k += 1) {
                    const ydash = try f.nodes[f.non_back_preds[xd].items[k]].findSet(gpa);
                    const yd = ydash.dfs_number;
                    if (!f.isAncestor(w, yd)) {
                        f.typ[w] = .irreducible;
                        try addToSet(gpa, &f.non_back_preds[w], yd);
                    } else if (yd != w) {
                        const found = for (node_pool.items) |e| {
                            if (e == ydash) break true;
                        } else false;
                        if (!found) {
                            try work_list.append(gpa, ydash);
                            try node_pool.append(gpa, ydash);
                        }
                    }
                }
            }
            if (node_pool.items.len > 0 or f.typ[w] == .self) {
                const loop = try f.lsg.newLoop(node_w, f.typ[w] != .irreducible);
                f.nodes[w].loop = loop;
                for (node_pool.items) |node| {
                    f.header[node.dfs_number] = w;
                    node.parent = &f.nodes[w];
                    if (node.loop) |l| {
                        try l.setParent(gpa, loop);
                    } else {
                        try loop.addNode(gpa, node.bb.?);
                    }
                }
            }
        }
    }
};

const App = struct {
    gpa: Allocator,
    cfg: Cfg,
    lsg: Lsg,

    fn buildDiamond(a: *App, start: usize) !usize {
        const bb0 = start;
        try a.cfg.addEdge(bb0, bb0 + 1);
        try a.cfg.addEdge(bb0, bb0 + 2);
        try a.cfg.addEdge(bb0 + 1, bb0 + 3);
        try a.cfg.addEdge(bb0 + 2, bb0 + 3);
        return bb0 + 3;
    }

    fn buildConnect(a: *App, start: usize, end: usize) !void {
        try a.cfg.addEdge(start, end);
    }

    fn buildStraight(a: *App, start: usize, n: usize) !usize {
        for (0..n) |i| try a.buildConnect(start + i, start + i + 1);
        return start + n;
    }

    fn buildBaseLoop(a: *App, from: usize) !usize {
        const header = try a.buildStraight(from, 1);
        const diamond1 = try a.buildDiamond(header);
        const d11 = try a.buildStraight(diamond1, 1);
        const diamond2 = try a.buildDiamond(d11);
        const footer = try a.buildStraight(diamond2, 1);
        try a.buildConnect(diamond2, d11);
        try a.buildConnect(diamond1, header);
        try a.buildConnect(footer, from);
        return a.buildStraight(footer, 1);
    }

    fn findLoops(a: *App, lsg: *Lsg) !void {
        var f = Finder{ .gpa = a.gpa, .cfg = &a.cfg, .lsg = lsg };
        defer f.deinit();
        try f.findLoops();
    }

    fn main(a: *App, num_dummy_loops: u32, find_loop_iterations: u32, par_loops: u32, ppar_loops: u32, pppar_loops: u32) ![2]usize {
        _ = try a.cfg.createNode(0);
        _ = try a.buildBaseLoop(0);
        _ = try a.cfg.createNode(1);
        try a.cfg.addEdge(0, 2);
        for (0..num_dummy_loops) |_| try a.findLoops(&a.lsg);
        var n: usize = 2;
        for (0..par_loops) |_| {
            _ = try a.cfg.createNode(n + 1);
            try a.buildConnect(2, n + 1);
            n += 1;
            for (0..ppar_loops) |_| {
                const top = n;
                n = try a.buildStraight(n, 1);
                for (0..pppar_loops) |_| n = try a.buildBaseLoop(n);
                const bottom = try a.buildStraight(n, 1);
                try a.buildConnect(n, top);
                n = bottom;
            }
            try a.buildConnect(n, 1);
        }
        try a.findLoops(&a.lsg);
        // The reference discards these results; their loop counts are summed
        // so no compiler can drop the work (as in the Resid port).
        var extra: usize = 0;
        for (0..find_loop_iterations) |_| {
            var l = try Lsg.init(a.gpa);
            defer l.deinit();
            try a.findLoops(&l);
            extra += l.loops.items.len;
        }
        if (extra == 0 and find_loop_iterations > 0) @panic("findLoops found nothing");
        try a.lsg.calculateNestingLevel();
        return .{ a.lsg.loops.items.len, a.cfg.basic_block_map.items.len };
    }
};

pub fn inner(gpa: Allocator, n: u32) !bool {
    var app = App{ .gpa = gpa, .cfg = .{ .gpa = gpa }, .lsg = try Lsg.init(gpa) };
    defer app.cfg.deinit();
    defer app.lsg.deinit();
    _ = try app.cfg.createNode(0);
    const r = try app.main(n, 50, 10, 10, 5);
    const loops = r[0];
    const nodes = r[1];
    return switch (n) {
        15000 => loops == 46602 and nodes == 5213,
        1500 => loops == 6102 and nodes == 5213,
        150 => loops == 2052 and nodes == 5213,
        15 => loops == 1647 and nodes == 5213,
        1 => loops == 1605 and nodes == 5213,
        else => blk: {
            std.debug.print("No verification result for {d} found; result {d}, {d}\n", .{ n, loops, nodes });
            break :blk false;
        },
    };
}
