module CodeGeneration where

import Data.List
import IntermediateRepresentation
import Control.Monad.State.Lazy

type Offset = Int
data Register = FP | SP | CP | HP
data Operation = ADD_F | SUB_F | DIV_F | MUL_F | NEG_F | FLOOR | CEIL
               | ADD | SUB | DIV | MUL | NEG | FLOAT
               | LT_F | LE_F | EQ_F | GE_F | GT_F
               | LT_C | LE_C | EQ_C | GE_C | GT_C
               | LT | LE | EQ | GE | GT
               | AND | OR | NOT
               deriving (Show)

data BOOLEAN = TRUE | FALSE

instance Show BOOLEAN where
  show TRUE = "true"
  show FALSE = "false"

data Instruction  = LOAD_R Register --load places something ontop of the stack
                  | LOAD_F Double | LOAD_I Integer | LOAD_B BOOLEAN | LOAD_C Char     -- litterals
                  | LOAD_O Offset   -- offset from pointer (on stack)
                  | LOAD_OS         -- offset (on stack) from pointer (on stack)
                  | LOAD_H          -- %hp (on stack) replaced by heap record
                  | LOAD_HO Offset  -- %hp (on stack) replaced by offset (from hp)
                  | STORE_R Register --storing uses stack to place things elsewhere
                  | STORE_O Offset  -- offset from pointer (on stack)
                  | STORE_OS        -- offset (on stack) from pointer (on stack)
                  | STORE_H Int     -- top 'n' elements removed from stack and replaced with a heap pointer to these elements in the stack
                  | STORE_HO Offset -- %hp (on stack); cell beneath replaces value at offset from hp
                  | JUMP String     -- jump to code label
                  | JUMP_S          -- jump to %cp (on stack); for returning from functions
                  | JUMP_C String   -- jump if boolean (on stack) is false;
                  | JUMP_O          -- jump to offset (on stack)
                  | ALLOC Int
                  | ALLOC_S         -- replace integer on top of stack with as many void cells
                  | ALLOC_H Int     -- allocate n void cells on top of heap, and create a heap pointer to them on top of stack
                  | APP Operation
                  | READ_F | READ_I | READ_B | READ_C
                  | PRINT_F | PRINT_I | PRINT_B | PRINT_C
                  | HALT

instance Show Instruction where
  show (LOAD_R reg) = "LOAD_R " ++ show reg
  show (LOAD_F double) = "LOAD_F "  ++ show double
  show (LOAD_I integer) = "LOAD_I " ++ show integer
  show (LOAD_B boolean) = "LOAD_B " ++ show boolean
  show (LOAD_C char) = "LOAD_C " ++ show char
  show (LOAD_O offset) = "LOAD_O " ++ show offset
  show (LOAD_OS) = "LOAD_OS "
  show (LOAD_H) = "LOAD_H "
  show (LOAD_HO offset) = "LOAD_HO " ++ show offset
  show (STORE_R register) = "STORE_R " ++ show register
  show (STORE_O offset) = "STORE_O " ++ show offset
  show (STORE_OS) = "STORE_OS "
  show (STORE_H int) = "STORE_H " ++ show int
  show (STORE_HO offset) = "STORE_HO " ++ show offset
  show (JUMP string) = "JUMP " ++ string
  show (JUMP_S) = "JUMP_S "
  show (JUMP_C string) = "JUMP_C " ++ string
  show (JUMP_O) = "JUMP_O "
  show (ALLOC int) = "ALLOC " ++ show int
  show (ALLOC_S) = "ALLOC_S "
  show (ALLOC_H int) = "ALLOC_H " ++ show int
  show (APP operation) = "APP " ++ show operation
  show (READ_F) = "READ_F "
  show (READ_I) = "READ_I "
  show (READ_B) = "READ_B "
  show (READ_C) = "READ_C "
  show (PRINT_F) = "PRINT_F "
  show (PRINT_I) = "PRINT_I "
  show (PRINT_B) = "PRINT_B "
  show (PRINT_C) = "PRINT_C "
  show (HALT) = "HALT "

