{ pidigits (Benchmarks Game algorithm), single-threaded Free Pascal.
  Arbitrary precision arithmetic is GMP's mpz API via FPC's gmp unit. }
program pidigits;
{$mode objfpc}
uses gmp;

var
  acc, den, num, tmp1, tmp2: mpz_t;

procedure NextTerm(k: longint);
var
  k2: valuint;
begin
  k2 := 2 * k + 1;
  mpz_addmul_ui(acc, num, 2);
  mpz_mul_ui(acc, acc, k2);
  mpz_mul_ui(den, den, k2);
  mpz_mul_ui(num, num, k);
end;

function ExtractDigit(nth: longint): longint;
begin
  mpz_mul_ui(tmp1, num, nth);
  mpz_add(tmp2, tmp1, acc);
  mpz_tdiv_q(tmp1, tmp2, den);
  Result := mpz_get_ui(tmp1);
end;

procedure EliminateDigit(d: longint);
begin
  mpz_submul_ui(acc, den, d);
  mpz_mul_ui(acc, acc, 10);
  mpz_mul_ui(num, num, 10);
end;

var
  n, i, k, d, col, code: longint;
  line: string[10];
begin
  n := 30;
  if ParamCount >= 1 then Val(ParamStr(1), n, code);
  mpz_init_set_ui(acc, 0);
  mpz_init_set_ui(den, 1);
  mpz_init_set_ui(num, 1);
  mpz_init(tmp1);
  mpz_init(tmp2);
  i := 0;
  k := 0;
  col := 0;
  line := '';
  while i < n do
  begin
    Inc(k);
    NextTerm(k);
    if mpz_cmp(num, acc) > 0 then continue;
    d := ExtractDigit(3);
    if d <> ExtractDigit(4) then continue;
    line := line + Chr(Ord('0') + d);
    Inc(col);
    Inc(i);
    if col = 10 then
    begin
      WriteLn(line, #9':', i);
      line := '';
      col := 0;
    end;
    EliminateDigit(d);
  end;
  if col <> 0 then
  begin
    while Length(line) < 10 do line := line + ' ';
    WriteLn(line, #9':', i);
  end;
end.
