module Main where

import LexM
import ParM
import AbsM
import AST
import ASTConv
import ErrM

import System.Environment

test:: String -> IO ()
test s = do
  fConts <- readFile s
  let tokens = myLexer fConts
      pTree = pProg tokens
      in case pTree of
        Ok prog -> putStrLn $ showProg $ transProg prog
        Bad err -> print err

main :: IO ()
main = do
  args <- getArgs
  let fname = head args
  fConts <- readFile fname
  let tokens = myLexer fConts
      pTree = pProg tokens
      in case pTree of
        Ok prog -> putStrLn $ showProg $ transProg prog
        Bad err -> print err

showProg::M_prog-> String
showProg (M_prog (ds, ss)) = concatMap (`showDecl` 0) ds ++ "\n" ++ concatMap (`showStmt` 0) ss ++ "\n"

showDecl::M_decl -> Int -> String
showDecl d i =
  let r j = (concat $ replicate (j-1) "  ")
      in case d of
        M_var (name, array, type_) -> r i++ show d ++ ";\n"
        M_fun (name, arguments, type_, ds, ss) -> r i ++ "M_fun (" ++ name ++ concatMap show arguments ++ show type_ ++ ")" ++ "{\n" ++
                                                  concatMap (`showDecl` (i+1)) ds ++ concatMap (`showStmt` (i+1)) ss ++ r (i+1)++ "};\n"
        M_data (name, constructors) -> r i ++ "M_data (" ++ name ++ "[\n"++ concatMap (`showConstructors` (i+1)) constructors ++ r (i+1) ++"])\n"

showConstructors::(String,[M_type]) -> Int -> String
showConstructors (s, ts) i =
  let r = (concat $ replicate (i-1) "  ") in
      r ++ show s ++ concatMap show ts ++ ",\n"

showStmt::M_stmt -> Int -> String
showStmt s i =
  let r j = (concat $ replicate (j-1) "  ")
      in case s of
        M_ass (name, address, expr) -> r i ++ show s ++ "\n"
        M_while (cond, stmt) -> r i ++ "M_while (" ++ show cond ++ ")" ++ "{\n" ++ showStmt s (i+1) ++ r (i+1) ++ "};\n"
        M_cond (cond, then_, else_) -> r i ++ "M_Cond (" ++ show cond ++ "\n" ++ r (i+1) ++ show then_ ++ "\n" ++ r (i+1) ++ show else_ ++ ")" ++ "\n"
        M_print e -> r i ++ show s ++ "\n"
        M_read (name, address) -> r i ++ show s ++ "\n"
        M_return e -> r i ++ show s ++ "\n"
        M_block (ds,ss) -> r i ++ "M_block (" ++ concatMap (`showDecl` (i+1)) ds ++ "\n" ++ concatMap (`showStmt` (i+1)) ss ++ r (i+1) ++ ");\n"
        M_case (e, cases) -> r i ++ "M_case (" ++ show e ++ "[\n" ++ concatMap (`showCases` (i+1)) cases ++ r (i+1) ++ "])\n"

showCases::(String,[String],M_stmt) -> Int -> String
showCases c@(case_, args, stmt) i =
  let r =  (concat $ replicate (i-1) "  ") in
      case stmt of
        M_block _ -> r ++ show case_ ++ show args ++ "\n" ++ showStmt stmt (i+1)
        M_ass _ -> r ++ show c  ++ "\n"
        M_while _ -> r ++ show case_ ++ show args ++ "\n" ++ showStmt stmt (i+1)
        M_cond _ -> r ++ show case_ ++ show args ++ "\n" ++ showStmt stmt (i+1)
        M_print _ -> r ++ show c ++ "\n"
        M_read _ -> r ++ show c ++ "\n"
        M_return _ ->r ++ show c ++ "\n"
        M_case _ -> r ++ show case_ ++ show args ++ "\n" ++ showStmt stmt (i+1)
