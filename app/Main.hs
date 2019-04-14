{-# LANGUAGE PackageImports #-}

module Main where

import LexBeatle
import ParBeatle
import AbsBeatle
import Interpreter

import ErrM

import Control.Monad.IO.Class
import System.Console.Haskeline

process :: String -> IO ()
process line = do
  let res = pProgram (myLexer line)
  case res of
    (Bad s) -> print "err"
    (Ok s) -> print (interpretProg s)

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