// AWFY Json, after the Java reference: a pure-string parser over the RAP
// benchmark document. `current` is a one-character substring of the input
// (the reference's substring), "" at the end of the text.
package main

import _ "embed"

//go:embed rap.json
var rapBenchmark string

type jsonValue interface{}

type jsonArray struct{ values []jsonValue }
type jsonNumber struct{ s string }
type jsonString struct{ s string }
type jsonLiteral struct{ name string }

var jsonNull = &jsonLiteral{"null"}
var jsonTrue = &jsonLiteral{"true"}
var jsonFalse = &jsonLiteral{"false"}

type jsonObject struct {
	names  []string
	values []jsonValue
	table  [32]int
}

func jsonSlot(name string) int { return (len(name) * 1402589) & 31 }

func (o *jsonObject) add(name string, value jsonValue) {
	index := len(o.names)
	if index < 0xff {
		o.table[jsonSlot(name)] = (index + 1) & 0xff
	} else {
		o.table[jsonSlot(name)] = 0
	}
	o.names = append(o.names, name)
	o.values = append(o.values, value)
}

func (o *jsonObject) get(name string) jsonValue {
	index := (o.table[jsonSlot(name)] & 0xff) - 1
	if index != -1 && name == o.names[index] {
		return o.values[index]
	}
	panic("NotImplemented")
}

type jsonParser struct {
	input         string
	index         int
	line, column  int
	current       string
	captureBuffer []byte
	captureStart  int
}

func newJsonParser(input string) *jsonParser {
	return &jsonParser{input: input, index: -1, line: 1, captureStart: -1}
}

func (p *jsonParser) parse() jsonValue {
	p.read()
	p.skipWhiteSpace()
	result := p.readValue()
	p.skipWhiteSpace()
	if !p.isEndOfText() {
		panic("Unexpected character")
	}
	return result
}

func (p *jsonParser) readValue() jsonValue {
	switch p.current {
	case "n":
		return p.readNull()
	case "t":
		return p.readTrue()
	case "f":
		return p.readFalse()
	case "\"":
		return &jsonString{p.readStringInternal()}
	case "[":
		return p.readArray()
	case "{":
		return p.readObject()
	case "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
		return p.readNumber()
	}
	panic("Expected value")
}

func (p *jsonParser) readArray() jsonValue {
	p.read()
	array := &jsonArray{}
	p.skipWhiteSpace()
	if p.readChar("]") {
		return array
	}
	for {
		p.skipWhiteSpace()
		array.values = append(array.values, p.readValue())
		p.skipWhiteSpace()
		if !p.readChar(",") {
			break
		}
	}
	if !p.readChar("]") {
		panic("Expected ',' or ']'")
	}
	return array
}

func (p *jsonParser) readObject() jsonValue {
	p.read()
	object := &jsonObject{}
	p.skipWhiteSpace()
	if p.readChar("}") {
		return object
	}
	for {
		p.skipWhiteSpace()
		name := p.readName()
		p.skipWhiteSpace()
		if !p.readChar(":") {
			panic("Expected ':'")
		}
		p.skipWhiteSpace()
		object.add(name, p.readValue())
		p.skipWhiteSpace()
		if !p.readChar(",") {
			break
		}
	}
	if !p.readChar("}") {
		panic("Expected ',' or '}'")
	}
	return object
}

func (p *jsonParser) readName() string {
	if p.current != "\"" {
		panic("Expected name")
	}
	return p.readStringInternal()
}

func (p *jsonParser) req(ch string) {
	if !p.readChar(ch) {
		panic("Expected '" + ch + "'")
	}
}

func (p *jsonParser) readNull() jsonValue {
	p.read()
	p.req("u")
	p.req("l")
	p.req("l")
	return jsonNull
}

func (p *jsonParser) readTrue() jsonValue {
	p.read()
	p.req("r")
	p.req("u")
	p.req("e")
	return jsonTrue
}

func (p *jsonParser) readFalse() jsonValue {
	p.read()
	p.req("a")
	p.req("l")
	p.req("s")
	p.req("e")
	return jsonFalse
}

