// AWFY DeltaBlue, after the Java reference: the constraint classes are one
// struct with a kind, variables and constraints a pointer graph.
package main

type strength int

// Arithmetic values of the reference's strength table: smaller is stronger.
const (
	sRequired        strength = -800
	sPreferred       strength = -400
	sStrongDefault   strength = -200
	sDefault         strength = 0
	sAbsoluteWeakest strength = 10000
)

func (s strength) stronger(o strength) bool { return s < o }
func (s strength) weaker(o strength) bool   { return s > o }
func (s strength) weakest(o strength) strength {
	if o.weaker(s) {
		return o
	}
	return s
}

type conKind int

const (
	kStay conKind = iota
	kEdit
	kEquality
	kScale
)

type direction int

const (
	dirNone direction = iota
	dirForward
	dirBackward
)

type variable struct {
	value        int
	constraints  []*constraint
	determinedBy *constraint
	mark         int
	walkStrength strength
	stay         bool
}

func newVariable(value int) *variable {
	return &variable{value: value, constraints: make([]*constraint, 0, 2), walkStrength: sAbsoluteWeakest, stay: true}
}

func (v *variable) removeConstraint(c *constraint) {
	out := v.constraints[:0]
	for _, x := range v.constraints {
		if x != c {
			out = append(out, x)
		}
	}
	for i := len(out); i < len(v.constraints); i++ {
		v.constraints[i] = nil
	}
	v.constraints = out
	if v.determinedBy == c {
		v.determinedBy = nil
	}
}

type constraint struct {
	kind          conKind
	strength      strength
	v1, v2        *variable // unary: v1 is the output
	scale, offset *variable
	direction     direction
	satisfied     bool
}

func (c *constraint) unary() bool   { return c.kind == kStay || c.kind == kEdit }
func (c *constraint) isInput() bool { return c.kind == kEdit }

func (c *constraint) isSatisfied() bool {
	if c.unary() {
		return c.satisfied
	}
	return c.direction != dirNone
}

func (c *constraint) addToGraph() {
	c.v1.constraints = append(c.v1.constraints, c)
	if c.unary() {
		c.satisfied = false
		return
	}
	c.v2.constraints = append(c.v2.constraints, c)
	if c.kind == kScale {
		c.scale.constraints = append(c.scale.constraints, c)
		c.offset.constraints = append(c.offset.constraints, c)
	}
	c.direction = dirNone
}

func (c *constraint) removeFromGraph() {
	c.v1.removeConstraint(c)
	if c.unary() {
		c.satisfied = false
		return
	}
	c.v2.removeConstraint(c)
	if c.kind == kScale {
		c.scale.removeConstraint(c)
		c.offset.removeConstraint(c)
	}
	c.direction = dirNone
}

func (c *constraint) chooseMethod(mark int) {
	if c.unary() {
		c.satisfied = c.v1.mark != mark && c.strength.stronger(c.v1.walkStrength)
		return
	}
	v1, v2 := c.v1, c.v2
	c.direction = dirNone
	switch {
	case v1.mark == mark:
		if v2.mark != mark && c.strength.stronger(v2.walkStrength) {
			c.direction = dirForward
		}
	case v2.mark == mark:
		if v1.mark != mark && c.strength.stronger(v1.walkStrength) {
			c.direction = dirBackward
		}
	case v1.walkStrength.weaker(v2.walkStrength):
		if c.strength.stronger(v1.walkStrength) {
			c.direction = dirBackward
		}
	default:
		if c.strength.stronger(v2.walkStrength) {
			c.direction = dirForward
		}
	}
}

func (c *constraint) execute() {
	switch c.kind {
	case kEquality:
		if c.direction == dirForward {
			c.v2.value = c.v1.value
		} else {
			c.v1.value = c.v2.value
		}
	case kScale:
		if c.direction == dirForward {
			c.v2.value = c.v1.value*c.scale.value + c.offset.value
		} else {
			c.v1.value = (c.v2.value - c.offset.value) / c.scale.value
		}
	}
}

