bnfc .\M.bnfc
alex .\LexM.x
happy .\ParM.y -o ParM.hs
ghc --make .\TestM.hs -o Test.exe
