var x:int;
fun f(y:int, z:int):int
  {  var x, a[y][z] :int;
     fun g(a[][]:int, b:int):int
        {   var i,j,y :int;
            begin
              a[i][j] := f(x,y);
              return a;
            end
        };
        return a;
  };
var v:int;
