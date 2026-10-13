// Are We Fast Yet, Zig port: `harness <Benchmark> [outer [inner]]`, the
// reference harness's interface and output (Run.java).
const std = @import("std");

const benchmarks = .{
    .{ "Bounce", @import("small.zig").bounce },
    .{ "List", @import("small.zig").list },
    .{ "Mandelbrot", @import("small.zig").mandelbrot },
    .{ "NBody", @import("small.zig").nbody },
    .{ "Permute", @import("small.zig").permute },
    .{ "Queens", @import("small.zig").queens },
    .{ "Sieve", @import("small.zig").sieve },
    .{ "Storage", @import("small.zig").storage },
    .{ "Towers", @import("small.zig").towers },
    .{ "Richards", @import("richards.zig").inner },
    .{ "DeltaBlue", @import("deltablue.zig").inner },
    .{ "Json", @import("json.zig").inner },
    .{ "CD", @import("cd.zig").inner },
    .{ "Havlak", @import("havlak.zig").inner },
};

fn run(name: []const u8, gpa: std.mem.Allocator, inner: u32) !bool {
    inline for (benchmarks) |b| {
        if (std.mem.eql(u8, name, b[0])) return b[1](gpa, inner);
    }
    return error.NoSuchBenchmark;
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var buf: [4096]u8 = undefined;
    var fw = std.Io.File.stdout().writer(io, &buf);
    const out = &fw.interface;
    defer out.flush() catch {};

    var args = init.minimal.args.iterate();
    _ = args.skip();
    const name = args.next() orelse {
        try out.print("harness benchmark [num-iterations [inner-iter]]\n", .{});
        try out.flush();
        std.process.exit(1);
    };
    const outer: u32 = if (args.next()) |a| try std.fmt.parseInt(u32, a, 10) else 1;
    const inner: u32 = if (args.next()) |a| try std.fmt.parseInt(u32, a, 10) else 1;
    // Zig's general-purpose allocator for release builds; every benchmark
    // frees what it allocates (AWFY's explicit-memory rules), which a Debug
    // build checks with the leak-detecting DebugAllocator.
    var debug_alloc: std.heap.DebugAllocator(.{}) = .init;
    defer if (@import("builtin").mode == .Debug and debug_alloc.deinit() == .leak) @panic("memory leaked");
    const gpa = if (@import("builtin").mode == .Debug) debug_alloc.allocator() else std.heap.smp_allocator;

    try out.print("Starting {s} benchmark ...\n", .{name});
    var total: i64 = 0;
    var i: u32 = 0;
    while (i < outer) : (i += 1) {
        const t0 = std.Io.Timestamp.now(io, .awake);
        if (!try run(name, gpa, inner)) {
            try out.print("Benchmark failed with incorrect result\n", .{});
            try out.flush();
            std.process.exit(1);
        }
        const us = t0.durationTo(std.Io.Timestamp.now(io, .awake)).toMicroseconds();
        try out.print("{s}: iterations=1 runtime: {d}us\n", .{ name, us });
        total += us;
    }
    try out.print("{s}: iterations={d} average: {d}us total: {d}us\n\n", .{ name, outer, @divTrunc(total, outer), total });
    try out.print("Total Runtime: {d}us\n", .{total});
}
