{-# LANGUAGE PackageImports #-}

module Main where

import LexBeatle
import ParBeatle
import AbsBeatle
import LayoutBeatle
import Interpreter

import ErrM

import Control.Monad.IO.Class
import System.Console.Haskeline

import qualified Lambda.Lambda as L

myLLexer = resolveLayout True . myLexer

eitherFunc :: Either String L.Value -> String
eitherFunc (Left err) = err
eitherFunc (Right val) = case val of
    L.VInt i -> show i
    L.VBool b -> show b
    L.VClos _ _ -> "<<function>>"

process :: String -> IO ()
process line = do
    let res = pLine (myLLexer line)
    case res of
        (Bad s) -> print "err"
        (Ok s) -> print . eitherFunc . interpretLine $ s
        -- (Ok s) -> print $ map eitherFunc (interpretLine s)

main :: IO ()
main = runInputT defaultSettings loop
    where
        loop :: InputT IO ()
        loop = do
            minput <- getInputLine "λ "
            case minput of
                Nothing -> return ()
                Just ":q" -> outputStrLn "Goodbye."
                Just input -> (liftIO $ process input) >> loop