// AWFY DeltaBlue, after the Java reference. Variables and constraints live
// in arenas and refer to each other by index; constraint subclasses are an
// enum; strengths are their arithmetic values.
use std::collections::VecDeque;

const REQUIRED: i32 = -800;
const STRONG_DEFAULT: i32 = -200;
const PREFERRED: i32 = -400;
const DEFAULT: i32 = 0;
const WEAKEST: i32 = 10000;

#[derive(Clone, Copy, PartialEq)]
enum Dir { None, Forward, Backward }

#[derive(Clone, Copy, PartialEq)]
enum Kind { Edit, Stay, Equality, Scale { scale: usize, offset: usize } }

struct Var { value: i32, constraints: Vec<usize>, determined_by: Option<usize>, mark: i32, walk: i32, stay: bool }

#[derive(Clone, Copy)]
struct Con { kind: Kind, strength: i32, v1: usize, v2: usize, dir: Dir, satisfied: bool }

impl Con {
    fn unary(&self) -> bool { matches!(self.kind, Kind::Edit | Kind::Stay) }
    fn is_input(&self) -> bool { matches!(self.kind, Kind::Edit) }
    fn is_satisfied(&self) -> bool { if self.unary() { self.satisfied } else { self.dir != Dir::None } }
    fn output(&self) -> usize { if self.unary() || self.dir != Dir::Forward { self.v1 } else { self.v2 } }
    fn input(&self) -> usize { if self.dir == Dir::Forward { self.v1 } else { self.v2 } }
}

struct Planner { vars: Vec<Var>, cons: Vec<Con>, current_mark: i32 }

impl Planner {
    fn new_var(&mut self, value: i32) -> usize {
        self.vars.push(Var { value, constraints: Vec::with_capacity(2), determined_by: None, mark: 0, walk: WEAKEST, stay: true });
        self.vars.len() - 1
    }

    fn new_con(&mut self, kind: Kind, strength: i32, v1: usize, v2: usize) -> usize {
        self.cons.push(Con { kind, strength, v1, v2, dir: Dir::None, satisfied: false });
        let c = self.cons.len() - 1;
        self.add_to_graph(c);
        self.incremental_add(c);
        c
    }

    fn add_to_graph(&mut self, c: usize) {
        let k = self.cons[c];
        self.vars[k.v1].constraints.push(c);
        if !k.unary() { self.vars[k.v2].constraints.push(c); }
        if let Kind::Scale { scale, offset } = k.kind {
            self.vars[scale].constraints.push(c);
            self.vars[offset].constraints.push(c);
        }
        self.cons[c].dir = Dir::None;
        self.cons[c].satisfied = false;
    }

    fn remove_var_con(&mut self, v: usize, c: usize) {
        self.vars[v].constraints.retain(|&x| x != c);
        if self.vars[v].determined_by == Some(c) { self.vars[v].determined_by = None; }
    }

    fn remove_from_graph(&mut self, c: usize) {
        let k = self.cons[c];
        self.remove_var_con(k.v1, c);
        if !k.unary() { self.remove_var_con(k.v2, c); }
        if let Kind::Scale { scale, offset } = k.kind {
            self.remove_var_con(scale, c);
            self.remove_var_con(offset, c);
        }
        self.cons[c].dir = Dir::None;
        self.cons[c].satisfied = false;
    }

    fn choose_method(&mut self, c: usize, mark: i32) {
        let k = self.cons[c];
        if k.unary() {
            let o = &self.vars[k.v1];
            self.cons[c].satisfied = o.mark != mark && k.strength < o.walk;
            return;
        }
        let (a, b) = (&self.vars[k.v1], &self.vars[k.v2]);
        let dir = if a.mark == mark {
            if b.mark != mark && k.strength < b.walk { Dir::Forward } else { Dir::None }
        } else if b.mark == mark {
            if a.mark != mark && k.strength < a.walk { Dir::Backward } else { Dir::None }
        } else if a.walk > b.walk {
            if k.strength < a.walk { Dir::Backward } else { Dir::None }
        } else if k.strength < b.walk { Dir::Forward } else { Dir::None };
        self.cons[c].dir = dir;
    }