data Code = L String Instruction
          | I Instruction

instance Show Code where
  show (L str instr) = id str ++ ":\t" ++ show instr
  show (I instr) = "\t" ++ show instr
instance Show Register where
  show FP = "%fp"
  show SP = "%sp"
  show CP = "%cp"
  show HP = "%hp"

codeGen::I_prog -> String
codeGen prog = intercalate "\n" . map show $ evalState (transProg prog) 0

{-TODO:
  Allocate local Variable space
  Deallocate Stack-}
transProg:: I_prog -> State Int [Code]
transProg (I_PROG (funs, nVars, arrDesc, body)) = prog where
  prog = do
    b <- progBody
    f <- functions
    arrs <- mapM (transArr nVars) arrDesc
    return $ progStart ++ concat arrs ++ b ++ progEnd ++ f
  progStart = [ I (LOAD_R SP), -- put the stack pointer on the stack
                I (LOAD_R SP),
                I (STORE_R FP), -- and put it in the frame pointer
                I (ALLOC nVars), -- alocate space for local variables
                I (LOAD_I (fromIntegral (-(nVars + 1)))) -- load the deallocation counter + 1 for stack pointer
                ]++[] -- TODO allocate space for local arrays and update counter
  progBody = do
    body' <- mapM transBody body
    return $ concat body'
  progEnd = [ I (LOAD_R FP),
              I (LOAD_O (nVars +1)),
              I (ALLOC_S),
              I HALT] --TODO deallocate stack !!! Use deallocation counter
  functions = do
    funs' <- mapM transFun funs
    return $ concat funs'



--TODO allocate array sizes
transFun:: I_fbody -> State Int [Code]
transFun (I_FUN (lbl,funs,nArgs,nLoc,varDesc,stmts)) = fun where
  fun = do
    body <- mapM transBody stmts
    funs <- mapM transFun funs
    arrs <- mapM (transArr nLoc) varDesc
    return $ initFun ++ concat arrs ++ concat body ++ endFun ++ concat funs
  initFun = [ L lbl (LOAD_R SP), I (STORE_R FP), --set frame pointer to top of the stack and set label
              I (ALLOC nLoc), -- allocate local storage
              I (LOAD_I (fromIntegral (-(nLoc + 2)))) -- init deallocation counter +2 for dynamic&static link
              ] ++ [] -- TODO allocate space for local arrays and update counter
  endFun = [I (LOAD_R FP), -- write return into first arg slot
            I (STORE_O (-(nArgs+3))),
            I (LOAD_R FP), -- write return pointer into second argument slot
            I (LOAD_O 0), -- load return pointer onto stack
            I (LOAD_R FP),
            I (STORE_O (-(nArgs+2))),
            I (LOAD_R FP), -- deallocate local storage
            I (LOAD_O (nLoc+1)), --load deallocation counter
            I (ALLOC_S),
            I (STORE_R FP), -- restore old frame pointers
            I (ALLOC (-nArgs)), -- cleanup the argument storage leaving only the return value & pointer on stack
            I (JUMP_S)] -- return

-- need to store size of each dimension in array description block
transArr::Int -> (Int, [I_expr]) -> State Int [Code]
transArr nLoc (i, dimDesc) = do
  dims <- mapM transExpr dimDesc
  let dealloc = nLoc + 1
  return $  concat (reverse dims) ++ -- put all dimensions in header block
            concat dims ++ -- adjust for array start location
            replicate (length dimDesc - 1) (I (APP MUL)) ++
            [ I (LOAD_R SP), -- array starts here
              I (LOAD_R FP),
              I (STORE_O i)] ++ -- make a pointer to the array
            [ I (LOAD_R SP), -- duplicate top of stack
              I (LOAD_O 0)] ++
            [ I (LOAD_I (fromIntegral (length dimDesc))),
              I (LOAD_R FP),
              I (LOAD_O dealloc),
              I (APP NEG),
              I (APP ADD),
              I (APP ADD),
              I (APP NEG),
              I (LOAD_R FP),
              I (STORE_O dealloc),
              I (ALLOC_S)]

