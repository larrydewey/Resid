{ n-body (Benchmarks Game algorithm), single-threaded, plain Free Pascal. }
program nbody;
{$mode objfpc}

const
  NB = 5;
  PI = 3.141592653589793;
  SOLAR_MASS = 4.0 * PI * PI;
  DAYS_PER_YEAR = 365.24;

type
  TBody = record
    x, y, z, vx, vy, vz, mass: double;
  end;

var
  b: array[0..NB - 1] of TBody;

procedure SetBody(i: integer; x, y, z, vx, vy, vz, m: double);
begin
  b[i].x := x; b[i].y := y; b[i].z := z;
  b[i].vx := vx * DAYS_PER_YEAR; b[i].vy := vy * DAYS_PER_YEAR; b[i].vz := vz * DAYS_PER_YEAR;
  b[i].mass := m * SOLAR_MASS;
end;

procedure OffsetMomentum;
var
  px, py, pz: double;
  i: integer;
begin
  px := 0; py := 0; pz := 0;
  for i := 0 to NB - 1 do
  begin
    px := px + b[i].vx * b[i].mass;
    py := py + b[i].vy * b[i].mass;
    pz := pz + b[i].vz * b[i].mass;
  end;
  b[0].vx := -px / SOLAR_MASS;
  b[0].vy := -py / SOLAR_MASS;
  b[0].vz := -pz / SOLAR_MASS;
end;

function Energy: double;
var
  i, j: integer;
  dx, dy, dz: double;
begin
  Result := 0;
  for i := 0 to NB - 1 do
  begin
    Result := Result + 0.5 * b[i].mass * (b[i].vx * b[i].vx + b[i].vy * b[i].vy + b[i].vz * b[i].vz);
    for j := i + 1 to NB - 1 do
    begin
      dx := b[i].x - b[j].x;
      dy := b[i].y - b[j].y;
      dz := b[i].z - b[j].z;
      Result := Result - b[i].mass * b[j].mass / Sqrt(dx * dx + dy * dy + dz * dz);
    end;
  end;
end;

procedure Advance(dt: double);
var
  i, j: integer;
  dx, dy, dz, d2, mag: double;
begin
  for i := 0 to NB - 1 do
    for j := i + 1 to NB - 1 do
    begin
      dx := b[i].x - b[j].x;
      dy := b[i].y - b[j].y;
      dz := b[i].z - b[j].z;
      d2 := dx * dx + dy * dy + dz * dz;
      mag := dt / (d2 * Sqrt(d2));
      b[i].vx := b[i].vx - dx * b[j].mass * mag;
      b[i].vy := b[i].vy - dy * b[j].mass * mag;
      b[i].vz := b[i].vz - dz * b[j].mass * mag;
      b[j].vx := b[j].vx + dx * b[i].mass * mag;
      b[j].vy := b[j].vy + dy * b[i].mass * mag;
      b[j].vz := b[j].vz + dz * b[i].mass * mag;
    end;
  for i := 0 to NB - 1 do
  begin
    b[i].x := b[i].x + dt * b[i].vx;
    b[i].y := b[i].y + dt * b[i].vy;
    b[i].z := b[i].z + dt * b[i].vz;
  end;
end;

var
  n, i, code: longint;
begin
  n := 1000;
  if ParamCount >= 1 then Val(ParamStr(1), n, code);
  SetBody(0, 0, 0, 0, 0, 0, 0, 1);
  SetBody(1, 4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
    1.66007664274403694e-03, 7.69901118419740425e-03, -6.90460016972063023e-05, 9.54791938424326609e-04);
  SetBody(2, 8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
    -2.76742510726862411e-03, 4.99852801234917238e-03, 2.30417297573763929e-05, 2.85885980666130812e-04);
  SetBody(3, 1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
    2.96460137564761618e-03, 2.37847173959480950e-03, -2.96589568540237556e-05, 4.36624404335156298e-05);
  SetBody(4, 1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
    2.68067772490389322e-03, 1.62824170038242295e-03, -9.51592254519715870e-05, 5.15138902046611451e-05);
  OffsetMomentum;
  WriteLn(Energy:0:9);
  for i := 1 to n do Advance(0.01);
  WriteLn(Energy:0:9);
end.
