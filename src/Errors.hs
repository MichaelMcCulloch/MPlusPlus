module Errors where

import AST
import SymbolTable

data IDs = Var | Fun | Data | Constr | Array
data ErrorType = IndexErr
               | IdentErr IDs
               | ArgNum Int Int
               | DimNum Int Int
               | BadArgument [M_type] [M_type]
               | Type M_type M_type
               | ReadData M_type
               | CaseErr M_type
               | OpErr M_operation [M_type]

errorST ::ST -> PIdent -> ErrorType -> String
errorST st pid type_ = errorPid pid type_ ++ show st

error_:: ErrorType -> String
error_ eType =
  case eType of
    IndexErr ->"Not a valid array index."
    IdentErr t ->
      "Expecting a" ++
      case t of
        Var -> " variable."
        Fun -> " function."
        Data -> " datatype."
        Constr -> " constructor."
        Array -> "n array."
    ArgNum expected found -> "Incorrect number of arguments, found " ++ show found ++ " but was expecting " ++ show expected
    DimNum expected found -> "Incorrect number of dimensions, found " ++ show found ++ " but was expecting " ++ show expected
    Type expected found -> "Incorrect type, found " ++ show found ++ " but was expecting " ++ show expected
    BadArgument expected found-> "Incorrect argument types, found " ++ show found ++ " but was expecting " ++ show expected
    ReadData found -> "Can't use " ++ show found ++ " here."
    CaseErr found -> "Can't case on a " ++ show found
    OpErr op types -> "Can't perform " ++ show op ++ " on " ++ show types

errorPid::PIdent -> ErrorType -> String
errorPid ((l,c), name) eType =
  let prefix = "ERROR:" ++ show l ++ ":" ++ show c ++ ": <" ++ name ++ ">: " in
  case eType of
    IndexErr -> prefix ++ "not a valid array index."
    IdentErr t ->
      prefix ++ "expecting a" ++
      case t of
        Var -> " variable."
        Fun -> " function."
        Data -> " datatype."
        Constr -> " constructor."
        Array -> "n array."
    ArgNum expected found-> prefix ++ "incorrect number of arguments, found " ++ show found ++ " but was expecting " ++ show expected
    DimNum expected found -> prefix ++ "incorrect number of dimensions, found " ++ show found ++ " but was expecting " ++ show expected
    Type expected found -> prefix ++ "incorrect type, found " ++ show found ++ " but was expecting " ++ show expected
    BadArgument expected found -> prefix ++ "incorrect argument types, found " ++ show found ++ " but was expecting " ++ show expected
    ReadData found -> prefix ++ "can't use " ++ show found ++ " here."
    CaseErr found -> prefix ++ "can't case on a " ++ show found
    OpErr op types-> prefix ++ "can't perform " ++ show op ++ " on " ++ show types
