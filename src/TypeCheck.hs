module SemCheck where


import SymbolTable
import AST
import Errors
import IntermediateRepresentation
import Control.Monad.State.Lazy
import Control.Monad.Except

wfExpr::ST -> M_expr -> StateErr ((M_type,Int), I_expr)
wfExpr st e = case e of
  M_ival i -> return ((M_int,0), I_IVAL i)
  M_rval r -> return ((M_real,0), I_RVAL r)
  M_bval b -> return ((M_bool,0), I_BVAL b)
  M_cval c -> return ((M_char,0), I_CVAL c)
  M_size (pid, dim) -> do
    varDesc <- lookup_ pid st
    case varDesc of
      I_VARIABLE (lvl, off, _, maxDims) ->
        if dim < maxDims
          then return ((M_int,0), I_SIZE (lvl, off, dim))
          else throwError $ errorPid pid (DimNum maxDims dim)
      _ -> throwError $ errorPid pid (IdentErr Var)
  M_id (pid, arrDesc) -> do
    (I_VARIABLE (lvl, off, vType, dims)) <- lookup_ pid st
    (spec, iArrDesc) <- mapAndUnzipM (wfExpr st) arrDesc
    if null arrDesc --if there is no arrayDescription, then whether or not pid is an array, return its number of dimensions
      then return ((vType, dims), I_ID (lvl, off, []))
      else if dims == length arrDesc  --if there are array descriptions, pid had better be an array of the same number of dimensions, and all arraySpecs must be integers
            then if all (== (M_int, 0)) spec
              then return ((vType,0), I_ID (lvl, off, iArrDesc))
              else throwError $ errorPid pid IndexErr
            else throwError $ errorPid pid (DimNum dims (length arrDesc))
  M_app (op, arguments) -> do
    (spec, iArgs) <- mapAndUnzipM (wfExpr st) arguments
    (appType, iop) <- wfOperation st op spec
    return ((appType,0), I_APP (iop, iArgs))


wfOperation::ST -> M_operation -> [(M_type, Int)] -> StateErr (M_type, I_opn)
wfOperation st M_add [(M_int, 0), (M_int, 0)] = return (M_int, I_ADD_I)
wfOperation st (M_fn fid) argSpec = do
  fDesc <- lookup_ fid st
  case fDesc of
    I_FUNCTION (lvl, lbl, expArgs, fType) ->
      if argSpec == expArgs
        then return (fType, I_CALL (lbl, lvl))
        else throwError $ errorPid fid (BadArgument expArgs argSpec)
    _ -> throwError $ errorPid fid (IdentErr Fun)
wfOperation st (M_cid cid) argSpec = do
  cDesc <- lookup_ cid st
  case cDesc of
    I_CONSTRUCTOR (num, typeComposition, parent) -> let
      (types, dims) = unzip argSpec
      in if all (== 0) dims && types == typeComposition
        then return
        else throwError $ errorPid cid (BadArgument typeComposition argSpec)
    _ -> throwError $ errorPid cid (IdentErr Constr)
