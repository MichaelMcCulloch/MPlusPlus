module MSemantics where

import SymbolTable
import AST
import IntermediateRepresentation
import Control.Monad.State.Lazy
import Control.Monad.Except
{-the goal of this file is to generate the IR using a
  dynamically generated SymbolTable-}
genSymbolTable::M_prog -> Either String I_prog
genSymbolTable ast = evalStateT (handleProg ast (newScope L_Prog empty)) 0

handleProg::M_prog -> ST -> StateErr I_prog
handleProg (M_prog (decls, stmts)) st = do
  let functions = filter isFunction decls
      variables = filter isVariable decls
      datas     = filter isData decls
      decls'    = variables ++ datas ++ functions   -- because variable declarations need to come first.
  st' <- foldM insertElem st decls'                 -- build current scope
  iFunBodies <-  mapM (handleFun st') functions
  iBody <- mapM (handleStmt st') stmts
  return $ I_PROG (iFunBodies, length variables,[],iBody)

handleFun::ST -> M_decl -> StateErr I_fbody   --build a new scope and use it to typecheck statements
handleFun st decl = throwError "handleFun"

handleStmt:: ST -> M_stmt -> StateErr I_stmt
handleStmt st decl = throwError "handleStmt"

insertElem::ST -> M_decl -> StateErr ST
insertElem st decl =
  case decl of
    M_var   (pident, arrExpr, vType) -> do
      --typeCheck each of arrExpr, then:
      insert st (VARIABLE (pident, vType, length arrExpr))
    M_fun   (pident, args, fType, _, _) -> do
      let args' = map (\(_, dims, aType) -> (aType, dims)) args
      insert st (FUNCTION (pident, args', fType))
    M_data  (((l,c), name), constrs) -> do
      st' <- insert st (DATATYPE ((l,c), name))   --insert the datatype first
      let cons' = map (\(c, ts) -> (c, ts, name)) constrs --then insert each constructor
          fCon st (((l,c), name), types, parent) = insert st (CONSTRUCTOR (((l,c), name), types, parent))
          in foldM fCon st' cons'


isFunction::M_decl -> Bool
isFunction (M_fun _) = True
isFunction _ = False

isVariable::M_decl -> Bool
isVariable (M_var _) = True
isVariable _ = False

isData::M_decl -> Bool
isData (M_data _) = True
isData _ = False
