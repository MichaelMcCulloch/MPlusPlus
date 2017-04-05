module Main where

import LexM
import ParM
import AbsM
import AST
import ASTConv
import ErrM
import SemCheck

import Text.PrettyPrint.GenericPretty

import System.Environment


showAst::String -> IO ()
showAst s = do
  fConts <- readFile s
  let tokens = myLexer fConts
      pTree = pProg tokens
      in case pTree of
        Ok prog -> pp $ transProg prog
        Bad err -> print err

test:: String -> IO ()
test s = do
  fConts <- readFile s
  let tokens = myLexer fConts
      pTree = pProg tokens
      in case pTree of
        Ok prog -> let
          ast = transProg prog
          ir = generateIR ast
          in case ir of
              Left err -> print err
              Right iprog -> pp iprog
        Bad err -> print err

main :: IO ()
main = do
  args <- getArgs
  if null args then putStrLn "Usage: MCompiler.exe .\\path\\to\\file.m"
    else do
      let fname = head args
      fConts <- readFile fname
      let tokens = myLexer fConts
          pTree = pProg tokens
          in case pTree of
            Ok prog -> let
              ast = transProg prog
              st = generateIR ast
              in case st of
                  Left err -> print err
                  Right iprog -> pp iprog
            Bad err -> print err
