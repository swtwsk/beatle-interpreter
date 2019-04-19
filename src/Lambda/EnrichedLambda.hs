module Lambda.EnrichedLambda where

import qualified Lambda.Lambda as L

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
          | LetRec Name Expr Expr
          deriving (Show)

-- data Pattern = Lit
--             | Var Name
--             | Constructor
--             deriving (Show)

eval :: Expr -> Either String Value
eval = L.eval . translate

translate :: Expr -> L.Expr
translate (Var n) = L.Var n
translate (Lam n e) = L.Lam n (translate e)
translate (Lit l) = L.Lit l
translate (App e1 e2) = L.App (translate e1) (translate e2)
translate (If c e1 e2) = L.If (translate c) (translate e1) (translate e2)
translate (BinOp op e1 e2) = L.BinOp op (translate e1) (translate e2)
translate (UnOp op e) = L.UnOp op (translate e)
translate (Let n e1 e2) = L.App (L.Lam n (translate e2)) (translate e1)
translate (LetRec n e1 e2) = L.App (L.Lam n (translate e2)) (L.App L.zComb (L.Lam n (translate e1)))

-- eval (LetRec "fac" (Lam "n" (If (BinOp L.OpEq (Var "n") (Lit $ L.LInt 0)) (Lit $ L.LInt 1) (BinOp L.OpMul (Var "n") (App (Var "fac") (BinOp L.OpSub (Var "n") (Lit $ L.LInt 1)))))) (App (Var "fac") (Lit $ L.LInt 2)))