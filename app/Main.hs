module Main where

import LexBeatle
import ParBeatle
import LayoutBeatle
import Interpreter
import Values
import ErrM

import Control.Monad (unless)
import Control.Monad.IO.Class
import Control.Monad.State
import Control.Monad.Except
import Data.List (intercalate)
import Data.Maybe (fromMaybe)
import System.Console.Haskeline

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
eitherFunc (Right l) = return $ map showVal l
    where
        showVal (name, val, t) = fromMaybe "-" name ++ " : " ++ show t 
            ++ " = " ++ show val

process :: String -> IState ()
process line = do
    let res = pLine (myLLexer line)
    case res of
        (Bad s) -> unless (null line) $ liftIO $ putStrLn s
        (Ok s) -> (liftIO . putStr . unlines) =<< eitherFunc =<< interpretLine s
        
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
