module Main where

import LexBeatle
import ParBeatle
import AbsBeatle
import LayoutBeatle
import Interpreter

import ErrM

import Control.Monad.IO.Class
import Control.Monad.State
import Data.Maybe
import System.Console.Haskeline

import qualified Data.Map as Map

import qualified Lambda.Lambda as L

-- type IState = StateT L.ValMap (InputT IO)

myLLexer = resolveLayout True . myLexer

eitherFunc :: Either String L.Value -> IState String
eitherFunc (Left err) = return err
eitherFunc (Right val) = return $ case val of
    L.VInt i -> show i
    L.VBool b -> show b
    L.VClos _ _ -> "<<function>>"
    L.VFixed _ _ _ -> "<<recursive function>>"
    l@(L.VClos _ _ : t) -> "<<" ++ show . length l ++ " functions>>"

process :: String -> IState ()
process line = do
    let res = pLine (myLLexer line)
    case res of
        (Bad s) -> liftIO $ print "err"
        (Ok s) -> (liftIO . print) =<< eitherFunc =<< interpretLine s
        -- (Ok s) -> print $ map eitherFunc (interpretLine s)

main :: IO ()
main = runInputT defaultSettings (runStateT loop Map.empty) >> return ()
    where
        loop :: IState ()
        loop = do
            minput <- lift $ getInputLine "λ "
            case minput of
                Nothing -> return ()
                Just ":q" -> lift $ outputStrLn "Goodbye."
                Just input -> process input >> loop
