// AWFY CD (collision detection), after the Java reference: a generic
// red-black tree over value keys, vectors and call signs as plain values.
package main

import "math"

const (
	cdMinX, cdMinY, cdMaxX, cdMaxY = 0.0, 0.0, 1000.0, 1000.0
	cdMinZ, cdMaxZ                 = 0.0, 10.0
	proximityRadius                = 1.0
	goodVoxelSize                  = proximityRadius * 2.0
)

type vector2D struct{ x, y float64 }

func (a vector2D) plus(b vector2D) vector2D  { return vector2D{a.x + b.x, a.y + b.y} }
func (a vector2D) minus(b vector2D) vector2D { return vector2D{a.x - b.x, a.y - b.y} }

func compareNumbers(a, b float64) int {
	if a == b {
		return 0
	}
	if a < b {
		return -1
	}
	if a > b {
		return 1
	}
	if a == a {
		return 1
	}
	return -1
}

func (a vector2D) compare(b vector2D) int {
	if r := compareNumbers(a.x, b.x); r != 0 {
		return r
	}
	return compareNumbers(a.y, b.y)
}

type vector3D struct{ x, y, z float64 }

func (a vector3D) plus(b vector3D) vector3D  { return vector3D{a.x + b.x, a.y + b.y, a.z + b.z} }
func (a vector3D) minus(b vector3D) vector3D { return vector3D{a.x - b.x, a.y - b.y, a.z - b.z} }
func (a vector3D) dot(b vector3D) float64    { return a.x*b.x + a.y*b.y + a.z*b.z }
func (a vector3D) squaredMagnitude() float64 { return a.dot(a) }
func (a vector3D) magnitude() float64        { return math.Sqrt(a.squaredMagnitude()) }
func (a vector3D) times(s float64) vector3D  { return vector3D{a.x * s, a.y * s, a.z * s} }

type callSign int

func (a callSign) compare(b callSign) int {
	if a == b {
		return 0
	}
	if a < b {
		return -1
	}
	return 1
}

// ---- Red-black tree ---------------------------------------------------------

type rbKey[K any] interface{ compare(K) int }

type rbNode[K rbKey[K], V any] struct {
	key                 K
	value               V
	left, right, parent *rbNode[K, V]
	red                 bool
}

func treeMinimum[K rbKey[K], V any](x *rbNode[K, V]) *rbNode[K, V] {
	for x.left != nil {
		x = x.left
	}
	return x
}

func (x *rbNode[K, V]) successor() *rbNode[K, V] {
	if x.right != nil {
		return treeMinimum(x.right)
	}
	y := x.parent
	for y != nil && x == y.right {
		x = y
		y = y.parent
	}
	return y
}

type rbTree[K rbKey[K], V any] struct{ root *rbNode[K, V] }

func isRed[K rbKey[K], V any](n *rbNode[K, V]) bool { return n != nil && n.red }

// put returns the previous value and whether there was one.
func (t *rbTree[K, V]) put(key K, value V) (V, bool) {
	var y *rbNode[K, V]
	x := t.root
	for x != nil {
		y = x
		c := key.compare(x.key)
		if c < 0 {
			x = x.left
		} else if c > 0 {
			x = x.right
		} else {
			old := x.value
			x.value = value
			return old, true
		}
	}
	z := &rbNode[K, V]{key: key, value: value, parent: y, red: true}
	if y == nil {
		t.root = z
	} else if key.compare(y.key) < 0 {
		y.left = z
	} else {
		y.right = z
	}
	x = z
	for x != t.root && x.parent.red {
		if x.parent == x.parent.parent.left {
			y := x.parent.parent.right
			if isRed(y) {
				x.parent.red = false
				y.red = false
				x.parent.parent.red = true
				x = x.parent.parent
			} else {
				if x == x.parent.right {
					x = x.parent
					t.leftRotate(x)
				}
				x.parent.red = false
				x.parent.parent.red = true
				t.rightRotate(x.parent.parent)
			}
		} else {
			y := x.parent.parent.left
			if isRed(y) {
				x.parent.red = false
				y.red = false
				x.parent.parent.red = true
				x = x.parent.parent
			} else {
				if x == x.parent.left {
					x = x.parent
					t.rightRotate(x)
				}
				x.parent.red = false
				x.parent.parent.red = true
				t.leftRotate(x.parent.parent)
			}
		}
	}
	t.root.red = false
	var zero V
	return zero, false
}

