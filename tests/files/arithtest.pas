program example(input, output);
var x, y, z: real;
var i, j, k:integer;

begin
  x:= 1 + 2*3/4;
  y:= 1 + 2*3/4.0;
  write(x,y);
  i:=4;
  j:=5;
  k:=i/j + j*i + j mod i + (j-i);
  write(k);
  if k>10 then z:=10 else z:=5;
  write(z);
  i:=1;
  j:=1;
  k:=0;
  if i or j and k then write(1) else write (0);
  while i<k 
  do
  begin
    write (i);
    i:=i+1
  end;
  x:= 5.0 mod 6;
  write(x)
end.
