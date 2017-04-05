module SemCheck where


import SymbolTable
import AST
import Errors
import IntermediateRepresentation
import Control.Monad.State.Lazy
import Control.Monad.Except

generateIR::M_prog -> Either String I_prog
generateIR ast = evalStateT (handleProg ast (newScope L_Prog empty)) (0,0)


handleProg::M_prog -> ST -> StateErr I_prog
handleProg (M_prog (decls, stmts)) st = let
  datas = filter isData decls
  functions = filter isFun decls
  variables = filter isVar decls
  decls' = datas ++ variables ++ functions in do
  st' <- foldM insertElem st decls'
  varDesc <- mapM (checkVars st') variables
  iFuns <- mapM (checkFuns st') functions
  iStmts <- mapM (checkBody st') stmts
  return $ I_PROG (iFuns, length variables, varDesc, iStmts)

checkVars:: ST -> M_decl -> StateErr (Int, [I_expr])
checkVars st (M_var (pid, args, _)) = do
  desc <- lookup_ pid st
  case desc of
    I_VARIABLE (lvl, off, _, dims) -> do
      iArgs <- mapM (wfExpr st) args
      let types = map fst iArgs
          iExprs = map snd iArgs
          in if all (== M_int) types
            then return (off, iExprs)
            else throwError $ errorPid pid IndexErr
    _ -> throwError $ errorPid pid (IdentErr Var)

checkFuns:: ST -> M_decl -> StateErr I_fbody
checkFuns st (M_fun (pid, argDesc, fType, fDecls, fBody)) =  let
  insertArg st (pid, dims, aType) =  insert st (ARGUMENT (pid, aType, dims))
  datas = filter isData fDecls
  functions = filter isFun fDecls
  variables = filter isVar fDecls
  decls' = datas ++ variables ++ functions    --put dataDecarations first
  st' = newScope (L_Fun fType) st             --make a new scope for this function
  varsAndArgs = variables ++ map (\(pid, _, t) -> M_var (pid, [], t)) argDesc in do
    desc <- lookup_ pid st
    case desc of
      I_FUNCTION (_,lbl, _, _) -> do
        st'' <- foldM insertArg st' argDesc         --insert all arguments
        st''' <- foldM insertElem st'' decls'       --insert all declarations
        varDesc <- mapM (checkVars st''') variables
        iFuns <- mapM (checkFuns st''') functions
        iStmts <- mapM (checkBody st''') fBody
        return $ I_FUN (lbl, iFuns, length argDesc, length variables, varDesc, iStmts)
      _-> throwError $ errorPid pid (IdentErr Fun)

checkBody::ST -> M_stmt -> StateErr I_stmt
checkBody st stmt =
  case stmt of
    M_ass (pid, mArgs, mAssign) -> do
      desc <- lookup_ pid st
      case desc of
        I_VARIABLE (lvl, off, vType, dims) -> do
          iArgs <- mapM (wfExpr st) mArgs
          (aType, aExpr) <- wfExpr st mAssign
          let types = map fst iArgs
              iExprs = map snd iArgs
              in if vType == aType
                then if all (== M_int) types
                  then return $ I_ASS (lvl, off, iExprs, aExpr)
                  else throwError $ errorPid pid IndexErr
                else throwError $ errorPid pid (Type vType aType)
        _ -> throwError $ errorPid pid (IdentErr Var)
    M_while (mExpr, action) -> do
      (t, iExp) <- wfExpr st mExpr
      iStmt <- checkBody st action
      if t == M_bool
        then return $ I_WHILE (iExp, iStmt)
        else throwError $ error_ (Type M_bool t)
    M_cond (condExpr, thenStmt, elseStmt) -> do
      (t, iExpr) <- wfExpr st condExpr
      iThen <- checkBody st thenStmt
      iElse <- checkBody st elseStmt
      if t == M_bool
        then return $ I_COND (iExpr, iThen, iElse)
        else throwError $ error_ (Type M_bool t)
    M_read (pid, arrDesc) -> do
      desc <- lookup_ pid st
      case desc of
        I_VARIABLE (lvl, off, vType, dim) -> do
          iArrDesc <- mapM (wfExpr st) arrDesc
          let types = map fst iArrDesc
              iExprs = map snd iArrDesc
              in if all (== M_int) types && dim == length arrDesc
                then case vType of
                  M_int -> return $ I_READ_I (lvl, off, iExprs)
                  M_bool -> return $ I_READ_B (lvl, off, iExprs)
                  M_real -> return $ I_READ_F (lvl, off, iExprs)
                  M_char -> return $ I_READ_C (lvl, off, iExprs)
                  _ -> throwError $ errorPid pid (ReadData vType)
                else throwError $ errorPid pid IndexErr
        _ -> throwError $ errorPid pid (IdentErr Var)
    M_print mExpr -> do
      (t, iExpr) <- wfExpr st mExpr
      case t of
        M_int -> return $ I_PRINT_I iExpr
        M_bool -> return $ I_PRINT_B iExpr
        M_real -> return $ I_PRINT_F iExpr
        M_char -> return $ I_PRINT_C iExpr
        _ -> throwError $ error_ (ReadData t)
    M_return mExpr -> do
      returnType <- return_ st
      (t, iExpr) <- wfExpr st mExpr
      if t == returnType
        then return $ I_RETURN iExpr
        else throwError $ error_ (Type returnType t)
    M_block (decls, stmts) -> let
      datas = filter isData decls
      functions = filter isFun decls
      variables = filter isVar decls
      decls' = datas ++ variables ++ functions    --put data decarations first
      st' = newScope L_Blk st in do               --make block scope
      st'' <- foldM insertElem st' decls'         --insert declarations
      iFuns <- mapM (checkFuns st'') functions
      varDesc <- mapM (checkVars st'') variables
      iStmts <- mapM (checkBody st'') stmts
      return $ I_BLOCK (iFuns, length variables, varDesc, iStmts)
    M_case (caseExpr, caseArgs) -> do
      (t, iExpr) <- wfExpr st caseExpr
      case t of
        M_type pid -> do
          iCaseArgs <- mapM (checkCase st) caseArgs
          return $ I_CASE (iExpr, iCaseArgs)
        _ -> throwError $ error_ (CaseErr t)
    where
      checkCase::ST -> (PCID, [PIdent], M_stmt) -> StateErr (Int, Int, I_stmt)
      checkCase st (cid, args, action) = do
        desc <- lookup_ cid st
        case desc of
          I_CONSTRUCTOR (conNum, types, parent) ->
            if length types == length args
              then let
                st' = newScope L_Cases st in do --make a new scope
                  st'' <- foldM insertCase st' (zip types args)
                  iAction <- checkBody st'' action
                  return (conNum, length args, iAction)
              else throwError $ errorPid cid (ArgNum (length types) (length args))
          _ -> throwError $ errorPid cid (IdentErr Constr)
        -- make a new argument, and give it the type the constructor says to give it
      insertCase::ST -> (M_type, PIdent) -> StateErr ST
      insertCase st (t, ident) = insert st (ARGUMENT (ident, t, 0))

wfExpr::ST -> M_expr -> StateErr (M_type, I_expr)
wfExpr _ (M_ival int)     = return (M_int,  I_IVAL int)
wfExpr _ (M_rval double)  = return (M_real, I_RVAL double)
wfExpr _ (M_bval bool)    = return (M_bool, I_BVAL bool)
wfExpr _ (M_cval char)    = return (M_char, I_CVAL char)
wfExpr st (M_size (pid, dim)) = do
  desc <- lookup_ pid st
  case desc of
    I_VARIABLE (lvl,off,mType,maxDims) ->
      if (maxDims >= dim)
        then return (M_int, I_SIZE (lvl, off, dim))
        else throwError $ errorPid pid IndexErr
    _ -> throwError $ errorPid pid (IdentErr Var)
wfExpr st (M_id (pid, arrayDesc)) = do
  desc <- lookup_ pid st
  case desc of
    I_VARIABLE (lvl, off, mType, maxDims) ->
      if length arrayDesc <= maxDims              --check array dimension is in bounds.
        then do
          arrCheck <- mapM (wfExpr st) arrayDesc
          let types   = map fst arrCheck
              iExprs  = map snd arrCheck
              in if all (== M_int) types
                then return (mType, I_ID (lvl, off, iExprs))
                else throwError $ errorPid pid IndexErr
        else throwError $ errorPid pid IndexErr
    _ -> throwError $ errorPid pid (IdentErr Var)
wfExpr st (M_app (operation, listOfArguments)) = do
  (opType, opAction) <- wfOperation st (operation, listOfArguments)
  return (opType, I_APP opAction)

wfOperation::ST -> (M_operation, [M_expr]) -> StateErr (M_type, (I_opn, [I_expr]))
wfOperation st (op, args) = do
  argumentTypes <- mapM (wfExpr st) args
  let types = map fst argumentTypes
      iexprs = map snd argumentTypes
  case op of
    M_add -> case types of
      [M_int, M_int] -> return (M_int, (I_ADD_I, iexprs))
      [M_real, M_real] -> return (M_real, (I_ADD_F, iexprs))
      _ -> throwError $ error_ BadArgument
    M_mul -> case types of
      [M_int, M_int] -> return (M_int, (I_MUL_I, iexprs))
      [M_real, M_real] -> return (M_real, (I_MUL_F, iexprs))
      _ -> throwError $ error_ BadArgument
    M_sub -> case types of
      [M_int, M_int] -> return (M_int, (I_SUB_I, iexprs))
      [M_real, M_real] -> return (M_real, (I_SUB_F, iexprs))
      _ -> throwError $ error_ BadArgument
    M_div -> case types of
      [M_int, M_int] -> return (M_int, (I_DIV_I, iexprs))
      [M_real, M_real] -> return (M_real, (I_DIV_F, iexprs))
      _ -> throwError $ error_ BadArgument
    M_neg -> case types of
      [M_int] -> return (M_int, (I_NEG_I, iexprs))
      [M_real] -> return (M_real, (I_NEG_F, iexprs))
      _ -> throwError $ error_ BadArgument
    M_lt  -> case types of
      [M_int, M_int] ->   return (M_bool, (I_LT_I ,iexprs))
      [M_real, M_real] -> return (M_bool, (I_LT_F ,iexprs))
      [M_char, M_char] -> return (M_bool, (I_LT_C ,iexprs))
      _ -> throwError $ error_ BadArgument
    M_le  -> case types of
      [M_int, M_int] ->   return (M_bool, (I_LE_I ,iexprs))
      [M_real, M_real] -> return (M_bool, (I_LE_F ,iexprs))
      [M_char, M_char] -> return (M_bool, (I_LE_C ,iexprs))
      _ -> throwError $ error_ BadArgument
    M_gt  -> case types of
      [M_int, M_int] ->   return (M_bool, (I_GT_I ,iexprs))
      [M_real, M_real] -> return (M_bool, (I_GT_F ,iexprs))
      [M_char, M_char] -> return (M_bool, (I_GT_C ,iexprs))
      _ -> throwError $ error_ BadArgument
    M_ge  -> case types of
      [M_int, M_int] ->   return (M_bool, (I_GE_I ,iexprs))
      [M_real, M_real] -> return (M_bool, (I_GE_F ,iexprs))
      [M_char, M_char] -> return (M_bool, (I_GE_C ,iexprs))
      _ -> throwError $ error_ BadArgument
    M_eq  -> case types of
      [M_int, M_int] ->   return (M_bool, (I_EQ_I ,iexprs))
      [M_real, M_real] -> return (M_bool, (I_EQ_F ,iexprs))
      [M_char, M_char] -> return (M_bool, (I_EQ_C ,iexprs))
      _ -> throwError $ error_ BadArgument
    M_not -> if types == [M_bool]
      then return (M_bool, (I_NOT, iexprs))
      else throwError $ error_ BadArgument
    M_and -> if types == [M_bool, M_bool]
      then return (M_bool, (I_AND, iexprs))
      else throwError $ error_ BadArgument
    M_or  -> if types == [M_bool, M_bool]
      then return (M_bool, (I_OR, iexprs))
      else throwError $ error_ BadArgument
    M_float -> if types == [M_int]
      then return (M_real, (I_FLOAT, iexprs))
      else throwError $ error_ BadArgument
    M_floor -> if types == [M_real]
      then return (M_int, (I_FLOOR, iexprs))
      else throwError $ error_ BadArgument
    M_ceil  -> if types == [M_real]
      then return (M_int, (I_CEIL, iexprs))
      else throwError $ error_ BadArgument
    M_cid cid -> do
      desc <- lookup_ cid st
      case desc of
        I_CONSTRUCTOR (conNum, expectedTypes, parent) ->
          if and $ zipWith (==) expectedTypes types
            then return (M_type ((0,0), parent), (I_CONS (conNum, length expectedTypes), iexprs))
            else throwError $ errorPid cid (ArgNum (length expectedTypes) (length types))
        _ -> throwError $ errorPid cid (IdentErr Constr)
    M_fn pid -> do
      desc <- lookup_ pid st
      case desc of
        I_FUNCTION (lvl, lbl, argumentTypesAndDims, funType) ->
          if length argumentTypesAndDims == length args
            then do
              newParams <- zipWithM (wfFunctionCall st pid) argumentTypesAndDims args
              return $ (funType, (I_CALL (lbl, lvl), newParams))
            else throwError $ errorPid pid (ArgNum (length argumentTypesAndDims) (length args))
        _ -> throwError $ errorPid pid (IdentErr Fun)

wfFunctionCall::ST -> PIdent -> (M_type, Int) -> M_expr -> StateErr I_expr
wfFunctionCall st pid (expType, expDims) mExpr = do
  (pType, pExpr) <- wfExpr st mExpr
  if expType == pType                     -- if type matches
    then if expDims == 0                  -- if not expecting an array
      then case mExpr of
        M_id (vid, arrayDesc) -> do       -- then its ok if we are actually passing a value, not an incomplete index
          desc <- lookup_ vid st
          case desc of
            I_VARIABLE (_,_,_, maxDims) -> if length arrayDesc == maxDims
              then return pExpr
              else throwError $ errorPid vid BadArgument
            _ -> throwError $ errorPid vid (IdentErr Var)
        _ -> return pExpr                 -- a value or function
      else case mExpr of                  -- must be an array
        M_id (vid, []) -> do
          desc <- lookup_ vid st
          case desc of
            I_VARIABLE (lvl,off,_, maxDims) -> if expDims == maxDims
              then return $ I_REF (lvl, off)
              else throwError $ errorPid vid BadArgument
            _ -> throwError $ errorPid vid (IdentErr Var)
        _ -> throwError $ errorPid pid (IdentErr Array)
    else throwError $ errorPid pid (Type expType pType)

insertElem::ST -> M_decl -> StateErr ST
insertElem st decl =
  -- no type checking yet, just add it.
  case decl of
    M_var   (pident, arrExpr, vType) ->
      insert st (VARIABLE (pident, vType, length arrExpr))
    M_fun   (pident, args, fType, _, _) -> do
      let args' = map (\(_, dims, aType) -> (aType, dims)) args
      insert st (FUNCTION (pident, args', fType))
    M_data  (((l,c), name), constrs) -> do
      st' <- insert st (DATATYPE ((l,c), name))   --insert the datatype first
      let cons' = map (\(c, ts) -> (c, ts, name)) constrs --then insert each constructor
          fCon st (((l,c), name), types, parent) = insert st (CONSTRUCTOR (((l,c), name), types, parent))
          in foldM fCon st' cons'

sortDecls::[M_decl] -> [M_decl]
sortDecls decls = let
  datas = filter isData decls
  functions = filter isFun decls
  variables = filter isVar decls
  decls' = datas ++ variables ++ functions
  in decls'

isData::M_decl -> Bool
isData (M_data _) = True
isData _ = False

isFun:: M_decl -> Bool
isFun (M_fun _) = True
isFun _ = False

isVar:: M_decl -> Bool
isVar (M_var _) = True
isVar _ = False
