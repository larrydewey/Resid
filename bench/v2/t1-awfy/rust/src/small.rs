// The nine small Are We Fast Yet benchmarks, after the Java and C++
// references: Bounce, List, Mandelbrot, NBody, Permute, Queens, Sieve,
// Storage, Towers.
use crate::som::Random;

// ---- Bounce -----------------------------------------------------------------

struct Ball { x: i32, y: i32, x_vel: i32, y_vel: i32 }

impl Ball {
    fn new(r: &mut Random) -> Ball {
        Ball { x: r.next() % 500, y: r.next() % 500, x_vel: (r.next() % 300) - 150, y_vel: (r.next() % 300) - 150 }
    }
    fn bounce(&mut self) -> bool {
        let (x_limit, y_limit) = (500, 500);
        let mut bounced = false;
        self.x += self.x_vel;
        self.y += self.y_vel;
        if self.x > x_limit { self.x = x_limit; self.x_vel = -self.x_vel.abs(); bounced = true; }
        if self.x < 0 { self.x = 0; self.x_vel = self.x_vel.abs(); bounced = true; }
        if self.y > y_limit { self.y = y_limit; self.y_vel = -self.y_vel.abs(); bounced = true; }
        if self.y < 0 { self.y = 0; self.y_vel = self.y_vel.abs(); bounced = true; }
        bounced
    }
}

fn bounce() -> i32 {
    let mut random = Random::new();
    let ball_count = 100;
    let mut bounces = 0;
    let mut balls: Vec<Ball> = (0..ball_count).map(|_| Ball::new(&mut random)).collect();
    for _ in 0..50 {
        for ball in balls.iter_mut() {
            if ball.bounce() { bounces += 1; }
        }
    }
    bounces
}

pub fn bounce_inner(inner: i32) -> bool { (0..inner).all(|_| bounce() == 1331) }

// ---- List -------------------------------------------------------------------
// The lists live in the caller; tail returns references into them.

struct Element { val: i32, next: Option<Box<Element>> }

fn length(e: &Element) -> i32 { match &e.next { None => 1, Some(n) => 1 + length(n) } }

fn make_list(length: i32) -> Option<Box<Element>> {
    if length == 0 { return None; }
    Some(Box::new(Element { val: length, next: make_list(length - 1) }))
}

fn is_shorter_than(x: Option<&Element>, y: Option<&Element>) -> bool {
    let mut x_tail = x;
    let mut y_tail = y;
    while let Some(y_e) = y_tail {
        match x_tail {
            None => return true,
            Some(x_e) => { x_tail = x_e.next.as_deref(); }
        }
        y_tail = y_e.next.as_deref();
    }
    false
}

fn tail<'a>(x: Option<&'a Element>, y: Option<&'a Element>, z: Option<&'a Element>) -> Option<&'a Element> {
    if is_shorter_than(y, x) {
        let xn = x.unwrap().next.as_deref();
        let yn = y.unwrap().next.as_deref();
        let zn = z.unwrap().next.as_deref();
        tail(tail(xn, y, z), tail(yn, z, x), tail(zn, x, y))
    } else {
        z
    }
}

fn list() -> i32 {
    let (a, b, c) = (make_list(15), make_list(10), make_list(6));
    let r = tail(a.as_deref(), b.as_deref(), c.as_deref()).unwrap();
    let _ = r.val;
    length(r)
}

pub fn list_inner(inner: i32) -> bool { (0..inner).all(|_| list() == 10) }

// ---- Mandelbrot -------------------------------------------------------------

fn mandelbrot(size: i32) -> i32 {
    let mut sum = 0;
    let mut byte_acc = 0;
    let mut bit_num = 0;
    let mut y = 0;
    while y < size {
        let ci = (2.0 * y as f64 / size as f64) - 1.0;
        let mut x = 0;
        while x < size {
            let mut zrzr = 0.0;
            let mut zi = 0.0;
            let mut zizi = 0.0;
            let cr = (2.0 * x as f64 / size as f64) - 1.5;
            let mut z = 0;
            let mut not_done = true;
            let mut escape = 0;
            while not_done && z < 50 {
                let zr = zrzr - zizi + cr;
                zi = 2.0 * zr * zi + ci;
                zrzr = zr * zr;
                zizi = zi * zi;
                if zrzr + zizi > 4.0 { not_done = false; escape = 1; }
                z += 1;
            }
            byte_acc = (byte_acc << 1) + escape;
            bit_num += 1;
            if bit_num == 8 {
                sum ^= byte_acc;
                byte_acc = 0;
                bit_num = 0;
            } else if x == size - 1 {
                byte_acc <<= 8 - bit_num;
                sum ^= byte_acc;
                byte_acc = 0;
                bit_num = 0;
            }
            x += 1;
        }
        y += 1;
    }
    sum
}

pub fn mandelbrot_inner(inner: i32) -> bool {
    let r = mandelbrot(inner);
    match inner {
        500 => r == 191,
        750 => r == 50,
        1 => r == 128,
        _ => { println!("No verification result for {} found", inner); println!("Result is: {}", r); false }
    }
}

