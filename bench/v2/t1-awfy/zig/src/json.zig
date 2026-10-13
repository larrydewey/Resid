// AWFY Json, after the Java reference: a pure-string parser over the RAP
// benchmark document. `current` is a one-character slice of the input (the
// reference's substring), "" at the end of the text. Each parse tree lives
// in an arena, as std.json's parsed values do.
const std = @import("std");
const Allocator = std.mem.Allocator;

const rap_benchmark = @embedFile("rap.json");

const Value = union(enum) {
    object: *Object,
    array: *std.ArrayList(*Value),
    number: []const u8,
    string: []const u8,
    literal: Literal,
};

const Literal = enum { null, true, false };

const Object = struct {
    names: std.ArrayList([]const u8) = .empty,
    values: std.ArrayList(*Value) = .empty,
    table: [32]i32 = .{0} ** 32,

    fn slot(name: []const u8) usize {
        return @intCast((@as(i32, @intCast(name.len)) *% 1402589) & 31);
    }

    fn add(o: *Object, a: Allocator, name: []const u8, value: *Value) !void {
        const index: i32 = @intCast(o.names.items.len);
        o.table[slot(name)] = if (index < 0xff) (index + 1) & 0xff else 0;
        try o.names.append(a, name);
        try o.values.append(a, value);
    }

    fn get(o: *const Object, name: []const u8) *Value {
        const index = (o.table[slot(name)] & 0xff) - 1;
        if (index != -1 and std.mem.eql(u8, name, o.names.items[@intCast(index)])) {
            return o.values.items[@intCast(index)];
        }
        @panic("NotImplemented");
    }
};

