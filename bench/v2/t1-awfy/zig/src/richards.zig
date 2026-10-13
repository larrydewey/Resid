// AWFY Richards, after the Java reference. Zig has no closures, so a task's
// function and data record are a tagged union switched on in runTask. The
// object graph lives in an arena freed after each run (the C++ port's
// object_tracker).
const std = @import("std");
const Allocator = std.mem.Allocator;

const idler = 0;
const worker = 1;
const handler_a = 2;
const handler_b = 3;
const device_a = 4;
const device_b = 5;
const num_types = 6;

const device_packet_kind = 0;
const work_packet_kind = 1;
const data_size = 4;

const Packet = struct {
    link: ?*Packet,
    identity: usize,
    kind: i32,
    datum: i32 = 0,
    data: [data_size]i32 = .{ 0, 0, 0, 0 },
};

fn append(packet: *Packet, queue_head: ?*Packet) *Packet {
    packet.link = null;
    const head = queue_head orelse return packet;
    var mouse = head;
    while (mouse.link) |link| mouse = link;
    mouse.link = packet;
    return head;
}

const TaskState = struct {
    packet_pending: bool = false,
    task_waiting: bool = false,
    task_holding: bool = false,

    fn running() TaskState {
        return .{};
    }
    fn waiting() TaskState {
        return .{ .task_waiting = true };
    }
    fn waitingWithPacket() TaskState {
        return .{ .task_waiting = true, .packet_pending = true };
    }
    fn isTaskHoldingOrWaiting(s: TaskState) bool {
        return s.task_holding or (!s.packet_pending and s.task_waiting);
    }
    fn isWaitingWithPacket(s: TaskState) bool {
        return s.packet_pending and s.task_waiting and !s.task_holding;
    }
};

const Record = union(enum) {
    device: struct { pending: ?*Packet = null },
    handler: struct { work_in: ?*Packet = null, device_in: ?*Packet = null },
    idle: struct { control: i32 = 1, count: i32 = 10000 },
    worker: struct { destination: usize = handler_a, count: i32 = 0 },
};

const Tcb = struct {
    state: TaskState,
    link: ?*Tcb,
    identity: usize,
    priority: i32,
    input: ?*Packet,
    record: Record,

    fn addInputAndCheckPriority(t: *Tcb, packet: *Packet, old_task: *Tcb) *Tcb {
        if (t.input) |in| {
            t.input = append(packet, in);
        } else {
            t.input = packet;
            t.state.packet_pending = true;
            if (t.priority > old_task.priority) return t;
        }
        return old_task;
    }
};

