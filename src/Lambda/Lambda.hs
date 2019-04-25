module Lambda.Lambda where

import Control.Monad.Reader
import Control.Monad.Except

import qualified Data.Map as Map

type Name = String

data Expr = Var Name
          | Lam Name Expr
          | Lit Lit
          | App Expr Expr
          | If Expr Expr Expr
          | BinOp BinOp Expr Expr
          | UnOp UnOp Expr
          | Mapped Expr ValMap
          | Fix Name Expr
          deriving (Show)

data Lit = LInt Integer
         | LBool Bool
         deriving (Show)

data BinOp = OpAdd | OpMul | OpSub | OpDiv | OpAnd | OpOr | OpEq | OpLT
    deriving (Show)
data UnOp = OpNeg | OpNot
    deriving (Show)

data Value = VInt Integer 
           | VBool Bool 
           | VClos Expr ValMap
           | VFixed Name [(Name, Expr)] ValMap
    deriving (Show)

type ValMap = Map.Map Name Value
type Env = ReaderT ValMap (Except String) Value

eval :: Expr -> Either String Value
eval expr = runExcept (runReaderT (eval' expr) Map.empty)

evalEnv :: ValMap -> Expr -> Either String Value
evalEnv map expr = runExcept (runReaderT (eval' expr) map)

eval' :: Expr -> Env
eval' (Lit l) = case l of
    LInt i -> return (VInt i)
    LBool b -> return (VBool b)

eval' (Var var) = do
    env <- ask
    maybe (throwError $ "Unbound value " ++ var) return (Map.lookup var env)

eval' e@(Lam _ _) = do
    env <- ask
    return (VClos e env)

eval' (Fix n e) = do
    env <- ask
    return $ VFixed n [(n, e)] env

eval' (App e1 e2) = do
    eval1 <- eval' e1
    eval2 <- eval' e2
    either throwError return $ apply eval1 eval2
    where
        apply (VClos (Lam x e1) env) e2 =
            runExcept (runReaderT (eval' e1) (Map.insert x e2 env))
        apply (VFixed fn l env) e2 =
            let (_, Lam x e1) = head $ filter (\(n, lam) -> n == fn) l in
            runExcept (runReaderT (eval' e1) (Map.union (Map.fromList l') (Map.insert x e2 env)))
            where
                l' = map (\(n, e) -> (n, VFixed n l env)) l
        apply _ _ = throwError "Expression is not a function; it cannot be applied"

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

eval' (Mapped e vmap) = do
    env <- ask
    either throwError return $ ev env
    where
        ev env = runExcept (runReaderT (eval' e) (Map.union vmap env))

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