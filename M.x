{
module MLexer (mLex) where
import System.Environment
}

%wrapper "monadUserState"

$digit = 0-9            -- digits
$alpha = [a-zA-Z]        -- alphabetic characters
$newline = [\n]

tokens :-
  <0>   $white+                           ;
  <0, comment>   "%".*                    ; --single line comment
  <0>   $newline                          ;
  <0,comment>   "/*"                      { beginComment } --multiline comment
  <comment>     "*/"                      { endComment }
  <comment>     [.\n]                     ;
  <0>   \+                                { mkToken ADD }
  <0>   \-                                { mkToken SUB }
  <0>   \*                                { mkToken MUL }
  <0>   \/                                { mkToken DIV }
  <0>   =>                                { mkToken ARROW }
  <0>   &&                                { mkToken AND }
  <0>   "||"                              { mkToken OR }
  <0>   not                               { mkToken NOT }
  <0>   \=                                { mkToken EQUAL }
  <0>   "<"                               { mkToken LESSTHAN }
  <0>   >                                 { mkToken GREATERTHAN }
  <0>   "=<"                              { mkToken LE }
  <0>   "<="                              { mkToken GE }

  <0>   :=                                { mkToken ASSIGN }

  <0>   \(                                { mkToken LPAR }
  <0>   \)                                { mkToken RPAR }
  <0>   \{                                { mkToken CLPAR }
  <0>   \}                                { mkToken CRPAR }
  <0>   \[                                { mkToken SLPAR }
  <0>   \]                                { mkToken SRPAR }
  <0>   \|                                { mkToken SLASH }

  <0>   \:                                { mkToken COLON }
  <0>   \;                                { mkToken SEMICOLON }
  <0>   \,                                { mkToken COMMA }

  <0>   if                                { mkToken IF }
  <0>   then                              { mkToken THEN }
  <0>   while                             { mkToken WHILE }
  <0>   do                                { mkToken DO }
  <0>   read                              { mkToken READ }
  <0>   else                              { mkToken ELSE }
  <0>   begin                             { mkToken BEGIN }
  <0>   end                               { mkToken END }
  <0>   case                              { mkToken CASE }
  <0>   of                                { mkToken OF }
  <0>   print                             { mkToken PRINT }
  <0>   int                               { mkToken INT }
  <0>   bool                              { mkToken BOOL }
  <0>   char                              { mkToken CHAR }
  <0>   real                              { mkToken REAL }
  <0>   var                               { mkToken VAR }
  <0>   data                              { mkToken DATA }
  <0>   size                              { mkToken SIZE }
  <0>   float                             { mkToken FLOAT }
  <0>   floor                             { mkToken FLOOR }
  <0>   ceil                              { mkToken CEIL }
  <0>   fun                               { mkToken FUN }
  <0>   return                            { mkToken RETURN }

  <0>   \# [$alpha $digit \_]*            { \a l -> return $ (CID $ fst (getStrPosn a l), snd (getStrPosn a l)) }
  <0>   $alpha [$alpha $digit \_]*        { \a l -> return $ (ID $ fst (getStrPosn a l), snd (getStrPosn a l)) }
  <0>   $digit+"\."$digit+                { \a l -> return $ (RVAL (read (fst (getStrPosn a l))), snd (getStrPosn a l)) }
  <0>   $digit+                           { \a l -> return $ (IVAL (read (fst (getStrPosn a l))), snd (getStrPosn a l)) }
  <0>   false                             { mkToken (BVAL False) }
  <0>   true                              { mkToken (BVAL True) }
  <0>   "\"" $alpha "\""                  { \a l -> return $ (CVAL ((fst (getStrPosn a l)) !! 1), snd (getStrPosn a l)) }
  <0>   "\"\n\""                          { \a l -> return $ (CVAL ((fst (getStrPosn a l)) !! 1), snd (getStrPosn a l)) }
  <0>   "\"\t\""                          { \a l -> return $ (CVAL ((fst (getStrPosn a l)) !! 1), snd (getStrPosn a l)) }
{

data AlexUserState = AlexUserState { commentDepth :: Int}

data Pos = Pos Int Int
type Token = (TokenClass, Pos)

data TokenClass
  = MLC_Start | MLC_End
  | ADD | SUB | MUL | DIV | ARROW
  | AND | OR | NOT
  | EQUAL | LESSTHAN | GREATERTHAN | LE | GE
  | ASSIGN
  | LPAR | RPAR | CLPAR | CRPAR | SLPAR | SRPAR | SLASH
  | COLON | SEMICOLON | COMMA
  | IF | THEN | ELSE | WHILE | DO | READ | PRINT
  | BEGIN | END | CASE | OF
  | INT | BOOL | CHAR | REAL | VAR | DATA | SIZE
  | FLOAT | FLOOR | CEIL | FUN | RETURN
  | CID String | ID String | RVAL Float | IVAL Int | BVAL Bool | CVAL Char
  | LEOF

    deriving (Eq,Show)

{-instance Show Token where
  show (tkn, pos) = show tkn {-++ ":" ++ show pos-}-}

instance Show Pos where
  show (Pos l c) = show l ++ ":" ++ show c

alexEOF = return (LEOF, (Pos 0 0))

mkToken :: TokenClass -> AlexInput -> Int -> Alex Token
mkToken tClass ((AlexPn _ l c), prev, pend, input) len = return (tClass, (Pos l c))

getStrPosn::AlexInput -> Int -> (String, Pos)
getStrPosn ((AlexPn _ l c), _, _, input) len = (take len input, Pos l c)

getCommentDepth::Alex Int
getCommentDepth = Alex $ \state@AlexState{alex_ust=ust} -> Right (state, commentDepth ust)

setCommentDepth::Int -> Alex ()
setCommentDepth cd = Alex $ \state -> Right (state{alex_ust=(alex_ust state){commentDepth=cd}}, () )

beginComment :: AlexInput -> Int -> Alex Token
beginComment (pos, prev, pend, input) _ = do
    d <- getCommentDepth
    setCommentDepth (d+1)
    alexSetStartCode 1
    return $ (MLC_Start, (Pos 0 0))

endComment :: AlexInput -> Int -> Alex Token
endComment (pos, prev, pend, input) _ = do
    d <- getCommentDepth
    let newDepth = d-1
    setCommentDepth newDepth
    case newDepth of
        0 -> alexSetStartCode 0
        _ -> alexSetStartCode 1
    return $ (MLC_End, (Pos 0 0))

alexInitUserState :: AlexUserState
alexInitUserState = AlexUserState { commentDepth = 0 }

scanner::String -> Either String [Token]
scanner string = runAlex string $ do
    let loop = do tok@(tClass, (Pos l c)) <- alexMonadScan;
                    if tClass == LEOF
                        then do i <- getCommentDepth
                                if (i == 0) then return [] else alexError "Bad Brackets"
                        else do toks <- loop
                                return $ tok : toks
    loop

test = do
    args <- getArgs
    case length args == 0 of
        True -> do putStrLn "Usage: mMinus.exe \"Tests\\testX.m-\""
        False -> do
            let fname = args !! 0
            fConts <- readFile fname{-"./assignment1/test1.m-"-}
            let tokens = scanner fConts
            case tokens of
                Left err -> print err
                Right toks -> mapM_ (putStrLn.show) toks

--lexer::String -> Either String [(TokenClass, Int, Int)]

mLex :: String -> IO (Either String [Token])
mLex fname = do
    fConts <- readFile fname
    let tokens = scanner fConts
    case tokens of
        Left err -> return $ Left err
        Right toks -> return $ Right [t | t@(tClass, _) <- toks, tClass /= MLC_End, tClass /= MLC_Start ]

}
