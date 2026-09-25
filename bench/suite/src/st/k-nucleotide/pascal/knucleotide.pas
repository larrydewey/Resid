{ k-nucleotide (Benchmarks Game algorithm), single-threaded, Free Pascal.
  Uses the RTL's Generics.Collections TDictionary as the hash table; keys are
  k-nucleotides packed 2 bits per base into a QWord. }
program knucleotide;
{$mode objfpc}{$H+}
uses SysUtils, Generics.Collections, Generics.Defaults;

type
  TCounts = specialize TDictionary<QWord, LongInt>;
  TEntry = record
    key: QWord;
    count: LongInt;
  end;

var
  seq: array of byte;
  slen: SizeInt;

function CountFrame(k: longint): TCounts;
var
  key, kmask: QWord;
  i: SizeInt;
  c: LongInt;
begin
  Result := TCounts.Create;
  kmask := (QWord(1) shl (2 * k)) - 1;
  key := 0;
  for i := 0 to k - 2 do key := (key shl 2) or seq[i];
  for i := k - 1 to slen - 1 do
  begin
    key := ((key shl 2) or seq[i]) and kmask;
    if Result.TryGetValue(key, c) then
      Result[key] := c + 1
    else
      Result.Add(key, 1);
  end;
end;

function Decode(key: QWord; k: longint): string;
const
  ACGT: array[0..3] of char = ('A', 'C', 'G', 'T');
var
  i: longint;
begin
  SetLength(Result, k);
  for i := k downto 1 do
  begin
    Result[i] := ACGT[key and 3];
    key := key shr 2;
  end;
end;

function Encode(const s: string): QWord;
var
  i: longint;
begin
  Result := 0;
  for i := 1 to Length(s) do
  begin
    Result := Result shl 2;
    case s[i] of
      'C': Result := Result or 1;
      'G': Result := Result or 2;
      'T': Result := Result or 3;
    end;
  end;
end;

procedure WriteFrequencies(k: longint);
var
  t: TCounts;
  e: array of TEntry;
  tmp: TEntry;
  p: specialize TPair<QWord, LongInt>;
  i, j, m: longint;
  total: double;
begin
  t := CountFrame(k);
  SetLength(e, t.Count);
  m := 0;
  for p in t do
  begin
    e[m].key := p.Key;
    e[m].count := p.Value;
    Inc(m);
  end;
  { insertion sort: count descending, then key (alphabetical) ascending }
  for i := 1 to m - 1 do
  begin
    tmp := e[i];
    j := i - 1;
    while (j >= 0) and ((e[j].count < tmp.count) or
      ((e[j].count = tmp.count) and (e[j].key > tmp.key))) do
    begin
      e[j + 1] := e[j];
      Dec(j);
    end;
    e[j + 1] := tmp;
  end;
  total := slen - k + 1;
  for i := 0 to m - 1 do
    WriteLn(Decode(e[i].key, k), ' ', (100.0 * e[i].count / total):0:3);
  WriteLn;
  t.Free;
end;

procedure WriteCount(const s: string);
var
  t: TCounts;
  c: LongInt;
begin
  t := CountFrame(Length(s));
  if not t.TryGetValue(Encode(s), c) then c := 0;
  WriteLn(c, #9, s);
  t.Free;
end;

var
  line: string;
  inbuf: array[0..65535] of char;
  i: SizeInt;
  found: boolean;
begin
  SetTextBuf(Input, inbuf, SizeOf(inbuf));
  found := false;
  while not EOF(Input) do
  begin
    ReadLn(line);
    if (Length(line) >= 6) and (Copy(line, 1, 6) = '>THREE') then
    begin
      found := true;
      break;
    end;
  end;
  if not found then Halt(1);
  SetLength(seq, 1 shl 20);
  slen := 0;
  while not EOF(Input) do
  begin
    ReadLn(line);
    if (Length(line) > 0) and (line[1] = '>') then break;
    if slen + Length(line) > Length(seq) then SetLength(seq, 2 * Length(seq) + Length(line));
    for i := 1 to Length(line) do
    begin
      case line[i] of
        'a', 'A': seq[slen] := 0;
        'c', 'C': seq[slen] := 1;
        'g', 'G': seq[slen] := 2;
        't', 'T': seq[slen] := 3;
      else
        continue;
      end;
      Inc(slen);
    end;
  end;

  WriteFrequencies(1);
  WriteFrequencies(2);
  WriteCount('GGT');
  WriteCount('GGTA');
  WriteCount('GGTATT');
  WriteCount('GGTATTTTAATT');
  WriteCount('GGTATTTTAATTTATAGT');
end.
