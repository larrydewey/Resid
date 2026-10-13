// AWFY Richards, after the Java reference. Packets and task control blocks
// live in arenas (Vec) and link by index (NO_WORK / NO_TASK = None); the
// task functions dispatch on the data record's kind.

const IDLER: usize = 0;
const WORKER: usize = 1;
const HANDLER_A: usize = 2;
const HANDLER_B: usize = 3;
const DEVICE_A: usize = 4;
const DEVICE_B: usize = 5;
const NUM_TYPES: usize = 6;
const DEVICE_PACKET_KIND: i32 = 0;
const WORK_PACKET_KIND: i32 = 1;
const DATA_SIZE: usize = 4;

type P = Option<usize>;

struct Packet { link: P, identity: usize, kind: i32, datum: i32, data: [i32; DATA_SIZE] }

enum Data {
    Device { pending: P },
    Handler { work_in: P, device_in: P },
    Idle { control: i32, count: i32 },
    Worker { destination: usize, count: i32 },
}

struct Tcb {
    link: Option<usize>, identity: usize, priority: i32, input: P,
    packet_pending: bool, task_waiting: bool, task_holding: bool, data: Data,
}

impl Tcb {
    fn is_holding_or_waiting(&self) -> bool { self.task_holding || (!self.packet_pending && self.task_waiting) }
    fn is_waiting_with_packet(&self) -> bool { self.packet_pending && self.task_waiting && !self.task_holding }
}

struct Scheduler {
    packets: Vec<Packet>, tasks: Vec<Tcb>, table: [Option<usize>; NUM_TYPES],
    task_list: Option<usize>, current_task: Option<usize>, current_task_identity: usize,
    queue_packet_count: i32, hold_count: i32,
}

impl Scheduler {
    fn append(&mut self, packet: usize, queue_head: P) -> P {
        self.packets[packet].link = None;
        let head = match queue_head { None => return Some(packet), Some(h) => h };
        let mut mouse = head;
        while let Some(link) = self.packets[mouse].link { mouse = link; }
        self.packets[mouse].link = Some(packet);
        Some(head)
    }

    fn create_packet(&mut self, link: P, identity: usize, kind: i32) -> usize {
        self.packets.push(Packet { link, identity, kind, datum: 0, data: [0; DATA_SIZE] });
        self.packets.len() - 1
    }

    // state: (packet_pending, task_waiting, task_holding)
    fn create_task(&mut self, identity: usize, priority: i32, work: P, state: (bool, bool, bool), data: Data) {
        let t = Tcb { link: self.task_list, identity, priority, input: work, packet_pending: state.0,
                      task_waiting: state.1, task_holding: state.2, data };
        self.tasks.push(t);
        let i = self.tasks.len() - 1;
        self.task_list = Some(i);
        self.table[identity] = Some(i);
    }

    fn find_task(&self, identity: usize) -> usize { self.table[identity].expect("findTask failed") }

    fn hold_self(&mut self) -> Option<usize> {
        self.hold_count += 1;
        let c = self.current_task.unwrap();
        self.tasks[c].task_holding = true;
        self.tasks[c].link
    }

    fn queue_packet(&mut self, packet: usize) -> Option<usize> {
        let t = self.find_task(self.packets[packet].identity);
        self.queue_packet_count += 1;
        self.packets[packet].link = None;
        self.packets[packet].identity = self.current_task_identity;
        let old = self.current_task.unwrap();
        self.add_input_and_check_priority(t, packet, old)
    }

    fn add_input_and_check_priority(&mut self, t: usize, packet: usize, old: usize) -> Option<usize> {
        if self.tasks[t].input.is_none() {
            self.tasks[t].input = Some(packet);
            self.tasks[t].packet_pending = true;
            if self.tasks[t].priority > self.tasks[old].priority { return Some(t); }
        } else {
            let input = self.tasks[t].input;
            self.tasks[t].input = self.append(packet, input);
        }
        Some(old)
    }

    fn release(&mut self, identity: usize) -> Option<usize> {
        let t = self.find_task(identity);
        self.tasks[t].task_holding = false;
        let c = self.current_task.unwrap();
        if self.tasks[t].priority > self.tasks[c].priority { Some(t) } else { Some(c) }
    }

    fn mark_waiting(&mut self) -> Option<usize> {
        let c = self.current_task.unwrap();
        self.tasks[c].task_waiting = true;
        Some(c)
    }

    fn run_task(&mut self, t: usize) -> Option<usize> {
        let message = if self.tasks[t].is_waiting_with_packet() {
            let m = self.tasks[t].input.unwrap();
            let next = self.packets[m].link;
            self.tasks[t].input = next;
            let tk = &mut self.tasks[t];
            if next.is_none() {
                tk.packet_pending = false; tk.task_waiting = false; tk.task_holding = false;
            } else {
                tk.packet_pending = true; tk.task_waiting = false; tk.task_holding = false;
            }
            Some(m)
        } else { None };
        self.run_function(t, message)
    }

