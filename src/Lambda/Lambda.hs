module Lambda.Lambda where

import Control.Monad.Reader
-- import Control.Monad.Trans
-- import Control.Monad.Trans.Maybe

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
type Env = Reader ValMap Value

eval :: Expr -> Value
eval expr = runReader (eval' expr) Map.empty

eval' :: Expr -> Env
eval' (Lit l) = case l of
    LInt i -> return (VInt i)
    LBool b -> return (VBool b)

eval' (Var var) = do
    env <- ask
    return $ env Map.! var

eval' e@(Lam _ _) = do
    env <- ask
    return (VClos e env)

eval' (App e1 e2) = do
    eval1 <- eval' e1
    eval2 <- eval' e2
    return $ apply eval1 eval2
    where
        apply (VClos (Lam x e1) env) e2 =
            runReader (eval' e1) (Map.insert x e2 env)

eval' (BinOp op e1 e2) = do
    eval1 <- eval' e1
    eval2 <- eval' e2
    return $ case op of
        OpAdd -> opAdd eval1 eval2
        OpMul -> opMul eval1 eval2
        OpSub -> opSub eval1 eval2
        OpDiv -> opDiv eval1 eval2
        OpAnd -> opAnd eval1 eval2
        OpOr  -> opOr eval1 eval2
    where
        opAdd (VInt a) (VInt b)   = VInt $ a + b
        opMul (VInt a) (VInt b)   = VInt $ a * b
        opSub (VInt a) (VInt b)   = VInt $ a - b
        opDiv (VInt a) (VInt b)   = VInt $ a `div` b
        opAnd (VBool a) (VBool b) = VBool $ a && b
        opOr  (VBool a) (VBool b) = VBool $ a || b


eval' (UnOp op e) = do
    (VBool b) <- eval' e
    return $ case op of
        OpNeg -> VBool $ not b