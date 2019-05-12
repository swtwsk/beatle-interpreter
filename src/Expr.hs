module Expr(
    Name,
    Expr(..),
    Pattern(..),
    Lit(..),
    BinOp(..),
    UnOp(..),
    Type(..),
    Scheme(..),
    SchemeMap,
    GammaEnv(..),
    inferType,
    inferTypeEnv,
    checkType,
    generalize
) where

import Data.List (intercalate)
import qualified Data.Map as Map
import qualified Data.Set as Set

import Control.Monad.Except
import Control.Monad.State
import Data.Functor.Identity

type Name = String

data Expr = Var Name
          | Lam Pattern (Maybe Type) Expr
          | Lit Lit
          | App Expr Expr
          | Let Name Expr Expr
          | LetRec [(Name, Maybe Type, Expr)] Expr
          | If Expr Expr Expr
          | BinOp BinOp Expr Expr
          | UnOp UnOp Expr
          | Cons Expr Expr                   -- list
          | AlgCons Name [Expr]
          | Case Name [(Pattern, Maybe Type, Expr)]

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
          deriving (Eq)

----- TYPE INFERENCE -----
--  Heavily inspired by 'Algorithm W Step by Step' by Martin Grabmuller
--------------------------
data Scheme = Scheme [String] Type
type Subst = Map.Map String Type

class Types a where
    ftv   :: a -> Set.Set String -- returns free type variables in type expr
    apply :: Subst -> a -> a     -- applies substitution to type expr

instance Types Type where
    ftv (TInt)       = Set.empty
    ftv (TBool)      = Set.empty
    ftv (TFun t1 t2) = Set.union (ftv t1) (ftv t2)
    ftv (TVar n)     = Set.singleton n
    ftv (TList t)    = Set.empty
    ftv (TAlg alg)   = Set.empty

    apply s v@(TVar n)   = maybe v id $ Map.lookup n s
    apply s (TFun t1 t2) = TFun (apply s t1) (apply s t2)
    apply s t            = t

instance Types Scheme where
    ftv (Scheme vars t)     = (ftv t) `Set.difference` (Set.fromList vars)
    apply s (Scheme vars t) = Scheme vars (apply (foldr Map.delete s vars) t)

-- Generalization for lists
instance Types a => Types [a] where
    apply s = map (apply s)
    ftv l   = foldr Set.union Set.empty $ map ftv l

emptySubst :: Subst
emptySubst = Map.empty

composeSubst :: Subst -> Subst -> Subst
-- Substitute every bound variable from s2 with proper s1 substitution
-- and concatenate rest of s1 to it
composeSubst s1 s2 = (Map.map (apply s1) s2) `Map.union` s1

type SchemeMap = Map.Map String Scheme
newtype GammaEnv = GammaEnv SchemeMap
remove :: GammaEnv -> String -> GammaEnv
remove (GammaEnv env) var = GammaEnv $ Map.delete var env

instance Types GammaEnv where
    ftv (GammaEnv env)     = ftv (Map.elems env)
    apply s (GammaEnv env) = GammaEnv $ Map.map (apply s) env

-- abstracts a type over all type variables which are free in the type
-- but not free in the given type environment
generalize :: GammaEnv -> Type -> Scheme
generalize env t = Scheme vars t
    where vars = Set.toList (Set.difference (ftv t) (ftv env))

data TcState = TcState { _supply :: String
                       , _subst  :: Subst  }

type TCM a = StateT TcState (Except String) a

tcmFresh :: TCM Type
tcmFresh = do
    s <- get
    let c@(h:t) = _supply s
        next    = if h == 'z' then 'a':c else (succ h):t
    put s { _supply = next }
    return $ TVar c

runTCM :: TCM a -> Either String (a, TcState)
runTCM t = runExcept $ runStateT t initState
    where initState = TcState { _supply = "a", _subst = Map.empty }

-- replace all bound type variables in a type scheme with fresh type variables
instantiate :: Scheme -> TCM Type
instantiate (Scheme vars t) = do
    nvars <- mapM (\_ -> tcmFresh) vars
    let s = Map.fromList (zip vars nvars)
    return $ apply s t

