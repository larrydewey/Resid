{ regex-redux (Benchmarks Game algorithm), single-threaded Free Pascal.
  Uses the FPC-bundled RegExpr unit (TRegExpr), Free Pascal's customary
  regular expression library. }
program regexredux;
{$mode objfpc}{$H+}
uses SysUtils, RegExpr;

const
  VARIANTS: array[0..8] of string = (
    'agggtaaa|tttaccct',
    '[cgt]gggtaaa|tttaccc[acg]',
    'a[act]ggtaaa|tttacc[agt]t',
    'ag[act]gtaaa|tttac[agt]ct',
    'agg[act]taaa|ttta[agt]cct',
    'aggg[acg]aaa|ttt[cgt]ccct',
    'agggt[cgt]aa|tt[acg]accct',
    'agggta[cgt]a|t[acg]taccct',
    'agggtaa[cgt]|[acg]ttaccct');
  PATS: array[0..4] of string = (
    'tHa[Nt]', 'aND|caN|Ha[DS]|WaS', 'a[NSt]|BY', '<[^>]*>', '\|[^|][^|]*\|');
  REPS: array[0..4] of string = ('<4>', '<3>', '<2>', '|', '-');

function ReadAll: string;
var
  n, got: SizeInt;
begin
  SetLength(Result, 1 shl 20);
  n := 0;
  repeat
    if n = Length(Result) then SetLength(Result, 2 * Length(Result));
    got := FileRead(StdInputHandle, Result[n + 1], Length(Result) - n);
    if got > 0 then Inc(n, got);
  until got <= 0;
  SetLength(Result, n);
end;

function ReplaceAll(const pat, rep, s: string): string;
var
  re: TRegExpr;
begin
  re := TRegExpr.Create(pat);
  re.ModifierS := false; { '.' does not match newline }
  re.ModifierM := false;
  Result := re.Replace(s, rep, false);
  re.Free;
end;

function CountMatches(const pat, s: string): longint;
var
  re: TRegExpr;
begin
  re := TRegExpr.Create(pat);
  Result := 0;
  if re.Exec(s) then
    repeat
      Inc(Result);
    until not re.ExecNext;
  re.Free;
end;

var
  seq, s: string;
  ilen, clen, i: SizeInt;
begin
  seq := ReadAll;
  ilen := Length(seq);
  seq := ReplaceAll('>.*\n|\n', '', seq);
  clen := Length(seq);
  for i := 0 to 8 do
    WriteLn(VARIANTS[i], ' ', CountMatches(VARIANTS[i], seq));
  s := seq;
  for i := 0 to 4 do
    s := ReplaceAll(PATS[i], REPS[i], s);
  WriteLn;
  WriteLn(ilen);
  WriteLn(clen);
  WriteLn(Length(s));
end.