const Parser = struct {
    a: Allocator,
    input: []const u8,
    index: isize = -1,
    line: i32 = 1,
    column: i32 = 0,
    current: []const u8 = "",
    eot: bool = false,
    capture_buffer: std.ArrayList(u8) = .empty,
    capture_start: isize = -1,

    fn parse(p: *Parser) !*Value {
        p.read();
        p.skipWhiteSpace();
        const result = try p.readValue();
        p.skipWhiteSpace();
        if (!p.eot) @panic("Unexpected character");
        return result;
    }

    fn is(p: *const Parser, ch: []const u8) bool {
        return std.mem.eql(u8, p.current, ch);
    }

    fn box(p: *Parser, v: Value) !*Value {
        const n = try p.a.create(Value);
        n.* = v;
        return n;
    }

    fn readValue(p: *Parser) anyerror!*Value {
        if (p.current.len == 1) switch (p.current[0]) {
            'n' => return p.readLiteral("ull", .null),
            't' => return p.readLiteral("rue", .true),
            'f' => return p.readLiteral("alse", .false),
            '"' => return p.box(.{ .string = try p.readStringInternal() }),
            '[' => return p.readArray(),
            '{' => return p.readObject(),
            '-', '0'...'9' => return p.readNumber(),
            else => {},
        };
        @panic("Expected value");
    }

    fn readArray(p: *Parser) !*Value {
        p.read();
        const array = try p.a.create(std.ArrayList(*Value));
        array.* = .empty;
        p.skipWhiteSpace();
        if (p.readChar("]")) return p.box(.{ .array = array });
        while (true) {
            p.skipWhiteSpace();
            try array.append(p.a, try p.readValue());
            p.skipWhiteSpace();
            if (!p.readChar(",")) break;
        }
        if (!p.readChar("]")) @panic("Expected ',' or ']'");
        return p.box(.{ .array = array });
    }

    fn readObject(p: *Parser) !*Value {
        p.read();
        const object = try p.a.create(Object);
        object.* = .{};
        p.skipWhiteSpace();
        if (p.readChar("}")) return p.box(.{ .object = object });
        while (true) {
            p.skipWhiteSpace();
            const name = try p.readName();
            p.skipWhiteSpace();
            if (!p.readChar(":")) @panic("Expected ':'");
            p.skipWhiteSpace();
            try object.add(p.a, name, try p.readValue());
            p.skipWhiteSpace();
            if (!p.readChar(",")) break;
        }
        if (!p.readChar("}")) @panic("Expected ',' or '}'");
        return p.box(.{ .object = object });
    }

    fn readName(p: *Parser) ![]const u8 {
        if (!p.is("\"")) @panic("Expected name");
        return p.readStringInternal();
    }

    // readNull/readTrue/readFalse: the first letter is current.
    fn readLiteral(p: *Parser, comptime rest: []const u8, lit: Literal) !*Value {
        p.read();
        inline for (rest) |ch| {
            if (!p.readChar(&[_]u8{ch})) @panic("Expected literal character");
        }
        return p.box(.{ .literal = lit });
    }

    fn readStringInternal(p: *Parser) ![]const u8 {
        p.read();
        p.startCapture();
        while (!p.is("\"")) {
            if (p.is("\\")) {
                try p.pauseCapture();
                try p.readEscape();
                p.startCapture();
            } else {
                p.read();
            }
        }
        const s = try p.endCapture();
        p.read();
        return s;
    }

    fn readEscape(p: *Parser) !void {
        p.read();
        const c: u8 = if (p.current.len == 1) p.current[0] else 0;
        const out: u8 = switch (c) {
            '"', '/', '\\' => c,
            'b' => 8,
            'f' => 12,
            'n' => '\n',
            'r' => '\r',
            't' => '\t',
            else => @panic("Expected valid escape sequence"),
        };
        try p.capture_buffer.append(p.a, out);
        p.read();
    }

    fn readNumber(p: *Parser) !*Value {
        p.startCapture();
        _ = p.readChar("-");
        const first_digit = p.current;
        if (!p.readDigit()) @panic("Expected digit");
        if (!std.mem.eql(u8, first_digit, "0")) {
            while (p.readDigit()) {}
        }
        _ = p.readFraction();
        _ = p.readExponent();
        return p.box(.{ .number = try p.endCapture() });
    }

    fn readFraction(p: *Parser) bool {
        if (!p.readChar(".")) return false;
        if (!p.readDigit()) @panic("Expected digit");
        while (p.readDigit()) {}
        return true;
    }

    fn readExponent(p: *Parser) bool {
        if (!p.readChar("e") and !p.readChar("E")) return false;
        if (!p.readChar("+")) _ = p.readChar("-");
        if (!p.readDigit()) @panic("Expected digit");
        while (p.readDigit()) {}
        return true;
    }

    fn readChar(p: *Parser, ch: []const u8) bool {
        if (!p.is(ch)) return false;
        p.read();
        return true;
    }

    fn readDigit(p: *Parser) bool {
        if (!p.isDigit()) return false;
        p.read();
        return true;
    }

    fn skipWhiteSpace(p: *Parser) void {
        while (p.isWhiteSpace()) p.read();
    }

    fn read(p: *Parser) void {
        if (p.is("\n")) {
            p.line += 1;
            p.column = 0;
        }
        p.index += 1;
        const i: usize = @intCast(p.index);
        if (i < p.input.len) {
            p.current = p.input[i .. i + 1];
        } else {
            p.current = "";
            p.eot = true;
        }
    }

    fn startCapture(p: *Parser) void {
        p.capture_start = p.index;
    }

    fn captured(p: *const Parser) []const u8 {
        const end = if (p.eot) p.index else p.index - 1;
        return p.input[@intCast(p.capture_start)..@intCast(end + 1)];
    }

    fn pauseCapture(p: *Parser) !void {
        try p.capture_buffer.appendSlice(p.a, p.captured());
        p.capture_start = -1;
    }

    fn endCapture(p: *Parser) ![]const u8 {
        const piece = p.captured();
        p.capture_start = -1;
        if (p.capture_buffer.items.len == 0) return piece;
        try p.capture_buffer.appendSlice(p.a, piece);
        const s = try p.capture_buffer.toOwnedSlice(p.a);
        return s;
    }

    fn isWhiteSpace(p: *const Parser) bool {
        return p.is(" ") or p.is("\t") or p.is("\n") or p.is("\r");
    }

    fn isDigit(p: *const Parser) bool {
        return p.current.len == 1 and p.current[0] >= '0' and p.current[0] <= '9';
    }
};

fn verify(r: *const Value) bool {
    const o = switch (r.*) {
        .object => |o| o,
        else => return false,
    };
    if (o.get("head").* != .object) return false;
    return switch (o.get("operations").*) {
        .array => |a| a.items.len == 156,
        else => false,
    };
}

pub fn inner(gpa: Allocator, n: u32) !bool {
    var i: u32 = 0;
    while (i < n) : (i += 1) {
        var arena = std.heap.ArenaAllocator.init(gpa);
        defer arena.deinit();
        var p = Parser{ .a = arena.allocator(), .input = rap_benchmark };
        if (!verify(try p.parse())) return false;
    }
    return true;
}
