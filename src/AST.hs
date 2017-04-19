{-# LANGUAGE DeriveGeneric #-}
module AST where

import Text.PrettyPrint.GenericPretty

type PIdent = ((Int, Int), String) --Line, Column
type PCID = ((Int, Int), String)

data M_prog = M_prog ([M_decl],[M_stmt])
            deriving (Eq, Generic, Show)
data M_decl = M_var (PIdent,[M_expr],M_type)  --identifier, array descriptions, type
            | M_fun (PIdent,[(PIdent,Int,M_type)],M_type,[M_decl],[M_stmt]) --identifier, arguments, type, local declarations, body
            | M_data (PIdent,[(PCID,[M_type])]) --identifier, constructor descriptions of form (conId,composite types)
            deriving (Eq, Generic, Show)
data M_stmt = M_ass (PIdent,[M_expr],M_expr) --identifier, at location := expr
            | M_while (M_expr,M_stmt) --loop test, body
            | M_cond (M_expr,M_stmt,M_stmt) --condition, then part, else part
            | M_read (PIdent,[M_expr]) -- id, array description
            | M_print M_expr
            | M_return M_expr
            | M_block ([M_decl],[M_stmt])
            | M_case (M_expr,[(PCID,[PIdent],M_stmt)]) --case on an expression, which evaluates to a constructor, list of arguments must match constructor composite types
            deriving (Eq, Generic, Show)
data M_type = M_int | M_bool | M_real | M_char | M_type PIdent deriving (Generic)
data M_expr = M_ival Integer
            | M_rval Double
            | M_bval Bool
            | M_cval Char
            | M_size (PIdent,Int)
            | M_id (PIdent,[M_expr])
            | M_app (M_operation,[M_expr])
            deriving (Eq, Generic, Show)
data M_operation
            = M_fn PIdent --
            | M_cid PCID
            | M_add | M_mul | M_sub | M_div
            | M_neg
            | M_lt | M_le | M_gt | M_ge | M_eq
            | M_not | M_and | M_or
            | M_float | M_floor | M_ceil
            deriving (Eq, Generic, Show)

instance Out M_prog
instance Out M_decl
instance Out M_stmt
instance Out M_type
instance Out M_expr
instance Out M_operation

instance Eq M_type where
  (==) M_int M_int = True
  (==) M_bool M_bool = True
  (==) M_real M_real = True
  (==) M_char M_char = True
  (==) (M_type ((_,_), t1)) (M_type ((_,_), t2)) = t1 == t2
  (==) _ _ = False

instance Show M_type where
  show M_int = "M_int"
  show M_bool = "M_bool"
  show M_real = "M_real"
  show M_char = "M_char"
  show (M_type ((_,_),t)) = "M_type '" ++ t ++ "'"
