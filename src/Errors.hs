module Errors where

import Expr

data InterpreterError = TCE TypeCheckError 
                      | EE EvalError 
                      | UnexpectedError

data TypeCheckError = TNotUnify Type Type
                    | TOccurCheck String Type
                    | TUnboundVar String
                    | TError String

data EvalError = EApplyErr ApplyErr
               | EUnboundVal String
               | EDivisionByZero
               | EEquality
               | EError String

data ApplyErr = ApplyFail InterpreterError 
              | MatchFail 
              | ExpressionNotAFunction
              | ForbiddenListPattern

instance Show InterpreterError where
    show (TCE tce) = "Type error: " ++ show tce
    show (EE ee)       = "Error: " ++ show ee
    show UnexpectedError      = "Unexpected error"

instance Show TypeCheckError where
    show (TNotUnify t1 t2) = 
        "Types do not unify: " ++ show t1 ++ " and " ++ show t2
    show (TOccurCheck u t) = "Occur check fails: " ++ u ++ " vs. " ++ show t
    show (TUnboundVar var) = "Unbound variable: " ++ var
    show (TError err)      = err

instance Show EvalError where
    show (EApplyErr ae)    = show ae
    show (EUnboundVal val) = "Unbound value: " ++ val
    show EDivisionByZero   = "Cannot divide by zero"
    show (EError err)      = err
    show EEquality = "Cannot test equality in types other than int and bool"

instance Show ApplyErr where
    show (ApplyFail err) = show err
    show MatchFail       = "Non-exhaustive pattern match"
    show ExpressionNotAFunction = 
        "Expression is not a function; it cannot be applied"
    show ForbiddenListPattern =
        "List patterns that aren't variables are forbidden"
