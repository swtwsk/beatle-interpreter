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
    TypeName,
    TypeDef(..),
    AlgTypeMap,
    ConsMap,
    Arity(..),
    inferType,
    inferTypeRec,
    checkType,
    generalize
) where

import Data.List (intercalate)
import qualified Data.List as List
import qualified Data.Map as Map
import qualified Data.Set as Set

import Control.Monad.Except
import Control.Monad.State
import Data.Functor.Identity

type Name = String

data Expr = Var Name
          | Lam Pattern Expr
          | Lit Lit
          | App Expr Expr
          | Let Name Expr Expr
          | LetRec [(Name, Expr)] Expr
          | If Expr Expr Expr
          | BinOp BinOp Expr Expr
          | UnOp UnOp Expr
          | Cons Expr Expr                   -- list
          | AlgCons Name [Expr]
          | Case Name [(Pattern, Expr)]
          | Typed Expr Type

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
          | TAlg String  -- placeholder type
          | TAlgT String [Type]
          deriving (Eq)

type TypeName = String
data TypeDef = TypeDef { _polys   :: [Type]
                       , _consdef :: [(Name, [Type])] } deriving (Show)
type AlgTypeMap = Map.Map TypeName TypeDef
type ConsMap = Map.Map Name TypeName

class Arity a where
    arity :: a -> Int

instance Arity Expr where
    arity (Cons _ (Lit LNil)) = 1
    arity (Cons _ e2) = 1 + arity e2
    arity _ = 0

instance Arity Pattern where
    arity (PCons _ p2) = 1 + arity p2
    arity (PVar _) = 1
    arity (PConst _) = 1

----- TYPE INFERENCE -----
--  Heavily inspired by 'Algorithm W Step by Step' by Martin Grabmuller
--------------------------
data Scheme = Scheme [String] Type deriving (Show)
type Subst = Map.Map String Type

class Types a where
    ftv   :: a -> Set.Set String -- returns free type variables in type expr
    apply :: Subst -> a -> a     -- applies substitution to type expr

instance Types Type where
    ftv (TInt)        = Set.empty
    ftv (TBool)       = Set.empty
    ftv (TFun t1 t2)  = Set.union (ftv t1) (ftv t2)
    ftv (TVar n)      = Set.singleton n
    ftv (TList t)     = Set.empty
    ftv (TAlgT alg t) = foldr (\t acc -> Set.union (ftv t) acc) Set.empty t

    apply s v@(TVar n)    = maybe v id $ Map.lookup n s
    apply s (TFun t1 t2)  = TFun (apply s t1) (apply s t2)
    apply s (TList t)     = TList (apply s t)
    apply s (TAlgT alg t) = TAlgT alg (map (apply s) t)
    apply s t             = t

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
newtype GammaEnv = GammaEnv SchemeMap deriving (Show)
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
                       , _subst  :: Subst
                       , _algs   :: AlgTypeMap
                       , _cons   :: ConsMap } deriving (Show)

type TCM a = StateT TcState (Except String) a

tcmFresh :: TCM Type
tcmFresh = do
    s <- get
    let c@(_:h:t) = _supply s
        next    = if h == 'z' then "\'a" ++ (h:t) else '\'':(succ h):t
    put s { _supply = next }
    return $ TVar c

