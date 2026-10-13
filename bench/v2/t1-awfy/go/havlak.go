// AWFY Havlak, after the Java reference: loop recognition on a synthetic
// control-flow graph, as a pointer graph. The block-number dictionary is a
// map keyed by block, as the reference's IdentityDictionary.
package main

import "math"

const unvisited = math.MaxInt32
const maxNonBackPreds = 32 * 1024

type bbClass int

const (
	bbTop bbClass = iota
	bbNonHeader
	bbReducible
	bbSelf
	bbIrreducible
	bbDead
)

type basicBlock struct {
	inEdges, outEdges []*basicBlock
	name              int
}

type cfgGraph struct {
	basicBlockMap []*basicBlock
	startNode     *basicBlock
	edgeList      [][2]*basicBlock
}

func (c *cfgGraph) createNode(name int) *basicBlock {
	for len(c.basicBlockMap) <= name {
		c.basicBlockMap = append(c.basicBlockMap, nil)
	}
	node := c.basicBlockMap[name]
	if node == nil {
		node = &basicBlock{inEdges: make([]*basicBlock, 0, 2), outEdges: make([]*basicBlock, 0, 2), name: name}
		c.basicBlockMap[name] = node
	}
	if len(c.basicBlockMap) == 1 {
		c.startNode = node
	}
	return node
}

func (c *cfgGraph) addEdge(fromName, toName int) {
	from := c.createNode(fromName)
	to := c.createNode(toName)
	from.outEdges = append(from.outEdges, to)
	to.inEdges = append(to.inEdges, from)
	c.edgeList = append(c.edgeList, [2]*basicBlock{from, to})
}

type simpleLoop struct {
	basicBlocks  []*basicBlock
	children     []*simpleLoop
	parent       *simpleLoop
	header       *basicBlock
	isReducible  bool
	isRoot       bool
	nestingLevel int
	counter      int
	depthLevel   int
}

func newSimpleLoop(bb *basicBlock, isReducible bool) *simpleLoop {
	l := &simpleLoop{header: bb, isReducible: isReducible}
	if bb != nil {
		l.basicBlocks = append(l.basicBlocks, bb)
	}
	return l
}

func (l *simpleLoop) addNode(bb *basicBlock) {
	for _, b := range l.basicBlocks {
		if b == bb {
			return
		}
	}
	l.basicBlocks = append(l.basicBlocks, bb)
}

func (l *simpleLoop) setParent(p *simpleLoop) {
	l.parent = p
	for _, c := range p.children {
		if c == l {
			return
		}
	}
	p.children = append(p.children, l)
}

func (l *simpleLoop) setNestingLevel(level int) {
	l.nestingLevel = level
	if level == 0 {
		l.isRoot = true
	}
}

type loopStructureGraph struct {
	root        *simpleLoop
	loops       []*simpleLoop
	loopCounter int
}

func newLSG() *loopStructureGraph {
	root := newSimpleLoop(nil, true)
	root.setNestingLevel(0)
	root.counter = 0
	return &loopStructureGraph{root: root, loops: []*simpleLoop{root}, loopCounter: 1}
}

func (g *loopStructureGraph) createNewLoop(bb *basicBlock, isReducible bool) *simpleLoop {
	l := newSimpleLoop(bb, isReducible)
	l.counter = g.loopCounter
	g.loopCounter++
	g.loops = append(g.loops, l)
	return l
}

func (g *loopStructureGraph) calculateNestingLevel() {
	for _, l := range g.loops {
		if !l.isRoot && l.parent == nil {
			l.setParent(g.root)
		}
	}
	g.calculateNestingLevelRec(g.root, 0)
}

func (g *loopStructureGraph) calculateNestingLevelRec(l *simpleLoop, depth int) {
	l.depthLevel = depth
	for _, c := range l.children {
		g.calculateNestingLevelRec(c, depth+1)
		l.setNestingLevel(max(l.nestingLevel, 1+c.nestingLevel))
	}
}

type unionFindNode struct {
	parent    *unionFindNode
	bb        *basicBlock
	loop      *simpleLoop
	dfsNumber int
}

