module Interpreter where

-- Haskell module generated by the BNF converter

import System.Console.Haskeline
import Control.Monad.State
import Control.Monad.Except
import qualified Data.Map as Map

import AbsBeatle
import ErrM
import Utils

import Lambda.Lambda hiding (Expr(..), TypeDef(..))
import qualified Lambda.Lambda as L
import qualified Types as T

type OldResult = Err String

data InterRes = InterVal [(Value, T.Type)]
              | InterType Name [(Name, [T.Type])]

type TransRes = Either String
type Result = TransRes InterRes

type IState = StateT L.Env (ExceptT String (InputT IO))

data Fun = Fun [(Name, T.Type, L.Expr)] | Rec [(Name, T.Type, L.Expr)]

interpretLine :: Line -> IState Result
interpretLine (Line phr) = interpretPhrase phr

-- interpretProg :: Program -> [Result]
-- interpretProg (Prog phr) = map interpretPhrase phr

interpretPhrase :: Phrase -> IState Result
interpretPhrase (Expression e) = do
    env <- get
    ev <- return $ either Left (eval env) $ translateExpr e
    return $ either Left (\n -> return $ InterVal [n]) $ ev
interpretPhrase (Value letdef) = do
    env <- get
    let vmap = _values env
    tld <- either throwError return $ translateLetDef letdef
    m <- case tld of
        Fun list -> either throwError return $ seqPair $ map (ev env) list
        Rec list -> do
            let tmap  = Map.fromList $ map (\(n, t, _) -> (n, t)) list
                tmap' = Map.union tmap (_types env)
            tl <- either throwError return $ 
                mapM (\(_, _, e') -> typeCheck tmap' e') list
            return $ L.fixed vmap list
    let m' = map (\(n, (v, _)) -> (n, v)) m
    let t' = map (\(n, (_, t)) -> (n, t)) m
    put $ env { _values = Map.union (Map.fromList m') vmap
              , _types  = Map.union (Map.fromList t') (_types env) }
    extr <- return $ map extract m
    return . pure . InterVal $ extr
    where
        ev env (name, _, expr) = (name, eval env expr)
        extract (_, expr) = expr
interpretPhrase (TypeDecl typedef) = do
    env <- get
    ttd <- either throwError return $ translateTypeDef typedef
    let (tname, tdef) = ttd
    let tmap = Map.insert tname tdef $ _algtypes env
    let cons = map (\(n, t) -> (n, (length t, tname))) $ L.consdef tdef
    let cmap = Map.union (Map.fromList cons) (_constructors env)
    put $ env { _constructors = cmap, _algtypes = tmap }
    return . pure $ InterType tname (L.consdef tdef)

translateExpr :: Expr -> TransRes L.Expr
translateExpr (EId (VIdent n)) = pure $ L.Var n
translateExpr (EInt i) = pure . L.Lit $ L.LInt i
translateExpr ETrue = pure . L.Lit $ L.LBool True
translateExpr EFalse = pure . L.Lit $ L.LBool False
translateExpr EListEmpty = pure . L.Lit $ L.LNil
translateExpr (EApp e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.App te1 te2
translateExpr (ETyped _ _) = Left "Unimplemented"
translateExpr (ENeg e) = do
    te <- translateExpr e
    pure $ L.UnOp L.OpNeg te
translateExpr (ENot e) = do
    te <- translateExpr e
    pure $ L.UnOp L.OpNot te
translateExpr (EMul e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.BinOp L.OpMul te1 te2
translateExpr (EDiv e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.BinOp L.OpDiv te1 te2
translateExpr (EAdd e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.BinOp L.OpAdd te1 te2
translateExpr (ESub e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.BinOp L.OpSub te1 te2
translateExpr (EMod e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ 
        L.BinOp L.OpSub te1 (L.BinOp L.OpMul te2 (L.BinOp L.OpDiv te1 te2))
translateExpr (EListCons e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.Cons te1 te2
translateExpr (ELTH e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.BinOp L.OpLT te1 te2
translateExpr (ELE e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.BinOp L.OpOr (L.BinOp L.OpLT te1 te2) (L.BinOp L.OpEq te1 te2)
translateExpr (EGTH e1 e2) = do
    le <- translateExpr (ELE e1 e2)
    pure $ L.UnOp L.OpNot le
translateExpr (EGE e1 e2) = do
    less <- translateExpr (ELTH e1 e2)
    pure $ L.UnOp L.OpNot less
translateExpr (EEQU e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.BinOp L.OpEq te1 te2
translateExpr (ENE e1 e2) = do
    eq <- translateExpr (EEQU e1 e2)
    pure $ L.UnOp L.OpNot eq
translateExpr (EAnd e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.BinOp L.OpAnd te1 te2
translateExpr (EOr e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.BinOp L.OpOr te1 te2
translateExpr (ECond cond e1 e2) = do
    tc <- translateExpr cond
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ L.If tc te1 te2

translateExpr (ELetIn letdef e) = do
    tl <- translateLetDef letdef
    te <- translateExpr e
    case tl of 
        Fun list -> pure $ transLambda list te
        Rec list -> pure $ L.LetRec list te
    where
        transLambda l e = case l of
            (n, _, fe):t -> L.Let n fe (transLambda t e)
            [] -> e

translateExpr (EMatch (VIdent n) matchList) =
    Left "unimplemented"
translateExpr (ELambda vlist e) = do
    te <- translateExpr e
    pure $ transLambda vlist te
    where 
        transLambda l e = case l of
            (TypedVId (VIdent n) typ):t -> 
                L.Lam n (translateType typ) (transLambda t e)
            -- STUPID PLACEHOLDER
            (LambdaVId (VIdent n)):t -> L.Lam n T.TInt (transLambda t e)
            [] -> e
translateExpr (EList elist) = do
    tlist <- sequence $ map translateExpr elist
    pure . trans $ tlist
    where 
        trans l = case l of
            h:t -> L.Cons h (trans t)
            [] -> L.Lit L.LNil
translateExpr (ETypeAlg (TIdent t)) = pure $ L.AlgCons t []
translateExpr (ETypeCons (TIdent t) elist) = do
    tlist <- sequence $ map translateExpr elist
    pure $ L.AlgCons t tlist

translateLetDef :: LetDef -> TransRes Fun
translateLetDef ld = case ld of
    Let letbinds -> 
        either Left (pure . Fun) $ sequence $ map translateLetBind letbinds
    LetRec letbinds -> 
        either Left (pure . Rec) $ sequence $ map translateLetBind letbinds

translateLetBind :: LetBind -> TransRes (String, T.Type, L.Expr)
translateLetBind (ConstBind p e) = do
    tp <- translatePattern p
    let (n, t) = tp
    te <- translateExpr e
    pure (n, t, te)
-- TODO: read rt
translateLetBind (ProcBind (ProcNameId (VIdent proc)) pl rt e) = do
    tpl <- sequence $ map translatePattern pl
    te <- translateExpr e
    trt <- case translateRetType rt of
        Nothing -> Left "function return type not specified"
        Just trt' -> pure trt'
    let proctype = foldr (\(_, t) acc -> T.TFun t acc) trt tpl
    pure (proc, proctype, transLambda tpl te)
    where
        transLambda l e = case l of
            (n, typ):t  -> L.Lam n typ (transLambda t e)
            [] -> e

-- TODO: This is totally not how it should be
translatePattern :: Pattern -> TransRes (String, T.Type)
translatePattern (PId (VIdent n)) = Left "Pattern: VIdent unimplemented"
translatePattern (PTyped (PId (VIdent n)) t) = pure (n, translateType t)
translatePattern _ = Left "Pattern: unimplemented"

translateTypeDef :: TypeDef -> TransRes (Name, L.TypeDef)
translateTypeDef (TDef (TIdent t) polys ltcons) = do
    let mpolys = map (\(TPolyIdent s) -> s) polys
    tl <- sequence $ map translateTypeCons ltcons
    return $ (t, L.TypeDef { L.polynames = mpolys, L.consdef = tl })

translateTypeCons :: TypeCons -> TransRes (Name, [T.Type])
translateTypeCons (TCons (TIdent t) types) = pure $ (t, map translateType types)

translateType :: Type -> T.Type
translateType TInt = T.TInt
translateType TBool = T.TBool
translateType (TAlgebraic (TIdent t)) = T.TAlg t
translateType (TPoly (TPolyIdent t)) = T.TPoly t
translateType (TFun t1 t2) = T.TFun (translateType t1) (translateType t2)

translateRetType :: RType -> Maybe T.Type
translateRetType NoRetType = Nothing
translateRetType (RetType t) = pure $ translateType t

failure :: Show a => a -> OldResult
failure x = Bad $ "Undefined case: " ++ show x

transTIdent :: TIdent -> OldResult
transTIdent x = case x of
  TIdent string -> failure x
transTPolyIdent :: TPolyIdent -> OldResult
transTPolyIdent x = case x of
  TPolyIdent string -> failure x
transPhrase :: Phrase -> OldResult
transPhrase x = case x of
  Value letdef -> failure x
  Expression expr -> failure x
  TypeDecl typedef -> failure x
transLetDef :: LetDef -> OldResult
transLetDef x = case x of
  Let letbinds -> failure x
  LetRec letbinds -> failure x
transLetBind :: LetBind -> OldResult
transLetBind x = case x of
  ConstBind pattern expr -> failure x
  ProcBind procname patterns rtype expr -> failure x
transPNested :: PNested -> OldResult
transPNested x = case x of
  PAlgWild -> failure x
  PAlgList patterns -> failure x
transCasePat :: CasePat -> OldResult
transCasePat x = case x of
  CPattern pattern -> failure x
  CTypeAlgRec tident pnested -> failure x
  CNamedPat vident pattern -> failure x
  CListCons pattern1 pattern2 -> failure x
transPattern :: Pattern -> OldResult
transPattern x = case x of
  PId vident -> failure x
  PInt integer -> failure x
  PTrue -> failure x
  PFalse -> failure x
  PWildcard -> failure x
  PListEmpty -> failure x
  PTypeAlg tident -> failure x
  PTyped pattern type_ -> failure x
  PList patterns -> failure x
  PTypeAlgRec tident pnested -> failure x
  PNamedPat vident pattern -> failure x
  PListCons pattern1 pattern2 -> failure x
transExpr :: Expr -> OldResult
transExpr x = case x of
  EId vident -> failure x
  EInt integer -> failure x
  ETrue -> failure x
  EFalse -> failure x
  EListEmpty -> failure x
  ETypeAlg tident -> failure x
  EApp expr1 expr2 -> failure x
  ETyped expr type_ -> failure x
  ENeg expr -> failure x
  ENot expr -> failure x
  EMul expr1 expr2 -> failure x
  EDiv expr1 expr2 -> failure x
  EMod expr1 expr2 -> failure x
  EAdd expr1 expr2 -> failure x
  ESub expr1 expr2 -> failure x
  EListCons expr1 expr2 -> failure x
  ELTH expr1 expr2 -> failure x
  ELE expr1 expr2 -> failure x
  EGTH expr1 expr2 -> failure x
  EGE expr1 expr2 -> failure x
  EEQU expr1 expr2 -> failure x
  ENE expr1 expr2 -> failure x
  EAnd expr1 expr2 -> failure x
  EOr expr1 expr2 -> failure x
  ECond expr1 expr2 expr3 -> failure x
  ELetIn letdef expr -> failure x
  EMatch vident matchings -> failure x
  ELambda vidents expr -> failure x
  EList exprs -> failure x
  ETypeCons tident exprs -> failure x
transMatching :: Matching -> OldResult
transMatching x = case x of
  MatchCase casepat expr -> failure x
transProcName :: ProcName -> OldResult
transProcName x = case x of
  ProcNameId vident -> failure x
transTypeDef :: TypeDef -> OldResult
transTypeDef x = case x of
  TDef tident tpolyidents typeconss -> failure x
transTypeCons :: TypeCons -> OldResult
transTypeCons x = case x of
  TCons tident types -> failure x
transType :: Type -> OldResult
transType x = case x of
  TInt -> failure x
  TBool -> failure x
  TAlgebraic tident -> failure x
  TPoly tpolyident -> failure x
  TFun type_1 type_2 -> failure x
transRType :: RType -> OldResult
transRType x = case x of
  NoRetType -> failure x
  RetType type_ -> failure x

