{-# LANGUAGE PackageImports #-}

module Main where

import LexBeatle
import ParBeatle
import AbsBeatle
import Interpreter

import ErrM

import Control.Monad.IO.Class
import System.Console.Haskeline

import qualified Lambda.Lambda as L

eitherFunc :: Either String L.Value -> String
eitherFunc (Left err) = err
eitherFunc (Right val) = show val

process :: String -> IO ()
process line = do
  let res = pProgram (myLexer line)
  case res of
    (Bad s) -> print "err"
    (Ok s) -> print $ map eitherFunc (interpretProg s)

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