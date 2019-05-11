module Expr(
    Name,
    Expr(..),
    Pattern(..),
    Lit(..),
    BinOp(..),
    UnOp(..),
    Type(..)
) where

import Data.List (intercalate)

type Name = String

data Expr = Var Name
          | Lam Pattern Type Expr
          | Lit Lit
          | App Expr Expr
          | Let Pattern Expr Expr
          | LetRec [(Pattern, Type, Expr)] Expr
          | If Expr Expr Expr
          | BinOp BinOp Expr Expr
          | UnOp UnOp Expr
          | Cons Expr Expr                   -- list
          | AlgCons Name [Expr]
          | Case Name [(Pattern, Type, Expr)]

data Pattern = PConst Lit            -- constant
             | PVar Name             -- variable
             | PCons Pattern Pattern -- list

data Lit = LInt Integer
         | LBool Bool
         | LNil

data BinOp = OpAdd | OpMul | OpSub | OpDiv | OpAnd | OpOr | OpEq | OpLT
data UnOp = OpNeg | OpNot


data Type = TInt
          | TBool
          | TFun Type Type
          | TVar String
          | TList Type
          | TAlg String
          | TPoly String
          deriving (Eq)

data Scheme = Scheme [String] Type

----- SHOW INSTANCES -----
instance Show Expr where
    show (Var n) = n
    show (Lam n t e) = "λ(" ++ show n ++ " : " ++ show t ++ ") -> " ++ show e
    show (Lit l) = show l
    show (App e1 e2) = "(" ++ show e1 ++ ")(" ++ show e2 ++ ")"
    show (Let n e1 e2) = "let " ++ show n ++ " = " ++ show e1 ++ " in " ++ show e2
    show (LetRec l e) = 
        "letrec " ++ 
        intercalate " also " (map (\(n, _, e') -> show n ++ " = " 
        ++ show e') l) ++ " in " ++ show e
    show (If cond e1 e2) = "if " ++ show cond ++ " then " ++ show e1 ++ 
        " else " ++ show e2
    show (BinOp op e1 e2) = show e1 ++ " " ++ show op ++ " " ++ show e2
    show (UnOp op e) = show op ++ " " ++ show e
    show (Cons e1 e2) = show e1 ++ " :: " ++ show e2
    show (AlgCons n le) = n ++ " of (" ++ intercalate ", " (map show le) 
        ++ ")"
    show (Case n l) = "match " ++ n ++ " with { " ++ 
        intercalate "; " (map (\(p, _, e) -> 
            "case " ++ show p ++ " -> " ++ show e) l) ++ " }"

instance Show Pattern where
    show (PConst lit) = show lit
    show (PVar n) = n
    show p@(PCons _ _) = case p of
        PCons p1 (PConst LNil) -> "[" ++ showLeftList p1 ++ "]"
        PCons p1 p2 -> "[" ++ showLeftList p1 ++ ", " ++ showRightList p2 ++ "]"
        where
            showLeftList p = case p of
                PCons p1 (PConst LNil) -> "[" ++ showLeftList p1 ++ "]"
                PCons p1 p2 -> "[" ++ showLeftList p1 ++ ", " 
                    ++ showRightList p2 ++ "]"
                _ -> show p
            showRightList p = case p of
                PCons p1 (PConst LNil) -> showLeftList p1
                PCons p1 p2 -> showLeftList p1 ++ ", " ++ showRightList p2
                (PConst LNil) -> ""
                _ -> "?"

instance Show Lit where
    show lit = case lit of
        LInt i  -> show i
        LBool b -> show b
        LNil    -> "[]"

instance Show BinOp where
    show op = case op of
        OpAdd -> "+"
        OpMul -> "*"
        OpSub -> "-"
        OpDiv -> "/"
        OpAnd -> "and"
        OpOr  -> "or"
        OpEq  -> "=="
        OpLT  -> "<"

instance Show UnOp where
    show op = case op of
        OpNeg -> "-"
        OpNot -> "not"

instance Show Type where
    show t = case t of
        TInt -> "Int"
        TBool -> "Bool"
        TFun TInt TInt -> "Int -> Int"
        TFun TBool TBool -> "Bool -> Bool"
        TFun TInt TBool -> "Int -> Bool"
        TFun TBool TInt -> "Bool -> Int"
        TFun TInt t2 -> "Int -> (" ++ show t2 ++ ")"
        TFun TBool t2 -> "Bool -> (" ++ show t2 ++ ")"
        TFun t1 TInt -> "(" ++ show t1 ++ ") -> Int"
        TFun t1 TBool -> "(" ++ show t1 ++ ") -> Bool"
        TFun t1 t2 -> "(" ++ show t1 ++ ") -> " ++ show t2
        TVar s -> s
        TList t -> "[" ++ show t ++ "]"
        TAlg s -> s
        TPoly s -> "\'" ++ s