func (n *unionFindNode) initNode(bb *basicBlock, dfsNumber int) {
	n.parent, n.bb, n.dfsNumber, n.loop = n, bb, dfsNumber, nil
}

func (n *unionFindNode) findSet() *unionFindNode {
	var nodeList []*unionFindNode
	node := n
	for node != node.parent {
		if node.parent != node.parent.parent {
			nodeList = append(nodeList, node)
		}
		node = node.parent
	}
	// The reference unions each with the starting node's parent.
	for _, it := range nodeList {
		it.parent = n.parent
	}
	return node
}

type havlakLoopFinder struct {
	cfg          *cfgGraph
	lsg          *loopStructureGraph
	nonBackPreds [][]int
	backPreds    [][]int
	number       map[*basicBlock]int
	header       []int
	typ          []bbClass
	last         []int
	nodes        []*unionFindNode
}

func (f *havlakLoopFinder) isAncestor(w, v int) bool { return w <= v && v <= f.last[w] }

func (f *havlakLoopFinder) doDFS(currentNode *basicBlock, current int) int {
	f.nodes[current].initNode(currentNode, current)
	f.number[currentNode] = current
	lastId := current
	for _, target := range currentNode.outEdges {
		if f.number[target] == unvisited {
			lastId = f.doDFS(target, lastId+1)
		}
	}
	f.last[current] = lastId
	return lastId
}

func addToSet(s []int, v int) []int {
	for _, x := range s {
		if x == v {
			return s
		}
	}
	return append(s, v)
}

func (f *havlakLoopFinder) findLoops() {
	if f.cfg.startNode == nil {
		return
	}
	size := len(f.cfg.basicBlockMap)
	f.nonBackPreds = make([][]int, size)
	f.backPreds = make([][]int, size)
	f.number = make(map[*basicBlock]int, size)
	f.header = make([]int, size)
	f.typ = make([]bbClass, size)
	f.last = make([]int, size)
	f.nodes = make([]*unionFindNode, size)
	for i := range f.nodes {
		f.nodes[i] = &unionFindNode{}
	}
	for _, bb := range f.cfg.basicBlockMap {
		f.number[bb] = unvisited
	}
	f.doDFS(f.cfg.startNode, 0)
	for w := 0; w < size; w++ {
		f.header[w] = 0
		f.typ[w] = bbNonHeader
		nodeW := f.nodes[w].bb
		if nodeW == nil {
			f.typ[w] = bbDead
			continue
		}
		for _, nodeV := range nodeW.inEdges {
			v := f.number[nodeV]
			if v != unvisited {
				if f.isAncestor(w, v) {
					f.backPreds[w] = append(f.backPreds[w], v)
				} else {
					f.nonBackPreds[w] = addToSet(f.nonBackPreds[w], v)
				}
			}
		}
	}
	f.header[0] = 0
	for w := size - 1; w >= 0; w-- {
		nodeW := f.nodes[w].bb
		if nodeW == nil {
			continue
		}
		var nodePool []*unionFindNode
		for _, v := range f.backPreds[w] {
			if v != w {
				nodePool = append(nodePool, f.nodes[v].findSet())
			} else {
				f.typ[w] = bbSelf
			}
		}
		workList := append([]*unionFindNode(nil), nodePool...)
		if len(nodePool) != 0 {
			f.typ[w] = bbReducible
		}
		for len(workList) > 0 {
			x := workList[0]
			workList = workList[1:]
			xd := x.dfsNumber
			if len(f.nonBackPreds[xd]) > maxNonBackPreds {
				return
			}
			// The set may grow while it is walked.
			for k := 0; k < len(f.nonBackPreds[xd]); k++ {
				ydash := f.nodes[f.nonBackPreds[xd][k]].findSet()
				yd := ydash.dfsNumber
				if !f.isAncestor(w, yd) {
					f.typ[w] = bbIrreducible
					f.nonBackPreds[w] = addToSet(f.nonBackPreds[w], yd)
				} else if yd != w {
					found := false
					for _, e := range nodePool {
						if e == ydash {
							found = true
							break
						}
					}
					if !found {
						workList = append(workList, ydash)
						nodePool = append(nodePool, ydash)
					}
				}
			}
		}
		if len(nodePool) > 0 || f.typ[w] == bbSelf {
			loop := f.lsg.createNewLoop(nodeW, f.typ[w] != bbIrreducible)
			f.nodes[w].loop = loop
			for _, node := range nodePool {
				f.header[node.dfsNumber] = w
				node.parent = f.nodes[w]
				if node.loop != nil {
					node.loop.setParent(loop)
				} else {
					loop.addNode(node.bb)
				}
			}
		}
	}
}

