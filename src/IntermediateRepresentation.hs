{-# LANGUAGE DeriveGeneric #-}
module IntermediateRepresentation where

import Text.PrettyPrint.GenericPretty


data I_prog = I_PROG ([I_fbody],Int,[(Int,[I_expr])],[I_stmt])
            deriving (Eq, Generic, Show)
-- functions, number of local variables, array descriptions, body.

data I_fbody = I_FUN (String,[I_fbody],Int,Int,[(Int,[I_expr])],[I_stmt])
            deriving (Eq, Generic, Show)
-- code label, functions, number of local variables, number of arguments
-- array descriptions, body
data I_stmt = I_ASS (Int,Int,[I_expr],I_expr)
            -- level, offset, array indexes, expressions
            | I_WHILE (I_expr,I_stmt)
            | I_COND (I_expr,I_stmt,I_stmt)
            | I_CASE (I_expr,[(Int,Int,I_stmt)])
            -- each case branch has a constructor number, a number of arguments,
            -- and the code statements
            | I_READ_B (Int,Int,[I_expr])
            -- level, offset, array indexes
            | I_PRINT_B I_expr
            | I_READ_I (Int,Int,[I_expr])
            | I_PRINT_I I_expr
            | I_READ_F (Int,Int,[I_expr])
            | I_PRINT_F I_expr
            | I_READ_C (Int,Int,[I_expr])
            | I_PRINT_C I_expr
            | I_RETURN I_expr
            | I_BLOCK ([I_fbody],Int,[(Int,[I_expr])],[I_stmt])
            deriving (Eq, Generic, Show)
            -- functions, number of local variables, array descriptions, body.
data I_expr = I_IVAL Integer
            | I_RVAL Double
            | I_BVAL Bool
            | I_CVAL Char
            | I_ID (Int,Int,[I_expr])
            -- level, offset, array indices
            | I_APP (I_opn,[I_expr])
            | I_REF (Int,Int)
            -- for passing an array reference as an argument
            -- of a function: level, offset
            | I_SIZE (Int,Int,Int)
            -- for retrieving the dimension of an array: level,offset,dimension
            deriving (Eq, Generic, Show)
data I_opn = I_CALL (String,Int)
            -- label and level
            | I_CONS (Int,Int)
            -- constructor number and number of arguments
            | I_ADD_I | I_MUL_I | I_SUB_I | I_DIV_I | I_NEG_I
            | I_ADD_F | I_MUL_F | I_SUB_F | I_DIV_F | I_NEG_F
            | I_LT_I | I_LE_I | I_GT_I | I_GE_I | I_EQ_I
            | I_LT_F | I_LE_F | I_GT_F | I_GE_F | I_EQ_F
            | I_LT_C | I_LE_C | I_GT_C | I_GE_C | I_EQ_C
            | I_NOT | I_AND | I_OR | I_FLOAT | I_FLOOR | I_CEIL
            deriving (Eq, Generic, Show)

instance Out I_prog
instance Out I_fbody
instance Out I_expr
instance Out I_stmt
instance Out I_opn
