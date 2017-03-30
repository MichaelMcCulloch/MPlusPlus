module AST where

type PIdent = ((Int, Int), String) --Line, Column
type PCID = ((Int, Int) ,String)

data M_prog = M_prog ([M_decl],[M_stmt])
            deriving (Eq, Show)
data M_decl = M_var (PIdent,[M_expr],M_type)
            | M_fun (PIdent,[(PIdent,Int,M_type)],M_type,[M_decl],[M_stmt])
            | M_data (PIdent,[(PCID,[M_type])])
            deriving (Eq, Show)
data M_stmt = M_ass (PIdent,[M_expr],M_expr)
            | M_while (M_expr,M_stmt)
            | M_cond (M_expr,M_stmt,M_stmt)
            | M_read (PIdent,[M_expr])
            | M_print M_expr
            | M_return M_expr
            | M_block ([M_decl],[M_stmt])
            | M_case (M_expr,[(PCID,[PIdent],M_stmt)])
            deriving (Eq, Show)
data M_type = M_int | M_bool | M_real | M_char | M_type PIdent
            deriving (Eq, Show)
data M_expr = M_ival Integer
            | M_rval Double
            | M_bval Bool
            | M_cval Char
            | M_size (PIdent,Int)
            | M_id (PIdent,[M_expr])
            | M_app (M_operation,[M_expr])
            deriving (Eq, Show)
data M_operation
            = M_fn PIdent --
            | M_cid PCID
            | M_add | M_mul | M_sub | M_div
            | M_neg
            | M_lt | M_le | M_gt | M_ge | M_eq
            | M_not | M_and | M_or
            | M_float | M_floor | M_ceil
            deriving (Eq,Show)

showProg::M_prog-> String
showProg (M_prog (ds, ss)) = concatMap (`showDecl` 0) ds ++ "\n" ++ concatMap (`showStmt` 0) ss ++ "\n"

showDecl::M_decl -> Int -> String
showDecl d i =
  let r j = (concat $ replicate (j-1) "  ")
      in case d of
        M_var (name, array, type_) -> r i++ show d ++ ";\n"
        M_fun (((_,_),name), arguments, type_, ds, ss) -> r i ++ "M_fun (" ++ name ++ concatMap show arguments ++ show type_ ++ ")" ++ "{\n" ++
                                                  concatMap (`showDecl` (i+1)) ds ++ concatMap (`showStmt` (i+1)) ss ++ r (i+1)++ "};\n"
        M_data (((_,_),name), constructors) -> r i ++ "M_data (" ++ "\"" ++ name ++ "\"" ++ "[\n"++ concatMap (`showConstructors` (i+1)) constructors ++ r (i+1) ++"])\n"

showConstructors::(PCID,[M_type]) -> Int -> String
showConstructors (((_,_),s), ts) i =
  let r = (concat $ replicate (i-1) "  ") in
      r ++ show s ++ concatMap show ts ++ ",\n"

showStmt::M_stmt -> Int -> String
showStmt s i =
  let r j = (concat $ replicate (j-1) "  ")
      in case s of
        M_ass (name, address, expr) -> r i ++ show s ++ "\n"
        M_while (cond, stmt) -> r i ++ "M_while (" ++ show cond ++ ")" ++ "{\n" ++ showStmt stmt (i+1) ++ r (i+1) ++ "};\n"
        M_cond (cond, then_, else_) -> r i ++ "M_Cond (" ++ show cond ++ "\n" ++ r (i+1) ++ show then_ ++ "\n" ++ r (i+1) ++ show else_ ++ ")" ++ "\n"
        M_print e -> r i ++ show s ++ "\n"
        M_read (name, address) -> r i ++ show s ++ "\n"
        M_return e -> r i ++ show s ++ "\n"
        M_block (ds,ss) -> r i ++ "M_block (" ++ concatMap (`showDecl` (i+1)) ds ++ "\n" ++ concatMap (`showStmt` (i+1)) ss ++ r (i+1) ++ ");\n"
        M_case (e, cases) -> r i ++ "M_case (" ++ show e ++ "[\n" ++ concatMap (`showCases` (i+1)) cases ++ r (i+1) ++ "])\n"

showCases::(PCID,[PIdent],M_stmt) -> Int -> String
showCases c@(((_,_),case_), args, stmt) i =
  let r =  (concat $ replicate (i-1) "  ") in
      case stmt of
        M_block _ -> r ++ show case_ ++ show args ++ "\n" ++ showStmt stmt (i+1)
        M_ass _ -> r ++ show c  ++ "\n"
        M_while _ -> r ++ show case_ ++ show args ++ "\n" ++ showStmt stmt (i+1)
        M_cond _ -> r ++ show case_ ++ show args ++ "\n" ++ showStmt stmt (i+1)
        M_print _ -> r ++ show c ++ "\n"
        M_read _ -> r ++ show c ++ "\n"
        M_return _ ->r ++ show c ++ "\n"
        M_case _ -> r ++ show case_ ++ show args ++ "\n" ++ showStmt stmt (i+1)
