// AWFY CD, after the Java reference: collision detection over red-black
// trees. The generic tree keeps its nodes in an arena with index links and
// parent pointers, as the reference's nodes do.
use std::cmp::Ordering;

const MIN_X: f64 = 0.0;
const MIN_Y: f64 = 0.0;
const MAX_X: f64 = 1000.0;
const MAX_Y: f64 = 1000.0;
const MIN_Z: f64 = 0.0;
const MAX_Z: f64 = 10.0;
const PROXIMITY_RADIUS: f64 = 1.0;
const GOOD_VOXEL_SIZE: f64 = PROXIMITY_RADIUS * 2.0;

#[derive(Clone, Copy)]
struct V3 { x: f64, y: f64, z: f64 }
impl V3 {
    fn plus(self, o: V3) -> V3 { V3 { x: self.x + o.x, y: self.y + o.y, z: self.z + o.z } }
    fn minus(self, o: V3) -> V3 { V3 { x: self.x - o.x, y: self.y - o.y, z: self.z - o.z } }
    fn dot(self, o: V3) -> f64 { self.x * o.x + self.y * o.y + self.z * o.z }
    fn squared_magnitude(self) -> f64 { self.dot(self) }
    fn magnitude(self) -> f64 { self.squared_magnitude().sqrt() }
    fn times(self, a: f64) -> V3 { V3 { x: self.x * a, y: self.y * a, z: self.z * a } }
}

#[derive(Clone, Copy)]
struct V2 { x: f64, y: f64 }
impl V2 {
    fn plus(self, o: V2) -> V2 { V2 { x: self.x + o.x, y: self.y + o.y } }
    fn minus(self, o: V2) -> V2 { V2 { x: self.x - o.x, y: self.y - o.y } }
}

fn compare_numbers(a: f64, b: f64) -> Ordering {
    if a == b { return Ordering::Equal; }
    if a < b { return Ordering::Less; }
    if a > b { return Ordering::Greater; }
    if a == a { return Ordering::Greater; }
    Ordering::Less
}

trait Key: Copy { fn cmp_key(&self, o: &Self) -> Ordering; }
impl Key for V2 {
    fn cmp_key(&self, o: &V2) -> Ordering {
        match compare_numbers(self.x, o.x) { Ordering::Equal => compare_numbers(self.y, o.y), r => r }
    }
}
impl Key for i32 { fn cmp_key(&self, o: &i32) -> Ordering { self.cmp(o) } }

const NIL: usize = usize::MAX;

struct Node<K, V> { key: K, value: V, left: usize, right: usize, parent: usize, red: bool }

struct Rbt<K, V> { nodes: Vec<Node<K, V>>, root: usize }

