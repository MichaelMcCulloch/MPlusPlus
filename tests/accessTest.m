var x:int;
fun a():int
  { fun b():int
      { fun c():int
          { return d(x); };
        return 1;
      };
    fun d(a:int):int
      { return x; };
    return 1;
  };

x := a();
