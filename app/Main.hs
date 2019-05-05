module Main where

import LexBeatle
import ParBeatle
import AbsBeatle
import LayoutBeatle
import Interpreter

import ErrM

import Control.Monad (unless)
import Control.Monad.IO.Class
import Control.Monad.State
import Control.Monad.Except
import Data.Maybe
import Data.List (intercalate)
import System.Console.Haskeline

import qualified Data.Map as Map

import Lambda.Lambda hiding (Expr(..))
import Types

title :: [String]
title = 
    [ "______               _    _       "
    , "| ___ \\             | |  | |      "
    , "| |_/ /  ___   __ _ | |_ | |  ___ "
    , "| ___ \\ / _ \\ / _` || __|| | / _ \\"
    , "| |_/ /|  __/| (_| || |_ | ||  __/"
    , "\\____/  \\___| \\__,_| \\__||_| \\___|"
    , " Beatle 0.1.0 REPL"
    , "                                  " ]

myLLexer :: String -> [Token]
myLLexer = resolveLayout True . myLexer

eitherFunc :: Either String InterRes -> IState [String]
eitherFunc (Left err) = return [err]
eitherFunc (Right (InterType tn l)) = 
    return ["type " ++ tn ++ " = " ++ intercalate " | " (map showType l)]
    where
        showType (name, tlist) = name ++ " " ++ unwords (map show tlist)
eitherFunc (Right (InterVal l)) = return $ map showVal l
    where
        showVal (val, t) = case val of
            VInt i -> "- : " ++ show t ++ " = " ++ show i
            VBool b -> "- : " ++ show t ++ " = " ++ show b
            VClos n _ _ -> n ++ " : " ++ show t ++ " = <fun>"
            VFixed n _ _ -> n ++ " : " ++ show t ++ " = <fun>"
            VCons v1 VNil -> 
                "- : " ++ show t ++ " = [" ++ showLeftList v1 ++ "]"
            VCons v1 v2 -> "- : " ++ show t ++ " = [" ++ showLeftList v1 ++ 
                ", " ++ showRightList v2 ++ "]"
            VNil -> "- : " ++ show t ++ "= []"
            VAlg cname tname lv -> 
                cname ++ " " ++ showList lv ++ " : " ++ tname
                where
                    showList l =
                        let lv' = map (\n -> (n, Types.TInt)) l 
                        in if length l <= 0 then "" 
                        else "(" ++ intercalate ", " (map showVal lv') ++ ")"
        showLeftList v = case v of
            VInt i -> show i
            VBool b -> show b
            VClos {} -> "<fun>"
            VFixed {} -> "<fun>"
            VCons v1 VNil -> "[" ++ showLeftList v1 ++ "]"
            VCons v1 v2 -> "[" ++ showLeftList v1 ++ ", " ++ showRightList v2 ++ "]"
            VNil -> "[]"
        showRightList v = case v of
            VCons v1 VNil -> showLeftList v1
            VCons v1 v2 -> showLeftList v1 ++ ", " ++ showRightList v2
            VNil -> ""

process :: String -> IState ()
process line = do
    let res = pLine (myLLexer line)
    case res of
        (Bad s) -> unless (null line) $ liftIO $ putStrLn $ "err: " ++ s
        (Ok s) -> (liftIO . putStr . unlines) =<< eitherFunc =<< interpretLine s
        -- (Ok s) -> print $ map eitherFunc (interpretLine s)
        
run :: IO ()
run = runInputT defaultSettings (runExceptT $ runStateT loop emptyEnv) >>= rerun run
    where
        loop :: IState ()
        loop = do
            minput <- lift $ lift $ getInputLine "λ "
            case minput of
                Nothing -> return ()
                Just ":q" -> lift $ lift $ outputStrLn "Goodbye."
                Just input -> process input >> loop

rerun :: IO () -> Either String b -> IO ()
rerun f (Left err) = putStrLn ("Error: " ++ err) >> f
rerun _ (Right _) = return ()

main :: IO ()
main = (putStr . unlines $ title) >> run