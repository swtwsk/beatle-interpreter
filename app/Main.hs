module Main where

import Control.Monad (unless)
import Control.Monad.IO.Class
import Control.Monad.State
import Control.Monad.Except
import Data.Maybe (fromMaybe)
import System.Console.Haskeline

import LexBeatle
import ParBeatle
import LayoutBeatle
import Interpreter
import Values
import Errors
import ErrM

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

showFunc :: InterRes -> IState [String]
showFunc l = return $ map showVal l
    where
        showVal (name, val, t) = fromMaybe "-" name ++ " : " ++ show t 
            ++ " = " ++ show val

process :: String -> IState ()
process line = do
    let res = pLine (myLLexer line)
    case res of
        (Bad s) -> unless (null line) $ liftIO $ putStrLn s
        (Ok s) -> (liftIO . putStr . unlines) =<< showFunc =<< interpretLine s
        
run :: Env -> IO ()
run env = runInputT defaultSettings (runStateT (runExceptT loop) env) 
    >>= rerun run
    where
        loop :: IState ()
        loop = do
            minput <- lift $ lift $ getInputLine "λ "
            case minput of
                Nothing -> return ()
                Just ":q" -> lift $ lift $ outputStrLn "Goodbye."
                Just input -> process input >> loop

rerun :: (Env -> IO ()) -> (Either InterpreterError b, Env) -> IO ()
rerun f (Left err, env) = print err >> f env
rerun _ (Right _, _) = return ()

main :: IO ()
main = (putStr . unlines $ title) >> run emptyEnv
