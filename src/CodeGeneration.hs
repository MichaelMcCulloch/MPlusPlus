module CodeGeneration where

import Data.List
import IntermediateRepresentation

type Offset = Int
data Register = FP | SP | CP | HP
data Operation = ADD_F | SUB_F | DIV_F | MUL_F | NEG_F | FLOOR | CEIL
               | ADD | SUB | DIV | MUL | NEG | FLOAT
               | LT_F | LE_F | EQ_F | GE_F | GT_F
               | LT_C | LE_C | EQ_C | GE_C | GT_C
               | LT | LE | EQ | GE | GT
               | AND | OR | NOT
               deriving (Show)
data Instruction  = LOAD_R Register --load places something ontop of the stack
                  | LOAD_F Double | LOAD_I Int | LOAD_B Bool | LOAD_C Char     -- litterals
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
                  deriving (Show)
instance Show Register where
  show FP = "%fp"
  show SP = "%sp"
  show CP = "%cp"
  show HP = "%hp"

codeGen::I_prog -> String
codeGen prog = intercalate "\n" $ transProg prog
  -- (intercalate "\n") . (map show) $ transProg prog

transProg::I_prog -> [String]
transProg (I_PROG (funs, nVars, arrDesc, body)) = prog where
  prog = progStart ++ progBody ++ progEnd ++ functions
  progStart = [ "LOAD_R %sp", -- put the stack pointer on the stack
                "LOAD_R %sp",
                "STORE_R %fp", -- and put it in the frame pointer
                "ALLOC " ++ show nVars] -- alocate space for local variables
  progBody = concatMap transBody body
  progEnd = undefined-- deallocate stack
  functions = concatMap transFun funs

transFun::I_fbody -> [String]
transFun (I_FUN (lbl,funs,nArgs,nLoc,varDesc,stmts)) = undefined




transBody::I_stmt -> [String]
transBody stmt = case stmt of
  I_ASS (lvl, off, arrDesc, expr) -> undefined
  I_WHILE (expr, stmt) -> undefined
  I_COND (expr, thenStmt, elseStmt) -> undefined
  I_CASE (expr, cases) -> undefined
  I_READ_B (lvl, off, arrDesc) -> undefined
  I_READ_I (lvl, off, arrDesc) -> undefined
  I_READ_F (lvl, off, arrDesc) -> undefined
  I_READ_C (lvl, off, arrDesc) -> undefined
  I_PRINT_B expr -> undefined
  I_PRINT_I expr -> undefined
  I_PRINT_F expr -> undefined
  I_PRINT_C expr -> undefined
  I_RETURN expr -> undefined
  I_BLOCK (funs, nVars, varDesc, stmts) -> undefined

transExpr::I_expr -> [String]
transExpr expr = case expr of
  I_IVAL i -> ["LOAD_I " ++ show i] -- litterals
  I_BVAL True -> ["LOAD_B TRUE"]
  I_BVAL False -> ["LOAD_B FALSE"]
  I_CVAL c -> ["LOAD_C " ++ show c]
  I_RVAL f -> ["LOAD_R " ++ show f]
  I_ID (lvl, off, arrDesc) -> calcAccessPointer lvl ++ ["LOAD_O " ++ show off] {- something with the array -}
  I_APP (op, args) -> case (op, args) of -- evaluate arguments to top of stack, then evaluate
    (I_CALL (label, lvl), a) -> concatMap transExpr args ++ calcAccessPointer lvl ++ {-set up stack for call. -} []++["JUMP " ++ label]
    (I_CONS (lvl,off), []) -> undefined --something way more fun.
    (I_ADD_I, [e1, e2]) -> let
          e2' = transExpr e2
          e1' = transExpr e1
          in e1' ++ e2' ++ ["APP ADD_I"]
    (I_MUL_I, []) ->
    (I_SUB_I, []) ->
    (I_DIV_I, []) ->
    (I_NEG_I, []) ->
    (I_ADD_F, []) ->
    (I_MUL_F, []) ->
    (I_SUB_F, []) ->
    (I_DIV_F, []) ->
    (I_NEG_F, []) ->
    (I_LT_I, []) ->
    (I_LE_I, []) ->
    (I_GT_I, []) ->
    (I_GE_I, []) ->
    (I_EQ_I, []) ->
    (I_LT_F, []) ->
    (I_LE_F, []) ->
    (I_GT_F, []) ->
    (I_GE_F, []) ->
    (I_EQ_F, []) ->
    (I_LT_C, []) ->
    (I_LE_C, []) ->
    (I_GT_C, []) ->
    (I_GE_C, []) ->
    (I_EQ_C, []) ->
    (I_NOT, []) ->
    (I_AND, []) ->
    (I_OR, []) ->
    (I_FLOAT, []) ->
    (I_FLOOR, []) ->
    (I_CEIL, []) ->
  I_REF (lvl, off) -> -- put pointer to the array ontop of the stack.
  I_SIZE (lvl, off, dim) -> -- something with the array.

calcAccessPointer::Int -> [String]
calcAccessPointer n = "LOADA_R %fp" : replicate n "LOAD_O -2"
