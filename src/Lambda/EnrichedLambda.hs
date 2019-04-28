module Lambda.EnrichedLambda where

import Control.Monad.Reader
import Control.Monad.Except

import qualified Data.Map as Map

import qualified Lambda.Lambda as L

import Utils

type Name  = L.Name
type BinOp = L.BinOp
type UnOp  = L.UnOp
type Value = L.Value
type Lit   = L.Lit

data Expr = Var Name
          | Lam Name Expr
          | Lit Lit
          | App Expr Expr
          | If Expr Expr Expr
          | BinOp BinOp Expr Expr
          | UnOp UnOp Expr
          | Let Name Expr Expr
          | LetRec [(Name, Expr)] Expr
          | Fix Name Expr
          deriving (Show)

-- data Pattern = Lit
--             | Var Name
--             | Constructor
--             deriving (Show)

type EState = ReaderT L.ValMap (Except String)

eval :: L.ValMap -> Expr -> Either String L.Value
eval vmap expr = do
    texpr <- runExcept (runReaderT (translate expr) vmap)
    either throwError return $ L.eval vmap texpr

translate :: Expr -> EState L.Expr
translate (Var n) = return $ L.Var n
translate (Lam n e) = do
    te <- translate e
    return $ L.Lam n te
translate (Lit l) = pure $ L.Lit l
translate (App e1 e2) = do
    te1 <- translate e1
    te2 <- translate e2
    return $ L.App te1 te2
translate (If c e1 e2) = do
    cond <- translate c
    te1 <- translate e1
    te2 <- translate e2
    return $ L.If cond te1 te2
translate (BinOp op e1 e2) = do
    te1 <- translate e1
    te2 <- translate e2
    return $ L.BinOp op te1 te2
translate (UnOp op e) = do
    te <- translate e
    return $ L.UnOp op te
translate (Let n e1 e2) = do
    vmap <- ask
    ev <- either fail return $ eval vmap e1
    let nmap = Map.insert n ev vmap
    te2 <- translate e2
    return $ L.Mapped te2 nmap
translate (LetRec l e) = do
    vmap <- ask
    l' <- either fail return $ seqPair $ map (\(n, e) -> (n, translate' e)) l
    let ml = Map.fromList $ L.fixed vmap l'
    let nmap = Map.union ml vmap
    te <- translate e
    return $ L.Mapped te nmap
translate (Fix n e) = do
    te <- translate e
    return $ L.Fix n te

translate' :: Expr -> Either String L.Expr
translate' (Var n) = return $ L.Var n
translate' (Lam n e) = do 
    te <- translate' e
    return $ L.Lam n te
translate' (Lit l) = return $ L.Lit l
translate' (App e1 e2) = do
    te1 <- translate' e1
    te2 <- translate' e2
    return $ L.App te1 te2
translate' (If c e1 e2) = do
    tc <- translate' c
    te1 <- translate' e1
    te2 <- translate' e2
    return $ L.If tc te1 te2
translate' (BinOp op e1 e2) = do
    te1 <- translate' e1
    te2 <- translate' e2
    return $ L.BinOp op te1 te2
translate' (UnOp op e) = do
    te <- translate' e
    return $ L.UnOp op te
translate' (Let n e1 e2) = do
    te1 <- translate' e1
    te2 <- translate' e2
    return $ L.App (L.Lam n te2) te1
translate' (LetRec _ _) = Left "recursive recursion"

-- eval (LetRec "fac" (Lam "n" (If (BinOp L.OpEq (Var "n") (Lit $ L.LInt 0)) (Lit $ L.LInt 1) (BinOp L.OpMul (Var "n") (App (Var "fac") (BinOp L.OpSub (Var "n") (Lit $ L.LInt 1)))))) (App (Var "fac") (Lit $ L.LInt 2)))