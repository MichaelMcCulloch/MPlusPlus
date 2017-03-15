-- This Happy file was machine-generated by the BNF converter
{
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParExpr where
import AbsExpr
import LexExpr
import ErrM

}

%name pExpr Expr
%name pTerm Term
%name pFactor Factor
-- no lexer declaration
%monad { Err } { thenM } { returnM }
%tokentype {Token}
%token
  '*' { PT _ (TS _ 1) }
  '+' { PT _ (TS _ 2) }

L_integ  { PT _ (TI $$) }


%%

Integer :: { Integer } : L_integ  { (read ( $1)) :: Integer }

Expr :: { Expr }
Expr : Expr '+' Term { AbsExpr.EAdd $1 $3 }
     | Term { AbsExpr.ETerm $1 }
Term :: { Term }
Term : Term '*' Factor { AbsExpr.TMul $1 $3 }
     | Factor { AbsExpr.TFact $1 }
Factor :: { Factor }
Factor : Integer { AbsExpr.Num $1 }
{

returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    _ -> " before " ++ unwords (map (id . prToken) (take 4 ts))

myLexer = tokens
}