type loopTesterApp struct {
	cfg *cfgGraph
	lsg *loopStructureGraph
}

func (a *loopTesterApp) buildDiamond(start int) int {
	bb0 := start
	a.cfg.addEdge(bb0, bb0+1)
	a.cfg.addEdge(bb0, bb0+2)
	a.cfg.addEdge(bb0+1, bb0+3)
	a.cfg.addEdge(bb0+2, bb0+3)
	return bb0 + 3
}

func (a *loopTesterApp) buildConnect(start, end int) { a.cfg.addEdge(start, end) }

func (a *loopTesterApp) buildStraight(start, n int) int {
	for i := 0; i < n; i++ {
		a.buildConnect(start+i, start+i+1)
	}
	return start + n
}

func (a *loopTesterApp) buildBaseLoop(from int) int {
	header := a.buildStraight(from, 1)
	diamond1 := a.buildDiamond(header)
	d11 := a.buildStraight(diamond1, 1)
	diamond2 := a.buildDiamond(d11)
	footer := a.buildStraight(diamond2, 1)
	a.buildConnect(diamond2, d11)
	a.buildConnect(diamond1, header)
	a.buildConnect(footer, from)
	return a.buildStraight(footer, 1)
}

func (a *loopTesterApp) findLoops(lsg *loopStructureGraph) {
	(&havlakLoopFinder{cfg: a.cfg, lsg: lsg}).findLoops()
}

func (a *loopTesterApp) main(numDummyLoops, findLoopIterations, parLoops, pparLoops, ppparLoops int) (int, int) {
	a.cfg.createNode(0)
	a.buildBaseLoop(0)
	a.cfg.createNode(1)
	a.cfg.addEdge(0, 2)
	for i := 0; i < numDummyLoops; i++ {
		a.findLoops(a.lsg)
	}
	n := 2
	for p := 0; p < parLoops; p++ {
		a.cfg.createNode(n + 1)
		a.buildConnect(2, n+1)
		n++
		for i := 0; i < pparLoops; i++ {
			top := n
			n = a.buildStraight(n, 1)
			for j := 0; j < ppparLoops; j++ {
				n = a.buildBaseLoop(n)
			}
			bottom := a.buildStraight(n, 1)
			a.buildConnect(n, top)
			n = bottom
		}
		a.buildConnect(n, 1)
	}
	a.findLoops(a.lsg)
	// The reference discards these results; their loop counts are summed
	// so no compiler can drop the work (as in the Resid port).
	extra := 0
	for i := 0; i < findLoopIterations; i++ {
		l := newLSG()
		a.findLoops(l)
		extra += len(l.loops)
	}
	if extra == 0 && findLoopIterations > 0 {
		panic("findLoops found nothing")
	}
	a.lsg.calculateNestingLevel()
	return len(a.lsg.loops), len(a.cfg.basicBlockMap)
}

func havlakInner(inner int) bool {
	app := &loopTesterApp{cfg: &cfgGraph{}, lsg: newLSG()}
	app.cfg.createNode(0)
	loops, nodes := app.main(inner, 50, 10, 10, 5)
	switch inner {
	case 15000:
		return loops == 46602 && nodes == 5213
	case 1500:
		return loops == 6102 && nodes == 5213
	case 150:
		return loops == 2052 && nodes == 5213
	case 15:
		return loops == 1647 && nodes == 5213
	case 1:
		return loops == 1605 && nodes == 5213
	}
	println("No verification result for", inner, "found; result", loops, nodes)
	return false
}