impl<K: Key, V: Clone> Rbt<K, V> {
    fn new() -> Self { Rbt { nodes: Vec::new(), root: NIL } }
    fn is_red(&self, i: usize) -> bool { i != NIL && self.nodes[i].red }
    fn tree_minimum(&self, x: usize) -> usize {
        let mut c = x;
        while self.nodes[c].left != NIL { c = self.nodes[c].left; }
        c
    }
    fn successor(&self, x0: usize) -> usize {
        let mut x = x0;
        if self.nodes[x].right != NIL { return self.tree_minimum(self.nodes[x].right); }
        let mut y = self.nodes[x].parent;
        while y != NIL && x == self.nodes[y].right { x = y; y = self.nodes[y].parent; }
        y
    }
    fn find_node(&self, key: &K) -> usize {
        let mut c = self.root;
        while c != NIL {
            match key.cmp_key(&self.nodes[c].key) {
                Ordering::Equal => return c,
                Ordering::Less => c = self.nodes[c].left,
                Ordering::Greater => c = self.nodes[c].right,
            }
        }
        NIL
    }
    fn get(&self, key: &K) -> Option<V> {
        let n = self.find_node(key);
        if n == NIL { None } else { Some(self.nodes[n].value.clone()) }
    }
    // treeInsert: (new entry, the new node, the old value)
    fn tree_insert(&mut self, key: K, value: V) -> (bool, usize, Option<V>) {
        let mut y = NIL;
        let mut x = self.root;
        while x != NIL {
            y = x;
            match key.cmp_key(&self.nodes[x].key) {
                Ordering::Less => x = self.nodes[x].left,
                Ordering::Greater => x = self.nodes[x].right,
                Ordering::Equal => {
                    let old = std::mem::replace(&mut self.nodes[x].value, value);
                    return (false, NIL, Some(old));
                }
            }
        }
        self.nodes.push(Node { key, value, left: NIL, right: NIL, parent: y, red: true });
        let z = self.nodes.len() - 1;
        if y == NIL { self.root = z; }
        else if key.cmp_key(&self.nodes[y].key) == Ordering::Less { self.nodes[y].left = z; }
        else { self.nodes[y].right = z; }
        (true, z, None)
    }
    fn left_rotate(&mut self, x: usize) -> usize {
        let y = self.nodes[x].right;
        self.nodes[x].right = self.nodes[y].left;
        if self.nodes[y].left != NIL { let yl = self.nodes[y].left; self.nodes[yl].parent = x; }
        self.nodes[y].parent = self.nodes[x].parent;
        let xp = self.nodes[x].parent;
        if xp == NIL { self.root = y; }
        else if x == self.nodes[xp].left { self.nodes[xp].left = y; }
        else { self.nodes[xp].right = y; }
        self.nodes[y].left = x;
        self.nodes[x].parent = y;
        y
    }
    fn right_rotate(&mut self, y: usize) -> usize {
        let x = self.nodes[y].left;
        self.nodes[y].left = self.nodes[x].right;
        if self.nodes[x].right != NIL { let xr = self.nodes[x].right; self.nodes[xr].parent = y; }
        self.nodes[x].parent = self.nodes[y].parent;
        let yp = self.nodes[y].parent;
        if yp == NIL { self.root = x; }
        else if y == self.nodes[yp].left { self.nodes[yp].left = x; }
        else { self.nodes[yp].right = x; }
        self.nodes[x].right = y;
        self.nodes[y].parent = x;
        x
    }
    fn put(&mut self, key: K, value: V) -> Option<V> {
        let (is_new, z, old) = self.tree_insert(key, value);
        if !is_new { return old; }
        let mut x = z;
        while x != self.root && self.is_red(self.nodes[x].parent) {
            let xp = self.nodes[x].parent;
            let xpp = self.nodes[xp].parent;
            if xp == self.nodes[xpp].left {
                let y = self.nodes[xpp].right;
                if self.is_red(y) {
                    self.nodes[xp].red = false;
                    self.nodes[y].red = false;
                    self.nodes[xpp].red = true;
                    x = xpp;
                } else {
                    if x == self.nodes[xp].right { x = xp; self.left_rotate(x); }
                    let p = self.nodes[x].parent;
                    let pp = self.nodes[p].parent;
                    self.nodes[p].red = false;
                    self.nodes[pp].red = true;
                    self.right_rotate(pp);
                }
            } else {
                let y = self.nodes[xpp].left;
                if self.is_red(y) {
                    self.nodes[xp].red = false;
                    self.nodes[y].red = false;
                    self.nodes[xpp].red = true;
                    x = xpp;
                } else {
                    if x == self.nodes[xp].left { x = xp; self.right_rotate(x); }
                    let p = self.nodes[x].parent;
                    let pp = self.nodes[p].parent;
                    self.nodes[p].red = false;
                    self.nodes[pp].red = true;
                    self.left_rotate(pp);
                }
            }
        }
        let r = self.root;
        self.nodes[r].red = false;
        None
    }
    fn remove(&mut self, key: &K) -> Option<V> {
        let z = self.find_node(key);
        if z == NIL { return None; }
        let y = if self.nodes[z].left == NIL || self.nodes[z].right == NIL { z } else { self.successor(z) };
        let x = if self.nodes[y].left != NIL { self.nodes[y].left } else { self.nodes[y].right };
        let x_parent;
        if x != NIL { self.nodes[x].parent = self.nodes[y].parent; x_parent = self.nodes[x].parent; }
        else { x_parent = self.nodes[y].parent; }
        let yp = self.nodes[y].parent;
        if yp == NIL { self.root = x; }
        else if y == self.nodes[yp].left { self.nodes[yp].left = x; }
        else { self.nodes[yp].right = x; }
        if y != z {
            if !self.nodes[y].red { self.remove_fixup(x, x_parent); }
            self.nodes[y].parent = self.nodes[z].parent;
            self.nodes[y].red = self.nodes[z].red;
            self.nodes[y].left = self.nodes[z].left;
            self.nodes[y].right = self.nodes[z].right;
            if self.nodes[z].left != NIL { let l = self.nodes[z].left; self.nodes[l].parent = y; }
            if self.nodes[z].right != NIL { let r = self.nodes[z].right; self.nodes[r].parent = y; }
            let zp = self.nodes[z].parent;
            if zp != NIL {
                if self.nodes[zp].left == z { self.nodes[zp].left = y; } else { self.nodes[zp].right = y; }
            } else { self.root = y; }
        } else if !self.nodes[y].red {
            self.remove_fixup(x, x_parent);
        }
        Some(self.nodes[z].value.clone())
    }
    fn remove_fixup(&mut self, mut x: usize, mut x_parent: usize) {
        while x != self.root && (x == NIL || !self.nodes[x].red) {
            if x == self.nodes[x_parent].left {
                let mut w = self.nodes[x_parent].right;
                if self.nodes[w].red {
                    self.nodes[w].red = false;
                    self.nodes[x_parent].red = true;
                    self.left_rotate(x_parent);
                    w = self.nodes[x_parent].right;
                }
                if !self.is_red(self.nodes[w].left) && !self.is_red(self.nodes[w].right) {
                    self.nodes[w].red = true;
                    x = x_parent;
                    x_parent = self.nodes[x].parent;
                } else {
                    if !self.is_red(self.nodes[w].right) {
                        let wl = self.nodes[w].left;
                        self.nodes[wl].red = false;
                        self.nodes[w].red = true;
                        self.right_rotate(w);
                        w = self.nodes[x_parent].right;
                    }
                    self.nodes[w].red = self.nodes[x_parent].red;
                    self.nodes[x_parent].red = false;
                    if self.nodes[w].right != NIL { let wr = self.nodes[w].right; self.nodes[wr].red = false; }
                    self.left_rotate(x_parent);
                    x = self.root;
                    x_parent = self.nodes[x].parent;
                }
            } else {
                let mut w = self.nodes[x_parent].left;
                if self.nodes[w].red {
                    self.nodes[w].red = false;
                    self.nodes[x_parent].red = true;
                    self.right_rotate(x_parent);
                    w = self.nodes[x_parent].left;
                }
                if !self.is_red(self.nodes[w].right) && !self.is_red(self.nodes[w].left) {
                    self.nodes[w].red = true;
                    x = x_parent;
                    x_parent = self.nodes[x].parent;
                } else {
                    if !self.is_red(self.nodes[w].left) {
                        let wr = self.nodes[w].right;
                        self.nodes[wr].red = false;
                        self.nodes[w].red = true;
                        self.left_rotate(w);
                        w = self.nodes[x_parent].left;
                    }
                    self.nodes[w].red = self.nodes[x_parent].red;
                    self.nodes[x_parent].red = false;
                    if self.nodes[w].left != NIL { let wl = self.nodes[w].left; self.nodes[wl].red = false; }
                    self.right_rotate(x_parent);
                    x = self.root;
                    x_parent = self.nodes[x].parent;
                }
            }
        }
        if x != NIL { self.nodes[x].red = false; }
    }
    // forEach over entries, in order.
    fn for_each<F: FnMut(&K, &V)>(&self, mut f: F) {
        if self.root == NIL { return; }
        let mut c = self.tree_minimum(self.root);
        while c != NIL {
            f(&self.nodes[c].key, &self.nodes[c].value);
            c = self.successor(c);
        }
    }
}

