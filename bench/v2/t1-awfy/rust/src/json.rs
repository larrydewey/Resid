// AWFY Json, after the Java reference: a pure-string parser over the RAP
// benchmark document. `current` is a one-character &str slice of the input
// (the reference's substring), "" at the end of the text.

#[allow(dead_code)]
enum JsonValue { Object(JsonObject), Array(Vec<JsonValue>), Number(String), Str(String), Null, True, False }

struct JsonObject { names: Vec<String>, values: Vec<JsonValue>, table: [i32; 32] }

impl JsonObject {
    fn new() -> JsonObject { JsonObject { names: Vec::new(), values: Vec::new(), table: [0; 32] } }
    fn slot(name: &str) -> usize { ((name.len() as i32).wrapping_mul(1402589) & 31) as usize }
    fn add(&mut self, name: String, value: JsonValue) {
        let index = self.names.len() as i32;
        self.table[JsonObject::slot(&name)] = if index < 0xff { (index + 1) & 0xff } else { 0 };
        self.names.push(name);
        self.values.push(value);
    }
    fn get(&self, name: &str) -> Option<&JsonValue> {
        let index = (self.table[JsonObject::slot(name)] & 0xff) - 1;
        if index != -1 && name == self.names[index as usize] { return Some(&self.values[index as usize]); }
        panic!("NotImplemented");
    }
}

struct Parser<'a> { input: &'a str, index: i64, line: i32, column: i32, current: &'a str, eot: bool, capture_buffer: String, capture_start: i64 }

