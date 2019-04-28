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

myLLexer = resolveLayout True . myLexer

eitherFunc :: Either String [L.Value] -> IState [String]
eitherFunc (Left err) = return [err]
eitherFunc (Right l) = return $ map showVal l
    where
        showVal val = case val of
            L.VInt i -> show i ++ " : int"
            L.VBool b -> show b ++ " : bool"
            L.VClos _ _ -> " = <fun>"
            L.VFixed n _ _ -> n ++ " = <fun>"
            -- clos@(L.VClos _ _ : t) -> "<<" ++ show . length clos ++ " functions>>"

process :: String -> IState ()
process line = do
    let res = pLine (myLLexer line)
    case res of
        (Bad s) -> liftIO $ putStrLn "err"
        (Ok s) -> (liftIO . putStr . unlines) =<< eitherFunc =<< interpretLine s
        -- (Ok s) -> print $ map eitherFunc (interpretLine s)

main :: IO ()
main = runInputT defaultSettings (runExceptT $ runStateT loop Map.empty) >>= rerun main
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
        rerun f (Right _) = return ()
