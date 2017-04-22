var x:int;
fun a():int
{
  fun b():int
  {
    fun c():int
    {
      return d(x)+1;
    };
    return c()+1;
  };
  fun d(a:int):int
  {
    return a+1;
  };
  return b()+1;
};
x:=7;
x := a();
print x;
