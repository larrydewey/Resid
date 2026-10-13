// AWFY Havlak, after the Java reference: loop recognition on a synthetic
// control-flow graph. Blocks, union-find nodes and loops live in arenas
// referred to by index; the block-number dictionary is a HashMap keyed by
// block name, as the reference's IdentityDictionary hashes by name.
use std::collections::HashMap;

const UNVISITED: i32 = i32::MAX;
const MAXNONBACKPREDS: usize = 32 * 1024;

#[derive(Clone, Copy, PartialEq)]
enum BbClass { Top, NonHeader, Reducible, SelfLoop, Irreducible, Dead }

struct BasicBlock { in_edges: Vec<usize>, out_edges: Vec<usize> }

struct Cfg { blocks: Vec<Option<BasicBlock>>, start: Option<usize>, edges: Vec<(usize, usize)> }

impl Cfg {
    fn new() -> Cfg { Cfg { blocks: Vec::new(), start: None, edges: Vec::new() } }
    fn create_node(&mut self, name: usize) -> usize {
        if self.blocks.len() <= name { self.blocks.resize_with(name + 1, || None); }
        if self.blocks[name].is_none() {
            self.blocks[name] = Some(BasicBlock { in_edges: Vec::with_capacity(2), out_edges: Vec::with_capacity(2) });
        }
        if self.blocks.len() == 1 { self.start = Some(name); }
        name
    }
    fn add_edge(&mut self, from: usize, to: usize) {
        let f = self.create_node(from);
        let t = self.create_node(to);
        self.blocks[f].as_mut().unwrap().out_edges.push(t);
        self.blocks[t].as_mut().unwrap().in_edges.push(f);
        self.edges.push((f, t));
    }
    fn num_nodes(&self) -> usize { self.blocks.len() }
}

struct SimpleLoop { basic_blocks: Vec<usize>, children: Vec<usize>, parent: Option<usize>, is_root: bool, nesting_level: i32, depth_level: i32 }

struct Lsg { loops: Vec<SimpleLoop>, loop_counter: i32 }

impl Lsg {
    fn new() -> Lsg {
        let root = SimpleLoop { basic_blocks: Vec::new(), children: Vec::new(), parent: None, is_root: true, nesting_level: 0, depth_level: 0 };
        Lsg { loops: vec![root], loop_counter: 1 }
    }
    fn create_new_loop(&mut self, bb: Option<usize>) -> usize {
        let mut l = SimpleLoop { basic_blocks: Vec::new(), children: Vec::new(), parent: None, is_root: false, nesting_level: 0, depth_level: 0 };
        if let Some(b) = bb { l.basic_blocks.push(b); }
        self.loop_counter += 1;
        self.loops.push(l);
        self.loops.len() - 1
    }
    fn set_parent(&mut self, l: usize, p: usize) {
        self.loops[l].parent = Some(p);
        if !self.loops[p].children.contains(&l) { self.loops[p].children.push(l); }
    }
    fn add_node(&mut self, l: usize, bb: usize) {
        if !self.loops[l].basic_blocks.contains(&bb) { self.loops[l].basic_blocks.push(bb); }
    }
    fn calculate_nesting_level(&mut self) {
        for i in 0..self.loops.len() {
            if !self.loops[i].is_root && self.loops[i].parent.is_none() { self.set_parent(i, 0); }
        }
        self.nesting_rec(0, 0);
    }
    fn nesting_rec(&mut self, l: usize, depth: i32) {
        self.loops[l].depth_level = depth;
        let kids = self.loops[l].children.clone();
        for k in kids {
            self.nesting_rec(k, depth + 1);
            let lvl = self.loops[l].nesting_level.max(1 + self.loops[k].nesting_level);
            self.loops[l].nesting_level = lvl;
            if lvl == 0 { self.loops[l].is_root = true; }
        }
    }
}

#[derive(Clone, Copy)]
struct Uf { parent: usize, bb: Option<usize>, lp: Option<usize>, dfs: usize }

struct Finder<'a> {
    cfg: &'a Cfg, lsg: &'a mut Lsg,
    non_back_preds: Vec<Vec<usize>>, back_preds: Vec<Vec<usize>>, number: HashMap<usize, i32>,
    header: Vec<usize>, ty: Vec<BbClass>, last: Vec<usize>, nodes: Vec<Uf>,
}

