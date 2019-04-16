module Lambda.Lambda where

import Control.Monad.Reader
import Control.Monad.Except

import qualified Data.Map as Map

type Name = String

data Expr = Var Name
          | Lam Name Expr
          | Lit Lit
          | App Expr Expr
          | BinOp BinOp Expr Expr
          | UnOp UnOp Expr
          deriving (Show)

data Lit = LInt Int
         | LBool Bool
         deriving (Show)

data BinOp = OpAdd | OpMul | OpSub | OpDiv | OpAnd | OpOr
    deriving (Show)
data UnOp = OpNeg
    deriving (Show)

data Value = VInt Int | VBool Bool | VClos Expr ValMap
    deriving (Show)

type ValMap = Map.Map Name Value
type Env = ReaderT ValMap (Except String) Value

eval :: Expr -> Either String Value
eval expr = runExcept (runReaderT (eval' expr) Map.empty)

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

eval' (App e1 e2) = do
    eval1 <- eval' e1
    eval2 <- eval' e2
    either throwError return $ apply eval1 eval2
    where
        apply (VClos (Lam x e1) env) e2 =
            runExcept (runReaderT (eval' e1) (Map.insert x e2 env))
        apply _ _ = throwError "First expression is not a function; it cannot be applied"

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
        binOp  (VBool a) (VBool b) OpOr = return . VBool $ a || b
        binOp _ _ OpAnd = throwError boolTypeError
        binOp _ _ OpOr  = throwError boolTypeError

eval' (UnOp op e) = do
    ev <- eval' e
    either throwError return $ boolOp ev op
    where 
        boolOp :: Value -> UnOp -> Either String Value
        boolOp (VBool b) OpNeg = return . VBool $ not b
        boolOp _ _ = throwError boolTypeError


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