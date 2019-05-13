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

import Lambda hiding (Expr(..))

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
        showVal (name, val, t) = (maybe "-" id name) ++ " : " ++ show t 
            ++ " = " ++ show val

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
rerun f (Left err) = putStrLn ("Fatal error: " ++ err) 
    >> putStrLn "Restarting interpreter" >> f
rerun _ (Right _) = return ()

main :: IO ()
main = (putStr . unlines $ title) >> run