runTCM :: (AlgTypeMap, ConsMap) -> TCM a -> Either String (a, TcState)
runTCM (alg, cons) t = runExcept $ runStateT t initState
    where initState = TcState { _supply = "\'a"
                              , _subst = Map.empty
                              , _algs = alg
                              , _cons = cons }

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
unify (TAlgT a at) (TAlgT b bt) | a == b && length at == length bt = do
    let zt = zip at bt
    types <- foldM foldf [emptySubst] zt
    return (foldl composeSubst emptySubst types)
    where
        foldf :: [Subst] -> (Type, Type) -> TCM [Subst]
        foldf s (t, t') = do
            let s1 = head s
            s2 <- unify (apply s1 t) (apply s1 t')
            return $ s2:s
unify (TVar a) b = varBind a b
unify a (TVar b) = varBind b a
unify (TFun l r) (TFun l' r') = do
    s1 <- unify l l'
    s2 <- unify (apply s1 r) (apply s1 r')
    return (s1 `composeSubst` s2)
unify a@(TAlg _) b = do
    ta <- getAlgType a
    unify ta b
unify a b@(TAlg _) = do
    tb <- getAlgType b
    unify a tb
unify t1 t2 = 
    throwError $ "Type: Types do not unify: " ++ show t1 ++ " and " ++ show t2

varBind :: String -> Type -> TCM Subst
varBind u t | t == TVar u = return emptySubst
            | u `Set.member` ftv t =
                throwError $ "Type: Occur check fails: " ++ u ++ " vs. " 
                ++ show t
            | otherwise = return (Map.singleton u t)

getAlgType :: Type -> TCM Type
getAlgType t@(TAlg alg) = do
    st <- get
    typedef <- case Map.lookup alg (_algs st) of
        Nothing -> throwError $ "Type: Unknown type " ++ show t
        Just td -> return td
    return $ TAlgT alg $ _polys typedef

class TypeCheck a where
    ti :: GammaEnv -> a -> TCM (Subst, Type)

instance TypeCheck Lit where
    ti _ l = do
        t <- case l of
            LInt _  -> return TInt
            LBool _ -> return TBool
            LNil    -> tcmFresh >>= return . TList
        return (emptySubst, t)

instance TypeCheck Expr where
    ti (GammaEnv env) (Var n) = case Map.lookup n env of
        Nothing -> throwError $ "Type: Unbound variable: " ++ n
        Just sigma -> do
            t <- instantiate sigma
            return (emptySubst, t)
    ti env (Lam (PVar n) e) = do
        tv <- tcmFresh
        let GammaEnv env' = remove env n
            env'' = GammaEnv (env' `Map.union` (Map.singleton n (Scheme [] tv)))
        (s1, t1) <- ti env'' e
        return (s1, TFun (apply s1 tv) t1)
    ti env (Lam (PConst k) e) = ti env k >> ti env e
    ti _ (Lam (PCons _ _) _) = throwError "Type: PCons unimplemented"
    ti env (Lit l) = ti env l
    ti env (App e1 e2) = do
        tv <- tcmFresh
        (s1, t1) <- ti env e1
        (s2, t2) <- ti (apply s1 env) e2
        s3 <- unify (apply s2 t1) (TFun t2 tv)
        return (s3 `composeSubst` s2 `composeSubst` s1, apply s3 tv)
    ti env (Let x e1 e2) = do
        tv <- tcmFresh
        (s1, t1) <- ti env e1
        s1' <- unify t1 tv
        let s1'' = s1' `composeSubst` s1
        let GammaEnv env' = remove env x
            t' = generalize (apply s1'' env) t1
            env'' = GammaEnv (Map.insert x t' env')
        (s2, t2) <- ti (apply s1'' env'') e2
        return (s1'' `composeSubst` s2, t2)
    ti env (LetRec l e) = do
        (s1, t1, env') <- typeRec env l
        let xs = map (\(n, _) -> n) l
            GammaEnv env2' = foldr (\x env -> remove env x) env' xs
            t' = generalize (apply s1 env) t1
            env2'' = GammaEnv $ foldr (\x env -> Map.insert x t' env) env2' xs
        (s2, t2) <- ti (apply s1 env2'') e
        return (s1 `composeSubst` s2, t2)
    ti env (If c e1 e2) = do
        tv1 <- tcmFresh
        tc' <- tcmFresh
        (sc, tc) <- ti env c
        sc' <- unify (TFun TBool (TFun tv1 (TFun tv1 tv1))) (TFun tc tc')
        let sc'' = sc' `composeSubst` sc
            tc'' = apply sc' tc'
        (s1, t1) <- ti (apply sc'' env) e1
        t1' <- tcmFresh
        s1' <- unify (apply s1 tc'') (TFun t1 t1')
        let s1'' = s1' `composeSubst` s1 `composeSubst` sc''
            t1'' = apply s1' t1'
        (s2, t2) <- ti (apply s1'' env) e2
        t2' <- tcmFresh
        s2' <- unify (apply s2 t1'') (TFun t2 t2')
        return (s2' `composeSubst` s2 `composeSubst` s1'', apply s2' t2')
    ti env (BinOp op e1 e2) = case op of
        OpAdd -> checkBinOpType TInt
        OpMul -> checkBinOpType TInt
        OpSub -> checkBinOpType TInt
        OpDiv -> checkBinOpType TInt
        OpAnd -> checkBinOpType TBool
        OpOr  -> checkBinOpType TBool
        OpEq  -> do
            tv <- tcmFresh
            (s, _) <- checkBinOpType tv
            return (s, TBool)
        OpLT  -> checkBinOpType TInt >>= \(s, _) -> return (s, TBool)
        where
            checkBinOpType :: Type -> TCM (Subst, Type)
            checkBinOpType t = do
                (s1, t1) <- ti env e1
                s1u      <- unify t1 t  -- s1 = { t1: t }
                let s' = s1u `composeSubst` s1
                (s2, t2) <- ti (apply s' env) e2
                s3       <- unify t2 t
                let s = s3 `composeSubst` s2 `composeSubst` s'
                return (s, t)
    ti env (UnOp op e) = case op of
        OpNeg -> checkUnOpType TInt
        OpNot -> checkUnOpType TBool
        where
            checkUnOpType :: Type -> TCM (Subst, Type)
            checkUnOpType t = do
                (s1, t1) <- ti env e
                s2 <- unify t1 t
                return (s2 `composeSubst` s1, t) 
    ti env (Cons e1 e2) = do
        (s1, t1) <- ti env e1
        (s2, t2) <- ti (apply s1 env) e2
        s3 <- unify (apply s2 (TList t1)) t2
        return (s3 `composeSubst` s2 `composeSubst` s1, apply s3 t2)
    ti env (AlgCons n le) = do
        st <- get
        typename <- maybe (throwError consErr) return $
            Map.lookup n $ _cons st
        typedef <- maybe (throwError $ typeErr typename) return $
            Map.lookup typename $ _algs st
        t <- getAlgType (TAlg typename)
        ctypes <- maybe (throwError consErr) return $
            List.lookup n $ _consdef typedef
        let clen = length ctypes
            elen = length le
        _ <- if clen /= elen then throwError $ countErr clen elen else return ()
        ste <- foldM foldExp [] le
        let s  = foldl composeSubst emptySubst $ map fst ste
            ts = zip ctypes $ map snd ste
        s' <- mapM (\(tc, te) -> unify (apply s tc) te) ts
        let s'' = foldr composeSubst emptySubst s'
        return (s'', apply s'' t)
        where
            consErr = "Type: Unknown type constructor " ++ n
            typeErr t = "Type: Unknown type " ++ show t
            countErr c1 c2 = "Type: The constructor " ++ n ++ " expects " ++
                show c1 ++ " argument(s),\nbut is applied here to " ++
                show c2 ++ " argument(s)"
            foldExp :: [(Subst, Type)] -> Expr -> TCM [(Subst, Type)]
            foldExp l@((s,_):_) e = do
                st <- ti (apply s env) e
                return $ st:l
            foldExp [] e = do
                st <- ti env e
                return [st]

    ti env (Case n l) = do
        (sn, tn)       <- ti env (Var n)
        tl <- mapM (caseCheckType (apply sn env)) l
        (s', tp, te) <- foldM unifyTypes (head tl) (tail tl)
        s1 <- unify (apply s' tn) tp
        return (s1 `composeSubst` s' `composeSubst` sn, apply s1 te)
    ti env (Typed e t) = do
        (s1, t1) <- ti env e
        s2 <- unify t1 t
        return (s2 `composeSubst` s1, apply s2 t1)

caseCheckType :: GammaEnv -> (Pattern, Expr) -> TCM (Subst, Type, Type)
caseCheckType env (PVar n, e) = do
    tv <- tcmFresh
    let GammaEnv env' = remove env n
        env'' = GammaEnv (env' `Map.union` (Map.singleton n (Scheme [] tv)))
    (sp, tp) <- ti env'' (PVar n)
    (se, te) <- ti (apply sp env'') e
    return (se `composeSubst` sp, apply se tp, apply se te)
caseCheckType env (PConst k, e) = do
    (_, tk) <- ti env k
    (s, te) <- ti env e
    return (s, tk, te)
caseCheckType env (PCons p1 p2, e) = do
    env' <- patEnv p1 Nothing env
    (s1, t1) <- ti env' p1
    env'' <- patEnv p2 Nothing env'
    (s2, t2) <- ti (apply s1 env'') p2
    let s = s2 `composeSubst` s1
    s3 <- unify (apply s (TList t1)) t2
    let s' = s3 `composeSubst` s
    (se, te) <- ti (apply s' env'') e
    let s'' = se `composeSubst` s'
    return (se `composeSubst` s', apply s'' t2, apply s'' te)

typeRec :: GammaEnv -> [(Name, Expr)] -> TCM (Subst, Type, GammaEnv)
typeRec env l = do
    tv <- tcmFresh
    let tfix = 
            TFun (foldr (\_ acc -> TFun tv acc) (TFun tv tv) (tail l)) tv
        GammaEnv env' = remove env "fix"
        env'' = GammaEnv $ 
            env' `Map.union` (Map.singleton "fix" (Scheme [] tfix))
        yfs = map (\(n, e) -> ("_y_" ++ n, transLambda l e)) l
        ys  = 
            map (\(n, _) -> transYLambda yfs (App (Var "fix") (Var n))) yfs
    ss <- mapM (ti env'') ys
    let s = foldr (\(s, _) acc -> s `composeSubst` acc) Map.empty ss
    s1 <- foldM (unificator tv) s ss
    return (s1, apply s1 tv, env'')
    where
        transLambda ((n,_):t) e = Lam (PVar n) $ transLambda t e
        transLambda [] e = e
        transYLambda ((n,e):t) e' = Let n e (transYLambda t e')
        transYLambda [] e' = e'
        unificator tv s (_, t) = do
            unified <- unify (apply s tv) t
            return $ unified `composeSubst` s

patEnv :: Pattern -> Maybe Type -> GammaEnv -> TCM GammaEnv
patEnv (PVar n) t env = do
    tv <- maybe tcmFresh return t
    let GammaEnv env' = remove env n
    return $ GammaEnv $ env' `Map.union` (Map.singleton n (Scheme [] tv))
patEnv (PConst k) t env = do
    tv <- maybe tcmFresh return t
    (sk, tk) <- ti env (PConst k)
    t' <- unify (apply sk tv) tk
    return env
patEnv (PCons p1 p2) t env = do
    tv <- case t of
        Nothing -> return Nothing
        Just (TList t') -> return $ Just t'
        Just _ -> throwError "Type: Pattern was expected to be of list type"
    (GammaEnv env1) <- patEnv p1 tv env
    (GammaEnv env2) <- patEnv p2 t env
    return $ GammaEnv $ env2 `Map.union` env1

unifyTypes :: (Subst, Type, Type) -> (Subst, Type, Type) 
    -> TCM (Subst, Type, Type)
unifyTypes (s1, tp1, te1) (s2, tp2, te2) = do
    let s' = s2 `composeSubst` s1
    sp3 <- unify (apply s' tp2) tp1
    let s'' = sp3 `composeSubst` s'
    se3 <- unify (apply s'' te2) te1
    return (se3 `composeSubst` s'', apply se3 tp1, apply se3 te1)

instance TypeCheck Pattern where
    ti env (PConst k) = ti env k
    ti (GammaEnv env) (PVar n) = case Map.lookup n env of
        Nothing    -> throwError $ "Type: Unbound variable: " ++ n
        Just sigma -> do
            t <- instantiate sigma
            return (emptySubst, t)
    ti env (PCons p1 p2) = do
        tv  <- tcmFresh
        tv1 <- tcmFresh
        (s1, t1) <- ti env p1
        s1' <- unify (TFun tv (TFun (TList tv) (TList tv))) (TFun t1 tv1)
        let s1'' = s1' `composeSubst` s1
            t1'' = apply s1' tv1
        (s2, t2) <- ti (apply s1'' env) p2
        tv2 <- tcmFresh
        s2' <- unify (apply s2 t1'') (TFun t2 tv2)
        return (s2' `composeSubst` s2 `composeSubst` s1'', apply s2' tv2)

typeInference :: Map.Map String Scheme -> Expr -> TCM Type
typeInference env e = do
    (s, t) <- ti (GammaEnv env) e
    return (apply s t)

inferType :: SchemeMap -> (AlgTypeMap, ConsMap) -> Expr -> Either String Type
inferType sm ac e = do
    (res, _) <- runTCM ac (typeInference sm e)
    return res

inferTypeRec :: SchemeMap -> (AlgTypeMap, ConsMap) -> [(Name, Expr)] 
    -> Either String Type
inferTypeRec sm ac l = do
    ((_, res, _), _) <- runTCM ac (typeRec (GammaEnv sm) l)
    return res

checkType :: SchemeMap -> (AlgTypeMap, ConsMap) -> Expr -> Type 
    -> Either String Type
checkType sm ac e t = do
    (res, _) <- runTCM ac $ do
        (s1, t1) <- ti (GammaEnv sm) e
        s <- unify t t1
        return (apply (s1 `composeSubst` s) t1)
    return res

----- SHOW INSTANCES -----
instance Show Expr where
    show (Var n) = n
    show (Lam n e) = "λ" ++ show n ++ " -> " ++ show e
    show (Lit l) = show l
    show (App e1 e2) = "(" ++ show e1 ++ ")(" ++ show e2 ++ ")"
    show (Let n e1 e2) = "let " ++ show n ++ " = " ++ show e1 ++ " in " ++ show e2
    show (LetRec l e) = 
        "letrec " ++ 
        intercalate " also " (map (\(n, e') -> show n ++ " = " 
        ++ show e') l) ++ " in " ++ show e
    show (If cond e1 e2) = "if " ++ show cond ++ " then " ++ show e1 ++ 
        " else " ++ show e2
    show (BinOp op e1 e2) = show e1 ++ " " ++ show op ++ " " ++ show e2
    show (UnOp op e) = show op ++ " " ++ show e
    show (Cons e1 e2) = show e1 ++ " :: " ++ show e2
    show (AlgCons n le) = n ++ " of (" ++ intercalate ", " (map show le) 
        ++ ")"
    show (Case n l) = "match " ++ n ++ " with { " ++ 
        intercalate "; " (map (\(p, e) -> 
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
        TAlg s -> "\"" ++ s ++ "\""
        TAlgT s ts -> s ++ " " ++ intercalate " " (map show ts)
