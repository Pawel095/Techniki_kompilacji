program sort(input, output);
var x:integer;
function b(x:integer):integer;
begin
  write(x);
  x := x-1;
  
  if x > 0 then 
    b := b(x)
  else
    b:=x
end;

procedure c(x:integer);
begin
  write(x);
  x := x-1;
  
  if x > 0 then 
    c(x)
  else
    x:=b(10)
end;


begin
  x := b(2);
  write(9999);
  write(x);
  write(9999);
  c(3)
end.