#[derive(Clone, Copy)]
struct Motion { callsign: i32, pos_one: V3, pos_two: V3 }

impl Motion {
    fn delta(&self) -> V3 { self.pos_two.minus(self.pos_one) }
    fn find_intersection(&self, other: &Motion) -> Option<V3> {
        let init1 = self.pos_one;
        let init2 = other.pos_one;
        let vec1 = self.delta();
        let vec2 = other.delta();
        let radius = PROXIMITY_RADIUS;
        let a = vec2.minus(vec1).squared_magnitude();
        if a != 0.0 {
            let b = 2.0 * init1.minus(init2).dot(vec1.minus(vec2));
            let c = -radius * radius + init2.minus(init1).squared_magnitude();
            let discr = b * b - 4.0 * a * c;
            if discr < 0.0 { return None; }
            let v1 = (-b - discr.sqrt()) / (2.0 * a);
            let v2 = (-b + discr.sqrt()) / (2.0 * a);
            if v1 <= v2 && ((v1 <= 1.0 && 1.0 <= v2) || (v1 <= 0.0 && 0.0 <= v2) || (0.0 <= v1 && v2 <= 1.0)) {
                let v = if v1 <= 0.0 { 0.0 } else { v1 };
                let result1 = init1.plus(vec1.times(v));
                let result2 = init2.plus(vec2.times(v));
                let result = result1.plus(result2).times(0.5);
                if result.x >= MIN_X && result.x <= MAX_X && result.y >= MIN_Y && result.y <= MAX_Y
                    && result.z >= MIN_Z && result.z <= MAX_Z {
                    return Some(result);
                }
            }
            return None;
        }
        let dist = init2.minus(init1).magnitude();
        if dist <= radius { return Some(init1.plus(init2).times(0.5)); }
        None
    }
}

