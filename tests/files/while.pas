program p0(inp,out);
var i:integer;
var result:real;

begin
    result:=2.0;
    while (i < 10) and (result < 0.2E6) do
    begin
        result := result * result;
        i:=i+1;
        write(result)
    end
end.
