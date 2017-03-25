module SymbolTable where

import AST
import Data.Char
import Control.Monad.State.Lazy
import Control.Monad.Error

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

type StateErr a = StateT Int (Either String) a



empty:: ST
empty = []

newScope:: ScopeType -> ST -> ST
newScope t s = SymbolTable (t,0,0,[]) : s

insert:: ST -> SYM_DESC -> StateErr ST -- The int in State is the current code label.
insert [] _ = throwError "Insertion before defining scope."
insert symtab@(SymbolTable (sT, nLocal, nArgs, sL) : rest) desc =
  case desc of
    ARGUMENT (name, type_, dims)
      | (in_index_list name sL) -> err_defined name
      | otherwise ->
        return (SymbolTable (sT, nLocal, nArgs+1,
          (name, Var_attr (-(nArgs+4),type_, dims)) : sL):rest) --why plus 4?
    VARIABLE (name, type_, dims)
      | (in_index_list name sL) -> err_defined name
      | otherwise ->
        return (SymbolTable (sT, nLocal+1, nArgs,
          (name, Var_attr (nLocal + 1,type_, dims)) : sL):rest)
    FUNCTION (name, argTypes, f_type)
      | (in_index_list name sL) -> err_defined name
      | otherwise -> do
          i <- get
          modify (+1)
          return (SymbolTable (sT, nLocal, nArgs,
            (name, Fun_attr ("fn_"++ name, argTypes, f_type)):sL):rest)
    DATATYPE name
      | (in_index_list name sL) -> err_defined name
      | otherwise -> do
          i <- get
          modify (+1)
          return (SymbolTable (sT, nLocal, nArgs,
            (name, Type_attr []):sL):rest)
    CONSTRUCTOR (name, types, dataType) --this may work
      | (in_index_list name sL) -> err_defined name
      | otherwise ->
        case lookup_ symtab dataType of
          Left err -> throwError err
          Right (I_TYPE constr) ->
            let ind = (length constr) - 1
                conAttr = (name, Con_attr (ind + 1, types, dataType))
                datAttr = (dataType, Type_attr (constr ++ [name]))
                in return (SymbolTable (sT, nLocal, nArgs, (datAttr:conAttr:sL)):rest )
  where
    err_defined str = throwError ("Symbol table error: <" ++ str ++"> is already defined.") :: StateErr ST
    in_index_list str [] = False
    in_index_list str ((x,_):xs)
      | str == x = True
      | otherwise = in_index_list str xs

lookup_:: ST -> String -> Either String SYM_I_DESC
lookup_ st key = find 0 st key where
  find n [] str = Left ("Error \""++ str ++ "\" not found")
  find n (SymbolTable (_,_,_,attrs):rest) str =
    case lookup str attrs of --not a typo
      Just attr -> Right (found n attr)
      Nothing -> find (n+1) rest str
  found level attr =
    case attr of
      Var_attr (offset, mT, dim) -> I_VARIABLE (level, offset, mT, dim)
      Fun_attr (label,args,mT) -> I_FUNCTION (level,label,args,mT)
      Con_attr (constructorNumber,cTypes,dataName) -> I_CONSTRUCTOR (constructorNumber, cTypes, dataName)
      Type_attr constructors -> I_TYPE constructors


return_:: ST -> Either String M_type --Must be L_Fun type
return_ (SymbolTable (L_Fun m_t, _, _, _) : rest) = Right m_t
return_ _ = Left "Not in function scope."
