module AST where

data Expr = Add (Expr, Expr)
          | Mul (Expr, Expr)
          | Num Integer
          deriving (Show)