// ---- NBody ------------------------------------------------------------------

const PI: f64 = 3.141592653589793;
const SOLAR_MASS: f64 = 4.0 * PI * PI;
const DAYS_PER_YER: f64 = 365.24;

struct Body { x: f64, y: f64, z: f64, vx: f64, vy: f64, vz: f64, mass: f64 }

impl Body {
    fn new(x: f64, y: f64, z: f64, vx: f64, vy: f64, vz: f64, mass: f64) -> Body {
        Body { x, y, z, vx: vx * DAYS_PER_YER, vy: vy * DAYS_PER_YER, vz: vz * DAYS_PER_YER, mass: mass * SOLAR_MASS }
    }
    fn offset_momentum(&mut self, px: f64, py: f64, pz: f64) {
        self.vx = 0.0 - (px / SOLAR_MASS);
        self.vy = 0.0 - (py / SOLAR_MASS);
        self.vz = 0.0 - (pz / SOLAR_MASS);
    }
}

fn create_bodies() -> Vec<Body> {
    let mut bodies = vec![
        Body::new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0),
        Body::new(4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
                  1.66007664274403694e-03, 7.69901118419740425e-03, -6.90460016972063023e-05, 9.54791938424326609e-04),
        Body::new(8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
                  -2.76742510726862411e-03, 4.99852801234917238e-03, 2.30417297573763929e-05, 2.85885980666130812e-04),
        Body::new(1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
                  2.96460137564761618e-03, 2.37847173959480950e-03, -2.96589568540237556e-05, 4.36624404335156298e-05),
        Body::new(1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
                  2.68067772490389322e-03, 1.62824170038242295e-03, -9.51592254519715870e-05, 5.15138902046611451e-05),
    ];
    let (mut px, mut py, mut pz) = (0.0, 0.0, 0.0);
    for b in bodies.iter() {
        px += b.vx * b.mass;
        py += b.vy * b.mass;
        pz += b.vz * b.mass;
    }
    bodies[0].offset_momentum(px, py, pz);
    bodies
}

fn advance(bodies: &mut [Body], dt: f64) {
    let n = bodies.len();
    for i in 0..n {
        for j in (i + 1)..n {
            let (left, right) = bodies.split_at_mut(j);
            let ib = &mut left[i];
            let jb = &mut right[0];
            let dx = ib.x - jb.x;
            let dy = ib.y - jb.y;
            let dz = ib.z - jb.z;
            let d_squared = dx * dx + dy * dy + dz * dz;
            let distance = d_squared.sqrt();
            let mag = dt / (d_squared * distance);
            ib.vx = ib.vx - (dx * jb.mass * mag);
            ib.vy = ib.vy - (dy * jb.mass * mag);
            ib.vz = ib.vz - (dz * jb.mass * mag);
            jb.vx = jb.vx + (dx * ib.mass * mag);
            jb.vy = jb.vy + (dy * ib.mass * mag);
            jb.vz = jb.vz + (dz * ib.mass * mag);
        }
    }
    for b in bodies.iter_mut() {
        b.x = b.x + dt * b.vx;
        b.y = b.y + dt * b.vy;
        b.z = b.z + dt * b.vz;
    }
}

fn energy(bodies: &[Body]) -> f64 {
    let mut e = 0.0;
    for i in 0..bodies.len() {
        let ib = &bodies[i];
        e += 0.5 * ib.mass * (ib.vx * ib.vx + ib.vy * ib.vy + ib.vz * ib.vz);
        for j in (i + 1)..bodies.len() {
            let jb = &bodies[j];
            let dx = ib.x - jb.x;
            let dy = ib.y - jb.y;
            let dz = ib.z - jb.z;
            let distance = (dx * dx + dy * dy + dz * dz).sqrt();
            e -= (ib.mass * jb.mass) / distance;
        }
    }
    e
}

pub fn nbody_inner(inner: i32) -> bool {
    let mut system = create_bodies();
    for _ in 0..inner { advance(&mut system, 0.01); }
    let r = energy(&system);
    match inner {
        250000 => r == -0.1690859889909308,
        1 => r == -0.16907495402506745,
        _ => { println!("No verification result for {} found", inner); println!("Result is: {}", r); false }
    }
}

// ---- Permute ----------------------------------------------------------------

struct Permute { count: i32, v: Vec<i32> }

impl Permute {
    fn permute(&mut self, n: i32) {
        self.count += 1;
        if n != 0 {
            let n1 = n - 1;
            self.permute(n1);
            let mut i = n1;
            while i >= 0 {
                self.swap(n1, i);
                self.permute(n1);
                self.swap(n1, i);
                i -= 1;
            }
        }
    }
    fn swap(&mut self, i: i32, j: i32) { self.v.swap(i as usize, j as usize); }
}

pub fn permute_inner(inner: i32) -> bool {
    (0..inner).all(|_| {
        let mut p = Permute { count: 0, v: vec![0; 6] };
        p.permute(6);
        p.count == 8660
    })
}

