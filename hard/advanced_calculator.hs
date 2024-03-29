{-
Advanced Calculator
===================
Challenge Description
----------------------
The goal of this challenge is to create an advanced calculator. 
The following operations should be supported with their order (operator precedence):
    Pi        Pi number
    e         Euler's number
    sqrt()    Square root
    cos()     Cosine
    sin()     Sine
    tan()     Tangent
    lg()      Decimal logarithm
    ln()      Natural logarithm
1   ()        Brackets
2   ||        Absolute value, e.g. |-5 - 10|
3   !         Factorial
4   -         Unary minus
5   ^         Exponent
6   mod       Modulus divide, e.g. 5 mod 2 = 1 (only integers will be supplied here)
7   *, /      Multiply, Divide (left-to-right precedence)
8   +, -      Add, Subtract (left-to-right precedence)

Input sample
-------------
Your program should accept as its first argument a path to a filename. The input file contains several lines. Each line is one test case. Each line contains mathematical expression. eg.
```
250*14.3
3^6 / 117
(2.16 - 48.34)^-1
(59 - 15 + 3*6)/21
lg(10) + ln(e)
15*5 mod 2
```

Output sample
-------------
For each set of input produce a single line of output which is the result of calculation.
```
3575
6.23077
−0.02165
2.95238
2
15
```

Note: Don't use any kind of eval function.

Constraints
-----------
Each number in input expression is greater than -20,000 and less than 20,000. 
Each output number is greater than -20,000 and less than 20,000. 
If output number is a float number it should be rounded to the 5th digit after the dot. 
E.g 14.132646 gets 14.13265, 14.132644 gets 14.13264, 14.132645 gets 14.13265. 

If output number has less than 5 digits after the dot you don't need to add zeros. 
E.g. you need to print 16.34 (and not 16.34000) in case the answer is 16.34. 
And you need to print 16 (and not 16.00000) in case the answer is 16.
-}

import System.Environment (getArgs)
import Text.ParserCombinators.ReadP

data Tree = Branch Tree Tree | Leaf deriving Show

leaf = do char 'o'
         return Leaf

tree = leaf +++ branch

branch = do 
  a <- leaf
  char '&'
  b <- tree
  return (Branch a b)
          


calculate :: String -> Double
calculate = reversePolishCalc . toRPN . modifier . preModifier . splitter . filter (not . isSpace)

-- | for unary operation like 3 ^ -2
modifier :: [String] -> [String]
modifier [] = []
modifier [x] = [x]
modifier [x,y] = [x,y]
modifier (x:"-":y:xs) = x : if x `isInfixOf` "^*/+-("
                          then ('-':y) : modifier xs
                          else modifier ("-":y:xs)
modifier (x:"+":y:xs) = x : if x `isInfixOf` "^*/+-("
                          then y : modifier xs
                          else modifier ("+":y:xs)                          
modifier (x:xs) = x : modifier xs


-- | for calculation like  -3 * 3
preModifier :: [String] -> [String]
preModifier ("-":xs) = "-1":"*":xs
preModifier xs       = xs

splitter :: String -> [String]
splitter ""     = []
splitter s@(x:xs) 
  | isOperator x = [x] : splitter xs
  | otherwise    = former : splitter latter
  where 
    isOperator = (`elem` "^*/+-()")
    (former, latter) = break isOperator s


reversePolishCalc :: [String] -> Double
reversePolishCalc xs = head $ foldl helper [] xs 
  where
    helper :: [Double] -> String -> [Double]
    helper (x:y:ys) "+" = (y + x) : ys
    helper (x:y:ys) "-" = (y - x) : ys
    helper (x:y:ys) "*" = (y * x) : ys
    helper (x:y:ys) "/" = (y / x) : ys
    helper (x:y:ys) "^" = (y ** x) : ys    
    helper xs numString = read numString : xs


toRPN :: [String] -> [String]
toRPN = reverse . shuntingYard [] [] 


-- Shunting-Yard Algorithm
shuntingYard :: [String] -> [String] -> [String] -> [String]
shuntingYard stack []     []       = stack 
shuntingYard stack (x:xs) []       = shuntingYard (x:stack) xs []
shuntingYard stack xs     ("(":ys) = shuntingYard stack ("(":xs) ys
shuntingYard stack (x:xs) (")":ys)
  | x == "("  = shuntingYard stack     xs   ys
  | otherwise = shuntingYard (x:stack) xs (")":ys)
shuntingYard stack (x:xs) (y:ys)
  | y `isInfixOf` "^*/+-" = if precedence x < precedence y 
                              then shuntingYard stack (y:x:xs) ys
                              else shuntingYard (x:stack) xs (y:ys)
  | otherwise             = shuntingYard (y:stack) (x:xs) ys
shuntingYard stack  []  (x:xs) 
  | x `isInfixOf` "^*/+-(" = shuntingYard  stack [x] xs
  | otherwise              = shuntingYard (x:stack) []  xs


precedence :: String -> Int
precedence "^" = 3
precedence "*" = 2
precedence "/" = 2
precedence "+" = 1
precedence "-" = 1
precedence "(" = 0 -- Ok to have the loweset precedence because of the special treatment in shuntingYard


formatter :: Double -> String
formatter x = reverse $ dropWhile (== '.') $ dropWhile (== '0') (reverse s)
  where s = printf "%.5f" x


main = do 
  f:_ <- getArgs
  contents <- readFile f
  let inputs = lines contents
  let outputs = map calculate inputs
  mapM_ (putStrLn . formatter) outputs