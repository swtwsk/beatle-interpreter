{-# LANGUAGE FlexibleInstances, OverlappingInstances #-}
{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}

-- | Pretty-printer for PrintBeatle.
--   Generated by the BNF converter.

module PrintBeatle where

import AbsBeatle
import Data.Char

-- | The top-level printing method.

printTree :: Print a => a -> String
printTree = render . prt 0

type Doc = [ShowS] -> [ShowS]

doc :: ShowS -> Doc
doc = (:)

render :: Doc -> String
render d = rend 0 (map ($ "") $ d []) "" where
  rend i ss = case ss of
    "["      :ts -> showChar '[' . rend i ts
    "("      :ts -> showChar '(' . rend i ts
    "{"      :ts -> showChar '{' . new (i+1) . rend (i+1) ts
    "}" : ";":ts -> new (i-1) . space "}" . showChar ';' . new (i-1) . rend (i-1) ts
    "}"      :ts -> new (i-1) . showChar '}' . new (i-1) . rend (i-1) ts
    ";"      :ts -> showChar ';' . new i . rend i ts
    t  : ts@(p:_) | closingOrPunctuation p -> showString t . rend i ts
    t        :ts -> space t . rend i ts
    _            -> id
  new i   = showChar '\n' . replicateS (2*i) (showChar ' ') . dropWhile isSpace
  space t = showString t . (\s -> if null s then "" else ' ':s)

  closingOrPunctuation :: String -> Bool
  closingOrPunctuation [c] = c `elem` closerOrPunct
  closingOrPunctuation _   = False

  closerOrPunct :: String
  closerOrPunct = ")],;"

parenth :: Doc -> Doc
parenth ss = doc (showChar '(') . ss . doc (showChar ')')

concatS :: [ShowS] -> ShowS
concatS = foldr (.) id

concatD :: [Doc] -> Doc
concatD = foldr (.) id

replicateS :: Int -> ShowS -> ShowS
replicateS n f = concatS (replicate n f)

-- | The printer class does the job.

class Print a where
  prt :: Int -> a -> Doc
  prtList :: Int -> [a] -> Doc
  prtList i = concatD . map (prt i)

instance Print a => Print [a] where
  prt = prtList

instance Print Char where
  prt _ s = doc (showChar '\'' . mkEsc '\'' s . showChar '\'')
  prtList _ s = doc (showChar '"' . concatS (map (mkEsc '"') s) . showChar '"')

mkEsc :: Char -> Char -> ShowS
mkEsc q s = case s of
  _ | s == q -> showChar '\\' . showChar s
  '\\'-> showString "\\\\"
  '\n' -> showString "\\n"
  '\t' -> showString "\\t"
  _ -> showChar s

prPrec :: Int -> Int -> Doc -> Doc
prPrec i j = if j < i then parenth else id

instance Print Integer where
  prt _ x = doc (shows x)

instance Print Double where
  prt _ x = doc (shows x)

instance Print TIdent where
  prt _ (TIdent i) = doc (showString i)

instance Print TPolyIdent where
  prt _ (TPolyIdent i) = doc (showString i)
  prtList _ [] = concatD []
  prtList _ (x:xs) = concatD [prt 0 x, prt 0 xs]

instance Print VIdent where
  prt _ (VIdent i) = doc (showString i)

instance Print Program where
  prt i e = case e of
    Prog phrases -> prPrec i 0 (concatD [prt 0 phrases])

instance Print Line where
  prt i e = case e of
    Line phrase -> prPrec i 0 (concatD [prt 0 phrase, doc (showString ";;")])

instance Print Phrase where
  prt i e = case e of
    Value letdef -> prPrec i 0 (concatD [prt 0 letdef])
    Expression expr -> prPrec i 0 (concatD [prt 0 expr])
    TypeDecl typedef -> prPrec i 0 (concatD [prt 0 typedef])
  prtList _ [] = concatD []
  prtList _ (x:xs) = concatD [prt 0 x, doc (showString ";;"), prt 0 xs]

instance Print [Phrase] where
  prt = prtList

instance Print LetDef where
  prt i e = case e of
    Let letbinds -> prPrec i 0 (concatD [doc (showString "let"), prt 0 letbinds])
    LetRec letbinds -> prPrec i 0 (concatD [doc (showString "letrec"), prt 0 letbinds])

instance Print LetBind where
  prt i e = case e of
    ConstBind letlvi expr -> prPrec i 0 (concatD [prt 0 letlvi, doc (showString "="), prt 0 expr])
    ProcBind procname letlvis rtype expr -> prPrec i 0 (concatD [prt 0 procname, prt 0 letlvis, prt 0 rtype, doc (showString "="), prt 0 expr])
  prtList _ [x] = concatD [prt 0 x]
  prtList _ (x:xs) = concatD [prt 0 x, doc (showString "also"), prt 0 xs]

instance Print LetLVI where
  prt i e = case e of
    LetLVI lambdavi -> prPrec i 0 (concatD [prt 0 lambdavi])
  prtList _ [x] = concatD [prt 0 x]
  prtList _ (x:xs) = concatD [prt 0 x, prt 0 xs]

instance Print [LetLVI] where
  prt = prtList

instance Print [LetBind] where
  prt = prtList

instance Print PNested where
  prt i e = case e of
    PAlgWild -> prPrec i 0 (concatD [doc (showString "_")])
    PAlgList patterns -> prPrec i 0 (concatD [doc (showString "("), prt 1 patterns, doc (showString ")")])

instance Print CasePat where
  prt i e = case e of
    CPattern pattern -> prPrec i 0 (concatD [prt 4 pattern])
    CTypeAlgRec tident pnested -> prPrec i 0 (concatD [prt 0 tident, prt 0 pnested])
    CNamedPat vident pattern -> prPrec i 0 (concatD [prt 0 vident, doc (showString "@"), prt 4 pattern])
    CListCons pattern1 pattern2 -> prPrec i 0 (concatD [prt 5 pattern1, doc (showString "::"), prt 1 pattern2])

instance Print Pattern where
  prt i e = case e of
    PId vident -> prPrec i 5 (concatD [prt 0 vident])
    PInt n -> prPrec i 5 (concatD [prt 0 n])
    PTrue -> prPrec i 5 (concatD [doc (showString "True")])
    PFalse -> prPrec i 5 (concatD [doc (showString "False")])
    PWildcard -> prPrec i 5 (concatD [doc (showString "_")])
    PListEmpty -> prPrec i 5 (concatD [doc (showString "[]")])
    PTypeAlg tident -> prPrec i 5 (concatD [prt 0 tident])
    PTyped pattern type_ -> prPrec i 5 (concatD [doc (showString "("), prt 0 pattern, doc (showString ":"), prt 0 type_, doc (showString ")")])
    PList patterns -> prPrec i 4 (concatD [doc (showString "["), prt 4 patterns, doc (showString "]")])
    PTypeAlgRec tident pnested -> prPrec i 3 (concatD [doc (showString "("), prt 0 tident, prt 0 pnested, doc (showString ")")])
    PNamedPat vident pattern -> prPrec i 2 (concatD [prt 0 vident, doc (showString "@"), prt 4 pattern])
    PListCons pattern1 pattern2 -> prPrec i 1 (concatD [prt 5 pattern1, doc (showString "::"), prt 1 pattern2])
  prtList 4 [x] = concatD [prt 4 x]
  prtList 4 (x:xs) = concatD [prt 4 x, doc (showString ","), prt 4 xs]
  prtList 1 [] = concatD []
  prtList 1 [x] = concatD [prt 1 x]
  prtList 1 (x:xs) = concatD [prt 1 x, doc (showString ","), prt 1 xs]

instance Print Expr where
  prt i e = case e of
    EId vident -> prPrec i 9 (concatD [prt 0 vident])
    EInt n -> prPrec i 9 (concatD [prt 0 n])
    ETrue -> prPrec i 9 (concatD [doc (showString "True")])
    EFalse -> prPrec i 9 (concatD [doc (showString "False")])
    EListEmpty -> prPrec i 9 (concatD [doc (showString "[]")])
    ETypeAlg tident -> prPrec i 9 (concatD [prt 0 tident])
    EList exprs -> prPrec i 9 (concatD [doc (showString "["), prt 0 exprs, doc (showString "]")])
    EApp expr1 expr2 -> prPrec i 8 (concatD [prt 8 expr1, prt 9 expr2])
    ETyped expr type_ -> prPrec i 7 (concatD [doc (showString "("), prt 0 expr, doc (showString ":"), prt 0 type_, doc (showString ")")])
    ENeg expr -> prPrec i 6 (concatD [doc (showString "-"), prt 7 expr])
    ENot expr -> prPrec i 6 (concatD [doc (showString "not"), prt 7 expr])
    EMul expr1 expr2 -> prPrec i 5 (concatD [prt 5 expr1, doc (showString "*"), prt 6 expr2])
    EDiv expr1 expr2 -> prPrec i 5 (concatD [prt 5 expr1, doc (showString "/"), prt 6 expr2])
    EMod expr1 expr2 -> prPrec i 5 (concatD [prt 5 expr1, doc (showString "%"), prt 6 expr2])
    EAdd expr1 expr2 -> prPrec i 4 (concatD [prt 4 expr1, doc (showString "+"), prt 5 expr2])
    ESub expr1 expr2 -> prPrec i 4 (concatD [prt 4 expr1, doc (showString "-"), prt 5 expr2])
    EListCons expr1 expr2 -> prPrec i 3 (concatD [prt 4 expr1, doc (showString "::"), prt 3 expr2])
    ELTH expr1 expr2 -> prPrec i 2 (concatD [prt 2 expr1, doc (showString "<"), prt 3 expr2])
    ELE expr1 expr2 -> prPrec i 2 (concatD [prt 2 expr1, doc (showString "<="), prt 3 expr2])
    EGTH expr1 expr2 -> prPrec i 2 (concatD [prt 2 expr1, doc (showString ">"), prt 3 expr2])
    EGE expr1 expr2 -> prPrec i 2 (concatD [prt 2 expr1, doc (showString ">="), prt 3 expr2])
    EEQU expr1 expr2 -> prPrec i 2 (concatD [prt 2 expr1, doc (showString "=="), prt 3 expr2])
    ENE expr1 expr2 -> prPrec i 2 (concatD [prt 2 expr1, doc (showString "!="), prt 3 expr2])
    EAnd expr1 expr2 -> prPrec i 1 (concatD [prt 2 expr1, doc (showString "and"), prt 1 expr2])
    EOr expr1 expr2 -> prPrec i 0 (concatD [prt 1 expr1, doc (showString "or"), prt 0 expr2])
    ECond expr1 expr2 expr3 -> prPrec i 0 (concatD [doc (showString "if"), prt 0 expr1, doc (showString "then"), prt 0 expr2, doc (showString "else"), prt 0 expr3])
    ELetIn letdef expr -> prPrec i 0 (concatD [prt 0 letdef, doc (showString "in"), prt 0 expr])
    EMatch vident matchings -> prPrec i 0 (concatD [doc (showString "match"), prt 0 vident, doc (showString "with"), doc (showString "{"), prt 0 matchings, doc (showString "}")])
    ELambda lambdavis expr -> prPrec i 0 (concatD [doc (showString "\\"), prt 0 lambdavis, doc (showString "->"), prt 0 expr])
    ETypeCons tident exprs -> prPrec i 0 (concatD [prt 0 tident, doc (showString "of"), doc (showString "("), prt 0 exprs, doc (showString ")")])
  prtList _ [x] = concatD [prt 0 x]
  prtList _ (x:xs) = concatD [prt 0 x, doc (showString ","), prt 0 xs]

instance Print LambdaVI where
  prt i e = case e of
    TypedVId vident type_ -> prPrec i 0 (concatD [doc (showString "("), prt 0 vident, doc (showString ":"), prt 0 type_, doc (showString ")")])
    LambdaVId vident -> prPrec i 0 (concatD [prt 0 vident])
    WildVId -> prPrec i 0 (concatD [doc (showString "_")])
  prtList _ [x] = concatD [prt 0 x]
  prtList _ (x:xs) = concatD [prt 0 x, doc (showString ","), prt 0 xs]

instance Print [Expr] where
  prt = prtList

instance Print [Matching] where
  prt = prtList

instance Print [LambdaVI] where
  prt = prtList

instance Print Matching where
  prt i e = case e of
    MatchCase pattern expr -> prPrec i 0 (concatD [doc (showString "case"), prt 0 pattern, doc (showString "->"), prt 0 expr])
  prtList _ [x] = concatD [prt 0 x]
  prtList _ (x:xs) = concatD [prt 0 x, doc (showString ";"), prt 0 xs]

instance Print ProcName where
  prt i e = case e of
    ProcNameId vident -> prPrec i 0 (concatD [prt 0 vident])

instance Print TypeDef where
  prt i e = case e of
    TDef tident tpolyidents typeconss -> prPrec i 0 (concatD [doc (showString "type"), prt 0 tident, prt 0 tpolyidents, doc (showString "="), prt 0 typeconss])

instance Print TypeCons where
  prt i e = case e of
    TCons tident types -> prPrec i 0 (concatD [prt 0 tident, prt 0 types])
  prtList _ [x] = concatD [prt 0 x]
  prtList _ (x:xs) = concatD [prt 0 x, doc (showString "|"), prt 0 xs]

instance Print [TPolyIdent] where
  prt = prtList

instance Print [TypeCons] where
  prt = prtList

instance Print [Type] where
  prt = prtList

instance Print Type where
  prt i e = case e of
    TInt -> prPrec i 1 (concatD [doc (showString "Int")])
    TBool -> prPrec i 1 (concatD [doc (showString "Bool")])
    TList type_ -> prPrec i 1 (concatD [doc (showString "["), prt 0 type_, doc (showString "]")])
    TAlgebraic tident -> prPrec i 1 (concatD [prt 0 tident])
    TPoly tpolyident -> prPrec i 1 (concatD [prt 0 tpolyident])
    TFun type_1 type_2 -> prPrec i 0 (concatD [prt 1 type_1, doc (showString "->"), prt 0 type_2])
  prtList _ [] = concatD []
  prtList _ (x:xs) = concatD [prt 0 x, prt 0 xs]

instance Print RType where
  prt i e = case e of
    NoRetType -> prPrec i 0 (concatD [])
    RetType type_ -> prPrec i 0 (concatD [doc (showString "->"), prt 0 type_])

