module Lambda.Lambda (
    Name,
    Expr(..),
    Lit(..),
    BinOp(..),
    UnOp(..),
    Value(..),
    TypeDef(..),
    ValMap,
    ConsMap,
    TypeMap,
    Env(..),
    eval,
    fixed,
    emptyEnv
) where

import Control.Monad.Reader
import Control.Monad.Except

import qualified Data.Map as Map

import Types
import Utils

type Name = String

data Expr = Var Name
          | Lam Name Expr
          | Lit Lit
          | App Expr Expr
          | Let Name Expr Expr
          | LetRec [(Name, Expr)] Expr
          | If Expr Expr Expr
          | BinOp BinOp Expr Expr
          | UnOp UnOp Expr
          | Cons Expr Expr
          | AlgCons Name [Expr]
          deriving (Show)

data Lit = LInt Integer
         | LBool Bool
         | LNil
         deriving (Show)

data BinOp = OpAdd | OpMul | OpSub | OpDiv | OpAnd | OpOr | OpEq | OpLT
    deriving (Show)
data UnOp = OpNeg | OpNot
    deriving (Show)

data Value = VInt Integer 
           | VBool Bool 
           | VClos Name Expr ValMap
           | VFixed Name [(Name, Expr)] ValMap
           | VCons Value Value
           | VNil
           | VAlg Name TypeName [Value]
    deriving (Show)

data TypeDef = TypeDef { polynames :: [Name], consdef :: [(Name, [Type])] }

type ValMap = Map.Map Name Value
type TypeName = String
type ConsMap = Map.Map Name (Int, TypeName)
type TypeMap = Map.Map TypeName TypeDef

data Env = Env 
    { values :: ValMap
    , constructors :: ConsMap
    , algtypes  :: TypeMap }

emptyEnv :: Env
emptyEnv = Env { values = Map.empty
               , constructors = Map.empty
               , algtypes = Map.empty }

type EvalReader = ReaderT Env (Except String) Value

fixed :: ValMap -> [(Name, Expr)] -> [(Name, Value)]
fixed env l = map (\(n, _) -> (n, VFixed n l env)) l