func (t *rbTree[K, V]) findNode(key K) *rbNode[K, V] {
	current := t.root
	for current != nil {
		c := key.compare(current.key)
		if c == 0 {
			return current
		}
		if c < 0 {
			current = current.left
		} else {
			current = current.right
		}
	}
	return nil
}

func (t *rbTree[K, V]) get(key K) (V, bool) {
	if n := t.findNode(key); n != nil {
		return n.value, true
	}
	var zero V
	return zero, false
}

func (t *rbTree[K, V]) remove(key K) {
	z := t.findNode(key)
	if z == nil {
		return
	}
	y := z
	if z.left != nil && z.right != nil {
		y = z.successor()
	}
	x := y.right
	if y.left != nil {
		x = y.left
	}
	xParent := y.parent
	if x != nil {
		x.parent = y.parent
	}
	if y.parent == nil {
		t.root = x
	} else if y == y.parent.left {
		y.parent.left = x
	} else {
		y.parent.right = x
	}
	if y != z {
		if !y.red {
			t.removeFixup(x, xParent)
		}
		y.parent = z.parent
		y.red = z.red
		y.left = z.left
		y.right = z.right
		if z.left != nil {
			z.left.parent = y
		}
		if z.right != nil {
			z.right.parent = y
		}
		if z.parent != nil {
			if z.parent.left == z {
				z.parent.left = y
			} else {
				z.parent.right = y
			}
		} else {
			t.root = y
		}
	} else if !y.red {
		t.removeFixup(x, xParent)
	}
}

func (t *rbTree[K, V]) forEach(fn func(K, V)) {
	if t.root == nil {
		return
	}
	for current := treeMinimum(t.root); current != nil; current = current.successor() {
		fn(current.key, current.value)
	}
}

func (t *rbTree[K, V]) leftRotate(x *rbNode[K, V]) {
	y := x.right
	x.right = y.left
	if y.left != nil {
		y.left.parent = x
	}
	y.parent = x.parent
	if x.parent == nil {
		t.root = y
	} else if x == x.parent.left {
		x.parent.left = y
	} else {
		x.parent.right = y
	}
	y.left = x
	x.parent = y
}

func (t *rbTree[K, V]) rightRotate(y *rbNode[K, V]) {
	x := y.left
	y.left = x.right
	if x.right != nil {
		x.right.parent = y
	}
	x.parent = y.parent
	if y.parent == nil {
		t.root = x
	} else if y == y.parent.left {
		y.parent.left = x
	} else {
		y.parent.right = x
	}
	x.right = y
	y.parent = x
}

func (t *rbTree[K, V]) removeFixup(x, xParent *rbNode[K, V]) {
	for x != t.root && !isRed(x) {
		if x == xParent.left {
			w := xParent.right
			if w.red {
				w.red = false
				xParent.red = true
				t.leftRotate(xParent)
				w = xParent.right
			}
			if !isRed(w.left) && !isRed(w.right) {
				w.red = true
				x = xParent
				xParent = x.parent
			} else {
				if !isRed(w.right) {
					w.left.red = false
					w.red = true
					t.rightRotate(w)
					w = xParent.right
				}
				w.red = xParent.red
				xParent.red = false
				if w.right != nil {
					w.right.red = false
				}
				t.leftRotate(xParent)
				x = t.root
				xParent = x.parent
			}
		} else {
			w := xParent.left
			if w.red {
				w.red = false
				xParent.red = true
				t.rightRotate(xParent)
				w = xParent.left
			}
			if !isRed(w.right) && !isRed(w.left) {
				w.red = true
				x = xParent
				xParent = x.parent
			} else {
				if !isRed(w.left) {
					w.right.red = false
					w.red = true
					t.leftRotate(w)
					w = xParent.left
				}
				w.red = xParent.red
				xParent.red = false
				if w.left != nil {
					w.left.red = false
				}
				t.rightRotate(xParent)
				x = t.root
				xParent = x.parent
			}
		}
	}
	if x != nil {
		x.red = false
	}
}

