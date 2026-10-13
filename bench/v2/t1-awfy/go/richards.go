// AWFY Richards, after the Java reference: tasks are closures over their
// data records, packets a linked list, nil for NO_WORK/NO_TASK.
package main

const (
	rIdler = iota
	rWorker
	rHandlerA
	rHandlerB
	rDeviceA
	rDeviceB
	rNumTypes
)

const (
	devicePacketKind = 0
	workPacketKind   = 1
	packetDataSize   = 4
)

type packet struct {
	link     *packet
	identity int
	kind     int
	datum    int
	data     [packetDataSize]int
}

func appendPacket(p, queueHead *packet) *packet {
	p.link = nil
	if queueHead == nil {
		return p
	}
	mouse := queueHead
	for mouse.link != nil {
		mouse = mouse.link
	}
	mouse.link = p
	return queueHead
}

type taskState struct{ packetPending, taskWaiting, taskHolding bool }

func (t *taskState) packetPendingState() {
	t.packetPending, t.taskWaiting, t.taskHolding = true, false, false
}
func (t *taskState) running() { t.packetPending, t.taskWaiting, t.taskHolding = false, false, false }
func (t *taskState) isTaskHoldingOrWaiting() bool {
	return t.taskHolding || (!t.packetPending && t.taskWaiting)
}
func (t *taskState) isWaitingWithPacket() bool {
	return t.packetPending && t.taskWaiting && !t.taskHolding
}

func stateRunning() taskState           { return taskState{} }
func stateWaiting() taskState           { return taskState{taskWaiting: true} }
func stateWaitingWithPacket() taskState { return taskState{taskWaiting: true, packetPending: true} }

type processFunction func(work *packet) *tcb

type tcb struct {
	taskState
	link     *tcb
	identity int
	priority int
	input    *packet
	function processFunction
}

func (t *tcb) addInputAndCheckPriority(p *packet, oldTask *tcb) *tcb {
	if t.input == nil {
		t.input = p
		t.packetPending = true
		if t.priority > oldTask.priority {
			return t
		}
	} else {
		t.input = appendPacket(p, t.input)
	}
	return oldTask
}

func (t *tcb) runTask() *tcb {
	var message *packet
	if t.isWaitingWithPacket() {
		message = t.input
		t.input = message.link
		if t.input == nil {
			t.running()
		} else {
			t.packetPendingState()
		}
	}
	return t.function(message)
}

type scheduler struct {
	taskList            *tcb
	currentTask         *tcb
	currentTaskIdentity int
	taskTable           [rNumTypes]*tcb
	queuePacketCount    int
	holdCount           int
}

func (s *scheduler) createTask(identity, priority int, work *packet, state taskState, f processFunction) {
	t := &tcb{taskState: state, link: s.taskList, identity: identity, priority: priority, input: work, function: f}
	s.taskList = t
	s.taskTable[identity] = t
}

func (s *scheduler) createDevice(identity, priority int, work *packet, state taskState) {
	var pending *packet
	s.createTask(identity, priority, work, state, func(functionWork *packet) *tcb {
		if functionWork == nil {
			if functionWork = pending; functionWork == nil {
				return s.markWaiting()
			}
			pending = nil
			return s.queuePacket(functionWork)
		}
		pending = functionWork
		return s.holdSelf()
	})
}

func (s *scheduler) createHandler(identity, priority int, work *packet, state taskState) {
	var workIn, deviceIn *packet
	s.createTask(identity, priority, work, state, func(w *packet) *tcb {
		if w != nil {
			if w.kind == workPacketKind {
				workIn = appendPacket(w, workIn)
			} else {
				deviceIn = appendPacket(w, deviceIn)
			}
		}
		workPacket := workIn
		if workPacket == nil {
			return s.markWaiting()
		}
		count := workPacket.datum
		if count >= packetDataSize {
			workIn = workPacket.link
			return s.queuePacket(workPacket)
		}
		devicePacket := deviceIn
		if devicePacket == nil {
			return s.markWaiting()
		}
		deviceIn = devicePacket.link
		devicePacket.datum = workPacket.data[count]
		workPacket.datum = count + 1
		return s.queuePacket(devicePacket)
	})
}

