module Values where

import Expr

import qualified Data.Map as Map

data TypeDef = TypeDef { polynames :: [Name], consdef :: [(Name, [Type])] }

type ValMap = Map.Map Name Value
type TypeName = String
type ConsMap = Map.Map Name (Int, TypeName)
type AlgTypeMap = Map.Map TypeName TypeDef

data Env = Env 
    { _values :: ValMap
    , _constructors :: ConsMap
    , _algtypes  :: AlgTypeMap
    , _schemes :: SchemeMap }

emptyEnv :: Env
emptyEnv = Env { _values = Map.empty
               , _constructors = Map.empty
               , _algtypes = Map.empty
               , _schemes = Map.empty }

mergeEnv :: Env -> Env -> Env
mergeEnv env1 env2 =
    Env { _values = Map.union (_values env1) (_values env2) 
        , _constructors = Map.union (_constructors env1) (_constructors env2)
        , _algtypes = Map.union (_algtypes env1) (_algtypes env2) 
        , _schemes = Map.union (_schemes env1) (_schemes env2) }

data Value = VInt Integer 
           | VBool Bool 
           | VClos Pattern Expr Env
           | VFixed Name [(Name, Expr)] Env
           | VCase Name [(Pattern, Expr)] Env
           | VCons Value Value
           | VNil
           | VAlg Name TypeName [Value]