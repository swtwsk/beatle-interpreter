module Main where

import LexBeatle
import ParBeatle
import AbsBeatle
import LayoutBeatle
import Interpreter

import ErrM

import Control.Monad.IO.Class
import Control.Monad.State
import Control.Monad.Except
import Data.Maybe
import System.Console.Haskeline

import qualified Data.Map as Map

import qualified Lambda.Lambda as L

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

eitherFunc :: Either String [L.Value] -> IState [String]
eitherFunc (Left err) = return [err]
eitherFunc (Right l) = return $ map showVal l
    where
        showVal val = case val of
            L.VInt i -> show i ++ " : int"
            L.VBool b -> show b ++ " : bool"
            L.VClos n _ _ -> n ++ " = <fun>"
            L.VFixed n _ _ -> n ++ " = <fun>"
            -- clos@(L.VClos _ _ : t) -> "<<" ++ show . length clos ++ " functions>>"

process :: String -> IState ()
process line = do
    let res = pLine (myLLexer line)
    case res of
        (Bad s) -> if null line then return () else liftIO $ putStrLn "err"
        (Ok s) -> (liftIO . putStr . unlines) =<< eitherFunc =<< interpretLine s
        -- (Ok s) -> print $ map eitherFunc (interpretLine s)

main :: IO ()
main = (putStr . unlines $ title) >> run
    where
        run :: IO ()
        run = runInputT defaultSettings (runExceptT $ runStateT loop Map.empty) >>= rerun run
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
