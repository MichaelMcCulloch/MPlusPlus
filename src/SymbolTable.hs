module SymbolTable where

import AST
import Data.Char
import Control.Monad.State.Lazy
import Control.Monad.Except

data ScopeType = L_Prog | L_Fun M_type | L_Blk | L_Cases
                deriving (Eq, Show)
data SYM_DESC = ARGUMENT (PIdent,M_type,Int)
              | VARIABLE (PIdent,M_type,Int)
              | FUNCTION (PIdent,[(M_type,Int)],M_type)
              | DATATYPE PIdent
              | CONSTRUCTOR (PCID, [M_type], String)
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
    ARGUMENT (pident@((line,column), name), type_, dims)
      | (in_index_list name sL) -> err_defined ((line,column), name)
      | otherwise ->
        return (SymbolTable (sT, nLocal, nArgs+1,
          (name, Var_attr (-(nArgs+4),type_, dims)) : sL):rest) --why plus 4?
    VARIABLE (pident@((line,column), name), type_, dims)
      | (in_index_list name sL) -> err_defined pident
      | otherwise ->
        return (SymbolTable (sT, nLocal+1, nArgs,
          (name, Var_attr (nLocal + 1,type_, dims)) : sL):rest)
    FUNCTION (pident@((line,column), name), argTypes, f_type)
      | (in_index_list name sL) -> err_defined pident
      | otherwise -> do
          i <- get
          modify (+1)
          return (SymbolTable (sT, nLocal, nArgs,
            (name, Fun_attr ("fn_"++ show i, argTypes, f_type)):sL):rest)
    DATATYPE pident@((line,column), name)
      | (in_index_list name sL) -> err_defined pident
      | otherwise -> do
          i <- get
          modify (+1)
          return (SymbolTable (sT, nLocal, nArgs,
            (name, Type_attr []):sL):rest)
    CONSTRUCTOR (pident@((line,column), name), types, dataType)
    {-get description for parent, then create a new symbol for parent dataype which includes this constructor-}
      | (in_index_list name sL) -> err_defined pident
      | otherwise -> do
        desc <- lookup_ ((line,column),dataType) symtab
        case desc of
          I_TYPE constr -> let
            ind = length constr
            conAttr = (name, Con_attr (ind, types, dataType)):sL
            datAttr = (dataType, Type_attr (constr ++ [name])):conAttr
            in return (SymbolTable (sT, nLocal, nArgs, datAttr):rest)
          I_VARIABLE _ -> err_notAConstructor pident
          I_FUNCTION _ -> err_notAConstructor pident
          I_CONSTRUCTOR _ -> err_notAConstructor pident
  where
    err_defined ((line,column), str) = throwError ("Error:" ++ show line ++ ":" ++ show column ++ ": <" ++ str ++ "> is already defined.") :: StateErr ST
    err_notAConstructor ((line,column), str) = throwError ("Error:" ++ show line ++ ":" ++ show column ++ ": <" ++ str ++ "> is not a constructor of any type") :: StateErr ST
    {-in_index_list will incorrectly fail if a local VARIABLE and a FUNCTION are declared with same name in scope. 
      Intended is that only duplicate FUNCTION names are forbidden-}
    in_index_list _ [] = False
    in_index_list str ((x,_):xs)
      | str == x = True
      | otherwise = in_index_list str xs

lookup_::PIdent -> ST -> StateErr SYM_I_DESC
lookup_ ((l,c),key) st = find 0 st key where
  find n [] str = throwError ("Error:" ++ show l ++ ":" ++ show c ++ ": <" ++ str ++ "> not defined") :: StateErr SYM_I_DESC
  find n (SymbolTable (_,_,_,attrs):rest) str =
    case lookup str attrs of
      Just attr -> return $ found n attr
      Nothing -> find (n+1) rest str
  found level attr =
    case attr of
      Var_attr (offset, mT, dim) -> I_VARIABLE (level, offset, mT, dim)
      Fun_attr (label,args,mT) -> I_FUNCTION (level,label,args,mT)
      Con_attr (constructorNumber,cTypes,dataName) -> I_CONSTRUCTOR (constructorNumber, cTypes, dataName)
      Type_attr constructors -> I_TYPE constructors


return_:: ST -> StateErr M_type --Must be L_Fun type
return_ (SymbolTable (L_Fun m_t, _, _, _) : rest) = return m_t
return_ _ = throwError "Not in function scope."
