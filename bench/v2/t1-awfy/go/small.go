// The nine small Are We Fast Yet benchmarks, after the Java reference.
package main

import "math"

// ---- Bounce -----------------------------------------------------------------

type ball struct{ x, y, xVel, yVel int }

func newBall(r *Random) *ball {
	return &ball{x: r.next() % 500, y: r.next() % 500, xVel: (r.next() % 300) - 150, yVel: (r.next() % 300) - 150}
}

func abs(a int) int {
	if a < 0 {
		return -a
	}
	return a
}

func (b *ball) bounce() bool {
	xLimit, yLimit := 500, 500
	bounced := false
	b.x += b.xVel
	b.y += b.yVel
	if b.x > xLimit {
		b.x = xLimit
		b.xVel = 0 - abs(b.xVel)
		bounced = true
	}
	if b.x < 0 {
		b.x = 0
		b.xVel = abs(b.xVel)
		bounced = true
	}
	if b.y > yLimit {
		b.y = yLimit
		b.yVel = 0 - abs(b.yVel)
		bounced = true
	}
	if b.y < 0 {
		b.y = 0
		b.yVel = abs(b.yVel)
		bounced = true
	}
	return bounced
}

func bounceBench() int {
	random := newRandom()
	ballCount := 100
	bounces := 0
	balls := make([]*ball, ballCount)
	for i := range balls {
		balls[i] = newBall(random)
	}
	for i := 0; i < 50; i++ {
		for _, b := range balls {
			if b.bounce() {
				bounces++
			}
		}
	}
	return bounces
}

func bounceInner(inner int) bool {
	for i := 0; i < inner; i++ {
		if bounceBench() != 1331 {
			return false
		}
	}
	return true
}

// ---- List -------------------------------------------------------------------

type element struct {
	val  int
	next *element
}

func (e *element) length() int {
	if e.next == nil {
		return 1
	}
	return 1 + e.next.length()
}

func makeList(length int) *element {
	if length == 0 {
		return nil
	}
	return &element{val: length, next: makeList(length - 1)}
}

func isShorterThan(x, y *element) bool {
	xTail, yTail := x, y
	for yTail != nil {
		if xTail == nil {
			return true
		}
		xTail = xTail.next
		yTail = yTail.next
	}
	return false
}

func tail(x, y, z *element) *element {
	if isShorterThan(y, x) {
		return tail(tail(x.next, y, z), tail(y.next, z, x), tail(z.next, x, y))
	}
	return z
}

func listInner(inner int) bool {
	for i := 0; i < inner; i++ {
		if tail(makeList(15), makeList(10), makeList(6)).length() != 10 {
			return false
		}
	}
	return true
}

// ---- Mandelbrot -------------------------------------------------------------

func mandelbrot(size int) int {
	sum, byteAcc, bitNum := 0, 0, 0
	for y := 0; y < size; y++ {
		ci := (2.0 * float64(y) / float64(size)) - 1.0
		for x := 0; x < size; x++ {
			zrzr, zi, zizi := 0.0, 0.0, 0.0
			cr := (2.0 * float64(x) / float64(size)) - 1.5
			z := 0
			notDone := true
			escape := 0
			for notDone && z < 50 {
				zr := zrzr - zizi + cr
				zi = 2.0*zr*zi + ci
				zrzr = zr * zr
				zizi = zi * zi
				if zrzr+zizi > 4.0 {
					notDone = false
					escape = 1
				}
				z++
			}
			byteAcc = (byteAcc << 1) + escape
			bitNum++
			if bitNum == 8 {
				sum ^= byteAcc
				byteAcc = 0
				bitNum = 0
			} else if x == size-1 {
				byteAcc <<= uint(8 - bitNum)
				sum ^= byteAcc
				byteAcc = 0
				bitNum = 0
			}
		}
	}
	return sum
}

func mandelbrotInner(inner int) bool {
	r := mandelbrot(inner)
	switch inner {
	case 500:
		return r == 191
	case 750:
		return r == 50
	case 1:
		return r == 128
	}
	println("No verification result for", inner, "found; result", r)
	return false
}

// ---- NBody ------------------------------------------------------------------

const solarMass = 4 * math.Pi * math.Pi
const daysPerYear = 365.24