unify :: Type -> Type -> TCM Subst
unify TInt TInt   = return emptySubst
unify TBool TBool = return emptySubst
unify (TList t1) (TList t2) = unify t1 t2
unify (TAlg a) (TAlg b) = throwError "Type: Unify of algs unimplemented"
unify (TVar a) b = varBind a b
unify a (TVar b) = varBind b a
unify (TFun l r) (TFun l' r') = do
    s1 <- unify l l'
    s2 <- unify (apply s1 r) (apply s1 r')
    return (s1 `composeSubst` s2)
unify t1 t2 = 
    throwError $ "Type: Types do not unify: " ++ show t1 ++ " and " ++ show t2

varBind :: String -> Type -> TCM Subst
varBind u t | t == TVar u = return emptySubst
            | u `Set.member` ftv t =
                throwError $ "Type: Occur check fails: " ++ u ++ " vs. " 
                ++ show t
            | otherwise = return (Map.singleton u t)

tiLit :: Lit -> TCM (Subst, Type)
tiLit l = do
    t <- case l of
        LInt _  -> return TInt
        LBool _ -> return TBool
        LNil    -> tcmFresh >>= return . TList
    return (emptySubst, t)

ti :: GammaEnv -> Expr -> TCM (Subst, Type)
ti (GammaEnv env) (Var n) = case Map.lookup n env of
    Nothing    -> throwError $ "Type: Unbound variable: " ++ n
    Just sigma -> do
        t <- instantiate sigma
        return (emptySubst, t)
ti env (Lam (PVar n) t e) = do
    tv <- maybe tcmFresh return t
    let GammaEnv env' = remove env n
        env'' = GammaEnv (env' `Map.union` (Map.singleton n (Scheme [] tv)))
    (s1, t1) <- ti env'' e
    return (s1, TFun (apply s1 tv) t1)
ti env (Lam (PConst k) t e) = do
    (sk, tk) <- tiLit k
    case t of
        Nothing -> ti env e
        Just t' -> unify tk t' >> ti env e
ti env (Lam (PCons p1 p2) t0 e) = throwError "Type: PCons unimplemented"
ti env (Lit l) = tiLit l
ti env (App e1 e2) = do
    tv <- tcmFresh
    (s1, t1) <- ti env e1
    (s2, t2) <- ti (apply s1 env) e2
    s3 <- unify (apply s2 t1) (TFun t2 tv)
    return (s3 `composeSubst` s2 `composeSubst` s1, apply s3 tv)
ti env (Let x e1 e2) = do
    (s1, t1) <- ti env e1
    let GammaEnv env' = remove env x
        t' = generalize (apply s1 env) t1
        env'' = GammaEnv (Map.insert x t' env')
    (s2, t2) <- ti (apply s1 env'') e2
    return (s1 `composeSubst` s2, t2)
-- LetRec [(Pattern, Type, Expr)] Expr
ti env (LetRec lp e) = throwError "Type: Recursion unimplemented yet"
ti env (If c e1 e2) = throwError "Type: If unimplemented yet"
ti env (BinOp op e1 e2) = throwError "Type: BinOp unimplemented yet"
ti env (UnOp op e) = throwError "Type: UnOp unimplemented yet"
ti env (Cons e1 e2) = throwError "Type: Cons unimplemented yet"
ti env (AlgCons n le) = throwError "Type: AlgCons unimplemented yet"
-- lp :: [(Pattern, Type, Expr)]
ti env (Case n lp) = throwError "Type: Case unimplemented yet"

typeInference :: Map.Map String Scheme -> Expr -> TCM Type
typeInference env e = do
    (s, t) <- ti (GammaEnv env) e
    return (apply s t)

-- todo: potrzebny mi TcState XD
inferType :: Expr -> Either String Type
inferType e = do
    (res, _) <- runTCM (typeInference Map.empty e)
    return res

inferTypeEnv :: SchemeMap -> Expr -> Either String Type
inferTypeEnv sm e = do
    (res, _) <- runTCM (typeInference sm e)
    return res

checkType :: SchemeMap -> Expr -> Type -> Either String Type
checkType sm e t = do
    (res, _) <- runTCM $ do
        t' <- typeInference sm e
        unify t t'
        return t
    return res

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
