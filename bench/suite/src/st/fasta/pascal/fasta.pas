{ fasta (Benchmarks Game algorithm), single-threaded, plain Free Pascal.
  Output is collected in a byte buffer and flushed with FileWrite. }
program fasta;
{$mode objfpc}
uses SysUtils;

const
  IM = 139968;
  IA = 3877;
  IC = 29573;
  WIDTH = 60;
  ALU: ansistring =
    'GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG' +
    'GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA' +
    'CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT' +
    'ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA' +
    'GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG' +
    'AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC' +
    'AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA';
  BUFSIZE = 65536;

type
  TProbs = array of double;

var
  buf: array[0..BUFSIZE - 1] of char;
  blen: longint = 0;
  last: longint = 42;

procedure FlushOut;
begin
  if blen > 0 then FileWrite(StdOutputHandle, buf[0], blen);
  blen := 0;
end;

procedure Put(c: char); inline;
begin
  if blen = BUFSIZE then FlushOut;
  buf[blen] := c;
  Inc(blen);
end;

procedure Puts(const s: ansistring);
var
  i: longint;
begin
  for i := 1 to Length(s) do Put(s[i]);
end;

procedure RepeatFasta(cnt: longint);
var
  i, k, col: longint;
begin
  k := 1;
  col := 0;
  for i := 1 to cnt do
  begin
    Put(ALU[k]);
    Inc(k);
    if k > Length(ALU) then k := 1;
    Inc(col);
    if col = WIDTH then
    begin
      Put(#10);
      col := 0;
    end;
  end;
  if col <> 0 then Put(#10);
end;

procedure RandomFasta(const chars: ansistring; const probs: TProbs; cnt: longint);
var
  cum: TProbs;
  acc, r: double;
  i, j, m, col: longint;
begin
  m := Length(probs);
  SetLength(cum, m);
  acc := 0;
  for j := 0 to m - 1 do
  begin
    acc := acc + probs[j];
    cum[j] := acc;
  end;
  col := 0;
  for i := 1 to cnt do
  begin
    last := (last * IA + IC) mod IM;
    r := 1.0 * double(last) / double(IM);
    j := 0;
    while (j < m - 1) and not (r < cum[j]) do Inc(j);
    Put(chars[j + 1]);
    Inc(col);
    if col = WIDTH then
    begin
      Put(#10);
      col := 0;
    end;
  end;
  if col <> 0 then Put(#10);
end;

var
  n, code: longint;
  iub, hs: TProbs;
begin
  n := 1000;
  if ParamCount >= 1 then Val(ParamStr(1), n, code);
  iub := TProbs.Create(0.27, 0.12, 0.12, 0.27, 0.02, 0.02, 0.02, 0.02,
    0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02);
  hs := TProbs.Create(0.3029549426680, 0.1979883004921, 0.1975473066391, 0.3015094502008);
  Puts('>ONE Homo sapiens alu'#10);
  RepeatFasta(2 * n);
  Puts('>TWO IUB ambiguity codes'#10);
  RandomFasta('acgtBDHKMNRSVWY', iub, 3 * n);
  Puts('>THREE Homo sapiens frequency'#10);
  RandomFasta('acgt', hs, 5 * n);
  FlushOut;
end.
