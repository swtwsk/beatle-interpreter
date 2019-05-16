module Main where

import Control.Monad (unless)
import Control.Monad.IO.Class
import Control.Monad.State
import Control.Monad.Except
import Data.Maybe (fromMaybe)
import System.Console.Haskeline
import System.IO
import System.Environment
import System.Exit

import AbsBeatle
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
    , " Beatle 1.0.0 REPL"
    , "                                  " ]

myLLexer :: String -> [Token]
myLLexer = resolveLayout True . myLexer

showFunc :: Result -> IState [String]
showFunc l = return $ map showVal l
    where
        showVal (name, val, t) = fromMaybe "-" name ++ " : " ++ show t 
            ++ " = " ++ show val

process :: String -> IState ()
process line = do
    let res = pLine (myLLexer line)
    case res of
        (Bad s) -> unless (null line) $ liftIO $ putStrLn "Parse error"
        (Ok s)  -> (liftIO . putStr . unlines) =<< showFunc =<< interpretLine s

processProg :: String -> IState ()
processProg prog = do
    let res = pProgram (myLLexer prog)
    case res of
        (Bad s) -> liftIO $ do
            _ <- hPutStrLn stderr $ "Parse error"
            exitWith (ExitFailure 1)
        (Ok s) -> do
            ip <- interpretProg s
            sp <- mapM showFunc ip
            mapM_ (liftIO . putStr . unlines) sp

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

runFile :: String -> IO ()
runFile file = runInputT defaultSettings $
    runStateT (runExceptT $ processProg file) emptyEnv >> return ()

parseFile :: String -> IO ()
parseFile filename = do
    file <- readFile filename
    res  <- runInputT defaultSettings $
        runStateT (runExceptT $ processProg file) emptyEnv
    case res of
        (Left err, _) -> hPutStrLn stderr $ show err
        (Right _, _)  -> return ()

main :: IO ()
main = do
    args <- getArgs
    case args of
        [] -> (putStr . unlines $ title) >> run emptyEnv
        fs -> mapM_ parseFile fs