func (s *scheduler) createIdler(identity, priority int, work *packet, state taskState) {
	control, count := 1, 10000
	s.createTask(identity, priority, work, state, func(_ *packet) *tcb {
		count--
		if count == 0 {
			return s.holdSelf()
		}
		if control&1 == 0 {
			control = control / 2
			return s.release(rDeviceA)
		}
		control = (control / 2) ^ 53256
		return s.release(rDeviceB)
	})
}

func (s *scheduler) createWorker(identity, priority int, work *packet, state taskState) {
	destination, count := rHandlerA, 0
	s.createTask(identity, priority, work, state, func(w *packet) *tcb {
		if w == nil {
			return s.markWaiting()
		}
		if destination == rHandlerA {
			destination = rHandlerB
		} else {
			destination = rHandlerA
		}
		w.identity = destination
		w.datum = 0
		for i := 0; i < packetDataSize; i++ {
			count++
			if count > 26 {
				count = 1
			}
			w.data[i] = 65 + count - 1
		}
		return s.queuePacket(w)
	})
}

func newPacket(link *packet, identity, kind int) *packet {
	return &packet{link: link, identity: identity, kind: kind}
}

func (s *scheduler) start() bool {
	s.createIdler(rIdler, 0, nil, stateRunning())
	workQ := newPacket(nil, rWorker, workPacketKind)
	workQ = newPacket(workQ, rWorker, workPacketKind)
	s.createWorker(rWorker, 1000, workQ, stateWaitingWithPacket())
	workQ = newPacket(nil, rDeviceA, devicePacketKind)
	workQ = newPacket(workQ, rDeviceA, devicePacketKind)
	workQ = newPacket(workQ, rDeviceA, devicePacketKind)
	s.createHandler(rHandlerA, 2000, workQ, stateWaitingWithPacket())
	workQ = newPacket(nil, rDeviceB, devicePacketKind)
	workQ = newPacket(workQ, rDeviceB, devicePacketKind)
	workQ = newPacket(workQ, rDeviceB, devicePacketKind)
	s.createHandler(rHandlerB, 3000, workQ, stateWaitingWithPacket())
	s.createDevice(rDeviceA, 4000, nil, stateWaiting())
	s.createDevice(rDeviceB, 5000, nil, stateWaiting())
	s.schedule()
	return s.queuePacketCount == 23246 && s.holdCount == 9297
}

func (s *scheduler) findTask(identity int) *tcb {
	t := s.taskTable[identity]
	if t == nil {
		panic("findTask failed")
	}
	return t
}

func (s *scheduler) holdSelf() *tcb {
	s.holdCount++
	s.currentTask.taskHolding = true
	return s.currentTask.link
}

func (s *scheduler) queuePacket(p *packet) *tcb {
	t := s.findTask(p.identity)
	s.queuePacketCount++
	p.link = nil
	p.identity = s.currentTaskIdentity
	return t.addInputAndCheckPriority(p, s.currentTask)
}

func (s *scheduler) release(identity int) *tcb {
	t := s.findTask(identity)
	t.taskHolding = false
	if t.priority > s.currentTask.priority {
		return t
	}
	return s.currentTask
}

func (s *scheduler) markWaiting() *tcb {
	s.currentTask.taskWaiting = true
	return s.currentTask
}

func (s *scheduler) schedule() {
	s.currentTask = s.taskList
	for s.currentTask != nil {
		if s.currentTask.isTaskHoldingOrWaiting() {
			s.currentTask = s.currentTask.link
		} else {
			s.currentTaskIdentity = s.currentTask.identity
			s.currentTask = s.currentTask.runTask()
		}
	}
}

func richardsInner(inner int) bool {
	for i := 0; i < inner; i++ {
		if !(&scheduler{}).start() {
			return false
		}
	}
	return true
}
