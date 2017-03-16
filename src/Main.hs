module Main where

import LexM
import ParM
import AbsM
import ASTConv --from skel file
import ErrM

import System.Environment

main :: IO ()
main = do
  args <- getArgs
  let fname = args !! 0
  fConts <- readFile fname
  let tokens = myLexer fConts
      pTree = pProg tokens
      in case pTree of
        Ok prog -> print $ transProg prog
        Bad err -> print err
