module Types where

data Type = TInt
          | TBool
          | TFun Type Type
          | TVar String
          | TList Type
          | TAlg String
          | TPoly String
          deriving (Eq)

data Scheme = Scheme [String] Type

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