    fn execute(&mut self, c: usize) {
        let k = self.cons[c];
        match k.kind {
            Kind::Equality => {
                if k.dir == Dir::Forward { self.vars[k.v2].value = self.vars[k.v1].value; }
                else { self.vars[k.v1].value = self.vars[k.v2].value; }
            }
            Kind::Scale { scale, offset } => {
                let (s, o) = (self.vars[scale].value, self.vars[offset].value);
                if k.dir == Dir::Forward { self.vars[k.v2].value = self.vars[k.v1].value * s + o; }
                else { self.vars[k.v1].value = (self.vars[k.v2].value - o) / s; }
            }
            _ => {}
        }
    }

    fn recalculate(&mut self, c: usize) {
        let k = self.cons[c];
        if k.unary() {
            self.vars[k.v1].walk = k.strength;
            self.vars[k.v1].stay = !k.is_input();
            if self.vars[k.v1].stay { self.execute(c); }
            return;
        }
        let (i, o) = (k.input(), k.output());
        self.vars[o].walk = k.strength.max(self.vars[i].walk);
        let mut stay = self.vars[i].stay;
        if let Kind::Scale { scale, offset } = k.kind { stay = stay && self.vars[scale].stay && self.vars[offset].stay; }
        self.vars[o].stay = stay;
        if stay { self.execute(c); }
    }

    fn inputs_known(&self, c: usize, mark: i32) -> bool {
        let k = &self.cons[c];
        if k.unary() { return true; }
        let v = &self.vars[k.input()];
        v.mark == mark || v.stay || v.determined_by.is_none()
    }

    fn inputs_mark(&mut self, c: usize, mark: i32) {
        let k = self.cons[c];
        if k.unary() { return; }
        self.vars[k.input()].mark = mark;
        if let Kind::Scale { scale, offset } = k.kind { self.vars[scale].mark = mark; self.vars[offset].mark = mark; }
    }

    fn new_mark(&mut self) -> i32 { self.current_mark += 1; self.current_mark }

    fn satisfy(&mut self, c: usize, mark: i32) -> Option<usize> {
        self.choose_method(c, mark);
        if self.cons[c].is_satisfied() {
            self.inputs_mark(c, mark);
            let out = self.cons[c].output();
            let overridden = self.vars[out].determined_by;
            if let Some(o) = overridden { self.cons[o].dir = Dir::None; self.cons[o].satisfied = false; }
            self.vars[out].determined_by = Some(c);
            if !self.add_propagate(c, mark) { panic!("Cycle encountered"); }
            self.vars[out].mark = mark;
            overridden
        } else {
            if self.cons[c].strength == REQUIRED { panic!("Could not satisfy a required constraint"); }
            None
        }
    }

    fn incremental_add(&mut self, c: usize) {
        let mark = self.new_mark();
        let mut overridden = self.satisfy(c, mark);
        while let Some(o) = overridden { overridden = self.satisfy(o, mark); }
    }

    fn incremental_remove(&mut self, c: usize) {
        let out = self.cons[c].output();
        self.cons[c].dir = Dir::None;
        self.cons[c].satisfied = false;
        self.remove_from_graph(c);
        let unsatisfied = self.remove_propagate_from(out);
        for u in unsatisfied { self.incremental_add(u); }
    }

    fn add_constraints_consuming_to(&self, v: usize, coll: &mut VecDeque<usize>) {
        let det = self.vars[v].determined_by;
        for &c in self.vars[v].constraints.iter() {
            if Some(c) != det && self.cons[c].is_satisfied() { coll.push_back(c); }
        }
    }

    fn add_propagate(&mut self, c: usize, mark: i32) -> bool {
        let mut todo = VecDeque::from([c]);
        while let Some(d) = todo.pop_front() {
            if self.vars[self.cons[d].output()].mark == mark {
                self.incremental_remove(c);
                return false;
            }
            self.recalculate(d);
            self.add_constraints_consuming_to(self.cons[d].output(), &mut todo);
        }
        true
    }

