var x,y:int;
fun exp(b:int):int
  { var z:int;
    if b=0 then z:= 1
        else z:= x * exp(b-1);
    return z;
  };
read x;
read y;
print exp(y);