eval :: Env -> Expr -> Either String Value
eval map expr = runExcept (runReaderT (eval' expr) map)

eval' :: Expr -> EvalReader
eval' (Lit l) = case l of
    LInt i -> return (VInt i)
    LBool b -> return (VBool b)
    LNil -> return VNil

eval' (Var var) = do
    env <- ask
    let vmap = values env
    maybe (throwError $ "Unbound value " ++ var) return (Map.lookup var vmap)

eval' (Lam n e) = do
    env <- ask
    let vmap = values env
    return (VClos n e vmap)

eval' (Let n e1 e2) = do
    env <- ask
    let vmap = values env
    eval1 <- either fail return $ eval env e1
    let nmap = Map.insert n eval1 vmap
    either throwError return $ ev (Map.union nmap vmap) env
    where
        ev :: ValMap -> Env -> Either String Value
        ev vmap env = runExcept (runReaderT (eval' e2) (env {values=vmap}))

eval' (LetRec l e) = do
    env <- ask
    let vmap = values env
    let nmap = Map.fromList $ fixed vmap l
    either throwError return $ ev (Map.union nmap vmap) env
    where
        ev :: ValMap -> Env -> Either String Value
        ev vmap env = runExcept (runReaderT (eval' e) (env {values=vmap}))

eval' (App e1 e2) = do
    env <- ask
    eval1 <- eval' e1
    eval2 <- eval' e2
    either throwError return $ apply eval1 eval2 env
    where
        apply (VClos x e1 vmap) e2 env =
            runExcept (runReaderT (eval' e1) (env {values=Map.insert x e2 vmap}))
        apply (VFixed fn l vmap) e2 env = case found of
            (_, Lam x e1):_ -> runExcept (runReaderT (eval' e1) (env {values=nmap x}))
            _ -> throwError "Expression is not a function; it cannot be applied"
            where
                found = filter (\(n, _) -> n == fn) l
                l' = map (\(n, _) -> (n, VFixed n l vmap)) l
                nmap x = Map.insert x e2 (Map.union (Map.fromList l') vmap)
        apply _ _ _ = throwError "Expression is not a function; it cannot be applied"

eval' (If cond e1 e2) = do
    c <- eval' cond
    case c of
        VBool b -> if b then eval' e1 else eval' e2
        _ -> throwError boolTypeError

eval' (BinOp op e1 e2) = do
    eval1 <- eval' e1
    eval2 <- eval' e2
    either throwError return $ binOp eval1 eval2 op
    where
        binOp :: Value -> Value -> BinOp -> Either String Value
        binOp (VInt a) (VInt b) OpAdd = return . VInt $ a + b
        binOp (VInt a) (VInt b) OpMul = return . VInt $ a * b
        binOp (VInt a) (VInt b) OpSub = return . VInt $ a - b
        binOp (VInt a) (VInt 0) OpDiv = throwError "Cannot divide by zero"
        binOp (VInt a) (VInt b) OpDiv = return . VInt $ a `div` b
        binOp _ _ OpAdd = throwError intTypeError
        binOp _ _ OpMul = throwError intTypeError
        binOp _ _ OpSub = throwError intTypeError
        binOp _ _ OpDiv = throwError intTypeError
        binOp (VBool a) (VBool b) OpAnd = return . VBool $ a && b
        binOp (VBool a) (VBool b) OpOr  = return . VBool $ a || b
        binOp (VBool a) (VBool b) OpEq  = return . VBool $ a == b
        binOp (VInt a) (VInt b) OpEq    = return . VBool $ a == b
        binOp (VInt a) (VInt b) OpLT    = return . VBool $ a < b
        binOp _ _ OpEq  = throwError boolTypeError
        binOp _ _ OpLT  = throwError boolTypeError
        binOp _ _ OpAnd = throwError boolTypeError
        binOp _ _ OpOr  = throwError boolTypeError

eval' (UnOp op e) = do
    ev <- eval' e
    either throwError return $ unOp ev op
    where 
        unOp :: Value -> UnOp -> Either String Value
        unOp (VInt v) OpNeg = return . VInt $ (-v)
        unOp _ OpNeg = throwError intTypeError
        unOp (VBool b) OpNot = return . VBool $ not b
        unOp _ OpNot = throwError boolTypeError

eval' (Cons e1 e2) = do
    eval1 <- eval' e1
    eval2 <- eval' e2
    return $ VCons eval1 eval2

eval' (AlgCons cname le) = do
    env <- ask
    let cmap = constructors env
    c <- maybe (throwError $ "Unbound constructor " ++ cname) return $
         (Map.lookup cname cmap)
    let (count, tname) = c
    args <- mapM eval' le
    let arglen = length args
    if arglen == count then return $ VAlg cname tname $ args
    else throwError $ err cname count arglen
    where
        err :: String -> Int -> Int -> String
        err cname expected provided =
            "The constructor " ++ cname ++ " expects " ++ show expected 
            ++ " argument(s), but is applied to " ++ show provided ++ " argument(s)"

typeError :: String -> String
typeError t = "Expression was expected of type " ++ t

intTypeError :: String
intTypeError = typeError "int"

boolTypeError :: String
boolTypeError = typeError "bool"

example1 :: Expr
example1 = App (App (App (Lam "f" (Lam "g" (Lam "h" (App (App (Var "f") (App (App (Var "g") (Lit $ LInt 1)) (Lit $ LInt 2))) (App (App (Var "h") (Lit $ LInt 3)) (Lit $ LInt 4)))))) (Lam "x" (Lam "y" (BinOp OpAdd (Var "x") (Var "y"))))) (Lam "x" (Lam "y" (BinOp OpSub (Var "x") (Var "y"))))) (Lam "x" (Lam "y" (BinOp OpMul (Var "x") (Var "y"))))

twice :: Expr
twice = Lam "f" (Lam "x" (App (Var "f") (App (Var "f") (Var "x"))))

not' :: Expr
not' = Lam "x" (UnOp OpNeg (Var "x"))

example2 :: Expr
example2 = App (Lam "t" (App (App (Var "t") (not')) (Lit $ LBool True))) twice

yComb :: Expr
yComb = Lam "h" (App (Lam "x" (App (Var "h") (App (Var "x") (Var "x")))) (Lam "x" (App (Var "h") (App (Var "x") (Var "x")))))

zComb :: Expr
zComb = Lam "f" (App (Lam "x" (App (Var "f") (Lam "v" (App (App (Var "x") (Var "x")) (Var "v"))))) (Lam "x" (App (Var "f") (Lam "v" (App (App (Var "x") (Var "x")) (Var "v"))))))

sComb :: Expr
sComb = Lam "f" (Lam "g" (Lam "x" (App (App (Var "f") (Var "x")) (App (Var "g") (Var "x")))))

kComb :: Expr
kComb = Lam "x" (Lam "y" (Var "x"))

iComb :: Expr
iComb = Lam "x" (Var "x")

hFac :: Expr
hFac = (Lam "n" (If (BinOp OpEq (Var "n") (Lit $ LInt 0)) (Lit $ LInt 1) (BinOp OpMul (Var "n") (App (Var "fac") (BinOp OpSub (Var "n") (Lit $ LInt 1))))))

omega :: Expr
omega = App (Lam "x" (App (Var "x") (Var "x")))
            (Lam "x" (App (Var "x") (Var "x")))

testing :: ValMap
testing = Map.fromList [
    ("f", VFixed "f" [
        ("f", Lam "n" (If (BinOp OpEq (Var "n") (Lit $ LInt 0)) (Lit $ LInt 0) (App (Var "g") (BinOp OpSub (Var "n") (Lit $ LInt 1))))),
        ("g", Lam "n" (If (BinOp OpEq (Var "n") (Lit $ LInt 0)) (Lit $ LInt 1) (App (Var "f") (BinOp OpSub (Var "n") (Lit $ LInt 1)))))
    ] Map.empty)]