const Scheduler = struct {
    arena: Allocator,
    task_list: ?*Tcb = null,
    current_task: ?*Tcb = null,
    current_task_identity: usize = 0,
    task_table: [num_types]?*Tcb = .{null} ** num_types,
    queue_packet_count: i32 = 0,
    hold_count: i32 = 0,

    fn createTask(s: *Scheduler, identity: usize, priority: i32, work: ?*Packet, state: TaskState, record: Record) !void {
        const t = try s.arena.create(Tcb);
        t.* = .{ .state = state, .link = s.task_list, .identity = identity, .priority = priority, .input = work, .record = record };
        s.task_list = t;
        s.task_table[identity] = t;
    }

    fn createPacket(s: *Scheduler, link: ?*Packet, identity: usize, kind: i32) !*Packet {
        const p = try s.arena.create(Packet);
        p.* = .{ .link = link, .identity = identity, .kind = kind };
        return p;
    }

    fn start(s: *Scheduler) !bool {
        try s.createTask(idler, 0, null, TaskState.running(), .{ .idle = .{} });
        var work_q = try s.createPacket(null, worker, work_packet_kind);
        work_q = try s.createPacket(work_q, worker, work_packet_kind);
        try s.createTask(worker, 1000, work_q, TaskState.waitingWithPacket(), .{ .worker = .{} });
        work_q = try s.createPacket(null, device_a, device_packet_kind);
        work_q = try s.createPacket(work_q, device_a, device_packet_kind);
        work_q = try s.createPacket(work_q, device_a, device_packet_kind);
        try s.createTask(handler_a, 2000, work_q, TaskState.waitingWithPacket(), .{ .handler = .{} });
        work_q = try s.createPacket(null, device_b, device_packet_kind);
        work_q = try s.createPacket(work_q, device_b, device_packet_kind);
        work_q = try s.createPacket(work_q, device_b, device_packet_kind);
        try s.createTask(handler_b, 3000, work_q, TaskState.waitingWithPacket(), .{ .handler = .{} });
        try s.createTask(device_a, 4000, null, TaskState.waiting(), .{ .device = .{} });
        try s.createTask(device_b, 5000, null, TaskState.waiting(), .{ .device = .{} });
        s.schedule();
        return s.queue_packet_count == 23246 and s.hold_count == 9297;
    }

    fn findTask(s: *Scheduler, identity: usize) *Tcb {
        return s.task_table[identity] orelse @panic("findTask failed");
    }

    fn holdSelf(s: *Scheduler) ?*Tcb {
        s.hold_count += 1;
        const t = s.current_task.?;
        t.state.task_holding = true;
        return t.link;
    }

    fn queuePacket(s: *Scheduler, packet: *Packet) ?*Tcb {
        const t = s.findTask(packet.identity);
        s.queue_packet_count += 1;
        packet.link = null;
        packet.identity = s.current_task_identity;
        return t.addInputAndCheckPriority(packet, s.current_task.?);
    }

    fn release(s: *Scheduler, identity: usize) ?*Tcb {
        const t = s.findTask(identity);
        t.state.task_holding = false;
        const cur = s.current_task.?;
        return if (t.priority > cur.priority) t else cur;
    }

    fn markWaiting(s: *Scheduler) ?*Tcb {
        const t = s.current_task.?;
        t.state.task_waiting = true;
        return t;
    }

    fn runTask(s: *Scheduler, t: *Tcb) ?*Tcb {
        var message: ?*Packet = null;
        if (t.state.isWaitingWithPacket()) {
            const m = t.input.?;
            message = m;
            t.input = m.link;
            if (t.input == null) {
                t.state = TaskState.running();
            } else {
                t.state = .{ .packet_pending = true };
            }
        }
        switch (t.record) {
            .device => |*d| {
                const work = message orelse {
                    const pending = d.pending orelse return s.markWaiting();
                    d.pending = null;
                    return s.queuePacket(pending);
                };
                d.pending = work;
                return s.holdSelf();
            },
            .handler => |*h| {
                if (message) |work| {
                    if (work.kind == work_packet_kind) {
                        h.work_in = append(work, h.work_in);
                    } else {
                        h.device_in = append(work, h.device_in);
                    }
                }
                const work_packet = h.work_in orelse return s.markWaiting();
                const count = work_packet.datum;
                if (count >= data_size) {
                    h.work_in = work_packet.link;
                    return s.queuePacket(work_packet);
                }
                const device_packet = h.device_in orelse return s.markWaiting();
                h.device_in = device_packet.link;
                device_packet.datum = work_packet.data[@intCast(count)];
                work_packet.datum = count + 1;
                return s.queuePacket(device_packet);
            },
            .idle => |*r| {
                r.count -= 1;
                if (r.count == 0) return s.holdSelf();
                if (r.control & 1 == 0) {
                    r.control = @divTrunc(r.control, 2);
                    return s.release(device_a);
                }
                r.control = @divTrunc(r.control, 2) ^ 53256;
                return s.release(device_b);
            },
            .worker => |*w| {
                const work = message orelse return s.markWaiting();
                w.destination = if (w.destination == handler_a) handler_b else handler_a;
                work.identity = w.destination;
                work.datum = 0;
                for (&work.data) |*d| {
                    w.count += 1;
                    if (w.count > 26) w.count = 1;
                    d.* = 65 + w.count - 1;
                }
                return s.queuePacket(work);
            },
        }
    }

    fn schedule(s: *Scheduler) void {
        s.current_task = s.task_list;
        while (s.current_task) |t| {
            if (t.state.isTaskHoldingOrWaiting()) {
                s.current_task = t.link;
            } else {
                s.current_task_identity = t.identity;
                s.current_task = s.runTask(t);
            }
        }
    }
};

pub fn inner(gpa: Allocator, n: u32) !bool {
    var i: u32 = 0;
    while (i < n) : (i += 1) {
        var arena = std.heap.ArenaAllocator.init(gpa);
        defer arena.deinit();
        var s = Scheduler{ .arena = arena.allocator() };
        if (!try s.start()) return false;
    }
    return true;
}