{-Column Major:
  Note: array sizes are store at negative offsets from array pointer. array starts at 0, first dim is -1, etc-}
accessArray::(Int, Int, [I_expr]) -> Bool -> State Int [Code]
accessArray (lvl, off, arrayLocations) loadOrStore = do
  let dims = length arrayLocations
  exprs <- mapM transExpr arrayLocations
  return undefined



{-TODO:
  arrayDescriptions
  cases-}
transBody:: I_stmt -> State Int [Code]
transBody stmt = case stmt of
  I_ASS (lvl, off, arrDesc, expr) -> do
    expr' <- transExpr expr
    ap <- calcAccessPointer lvl
    return $ expr' ++ ap ++ [I (STORE_O off)] -- TODO array shit
  I_WHILE (expr, stmt) -> do --Code evaluates expression, then tests it, then jumps after loop if false
    i <- get
    modify (+1)
    body <- transBody stmt
    test <- transExpr expr
    let I instr:as = test
        test' = L ("test" ++ show i) instr:as
        body' = body ++ [L ("end" ++ show i) (ALLOC 0)]
    return $ test' ++
           [I (JUMP_C ("end" ++ show i))] ++
           body ++ [I (JUMP ("test" ++ show i)), L ("end" ++ show i) (ALLOC 0)]
  I_COND (expr, thenStmt, elseStmt) -> do
    i <- get
    modify (+1)
    test <- transExpr expr
    thenPart <- transBody thenStmt
    elsePart <- transBody elseStmt
    let (I instr):as = elsePart
        elsePart' = (L ("else"++show i) instr):as
    return $ test ++ [I (JUMP_C ("else" ++ show i))] ++ --test and jump
             thenPart ++ [I (JUMP ("end" ++ show i))]++
             elsePart' ++ [L ("end" ++ show i) (ALLOC 0)]
  I_CASE (expr, cases) -> undefined --TODO
  I_READ_B (lvl, off, arrDesc) -> do
    ap <- calcAccessPointer lvl
    return $ [I READ_B] ++ ap ++ [I (STORE_O off)] -- array shit
  I_READ_I (lvl, off, arrDesc) -> do
    ap <- calcAccessPointer lvl
    return $ [I READ_I] ++ ap ++ [I (STORE_O off)] -- array shit
  I_READ_F (lvl, off, arrDesc) -> do
    ap <- calcAccessPointer lvl
    return $ [I READ_F] ++ ap ++ [I (STORE_O off)] -- array shit
  I_READ_C (lvl, off, arrDesc) -> do
    ap <- calcAccessPointer lvl
    return $ [I READ_C] ++ ap ++ [I (STORE_O off)] -- array shit
  I_PRINT_B expr -> do
    expr' <- transExpr expr
    return $ expr' ++ [I PRINT_B] -- evaluate expression, then print it
  I_PRINT_I expr -> do
    expr' <- transExpr expr
    return $ expr' ++ [I PRINT_I] -- evaluate expression, then print it
  I_PRINT_F expr -> do
    expr' <- transExpr expr
    return $ expr' ++ [I PRINT_F] -- evaluate expression, then print it
  I_PRINT_C expr -> do
    expr' <- transExpr expr
    return $ expr' ++ [I PRINT_C] -- evaluate expression, then print it
  I_RETURN expr -> transExpr expr
  I_BLOCK (funs, nVars, varDesc, stmts) -> block where
    dealloc = fromIntegral (-(nVars+3))
    block = do
      body <- mapM transBody stmts
      funs <- mapM transFun funs
      return $ initBlock ++ concat body ++ endBlock ++ concat funs
    initBlock = [ I (LOAD_R FP),
                  I (ALLOC 2),
                  I (LOAD_R SP),
                  I (STORE_R FP),
                  I (ALLOC nVars),
                  I (LOAD_I dealloc)] ++
                  [] --TODO allocate local arrays
    endBlock = [  I (LOAD_R FP), -- deallocate local storage
                  I (LOAD_O (nVars+1)), --load deallocation counter
                  I (ALLOC_S),
                  I (STORE_R FP)]

