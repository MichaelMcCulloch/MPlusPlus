module SemCheck where


import SymbolTable
import AST
import Errors
import IntermediateRepresentation
import Control.Monad.State.Lazy
import Control.Monad.Except

generateIR::M_prog -> Either String I_prog
generateIR ast = evalStateT (handleProg ast (newScope L_Prog empty)) (1,1)


handleProg::M_prog -> ST -> StateErr I_prog
handleProg (M_prog (decls, stmts)) st = let
  datas = filter isData decls
  functions = filter isFun decls
  variables = filter isVar decls
  decls' = variables ++ functions in do
  st' <- insertData st datas
  st'' <- foldM insertElem st' decls'
  varDesc <- mapM (checkVars st'') variables
  iFuns <- mapM (checkFuns st'') functions
  iStmts <- mapM (checkBody st'') stmts
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
  decls' = variables ++ functions    --put dataDecarations first
  st' = newScope (L_Fun fType) st             --make a new scope for this function
  varsAndArgs = variables ++ map (\(pid, _, t) -> M_var (pid, [], t)) argDesc in do
    desc <- lookup_ pid st
    case desc of
      I_FUNCTION (_,lbl, _, _) -> do
        st'' <- foldM insertArg st' argDesc         --insert all arguments
        st''' <- insertData st'' datas
        st'''' <- foldM insertElem st''' decls'       --insert all declarations
        varDesc <- mapM (checkVars st'''') variables
        iFuns <- mapM (checkFuns st'''') functions
        iStmts <- mapM (checkBody st'''') fBody
        return $ I_FUN (lbl, iFuns, length argDesc, length variables, varDesc, iStmts)
      _-> throwError $ errorPid pid (IdentErr Fun)

checkBody::ST -> M_stmt -> StateErr I_stmt
checkBody st stmt =
  case stmt of
    M_ass (pid, mArgs, mAssign) -> do
      desc <- lookup_ pid st
      case desc of
        I_VARIABLE (lvl, off, vType, dims) -> do
          (types, iExprs) <- mapAndUnzipM (wfExpr st) mArgs
          (aType, aExpr) <- wfExpr st mAssign
          if vType == aType
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
          (types, iExprs) <- mapAndUnzipM (wfExpr st) arrDesc
          if all (== M_int) types && dim == length arrDesc
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
      decls' = variables ++ functions    --put data decarations first
      st' = newScope L_Blk st in do               --make block scope
      st'' <- insertData st' datas
      st''' <- foldM insertElem st'' decls'         --insert declarations
      iFuns <- mapM (checkFuns st''') functions
      varDesc <- mapM (checkVars st''') variables
      iStmts <- mapM (checkBody st''') stmts
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
wfExpr st expr =
  case expr of
    M_ival i -> return (M_int,  I_IVAL i)
    M_bval i -> return (M_bool, I_BVAL i)
    M_rval i -> return (M_real, I_RVAL i)
    M_cval i -> return (M_char, I_CVAL i)
    M_size (pid, n) -> do
      var <- lookup_ pid st
      case var of
        I_VARIABLE (lvl, off, _, dims)
          | n < dims -> return (M_int, I_SIZE (lvl, off, n))
          | otherwise -> throwError $ errorPid pid IndexErr
        _ -> throwError $ errorPid pid (IdentErr Var)
    M_id (pid, mExprs) -> do
      var <- lookup_ pid st
      case var of
        I_VARIABLE (lvl, off, vType, dim)
          | length mExprs <= dim -> do
              (types, iExprs) <- mapAndUnzipM (wfExpr st) mExprs
              if all (== M_int) types
                then return (vType, I_ID (lvl, off, iExprs))
                else throwError $ errorPid pid IndexErr
          | otherwise -> throwError $ errorPid pid (DimNum dim (length mExprs))
        _ -> throwError $ errorPid pid (IdentErr Var)
    M_app (op, mExprs) -> do
      (appType, iOpn) <- wfOperation st (op, mExprs)
      return (appType, I_APP iOpn)

wfOperation::ST -> (M_operation, [M_expr]) -> StateErr (M_type, (I_opn, [I_expr]))
wfOperation st (op,mExprs) = do
  (mTypes, iExprs) <- mapAndUnzipM (wfExpr st) mExprs
  case (op, mTypes) of
    (M_fn pid, args) -> do
      fun <- lookup_ pid st
      case fun of
        I_FUNCTION (lvl, lbl, fArgs, fType) -> let
          (argTypes, dims) = unzip fArgs
          in if (length args == length fArgs)
            then if and $ zipWith (==) argTypes args
              then do
                iParams <- zipWithM (transform st) mExprs dims
                return (fType, (I_CALL (lbl, lvl), iParams))
              else throwError $ errorPid pid (BadArgument argTypes args)
            else throwError $ errorPid pid (ArgNum (length fArgs) (length args))
        _ -> throwError $ errorPid pid (IdentErr Fun)
        where
          transform::ST -> M_expr -> Int -> StateErr I_expr
          transform st m 0 = --check if expr no dims
            case m of
              (M_id (pid, arrayArgs)) -> do
                var <- lookup_ pid st
                case var of
                  I_VARIABLE (lvl, off, _, dims)
                    | dims == length arrayArgs -> do
                      (types, iExprs) <- mapAndUnzipM (wfExpr st) arrayArgs
                      if all (== M_int) types
                        then return $ I_ID (lvl, off, iExprs)
                        else throwError $ errorPid pid IndexErr
                    | otherwise -> throwError $ errorPid pid (DimNum dims (length arrayArgs))
                  _ -> throwError $ errorPid pid (IdentErr Var)
              _ -> do
                (t, iExpr) <- wfExpr st m
                return iExpr
          transform st m n =
            case m of
              (M_id (pid, [])) -> do
                var <- lookup_ pid st
                case var of
                  I_VARIABLE (lvl, off, _, dims)
                    | dims == n -> return $ I_REF (lvl, off)
                    | otherwise -> throwError $ errorPid pid (DimNum dims n)
                  _ -> throwError $ error_ (IdentErr Var)
              _ -> throwError $ error_ (IdentErr Array)
    (M_cid cid, args) -> do
      con <- lookup_ cid st
      case con of
        I_CONSTRUCTOR (conNum, typeComp, parent) ->
          if length typeComp == length args
            then if and $ zipWith (==) mTypes typeComp
              then return (M_type ((0,0), parent), (I_CONS (conNum, length typeComp), iExprs))
              else throwError $ errorPid cid (BadArgument typeComp mTypes)
            else throwError $ errorPid cid (ArgNum (length typeComp) (length args))
        _ -> throwError $ errorPid cid (IdentErr Constr)
    (M_add, [M_int, M_int]) ->    return (M_int, (I_ADD_I, iExprs))
    (M_add, [M_real, M_real]) ->  return (M_real, (I_ADD_F, iExprs))
    (M_mul, [M_int, M_int]) ->    return (M_int, (I_MUL_I, iExprs))
    (M_mul, [M_real, M_real]) ->  return (M_real, (I_MUL_F, iExprs))
    (M_sub, [M_int, M_int]) ->    return (M_int, (I_SUB_I, iExprs))
    (M_sub, [M_real, M_real]) ->  return (M_real, (I_SUB_F, iExprs))
    (M_div, [M_int, M_int]) ->    return (M_int, (I_DIV_I, iExprs))
    (M_div, [M_real, M_real]) ->  return (M_real, (I_DIV_F, iExprs))
    (M_neg, [M_int]) ->           return (M_int, (I_NEG_I, iExprs))
    (M_neg, [M_real]) ->          return (M_real, (I_NEG_F, iExprs))
    (M_lt, [M_int, M_int]) ->     return (M_bool, (I_LT_I, iExprs))
    (M_lt, [M_real, M_real]) ->   return (M_bool, (I_LT_F, iExprs))
    (M_lt, [M_char, M_char]) ->   return (M_bool, (I_LT_C, iExprs))
    (M_le, [M_int, M_int]) ->     return (M_bool, (I_LE_I, iExprs))
    (M_le, [M_real, M_real]) ->   return (M_bool, (I_LE_F, iExprs))
    (M_le, [M_char, M_char]) ->   return (M_bool, (I_LE_C, iExprs))
    (M_gt, [M_int, M_int]) ->     return (M_bool, (I_GT_I, iExprs))
    (M_gt, [M_real, M_real]) ->   return (M_bool, (I_GT_F, iExprs))
    (M_gt, [M_char, M_char]) ->   return (M_bool, (I_GT_C, iExprs))
    (M_ge, [M_int, M_int]) ->     return (M_bool, (I_GE_I, iExprs))
    (M_ge, [M_real, M_real]) ->   return (M_bool, (I_GE_F, iExprs))
    (M_ge, [M_char, M_char]) ->   return (M_bool, (I_GE_C, iExprs))
    (M_eq, [M_int, M_int]) ->     return (M_bool, (I_EQ_I, iExprs))
    (M_eq, [M_real, M_real]) ->   return (M_bool, (I_EQ_F, iExprs))
    (M_eq, [M_char, M_char]) ->   return (M_bool, (I_EQ_C, iExprs))
    (M_not, [M_bool]) ->          return (M_bool, (I_NOT, iExprs))
    (M_and, [M_bool, M_bool]) ->  return (M_bool, (I_AND, iExprs))
    (M_or, [M_bool, M_bool]) ->   return (M_bool, (I_OR, iExprs))
    (M_float, [M_int]) ->         return (M_real, (I_FLOAT, iExprs))
    (M_floor, [M_real]) ->        return (M_int, (I_FLOOR, iExprs))
    (M_ceil, [M_real]) ->         return (M_int, (I_CEIL, iExprs))
    _ -> throwError $ error_ (OpErr op mTypes)

insertElem::ST -> M_decl -> StateErr ST
insertElem st decl =
  -- no type checking yet, just add it.
  case decl of
    M_var   (pident, arrExpr, vType) ->
      insert st (VARIABLE (pident, vType, length arrExpr))
    M_fun   (pident, args, fType, _, _) -> do
      let args' = map (\(_, dims, aType) -> (aType, dims)) args
      insert st (FUNCTION (pident, args', fType))
    M_data  (pid@((l,c), name), constrs) -> do
      st' <- insert st (DATATYPE pid)   --insert the datatype first
      let cons' = map (\(c, ts) -> (c, ts, name)) constrs --then insert each constructor
          fCon st (pid, types, parent) = insert st (CONSTRUCTOR (pid, types, parent))
          in foldM fCon st' cons'

insertData::ST -> [M_decl] -> StateErr ST
insertData st [] = return st
insertData st (M_data (pid@((l,c), name), constrs):ds) = do
  st' <- insert st (DATATYPE pid)
  st'' <- insertData st' ds
  let cons = map (\(c, ts) -> (c, ts, name)) constrs
      fCon st (pid, types, parent) = insert st (CONSTRUCTOR (pid, types, parent))
      in foldM fCon st' cons

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