// ---- Collision detection ----------------------------------------------------

type aircraft struct {
	callsign callSign
	position vector3D
}

type motion struct {
	callsign       callSign
	posOne, posTwo vector3D
}

type collision struct {
	aircraftA, aircraftB callSign
	position             vector3D
}

func (m *motion) delta() vector3D { return m.posTwo.minus(m.posOne) }

func (m *motion) findIntersection(other *motion) (vector3D, bool) {
	init1, init2 := m.posOne, other.posOne
	vec1, vec2 := m.delta(), other.delta()
	radius := proximityRadius
	a := vec2.minus(vec1).squaredMagnitude()
	if a != 0.0 {
		b := 2.0 * init1.minus(init2).dot(vec1.minus(vec2))
		c := -radius*radius + init2.minus(init1).squaredMagnitude()
		discr := b*b - 4.0*a*c
		if discr < 0.0 {
			return vector3D{}, false
		}
		v1 := (-b - math.Sqrt(discr)) / (2.0 * a)
		v2 := (-b + math.Sqrt(discr)) / (2.0 * a)
		if v1 <= v2 && ((v1 <= 1.0 && 1.0 <= v2) || (v1 <= 0.0 && 0.0 <= v2) || (0.0 <= v1 && v2 <= 1.0)) {
			v := v1
			if v1 <= 0.0 {
				v = 0.0
			}
			result1 := init1.plus(vec1.times(v))
			result2 := init2.plus(vec2.times(v))
			result := result1.plus(result2).times(0.5)
			if result.x >= cdMinX && result.x <= cdMaxX && result.y >= cdMinY && result.y <= cdMaxY &&
				result.z >= cdMinZ && result.z <= cdMaxZ {
				return result, true
			}
		}
		return vector3D{}, false
	}
	if init2.minus(init1).magnitude() <= radius {
		return init1.plus(init2).times(0.5), true
	}
	return vector3D{}, false
}

type collisionDetector struct{ state rbTree[callSign, vector3D] }

func (d *collisionDetector) handleNewFrame(frame []aircraft) []collision {
	var motions []*motion
	seen := &rbTree[callSign, bool]{}
	for _, a := range frame {
		oldPosition, had := d.state.put(a.callsign, a.position)
		newPosition := a.position
		seen.put(a.callsign, true)
		if !had {
			oldPosition = newPosition
		}
		motions = append(motions, &motion{a.callsign, oldPosition, newPosition})
	}
	var toRemove []callSign
	d.state.forEach(func(k callSign, _ vector3D) {
		if s, _ := seen.get(k); !s {
			toRemove = append(toRemove, k)
		}
	})
	for _, k := range toRemove {
		d.state.remove(k)
	}
	var collisions []collision
	for _, reduced := range reduceCollisionSet(motions) {
		for i := 0; i < len(reduced); i++ {
			m1 := reduced[i]
			for j := i + 1; j < len(reduced); j++ {
				m2 := reduced[j]
				if c, ok := m1.findIntersection(m2); ok {
					collisions = append(collisions, collision{m1.callsign, m2.callsign, c})
				}
			}
		}
	}
	return collisions
}

func isInVoxel(voxel vector2D, m *motion) bool {
	if voxel.x > cdMaxX || voxel.x < cdMinX || voxel.y > cdMaxY || voxel.y < cdMinY {
		return false
	}
	init, fin := m.posOne, m.posTwo
	vS := goodVoxelSize
	r := proximityRadius / 2.0
	vX, x0, xv := voxel.x, init.x, fin.x-init.x
	vY, y0, yv := voxel.y, init.y, fin.y-init.y
	lowX := (vX - r - x0) / xv
	highX := (vX + vS + r - x0) / xv
	if xv < 0.0 {
		lowX, highX = highX, lowX
	}
	lowY := (vY - r - y0) / yv
	highY := (vY + vS + r - y0) / yv
	if yv < 0.0 {
		lowY, highY = highY, lowY
	}
	return ((xv == 0.0 && vX <= x0+r && x0-r <= vX+vS) ||
		(lowX <= 1.0 && 1.0 <= highX) || (lowX <= 0.0 && 0.0 <= highX) ||
		(0.0 <= lowX && highX <= 1.0)) &&
		((yv == 0.0 && vY <= y0+r && y0-r <= vY+vS) ||
			((lowY <= 1.0 && 1.0 <= highY) || (lowY <= 0.0 && 0.0 <= highY) ||
				(0.0 <= lowY && highY <= 1.0))) &&
		(xv == 0.0 || yv == 0.0 ||
			(lowY <= highX && highX <= highY) ||
			(lowY <= lowX && lowX <= highY) ||
			(lowX <= lowY && highY <= highX))
}

