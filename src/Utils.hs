module Utils where

seqPair :: [(a, Either b c)] -> Either b [(a, c)]
seqPair = sequence . seq'
    where
        seq' l = case l of
            (a, Left b):t -> [Left b]
            (a, Right b):t -> Right (a, b) : seq' t
            [] -> []