type body struct{ x, y, z, vx, vy, vz, mass float64 }

func newBody(x, y, z, vx, vy, vz, mass float64) *body {
	return &body{x, y, z, vx * daysPerYear, vy * daysPerYear, vz * daysPerYear, mass * solarMass}
}

func createBodies() []*body {
	bodies := []*body{
		newBody(0, 0, 0, 0, 0, 0, 1),
		newBody(4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
			1.66007664274403694e-03, 7.69901118419740425e-03, -6.90460016972063023e-05, 9.54791938424326609e-04),
		newBody(8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
			-2.76742510726862411e-03, 4.99852801234917238e-03, 2.30417297573763929e-05, 2.85885980666130812e-04),
		newBody(1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
			2.96460137564761618e-03, 2.37847173959480950e-03, -2.96589568540237556e-05, 4.36624404335156298e-05),
		newBody(1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
			2.68067772490389322e-03, 1.62824170038242295e-03, -9.51592254519715870e-05, 5.15138902046611451e-05),
	}
	px, py, pz := 0.0, 0.0, 0.0
	for _, b := range bodies {
		px += b.vx * b.mass
		py += b.vy * b.mass
		pz += b.vz * b.mass
	}
	s := bodies[0]
	s.vx = 0.0 - (px / solarMass)
	s.vy = 0.0 - (py / solarMass)
	s.vz = 0.0 - (pz / solarMass)
	return bodies
}

func advance(bodies []*body, dt float64) {
	for i := 0; i < len(bodies); i++ {
		ib := bodies[i]
		for j := i + 1; j < len(bodies); j++ {
			jb := bodies[j]
			dx := ib.x - jb.x
			dy := ib.y - jb.y
			dz := ib.z - jb.z
			dSquared := dx*dx + dy*dy + dz*dz
			distance := math.Sqrt(dSquared)
			mag := dt / (dSquared * distance)
			ib.vx = ib.vx - (dx * jb.mass * mag)
			ib.vy = ib.vy - (dy * jb.mass * mag)
			ib.vz = ib.vz - (dz * jb.mass * mag)
			jb.vx = jb.vx + (dx * ib.mass * mag)
			jb.vy = jb.vy + (dy * ib.mass * mag)
			jb.vz = jb.vz + (dz * ib.mass * mag)
		}
	}
	for _, b := range bodies {
		b.x = b.x + dt*b.vx
		b.y = b.y + dt*b.vy
		b.z = b.z + dt*b.vz
	}
}

func energy(bodies []*body) float64 {
	e := 0.0
	for i := 0; i < len(bodies); i++ {
		ib := bodies[i]
		e += 0.5 * ib.mass * (ib.vx*ib.vx + ib.vy*ib.vy + ib.vz*ib.vz)
		for j := i + 1; j < len(bodies); j++ {
			jb := bodies[j]
			dx := ib.x - jb.x
			dy := ib.y - jb.y
			dz := ib.z - jb.z
			e -= (ib.mass * jb.mass) / math.Sqrt(dx*dx+dy*dy+dz*dz)
		}
	}
	return e
}

func nbodyInner(inner int) bool {
	system := createBodies()
	for i := 0; i < inner; i++ {
		advance(system, 0.01)
	}
	r := energy(system)
	switch inner {
	case 250000:
		return r == -0.1690859889909308
	case 1:
		return r == -0.16907495402506745
	}
	println("No verification result for", inner, "found")
	return false
}

// ---- Permute ----------------------------------------------------------------

type permuter struct {
	count int
	v     []int
}

func (p *permuter) permute(n int) {
	p.count++
	if n != 0 {
		n1 := n - 1
		p.permute(n1)
		for i := n1; i >= 0; i-- {
			p.swap(n1, i)
			p.permute(n1)
			p.swap(n1, i)
		}
	}
}

func (p *permuter) swap(i, j int) { p.v[i], p.v[j] = p.v[j], p.v[i] }

func permuteInner(inner int) bool {
	for i := 0; i < inner; i++ {
		p := &permuter{count: 0, v: make([]int, 6)}
		p.permute(6)
		if p.count != 8660 {
			return false
		}
	}
	return true
}

// ---- Queens -----------------------------------------------------------------

type queens struct {
	freeMaxs, freeRows, freeMins []bool
	queenRows                    []int
}

