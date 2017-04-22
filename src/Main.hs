module Main where

import LexM
import ParM
import AbsM
import AST
import ASTConv
import ErrM
import SemCheck
import CodeGeneration

import Text.PrettyPrint.GenericPretty

import System.Environment
import Data.List

showAst::String -> IO ()
showAst s = do
  fConts <- readFile s
  let tokens = myLexer fConts
      pTree = pProg tokens
      in case pTree of
        Ok prog -> pp $ ASTConv.transProg prog
        Bad err -> putStrLn err

showIR::String -> IO ()
showIR s = do
  fConts <- readFile s
  let tokens = myLexer fConts
      pTree = pProg tokens
      in case pTree of
        Ok prog -> let
          ast = ASTConv.transProg prog
          ir = generateIR ast
          in case ir of
              Left err -> putStrLn err
              Right iprog -> pp iprog
        Bad err -> putStrLn err

test:: String -> IO ()
test s = do
  fConts <- readFile s
  let tokens = myLexer fConts
      pTree = pProg tokens
      in case pTree of
        Ok prog -> let
          ast = ASTConv.transProg prog
          ir = generateIR ast
          in case ir of
              Left err -> putStrLn err
              Right iprog -> do
                let asm = codeGen iprog
                writeFile ((dropExtension s) ++ ".AM") asm
                putStrLn ("Output: " ++ (dropExtension s) ++ ".AM")
                putStrLn asm
        Bad err -> putStrLn err

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
              ast = ASTConv.transProg prog
              st = generateIR ast
              in case st of
                  Left err -> putStrLn err
                  Right iprog -> do
                    let asm = codeGen iprog
                    writeFile ((dropExtension fname) ++ ".AM") asm
                    putStrLn ("Output: " ++ (dropExtension fname) ++ ".AM")
                    putStrLn asm
            Bad err -> putStrLn err

dropExtension::String -> String
dropExtension str = let
  str' = dropWhileEnd (/='.') str
  (a:as) = reverse str'
  in reverse as
