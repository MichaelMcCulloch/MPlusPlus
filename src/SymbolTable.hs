module SymbolTable (ST,empty,newScope,insert,lookup,return) where

import AST
import Data.Char
import Control.Monad.State.Lazy

data ScopeType = L_Prog | L_Fun M_type | L_Blk | L_Cases
                deriving (Eq, Show)
data SYM_DESC = ARGUMENT (String,M_type,Int)
              | VARIABLE (String,M_type,Int)
              | FUNCTION (String,[(M_type,Int)],M_type)
              | DATATYPE String
              | CONSTRUCTOR (String, [M_type], String)
              deriving (Eq, Show)
data SYM_I_DESC = I_VARIABLE (Int,Int,M_type,Int)
                | I_FUNCTION (Int,String,[(M_type,Int)],M_type)
                | I_CONSTRUCTOR (Int,[M_type],String)
                | I_TYPE [String]
                deriving (Eq, Show)
data SYM_VALUE = Var_attr (Int,M_type,Int)
               | Fun_attr (String,[(M_type,Int)],M_type)
               | Con_attr (Int,[M_type],String)
               | Type_attr [String]
               deriving (Eq, Show)
data SymbolTable = SymbolTable (ScopeType,Int,Int,[(String,SYM_VALUE)])
                deriving (Eq, Show)

type ST = [SymbolTable]

empty:: ST
empty = []

newScope:: ScopeType -> ST -> ST
newScope t s = SymbolTable (t,0,0,[]) : s

insert:: ST -> SYM_DESC -> State Int (Either String ST) -- The int in State is the current code label.
insert [] _ = return $ Left "Insertion before defining scope."
insert symTab@(SymbolTable (sT, nLocal, nArgs, sL) : rest) desc =
  case desc of
    ARGUMENT (name, type_, dims)
      | (in_index_list name sL) -> err_defined name
      | otherwise ->
        return $ Right (SymbolTable (sT, nLocal, nArgs+1,
          (name, Var_attr (-(nArgs+4),type_, dims)) : sL):rest) --why plus 4?
    VARIABLE (name, type_, dims)
      | (in_index_list name sL) -> err_defined name
      | otherwise ->
        return $ Right (SymbolTable (sT, nLocal+1, nArgs,
          (name, Var_attr (nLocal + 1,type_, dims)) : sL):rest)
    FUNCTION (name, argTypes, f_type)
      | (in_index_list name sL) -> err_defined name
      | otherwise -> do
          i <- get
          modify (+1)
          return $ Right (SymbolTable (sT, nLocal, nArgs,
            (name, Fun_attr ("fn_"++ [chr i], argTypes, f_type)):sL):rest)
    DATATYPE name
      | (in_index_list name sL) -> err_defined name
      | otherwise -> do
          i <- get
          modify (+1)
          return $ Right (SymbolTable (sT, nLocal, nArgs,
            (name, Type_attr ["List of associated constructor"]):sL):rest)
    CONSTRUCTOR (name, types, dataType)
      | (in_index_list name sL) -> err_defined name
      | otherwise ->
        return $ Right (SymbolTable (sT, nLocal, nArgs,
          (name, Con_attr (1, types, "parent")):sL):rest) -- '1' should be index of constructor in associated dataType
  where
    err_defined sym = return $ Left ("Symbol table error: " ++ sym ++"is already defined.")
    in_index_list str [] = False
    in_index_list str ((x,_):xs)
      | str == x = True
      | otherwise = in_index_list str xs

lookup_:: ST -> String -> Either String SYM_I_DESC
lookup_ st s = Left s

return_:: ST -> Either String M_type --Must be L_Fun type
return_ s = Left ""
