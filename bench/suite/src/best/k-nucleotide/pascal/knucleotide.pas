{ k-nucleotide, tuned Free Pascal (not a Benchmarks Game program: there is no
  Free Pascal k-nucleotide entry there).  Same algorithm and hash table as the
  st cell (Generics.Collections TDictionary, 2-bit packed QWord keys); the
  seven frames are counted concurrently, one TThread each (largest first),
  and each dictionary is pre-sized. }
program knucleotide;
{$mode objfpc}{$H+}
uses {$IFDEF UNIX}cthreads,{$ENDIF} Classes, SysUtils, Generics.Collections, Generics.Defaults;

type
  { key -> index into a per-frame count array, so a hit costs one lookup }
  TCounts = specialize TDictionary<QWord, LongInt>;

  TKeyComparer = class(TInterfacedObject, specialize IEqualityComparer<QWord>)
  public
    function Equals(constref ALeft, ARight: QWord): Boolean; reintroduce;
    function GetHashCode(constref AValue: QWord): UInt32; reintroduce;
  end;

  TFrame = class
    Dict: TCounts;
    Counts: array of LongInt;
    destructor Destroy; override;
  end;
  TEntry = record
    key: QWord;
    count: LongInt;
  end;

function TKeyComparer.Equals(constref ALeft, ARight: QWord): Boolean;
begin
  Result := ALeft = ARight;
end;

function TKeyComparer.GetHashCode(constref AValue: QWord): UInt32;
var
  h: QWord;
begin
  h := AValue * QWord($9E3779B97F4A7C15);
  Result := UInt32(h shr 32);
end;

destructor TFrame.Destroy;
begin
  Dict.Free;
  inherited Destroy;
end;

var
  KeyComparer: specialize IEqualityComparer<QWord>;
  seq: array of byte;
  slen: SizeInt;

function CountFrame(k: longint): TFrame;
var
  key, kmask, want: QWord;
  i: SizeInt;
  idx, n: LongInt;
  d: TCounts;
begin
  if 2 * k < 40 then want := QWord(1) shl (2 * k) else want := slen;
  if want > QWord(slen) then want := slen;
  Result := TFrame.Create;
  d := TCounts.Create(want, KeyComparer);
  Result.Dict := d;
  SetLength(Result.Counts, want + 1);
  n := 0;
  kmask := (QWord(1) shl (2 * k)) - 1;
  key := 0;
  for i := 0 to k - 2 do key := (key shl 2) or seq[i];
  for i := k - 1 to slen - 1 do
  begin
    key := ((key shl 2) or seq[i]) and kmask;
    if d.TryGetValue(key, idx) then
      Inc(Result.Counts[idx])
    else
    begin
      d.Add(key, n);
      Result.Counts[n] := 1;
      Inc(n);
    end;
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

procedure WriteFrequencies(k: longint; t: TFrame);
var
  e: array of TEntry;
  tmp: TEntry;
  p: specialize TPair<QWord, LongInt>;
  i, j, m: longint;
  total: double;
begin
  SetLength(e, t.Dict.Count);
  m := 0;
  for p in t.Dict do
  begin
    e[m].key := p.Key;
    e[m].count := t.Counts[p.Value];
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

procedure WriteCount(const s: string; t: TFrame);
var
  c: LongInt;
begin
  if t.Dict.TryGetValue(Encode(s), c) then c := t.Counts[c] else c := 0;
  WriteLn(c, #9, s);
  t.Free;
end;

const
  FRAMES: array[0..6] of longint = (1, 2, 3, 4, 6, 12, 18);
  QUERIES: array[2..6] of string = ('GGT', 'GGTA', 'GGTATT', 'GGTATTTTAATT',
    'GGTATTTTAATTTATAGT');

type
  TCounter = class(TThread)
  public
    K: longint;
    Table: TFrame;
    constructor Create(AK: longint);
  protected
    procedure Execute; override;
  end;

constructor TCounter.Create(AK: longint);
begin
  K := AK;
  FreeOnTerminate := false;
  inherited Create(false);
end;

procedure TCounter.Execute;
begin
  Table := CountFrame(K);
end;

var
  line: string;
  workers: array[0..6] of TCounter;
  f: longint;
  inbuf: array[0..65535] of char;
  i: SizeInt;
  found: boolean;
begin
  KeyComparer := TKeyComparer.Create;
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

  for f := 6 downto 0 do workers[f] := TCounter.Create(FRAMES[f]);
  for f := 0 to 6 do workers[f].WaitFor;
  WriteFrequencies(1, workers[0].Table);
  WriteFrequencies(2, workers[1].Table);
  for f := 2 to 6 do WriteCount(QUERIES[f], workers[f].Table);
  for f := 0 to 6 do workers[f].Free;
  KeyComparer := nil;
end.
