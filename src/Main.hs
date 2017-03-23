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
  if null args then putStrLn "Usage: MCompiler.exe .\\path\\to\\file.m"
    else do
      let fname = head args
      fConts <- readFile fname
      let tokens = myLexer fConts
          pTree = pProg tokens
          in case pTree of
            Ok prog -> putStrLn $ showProg $ transProg prog
            Bad err -> print err
