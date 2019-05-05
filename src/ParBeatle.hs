{-# OPTIONS_GHC -w #-}
{-# OPTIONS -XMagicHash -XBangPatterns -XTypeSynonymInstances -XFlexibleInstances -cpp #-}
#if __GLASGOW_HASKELL__ >= 710
{-# OPTIONS_GHC -XPartialTypeSignatures #-}
#endif
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParBeatle where
import AbsBeatle
import LexBeatle
import ErrM
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import qualified GHC.Exts as Happy_GHC_Exts
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.9

newtype HappyAbsSyn  = HappyAbsSyn HappyAny
#if __GLASGOW_HASKELL__ >= 607
type HappyAny = Happy_GHC_Exts.Any
#else
type HappyAny = forall a . a
#endif
happyIn5 :: (Integer) -> (HappyAbsSyn )
happyIn5 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn5 #-}
happyOut5 :: (HappyAbsSyn ) -> (Integer)
happyOut5 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut5 #-}
happyIn6 :: (TIdent) -> (HappyAbsSyn )
happyIn6 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn6 #-}
happyOut6 :: (HappyAbsSyn ) -> (TIdent)
happyOut6 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut6 #-}
happyIn7 :: (TPolyIdent) -> (HappyAbsSyn )
happyIn7 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn7 #-}
happyOut7 :: (HappyAbsSyn ) -> (TPolyIdent)
happyOut7 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut7 #-}
happyIn8 :: (VIdent) -> (HappyAbsSyn )
happyIn8 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn8 #-}
happyOut8 :: (HappyAbsSyn ) -> (VIdent)
happyOut8 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut8 #-}
happyIn9 :: (Program) -> (HappyAbsSyn )
happyIn9 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn9 #-}
happyOut9 :: (HappyAbsSyn ) -> (Program)
happyOut9 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut9 #-}
happyIn10 :: (Line) -> (HappyAbsSyn )
happyIn10 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn10 #-}
happyOut10 :: (HappyAbsSyn ) -> (Line)
happyOut10 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut10 #-}
happyIn11 :: (Phrase) -> (HappyAbsSyn )
happyIn11 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn11 #-}
happyOut11 :: (HappyAbsSyn ) -> (Phrase)
happyOut11 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut11 #-}
happyIn12 :: ([Phrase]) -> (HappyAbsSyn )
happyIn12 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn12 #-}
happyOut12 :: (HappyAbsSyn ) -> ([Phrase])
happyOut12 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut12 #-}
happyIn13 :: (LetDef) -> (HappyAbsSyn )
happyIn13 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn13 #-}
happyOut13 :: (HappyAbsSyn ) -> (LetDef)
happyOut13 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut13 #-}
happyIn14 :: (LetBind) -> (HappyAbsSyn )
happyIn14 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn14 #-}
happyOut14 :: (HappyAbsSyn ) -> (LetBind)
happyOut14 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut14 #-}
happyIn15 :: ([Pattern]) -> (HappyAbsSyn )
happyIn15 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn15 #-}
happyOut15 :: (HappyAbsSyn ) -> ([Pattern])
happyOut15 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut15 #-}
happyIn16 :: ([LetBind]) -> (HappyAbsSyn )
happyIn16 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn16 #-}
happyOut16 :: (HappyAbsSyn ) -> ([LetBind])
happyOut16 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut16 #-}
happyIn17 :: (Pattern) -> (HappyAbsSyn )
happyIn17 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn17 #-}
happyOut17 :: (HappyAbsSyn ) -> (Pattern)
happyOut17 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut17 #-}
happyIn18 :: (Pattern) -> (HappyAbsSyn )
happyIn18 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn18 #-}
happyOut18 :: (HappyAbsSyn ) -> (Pattern)
happyOut18 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut18 #-}
happyIn19 :: (Pattern) -> (HappyAbsSyn )
happyIn19 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn19 #-}
happyOut19 :: (HappyAbsSyn ) -> (Pattern)
happyOut19 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut19 #-}
happyIn20 :: (Pattern) -> (HappyAbsSyn )
happyIn20 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn20 #-}
happyOut20 :: (HappyAbsSyn ) -> (Pattern)
happyOut20 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut20 #-}
happyIn21 :: (Pattern) -> (HappyAbsSyn )
happyIn21 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn21 #-}
happyOut21 :: (HappyAbsSyn ) -> (Pattern)
happyOut21 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut21 #-}
happyIn22 :: (PNested) -> (HappyAbsSyn )
happyIn22 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn22 #-}
happyOut22 :: (HappyAbsSyn ) -> (PNested)
happyOut22 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut22 #-}
happyIn23 :: (CasePat) -> (HappyAbsSyn )
happyIn23 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn23 #-}
happyOut23 :: (HappyAbsSyn ) -> (CasePat)
happyOut23 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut23 #-}
happyIn24 :: ([Pattern]) -> (HappyAbsSyn )
happyIn24 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn24 #-}
happyOut24 :: (HappyAbsSyn ) -> ([Pattern])
happyOut24 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut24 #-}
happyIn25 :: ([Pattern]) -> (HappyAbsSyn )
happyIn25 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn25 #-}
happyOut25 :: (HappyAbsSyn ) -> ([Pattern])
happyOut25 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut25 #-}
happyIn26 :: (Pattern) -> (HappyAbsSyn )
happyIn26 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn26 #-}
happyOut26 :: (HappyAbsSyn ) -> (Pattern)
happyOut26 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut26 #-}
happyIn27 :: (Expr) -> (HappyAbsSyn )
happyIn27 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn27 #-}
happyOut27 :: (HappyAbsSyn ) -> (Expr)
happyOut27 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut27 #-}
happyIn28 :: (Expr) -> (HappyAbsSyn )
happyIn28 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn28 #-}
happyOut28 :: (HappyAbsSyn ) -> (Expr)
happyOut28 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut28 #-}
happyIn29 :: (Expr) -> (HappyAbsSyn )
happyIn29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn29 #-}
happyOut29 :: (HappyAbsSyn ) -> (Expr)
happyOut29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut29 #-}
happyIn30 :: (Expr) -> (HappyAbsSyn )
happyIn30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn30 #-}
happyOut30 :: (HappyAbsSyn ) -> (Expr)
happyOut30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut30 #-}
happyIn31 :: (Expr) -> (HappyAbsSyn )
happyIn31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn31 #-}
happyOut31 :: (HappyAbsSyn ) -> (Expr)
happyOut31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut31 #-}
happyIn32 :: (Expr) -> (HappyAbsSyn )
happyIn32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn32 #-}
happyOut32 :: (HappyAbsSyn ) -> (Expr)
happyOut32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut32 #-}
happyIn33 :: (Expr) -> (HappyAbsSyn )
happyIn33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn33 #-}
happyOut33 :: (HappyAbsSyn ) -> (Expr)
happyOut33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut33 #-}
happyIn34 :: (Expr) -> (HappyAbsSyn )
happyIn34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn34 #-}
happyOut34 :: (HappyAbsSyn ) -> (Expr)
happyOut34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut34 #-}
happyIn35 :: (Expr) -> (HappyAbsSyn )
happyIn35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn35 #-}
happyOut35 :: (HappyAbsSyn ) -> (Expr)
happyOut35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut35 #-}
happyIn36 :: (Expr) -> (HappyAbsSyn )
happyIn36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn36 #-}
happyOut36 :: (HappyAbsSyn ) -> (Expr)
happyOut36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut36 #-}
happyIn37 :: (LambdaVI) -> (HappyAbsSyn )
happyIn37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn37 #-}
happyOut37 :: (HappyAbsSyn ) -> (LambdaVI)
happyOut37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut37 #-}
happyIn38 :: ([Expr]) -> (HappyAbsSyn )
happyIn38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn38 #-}
happyOut38 :: (HappyAbsSyn ) -> ([Expr])
happyOut38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut38 #-}
happyIn39 :: ([Matching]) -> (HappyAbsSyn )
happyIn39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn39 #-}
happyOut39 :: (HappyAbsSyn ) -> ([Matching])
happyOut39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut39 #-}
happyIn40 :: ([LambdaVI]) -> (HappyAbsSyn )
happyIn40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn40 #-}
happyOut40 :: (HappyAbsSyn ) -> ([LambdaVI])
happyOut40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut40 #-}
happyIn41 :: (Matching) -> (HappyAbsSyn )
happyIn41 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn41 #-}
happyOut41 :: (HappyAbsSyn ) -> (Matching)
happyOut41 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut41 #-}
happyIn42 :: (ProcName) -> (HappyAbsSyn )
happyIn42 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn42 #-}
happyOut42 :: (HappyAbsSyn ) -> (ProcName)
happyOut42 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut42 #-}
happyIn43 :: (TypeDef) -> (HappyAbsSyn )
happyIn43 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn43 #-}
happyOut43 :: (HappyAbsSyn ) -> (TypeDef)
happyOut43 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut43 #-}
happyIn44 :: (TypeCons) -> (HappyAbsSyn )
happyIn44 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn44 #-}
happyOut44 :: (HappyAbsSyn ) -> (TypeCons)
happyOut44 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut44 #-}
happyIn45 :: ([TPolyIdent]) -> (HappyAbsSyn )
happyIn45 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn45 #-}
happyOut45 :: (HappyAbsSyn ) -> ([TPolyIdent])
happyOut45 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut45 #-}
happyIn46 :: ([TypeCons]) -> (HappyAbsSyn )
happyIn46 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn46 #-}
happyOut46 :: (HappyAbsSyn ) -> ([TypeCons])
happyOut46 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut46 #-}
happyIn47 :: ([Type]) -> (HappyAbsSyn )
happyIn47 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn47 #-}
happyOut47 :: (HappyAbsSyn ) -> ([Type])
happyOut47 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut47 #-}
happyIn48 :: (Type) -> (HappyAbsSyn )
happyIn48 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn48 #-}
happyOut48 :: (HappyAbsSyn ) -> (Type)
happyOut48 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut48 #-}
happyIn49 :: (Type) -> (HappyAbsSyn )
happyIn49 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn49 #-}
happyOut49 :: (HappyAbsSyn ) -> (Type)
happyOut49 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut49 #-}
happyIn50 :: (RType) -> (HappyAbsSyn )
happyIn50 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn50 #-}
happyOut50 :: (HappyAbsSyn ) -> (RType)
happyOut50 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut50 #-}
happyInTok :: (Token) -> (HappyAbsSyn )
happyInTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyInTok #-}
happyOutTok :: (HappyAbsSyn ) -> (Token)
happyOutTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOutTok #-}


happyExpList :: HappyAddr
happyExpList = HappyA# "\x00\x00\x00\x00\x00\x00\x10\x02\x00\x3d\xd0\x23\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x10\x00\xe8\x81\x1e\x61\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\xe8\x00\x00\x60\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x48\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x11\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x60\x07\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x04\x00\x7a\xa0\x07\x58\x00\x00\x00\x00\x00\x00\x10\x00\x00\x1d\x00\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x42\x00\xa0\x07\x7a\x80\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x40\x08\x00\xf4\x40\x0f\xb0\x00\x00\x00\x00\x00\x00\x20\x00\x00\x3a\x01\x00\x58\x00\x00\x00\x00\x00\x00\x10\x00\x00\x9d\x00\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x04\x00\x40\x07\x00\x00\x0b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\xe8\x04\x00\x60\x01\x00\x00\x00\x00\x00\x40\x00\x00\x74\x02\x00\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x80\x4e\x00\x00\x16\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x04\x00\x7a\xa0\x07\x58\x00\x00\x00\x00\x00\x00\x10\x02\x00\x1d\x00\x02\x2c\x00\x00\x00\x00\x00\x00\x08\x01\x80\x0e\x00\x01\x16\x00\x00\x00\x00\x00\x00\x84\x00\x40\x07\x80\x00\x0b\x00\x00\x00\x00\x00\x00\x42\x00\xa0\x03\x40\x80\x05\x00\x00\x00\x00\x00\x00\x21\x00\xd0\x01\x20\xc0\x02\x00\x00\x00\x00\x00\x80\x10\x00\xe8\x00\x10\x60\x01\x00\x00\x00\x00\x00\x40\x08\x00\x74\x00\x08\xb0\x00\x00\x00\x00\x00\x00\x20\x04\x00\x3a\x00\x04\x58\x00\x00\x00\x00\x00\x00\x10\x02\x00\x1d\x00\x02\x2c\x00\x00\x00\x00\x00\x00\x08\x01\x80\x0e\x00\x01\x16\x00\x00\x00\x00\x00\x00\x84\x00\x40\x07\x80\x00\x0b\x00\x00\x00\x00\x00\x00\x42\x00\xa0\x03\x40\x80\x05\x00\x00\x00\x00\x00\x00\x21\x00\xd0\x01\x20\xc0\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x08\x00\xf4\x40\x0f\xb0\x00\x00\x00\x00\x00\x00\x20\x04\x00\x7a\xa0\x07\x58\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x21\x00\xd0\x03\x3d\xc0\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x09\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x84\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x2a\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x02\x00\x3d\xd0\x03\x2c\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84\x00\x40\x0f\xf4\x00\x0b\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x21\x00\xd0\x03\x3d\xc0\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x80\x4e\x00\x00\x16\x00\x00\x00\x00\x00\x00\x04\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x74\x02\x00\xb0\x00\x00\x00\x00\x00\x00\x20\x04\x00\x7a\xa0\x07\x58\x00\x00\x00\x00\x00\x00\x10\x00\x00\x9d\x00\x00\x2c\x00\x00\x00\x00\x00\x00\x08\x00\x80\x4e\x00\x00\x16\x00\x00\x00\x00\x00\x00\x04\x00\x40\x27\x00\x00\x0b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x80\x0a\x00\x00\x18\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\xa0\x02\x00\x00\x06\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\xd0\x09\x00\xc0\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x3a\x01\x00\x58\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x50\x01\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x40\x05\x00\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\xa8\x00\x00\x80\x01\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\xa0\x02\x00\x00\x06\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x21\x00\xd0\x03\x3d\xc0\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x42\x00\xa0\x07\x7a\x80\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x74\x02\x00\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x02\x00\x50\x01\x00\x00\x03\x00\x00\x00\x00\x00\x00\x01\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x74\x02\x00\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x08\x00\xf4\x40\x0f\xb0\x00\x00\x00\x00\x00\x00\x20\x00\x00\x3a\x01\x00\x58\x00\x00\x00\x00\x00\x00\x10\x00\x00\x9d\x00\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pLine","%start_pProgram","Integer","TIdent","TPolyIdent","VIdent","Program","Line","Phrase","ListPhrase","LetDef","LetBind","ListPattern","ListLetBind","Pattern5","Pattern4","Pattern3","Pattern2","Pattern1","PNested","CasePat","ListPattern4","ListPattern1","Pattern","Expr9","Expr8","Expr7","Expr6","Expr5","Expr4","Expr3","Expr2","Expr1","Expr","LambdaVI","ListExpr","ListMatching","ListLambdaVI","Matching","ProcName","TypeDef","TypeCons","ListTPolyIdent","ListTypeCons","ListType","Type1","Type","RType","'!='","'%'","'('","')'","'*'","'+'","','","'-'","'->'","'/'","':'","'::'","';'","';;'","'<'","'<='","'='","'=='","'>'","'>='","'@'","'Bool'","'False'","'Int'","'True'","'['","'[]'","'\\\\'","']'","'_'","'also'","'and'","'case'","'else'","'if'","'in'","'let'","'letrec'","'match'","'not'","'of'","'or'","'then'","'type'","'with'","'{'","'|'","'}'","L_integ","L_TIdent","L_TPolyIdent","L_VIdent","%eof"]
        bit_start = st * 103
        bit_end = (st + 1) * 103
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..102]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

happyActOffsets :: HappyAddr
happyActOffsets = HappyA# "\xfe\xff\x00\x00\xd1\xff\x00\x00\xdd\xff\xfe\xff\x00\x00\xf3\xff\x00\x00\xf2\xff\x39\x00\x1f\x00\x00\x00\x9b\x00\x00\x00\x00\x00\x09\x00\xf7\x00\x00\x00\xa0\x02\x20\x00\x00\x00\x00\x00\x1a\x00\xac\x00\x00\x00\x00\x00\x1a\x00\x00\x00\x04\x00\x1a\x00\x41\x00\x41\x00\xf4\xff\xac\x00\x21\x00\x00\x00\x00\x00\x23\x00\x00\x00\x00\x00\x2a\x00\x00\x00\x00\x00\xf8\xff\x3a\x00\x00\x00\x59\x00\x00\x00\x00\x00\x00\x00\x00\x00\x5e\x00\x41\x00\x41\x00\x00\x00\x00\x00\x52\x00\x00\x00\x00\x00\x00\x00\x4a\x00\x4e\x00\x00\x00\x78\x00\x77\x00\x56\x00\x84\x00\x73\x00\x00\x00\xff\xff\x1a\x00\x36\x00\x36\x00\x36\x00\x36\x00\x36\x00\x36\x00\x36\x00\x36\x00\x36\x00\x36\x00\x36\x00\x36\x00\x36\x00\x00\x00\x1a\x00\x1a\x00\x00\x00\x8f\x00\x8d\x00\x00\x00\x1a\x00\x00\x00\x98\x00\x00\x00\x00\x00\x00\x00\x00\x00\x09\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x13\x00\x00\x00\x1a\x00\xb2\x00\x1a\x00\x04\x00\x1a\x00\x00\x00\x00\x00\x9f\x00\xbb\x00\x5d\x00\x02\x00\xc6\x00\x10\x00\xd6\x00\x5d\x00\x1a\x00\x5d\x00\x5d\x00\x63\x00\xba\x00\xbc\x00\xe0\x00\x00\x00\xc8\x00\x00\x00\xd7\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xef\x00\x13\x00\x00\x00\x13\x00\xfd\x00\x6e\x00\x00\x00\x00\x00\x7f\x00\xe2\x00\x00\x00\x00\x00\x13\x00\x00\x00\x00\x00\x00\x00\xf9\x00\x01\x01\x13\x00\x00\x00\x00\x00\x13\x00\x02\x01\x00\x00\xea\x00\x04\x01\x00\x00\x13\x00\x05\x01\x1a\x00\x00\x00\x03\x01\x07\x01\x00\x00\x12\x01\x00\x00\x1a\x00\xe9\x00\x0e\x01\x7f\x00\x00\x00\xf1\x00\x00\x00\xec\x00\x13\x00\x02\x00\x0c\x01\x16\x01\x00\x00\x1a\x01\x06\x01\x00\x00\x00\x00\x00\x00\x00\x00\x8a\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1a\x00\x8a\x00\x90\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyGotoOffsets :: HappyAddr
happyGotoOffsets = HappyA# "\xf6\x00\x08\x00\x00\x00\x00\x00\x00\x00\x17\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xd1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xaf\x01\x32\x03\x00\x00\x00\x00\x74\x01\x00\x00\xcb\x00\xcf\x01\x37\x01\x48\x01\x21\x01\x4b\x03\x24\x01\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4f\x03\x76\x03\x00\x00\x00\x00\xd9\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x23\x01\x00\x00\x00\x00\x00\x00\x00\x00\xd9\x01\xa2\x02\xca\x02\xd1\x02\xd8\x02\xf5\x02\xfc\x02\xab\x02\x20\x03\x25\x03\x03\x03\x67\x01\x2a\x03\x2e\x03\x00\x00\xf9\x01\x03\x02\x00\x00\x00\x00\x00\x00\x00\x00\x81\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0f\x00\x00\x00\xa3\x01\x00\x00\x23\x02\xcd\x00\x2d\x02\x00\x00\x00\x00\x00\x00\x00\x00\x87\x03\x18\x01\x00\x00\x00\x00\xfb\x00\x65\x03\x4d\x02\xbf\x03\x63\x01\xa7\x01\x00\x00\x35\x00\x00\x00\x00\x00\x2b\x00\x00\x00\x3f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1d\x00\x00\x00\xab\x00\x00\x00\x98\x03\x00\x00\x00\x00\x4d\x01\x00\x00\x00\x00\x00\x00\xb6\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x00\x00\x00\xbe\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc7\x00\x00\x00\x57\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x77\x02\x00\x00\x00\x00\xaf\x03\x00\x01\x00\x00\x00\x00\x3b\x00\xc9\x00\x1b\x01\x00\x00\x00\x00\x00\x00\x00\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\xaa\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x81\x02\xc4\x03\xd3\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyAdjustOffset :: Happy_GHC_Exts.Int# -> Happy_GHC_Exts.Int#
happyAdjustOffset off = off

happyDefActions :: HappyAddr
happyDefActions = HappyA# "\x00\x00\xf4\xff\x00\x00\xfd\xff\x00\x00\xf9\xff\xcc\xff\xc8\xff\xcd\xff\x00\x00\x00\x00\xf7\xff\xc4\xff\xc2\xff\xbf\xff\xbb\xff\xb8\xff\xb6\xff\xaf\xff\xad\xff\xa6\xff\xf6\xff\xf5\xff\x00\x00\x00\x00\xca\xff\xcb\xff\x00\x00\xc9\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfc\xff\xfa\xff\x99\xff\xc8\xff\xc0\xff\x00\x00\xe9\xff\xe4\xff\x9c\xff\xec\xff\xf1\xff\xe0\xff\xde\xff\xdc\xff\xda\xff\xce\xff\x00\x00\x00\x00\x00\x00\xe7\xff\xe8\xff\x00\x00\xe5\xff\xe6\xff\xf2\xff\x00\x00\x00\x00\xa4\xff\x9f\xff\x00\x00\x00\x00\xa3\xff\x00\x00\xc1\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc5\xff\x00\x00\x00\x00\xf8\xff\x00\x00\x00\x00\xf3\xff\x00\x00\xaa\xff\x00\x00\xbd\xff\xbe\xff\xbc\xff\xb7\xff\xb9\xff\xba\xff\xae\xff\xb2\xff\xb3\xff\xb1\xff\xb4\xff\xb5\xff\xb0\xff\xac\xff\xc6\xff\x00\x00\xc7\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xea\xff\xe0\xff\xd3\xff\x00\x00\x00\x00\xe4\xff\xea\xff\x00\x00\x8b\xff\xee\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x99\xff\x00\x00\xfb\xff\x00\x00\x98\xff\x00\x00\xdd\xff\xeb\xff\xdb\xff\xf0\xff\xed\xff\x00\x00\x00\x00\xe2\xff\x00\x00\x00\x00\xd1\xff\xd9\xff\xe1\xff\x00\x00\x00\x00\x9e\xff\xa8\xff\x00\x00\xa2\xff\x90\xff\x8f\xff\x8c\xff\x00\x00\x00\x00\x92\xff\x93\xff\x00\x00\x00\x00\xa7\xff\x00\x00\x00\x00\xc3\xff\x00\x00\x00\x00\x00\x00\xd2\xff\xd0\xff\x00\x00\xdf\xff\x00\x00\x8a\xff\x00\x00\x00\x00\xa1\xff\x00\x00\x95\xff\x97\xff\x9b\xff\x00\x00\x9a\xff\xe4\xff\xea\xff\xe0\xff\xd7\xff\x00\x00\x00\x00\xa9\xff\xef\xff\xe3\xff\xd8\xff\xd1\xff\xab\xff\xa5\xff\x8d\xff\x8e\xff\x91\xff\xcf\xff\xa0\xff\x00\x00\x00\x00\x00\x00\xd6\xff\x94\xff\x96\xff\xd5\xff\xd4\xff\x9d\xff"#

happyCheck :: HappyAddr
happyCheck = HappyA# "\xff\xff\x03\x00\x31\x00\x04\x00\x0c\x00\x03\x00\x08\x00\x03\x00\x02\x00\x11\x00\x0b\x00\x02\x00\x04\x00\x15\x00\x05\x00\x07\x00\x01\x00\x02\x00\x35\x00\x0a\x00\x04\x00\x17\x00\x03\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x0b\x00\x29\x00\x03\x00\x01\x00\x02\x00\x1e\x00\x23\x00\x08\x00\x25\x00\x26\x00\x27\x00\x28\x00\x35\x00\x34\x00\x16\x00\x2c\x00\x18\x00\x01\x00\x1a\x00\x28\x00\x31\x00\x32\x00\x17\x00\x34\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x02\x00\x34\x00\x03\x00\x2b\x00\x2c\x00\x01\x00\x23\x00\x08\x00\x25\x00\x26\x00\x27\x00\x28\x00\x24\x00\x03\x00\x32\x00\x33\x00\x0e\x00\x2b\x00\x2c\x00\x2a\x00\x31\x00\x32\x00\x17\x00\x34\x00\x19\x00\x1a\x00\x1b\x00\x27\x00\x32\x00\x29\x00\x03\x00\x33\x00\x2d\x00\x17\x00\x1f\x00\x19\x00\x1a\x00\x1b\x00\x28\x00\x28\x00\x1e\x00\x03\x00\x22\x00\x27\x00\x24\x00\x29\x00\x0c\x00\x03\x00\x31\x00\x32\x00\x17\x00\x34\x00\x19\x00\x1a\x00\x1b\x00\x24\x00\x11\x00\x1e\x00\x03\x00\x31\x00\x32\x00\x17\x00\x34\x00\x19\x00\x1a\x00\x1b\x00\x2b\x00\x17\x00\x1e\x00\x19\x00\x1a\x00\x1b\x00\x07\x00\x09\x00\x1e\x00\x03\x00\x31\x00\x32\x00\x17\x00\x34\x00\x19\x00\x1a\x00\x1b\x00\x34\x00\x07\x00\x1e\x00\x03\x00\x31\x00\x32\x00\x1d\x00\x34\x00\x03\x00\x03\x00\x31\x00\x32\x00\x17\x00\x34\x00\x19\x00\x1a\x00\x1b\x00\x0e\x00\x04\x00\x1e\x00\x03\x00\x31\x00\x32\x00\x17\x00\x34\x00\x19\x00\x1a\x00\x1b\x00\x07\x00\x17\x00\x1e\x00\x19\x00\x1a\x00\x1b\x00\x01\x00\x02\x00\x1e\x00\x03\x00\x31\x00\x32\x00\x17\x00\x34\x00\x19\x00\x1a\x00\x1b\x00\x01\x00\x02\x00\x01\x00\x02\x00\x31\x00\x32\x00\x0b\x00\x34\x00\x01\x00\x02\x00\x31\x00\x32\x00\x17\x00\x34\x00\x19\x00\x1a\x00\x1b\x00\x01\x00\x02\x00\x01\x00\x02\x00\x31\x00\x32\x00\x03\x00\x34\x00\x03\x00\x00\x00\x01\x00\x22\x00\x03\x00\x24\x00\x2b\x00\x2c\x00\x1d\x00\x00\x00\x01\x00\x15\x00\x03\x00\x31\x00\x32\x00\x09\x00\x34\x00\x2b\x00\x2c\x00\x2b\x00\x2c\x00\x0c\x00\x0d\x00\x16\x00\x2e\x00\x2b\x00\x2c\x00\x20\x00\x13\x00\x20\x00\x23\x00\x33\x00\x23\x00\x11\x00\x2b\x00\x2c\x00\x2b\x00\x2c\x00\x00\x00\x01\x00\x21\x00\x03\x00\x32\x00\x05\x00\x06\x00\x06\x00\x08\x00\x08\x00\x11\x00\x04\x00\x09\x00\x0c\x00\x22\x00\x04\x00\x04\x00\x1d\x00\x04\x00\x04\x00\x07\x00\x04\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x04\x00\x00\x00\x01\x00\x30\x00\x03\x00\x0d\x00\x26\x00\x06\x00\x32\x00\x08\x00\x2f\x00\x15\x00\x0c\x00\x09\x00\x03\x00\x01\x00\x03\x00\x21\x00\x2d\x00\x11\x00\x2a\x00\xff\xff\x11\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\x26\x00\xff\xff\xff\xff\x09\x00\xff\xff\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x00\x00\x01\x00\xff\xff\x03\x00\x15\x00\x00\x00\x01\x00\xff\xff\x03\x00\x09\x00\xff\xff\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x0c\x00\x0d\x00\xff\xff\x25\x00\x15\x00\xff\xff\xff\xff\x13\x00\xff\xff\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\x09\x00\x25\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x00\x00\x01\x00\xff\xff\x03\x00\x15\x00\xff\xff\xff\xff\xff\xff\x08\x00\x16\x00\x17\x00\x18\x00\x19\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\x25\x00\x08\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\xff\xff\x21\x00\xff\xff\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\xff\xff\x21\x00\x00\x00\x01\x00\xff\xff\x03\x00\x00\x00\x01\x00\xff\xff\x03\x00\x08\x00\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\x0c\x00\x0d\x00\xff\xff\xff\xff\x08\x00\xff\xff\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\xff\xff\x21\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x00\x00\x01\x00\xff\xff\x03\x00\x00\x00\x01\x00\xff\xff\x03\x00\x08\x00\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\x0c\x00\x0d\x00\x08\x00\xff\xff\xff\xff\xff\xff\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\xff\xff\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\xff\xff\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\xff\xff\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\xff\xff\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x01\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\x0f\x00\x10\x00\xff\xff\x12\x00\x13\x00\x14\x00\xff\xff\xff\xff\xff\xff\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\xff\xff\x20\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\x00\x00\x01\x00\xff\xff\x03\x00\x00\x00\x01\x00\xff\xff\x03\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x16\x00\x17\x00\x18\x00\x19\x00\x16\x00\x17\x00\x18\x00\x19\x00\x16\x00\x17\x00\x18\x00\x00\x00\x01\x00\xff\xff\x03\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x0a\x00\xff\xff\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\xff\xff\x16\x00\x17\x00\x18\x00\x15\x00\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x0a\x00\xff\xff\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x00\x00\x01\x00\xff\xff\x03\x00\x15\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x00\x00\x01\x00\xff\xff\x03\x00\x15\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x00\x00\x01\x00\xff\xff\x03\x00\x15\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\xff\xff\x00\x00\x01\x00\x14\x00\x03\x00\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x0c\x00\x0d\x00\xff\xff\x14\x00\x00\x00\x01\x00\x12\x00\x03\x00\xff\xff\x00\x00\x01\x00\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff"#

happyTable :: HappyAddr
happyTable = HappyA# "\x00\x00\x18\x00\x04\x00\x6e\x00\xea\xff\x95\x00\x19\x00\x43\x00\x84\x00\xea\xff\x6f\x00\x53\x00\x04\x00\x83\x00\x54\x00\x05\x00\x9d\x00\x9e\x00\xff\xff\x55\x00\x92\x00\x1a\x00\xa2\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x93\x00\x5a\x00\x18\x00\x9d\x00\x9e\x00\x96\x00\x1f\x00\x19\x00\x20\x00\x21\x00\x22\x00\x23\x00\xff\xff\x26\x00\xa3\x00\x24\x00\xa4\x00\xb7\x00\xa5\x00\x85\x00\x04\x00\x25\x00\x1a\x00\x26\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x84\x00\x26\x00\x18\x00\x9f\x00\xa0\x00\xb7\x00\x1f\x00\x19\x00\x20\x00\x21\x00\x22\x00\x23\x00\x58\x00\x37\x00\x25\x00\x87\x00\x59\x00\x9f\x00\xb2\x00\x48\x00\x04\x00\x25\x00\x1a\x00\x26\x00\x1b\x00\x1c\x00\x1d\x00\xb8\x00\x25\x00\xb9\x00\x7a\x00\x87\x00\x84\x00\x38\x00\x82\x00\x39\x00\x3a\x00\x3b\x00\x88\x00\x23\x00\x3c\x00\x37\x00\xb4\x00\xb8\x00\xb5\x00\xd3\x00\x81\x00\x7a\x00\x04\x00\x25\x00\x38\x00\x26\x00\x39\x00\x3a\x00\x3b\x00\x58\x00\x80\x00\x3c\x00\x37\x00\x04\x00\x25\x00\x38\x00\x26\x00\x39\x00\x3a\x00\x3b\x00\x75\x00\x38\x00\x3c\x00\x39\x00\x3a\x00\x3b\x00\x74\x00\x73\x00\x3c\x00\x7a\x00\x04\x00\x25\x00\x38\x00\x26\x00\x39\x00\x3a\x00\x3b\x00\x26\x00\x71\x00\x3c\x00\x37\x00\x04\x00\x25\x00\x70\x00\x26\x00\x5d\x00\x7a\x00\x04\x00\x25\x00\x38\x00\x26\x00\x39\x00\x3a\x00\x3b\x00\x5c\x00\x6e\x00\x3c\x00\x57\x00\x04\x00\x25\x00\x38\x00\x26\x00\x39\x00\x3a\x00\x3b\x00\x98\x00\x38\x00\x3c\x00\x39\x00\x3a\x00\x3b\x00\x9d\x00\x9e\x00\x3c\x00\x18\x00\x04\x00\x25\x00\x1a\x00\x26\x00\x1b\x00\x1c\x00\x1d\x00\x9d\x00\x9e\x00\x9d\x00\x9e\x00\x04\x00\x25\x00\x9c\x00\x26\x00\x9d\x00\x9e\x00\x04\x00\x25\x00\x1a\x00\x26\x00\x1b\x00\x1c\x00\x1d\x00\x9d\x00\x9e\x00\x9d\x00\x9e\x00\x04\x00\x25\x00\x3f\x00\x26\x00\x3f\x00\x06\x00\x27\x00\xcd\x00\x08\x00\xb5\x00\x9f\x00\xb1\x00\x97\x00\x2a\x00\x2b\x00\x83\x00\x75\x00\x04\x00\x25\x00\x91\x00\x26\x00\x9f\x00\xab\x00\x9f\x00\xa8\x00\x76\x00\x77\x00\x55\x00\x8a\x00\x9f\x00\xa7\x00\x40\x00\x78\x00\x40\x00\x41\x00\x87\x00\x99\x00\x88\x00\x9f\x00\xc9\x00\x9f\x00\xd2\x00\x06\x00\x07\x00\xb7\x00\x08\x00\x25\x00\x09\x00\x0a\x00\x50\x00\x0b\x00\x51\x00\xb4\x00\xb1\x00\xab\x00\x52\x00\xad\x00\xaa\x00\xa7\x00\xcc\x00\xcb\x00\xc9\x00\xc7\x00\xc6\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\xc5\x00\x06\x00\x07\x00\xc3\x00\x08\x00\xc2\x00\x16\x00\x5a\x00\x25\x00\x0b\x00\xbb\x00\xd1\x00\xd0\x00\xcf\x00\x29\x00\x26\x00\x71\x00\xb7\x00\x8f\x00\x93\x00\xbb\x00\x00\x00\xd1\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x2a\x00\x2b\x00\x00\x00\x2c\x00\x00\x00\x00\x00\x16\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x3c\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x2a\x00\x2b\x00\x00\x00\x2c\x00\x34\x00\x2a\x00\x2b\x00\x00\x00\x75\x00\x2d\x00\x00\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x76\x00\x77\x00\x00\x00\x35\x00\x34\x00\x00\x00\x00\x00\xad\x00\x00\x00\x00\x00\x2a\x00\x2b\x00\x00\x00\x2c\x00\x06\x00\x27\x00\x00\x00\x08\x00\x00\x00\x2d\x00\x35\x00\x8b\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x06\x00\x07\x00\x00\x00\x08\x00\x34\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x0c\x00\x0d\x00\x0e\x00\x61\x00\x06\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x35\x00\x3d\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x43\x00\x00\x00\x44\x00\x00\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x43\x00\x00\x00\xa5\x00\x06\x00\x07\x00\x00\x00\x08\x00\x2a\x00\x2b\x00\x00\x00\x75\x00\x3d\x00\x00\x00\x00\x00\x00\x00\x06\x00\x07\x00\x00\x00\x08\x00\x76\x00\x8a\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x43\x00\x00\x00\x9c\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x46\x00\x06\x00\x07\x00\x00\x00\x08\x00\x2a\x00\x2b\x00\x00\x00\x75\x00\x3d\x00\x00\x00\x06\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x76\x00\xd4\x00\x3d\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x3e\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x6c\x00\x06\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x06\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x5e\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x5d\x00\x06\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x06\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x9a\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x98\x00\x06\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x06\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x8d\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\xc7\x00\x06\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x06\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\xc3\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\xd6\x00\x49\x00\x06\x00\x27\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x27\x00\x00\x00\x08\x00\x4a\x00\x4b\x00\x00\x00\x4c\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x6b\x00\x00\x00\x4f\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x65\x00\x06\x00\x27\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x06\x00\x27\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x06\x00\x27\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x6a\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x69\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x68\x00\x06\x00\x27\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x06\x00\x27\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x06\x00\x27\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x67\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x66\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x62\x00\x06\x00\x27\x00\x00\x00\x08\x00\x00\x00\x06\x00\x27\x00\x00\x00\x08\x00\x00\x00\x06\x00\x27\x00\x00\x00\x08\x00\x06\x00\x27\x00\x00\x00\x08\x00\x06\x00\x27\x00\x00\x00\x08\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x64\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x63\x00\x0c\x00\x0d\x00\x0e\x00\x60\x00\x0c\x00\x0d\x00\x0e\x00\x5f\x00\x0c\x00\x0d\x00\x45\x00\x06\x00\x27\x00\x00\x00\x08\x00\x2a\x00\x2b\x00\x00\x00\x7b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7d\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x00\x00\x0c\x00\x0d\x00\x28\x00\x7e\x00\x2a\x00\x2b\x00\x00\x00\x7b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x8e\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x2a\x00\x7a\x00\x00\x00\x7b\x00\x7e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x2a\x00\x2b\x00\x00\x00\x7b\x00\x7c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x2a\x00\x2b\x00\x00\x00\x7b\x00\x7c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x32\x00\xae\x00\x00\x00\x2a\x00\x2b\x00\xaf\x00\x7b\x00\x00\x00\x2a\x00\xbc\x00\x00\x00\xbd\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x32\x00\xae\x00\xbe\x00\xbf\x00\x00\x00\xcc\x00\x2a\x00\x2b\x00\xc0\x00\x7b\x00\x00\x00\x2a\x00\x2b\x00\x00\x00\x7b\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x8c\x00\x2f\x00\x30\x00\x31\x00\x32\x00\xd5\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyReduceArr = Happy_Data_Array.array (2, 117) [
	(2 , happyReduce_2),
	(3 , happyReduce_3),
	(4 , happyReduce_4),
	(5 , happyReduce_5),
	(6 , happyReduce_6),
	(7 , happyReduce_7),
	(8 , happyReduce_8),
	(9 , happyReduce_9),
	(10 , happyReduce_10),
	(11 , happyReduce_11),
	(12 , happyReduce_12),
	(13 , happyReduce_13),
	(14 , happyReduce_14),
	(15 , happyReduce_15),
	(16 , happyReduce_16),
	(17 , happyReduce_17),
	(18 , happyReduce_18),
	(19 , happyReduce_19),
	(20 , happyReduce_20),
	(21 , happyReduce_21),
	(22 , happyReduce_22),
	(23 , happyReduce_23),
	(24 , happyReduce_24),
	(25 , happyReduce_25),
	(26 , happyReduce_26),
	(27 , happyReduce_27),
	(28 , happyReduce_28),
	(29 , happyReduce_29),
	(30 , happyReduce_30),
	(31 , happyReduce_31),
	(32 , happyReduce_32),
	(33 , happyReduce_33),
	(34 , happyReduce_34),
	(35 , happyReduce_35),
	(36 , happyReduce_36),
	(37 , happyReduce_37),
	(38 , happyReduce_38),
	(39 , happyReduce_39),
	(40 , happyReduce_40),
	(41 , happyReduce_41),
	(42 , happyReduce_42),
	(43 , happyReduce_43),
	(44 , happyReduce_44),
	(45 , happyReduce_45),
	(46 , happyReduce_46),
	(47 , happyReduce_47),
	(48 , happyReduce_48),
	(49 , happyReduce_49),
	(50 , happyReduce_50),
	(51 , happyReduce_51),
	(52 , happyReduce_52),
	(53 , happyReduce_53),
	(54 , happyReduce_54),
	(55 , happyReduce_55),
	(56 , happyReduce_56),
	(57 , happyReduce_57),
	(58 , happyReduce_58),
	(59 , happyReduce_59),
	(60 , happyReduce_60),
	(61 , happyReduce_61),
	(62 , happyReduce_62),
	(63 , happyReduce_63),
	(64 , happyReduce_64),
	(65 , happyReduce_65),
	(66 , happyReduce_66),
	(67 , happyReduce_67),
	(68 , happyReduce_68),
	(69 , happyReduce_69),
	(70 , happyReduce_70),
	(71 , happyReduce_71),
	(72 , happyReduce_72),
	(73 , happyReduce_73),
	(74 , happyReduce_74),
	(75 , happyReduce_75),
	(76 , happyReduce_76),
	(77 , happyReduce_77),
	(78 , happyReduce_78),
	(79 , happyReduce_79),
	(80 , happyReduce_80),
	(81 , happyReduce_81),
	(82 , happyReduce_82),
	(83 , happyReduce_83),
	(84 , happyReduce_84),
	(85 , happyReduce_85),
	(86 , happyReduce_86),
	(87 , happyReduce_87),
	(88 , happyReduce_88),
	(89 , happyReduce_89),
	(90 , happyReduce_90),
	(91 , happyReduce_91),
	(92 , happyReduce_92),
	(93 , happyReduce_93),
	(94 , happyReduce_94),
	(95 , happyReduce_95),
	(96 , happyReduce_96),
	(97 , happyReduce_97),
	(98 , happyReduce_98),
	(99 , happyReduce_99),
	(100 , happyReduce_100),
	(101 , happyReduce_101),
	(102 , happyReduce_102),
	(103 , happyReduce_103),
	(104 , happyReduce_104),
	(105 , happyReduce_105),
	(106 , happyReduce_106),
	(107 , happyReduce_107),
	(108 , happyReduce_108),
	(109 , happyReduce_109),
	(110 , happyReduce_110),
	(111 , happyReduce_111),
	(112 , happyReduce_112),
	(113 , happyReduce_113),
	(114 , happyReduce_114),
	(115 , happyReduce_115),
	(116 , happyReduce_116),
	(117 , happyReduce_117)
	]

happy_n_terms = 54 :: Int
happy_n_nonterms = 46 :: Int

happyReduce_2 = happySpecReduce_1  0# happyReduction_2
happyReduction_2 happy_x_1
	 =  case happyOutTok happy_x_1 of { (PT _ (TI happy_var_1)) -> 
	happyIn5
		 ((read ( happy_var_1)) :: Integer
	)}

happyReduce_3 = happySpecReduce_1  1# happyReduction_3
happyReduction_3 happy_x_1
	 =  case happyOutTok happy_x_1 of { (PT _ (T_TIdent happy_var_1)) -> 
	happyIn6
		 (TIdent (happy_var_1)
	)}

happyReduce_4 = happySpecReduce_1  2# happyReduction_4
happyReduction_4 happy_x_1
	 =  case happyOutTok happy_x_1 of { (PT _ (T_TPolyIdent happy_var_1)) -> 
	happyIn7
		 (TPolyIdent (happy_var_1)
	)}

happyReduce_5 = happySpecReduce_1  3# happyReduction_5
happyReduction_5 happy_x_1
	 =  case happyOutTok happy_x_1 of { (PT _ (T_VIdent happy_var_1)) -> 
	happyIn8
		 (VIdent (happy_var_1)
	)}

happyReduce_6 = happySpecReduce_1  4# happyReduction_6
happyReduction_6 happy_x_1
	 =  case happyOut12 happy_x_1 of { happy_var_1 -> 
	happyIn9
		 (AbsBeatle.Prog (reverse happy_var_1)
	)}

happyReduce_7 = happySpecReduce_2  5# happyReduction_7
happyReduction_7 happy_x_2
	happy_x_1
	 =  case happyOut11 happy_x_1 of { happy_var_1 -> 
	happyIn10
		 (AbsBeatle.Line happy_var_1
	)}

happyReduce_8 = happySpecReduce_1  6# happyReduction_8
happyReduction_8 happy_x_1
	 =  case happyOut13 happy_x_1 of { happy_var_1 -> 
	happyIn11
		 (AbsBeatle.Value happy_var_1
	)}

happyReduce_9 = happySpecReduce_1  6# happyReduction_9
happyReduction_9 happy_x_1
	 =  case happyOut36 happy_x_1 of { happy_var_1 -> 
	happyIn11
		 (AbsBeatle.Expression happy_var_1
	)}

happyReduce_10 = happySpecReduce_1  6# happyReduction_10
happyReduction_10 happy_x_1
	 =  case happyOut43 happy_x_1 of { happy_var_1 -> 
	happyIn11
		 (AbsBeatle.TypeDecl happy_var_1
	)}

happyReduce_11 = happySpecReduce_0  7# happyReduction_11
happyReduction_11  =  happyIn12
		 ([]
	)

happyReduce_12 = happySpecReduce_3  7# happyReduction_12
happyReduction_12 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut12 happy_x_1 of { happy_var_1 -> 
	case happyOut11 happy_x_2 of { happy_var_2 -> 
	happyIn12
		 (flip (:) happy_var_1 happy_var_2
	)}}

happyReduce_13 = happySpecReduce_2  8# happyReduction_13
happyReduction_13 happy_x_2
	happy_x_1
	 =  case happyOut16 happy_x_2 of { happy_var_2 -> 
	happyIn13
		 (AbsBeatle.Let happy_var_2
	)}

happyReduce_14 = happySpecReduce_2  8# happyReduction_14
happyReduction_14 happy_x_2
	happy_x_1
	 =  case happyOut16 happy_x_2 of { happy_var_2 -> 
	happyIn13
		 (AbsBeatle.LetRec happy_var_2
	)}

happyReduce_15 = happySpecReduce_3  9# happyReduction_15
happyReduction_15 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut26 happy_x_1 of { happy_var_1 -> 
	case happyOut36 happy_x_3 of { happy_var_3 -> 
	happyIn14
		 (AbsBeatle.ConstBind happy_var_1 happy_var_3
	)}}

happyReduce_16 = happyReduce 5# 9# happyReduction_16
happyReduction_16 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut42 happy_x_1 of { happy_var_1 -> 
	case happyOut15 happy_x_2 of { happy_var_2 -> 
	case happyOut50 happy_x_3 of { happy_var_3 -> 
	case happyOut36 happy_x_5 of { happy_var_5 -> 
	happyIn14
		 (AbsBeatle.ProcBind happy_var_1 happy_var_2 happy_var_3 happy_var_5
	) `HappyStk` happyRest}}}}

happyReduce_17 = happySpecReduce_1  10# happyReduction_17
happyReduction_17 happy_x_1
	 =  case happyOut26 happy_x_1 of { happy_var_1 -> 
	happyIn15
		 ((:[]) happy_var_1
	)}

happyReduce_18 = happySpecReduce_2  10# happyReduction_18
happyReduction_18 happy_x_2
	happy_x_1
	 =  case happyOut26 happy_x_1 of { happy_var_1 -> 
	case happyOut15 happy_x_2 of { happy_var_2 -> 
	happyIn15
		 ((:) happy_var_1 happy_var_2
	)}}

happyReduce_19 = happySpecReduce_1  11# happyReduction_19
happyReduction_19 happy_x_1
	 =  case happyOut14 happy_x_1 of { happy_var_1 -> 
	happyIn16
		 ((:[]) happy_var_1
	)}

happyReduce_20 = happySpecReduce_3  11# happyReduction_20
happyReduction_20 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut14 happy_x_1 of { happy_var_1 -> 
	case happyOut16 happy_x_3 of { happy_var_3 -> 
	happyIn16
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_21 = happySpecReduce_1  12# happyReduction_21
happyReduction_21 happy_x_1
	 =  case happyOut8 happy_x_1 of { happy_var_1 -> 
	happyIn17
		 (AbsBeatle.PId happy_var_1
	)}

happyReduce_22 = happySpecReduce_1  12# happyReduction_22
happyReduction_22 happy_x_1
	 =  case happyOut5 happy_x_1 of { happy_var_1 -> 
	happyIn17
		 (AbsBeatle.PInt happy_var_1
	)}

happyReduce_23 = happySpecReduce_1  12# happyReduction_23
happyReduction_23 happy_x_1
	 =  happyIn17
		 (AbsBeatle.PTrue
	)

happyReduce_24 = happySpecReduce_1  12# happyReduction_24
happyReduction_24 happy_x_1
	 =  happyIn17
		 (AbsBeatle.PFalse
	)

happyReduce_25 = happySpecReduce_1  12# happyReduction_25
happyReduction_25 happy_x_1
	 =  happyIn17
		 (AbsBeatle.PWildcard
	)

happyReduce_26 = happySpecReduce_1  12# happyReduction_26
happyReduction_26 happy_x_1
	 =  happyIn17
		 (AbsBeatle.PListEmpty
	)

happyReduce_27 = happySpecReduce_1  12# happyReduction_27
happyReduction_27 happy_x_1
	 =  case happyOut6 happy_x_1 of { happy_var_1 -> 
	happyIn17
		 (AbsBeatle.PTypeAlg happy_var_1
	)}

happyReduce_28 = happyReduce 5# 12# happyReduction_28
happyReduction_28 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut26 happy_x_2 of { happy_var_2 -> 
	case happyOut49 happy_x_4 of { happy_var_4 -> 
	happyIn17
		 (AbsBeatle.PTyped happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_29 = happySpecReduce_3  12# happyReduction_29
happyReduction_29 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut26 happy_x_2 of { happy_var_2 -> 
	happyIn17
		 (happy_var_2
	)}

happyReduce_30 = happySpecReduce_3  13# happyReduction_30
happyReduction_30 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut24 happy_x_2 of { happy_var_2 -> 
	happyIn18
		 (AbsBeatle.PList happy_var_2
	)}

happyReduce_31 = happySpecReduce_1  13# happyReduction_31
happyReduction_31 happy_x_1
	 =  case happyOut17 happy_x_1 of { happy_var_1 -> 
	happyIn18
		 (happy_var_1
	)}

happyReduce_32 = happyReduce 4# 14# happyReduction_32
happyReduction_32 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut6 happy_x_2 of { happy_var_2 -> 
	case happyOut22 happy_x_3 of { happy_var_3 -> 
	happyIn19
		 (AbsBeatle.PTypeAlgRec happy_var_2 happy_var_3
	) `HappyStk` happyRest}}

happyReduce_33 = happySpecReduce_1  14# happyReduction_33
happyReduction_33 happy_x_1
	 =  case happyOut18 happy_x_1 of { happy_var_1 -> 
	happyIn19
		 (happy_var_1
	)}

happyReduce_34 = happySpecReduce_3  15# happyReduction_34
happyReduction_34 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut8 happy_x_1 of { happy_var_1 -> 
	case happyOut18 happy_x_3 of { happy_var_3 -> 
	happyIn20
		 (AbsBeatle.PNamedPat happy_var_1 happy_var_3
	)}}

happyReduce_35 = happySpecReduce_1  15# happyReduction_35
happyReduction_35 happy_x_1
	 =  case happyOut19 happy_x_1 of { happy_var_1 -> 
	happyIn20
		 (happy_var_1
	)}

happyReduce_36 = happySpecReduce_3  16# happyReduction_36
happyReduction_36 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut17 happy_x_1 of { happy_var_1 -> 
	case happyOut21 happy_x_3 of { happy_var_3 -> 
	happyIn21
		 (AbsBeatle.PListCons happy_var_1 happy_var_3
	)}}

happyReduce_37 = happySpecReduce_1  16# happyReduction_37
happyReduction_37 happy_x_1
	 =  case happyOut20 happy_x_1 of { happy_var_1 -> 
	happyIn21
		 (happy_var_1
	)}

happyReduce_38 = happySpecReduce_1  17# happyReduction_38
happyReduction_38 happy_x_1
	 =  happyIn22
		 (AbsBeatle.PAlgWild
	)

happyReduce_39 = happySpecReduce_3  17# happyReduction_39
happyReduction_39 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut25 happy_x_2 of { happy_var_2 -> 
	happyIn22
		 (AbsBeatle.PAlgList happy_var_2
	)}

happyReduce_40 = happySpecReduce_1  18# happyReduction_40
happyReduction_40 happy_x_1
	 =  case happyOut18 happy_x_1 of { happy_var_1 -> 
	happyIn23
		 (AbsBeatle.CPattern happy_var_1
	)}

happyReduce_41 = happySpecReduce_2  18# happyReduction_41
happyReduction_41 happy_x_2
	happy_x_1
	 =  case happyOut6 happy_x_1 of { happy_var_1 -> 
	case happyOut22 happy_x_2 of { happy_var_2 -> 
	happyIn23
		 (AbsBeatle.CTypeAlgRec happy_var_1 happy_var_2
	)}}

happyReduce_42 = happySpecReduce_3  18# happyReduction_42
happyReduction_42 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut8 happy_x_1 of { happy_var_1 -> 
	case happyOut18 happy_x_3 of { happy_var_3 -> 
	happyIn23
		 (AbsBeatle.CNamedPat happy_var_1 happy_var_3
	)}}

happyReduce_43 = happySpecReduce_3  18# happyReduction_43
happyReduction_43 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut17 happy_x_1 of { happy_var_1 -> 
	case happyOut21 happy_x_3 of { happy_var_3 -> 
	happyIn23
		 (AbsBeatle.CListCons happy_var_1 happy_var_3
	)}}

happyReduce_44 = happySpecReduce_1  19# happyReduction_44
happyReduction_44 happy_x_1
	 =  case happyOut18 happy_x_1 of { happy_var_1 -> 
	happyIn24
		 ((:[]) happy_var_1
	)}

happyReduce_45 = happySpecReduce_3  19# happyReduction_45
happyReduction_45 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut18 happy_x_1 of { happy_var_1 -> 
	case happyOut24 happy_x_3 of { happy_var_3 -> 
	happyIn24
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_46 = happySpecReduce_0  20# happyReduction_46
happyReduction_46  =  happyIn25
		 ([]
	)

happyReduce_47 = happySpecReduce_1  20# happyReduction_47
happyReduction_47 happy_x_1
	 =  case happyOut21 happy_x_1 of { happy_var_1 -> 
	happyIn25
		 ((:[]) happy_var_1
	)}

happyReduce_48 = happySpecReduce_3  20# happyReduction_48
happyReduction_48 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut21 happy_x_1 of { happy_var_1 -> 
	case happyOut25 happy_x_3 of { happy_var_3 -> 
	happyIn25
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_49 = happySpecReduce_1  21# happyReduction_49
happyReduction_49 happy_x_1
	 =  case happyOut21 happy_x_1 of { happy_var_1 -> 
	happyIn26
		 (happy_var_1
	)}

happyReduce_50 = happySpecReduce_1  22# happyReduction_50
happyReduction_50 happy_x_1
	 =  case happyOut8 happy_x_1 of { happy_var_1 -> 
	happyIn27
		 (AbsBeatle.EId happy_var_1
	)}

happyReduce_51 = happySpecReduce_1  22# happyReduction_51
happyReduction_51 happy_x_1
	 =  case happyOut5 happy_x_1 of { happy_var_1 -> 
	happyIn27
		 (AbsBeatle.EInt happy_var_1
	)}

happyReduce_52 = happySpecReduce_1  22# happyReduction_52
happyReduction_52 happy_x_1
	 =  happyIn27
		 (AbsBeatle.ETrue
	)

happyReduce_53 = happySpecReduce_1  22# happyReduction_53
happyReduction_53 happy_x_1
	 =  happyIn27
		 (AbsBeatle.EFalse
	)

happyReduce_54 = happySpecReduce_1  22# happyReduction_54
happyReduction_54 happy_x_1
	 =  happyIn27
		 (AbsBeatle.EListEmpty
	)

happyReduce_55 = happySpecReduce_1  22# happyReduction_55
happyReduction_55 happy_x_1
	 =  case happyOut6 happy_x_1 of { happy_var_1 -> 
	happyIn27
		 (AbsBeatle.ETypeAlg happy_var_1
	)}

happyReduce_56 = happySpecReduce_3  22# happyReduction_56
happyReduction_56 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut38 happy_x_2 of { happy_var_2 -> 
	happyIn27
		 (AbsBeatle.EList happy_var_2
	)}

happyReduce_57 = happySpecReduce_3  22# happyReduction_57
happyReduction_57 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut36 happy_x_2 of { happy_var_2 -> 
	happyIn27
		 (happy_var_2
	)}

happyReduce_58 = happySpecReduce_2  23# happyReduction_58
happyReduction_58 happy_x_2
	happy_x_1
	 =  case happyOut28 happy_x_1 of { happy_var_1 -> 
	case happyOut27 happy_x_2 of { happy_var_2 -> 
	happyIn28
		 (AbsBeatle.EApp happy_var_1 happy_var_2
	)}}

happyReduce_59 = happySpecReduce_1  23# happyReduction_59
happyReduction_59 happy_x_1
	 =  case happyOut27 happy_x_1 of { happy_var_1 -> 
	happyIn28
		 (happy_var_1
	)}

happyReduce_60 = happyReduce 5# 24# happyReduction_60
happyReduction_60 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut36 happy_x_2 of { happy_var_2 -> 
	case happyOut49 happy_x_4 of { happy_var_4 -> 
	happyIn29
		 (AbsBeatle.ETyped happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_61 = happySpecReduce_1  24# happyReduction_61
happyReduction_61 happy_x_1
	 =  case happyOut28 happy_x_1 of { happy_var_1 -> 
	happyIn29
		 (happy_var_1
	)}

happyReduce_62 = happySpecReduce_2  25# happyReduction_62
happyReduction_62 happy_x_2
	happy_x_1
	 =  case happyOut29 happy_x_2 of { happy_var_2 -> 
	happyIn30
		 (AbsBeatle.ENeg happy_var_2
	)}

happyReduce_63 = happySpecReduce_2  25# happyReduction_63
happyReduction_63 happy_x_2
	happy_x_1
	 =  case happyOut29 happy_x_2 of { happy_var_2 -> 
	happyIn30
		 (AbsBeatle.ENot happy_var_2
	)}

happyReduce_64 = happySpecReduce_1  25# happyReduction_64
happyReduction_64 happy_x_1
	 =  case happyOut29 happy_x_1 of { happy_var_1 -> 
	happyIn30
		 (happy_var_1
	)}

happyReduce_65 = happySpecReduce_3  26# happyReduction_65
happyReduction_65 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut31 happy_x_1 of { happy_var_1 -> 
	case happyOut30 happy_x_3 of { happy_var_3 -> 
	happyIn31
		 (AbsBeatle.EMul happy_var_1 happy_var_3
	)}}

happyReduce_66 = happySpecReduce_3  26# happyReduction_66
happyReduction_66 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut31 happy_x_1 of { happy_var_1 -> 
	case happyOut30 happy_x_3 of { happy_var_3 -> 
	happyIn31
		 (AbsBeatle.EDiv happy_var_1 happy_var_3
	)}}

happyReduce_67 = happySpecReduce_3  26# happyReduction_67
happyReduction_67 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut31 happy_x_1 of { happy_var_1 -> 
	case happyOut30 happy_x_3 of { happy_var_3 -> 
	happyIn31
		 (AbsBeatle.EMod happy_var_1 happy_var_3
	)}}

happyReduce_68 = happySpecReduce_1  26# happyReduction_68
happyReduction_68 happy_x_1
	 =  case happyOut30 happy_x_1 of { happy_var_1 -> 
	happyIn31
		 (happy_var_1
	)}

happyReduce_69 = happySpecReduce_3  27# happyReduction_69
happyReduction_69 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut31 happy_x_3 of { happy_var_3 -> 
	happyIn32
		 (AbsBeatle.EAdd happy_var_1 happy_var_3
	)}}

happyReduce_70 = happySpecReduce_3  27# happyReduction_70
happyReduction_70 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut31 happy_x_3 of { happy_var_3 -> 
	happyIn32
		 (AbsBeatle.ESub happy_var_1 happy_var_3
	)}}

happyReduce_71 = happySpecReduce_1  27# happyReduction_71
happyReduction_71 happy_x_1
	 =  case happyOut31 happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (happy_var_1
	)}

happyReduce_72 = happySpecReduce_3  28# happyReduction_72
happyReduction_72 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn33
		 (AbsBeatle.EListCons happy_var_1 happy_var_3
	)}}

happyReduce_73 = happySpecReduce_1  28# happyReduction_73
happyReduction_73 happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	happyIn33
		 (happy_var_1
	)}

happyReduce_74 = happySpecReduce_3  29# happyReduction_74
happyReduction_74 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut34 happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (AbsBeatle.ELTH happy_var_1 happy_var_3
	)}}

happyReduce_75 = happySpecReduce_3  29# happyReduction_75
happyReduction_75 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut34 happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (AbsBeatle.ELE happy_var_1 happy_var_3
	)}}

happyReduce_76 = happySpecReduce_3  29# happyReduction_76
happyReduction_76 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut34 happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (AbsBeatle.EGTH happy_var_1 happy_var_3
	)}}

happyReduce_77 = happySpecReduce_3  29# happyReduction_77
happyReduction_77 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut34 happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (AbsBeatle.EGE happy_var_1 happy_var_3
	)}}

