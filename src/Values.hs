module Values where

import Expr

import qualified Data.Map as Map
import Data.List (intercalate)

type ValMap = Map.Map Name Value

data Env = Env 
    { _values       :: ValMap
    , _schemes      :: SchemeMap }

emptyEnv :: Env
emptyEnv = Env { _values = Map.empty
               , _schemes = Map.empty }

mergeEnv :: Env -> Env -> Env
mergeEnv env1 env2 =
    Env { _values = Map.union (_values env1) (_values env2)
        , _schemes = Map.union (_schemes env1) (_schemes env2) }

data Value = VInt Integer 
           | VBool Bool 
           | VClos Pattern Expr Env
           | VFixed Name [(Name, Expr)] Env
           | VCase Name [(Pattern, Expr)] Env
           | VCons Value Value
           | VNil

instance Arity Value where
    arity (VCons _ v2) = 1 + arity v2
    arity VNil = 1
    arity _ = 0

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
    show (VCase n l _) = "<pattern-match>"