func fillBool(n int, v bool) []bool {
	a := make([]bool, n)
	for i := range a {
		a[i] = v
	}
	return a
}

func (q *queens) queens() bool {
	q.freeRows = fillBool(8, true)
	q.freeMaxs = fillBool(16, true)
	q.freeMins = fillBool(16, true)
	q.queenRows = make([]int, 8)
	for i := range q.queenRows {
		q.queenRows[i] = -1
	}
	return q.placeQueen(0)
}

func (q *queens) placeQueen(c int) bool {
	for r := 0; r < 8; r++ {
		if q.getRowColumn(r, c) {
			q.queenRows[r] = c
			q.setRowColumn(r, c, false)
			if c == 7 {
				return true
			}
			if q.placeQueen(c + 1) {
				return true
			}
			q.setRowColumn(r, c, true)
		}
	}
	return false
}

func (q *queens) getRowColumn(r, c int) bool {
	return q.freeRows[r] && q.freeMaxs[c+r] && q.freeMins[c-r+7]
}

func (q *queens) setRowColumn(r, c int, v bool) {
	q.freeRows[r] = v
	q.freeMaxs[c+r] = v
	q.freeMins[c-r+7] = v
}

func queensInner(inner int) bool {
	for i := 0; i < inner; i++ {
		q := &queens{}
		result := true
		for k := 0; k < 10; k++ {
			result = result && q.queens()
		}
		if !result {
			return false
		}
	}
	return true
}

// ---- Sieve ------------------------------------------------------------------

func sieve(flags []bool, size int) int {
	primeCount := 0
	for i := 2; i <= size; i++ {
		if flags[i-1] {
			primeCount++
			for k := i + i; k <= size; k += i {
				flags[k-1] = false
			}
		}
	}
	return primeCount
}

func sieveInner(inner int) bool {
	for i := 0; i < inner; i++ {
		if sieve(fillBool(5000, true), 5000) != 669 {
			return false
		}
	}
	return true
}

// ---- Storage ----------------------------------------------------------------

type storage struct{ count int }

func (s *storage) buildTreeDepth(depth int, random *Random) interface{} {
	s.count++
	if depth == 1 {
		return make([]interface{}, random.next()%10+1)
	}
	arr := make([]interface{}, 4)
	for i := range arr {
		arr[i] = s.buildTreeDepth(depth-1, random)
	}
	return arr
}

func storageInner(inner int) bool {
	for i := 0; i < inner; i++ {
		s := &storage{}
		s.buildTreeDepth(7, newRandom())
		if s.count != 5461 {
			return false
		}
	}
	return true
}

// ---- Towers -----------------------------------------------------------------

type towersDisk struct {
	size int
	next *towersDisk
}

type towers struct {
	piles     [3]*towersDisk
	movesDone int
}

func (t *towers) pushDisk(disk *towersDisk, pile int) {
	top := t.piles[pile]
	if top != nil && disk.size >= top.size {
		panic("Cannot put a big disk on a smaller one")
	}
	disk.next = top
	t.piles[pile] = disk
}

func (t *towers) popDiskFrom(pile int) *towersDisk {
	top := t.piles[pile]
	if top == nil {
		panic("Attempting to remove a disk from an empty pile")
	}
	t.piles[pile] = top.next
	top.next = nil
	return top
}

func (t *towers) moveTopDisk(from, to int) {
	t.pushDisk(t.popDiskFrom(from), to)
	t.movesDone++
}

func (t *towers) buildTowerAt(pile, disks int) {
	for i := disks; i >= 0; i-- {
		t.pushDisk(&towersDisk{size: i}, pile)
	}
}

func (t *towers) moveDisks(disks, from, to int) {
	if disks == 1 {
		t.moveTopDisk(from, to)
	} else {
		other := (3 - from) - to
		t.moveDisks(disks-1, from, other)
		t.moveTopDisk(from, to)
		t.moveDisks(disks-1, other, to)
	}
}

func towersInner(inner int) bool {
	for i := 0; i < inner; i++ {
		t := &towers{}
		t.buildTowerAt(0, 13)
		t.movesDone = 0
		t.moveDisks(13, 0, 1)
		if t.movesDone != 8191 {
			return false
		}
	}
	return true
}
