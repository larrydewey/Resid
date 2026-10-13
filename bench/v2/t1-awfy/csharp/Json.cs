// AWFY Json, after the Java reference: a pure-string parser over the RAP
// benchmark document. `current` is a one-character substring of the input
// (the reference's substring), null at the end of the text.
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace Awfy.Json {

public sealed class JsonBench : RepeatingBenchmark {
  static readonly string RapBenchmark = LoadRap();

  static string LoadRap() {
    using Stream s = Assembly.GetExecutingAssembly().GetManifestResourceStream("rap.json");
    using StreamReader r = new StreamReader(s);
    return r.ReadToEnd();
  }

  public override object Run() { return new JsonPureStringParser(RapBenchmark).Parse(); }

  public override bool Verify(object result) {
    if (!(result is JsonObject o)) { return false; }
    if (!(o.Get("head") is JsonObject)) { return false; }
    return o.Get("operations") is JsonArray a && a.Size() == 156;
  }
}

abstract class JsonValue { }

sealed class JsonArray : JsonValue {
  readonly List<JsonValue> values = new List<JsonValue>();
  public void Add(JsonValue v) { values.Add(v); }
  public int Size() { return values.Count; }
}

sealed class JsonNumber : JsonValue {
  public readonly string S;
  public JsonNumber(string s) { S = s; }
}

sealed class JsonString : JsonValue {
  public readonly string S;
  public JsonString(string s) { S = s; }
}

sealed class JsonLiteral : JsonValue {
  public static readonly JsonLiteral Null = new JsonLiteral("null");
  public static readonly JsonLiteral True = new JsonLiteral("true");
  public static readonly JsonLiteral False = new JsonLiteral("false");
  readonly string value;
  JsonLiteral(string v) { value = v; }
}

sealed class JsonObject : JsonValue {
  readonly List<string> names = new List<string>();
  readonly List<JsonValue> values = new List<JsonValue>();
  readonly int[] table = new int[32];

  static int Slot(string name) { return (name.Length * 1402589) & 31; }

  public void Add(string name, JsonValue value) {
    int index = names.Count;
    table[Slot(name)] = index < 0xff ? (index + 1) & 0xff : 0;
    names.Add(name);
    values.Add(value);
  }

  public JsonValue Get(string name) {
    int index = (table[Slot(name)] & 0xff) - 1;
    if (index != -1 && name == names[index]) { return values[index]; }
    throw new Exception("NotImplemented");
  }
}

sealed class JsonPureStringParser {
  readonly string input;
  int index = -1;
  int line = 1;
  int column; // kept from the reference; never read
  string current;
  StringBuilder captureBuffer = new StringBuilder();
  int captureStart = -1;

  public JsonPureStringParser(string s) { input = s; }

  public JsonValue Parse() {
    Read();
    SkipWhiteSpace();
    JsonValue result = ReadValue();
    SkipWhiteSpace();
    if (!IsEndOfText()) { throw new Exception("Unexpected character"); }
    return result;
  }

  JsonValue ReadValue() {
    switch (current) {
      case "n": return ReadNull();
      case "t": return ReadTrue();
      case "f": return ReadFalse();
      case "\"": return ReadString();
      case "[": return ReadArray();
      case "{": return ReadObject();
      case "-": case "0": case "1": case "2": case "3": case "4":
      case "5": case "6": case "7": case "8": case "9":
        return ReadNumber();
    }
    throw new Exception("Expected value");
  }

  JsonValue ReadArray() {
    Read();
    JsonArray array = new JsonArray();
    SkipWhiteSpace();
    if (ReadChar("]")) { return array; }
    do {
      SkipWhiteSpace();
      array.Add(ReadValue());
      SkipWhiteSpace();
    } while (ReadChar(","));
    if (!ReadChar("]")) { throw new Exception("Expected ',' or ']'"); }
    return array;
  }

  JsonValue ReadObject() {
    Read();
    JsonObject obj = new JsonObject();
    SkipWhiteSpace();
    if (ReadChar("}")) { return obj; }
    do {
      SkipWhiteSpace();
      string name = ReadName();
      SkipWhiteSpace();
      if (!ReadChar(":")) { throw new Exception("Expected ':'"); }
      SkipWhiteSpace();
      obj.Add(name, ReadValue());
      SkipWhiteSpace();
    } while (ReadChar(","));
    if (!ReadChar("}")) { throw new Exception("Expected ',' or '}'"); }
    return obj;
  }

  string ReadName() {
    if (current != "\"") { throw new Exception("Expected name"); }
    return ReadStringInternal();
  }

  void Req(string ch) {
    if (!ReadChar(ch)) { throw new Exception("Expected '" + ch + "'"); }
  }

  JsonValue ReadNull() { Read(); Req("u"); Req("l"); Req("l"); return JsonLiteral.Null; }
  JsonValue ReadTrue() { Read(); Req("r"); Req("u"); Req("e"); return JsonLiteral.True; }
  JsonValue ReadFalse() { Read(); Req("a"); Req("l"); Req("s"); Req("e"); return JsonLiteral.False; }

  JsonValue ReadString() { return new JsonString(ReadStringInternal()); }

  string ReadStringInternal() {
    Read();
    StartCapture();
    while (current != "\"") {
      if (current == "\\") {
        PauseCapture();
        ReadEscape();
        StartCapture();
      } else {
        Read();
      }
    }
    string s = EndCapture();
    Read();
    return s;
  }

  void ReadEscape() {
    Read();
    switch (current) {
      case "\"": case "/": case "\\": captureBuffer.Append(current); break;
      case "b": captureBuffer.Append('\b'); break;
      case "f": captureBuffer.Append('\f'); break;
      case "n": captureBuffer.Append('\n'); break;
      case "r": captureBuffer.Append('\r'); break;
      case "t": captureBuffer.Append('\t'); break;
      default: throw new Exception("Expected valid escape sequence");
    }
    Read();
  }

  JsonValue ReadNumber() {
    StartCapture();
    ReadChar("-");
    string firstDigit = current;
    if (!ReadDigit()) { throw new Exception("Expected digit"); }
    if (firstDigit != "0") { while (ReadDigit()) { } }
    ReadFraction();
    ReadExponent();
    return new JsonNumber(EndCapture());
  }

  bool ReadFraction() {
    if (!ReadChar(".")) { return false; }
    if (!ReadDigit()) { throw new Exception("Expected digit"); }
    while (ReadDigit()) { }
    return true;
  }

  bool ReadExponent() {
    if (!ReadChar("e") && !ReadChar("E")) { return false; }
    if (!ReadChar("+")) { ReadChar("-"); }
    if (!ReadDigit()) { throw new Exception("Expected digit"); }
    while (ReadDigit()) { }
    return true;
  }

  bool ReadChar(string ch) {
    if (current != ch) { return false; }
    Read();
    return true;
  }

  bool ReadDigit() {
    if (!IsDigit()) { return false; }
    Read();
    return true;
  }

  void SkipWhiteSpace() { while (IsWhiteSpace()) { Read(); } }

  void Read() {
    if (current == "\n") {
      line++;
      column = 0;
    }
    index++;
    current = index < input.Length ? input.Substring(index, 1) : null;
  }

  void StartCapture() { captureStart = index; }

  void PauseCapture() {
    int end = current == null ? index : index - 1;
    captureBuffer.Append(input, captureStart, end + 1 - captureStart);
    captureStart = -1;
  }

  string EndCapture() {
    int end = current == null ? index : index - 1;
    string captured;
    if (captureBuffer.Length == 0) {
      captured = input.Substring(captureStart, end + 1 - captureStart);
    } else {
      captureBuffer.Append(input, captureStart, end + 1 - captureStart);
      captured = captureBuffer.ToString();
      captureBuffer = new StringBuilder();
    }
    captureStart = -1;
    return captured;
  }

  bool IsWhiteSpace() { return current == " " || current == "\t" || current == "\n" || current == "\r"; }

  bool IsDigit() {
    return current == "0" || current == "1" || current == "2" || current == "3" || current == "4" ||
           current == "5" || current == "6" || current == "7" || current == "8" || current == "9";
  }

  bool IsEndOfText() { return current == null; }
}

}