func (p *jsonParser) readStringInternal() string {
	p.read()
	p.startCapture()
	for p.current != "\"" {
		if p.current == "\\" {
			p.pauseCapture()
			p.readEscape()
			p.startCapture()
		} else {
			p.read()
		}
	}
	s := p.endCapture()
	p.read()
	return s
}

func (p *jsonParser) readEscape() {
	p.read()
	switch p.current {
	case "\"", "/", "\\":
		p.captureBuffer = append(p.captureBuffer, p.current...)
	case "b":
		p.captureBuffer = append(p.captureBuffer, '\b')
	case "f":
		p.captureBuffer = append(p.captureBuffer, '\f')
	case "n":
		p.captureBuffer = append(p.captureBuffer, '\n')
	case "r":
		p.captureBuffer = append(p.captureBuffer, '\r')
	case "t":
		p.captureBuffer = append(p.captureBuffer, '\t')
	default:
		panic("Expected valid escape sequence")
	}
	p.read()
}

func (p *jsonParser) readNumber() jsonValue {
	p.startCapture()
	p.readChar("-")
	firstDigit := p.current
	if !p.readDigit() {
		panic("Expected digit")
	}
	if firstDigit != "0" {
		for p.readDigit() {
		}
	}
	p.readFraction()
	p.readExponent()
	return &jsonNumber{p.endCapture()}
}

func (p *jsonParser) readFraction() bool {
	if !p.readChar(".") {
		return false
	}
	if !p.readDigit() {
		panic("Expected digit")
	}
	for p.readDigit() {
	}
	return true
}

func (p *jsonParser) readExponent() bool {
	if !p.readChar("e") && !p.readChar("E") {
		return false
	}
	if !p.readChar("+") {
		p.readChar("-")
	}
	if !p.readDigit() {
		panic("Expected digit")
	}
	for p.readDigit() {
	}
	return true
}

func (p *jsonParser) readChar(ch string) bool {
	if p.current != ch {
		return false
	}
	p.read()
	return true
}

func (p *jsonParser) readDigit() bool {
	if !p.isDigit() {
		return false
	}
	p.read()
	return true
}

func (p *jsonParser) skipWhiteSpace() {
	for p.isWhiteSpace() {
		p.read()
	}
}

func (p *jsonParser) read() {
	if p.current == "\n" {
		p.line++
		p.column = 0
	}
	p.index++
	if p.index < len(p.input) {
		p.current = p.input[p.index : p.index+1]
	} else {
		p.current = ""
	}
}

func (p *jsonParser) startCapture() { p.captureStart = p.index }

func (p *jsonParser) captureEnd() int {
	if p.isEndOfText() {
		return p.index
	}
	return p.index - 1
}

func (p *jsonParser) pauseCapture() {
	end := p.captureEnd()
	p.captureBuffer = append(p.captureBuffer, p.input[p.captureStart:end+1]...)
	p.captureStart = -1
}

func (p *jsonParser) endCapture() string {
	end := p.captureEnd()
	piece := p.input[p.captureStart : end+1]
	var captured string
	if len(p.captureBuffer) == 0 {
		captured = piece
	} else {
		p.captureBuffer = append(p.captureBuffer, piece...)
		captured = string(p.captureBuffer)
		p.captureBuffer = p.captureBuffer[:0]
	}
	p.captureStart = -1
	return captured
}

func (p *jsonParser) isWhiteSpace() bool {
	switch p.current {
	case " ", "\t", "\n", "\r":
		return true
	}
	return false
}

func (p *jsonParser) isDigit() bool {
	return len(p.current) == 1 && p.current[0] >= '0' && p.current[0] <= '9'
}

func (p *jsonParser) isEndOfText() bool { return p.current == "" }

func jsonVerify(r jsonValue) bool {
	o, ok := r.(*jsonObject)
	if !ok {
		return false
	}
	if _, ok := o.get("head").(*jsonObject); !ok {
		return false
	}
	a, ok := o.get("operations").(*jsonArray)
	return ok && len(a.values) == 156
}

func jsonInner(inner int) bool {
	for i := 0; i < inner; i++ {
		if !jsonVerify(newJsonParser(rapBenchmark).parse()) {
			return false
		}
	}
	return true
}
