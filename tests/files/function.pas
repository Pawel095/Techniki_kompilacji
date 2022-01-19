program proc(inp,out);
var g,i,j,m,n:integer;


function f(b:integer;c:real):real;
var g:real;
begin
    f:=b-c*b
end;

function proc2(a:integer;b:real):integer;
begin
    proc2:=a+b
end;

begin
    i:=1;
    j:=2;
    g:=2 mod 3;
    m:=f(i,j+g);
    n:=proc2(1,3);
    write(m);
    write(n)
end.
