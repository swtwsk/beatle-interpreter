module Interpreter where

-- Haskell module generated by the BNF converter

import System.Console.Haskeline
import Control.Monad.State
import Control.Monad.Except
import qualified Data.Map as Map

import AbsBeatle
import Utils

import Errors
import Lambda
import qualified Expr as E
import qualified TypeInference as T

type InterRes = [(Maybe Name, Value, E.Type)]

type IState = ExceptT InterpreterError (StateT Env (InputT IO))

data Fun = Fun [(Name, E.Expr)] | Rec [(Name, E.Expr)]

interpretLine :: Line -> IState InterRes
interpretLine (Line phr) = interpretPhrase phr

-- interpretProg :: Program -> [Result]
-- interpretProg (Prog phr) = map interpretPhrase phr

interpretPhrase :: Phrase -> IState InterRes
interpretPhrase (Expression e) = do
    env <- get
    let ev = eval env $ translateExpr e
    case ev of
        Left err -> throwError err
        Right (v, t) -> return [(Nothing, v, t)]
interpretPhrase (Value letdef) = do
    env <- get
    let vmap = _values env
        tld  = translateLetDef letdef
        sm   = _schemes env
    m <- case tld of
        Fun list -> either throwError (return . map extractVar) $ 
            seqPair $ map (ev env) list
        Rec list -> do
            ty <- either throwError return $ T.inferTypeRec sm list
            return $ zipType (fixed env list) ty
            where
                    zipType ((n, v):tv) t = (n, v, t) : zipType tv t
                    zipType [] _ = []
    let m' = map (\(n, v, _) -> (n, v)) m
        t' = map (\(n, _, t) -> (n, T.generalize (T.GammaEnv sm) t)) m
    put $ env { _values = Map.union (Map.fromList m') vmap
              , _schemes  = Map.union (Map.fromList t') sm }
    return $ map (\(n, v, t) -> (pure n, v, t)) m
    where
        ev env (name, expr) = (name, eval env expr)
        extractVar (n, (v, t)) = (n, v, t)

translateExpr :: Expr -> E.Expr
translateExpr (EId (VIdent n)) = E.Var n
translateExpr (EInt i) = E.Lit $ E.LInt i
translateExpr ETrue = E.Lit $ E.LBool True
translateExpr EFalse = E.Lit $ E.LBool False
translateExpr EListEmpty = E.Lit E.LNil
translateExpr (EApp e1 e2) = E.App te1 te2
    where
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (ENeg e) = E.UnOp E.OpNeg $ translateExpr e
translateExpr (ENot e) = E.UnOp E.OpNot $ translateExpr e
translateExpr (EMul e1 e2) = E.BinOp E.OpMul te1 te2
    where
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (EDiv e1 e2) = E.BinOp E.OpDiv te1 te2
    where
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (EAdd e1 e2) = E.BinOp E.OpAdd te1 te2
    where
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (ESub e1 e2) = E.BinOp E.OpSub te1 te2
    where
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (EMod e1 e2) =
    E.BinOp E.OpSub te1 (E.BinOp E.OpMul te2 (E.BinOp E.OpDiv te1 te2))
    where
        te1 = translateExpr e1
        te2 = translateExpr e2        
translateExpr (EListCons e1 e2) = E.Cons te1 te2
    where
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (ELTH e1 e2) = E.BinOp E.OpLT te1 te2
    where
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (ELE e1 e2) = 
    E.BinOp E.OpOr (E.BinOp E.OpLT te1 te2) (E.BinOp E.OpEq te1 te2)
    where
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (EGTH e1 e2) = E.UnOp E.OpNot $ translateExpr (ELE e1 e2)
translateExpr (EGE e1 e2) = E.UnOp E.OpNot $ translateExpr (ELTH e1 e2)
translateExpr (EEQU e1 e2) = E.BinOp E.OpEq te1 te2
    where
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (ENE e1 e2) = E.UnOp E.OpNot $ translateExpr (EEQU e1 e2)
translateExpr (EAnd e1 e2) = E.BinOp E.OpAnd te1 te2
    where
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (EOr e1 e2) = E.BinOp E.OpOr te1 te2
    where
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (ECond cond e1 e2) = E.If tc te1 te2
    where
        tc  = translateExpr cond
        te1 = translateExpr e1
        te2 = translateExpr e2
translateExpr (ELetIn letdef e) = case tl of 
    Fun list -> transLambda list te
    Rec list -> E.LetRec list te
    where
        tl = translateLetDef letdef
        te = translateExpr e
        transLambda l e = case l of
            (n, fe):t -> E.Let n fe (transLambda t e)
            [] -> e

translateExpr (EMatch (VIdent n) matchList) = 
    E.Case n $ map translateMatching matchList

translateExpr (ELambda vlist e) = transLambda vlist $ translateExpr e
    where 
        transLambda l e = case l of
            h:t -> E.Lam (E.PVar $ translateLambdaVI h) (transLambda t e)
            []  -> e
translateExpr (EList elist) = trans $ map translateExpr elist
    where 
        trans l = case l of
            h:t -> E.Cons h (trans t)
            []  -> E.Lit E.LNil

translateLetDef :: LetDef -> Fun
translateLetDef ld = case ld of
    Let letbinds -> Fun $ map translateLetBind letbinds
    LetRec letbinds -> Rec $ map translateLetBind letbinds

translateLetBind :: LetBind -> (Name, E.Expr)
translateLetBind (ConstBind lvi e) = (n, te)
    where
        n = translateLetLVI lvi
        te = translateExpr e
translateLetBind (ProcBind (ProcNameId (VIdent proc)) il e) = 
    (proc, transLambda til te)
    where
        til = map translateLetLVI il
        te = translateExpr e
        transLambda l e = case l of
            n:t  -> E.Lam (E.PVar n) (transLambda t e)
            [] -> e

translateLetLVI :: LetLVI -> Name
translateLetLVI (LetLVI lvi) = translateLambdaVI lvi

translateLambdaVI :: LambdaVI -> Name
translateLambdaVI (LambdaVId (VIdent n)) = n
translateLambdaVI WildVId = "_"

translatePattern :: Pattern -> E.Pattern
translatePattern (PId (VIdent n)) = E.PVar n
translatePattern (PInt i) = E.PConst $ LInt i
translatePattern PTrue = E.PConst $ LBool True
translatePattern PFalse = E.PConst $ LBool False
translatePattern PWildcard = E.PVar "_"
translatePattern PListEmpty = E.PConst LNil
translatePattern (PList plist) = trans $ map translatePattern plist
    where 
        trans l = case l of
            h:t -> E.PCons h (trans t)
            []  -> E.PConst E.LNil
translatePattern (PListCons p1 p2) = E.PCons tp1 tp2
    where
        tp1 = translatePattern p1
        tp2 = translatePattern p2 

translateMatching :: Matching -> (E.Pattern, E.Expr)
translateMatching (MatchCase p expr) = (tp, te)
    where
        tp = translatePattern p
        te = translateExpr expr
