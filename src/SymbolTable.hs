module SymbolTable where

import AST
import Data.Char
import Control.Monad.State.Lazy
import Control.Monad.Except

data ScopeType = L_Prog | L_Fun M_type | L_Blk | L_Cases
                deriving (Eq, Show)
data SYM_DESC = ARGUMENT (PIdent,M_type,Int)
              --Identifier, type, dimensions
              | VARIABLE (PIdent,M_type,Int)
              --Identifier, type, dimensions
              | FUNCTION (PIdent,[(M_type,Int)],M_type)
              --Identifier, arguments, type
              | DATATYPE PIdent
              --Identifier
              | CONSTRUCTOR (PCID, [M_type], String)
              --Identifier, type composition, parent datatype
              deriving (Eq, Show)
data SYM_I_DESC = I_VARIABLE (Int,Int,M_type,Int)
                -- level, offset, type, dimensions
                | I_FUNCTION (Int,String,[(M_type,Int)],M_type)
                -- level, code label, argument types and dimensions, type
                | I_CONSTRUCTOR (Int,[M_type],String)
                -- constructor number, type composition, parent
                | I_TYPE [String]
                --list of constructor names
                deriving (Eq, Show)
data SYM_VALUE = Var_attr (Int,M_type,Int)
               --offset, type, dimensions
               | Fun_attr (String,[(M_type,Int)],M_type)
               --code label, arg types and dimensions, type
               | Con_attr (Int,[M_type],String)
               --constructor number
               | Type_attr [String]
               -- list of constructor names
               deriving (Eq, Show)
data SymbolTable = SymbolTable (ScopeType,Int,Int,[(String,SYM_VALUE)])
                deriving (Eq, Show)

type ST = [SymbolTable]

type StateErr a = StateT (Int, Int) (Either String) a

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
          (f,c) <- get    --each function gets a unique number
          modify (\(f,c) -> (f+1,c))
          return (SymbolTable (sT, nLocal, nArgs,
            (name, Fun_attr ("fn_"++ show f, argTypes, f_type)):sL):rest)
    DATATYPE pident@((line,column), name)
      | (in_index_list name sL) -> err_defined pident
      | otherwise ->
          return (SymbolTable (sT, nLocal, nArgs,
            (name, Type_attr []):sL):rest)
    CONSTRUCTOR (pident@((line,column), name), types, dataType)
    {-get description for parent, then create a new symbol for parent dataype which includes this constructor-}
      | (in_index_list name sL) -> err_defined pident
      | otherwise -> do
        desc <- lookup_ ((line,column), dataType) symtab
        case desc of
          I_TYPE constr -> do
            (f,c) <- get    --each constructor gets a unique number
            modify (\(f,c) -> (f,c+1))
            let
              conAttr = (name, Con_attr (c, types, dataType)):sL
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
