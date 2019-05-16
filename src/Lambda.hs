module Lambda (
    Name,
    Lit(..),
    BinOp(..),
    UnOp(..),
    Value(..),
    ValMap,
    Env(..),
    eval,
    evalCheck,
    typeCheck,
    fixed,
    emptyEnv
) where

import Control.Monad
import Control.Monad.Reader
import Control.Monad.Except

import Data.Maybe
import qualified Data.Map as Map

import Expr
import Errors
import TypeInference
import Values

type EvalReader = ReaderT Env (Except InterpreterError) Value

fixed :: Env -> [(Name, Expr)] -> [(Name, Value)]
fixed env l = map (\(n, _) -> (n, VFixed n l env)) l

eval :: Env -> Expr -> Either InterpreterError (Value, Type)
eval env expr = do
    let schemes = _schemes env
    typed <- inferType schemes expr
    evaled <- runExcept $ runReaderT (eval' expr) env
    return (evaled, typed)

evalCheck :: Env -> Expr -> Type -> Either InterpreterError (Value, Type)
evalCheck env expr t = do
    let schemes = _schemes env
    typed <- checkType schemes expr t
    evaled <- runExcept $ runReaderT (eval' expr) env
    return (evaled, typed)

typeCheck :: Env -> Expr -> Maybe Type -> Either InterpreterError Type
typeCheck env expr t = do
    let tv = fromMaybe (TVar "a") t
        schemes = _schemes env
    either throwError return $ checkType schemes expr tv

eval' :: Expr -> EvalReader
eval' (Lit l) = case l of
    LInt i -> return (VInt i)
    LBool b -> return (VBool b)
    LNil -> return VNil

eval' (Var var) = do
    env <- ask
    let vmap = _values env
    maybe (throwError . EE $ EUnboundVal var) return $ Map.lookup var vmap

eval' (Lam n e) = do
    env <- ask
    return (VClos n e env)

eval' (Case var l) = do
    env <- ask
    val <- eval' (Var var)
    either readApplyErr return $ apply (VCase var l env) val env

eval' (Let n e1 e2) = do
    env <- ask
    let vmap = _values env
    eval1 <- either throwError return $ eval env e1
    let (eval1', _) = eval1
    let nmap = Map.insert n eval1' vmap
    either throwError return $ ev (Map.union nmap vmap) env
    where
        ev :: ValMap -> Env -> Either InterpreterError Value
        ev vmap env = runExcept (runReaderT (eval' e2) (env {_values=vmap}))

eval' (LetRec l e) = do
    env <- ask
    let vmap = _values env
    let prepVals = fixed env l
    let nmap = Map.fromList prepVals
    either throwError return $ ev (env {_values=Map.union nmap vmap})
    where
        ev :: Env -> Either InterpreterError Value
        ev env = runExcept $ runReaderT (eval' e) env

eval' (App e1 e2) = do
    env <- ask
    eval1 <- eval' e1
    eval2 <- eval' e2
    either readApplyErr return $ apply eval1 eval2 env

eval' (If cond e1 e2) = do
    c <- eval' cond
    case c of
        VBool b -> if b then eval' e1 else eval' e2
        _ -> throwError UnexpectedError

eval' (BinOp op e1 e2) = do
    eval1 <- eval' e1
    eval2 <- eval' e2
    either throwError return $ binOp eval1 eval2 op
    where
        binOp :: Value -> Value -> BinOp -> Either InterpreterError Value
        binOp (VInt a) (VInt b) OpAdd = return . VInt $ a + b
        binOp (VInt a) (VInt b) OpMul = return . VInt $ a * b
        binOp (VInt a) (VInt b) OpSub = return . VInt $ a - b
        binOp (VInt a) (VInt 0) OpDiv = throwError $ EE EDivisionByZero
        binOp (VInt a) (VInt b) OpDiv = return . VInt $ a `div` b
        binOp (VBool a) (VBool b) OpAnd = return . VBool $ a && b
        binOp (VBool a) (VBool b) OpOr  = return . VBool $ a || b
        binOp (VBool a) (VBool b) OpEq  = return . VBool $ a == b
        binOp (VInt a) (VInt b) OpEq    = return . VBool $ a == b
        binOp (VInt a) (VInt b) OpLT    = return . VBool $ a < b
        binOp _ _ OpEq  = throwError $ EE EEquality
        binOp _ _ _     = throwError UnexpectedError

eval' (UnOp op e) = do
    ev <- eval' e
    either throwError return $ unOp ev op
    where 
        unOp :: Value -> UnOp -> Either InterpreterError Value
        unOp (VInt v) OpNeg = return . VInt $ (-v)
        unOp (VBool b) OpNot = return . VBool $ not b
        unOp _ _ = throwError UnexpectedError

eval' (Cons e1 e2) = do
    eval1 <- eval' e1
    eval2 <- eval' e2
    return $ VCons eval1 eval2

eval' (Typed e _) = eval' e

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
apply (VClos p@(PCons p1 p2) e1 cenv) e2 env = do
    let arityp = arity p
        aritye = arity e2
    _ <- when (arityp > aritye) (Left MatchFail)
    e1' <- unpackp p arityp
    let e2'  = unpackv e2 arityp
        venv = Map.fromList $ zip e1' e2'
        nenv = (mergeEnv cenv env) {
            _values = Map.union venv $ _values cenv
        }
    either (Left . ApplyFail) return $ runExcept $ runReaderT (eval' e1) nenv
    where
        unpackp :: Pattern -> Int -> Either ApplyErr [Name]
        unpackp (PCons (PVar p1) p2) len = if len <= 1 then return [p1]
            else do { p2' <- unpackp p2 (len - 1); return $ p1 : p2'}
        unpackp (PVar p1) _ = return [p1]
        unpackp (PConst LNil) _ = return []
        unpackp _ _ = Left ForbiddenListPattern
        unpackv v@(VCons v1 v2) len = 
            if len > 1 then v1 : unpackv v2 (len - 1) else [v]
        unpackv VNil _ = [VNil]
        
apply (VFixed fn l cenv) e2 env = case found of
    (_, Lam (PConst k) e1):_ -> do
        k' <- either (Left . ApplyFail) return . 
            runExcept $ runReaderT (eval' (Lit k)) cenv
        let cond = case (k', e2) of (VInt i1, VInt i2) -> i1 == i2
                                    (VBool b1, VBool b2) -> b1 == b2
                                    (VNil, VNil) -> True
                                    _ -> False
        if cond then either (Left . ApplyFail) return .
            runExcept $ runReaderT (eval' e1) (nenv kmap) else Left MatchFail
    (_, Lam (PVar x) e1):_ -> either (Left . ApplyFail) return .
        runExcept $ runReaderT (eval' e1) (nenv $ nmap x)
    _ -> Left ExpressionNotAFunction
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
apply _ _ _ = Left ExpressionNotAFunction

readApplyErr :: ApplyErr -> EvalReader
readApplyErr ae = throwError . EE $ EApplyErr ae
