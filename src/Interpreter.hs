module Interpreter where

-- Haskell module generated by the BNF converter

import AbsBeatle
import ErrM

import qualified Lambda.EnrichedLambda as EL
import qualified Lambda.Lambda as L

type OldResult = Err String
type Value = L.Value

type TransRes = Either String
type Result = TransRes Value

interpretProg :: Program -> [Result]
interpretProg (Prog phr) = map interpretPhrase phr

interpretPhrase :: Phrase -> Result
interpretPhrase (Expression e) = either Left EL.eval . translateExpr $ e

translateExpr :: Expr -> TransRes EL.Expr
translateExpr (EId (VIdent n)) = pure $ EL.Var n
translateExpr (EInt i) = pure . EL.Lit $ L.LInt i
translateExpr ETrue = pure . EL.Lit $ L.LBool True
translateExpr EFalse = pure . EL.Lit $ L.LBool False
translateExpr EListEmpty = Left "Unimplemented"
translateExpr (ETypeAlg _) = Left "Unimplemented"
translateExpr (EApp e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ EL.App te1 te2
translateExpr (ETyped _ _) = Left "Unimplemented"
translateExpr (ENeg e) = do
    te <- translateExpr e
    pure $ EL.UnOp L.OpNeg te
translateExpr (ENot e) = do
    te <- translateExpr e
    pure $ EL.UnOp L.OpNot te
translateExpr (EMul e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ EL.BinOp L.OpMul te1 te2
translateExpr (EDiv e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ EL.BinOp L.OpDiv te1 te2
translateExpr (EAdd e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ EL.BinOp L.OpAdd te1 te2
translateExpr (ESub e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ EL.BinOp L.OpSub te1 te2
translateExpr (EMod e1 e2) = Left "unimplemented"
translateExpr (EListCons e1 e2) = Left "unimplemented"
translateExpr (ELTH e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ EL.BinOp L.OpLT te1 te2
translateExpr (ELE e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ EL.BinOp L.OpOr (EL.BinOp L.OpLT te1 te2) (EL.BinOp L.OpEq te1 te2)
translateExpr (EGTH e1 e2) = do
    le <- translateExpr (ELE e1 e2)
    pure $ EL.UnOp L.OpNot le
translateExpr (EGE e1 e2) = do
    less <- translateExpr (ELTH e1 e2)
    pure $ EL.UnOp L.OpNot less
translateExpr (EEQU e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ EL.BinOp L.OpEq te1 te2
translateExpr (ENE e1 e2) = do
    eq <- translateExpr (EEQU e1 e2)
    pure $ EL.UnOp L.OpNot eq
translateExpr (EAnd e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ EL.BinOp L.OpAnd te1 te2
translateExpr (EOr e1 e2) = do
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ EL.BinOp L.OpOr te1 te2
translateExpr (ECond cond e1 e2) = do
    tc <- translateExpr cond
    te1 <- translateExpr e1
    te2 <- translateExpr e2
    pure $ EL.If tc te1 te2

translateExpr (ELetIn letdef e) = do
    tl <- translateLetDef letdef
    let (name, letbind) = tl
    te <- translateExpr e
    pure $ EL.Let name letbind te 
-- | EMatch VIdent [Matching]
translateExpr (ELambda vlist e) = do
    te <- translateExpr e
    pure $ transLambda vlist te
    where 
        transLambda l e = case l of
            (VIdent n):t -> EL.Lam n (transLambda t e)
            [] -> e
translateExpr (EList elist) = Left "unimplemented"
translateExpr (ETypeCons (TIdent t) elist) = Left "unimplemented"

translateLetDef :: LetDef -> TransRes (String, EL.Expr)
translateLetDef ld = case ld of
    Let letbinds -> head $ map translateLetBind letbinds
    LetRec letbinds -> Left "unimplemented"

translateLetBind :: LetBind -> TransRes (String, EL.Expr)
translateLetBind (ConstBind p e) = do
    tp <- translatePattern p
    te <- translateExpr e
    pure (tp, te)
translateLetBind (ProcBind procname patterns rtype expr) =
    Left "unimplemented"

-- TODO: This is totally not how it should be
translatePattern :: Pattern -> TransRes String
translatePattern (PId (VIdent n)) = pure n
translatePattern _ = Left "unimplemented"

failure :: Show a => a -> OldResult
failure x = Bad $ "Undefined case: " ++ show x

transTIdent :: TIdent -> OldResult
transTIdent x = case x of
  TIdent string -> failure x
transTPolyIdent :: TPolyIdent -> OldResult
transTPolyIdent x = case x of
  TPolyIdent string -> failure x
transVIdent :: VIdent -> OldResult
transVIdent x = case x of
  VIdent string -> failure x
transProgram :: Program -> OldResult
transProgram x = case x of
  Prog phrases -> failure x
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

