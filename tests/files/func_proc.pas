program proc(inp,out);
var g:integer;


procedure show(b:integer;c:real);
var g:real;
begin
    g:=b-c*b;
    write(b);
    write(c);
    write(g)
end;

function p1(a:real):real;
var temp:real;
begin
    temp:= a;
    p1:=temp*a
end;

function p2(a:integer):integer;
var temp:integer;
begin
    temp:= a;
    p2:=temp/a
end;

procedure level1(b:integer;c:real);
var t1:real;
var t2:integer;
begin
    t1:=p1(b);
    t2:=p2(c);
    show(t1,t2)
end;

begin
    level1(4,0.1E4);
    write(g)
end.