{-TODO:
  Array descriptions
  Pass by reference --verify
  Cons
  Size-}
transExpr:: I_expr -> State Int [Code]
transExpr expr = case expr of
  I_IVAL i -> return [I (LOAD_I i)] -- litterals
  I_BVAL True -> return [I (LOAD_B TRUE)]
  I_BVAL False -> return [I (LOAD_B FALSE)]
  I_CVAL c -> return [I (LOAD_C c)]
  I_RVAL f -> return [I (LOAD_F f)]
  I_ID (lvl, off, arrDesc) -> do
    ap <- calcAccessPointer lvl
    return $ ap ++ [I (LOAD_O off)] {- TODO something with the array -}
  I_APP (op, args) -> case (op, args) of -- evaluate arguments to top of stack, then evaluate
    (I_CALL (label, lvl), a) -> do
      args' <- mapM transExpr args
      ap <- calcAccessPointer lvl
      return $ concat (reverse args') ++ -- load arguments
          [I (ALLOC 1)] ++ -- make space for return
          ap ++ -- get the access pointer.
          [ I (LOAD_R FP), -- get the current frame pointer
            I (LOAD_R CP), -- set return address
            I (JUMP label)] -- go to the function, after which, there will be only the result of this function on the stack
    (I_CONS (conNum, nArgs), a) -> undefined --something way more fun on the heap.
    (I_ADD_I, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP ADD)]
    (I_MUL_I, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP MUL)]
    (I_SUB_I, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP SUB)]
    (I_DIV_I, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP DIV)]
    (I_NEG_I, [e]) -> do
          e' <- transExpr e
          return $ e' ++ [ I (APP NEG)]
    (I_ADD_F, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP ADD_F)]
    (I_MUL_F, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP MUL_F)]
    (I_SUB_F, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP SUB_F)]
    (I_DIV_F, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP DIV_F)]
    (I_NEG_F, [e]) -> do
          e' <- transExpr e
          return $ e' ++ [ I (APP NEG_F)]
    (I_LT_I, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP CodeGeneration.LT)]
    (I_LE_I, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP LE)]
    (I_GT_I, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP CodeGeneration.GT)]
    (I_GE_I, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP GE)]
    (I_EQ_I, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP CodeGeneration.EQ)]
    (I_LT_F, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP LT_F)]
    (I_LE_F, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP LE_F)]
    (I_GT_F, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP GT_F)]
    (I_GE_F, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP GE_F)]
    (I_EQ_F, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP EQ_F)]
    (I_LT_C, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP LT_C)]
    (I_LE_C, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP LE_C)]
    (I_GT_C, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP GT_C)]
    (I_GE_C, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP GE_C)]
    (I_EQ_C, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP EQ_C)]
    (I_NOT, [e]) -> do
          e' <- transExpr e
          return $ e' ++ [ I (APP NOT)]
    (I_AND, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP AND)]
    (I_OR, [e1, e2]) -> do
          e2' <- transExpr e2
          e1' <- transExpr e1
          return $ e1' ++ e2' ++ [ I (APP OR)]
    (I_FLOAT, [e]) -> do
          e' <- transExpr e
          return $ e' ++ [ I (APP FLOAT)]
    (I_FLOOR, [e]) -> do
          e' <- transExpr e
          return $ e' ++ [ I (APP FLOOR)]
    (I_CEIL, [e]) -> do
          e' <- transExpr e
          return $ e' ++ [ I (APP CEIL)]
  I_REF (lvl, off) -> do
    ap <- calcAccessPointer lvl
    return $ ap ++ [I (LOAD_O off)] -- TODO verify
  I_SIZE (lvl, off, dim) -> undefined -- TODO something with the array.

calcAccessPointer:: Int -> State Int [Code]
calcAccessPointer n = return $ I (LOAD_R FP) : replicate n (I (LOAD_O (-2)))
