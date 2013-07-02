{-
dupes.py

Created by Yamato Matsuoka on 2013-07-02.

# Description
You are given a sorted list of numbers with duplicates. Print out the sorted list with duplicates removed.

## Input sample
File containing a list of sorted integers, comma delimited, one per line. e.g. 
```
1,1,1,2,2,3,3,4,4
2,3,4,5,5
```

## Output sample
Print out the sorted list with duplicates removed, one per line. e.g.
```
1,2,3,4
2,3,4,5
```
-}

import System.Environment
import Data.List (nub)


-- modified: http://stackoverflow.com/questions/4978578/how-to-split-a-string-in-haskell
split :: Char -> String -> [String]
split c s = case dropWhile (== c) s of
                "" -> []
                s' -> w : split c s''
                    where (w, s'') = break (== c) s'

join :: Char -> [String] -> String
join c ws = foldr1 (\w s -> w ++ c : s) ws


main = do 
    args <- getArgs
    let fileName = head args
    contents <- readFile fileName
    let inputs = map (split ',') $ lines contents
    let outputs = map nub inputs
    mapM (putStrLn . (join ',')) outputs