// ---- Queens -----------------------------------------------------------------

struct Queens { free_maxs: Vec<bool>, free_rows: Vec<bool>, free_mins: Vec<bool>, queen_rows: Vec<i32> }

impl Queens {
    fn queens(&mut self) -> bool {
        self.free_rows = vec![true; 8];
        self.free_maxs = vec![true; 16];
        self.free_mins = vec![true; 16];
        self.queen_rows = vec![-1; 8];
        self.place_queen(0)
    }
    fn place_queen(&mut self, c: i32) -> bool {
        for r in 0..8 {
            if self.get_row_column(r, c) {
                self.queen_rows[r as usize] = c;
                self.set_row_column(r, c, false);
                if c == 7 { return true; }
                if self.place_queen(c + 1) { return true; }
                self.set_row_column(r, c, true);
            }
        }
        false
    }
    fn get_row_column(&self, r: i32, c: i32) -> bool {
        self.free_rows[r as usize] && self.free_maxs[(c + r) as usize] && self.free_mins[(c - r + 7) as usize]
    }
    fn set_row_column(&mut self, r: i32, c: i32, v: bool) {
        self.free_rows[r as usize] = v;
        self.free_maxs[(c + r) as usize] = v;
        self.free_mins[(c - r + 7) as usize] = v;
    }
}

fn queens() -> bool {
    let mut q = Queens { free_maxs: vec![], free_rows: vec![], free_mins: vec![], queen_rows: vec![] };
    let mut result = true;
    for _ in 0..10 { result = result && q.queens(); }
    result
}

pub fn queens_inner(inner: i32) -> bool { (0..inner).all(|_| queens()) }

// ---- Sieve ------------------------------------------------------------------

fn sieve(flags: &mut [bool], size: i32) -> i32 {
    let mut prime_count = 0;
    for i in 2..=size {
        if flags[(i - 1) as usize] {
            prime_count += 1;
            let mut k = i + i;
            while k <= size {
                flags[(k - 1) as usize] = false;
                k += i;
            }
        }
    }
    prime_count
}

pub fn sieve_inner(inner: i32) -> bool {
    (0..inner).all(|_| {
        let mut flags = vec![true; 5000];
        sieve(&mut flags, 5000) == 669
    })
}

// ---- Storage ----------------------------------------------------------------

#[allow(dead_code)]
enum Tree { Node(Vec<Tree>), Leaf(Vec<Option<Box<Tree>>>) }

fn build_tree_depth(depth: i32, random: &mut Random, count: &mut i32) -> Tree {
    *count += 1;
    if depth == 1 {
        let n = (random.next() % 10 + 1) as usize;
        Tree::Leaf((0..n).map(|_| None).collect())
    } else {
        Tree::Node((0..4).map(|_| build_tree_depth(depth - 1, random, count)).collect())
    }
}

pub fn storage_inner(inner: i32) -> bool {
    (0..inner).all(|_| {
        let mut random = Random::new();
        let mut count = 0;
        let _t = build_tree_depth(7, &mut random, &mut count);
        count == 5461
    })
}

// ---- Towers -----------------------------------------------------------------

struct TowersDisk { size: i32, next: Option<Box<TowersDisk>> }

struct Towers { piles: Vec<Option<Box<TowersDisk>>>, moves_done: i32 }

impl Towers {
    fn push_disk(&mut self, mut disk: Box<TowersDisk>, pile: usize) {
        if let Some(top) = &self.piles[pile] {
            if disk.size >= top.size { panic!("Cannot put a big disk on a smaller one"); }
        }
        disk.next = self.piles[pile].take();
        self.piles[pile] = Some(disk);
    }
    fn pop_disk_from(&mut self, pile: usize) -> Box<TowersDisk> {
        let mut top = self.piles[pile].take().expect("Attempting to remove a disk from an empty pile");
        self.piles[pile] = top.next.take();
        top
    }
    fn move_top_disk(&mut self, from: usize, to: usize) {
        let d = self.pop_disk_from(from);
        self.push_disk(d, to);
        self.moves_done += 1;
    }
    fn build_tower_at(&mut self, pile: usize, disks: i32) {
        let mut i = disks;
        while i >= 0 {
            self.push_disk(Box::new(TowersDisk { size: i, next: None }), pile);
            i -= 1;
        }
    }
    fn move_disks(&mut self, disks: i32, from: usize, to: usize) {
        if disks == 1 {
            self.move_top_disk(from, to);
        } else {
            let other = (3 - from) - to;
            self.move_disks(disks - 1, from, other);
            self.move_top_disk(from, to);
            self.move_disks(disks - 1, other, to);
        }
    }
}

pub fn towers_inner(inner: i32) -> bool {
    (0..inner).all(|_| {
        let mut t = Towers { piles: vec![None, None, None], moves_done: 0 };
        t.build_tower_at(0, 13);
        t.moves_done = 0;
        t.move_disks(13, 0, 1);
        t.moves_done == 8191
    })
}
