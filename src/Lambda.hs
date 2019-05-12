module Lambda (
    Name,
    Lit(..),
    BinOp(..),
    UnOp(..),
    Value(..),
    ValMap,
    ConsMap,
    AlgTypeMap,
    Env(..),
    eval,
    typeCheck,
    typeEqualCheck,
    fixed,
    emptyEnv
) where

import Control.Monad
import Control.Monad.Reader
import Control.Monad.Except

import qualified Data.Map as Map
import Data.List (intercalate)
import qualified Data.List as List

import Expr
import Utils
import Values

type TypeReader = ReaderT Env (Except String) Type
type EvalReader = ReaderT Env (Except String) Value

fixed :: Env -> [(Name, Maybe Type, Expr)] -> [(Name, (Value, Maybe Type))]
fixed env l = map (\(n, t, _) -> (n, (VFixed n l' env, t))) l
    where l' = map (\(n, _, e) -> (n, e)) l

eval :: Env -> Expr -> Either String (Value, Type)
eval env expr = do
    -- typed <- typeCheck env expr
    let schemes = _schemes env
    typed <- inferTypeEnv schemes expr
    evaled <- runExcept $ runReaderT (eval' expr) env
    return (evaled, typed)

typeCheck :: Env -> Expr -> Either String Type
typeCheck env expr = do
    let schemes = _schemes env
    -- runExcept $ runReaderT (inferTypeEnv schemes expr) env
    either throwError return $ inferTypeEnv schemes expr

typeEqualCheck :: Env -> Expr -> Type -> Either String Type
typeEqualCheck env expr t = do
    let schemes = _schemes env
    either throwError return $ checkType schemes expr t
    -- runExcept $ runReaderT (checkType expr t) env

eval' :: Expr -> EvalReader
eval' (Lit l) = case l of
    LInt i -> return (VInt i)
    LBool b -> return (VBool b)
    LNil -> return VNil

eval' (Var var) = do
    env <- ask
    let vmap = _values env
    maybe (throwError $ "Unbound value " ++ var) return (Map.lookup var vmap)

eval' (Lam n t e) = do
    env <- ask
    return (VClos n e env)

eval' (Case var l) = do
    env <- ask
    let l' = map (\(n, _, e) -> (n, e)) l
    val <- eval' (Var var)
    either readApplyErr return $ apply (VCase var l' env) val env
    where
        readApplyErr :: ApplyErr -> EvalReader
        readApplyErr (ApplyFail err) = throwError err
        readApplyErr MatchFail = throwError "Non-exhaustive pattern match"

eval' (Let n e1 e2) = do
    env <- ask
    let vmap = _values env
    eval1 <- either fail return $ eval env e1
    let (eval1', _) = eval1
    let nmap = Map.insert n eval1' vmap
    either throwError return $ ev (Map.union nmap vmap) env
    where
        ev :: ValMap -> Env -> Either String Value
        ev vmap env = runExcept (runReaderT (eval' e2) (env {_values=vmap}))

eval' (LetRec l e) = do
    env <- ask
    let vmap = _values env
    prepVals <- mapM (either throwError return . extractVar) $ fixed env l
    let nmap = Map.fromList prepVals
    either throwError return $ ev (env {_values=Map.union nmap vmap})
    where
        ev :: Env -> Either String Value
        ev env = runExcept $ runReaderT (eval' e) env
        extractVar :: (Name, (Value, Maybe Type)) -> Either String (Name, Value)
        extractVar (n, (v, _)) = pure (n, v)

eval' (App e1 e2) = do
    env <- ask
    eval1 <- eval' e1
    eval2 <- eval' e2
    either readApplyErr return $ apply eval1 eval2 env
    where
        readApplyErr :: ApplyErr -> EvalReader
        readApplyErr (ApplyFail err) = throwError err
        readApplyErr (MatchFail) = throwError "Non-exhaustive pattern match"

eval' (If cond e1 e2) = do
    c <- eval' cond
    case c of
        VBool b -> if b then eval' e1 else eval' e2
        _ -> throwError "Unexpected error"

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
        binOp (VBool a) (VBool b) OpAnd = return . VBool $ a && b
        binOp (VBool a) (VBool b) OpOr  = return . VBool $ a || b
        binOp (VBool a) (VBool b) OpEq  = return . VBool $ a == b
        binOp (VInt a) (VInt b) OpEq    = return . VBool $ a == b
        binOp (VInt a) (VInt b) OpLT    = return . VBool $ a < b
        binOp _ _ OpEq  = 
            throwError "Cannot test equality in types other than int and bool"
        binOp _ _ _     = throwError "Unexpected error"

eval' (UnOp op e) = do
    ev <- eval' e
    either throwError return $ unOp ev op
    where 
        unOp :: Value -> UnOp -> Either String Value
        unOp (VInt v) OpNeg = return . VInt $ (-v)
        unOp (VBool b) OpNot = return . VBool $ not b
        unOp _ _ = throwError "Unexpected error"

eval' (Cons e1 e2) = do
    eval1 <- eval' e1
    eval2 <- eval' e2
    return $ VCons eval1 eval2

eval' (AlgCons cname le) = do
    env <- ask
    let cmap = _constructors env
    c <- maybe (throwError $ "Unbound constructor " ++ cname) return $
         Map.lookup cname cmap
    let (count, tname) = c
    args <- mapM eval' le
    let arglen = length args
    if arglen == count then return $ VAlg cname tname args
    else throwError $ err cname count arglen
    where
        err :: String -> Int -> Int -> String
        err cname expected provided =
            "The constructor " ++ cname ++ " expects " ++ show expected 
            ++ " argument(s), but is applied to " 
            ++ show provided ++ " argument(s)"

data ApplyErr = ApplyFail String | MatchFail

apply :: Value -> Value -> Env -> Either ApplyErr Value
apply (VClos (PConst k) e1 cenv) e2 _ = do
    k' <- either (Left . ApplyFail) return . 
        runExcept $ runReaderT (eval' (Lit k)) cenv
    let cond = case (k', e2) of (VInt i1, VInt i2) -> i1 == i2
                                (VBool b1, VBool b2) -> b1 == b2
                                (VNil, VNil) -> True
                                _ -> False
    if cond then either (Left . ApplyFail) return $ 
        runExcept $ runReaderT (eval' e1) cenv else Left MatchFail
apply (VClos (PVar x) e1 cenv) e2 env =
    let nenv = (mergeEnv cenv env) {
        _values=Map.insert x e2 $ _values cenv
    } in either (Left . ApplyFail) return . 
        runExcept $ runReaderT (eval' e1) nenv
apply (VClos (PCons _ _) _ _) _ _ = 
    Left $ ApplyFail "Closure PCons: unimplemented"
apply (VFixed fn l cenv) e2 env = case found of
    (_, Lam (PConst k) _ e1):_ -> do
        k' <- either (Left . ApplyFail) return . 
            runExcept $ runReaderT (eval' (Lit k)) cenv
        let cond = case (k', e2) of (VInt i1, VInt i2) -> i1 == i2
                                    (VBool b1, VBool b2) -> b1 == b2
                                    (VNil, VNil) -> True
                                    _ -> False
        if cond then either (Left . ApplyFail) return .
            runExcept $ runReaderT (eval' e1) (nenv $ kmap) else Left MatchFail
    (_, Lam (PVar x) _ e1):_ -> either (Left . ApplyFail) return .
        runExcept $ runReaderT (eval' e1) (nenv $ nmap x)
    (_, Lam (PCons _ _) _ _):_ -> 
        Left $ ApplyFail "Closure PCons: unimplemented"
    _ -> Left $ ApplyFail "Expression is not a function; it cannot be applied"
    where
        found = filter (\(n, _) -> n == fn) l
        l' = map (\(n, _) -> (n, VFixed n l cenv)) l
        vmap = _values cenv
        kmap = Map.union (Map.fromList l') vmap
        nmap x = Map.insert x e2 kmap
        nenv vals = (mergeEnv cenv env) { _values = vals }
apply (VCase var l cenv) e2 env = workL l
    where 
        workL :: [(Pattern, Expr)] -> Either ApplyErr Value
        workL ((p, e):t) = case apply (VClos p e cenv) e2 env of
            Left MatchFail -> workL t
            err@(Left _) -> err
            val@(Right _) -> val
        workL [] = Left MatchFail
apply _ _ _ = 
    Left $ ApplyFail "Expression is not a function; it cannot be applied"

-- typeOf :: Expr -> TypeReader
-- typeOf (Lit l) = case l of
--     LInt i -> return TInt
--     LBool b -> return TBool
--     LNil -> throwError "Type: list type unimplemented"
-- typeOf (Var var) = do
--     env <- ask
--     let tenv = _types env
--     case Map.lookup var tenv of
--         Nothing -> throwError $ "Type: Unbound value " ++ var
--         Just t -> return t
-- typeOf (Lam (PVar n) t0 e) = do
--     env <- ask
--     let ntenv = Map.insert n t0 $ _types env
--     t1 <- local (\env -> env {_types = ntenv}) (typeOf e)
--     return $ TFun t0 t1
-- typeOf (Lam (PConst k) t0 e) = checkType (Lit k) t0 >> typeOf e
-- typeOf (Lam (PCons p1 p2) t0 e) = throwError "Type error: PCons unimplemented"
-- typeOf (App e1 e2) = do
--     t1 <- typeOf e1
--     case t1 of
--         TFun tl tr -> checkType e2 tl >> return tr
--         _ -> throwError $ "Type error: " ++ show e1 ++ " is of type " ++ show t1
-- typeOf (Let (PVar n) e1 e2) = do
--     t1 <- typeOf e1
--     env <- ask
--     let ntenv = Map.insert n t1 $ _types env
--     local (\env -> env {_types = ntenv}) (typeOf e2)
-- typeOf (Let {}) = throwError "Type: Patterns in let unimplemented"
-- typeOf (LetRec l e) = do
--     env <- ask
--     tlist <- mapM (either throwError return . extractVar) l
--     let nte = Map.union (Map.fromList tlist) $ _types env
--     tl <- mapM (\(_, _, e') -> local (\env -> env {_types = nte}) (typeOf e')) l
--     nlist <- mapM (either throwError return . extractNames) l
--     let typeMap = Map.fromList $ zip nlist tl
--     local (\env -> env {_types = typeMap}) (typeOf e)
--     where
--         extractVar :: (Pattern, Type, Expr) -> Either String (Name, Type)
--         extractVar (PVar n, t, _) = pure (n, t)
--         extractVar _ = Left "Patterns in letrecs: Unimplemented"
--         extractNames (PVar n, _, _) = pure n
--         extractNames _ = Left "Patterns in letrecs: Unimplemented"
-- typeOf (If cond e1 e2) = do
--     tc <- checkType cond TBool
--     t1 <- typeOf e1
--     checkType e2 t1 >> return t1
-- typeOf (BinOp op e1 e2) = case op of
--     OpAdd -> checkBinOpType e1 e2 TInt
--     OpMul -> checkBinOpType e1 e2 TInt
--     OpSub -> checkBinOpType e1 e2 TInt
--     OpDiv -> checkBinOpType e1 e2 TInt
--     OpAnd -> checkBinOpType e1 e2 TBool
--     OpOr  -> checkBinOpType e1 e2 TBool
--     OpEq  -> 
--         (checkBinOpType e1 e2 TInt >> return TBool) `catchError` (\_ -> checkBinOpType e1 e2 TBool)
--     OpLT  -> checkBinOpType e1 e2 TInt
--     where
--         checkBinOpType :: Expr -> Expr -> Type -> TypeReader
--         checkBinOpType e1 e2 t = checkType e1 t >> checkType e2 t           

-- typeOf (UnOp op e) = case op of
--     OpNeg -> checkType e TInt
--     OpNot -> checkType e TBool
-- typeOf (Cons e1 e2) = do
--     t1 <- typeOf e1
--     let listType = TList t1
--     case e2 of
--         Lit LNil -> return listType
--         _ -> checkType e2 listType
-- typeOf (AlgCons cname le) = do
--     env <- ask
--     c <- maybe (throwError $ "Unbound constructor " ++ cname) return $
--         Map.lookup cname $ _constructors env
--     let (_, typename) = c
--     algtype <- case Map.lookup typename $ _algtypes env of
--         Nothing -> throwError $ "Unknown type " ++ typename 
--             ++ " of constructor " ++ cname
--         Just a -> return a
--     types <- case List.lookup cname $ consdef algtype of
--         Nothing -> throwError $ "Constructor " ++ cname 
--             ++ " was said to be of type " ++ typename ++ " but is not"
--         Just tlist -> return tlist
--     _ <- zipWithM_ checkType le types
--     return $ TAlg typename
-- typeOf (Case n []) = throwError "Type: Empty pattern match"  -- impossible
-- typeOf (Case n ((p, t0, e):t)) = do
--     env <- ask
--     let ntenv = patToEnv p t0
--     t1 <- local (\env -> ntenv env) (typeOf e)
--     _  <- mapM_ (\(p, t, e) -> local (\e -> patToEnv p t e) (checkType e t0)) t
--     return t1
--     where
--         patToEnv :: Pattern -> Type -> Env -> Env
--         patToEnv (PConst _) _ env = env
--         patToEnv (PCons {}) _ env = env
--         patToEnv (PVar n) t env = env {_types = Map.insert n t $ _types env}

-- checkType :: Expr -> Type -> TypeReader
-- checkType e t = do
--     t' <- typeOf e
--     if t == t' then return t 
--     else throwError $ "Type error: " ++ show e ++ " should be " ++ show t 
--         ++ " but is of type " ++ show t'

instance Show Value where
    show (VInt i) = show i 
    show (VBool b) = show b
    show (VClos n e _) = "<fun>"
    show (VFixed _ l _) = "<fun>"
    show v@(VCons _ _) = case v of
        VCons v1 VNil -> "[" ++ showLeftList v1 ++ "]"
        VCons v1 v2 -> "[" ++ showLeftList v1 ++ ", " ++ showRightList v2 ++ "]"
        where
            showLeftList v = case v of
                VClos {} -> "<fun>"
                VFixed {} -> "<fun>"
                VCons v1 VNil -> "[" ++ showLeftList v1 ++ "]"
                VCons v1 v2 -> "[" ++ showLeftList v1 ++ ", " 
                    ++ showRightList v2 ++ "]"
                _ -> show v
            showRightList v = case v of
                VCons v1 VNil -> showLeftList v1
                VCons v1 v2 -> showLeftList v1 ++ ", " ++ showRightList v2
                VNil -> ""
                _ -> "?"
    show VNil = "[]"
    show (VAlg name _ lv) = name ++ "(" ++ List.intercalate ", " (map show lv) 
        ++ ")"
    show (VCase n l _) = "<pattern-match>"