struct Aircraft { callsign: i32, position: V3 }
#[allow(dead_code)]
struct Collision { a: i32, b: i32, position: V3 }

fn is_in_voxel(voxel: V2, motion: &Motion) -> bool {
    if voxel.x > MAX_X || voxel.x < MIN_X || voxel.y > MAX_Y || voxel.y < MIN_Y { return false; }
    let init = motion.pos_one;
    let fin = motion.pos_two;
    let v_s = GOOD_VOXEL_SIZE;
    let r = PROXIMITY_RADIUS / 2.0;
    let v_x = voxel.x;
    let x0 = init.x;
    let xv = fin.x - init.x;
    let v_y = voxel.y;
    let y0 = init.y;
    let yv = fin.y - init.y;
    let mut low_x = (v_x - r - x0) / xv;
    let mut high_x = (v_x + v_s + r - x0) / xv;
    if xv < 0.0 { std::mem::swap(&mut low_x, &mut high_x); }
    let mut low_y = (v_y - r - y0) / yv;
    let mut high_y = (v_y + v_s + r - y0) / yv;
    if yv < 0.0 { std::mem::swap(&mut low_y, &mut high_y); }
    ((xv == 0.0 && v_x <= x0 + r && x0 - r <= v_x + v_s)
        || (low_x <= 1.0 && 1.0 <= high_x) || (low_x <= 0.0 && 0.0 <= high_x) || (0.0 <= low_x && high_x <= 1.0))
        && ((yv == 0.0 && v_y <= y0 + r && y0 - r <= v_y + v_s)
            || ((low_y <= 1.0 && 1.0 <= high_y) || (low_y <= 0.0 && 0.0 <= high_y) || (0.0 <= low_y && high_y <= 1.0)))
        && (xv == 0.0 || yv == 0.0
            || (low_y <= high_x && high_x <= high_y) || (low_y <= low_x && low_x <= high_y) || (low_x <= low_y && high_y <= high_x))
}

const HORIZONTAL: V2 = V2 { x: GOOD_VOXEL_SIZE, y: 0.0 };
const VERTICAL: V2 = V2 { x: 0.0, y: GOOD_VOXEL_SIZE };

fn put_into_map(voxel_map: &mut Rbt<V2, Vec<Motion>>, voxel: V2, motion: &Motion) {
    // The reference appends to the vector in the map; with values held in
    // the tree, the vector is taken out, extended and put back.
    let n = voxel_map.find_node(&voxel);
    if n == NIL { voxel_map.put(voxel, vec![*motion]); } else { voxel_map.nodes[n].value.push(*motion); }
}