happyReduce_78 = happySpecReduce_3  29# happyReduction_78
happyReduction_78 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut34 happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (AbsBeatle.EEQU happy_var_1 happy_var_3
	)}}

happyReduce_79 = happySpecReduce_3  29# happyReduction_79
happyReduction_79 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut34 happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (AbsBeatle.ENE happy_var_1 happy_var_3
	)}}

happyReduce_80 = happySpecReduce_1  29# happyReduction_80
happyReduction_80 happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	happyIn34
		 (happy_var_1
	)}

happyReduce_81 = happySpecReduce_3  30# happyReduction_81
happyReduction_81 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut34 happy_x_1 of { happy_var_1 -> 
	case happyOut35 happy_x_3 of { happy_var_3 -> 
	happyIn35
		 (AbsBeatle.EAnd happy_var_1 happy_var_3
	)}}

happyReduce_82 = happySpecReduce_1  30# happyReduction_82
happyReduction_82 happy_x_1
	 =  case happyOut34 happy_x_1 of { happy_var_1 -> 
	happyIn35
		 (happy_var_1
	)}

happyReduce_83 = happySpecReduce_3  31# happyReduction_83
happyReduction_83 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut35 happy_x_1 of { happy_var_1 -> 
	case happyOut36 happy_x_3 of { happy_var_3 -> 
	happyIn36
		 (AbsBeatle.EOr happy_var_1 happy_var_3
	)}}