impl<'a> Finder<'a> {
    fn is_ancestor(&self, w: usize, v: usize) -> bool { w <= v && v <= self.last[w] }

    fn find_set(&mut self, n: usize) -> usize {
        let mut list = Vec::new();
        let mut node = n;
        while node != self.nodes[node].parent {
            let p = self.nodes[node].parent;
            if p != self.nodes[p].parent { list.push(node); }
            node = p;
        }
        // The reference unions each with the starting node's parent.
        let to = self.nodes[n].parent;
        for i in list { self.nodes[i].parent = to; }
        node
    }

    fn do_dfs(&mut self, current_node: usize, current: usize) -> usize {
        self.nodes[current] = Uf { parent: current, bb: Some(current_node), lp: None, dfs: current };
        self.number.insert(current_node, current as i32);
        let mut last_id = current;
        let outs = self.cfg.blocks[current_node].as_ref().unwrap().out_edges.clone();
        for target in outs {
            if self.number[&target] == UNVISITED { last_id = self.do_dfs(target, last_id + 1); }
        }
        self.last[current] = last_id;
        last_id
    }

    fn find_loops(&mut self) {
        let start = match self.cfg.start { None => return, Some(s) => s };
        let size = self.cfg.num_nodes();
        self.non_back_preds = vec![Vec::new(); size];
        self.back_preds = vec![Vec::new(); size];
        self.number.clear();
        self.header = vec![0; size];
        self.ty = vec![BbClass::Top; size];
        self.last = vec![0; size];
        self.nodes = vec![Uf { parent: 0, bb: None, lp: None, dfs: 0 }; size];
        for (i, b) in self.cfg.blocks.iter().enumerate() { if b.is_some() { self.number.insert(i, UNVISITED); } }
        self.do_dfs(start, 0);
        for w in 0..size {
            self.header[w] = 0;
            self.ty[w] = BbClass::NonHeader;
            match self.nodes[w].bb {
                None => self.ty[w] = BbClass::Dead,
                Some(bb) => {
                    let ins = &self.cfg.blocks[bb].as_ref().unwrap().in_edges;
                    for &nv in ins {
                        let v = self.number[&nv];
                        if v != UNVISITED {
                            let v = v as usize;
                            if self.is_ancestor(w, v) { self.back_preds[w].push(v); }
                            else if !self.non_back_preds[w].contains(&v) { self.non_back_preds[w].push(v); }
                        }
                    }
                }
            }
        }
        self.header[0] = 0;
        let mut w = size as i64 - 1;
        while w >= 0 {
            let wu = w as usize;
            let mut node_pool: Vec<usize> = Vec::new();
            if let Some(node_w) = self.nodes[wu].bb {
                // stepD
                let bps = self.back_preds[wu].clone();
                for v in bps {
                    if v != wu { let s = self.find_set(v); node_pool.push(s); } else { self.ty[wu] = BbClass::SelfLoop; }
                }
                let mut work_list: std::collections::VecDeque<usize> = node_pool.iter().copied().collect();
                if !node_pool.is_empty() { self.ty[wu] = BbClass::Reducible; }
                while let Some(x) = work_list.pop_front() {
                    if self.non_back_preds[self.nodes[x].dfs].len() > MAXNONBACKPREDS { return; }
                    // stepEProcessNonBackPreds; the set may grow while it is walked.
                    let xd = self.nodes[x].dfs;
                    let mut k = 0;
                    while k < self.non_back_preds[xd].len() {
                        let iter = self.non_back_preds[xd][k];
                        let ydash = self.find_set(iter);
                        let yd = self.nodes[ydash].dfs;
                        if !self.is_ancestor(wu, yd) {
                            self.ty[wu] = BbClass::Irreducible;
                            if !self.non_back_preds[wu].contains(&yd) { self.non_back_preds[wu].push(yd); }
                        } else if yd != wu && !node_pool.contains(&ydash) {
                            work_list.push_back(ydash);
                            node_pool.push(ydash);
                        }
                        k += 1;
                    }
                }
                if !node_pool.is_empty() || self.ty[wu] == BbClass::SelfLoop {
                    let lp = self.lsg.create_new_loop(Some(node_w));
                    let _ = self.ty[wu] != BbClass::Irreducible;
                    self.nodes[wu].lp = Some(lp);
                    for &node in node_pool.iter() {
                        self.header[self.nodes[node].dfs] = wu;
                        self.nodes[node].parent = wu;
                        match self.nodes[node].lp {
                            Some(l) => self.lsg.set_parent(l, lp),
                            None => { let b = self.nodes[node].bb.unwrap(); self.lsg.add_node(lp, b); }
                        }
                    }
                }
            }
            w -= 1;
        }
    }
}