    fn remove_propagate_from(&mut self, out: usize) -> Vec<usize> {
        let mut unsatisfied = Vec::new();
        self.vars[out].determined_by = None;
        self.vars[out].walk = WEAKEST;
        self.vars[out].stay = true;
        let mut todo = VecDeque::from([out]);
        while let Some(v) = todo.pop_front() {
            for &c in self.vars[v].constraints.iter() {
                if !self.cons[c].is_satisfied() { unsatisfied.push(c); }
            }
            let det = self.vars[v].determined_by;
            let cs = self.vars[v].constraints.clone();
            for c in cs {
                if Some(c) != det && self.cons[c].is_satisfied() {
                    self.recalculate(c);
                    todo.push_back(self.cons[c].output());
                }
            }
        }
        // The reference's Vector.sort implements no swap: it only ever sees
        // lists already in order.
        assert!(unsatisfied.len() <= 1 || (unsatisfied.len() == 2 && self.cons[unsatisfied[0]].strength < self.cons[unsatisfied[1]].strength));
        unsatisfied
    }

    fn make_plan(&mut self, sources: VecDeque<usize>) -> Vec<usize> {
        let mark = self.new_mark();
        let mut plan = Vec::with_capacity(15);
        let mut todo = sources;
        while let Some(c) = todo.pop_front() {
            let out = self.cons[c].output();
            if self.vars[out].mark != mark && self.inputs_known(c, mark) {
                plan.push(c);
                self.vars[out].mark = mark;
                self.add_constraints_consuming_to(out, &mut todo);
            }
        }
        plan
    }

    fn extract_plan(&mut self, constraints: &[usize]) -> Vec<usize> {
        let sources: VecDeque<usize> = constraints.iter().copied()
            .filter(|&c| self.cons[c].is_input() && self.cons[c].is_satisfied()).collect();
        self.make_plan(sources)
    }

    fn execute_plan(&mut self, plan: &[usize]) { for &c in plan { self.execute(c); } }

    fn destroy(&mut self, c: usize) {
        if self.cons[c].is_satisfied() { self.incremental_remove(c); }
        self.remove_from_graph(c);
    }

    fn change(&mut self, var: usize, new_value: i32) {
        let edit = self.new_con(Kind::Edit, PREFERRED, var, var);
        let plan = self.extract_plan(&[edit]);
        for _ in 0..10 {
            self.vars[var].value = new_value;
            self.execute_plan(&plan);
        }
        self.destroy(edit);
    }
}

fn planner() -> Planner { Planner { vars: Vec::new(), cons: Vec::new(), current_mark: 1 } }

fn chain_test(n: usize) {
    let mut p = planner();
    let vars: Vec<usize> = (0..=n).map(|_| p.new_var(0)).collect();
    for i in 0..n { p.new_con(Kind::Equality, REQUIRED, vars[i], vars[i + 1]); }
    p.new_con(Kind::Stay, STRONG_DEFAULT, vars[n], vars[n]);
    let edit = p.new_con(Kind::Edit, PREFERRED, vars[0], vars[0]);
    let plan = p.extract_plan(&[edit]);
    for i in 0..100 {
        p.vars[vars[0]].value = i;
        p.execute_plan(&plan);
        if p.vars[vars[n]].value != i { panic!("Chain test failed!"); }
    }
    p.destroy(edit);
}

fn projection_test(n: i32) {
    let mut p = planner();
    let mut dests = Vec::new();
    let scale = p.new_var(10);
    let offset = p.new_var(1000);
    let (mut src, mut dst) = (0, 0);
    for i in 1..=n {
        src = p.new_var(i);
        dst = p.new_var(i);
        dests.push(dst);
        p.new_con(Kind::Stay, DEFAULT, src, src);
        p.new_con(Kind::Scale { scale, offset }, REQUIRED, src, dst);
    }
    p.change(src, 17);
    if p.vars[dst].value != 1170 { panic!("Projection test 1 failed!"); }
    p.change(dst, 1050);
    if p.vars[src].value != 5 { panic!("Projection test 2 failed!"); }
    p.change(scale, 5);
    for i in 0..(n - 1) as usize {
        if p.vars[dests[i]].value != (i as i32 + 1) * 5 + 1000 { panic!("Projection test 3 failed!"); }
    }
    p.change(offset, 2000);
    for i in 0..(n - 1) as usize {
        if p.vars[dests[i]].value != (i as i32 + 1) * 5 + 2000 { panic!("Projection test 4 failed!"); }
    }
}

pub fn inner(inner: i32) -> bool {
    chain_test(inner as usize);
    projection_test(inner);
    true
}