fn recurse(voxel_map: &mut Rbt<V2, Vec<Motion>>, seen: &mut Rbt<V2, bool>, next: V2, motion: &Motion) {
    if !is_in_voxel(next, motion) { return; }
    if seen.put(next, true) == Some(true) { return; }
    put_into_map(voxel_map, next, motion);
    recurse(voxel_map, seen, next.minus(HORIZONTAL), motion);
    recurse(voxel_map, seen, next.plus(HORIZONTAL), motion);
    recurse(voxel_map, seen, next.minus(VERTICAL), motion);
    recurse(voxel_map, seen, next.plus(VERTICAL), motion);
    recurse(voxel_map, seen, next.minus(HORIZONTAL).minus(VERTICAL), motion);
    recurse(voxel_map, seen, next.minus(HORIZONTAL).plus(VERTICAL), motion);
    recurse(voxel_map, seen, next.plus(HORIZONTAL).minus(VERTICAL), motion);
    recurse(voxel_map, seen, next.plus(HORIZONTAL).plus(VERTICAL), motion);
}

fn voxel_hash(p: V3) -> V2 {
    let x_div = (p.x / GOOD_VOXEL_SIZE) as i32;
    let y_div = (p.y / GOOD_VOXEL_SIZE) as i32;
    let mut x = GOOD_VOXEL_SIZE * x_div as f64;
    let mut y = GOOD_VOXEL_SIZE * y_div as f64;
    if p.x < 0.0 { x -= GOOD_VOXEL_SIZE; }
    if p.y < 0.0 { y -= GOOD_VOXEL_SIZE; }
    V2 { x, y }
}

fn reduce_collision_set(motions: &[Motion]) -> Vec<Vec<Motion>> {
    let mut voxel_map: Rbt<V2, Vec<Motion>> = Rbt::new();
    for m in motions {
        let mut seen: Rbt<V2, bool> = Rbt::new();
        recurse(&mut voxel_map, &mut seen, voxel_hash(m.pos_one), m);
    }
    let mut result = Vec::new();
    voxel_map.for_each(|_, v| if v.len() > 1 { result.push(v.clone()); });
    result
}

struct Detector { state: Rbt<i32, V3> }

impl Detector {
    fn handle_new_frame(&mut self, frame: &[Aircraft]) -> Vec<Collision> {
        let mut motions = Vec::new();
        let mut seen: Rbt<i32, bool> = Rbt::new();
        for a in frame {
            let old = self.state.put(a.callsign, a.position);
            let new = a.position;
            seen.put(a.callsign, true);
            motions.push(Motion { callsign: a.callsign, pos_one: old.unwrap_or(new), pos_two: new });
        }
        let mut to_remove = Vec::new();
        self.state.for_each(|k, _| if seen.get(k) != Some(true) { to_remove.push(*k); });
        for k in to_remove { self.state.remove(&k); }
        let all_reduced = reduce_collision_set(&motions);
        let mut collisions = Vec::new();
        for reduced in all_reduced {
            for i in 0..reduced.len() {
                let m1 = &reduced[i];
                for j in (i + 1)..reduced.len() {
                    let m2 = &reduced[j];
                    if let Some(c) = m1.find_intersection(m2) {
                        collisions.push(Collision { a: m1.callsign, b: m2.callsign, position: c });
                    }
                }
            }
        }
        collisions
    }
}

fn simulate(n: i32, time: f64) -> Vec<Aircraft> {
    let mut frame = Vec::new();
    let mut i = 0;
    while i < n {
        frame.push(Aircraft { callsign: i, position: V3 { x: time, y: time.cos() * 2.0 + (i * 3) as f64, z: 10.0 } });
        frame.push(Aircraft { callsign: i + 1, position: V3 { x: time, y: time.sin() * 2.0 + (i * 3) as f64, z: 10.0 } });
        i += 2;
    }
    frame
}

fn benchmark(n: i32) -> i32 {
    let mut d = Detector { state: Rbt::new() };
    let mut actual = 0;
    for i in 0..200 {
        let time = i as f64 / 10.0;
        actual += d.handle_new_frame(&simulate(n, time)).len() as i32;
    }
    actual
}

pub fn inner(inner: i32) -> bool {
    let c = benchmark(inner);
    match inner {
        1000 => c == 14484, 500 => c == 14484, 250 => c == 10830, 200 => c == 8655,
        100 => c == 4305, 10 => c == 390, 2 => c == 42,
        _ => { println!("No verification result for {} found", inner); println!("Result is: {}", c); false }
    }
}