var horizontal = vector2D{goodVoxelSize, 0.0}
var vertical = vector2D{0.0, goodVoxelSize}

type voxelMap = rbTree[vector2D, *[]*motion]

func putIntoMap(vm *voxelMap, voxel vector2D, m *motion) {
	array, ok := vm.get(voxel)
	if !ok {
		array = &[]*motion{}
		vm.put(voxel, array)
	}
	*array = append(*array, m)
}

func recurse(vm *voxelMap, seen *rbTree[vector2D, bool], nextVoxel vector2D, m *motion) {
	if !isInVoxel(nextVoxel, m) {
		return
	}
	if old, _ := seen.put(nextVoxel, true); old {
		return
	}
	putIntoMap(vm, nextVoxel, m)
	recurse(vm, seen, nextVoxel.minus(horizontal), m)
	recurse(vm, seen, nextVoxel.plus(horizontal), m)
	recurse(vm, seen, nextVoxel.minus(vertical), m)
	recurse(vm, seen, nextVoxel.plus(vertical), m)
	recurse(vm, seen, nextVoxel.minus(horizontal).minus(vertical), m)
	recurse(vm, seen, nextVoxel.minus(horizontal).plus(vertical), m)
	recurse(vm, seen, nextVoxel.plus(horizontal).minus(vertical), m)
	recurse(vm, seen, nextVoxel.plus(horizontal).plus(vertical), m)
}

func reduceCollisionSet(motions []*motion) [][]*motion {
	vm := &voxelMap{}
	for _, m := range motions {
		recurse(vm, &rbTree[vector2D, bool]{}, voxelHash(m.posOne), m)
	}
	var result [][]*motion
	vm.forEach(func(_ vector2D, v *[]*motion) {
		if len(*v) > 1 {
			result = append(result, *v)
		}
	})
	return result
}

func voxelHash(position vector3D) vector2D {
	xDiv := int(position.x / goodVoxelSize)
	yDiv := int(position.y / goodVoxelSize)
	x := goodVoxelSize * float64(xDiv)
	y := goodVoxelSize * float64(yDiv)
	if position.x < 0 {
		x -= goodVoxelSize
	}
	if position.y < 0 {
		y -= goodVoxelSize
	}
	return vector2D{x, y}
}

func simulate(numAircraft int, time float64) []aircraft {
	frame := make([]aircraft, 0, numAircraft)
	for i := 0; i < numAircraft; i += 2 {
		frame = append(frame, aircraft{callSign(i), vector3D{time, math.Cos(time)*2 + float64(i)*3, 10}})
		frame = append(frame, aircraft{callSign(i + 1), vector3D{time, math.Sin(time)*2 + float64(i)*3, 10}})
	}
	return frame
}

func cdBenchmark(numAircrafts int) int {
	detector := &collisionDetector{}
	actual := 0
	for i := 0; i < 200; i++ {
		time := float64(i) / 10.0
		actual += len(detector.handleNewFrame(simulate(numAircrafts, time)))
	}
	return actual
}

func cdInner(inner int) bool {
	actual := cdBenchmark(inner)
	switch inner {
	case 1000, 500:
		return actual == 14484
	case 250:
		return actual == 10830
	case 200:
		return actual == 8655
	case 100:
		return actual == 4305
	case 10:
		return actual == 390
	case 2:
		return actual == 42
	}
	println("No verification result for", inner, "found; result", actual)
	return false
}