func (c *constraint) input() *variable {
	if c.direction == dirForward {
		return c.v1
	}
	return c.v2
}

func (c *constraint) output() *variable {
	if c.unary() || c.direction != dirForward {
		return c.v1
	}
	return c.v2
}

func (c *constraint) inputsDo(fn func(*variable)) {
	if c.unary() {
		return
	}
	fn(c.input())
	if c.kind == kScale {
		fn(c.scale)
		fn(c.offset)
	}
}

// The reference's inputsHasOne tests only v1/v2 (BinaryConstraint), even for scale.
func (c *constraint) inputsKnown(mark int) bool {
	if c.unary() {
		return true
	}
	v := c.input()
	return v.mark == mark || v.stay || v.determinedBy == nil
}

func (c *constraint) markUnsatisfied() {
	if c.unary() {
		c.satisfied = false
	} else {
		c.direction = dirNone
	}
}

func (c *constraint) recalculate() {
	if c.unary() {
		c.v1.walkStrength = c.strength
		c.v1.stay = !c.isInput()
		if c.v1.stay {
			c.execute()
		}
		return
	}
	in, out := c.input(), c.output()
	out.walkStrength = c.strength.weakest(in.walkStrength)
	if c.kind == kScale {
		out.stay = in.stay && c.scale.stay && c.offset.stay
	} else {
		out.stay = in.stay
	}
	if out.stay {
		c.execute()
	}
}

type planner struct{ currentMark int }

func (p *planner) newMark() int {
	p.currentMark++
	return p.currentMark
}

func (p *planner) newConstraint(kind conKind, s strength, v1, v2, scale, offset *variable) *constraint {
	c := &constraint{kind: kind, strength: s, v1: v1, v2: v2, scale: scale, offset: offset}
	c.addToGraph()
	p.incrementalAdd(c)
	return c
}

func (p *planner) satisfy(c *constraint, mark int) *constraint {
	c.chooseMethod(mark)
	if !c.isSatisfied() {
		if c.strength == sRequired {
			panic("Could not satisfy a required constraint")
		}
		return nil
	}
	c.inputsDo(func(in *variable) { in.mark = mark })
	out := c.output()
	overridden := out.determinedBy
	if overridden != nil {
		overridden.markUnsatisfied()
	}
	out.determinedBy = c
	if !p.addPropagate(c, mark) {
		panic("Cycle encountered")
	}
	out.mark = mark
	return overridden
}

func (p *planner) incrementalAdd(c *constraint) {
	mark := p.newMark()
	for overridden := p.satisfy(c, mark); overridden != nil; {
		overridden = p.satisfy(overridden, mark)
	}
}

func (p *planner) incrementalRemove(c *constraint) {
	out := c.output()
	c.markUnsatisfied()
	c.removeFromGraph()
	for _, u := range p.removePropagateFrom(out) {
		p.incrementalAdd(u)
	}
}

func (p *planner) destroyConstraint(c *constraint) {
	if c.isSatisfied() {
		p.incrementalRemove(c)
	}
	c.removeFromGraph()
}

func addConstraintsConsumingTo(v *variable, coll []*constraint) []*constraint {
	determining := v.determinedBy
	for _, c := range v.constraints {
		if c != determining && c.isSatisfied() {
			coll = append(coll, c)
		}
	}
	return coll
}

func (p *planner) addPropagate(c *constraint, mark int) bool {
	todo := []*constraint{c}
	for len(todo) > 0 {
		d := todo[0]
		todo = todo[1:]
		if d.output().mark == mark {
			p.incrementalRemove(c)
			return false
		}
		d.recalculate()
		todo = addConstraintsConsumingTo(d.output(), todo)
	}
	return true
}

