module Lambda (
    Name,
    Expr(..),
    Lit(..),
    BinOp(..),
    UnOp(..),
    Value(..),
    TypeDef(..),
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

import Types
import Utils

type Name = String

data Expr = Var Name
          | Lam Name Type Expr
          | Lit Lit
          | App Expr Expr
          | Let Name Expr Expr
          | LetRec [(Name, Type, Expr)] Expr
          | If Expr Expr Expr
          | BinOp BinOp Expr Expr
          | UnOp UnOp Expr
          | Cons Expr Expr
          | AlgCons Name [Expr]

data Lit = LInt Integer
         | LBool Bool
         | LNil

data BinOp = OpAdd | OpMul | OpSub | OpDiv | OpAnd | OpOr | OpEq | OpLT
data UnOp = OpNeg | OpNot

data Value = VInt Integer 
           | VBool Bool 
           | VClos Name Expr Env
           | VFixed Name [(Name, Expr)] Env
           | VCons Value Value
           | VNil
           | VAlg Name TypeName [Value]

data TypeDef = TypeDef { polynames :: [Name], consdef :: [(Name, [Type])] }

type ValMap = Map.Map Name Value
type TypeName = String
type ConsMap = Map.Map Name (Int, TypeName)
type AlgTypeMap = Map.Map TypeName TypeDef
type TypeMap = Map.Map TypeName Type

data Env = Env 
    { _values :: ValMap
    , _constructors :: ConsMap
    , _algtypes  :: AlgTypeMap
    , _types :: TypeMap }

emptyEnv :: Env
emptyEnv = Env { _values = Map.empty
               , _constructors = Map.empty
               , _algtypes = Map.empty
               , _types = Map.empty }

mergeEnv :: Env -> Env -> Env
mergeEnv env1 env2 =
    Env { _values = Map.union (_values env1) (_values env2) 
        , _constructors = Map.union (_constructors env1) (_constructors env2)
        , _algtypes = Map.union (_algtypes env1) (_algtypes env2) 
        , _types = Map.union (_types env1) (_types env2) }

type TypeReader = ReaderT Env (Except String) Type
type EvalReader = ReaderT Env (Except String) Value

fixed :: Env -> [(Name, Type, Expr)] -> [(Name, (Value, Type))]
fixed env l = map (\(n, t, _) -> (n, (VFixed n l' env, t))) l
    where l' = map (\(n, _, e) -> (n, e)) l

eval :: Env -> Expr -> Either String (Value, Type)
eval env expr = do
    typed <- typeCheck env expr
    evaled <- runExcept $ runReaderT (eval' expr) env
    return (evaled, typed)

typeCheck :: Env -> Expr -> Either String Type
typeCheck env expr = runExcept $ runReaderT (typeOf expr) env

typeEqualCheck :: Env -> Expr -> Type -> Either String Type
typeEqualCheck env expr t = runExcept $ runReaderT (checkType expr t) env

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
    let nmap = Map.fromList $ map (\(n, (v, _)) -> (n, v)) $ fixed env l
    either throwError return $ ev (env {_values=Map.union nmap vmap})
    where
        ev :: Env -> Either String Value
        ev env = runExcept $ runReaderT (eval' e) env

eval' (App e1 e2) = do
    env <- ask
    eval1 <- eval' e1
    eval2 <- eval' e2
    either throwError return $ apply eval1 eval2 env
    where
        apply (VClos x e1 cenv) e2 env =
            let nenv = (mergeEnv cenv env) {
                _values=Map.insert x e2 $ _values cenv
            } in runExcept $ runReaderT (eval' e1) nenv
        apply (VFixed fn l cenv) e2 env = case found of
            (_, Lam x _ e1):_ -> 
                runExcept $ runReaderT (eval' e1) (nenv $ nmap x)
            _ -> throwError "Expression is not a function; it cannot be applied"
            where
                found = filter (\(n, _) -> n == fn) l
                l' = map (\(n, _) -> (n, VFixed n l cenv)) l
                vmap = _values cenv
                nmap x = Map.insert x e2 (Map.union (Map.fromList l') vmap)
                nenv vals = (mergeEnv cenv env) { _values = vals }
        apply _ _ _ = 
            throwError "Expression is not a function; it cannot be applied"

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
        binOp _ _ OpEq  = throwError boolTypeError
        binOp _ _ OpLT  = throwError boolTypeError
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

typeError :: String -> String
typeError t = "Expression was expected of type " ++ t

intTypeError :: String
intTypeError = typeError "int"

boolTypeError :: String
boolTypeError = typeError "bool"

typeOf :: Expr -> TypeReader
typeOf (Lit l) = case l of
    LInt i -> return TInt
    LBool b -> return TBool
    LNil -> throwError "Type: list type unimplemented"
typeOf (Var var) = do
    env <- ask
    let tenv = _types env
    case Map.lookup var tenv of
        Nothing -> throwError $ "Type: Unbound value " ++ var
        Just t -> return t
typeOf (Lam n t0 e) = do
    env <- ask
    let ntenv = Map.insert n t0 $ _types env
    t1 <- local (\env -> env {_types = ntenv}) (typeOf e)
    return $ TFun t0 t1
typeOf (App e1 e2) = do
    t1 <- typeOf e1
    case t1 of
        TFun tl tr -> checkType e2 tl >> return tr
        _ -> throwError $ "Type error: " ++ show e1 ++ " is of type " ++ show t1
typeOf (Let n e1 e2) = do
    t1 <- typeOf e1
    env <- ask
    let ntenv = Map.insert n t1 $ _types env
    local (\env -> env {_types = ntenv}) (typeOf e2)
typeOf (LetRec l e) = do
    env <- ask
    let nte = Map.union tmap $ _types env
    tl <- mapM (\(_, _, e') -> local (\env -> env {_types = nte}) (typeOf e')) l
    let typeMap = Map.fromList $ zip nlist tl
    local (\env -> env {_types = typeMap}) (typeOf e)
    where
        tlist = map (\(n, t, _) -> (n, t)) l
        tmap  = Map.fromList tlist
        nlist = map (\(n, _, _) -> n) l
typeOf (If cond e1 e2) = do
    tc <- checkType cond TBool
    t1 <- typeOf e1
    checkType e2 t1 >> return t1
typeOf (BinOp op e1 e2) = case op of
    OpAdd -> checkBinOpType e1 e2 TInt
    OpMul -> checkBinOpType e1 e2 TInt
    OpSub -> checkBinOpType e1 e2 TInt
    OpDiv -> checkBinOpType e1 e2 TInt
    OpAnd -> checkBinOpType e1 e2 TBool
    OpOr  -> checkBinOpType e1 e2 TBool
    OpEq  -> 
        (checkBinOpType e1 e2 TInt >> return TBool) `catchError` (\_ -> checkBinOpType e1 e2 TBool)
    OpLT  -> checkBinOpType e1 e2 TInt
    where
        checkBinOpType :: Expr -> Expr -> Type -> TypeReader
        checkBinOpType e1 e2 t = checkType e1 t >> checkType e2 t           

typeOf (UnOp op e) = case op of
    OpNeg -> checkType e TInt
    OpNot -> checkType e TBool
typeOf (Cons e1 e2) = do
    t1 <- typeOf e1
    let listType = TList t1
    case e2 of
        Lit LNil -> return listType
        _ -> checkType e2 listType
typeOf (AlgCons cname le) = do
    env <- ask
    c <- maybe (throwError $ "Unbound constructor " ++ cname) return $
        Map.lookup cname $ _constructors env
    let (_, typename) = c
    algtype <- case Map.lookup typename $ _algtypes env of
        Nothing -> throwError $ "Unknown type " ++ typename 
            ++ " of constructor " ++ cname
        Just a -> return a
    types <- case List.lookup cname $ consdef algtype of
        Nothing -> throwError $ "Constructor " ++ cname 
            ++ " was said to be of type " ++ typename ++ " but is not"
        Just tlist -> return tlist
    _ <- zipWithM_ checkType le types
    return $ TAlg typename

checkType :: Expr -> Type -> TypeReader
checkType e t = do
    t' <- typeOf e
    if t == t' then return t 
    else throwError $ "Type error: " ++ show e ++ " should be " ++ show t 
        ++ " but is of type " ++ show t'


----- SHOW INSTANCES -----
instance Show Expr where
    show (Var n) = n
    show (Lam n t e) = "λ(" ++ n ++ " : " ++ show t ++ ") -> " ++ show e
    show (Lit l) = show l
    show (App e1 e2) = "(" ++ show e1 ++ ")(" ++ show e2 ++ ")"
    show (Let n e1 e2) = "let " ++ n ++ " = " ++ show e1 ++ " in " ++ show e2
    show (LetRec l e) = 
        "letrec " ++ 
        List.intercalate " also " (map (\(n, _, e') -> n ++ " = " 
        ++ show e') l) ++ " in " ++ show e
    show (If cond e1 e2) = "if " ++ show cond ++ " then " ++ show e1 ++ 
        " else " ++ show e2
    show (BinOp op e1 e2) = show e1 ++ " " ++ show op ++ " " ++ show e2
    show (UnOp op e) = show op ++ " " ++ show e
    show (Cons e1 e2) = show e1 ++ " :: " ++ show e2
    show (AlgCons n le) = n ++ " of (" ++ List.intercalate ", " (map show le) 
        ++ ")"

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

instance Show Value where
    show (VInt i) = show i 
    show(VBool b) = show b
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