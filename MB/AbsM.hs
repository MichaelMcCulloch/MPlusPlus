

module AbsM where

-- Haskell module generated by the BNF converter




newtype Ident = Ident String deriving (Eq, Ord, Show, Read)
newtype CID = CID String deriving (Eq, Ord, Show, Read)
newtype BVAL = BVAL String deriving (Eq, Ord, Show, Read)
data Prog = P Block
  deriving (Eq, Ord, Show, Read)

data Block = Prog [Declaration] ProgramBody
  deriving (Eq, Ord, Show, Read)

data Declaration
    = VarDef VarDeclaration
    | FunDef FunDeclaration
    | DataDef DataDeclaration
  deriving (Eq, Ord, Show, Read)

data VarDeclaration = VarDeclaration [VarSpec] Type
  deriving (Eq, Ord, Show, Read)

data VarSpec = VarSpec Ident [ArrayDimension]
  deriving (Eq, Ord, Show, Read)

data ArrayDimension = ArrDim Expr
  deriving (Eq, Ord, Show, Read)

data Type = Tint | Treal | Tbool | Tchar | Tuser Ident
  deriving (Eq, Ord, Show, Read)

data FunDeclaration = FunctionDec Ident ParamList Type FunBlock
  deriving (Eq, Ord, Show, Read)

data FunBlock = FunctionBlock [Declaration] FunBody
  deriving (Eq, Ord, Show, Read)

data ParamList = ParameterList [BasicDeclaration]
  deriving (Eq, Ord, Show, Read)

data BasicDeclaration
    = BasicDeclaration Ident [BasicArrayDimension] Type
  deriving (Eq, Ord, Show, Read)

data BasicArrayDimension = BArrDim
  deriving (Eq, Ord, Show, Read)

data DataDeclaration = DataDeclaration Ident [ConsDecl]
  deriving (Eq, Ord, Show, Read)

data ConsDecl = CTypeList CID [Type] | CSimple CID
  deriving (Eq, Ord, Show, Read)

data ProgramBody = ProgBodyA [ProgStmt] | ProgBodyB [ProgStmt]
  deriving (Eq, Ord, Show, Read)

data FunBody = FunBodyA [ProgStmt] Expr | FunBodyB [ProgStmt] Expr
  deriving (Eq, Ord, Show, Read)

data ProgStmt
    = PIf Expr ProgStmt ProgStmt
    | PWhile Expr ProgStmt
    | PRead Location
    | PLocation Location Expr
    | PPrint Expr
    | PBlock Block
    | PExpr Expr [Case]
  deriving (Eq, Ord, Show, Read)

data Location = Location Ident [ArrayDimension]
  deriving (Eq, Ord, Show, Read)

data Case = Case CID VarList ProgStmt
  deriving (Eq, Ord, Show, Read)

data VarList = VLList [Ident] | VLEnd
  deriving (Eq, Ord, Show, Read)

data Expr = BOr Expr BintTerm | BTerm BintTerm
  deriving (Eq, Ord, Show, Read)

data BintTerm = BAnd BintTerm BintFactor | BFactor BintFactor
  deriving (Eq, Ord, Show, Read)

data BintFactor
    = BNot BintFactor
    | BCompare IntExpr CompareOp IntExpr
    | BExpr IntExpr
  deriving (Eq, Ord, Show, Read)

data CompareOp = CompEQ | CompLT | CompGT | CompLEQ | CompGEQ
  deriving (Eq, Ord, Show, Read)

data IntExpr = IntAdd IntExpr Addop IntTerm | IntTerm IntTerm
  deriving (Eq, Ord, Show, Read)

data Addop = Add | Sub
  deriving (Eq, Ord, Show, Read)

data IntTerm = IntMul IntTerm Mulop IntFactor | IntFactor IntFactor
  deriving (Eq, Ord, Show, Read)

data Mulop = Mult | Divide
  deriving (Eq, Ord, Show, Read)

data IntFactor
    = Expression Expr
    | Size Ident [BasicArrayDimension]
    | Float Expr
    | Floor Expr
    | Ceil Expr
    | ID Ident ModifierList
    | Data CID ConsArgumentList
    | Integer Integer
    | Real Double
    | Boolean BVAL
    | Character Char
    | Negate IntFactor
  deriving (Eq, Ord, Show, Read)

data ModifierList
    = FunctionCall FunArgumentList | ArrayAccess [ArrayDimension]
  deriving (Eq, Ord, Show, Read)

data FunArgumentList = Args [Expr]
  deriving (Eq, Ord, Show, Read)

data ConsArgumentList = DataArguments FunArgumentList | NoArguments
  deriving (Eq, Ord, Show, Read)