fn find_loops(cfg: &Cfg, lsg: &mut Lsg) {
    let mut f = Finder { cfg, lsg, non_back_preds: Vec::new(), back_preds: Vec::new(), number: HashMap::new(),
                         header: Vec::new(), ty: Vec::new(), last: Vec::new(), nodes: Vec::new() };
    f.find_loops();
}

struct App { cfg: Cfg, lsg: Lsg }

impl App {
    fn build_diamond(&mut self, start: usize) -> usize {
        let bb0 = start;
        self.cfg.add_edge(bb0, bb0 + 1);
        self.cfg.add_edge(bb0, bb0 + 2);
        self.cfg.add_edge(bb0 + 1, bb0 + 3);
        self.cfg.add_edge(bb0 + 2, bb0 + 3);
        bb0 + 3
    }
    fn build_connect(&mut self, start: usize, end: usize) { self.cfg.add_edge(start, end); }
    fn build_straight(&mut self, start: usize, n: usize) -> usize {
        for i in 0..n { self.build_connect(start + i, start + i + 1); }
        start + n
    }
    fn build_base_loop(&mut self, from: usize) -> usize {
        let header = self.build_straight(from, 1);
        let diamond1 = self.build_diamond(header);
        let d11 = self.build_straight(diamond1, 1);
        let diamond2 = self.build_diamond(d11);
        let mut footer = self.build_straight(diamond2, 1);
        self.build_connect(diamond2, d11);
        self.build_connect(diamond1, header);
        self.build_connect(footer, from);
        footer = self.build_straight(footer, 1);
        footer
    }
    fn main(&mut self, num_dummy_loops: i32, find_loop_iterations: i32, par_loops: i32, ppar_loops: i32, pppar_loops: i32) -> (usize, usize) {
        self.construct_simple_cfg();
        for _ in 0..num_dummy_loops { find_loops(&self.cfg, &mut self.lsg); }
        self.construct_cfg(par_loops, ppar_loops, pppar_loops);
        find_loops(&self.cfg, &mut self.lsg);
        // The reference discards these results; their loop counts are summed
        // so no compiler can drop the work (as in the Resid port).
        let mut extra = 0;
        for _ in 0..find_loop_iterations { let mut l = Lsg::new(); find_loops(&self.cfg, &mut l); extra += l.loops.len(); }
        assert!(extra > 0 || find_loop_iterations == 0);
        self.lsg.calculate_nesting_level();
        (self.lsg.loops.len(), self.cfg.num_nodes())
    }
    fn construct_cfg(&mut self, par_loops: i32, ppar_loops: i32, pppar_loops: i32) {
        let mut n = 2;
        for _ in 0..par_loops {
            self.cfg.create_node(n + 1);
            self.build_connect(2, n + 1);
            n += 1;
            for _ in 0..ppar_loops {
                let top = n;
                n = self.build_straight(n, 1);
                for _ in 0..pppar_loops { n = self.build_base_loop(n); }
                let bottom = self.build_straight(n, 1);
                self.build_connect(n, top);
                n = bottom;
            }
            self.build_connect(n, 1);
        }
    }
    fn construct_simple_cfg(&mut self) {
        self.cfg.create_node(0);
        self.build_base_loop(0);
        self.cfg.create_node(1);
        self.cfg.add_edge(0, 2);
    }
}

pub fn inner(inner: i32) -> bool {
    let mut app = App { cfg: Cfg::new(), lsg: Lsg::new() };
    app.cfg.create_node(0);
    let r = app.main(inner, 50, 10, 10, 5);
    let (a, b) = (r.0 as i32, r.1 as i32);
    match inner {
        15000 => a == 46602 && b == 5213, 1500 => a == 6102 && b == 5213, 150 => a == 2052 && b == 5213,
        15 => a == 1647 && b == 5213, 1 => a == 1605 && b == 5213,
        _ => { println!("No verification result for {} found", inner); println!("Result is: {}, {}", a, b); false }
    }
}
