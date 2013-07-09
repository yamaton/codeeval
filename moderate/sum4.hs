{-
Sum to Zero 
============

Description
------------
You are given an array of integers. Count the numbers of ways in which the sum of 4 elements in this array results in zero

Input sample
-------------
Your program should accept as its first argument a path to a filename. Each line in this file consist of comma separated positive and negative integers. e.g.
```
2,3,1,0,-4,-1
0,-1,3,-2
```

Output sample
--------------
Print out the count of the different number of ways that 4 elements sum to zero. e.g.
```
2
1
```
-}

import System.Environment (getArgs)

split :: Char -> String -> [String]
split c s = case dropWhile (== c) s of
                "" -> []
                s' -> w : split c s''
                    where (w, s'') = break (== c) s'


-- http://www.haskell.org/pipermail/beginners/2011-November/008990.html
combinations :: Int -> [a] -> [[a]]
combinations 0 _ = [[]]
combinations _ [] = []
combinations n (x:xs) = [x:comb | comb <- combinations (n-1) xs]
                         ++ combinations n xs




countSum:: Int -> [Int] -> Int
countSum n xs = 

main = do 
    args <- getArgs
    contents <- readFile (head args)
    let inputs = [map read (split ',' line) | line <- lines contents]
    let outputs = map (countSum 4) inputs
    mapM print outputs
