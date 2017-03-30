module GenSymTab where

import SymbolTable
import AST
import Control.Monad.State.Lazy
import Control.Monad.Except

genSymbolTable::M_prog -> Either String ST
genSymbolTable ast = evalStateT (foldProg ast (newScope L_Prog empty)) 0

foldProg::M_prog -> ST -> StateErr ST
foldProg (M_prog (decls, stmts)) st = do
  st' <- foldDecl decls st
  foldStmts stmts st'

--foldDecl adds elements to the symbol table.
foldDecl::[M_decl] -> ST -> StateErr ST
foldDecl [] st = return st
foldDecl (d:decls) st =
  case d of
    M_var (((l,c), name),dims,mType) -> do
      st' <- insert st (VARIABLE (((l,c), name), mType, length dims))
      foldDecl decls st'
    M_fun (((l,c), name),args,mType,ds,stmts) -> do
      {-insert the function declaration first
        then insert the rest
        lastly, create a new scope and fold inside the function-}
      st' <- insert st (FUNCTION (((l,c), name), map (\(n, dims, aType) -> (aType, dims)) args, mType))
      st'' <- foldDecl decls st'
      let st''' = newScope (L_Fun mType) st''
          in do
            stFArgs <- foldM fArg st''' args
            stFDecls <- foldDecl ds stFArgs
            foldStmts stmts stFDecls
    M_data (((l,c), name),constrs) -> do
      st' <- insert st (DATATYPE ((l,c), name))
      let cons' = map (\(c, ts) -> (c, ts, name)) constrs
          in do
            stDat <- foldM fCon st' cons'
            foldDecl decls stDat
  where
    fArg st (((l,c), name), dims, aType) = insert st (ARGUMENT (((l,c), name), aType, dims))
    fCon st (((l,c), name), types, parent) = insert st (CONSTRUCTOR (((l,c), name), types, parent))

--foldStmts checks if things are in scope (and does typechecking?).
foldStmts::[M_stmt] -> ST -> StateErr ST
foldStmts [] st = return st
foldStmts (s:stmts) st =
  case s of
    M_ass (((l,c), name), arrExprs, expr) -> do
      attr <- lookup_ ((l,c), name) st
      case attr of
        I_VARIABLE (_, _, vType, arrDims) -> return st-- check that name is declared in scope with correct size, check that pieces of expr are declared
        I_TYPE _ -> throwError ("Error:" ++ show l ++ ":" ++ show c ++ ": <" ++ name ++ " is declared as a datatype")
        I_CONSTRUCTOR (_,_,parent) -> throwError ("Error:" ++ show l ++ ":" ++ show c ++ ": <" ++ name ++ " is declared as a constructor of " ++ parent)
        I_FUNCTION _ -> throwError ("Error:" ++ show l ++ ":" ++ show c ++ ": <" ++ name ++ " is declared as a function")
    M_while (expr, body) -> return st     --check that condition i
    M_cond (expr, stmt1, stmt2) -> return st
    M_read (name, arrExprs) -> return st
    M_print expr -> return st
    M_return expr -> return st
    {-Block and case are done last, new scopes are needed for each-}
    M_block (decs, sts) -> return st
    M_case (expr, cases) -> return st
