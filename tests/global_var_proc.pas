program proc(inp,out);
var g:real;


procedure setg(r:real);
var g:integer;
begin
    g:=r
end;

begin
    write(g[1]);
    setg(5.0);
    write(g[1])
end.
