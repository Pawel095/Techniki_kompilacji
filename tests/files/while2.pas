program p0(inp,out);
var i,j:integer;
var result:real;

begin
    result:=2.0;
    while (i < 10) and (result < 0.2E6) do
    begin
        j:=1;
        while j < 10 do 
        begin
            j:=j+1;
            result := result*i + j;
            write(result)
        end;
        i:=i+1
    end
end.