    fn run_function(&mut self, t: usize, work: P) -> Option<usize> {
        match self.tasks[t].data {
            Data::Device { pending } => match work {
                None => match pending {
                    None => self.mark_waiting(),
                    Some(fw) => { self.tasks[t].data = Data::Device { pending: None }; self.queue_packet(fw) }
                },
                Some(w) => { self.tasks[t].data = Data::Device { pending: Some(w) }; self.hold_self() }
            },
            Data::Handler { work_in, device_in } => {
                let (mut wi, mut di) = (work_in, device_in);
                if let Some(w) = work {
                    if self.packets[w].kind == WORK_PACKET_KIND { wi = self.append(w, wi); } else { di = self.append(w, di); }
                }
                self.tasks[t].data = Data::Handler { work_in: wi, device_in: di };
                match wi {
                    None => self.mark_waiting(),
                    Some(wp) => {
                        let count = self.packets[wp].datum;
                        if count >= DATA_SIZE as i32 {
                            self.tasks[t].data = Data::Handler { work_in: self.packets[wp].link, device_in: di };
                            self.queue_packet(wp)
                        } else {
                            match di {
                                None => self.mark_waiting(),
                                Some(dp) => {
                                    self.tasks[t].data = Data::Handler { work_in: wi, device_in: self.packets[dp].link };
                                    self.packets[dp].datum = self.packets[wp].data[count as usize];
                                    self.packets[wp].datum = count + 1;
                                    self.queue_packet(dp)
                                }
                            }
                        }
                    }
                }
            }
            Data::Idle { control, count } => {
                let c = count - 1;
                if c == 0 {
                    self.tasks[t].data = Data::Idle { control, count: c };
                    self.hold_self()
                } else if (control & 1) == 0 {
                    self.tasks[t].data = Data::Idle { control: control / 2, count: c };
                    self.release(DEVICE_A)
                } else {
                    self.tasks[t].data = Data::Idle { control: (control / 2) ^ 53256, count: c };
                    self.release(DEVICE_B)
                }
            }
            Data::Worker { destination, count } => match work {
                None => self.mark_waiting(),
                Some(w) => {
                    let dest = if destination == HANDLER_A { HANDLER_B } else { HANDLER_A };
                    let mut cnt = count;
                    self.packets[w].identity = dest;
                    self.packets[w].datum = 0;
                    for i in 0..DATA_SIZE {
                        cnt += 1;
                        if cnt > 26 { cnt = 1; }
                        self.packets[w].data[i] = 65 + cnt - 1;
                    }
                    self.tasks[t].data = Data::Worker { destination: dest, count: cnt };
                    self.queue_packet(w)
                }
            },
        }
    }

    fn schedule(&mut self) {
        self.current_task = self.task_list;
        while let Some(c) = self.current_task {
            if self.tasks[c].is_holding_or_waiting() {
                self.current_task = self.tasks[c].link;
            } else {
                self.current_task_identity = self.tasks[c].identity;
                self.current_task = self.run_task(c);
            }
        }
    }

    fn start(&mut self) -> bool {
        let running = (false, false, false);
        let waiting = (false, true, false);
        let waiting_with_packet = (true, true, false);
        self.create_task(IDLER, 0, None, running, Data::Idle { control: 1, count: 10000 });
        let mut wq = self.create_packet(None, WORKER, WORK_PACKET_KIND);
        wq = self.create_packet(Some(wq), WORKER, WORK_PACKET_KIND);
        self.create_task(WORKER, 1000, Some(wq), waiting_with_packet, Data::Worker { destination: HANDLER_A, count: 0 });
        wq = self.create_packet(None, DEVICE_A, DEVICE_PACKET_KIND);
        wq = self.create_packet(Some(wq), DEVICE_A, DEVICE_PACKET_KIND);
        wq = self.create_packet(Some(wq), DEVICE_A, DEVICE_PACKET_KIND);
        self.create_task(HANDLER_A, 2000, Some(wq), waiting_with_packet, Data::Handler { work_in: None, device_in: None });
        wq = self.create_packet(None, DEVICE_B, DEVICE_PACKET_KIND);
        wq = self.create_packet(Some(wq), DEVICE_B, DEVICE_PACKET_KIND);
        wq = self.create_packet(Some(wq), DEVICE_B, DEVICE_PACKET_KIND);
        self.create_task(HANDLER_B, 3000, Some(wq), waiting_with_packet, Data::Handler { work_in: None, device_in: None });
        self.create_task(DEVICE_A, 4000, None, waiting, Data::Device { pending: None });
        self.create_task(DEVICE_B, 5000, None, waiting, Data::Device { pending: None });
        self.schedule();
        self.queue_packet_count == 23246 && self.hold_count == 9297
    }
}

pub fn inner(inner: i32) -> bool {
    (0..inner).all(|_| {
        let mut s = Scheduler { packets: Vec::new(), tasks: Vec::new(), table: [None; NUM_TYPES], task_list: None,
                                current_task: None, current_task_identity: 0, queue_packet_count: 0, hold_count: 0 };
        s.start()
    })
}
