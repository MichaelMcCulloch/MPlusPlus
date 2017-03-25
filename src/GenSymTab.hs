module GenSymTab where

import SymbolTable
import AST
import Control.Monad.State.Lazy

genSymbolTable::M_prog -> Either String ST
genSymbolTable ast = evalStateT (foldProg ast (newScope L_Prog empty)) 0


foldProg::M_prog -> ST -> StateErr ST
foldProg (M_prog (decls, stmts)) st = do
  st' <- foldDecl decls st
  foldStmts stmts st'

foldDecl::[M_decl] -> ST -> StateErr ST
foldDecl [] st = return st
foldDecl (d:decls) st =
  case d of
    M_var (name,dims,mType) -> do
      st' <- insert st (VARIABLE (name, mType, length dims))
      foldDecl decls st'
    M_fun (name,args,mType,ds,stmts) -> do
      st' <- insert st (FUNCTION (name, map (\(n, dims, aType) -> (aType, dims)) args, mType)) --insert the function declaration first
      st'' <- foldDecl decls st'                                                               --then insert the rest
      let st''' = newScope (L_Fun mType) st''                                                  --lastly, create a new scope and fold inside the function
          in do
            stFArgs <- foldM fArg st''' args
            stFDecls <- foldDecl ds stFArgs
            foldStmts stmts stFDecls
    M_data (name,constrs) -> do
      st' <- insert st (DATATYPE name)
      let cons' = map (\(c, ts) -> (c, ts, name)) constrs
          in foldM fCon st' cons'
  where
    fArg st (name, dims, aType) = insert st (ARGUMENT (name, aType, dims))
    fCon st (name, types, parent) = insert st (CONSTRUCTOR (name, types, parent))

foldStmts::[M_stmt] -> ST -> StateErr ST
foldStmts [] st = return st
foldStmts (s:stmts) st = return st
