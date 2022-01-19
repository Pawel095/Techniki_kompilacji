program proc(inp,out);
var g,i,j,m,n:integer;


function f:real;
begin
    f:=1-2*1E+4
end;

function proc2(a:integer;b:real):integer;
begin
    proc2:=a+b
end;

begin
    i:=1;
    j:=2;
    g:=2 mod 3;
    m:=f;
    n:=proc2(1,3);
    write(m);
    write(n)
end.
