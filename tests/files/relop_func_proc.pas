program prog1(inp,out);
var a:integer;

function func1(a,b:integer):integer;
begin
    func1:= a <> b
end;

function func2(a,b,c:integer):integer;
begin
    func2:= (a < b) and (a = c)
end;


begin
    a:=10;
    write(func1(0,1));
    write(func2(a,50,100));
    write(a)
end.