func (p *planner) removePropagateFrom(out *variable) []*constraint {
	var unsatisfied []*constraint
	out.determinedBy = nil
	out.walkStrength = sAbsoluteWeakest
	out.stay = true
	todo := []*variable{out}
	for len(todo) > 0 {
		v := todo[0]
		todo = todo[1:]
		for _, c := range v.constraints {
			if !c.isSatisfied() {
				unsatisfied = append(unsatisfied, c)
			}
		}
		determining := v.determinedBy
		for _, c := range v.constraints {
			if c != determining && c.isSatisfied() {
				c.recalculate()
				todo = append(todo, c.output())
			}
		}
	}
	// The reference sorts strongest first with a Vector.sort that implements
	// no swap: it only ever sees lists already in that order.
	return unsatisfied
}

func (p *planner) makePlan(sources []*constraint) []*constraint {
	mark := p.newMark()
	plan := make([]*constraint, 0, 15)
	todo := sources
	for len(todo) > 0 {
		c := todo[0]
		todo = todo[1:]
		if c.output().mark != mark && c.inputsKnown(mark) {
			plan = append(plan, c)
			c.output().mark = mark
			todo = addConstraintsConsumingTo(c.output(), todo)
		}
	}
	return plan
}

func (p *planner) extractPlanFromConstraints(constraints []*constraint) []*constraint {
	var sources []*constraint
	for _, c := range constraints {
		if c.isInput() && c.isSatisfied() {
			sources = append(sources, c)
		}
	}
	return p.makePlan(sources)
}

func executePlan(plan []*constraint) {
	for _, c := range plan {
		c.execute()
	}
}

func (p *planner) change(v *variable, newValue int) {
	editC := p.newConstraint(kEdit, sPreferred, v, nil, nil, nil)
	plan := p.extractPlanFromConstraints([]*constraint{editC})
	for i := 0; i < 10; i++ {
		v.value = newValue
		executePlan(plan)
	}
	p.destroyConstraint(editC)
}

func chainTest(n int) {
	p := &planner{currentMark: 1}
	vars := make([]*variable, n+1)
	for i := range vars {
		vars[i] = newVariable(0)
	}
	for i := 0; i < n; i++ {
		p.newConstraint(kEquality, sRequired, vars[i], vars[i+1], nil, nil)
	}
	p.newConstraint(kStay, sStrongDefault, vars[n], nil, nil, nil)
	editC := p.newConstraint(kEdit, sPreferred, vars[0], nil, nil, nil)
	plan := p.extractPlanFromConstraints([]*constraint{editC})
	for i := 0; i < 100; i++ {
		vars[0].value = i
		executePlan(plan)
		if vars[n].value != i {
			panic("Chain test failed!")
		}
	}
	p.destroyConstraint(editC)
}

func projectionTest(n int) {
	p := &planner{currentMark: 1}
	var dests []*variable
	scale := newVariable(10)
	offset := newVariable(1000)
	var src, dst *variable
	for i := 1; i <= n; i++ {
		src = newVariable(i)
		dst = newVariable(i)
		dests = append(dests, dst)
		p.newConstraint(kStay, sDefault, src, nil, nil, nil)
		p.newConstraint(kScale, sRequired, src, dst, scale, offset)
	}
	p.change(src, 17)
	if dst.value != 1170 {
		panic("Projection test 1 failed!")
	}
	p.change(dst, 1050)
	if src.value != 5 {
		panic("Projection test 2 failed!")
	}
	p.change(scale, 5)
	for i := 0; i < n-1; i++ {
		if dests[i].value != (i+1)*5+1000 {
			panic("Projection test 3 failed!")
		}
	}
	p.change(offset, 2000)
	for i := 0; i < n-1; i++ {
		if dests[i].value != (i+1)*5+2000 {
			panic("Projection test 4 failed!")
		}
	}
}

func deltaBlueInner(inner int) bool {
	chainTest(inner)
	projectionTest(inner)
	return true
}
