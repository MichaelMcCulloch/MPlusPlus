var x:int;
fun f(y:int, z:int):int
  {  var x, a[y][z] :int;
     fun g(a[][]:int, b:int):int
        {   var y :int;
            begin
              a[1][2] := f(x,y);
              return a[1][2];
            end
        };
        return a[1][2];
  };
var v:int;

/*
[SymbolTable (L_Fun M_int,1,2,[ ("y",Var_attr (1,M_int,0)),
                                ("b",Var_attr (-5,M_int,0)),
                                ("a",Var_attr (-4,M_int,2))]),
SymbolTable (L_Fun M_int,2,2,[  ("g",Fun_attr ("fn_1",[(M_int,2),(M_int,0)],M_int)),
                                ("a",Var_attr (2,M_int,2)),
                                ("x",Var_attr (1,M_int,0)),
                                ("z",Var_attr (-5,M_int,0)),
                                ("y",Var_attr (-4,M_int,0))]),
SymbolTable (L_Prog,2,0,[       ("v",Var_attr (2,M_int,0)),
                                ("f",Fun_attr ("fn_0",[(M_int,0),(M_int,0)],M_int)),
                                ("x",Var_attr (1,M_int,0))])]
*/