impl<'a> Parser<'a> {
    fn new(input: &'a str) -> Parser<'a> {
        Parser { input, index: -1, line: 1, column: 0, current: "", eot: false, capture_buffer: String::new(), capture_start: -1 }
    }
    fn parse(&mut self) -> JsonValue {
        self.read();
        self.skip_white_space();
        let result = self.read_value();
        self.skip_white_space();
        if !self.eot { panic!("Unexpected character"); }
        result
    }
    fn read_value(&mut self) -> JsonValue {
        match self.current {
            "n" => self.read_null(),
            "t" => self.read_true(),
            "f" => self.read_false(),
            "\"" => JsonValue::Str(self.read_string_internal()),
            "[" => self.read_array(),
            "{" => self.read_object(),
            "-" | "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" => self.read_number(),
            _ => panic!("Expected value"),
        }
    }
    fn read_array(&mut self) -> JsonValue {
        self.read();
        let mut array = Vec::new();
        self.skip_white_space();
        if self.read_char("]") { return JsonValue::Array(array); }
        loop {
            self.skip_white_space();
            array.push(self.read_value());
            self.skip_white_space();
            if !self.read_char(",") { break; }
        }
        if !self.read_char("]") { panic!("Expected ',' or ']'"); }
        JsonValue::Array(array)
    }
    fn read_object(&mut self) -> JsonValue {
        self.read();
        let mut object = JsonObject::new();
        self.skip_white_space();
        if self.read_char("}") { return JsonValue::Object(object); }
        loop {
            self.skip_white_space();
            let name = self.read_name();
            self.skip_white_space();
            if !self.read_char(":") { panic!("Expected ':'"); }
            self.skip_white_space();
            let v = self.read_value();
            object.add(name, v);
            self.skip_white_space();
            if !self.read_char(",") { break; }
        }
        if !self.read_char("}") { panic!("Expected ',' or '}}'"); }
        JsonValue::Object(object)
    }
    fn read_name(&mut self) -> String {
        if self.current != "\"" { panic!("Expected name"); }
        self.read_string_internal()
    }
    fn read_null(&mut self) -> JsonValue { self.read(); self.req("u"); self.req("l"); self.req("l"); JsonValue::Null }
    fn read_true(&mut self) -> JsonValue { self.read(); self.req("r"); self.req("u"); self.req("e"); JsonValue::True }
    fn read_false(&mut self) -> JsonValue { self.read(); self.req("a"); self.req("l"); self.req("s"); self.req("e"); JsonValue::False }
    fn req(&mut self, ch: &str) { if !self.read_char(ch) { panic!("Expected '{}'", ch); } }
    fn read_string_internal(&mut self) -> String {
        self.read();
        self.start_capture();
        while self.current != "\"" {
            if self.current == "\\" {
                self.pause_capture();
                self.read_escape();
                self.start_capture();
            } else {
                self.read();
            }
        }
        let s = self.end_capture();
        self.read();
        s
    }
    fn read_escape(&mut self) {
        self.read();
        match self.current {
            "\"" | "/" | "\\" => { let c = self.current; self.capture_buffer.push_str(c); }
            "b" => self.capture_buffer.push('\u{8}'),
            "f" => self.capture_buffer.push('\u{c}'),
            "n" => self.capture_buffer.push('\n'),
            "r" => self.capture_buffer.push('\r'),
            "t" => self.capture_buffer.push('\t'),
            _ => panic!("Expected valid escape sequence"),
        }
        self.read();
    }
    fn read_number(&mut self) -> JsonValue {
        self.start_capture();
        self.read_char("-");
        let first_digit = self.current;
        if !self.read_digit() { panic!("Expected digit"); }
        if first_digit != "0" { while self.read_digit() {} }
        self.read_fraction();
        self.read_exponent();
        JsonValue::Number(self.end_capture())
    }
    fn read_fraction(&mut self) -> bool {
        if !self.read_char(".") { return false; }
        if !self.read_digit() { panic!("Expected digit"); }
        while self.read_digit() {}
        true
    }
    fn read_exponent(&mut self) -> bool {
        if !self.read_char("e") && !self.read_char("E") { return false; }
        if !self.read_char("+") { self.read_char("-"); }
        if !self.read_digit() { panic!("Expected digit"); }
        while self.read_digit() {}
        true
    }
    fn read_char(&mut self, ch: &str) -> bool {
        if self.current != ch { return false; }
        self.read();
        true
    }
    fn read_digit(&mut self) -> bool {
        if !self.is_digit() { return false; }
        self.read();
        true
    }
    fn skip_white_space(&mut self) { while self.is_white_space() { self.read(); } }
    fn read(&mut self) {
        if self.current == "\n" { self.line += 1; self.column = 0; }
        self.index += 1;
        let i = self.index as usize;
        if i < self.input.len() {
            self.current = &self.input[i..i + 1];
        } else {
            self.current = "";
            self.eot = true;
        }
    }
    fn start_capture(&mut self) { self.capture_start = self.index; }
    fn pause_capture(&mut self) {
        let end = if self.eot { self.index } else { self.index - 1 };
        let piece = &self.input[self.capture_start as usize..(end + 1) as usize];
        self.capture_buffer.push_str(piece);
        self.capture_start = -1;
    }
    fn end_capture(&mut self) -> String {
        let end = if self.eot { self.index } else { self.index - 1 };
        let piece = &self.input[self.capture_start as usize..(end + 1) as usize];
        let captured = if self.capture_buffer.is_empty() {
            piece.to_string()
        } else {
            self.capture_buffer.push_str(piece);
            std::mem::take(&mut self.capture_buffer)
        };
        self.capture_start = -1;
        captured
    }
    fn is_white_space(&self) -> bool { matches!(self.current, " " | "\t" | "\n" | "\r") }
    fn is_digit(&self) -> bool { matches!(self.current, "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9") }
}

fn verify(r: &JsonValue) -> bool {
    let o = match r { JsonValue::Object(o) => o, _ => return false };
    if !matches!(o.get("head"), Some(JsonValue::Object(_))) { return false; }
    match o.get("operations") { Some(JsonValue::Array(a)) => a.len() == 156, _ => false }
}

pub fn inner(inner: i32) -> bool {
    (0..inner).all(|_| verify(&Parser::new(RAP).parse()))
}

const RAP: &str = include_str!("rap.json");