happyReduce_84 = happyReduce 6# 31# happyReduction_84
happyReduction_84 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut36 happy_x_2 of { happy_var_2 -> 
	case happyOut36 happy_x_4 of { happy_var_4 -> 
	case happyOut36 happy_x_6 of { happy_var_6 -> 
	happyIn36
		 (AbsBeatle.ECond happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest}}}

happyReduce_85 = happySpecReduce_3  31# happyReduction_85
happyReduction_85 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut13 happy_x_1 of { happy_var_1 -> 
	case happyOut36 happy_x_3 of { happy_var_3 -> 
	happyIn36
		 (AbsBeatle.ELetIn happy_var_1 happy_var_3
	)}}

happyReduce_86 = happyReduce 6# 31# happyReduction_86
happyReduction_86 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut8 happy_x_2 of { happy_var_2 -> 
	case happyOut39 happy_x_5 of { happy_var_5 -> 
	happyIn36
		 (AbsBeatle.EMatch happy_var_2 happy_var_5
	) `HappyStk` happyRest}}

happyReduce_87 = happyReduce 4# 31# happyReduction_87
happyReduction_87 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut40 happy_x_2 of { happy_var_2 -> 
	case happyOut36 happy_x_4 of { happy_var_4 -> 
	happyIn36
		 (AbsBeatle.ELambda happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_88 = happyReduce 5# 31# happyReduction_88
happyReduction_88 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut6 happy_x_1 of { happy_var_1 -> 
	case happyOut38 happy_x_4 of { happy_var_4 -> 
	happyIn36
		 (AbsBeatle.ETypeCons happy_var_1 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_89 = happySpecReduce_1  31# happyReduction_89
happyReduction_89 happy_x_1
	 =  case happyOut35 happy_x_1 of { happy_var_1 -> 
	happyIn36
		 (happy_var_1
	)}

happyReduce_90 = happyReduce 5# 32# happyReduction_90
happyReduction_90 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut8 happy_x_2 of { happy_var_2 -> 
	case happyOut49 happy_x_4 of { happy_var_4 -> 
	happyIn37
		 (AbsBeatle.TypedVId happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_91 = happySpecReduce_1  32# happyReduction_91
happyReduction_91 happy_x_1
	 =  case happyOut8 happy_x_1 of { happy_var_1 -> 
	happyIn37
		 (AbsBeatle.LambdaVId happy_var_1
	)}

happyReduce_92 = happySpecReduce_1  33# happyReduction_92
happyReduction_92 happy_x_1
	 =  case happyOut36 happy_x_1 of { happy_var_1 -> 
	happyIn38
		 ((:[]) happy_var_1
	)}

happyReduce_93 = happySpecReduce_3  33# happyReduction_93
happyReduction_93 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut36 happy_x_1 of { happy_var_1 -> 
	case happyOut38 happy_x_3 of { happy_var_3 -> 
	happyIn38
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_94 = happySpecReduce_1  34# happyReduction_94
happyReduction_94 happy_x_1
	 =  case happyOut41 happy_x_1 of { happy_var_1 -> 
	happyIn39
		 ((:[]) happy_var_1
	)}

happyReduce_95 = happySpecReduce_3  34# happyReduction_95
happyReduction_95 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut41 happy_x_1 of { happy_var_1 -> 
	case happyOut39 happy_x_3 of { happy_var_3 -> 
	happyIn39
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_96 = happySpecReduce_1  35# happyReduction_96
happyReduction_96 happy_x_1
	 =  case happyOut37 happy_x_1 of { happy_var_1 -> 
	happyIn40
		 ((:[]) happy_var_1
	)}

happyReduce_97 = happySpecReduce_3  35# happyReduction_97
happyReduction_97 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut37 happy_x_1 of { happy_var_1 -> 
	case happyOut40 happy_x_3 of { happy_var_3 -> 
	happyIn40
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_98 = happyReduce 4# 36# happyReduction_98
happyReduction_98 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut23 happy_x_2 of { happy_var_2 -> 
	case happyOut36 happy_x_4 of { happy_var_4 -> 
	happyIn41
		 (AbsBeatle.MatchCase happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_99 = happySpecReduce_1  37# happyReduction_99
happyReduction_99 happy_x_1
	 =  case happyOut8 happy_x_1 of { happy_var_1 -> 
	happyIn42
		 (AbsBeatle.ProcNameId happy_var_1
	)}

happyReduce_100 = happyReduce 5# 38# happyReduction_100
happyReduction_100 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut6 happy_x_2 of { happy_var_2 -> 
	case happyOut45 happy_x_3 of { happy_var_3 -> 
	case happyOut46 happy_x_5 of { happy_var_5 -> 
	happyIn43
		 (AbsBeatle.TDef happy_var_2 happy_var_3 happy_var_5
	) `HappyStk` happyRest}}}

happyReduce_101 = happySpecReduce_2  39# happyReduction_101
happyReduction_101 happy_x_2
	happy_x_1
	 =  case happyOut6 happy_x_1 of { happy_var_1 -> 
	case happyOut47 happy_x_2 of { happy_var_2 -> 
	happyIn44
		 (AbsBeatle.TCons happy_var_1 (reverse happy_var_2)
	)}}

happyReduce_102 = happySpecReduce_0  40# happyReduction_102
happyReduction_102  =  happyIn45
		 ([]
	)

happyReduce_103 = happySpecReduce_2  40# happyReduction_103
happyReduction_103 happy_x_2
	happy_x_1
	 =  case happyOut7 happy_x_1 of { happy_var_1 -> 
	case happyOut45 happy_x_2 of { happy_var_2 -> 
	happyIn45
		 ((:) happy_var_1 happy_var_2
	)}}

happyReduce_104 = happySpecReduce_1  41# happyReduction_104
happyReduction_104 happy_x_1
	 =  case happyOut44 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 ((:[]) happy_var_1
	)}

happyReduce_105 = happySpecReduce_3  41# happyReduction_105
happyReduction_105 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut44 happy_x_1 of { happy_var_1 -> 
	case happyOut46 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_106 = happySpecReduce_0  42# happyReduction_106
happyReduction_106  =  happyIn47
		 ([]
	)

happyReduce_107 = happySpecReduce_2  42# happyReduction_107
happyReduction_107 happy_x_2
	happy_x_1
	 =  case happyOut47 happy_x_1 of { happy_var_1 -> 
	case happyOut49 happy_x_2 of { happy_var_2 -> 
	happyIn47
		 (flip (:) happy_var_1 happy_var_2
	)}}

happyReduce_108 = happySpecReduce_1  43# happyReduction_108
happyReduction_108 happy_x_1
	 =  happyIn48
		 (AbsBeatle.TInt
	)

happyReduce_109 = happySpecReduce_1  43# happyReduction_109
happyReduction_109 happy_x_1
	 =  happyIn48
		 (AbsBeatle.TBool
	)

happyReduce_110 = happySpecReduce_3  43# happyReduction_110
happyReduction_110 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut49 happy_x_2 of { happy_var_2 -> 
	happyIn48
		 (AbsBeatle.TList happy_var_2
	)}

happyReduce_111 = happySpecReduce_1  43# happyReduction_111
happyReduction_111 happy_x_1
	 =  case happyOut6 happy_x_1 of { happy_var_1 -> 
	happyIn48
		 (AbsBeatle.TAlgebraic happy_var_1
	)}

happyReduce_112 = happySpecReduce_1  43# happyReduction_112
happyReduction_112 happy_x_1
	 =  case happyOut7 happy_x_1 of { happy_var_1 -> 
	happyIn48
		 (AbsBeatle.TPoly happy_var_1
	)}

happyReduce_113 = happySpecReduce_3  43# happyReduction_113
happyReduction_113 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut49 happy_x_2 of { happy_var_2 -> 
	happyIn48
		 (happy_var_2
	)}

happyReduce_114 = happySpecReduce_3  44# happyReduction_114
happyReduction_114 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut48 happy_x_1 of { happy_var_1 -> 
	case happyOut49 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (AbsBeatle.TFun happy_var_1 happy_var_3
	)}}

happyReduce_115 = happySpecReduce_1  44# happyReduction_115
happyReduction_115 happy_x_1
	 =  case happyOut48 happy_x_1 of { happy_var_1 -> 
	happyIn49
		 (happy_var_1
	)}

happyReduce_116 = happySpecReduce_0  45# happyReduction_116
happyReduction_116  =  happyIn50
		 (AbsBeatle.NoRetType
	)

happyReduce_117 = happySpecReduce_2  45# happyReduction_117
happyReduction_117 happy_x_2
	happy_x_1
	 =  case happyOut49 happy_x_2 of { happy_var_2 -> 
	happyIn50
		 (AbsBeatle.RetType happy_var_2
	)}

happyNewToken action sts stk [] =
	happyDoAction 53# notHappyAtAll action sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = happyDoAction i tk action sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 1#;
	PT _ (TS _ 2) -> cont 2#;
	PT _ (TS _ 3) -> cont 3#;
	PT _ (TS _ 4) -> cont 4#;
	PT _ (TS _ 5) -> cont 5#;
	PT _ (TS _ 6) -> cont 6#;
	PT _ (TS _ 7) -> cont 7#;
	PT _ (TS _ 8) -> cont 8#;
	PT _ (TS _ 9) -> cont 9#;
	PT _ (TS _ 10) -> cont 10#;
	PT _ (TS _ 11) -> cont 11#;
	PT _ (TS _ 12) -> cont 12#;
	PT _ (TS _ 13) -> cont 13#;
	PT _ (TS _ 14) -> cont 14#;
	PT _ (TS _ 15) -> cont 15#;
	PT _ (TS _ 16) -> cont 16#;
	PT _ (TS _ 17) -> cont 17#;
	PT _ (TS _ 18) -> cont 18#;
	PT _ (TS _ 19) -> cont 19#;
	PT _ (TS _ 20) -> cont 20#;
	PT _ (TS _ 21) -> cont 21#;
	PT _ (TS _ 22) -> cont 22#;
	PT _ (TS _ 23) -> cont 23#;
	PT _ (TS _ 24) -> cont 24#;
	PT _ (TS _ 25) -> cont 25#;
	PT _ (TS _ 26) -> cont 26#;
	PT _ (TS _ 27) -> cont 27#;
	PT _ (TS _ 28) -> cont 28#;
	PT _ (TS _ 29) -> cont 29#;
	PT _ (TS _ 30) -> cont 30#;
	PT _ (TS _ 31) -> cont 31#;
	PT _ (TS _ 32) -> cont 32#;
	PT _ (TS _ 33) -> cont 33#;
	PT _ (TS _ 34) -> cont 34#;
	PT _ (TS _ 35) -> cont 35#;
	PT _ (TS _ 36) -> cont 36#;
	PT _ (TS _ 37) -> cont 37#;
	PT _ (TS _ 38) -> cont 38#;
	PT _ (TS _ 39) -> cont 39#;
	PT _ (TS _ 40) -> cont 40#;
	PT _ (TS _ 41) -> cont 41#;
	PT _ (TS _ 42) -> cont 42#;
	PT _ (TS _ 43) -> cont 43#;
	PT _ (TS _ 44) -> cont 44#;
	PT _ (TS _ 45) -> cont 45#;
	PT _ (TS _ 46) -> cont 46#;
	PT _ (TS _ 47) -> cont 47#;
	PT _ (TS _ 48) -> cont 48#;
	PT _ (TI happy_dollar_dollar) -> cont 49#;
	PT _ (T_TIdent happy_dollar_dollar) -> cont 50#;
	PT _ (T_TPolyIdent happy_dollar_dollar) -> cont 51#;
	PT _ (T_VIdent happy_dollar_dollar) -> cont 52#;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 53# tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

happyThen :: () => Err a -> (a -> Err b) -> Err b
happyThen = (thenM)
happyReturn :: () => a -> Err a
happyReturn = (returnM)
happyThen1 m k tks = (thenM) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> Err a
happyReturn1 = \a tks -> (returnM) a
happyError' :: () => ([(Token)], [String]) -> Err a
happyError' = (\(tokens, _) -> happyError tokens)
pLine tks = happySomeParser where
 happySomeParser = happyThen (happyParse 0# tks) (\x -> happyReturn (happyOut10 x))

pProgram tks = happySomeParser where
 happySomeParser = happyThen (happyParse 1# tks) (\x -> happyReturn (happyOut9 x))

happySeq = happyDontSeq


returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    t:_ -> " before `" ++ id(prToken t) ++ "'"

myLexer = tokens
{-# LINE 1 "templates/GenericTemplate.hs" #-}

















































































































































































































-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 













-- Do not remove this comment. Required to fix CPP parsing when using GCC and a clang-compiled alex.
#if __GLASGOW_HASKELL__ > 706
#define LT(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.<# m)) :: Bool)
#define GTE(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.>=# m)) :: Bool)
#define EQ(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.==# m)) :: Bool)
#else
#define LT(n,m) (n Happy_GHC_Exts.<# m)
#define GTE(n,m) (n Happy_GHC_Exts.>=# m)
#define EQ(n,m) (n Happy_GHC_Exts.==# m)
#endif


data Happy_IntList = HappyCons Happy_GHC_Exts.Int# Happy_IntList




















infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is 0#, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept 0# tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
        (happyTcHack j (happyTcHack st)) (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action



happyDoAction i tk st
        = {- nothing -}
          

          case action of
                0#           -> {- nothing -}
                                     happyFail (happyExpListPerState ((Happy_GHC_Exts.I# (st)) :: Int)) i tk st
                -1#          -> {- nothing -}
                                     happyAccept i tk st
                n | LT(n,(0# :: Happy_GHC_Exts.Int#)) -> {- nothing -}
                                                   
                                                   (happyReduceArr Happy_Data_Array.! rule) i tk st
                                                   where rule = (Happy_GHC_Exts.I# ((Happy_GHC_Exts.negateInt# ((n Happy_GHC_Exts.+# (1# :: Happy_GHC_Exts.Int#))))))
                n                 -> {- nothing -}
                                     

                                     happyShift new_state i tk st
                                     where new_state = (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#))
   where off    = happyAdjustOffset (indexShortOffAddr happyActOffsets st)
         off_i  = (off Happy_GHC_Exts.+#  i)
         check  = if GTE(off_i,(0# :: Happy_GHC_Exts.Int#))
                  then EQ(indexShortOffAddr happyCheck off_i, i)
                  else False
         action
          | check     = indexShortOffAddr happyTable off_i
          | otherwise = indexShortOffAddr happyDefActions st




indexShortOffAddr (HappyA# arr) off =
        Happy_GHC_Exts.narrow16Int# i
  where
        i = Happy_GHC_Exts.word2Int# (Happy_GHC_Exts.or# (Happy_GHC_Exts.uncheckedShiftL# high 8#) low)
        high = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr (off' Happy_GHC_Exts.+# 1#)))
        low  = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr off'))
        off' = off Happy_GHC_Exts.*# 2#




{-# INLINE happyLt #-}
happyLt x y = LT(x,y)


readArrayBit arr bit =
    Bits.testBit (Happy_GHC_Exts.I# (indexShortOffAddr arr ((unbox_int bit) `Happy_GHC_Exts.iShiftRA#` 4#))) (bit `mod` 16)
  where unbox_int (Happy_GHC_Exts.I# x) = x






data HappyAddr = HappyA# Happy_GHC_Exts.Addr#


-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state 0# tk st sts stk@(x `HappyStk` _) =
     let i = (case Happy_GHC_Exts.unsafeCoerce# x of { (Happy_GHC_Exts.I# (i)) -> i }) in
--     trace "shifting the error token" $
     happyDoAction i tk new_state (HappyCons (st) (sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state (HappyCons (st) (sts)) ((happyInTok (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_0 nt fn j tk st@((action)) sts stk
     = happyGoto nt j tk st (HappyCons (st) (sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@((HappyCons (st@(action)) (_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_2 nt fn j tk _ (HappyCons (_) (sts@((HappyCons (st@(action)) (_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_3 nt fn j tk _ (HappyCons (_) ((HappyCons (_) (sts@((HappyCons (st@(action)) (_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) sts of
         sts1@((HappyCons (st1@(action)) (_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (happyGoto nt j tk st1 sts1 r)

happyMonadReduce k nt fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> happyGoto nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
         let drop_stk = happyDropStk k stk

             off = happyAdjustOffset (indexShortOffAddr happyGotoOffsets st1)
             off_i = (off Happy_GHC_Exts.+#  nt)
             new_state = indexShortOffAddr happyTable off_i




          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop 0# l = l
happyDrop n (HappyCons (_) (t)) = happyDrop (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) t

happyDropStk 0# l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Happy_GHC_Exts.-# (1#::Happy_GHC_Exts.Int#)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction


happyGoto nt j tk st = 
   {- nothing -}
   happyDoAction j tk new_state
   where off = happyAdjustOffset (indexShortOffAddr happyGotoOffsets st)
         off_i = (off Happy_GHC_Exts.+#  nt)
         new_state = indexShortOffAddr happyTable off_i




-----------------------------------------------------------------------------
-- Error recovery (0# is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist 0# tk old_st _ stk@(x `HappyStk` _) =
     let i = (case Happy_GHC_Exts.unsafeCoerce# x of { (Happy_GHC_Exts.I# (i)) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  0# tk old_st (HappyCons ((action)) (sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        happyDoAction 0# tk action sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (action) sts stk =
--      trace "entering error recovery" $
        happyDoAction 0# tk action sts ( (Happy_GHC_Exts.unsafeCoerce# (Happy_GHC_Exts.I# (i))) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions


happyTcHack :: Happy_GHC_Exts.Int# -> a -> a
happyTcHack x y = y
{-# INLINE happyTcHack #-}


-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.


{-# NOINLINE happyDoAction #-}
{-# NOINLINE happyTable #-}
{-# NOINLINE happyCheck #-}
{-# NOINLINE happyActOffsets #-}
{-# NOINLINE happyGotoOffsets #-}
{-# NOINLINE happyDefActions #-}

{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.

