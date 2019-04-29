module Types where

data Type = TInt
          | TBool
          | TFun Type Type
          | TVar String
          | TAlg String
          | TPoly String
          deriving (Show, Eq)

data Scheme = Scheme [String] Type