import Data.Char
-----------------------------------
-- Name: Aakef Waris              |
-- Class: CS-340                  |
-- Assignment: MP2 Folds and HOFs |
-- Due: 03-24-19                  |
-----------------------------------


------------------------------------------------------------------------------
-- Permitted Functions for all problems:                                     |
 -- Tuple construction & component access: (), fst, snd                      |
 -- List construction & access: [], (:), head, tail, init, last, (!!), (++)  |
 -- Boolean operators: not, (&&), (||)                                       |
 -- Composition: (.)                                                         |
 -- Arithmetic: (+), (-), (/), (*)                                           |
 -- Comparison: (==), (/=), (<), (<=), (>), (>=)                             |
 -- HOFs: map, foldr, foldl                                                  |
------------------------------------------------------------------------------


-- WARM UP ----------------------------------------------------------


-- Problem 1:

any' :: (a -> Bool) -> [a] -> Bool
any' f (xs) = foldr (\a b -> a || b)  False (map f (xs)) 


-- Probelm 2:

all' :: (a -> Bool) -> [a] -> Bool
all' f (xs) = foldr (\a b -> a && b)  True  (map f (xs)) 


-- Problem 3:

compose :: [a -> a] -> (a -> a)
compose (xs) = foldr (\a b -> a . b) id (xs)  



-- Problem 4:

cycle' :: [a] -> [a]
cycle' (xs) = foldr(\a b -> (a:b)) (cycle'(xs)) (xs) 


-- Problem 5:

scanr' :: (a -> b -> b) -> b -> [a] -> [b]
scanr' f z [] = [z]
scanr' f z (x : xs) = foldr (\a b -> f a b) z (x : xs) : scanr' f z (xs)


-- Problem 6:

scanl' :: (b -> a -> b) -> b -> [a] -> [b]
scanl' _ z []  =  [z]
scanl' f z (x : xs) = foldl (\b a -> b ) z [x] : ( scanl' f zTwo (xs))
    where zTwo  = z `f` x  


-- Problem 7:

inits :: [a] -> [[a]]

inits = foldr (\x y -> [] : map (x:) y) [[]]


-- Problem 8:

tails :: [a] -> [[a]]
tails [] = [[]]
tails (x : xs) = foldr(\a b -> a++b ) [] [(x:xs)] : tails (xs)


-- TRICKIER EXERCISES --------------------------------------------------


-- Problem 1:
-- Permitted functions: min, max

minmax :: (Ord a) => [a] -> (a,a)
minmax [n] = (n,n)
minmax (x:xs) = if x > head xs 
    then 
        foldr compareValInTuple (head xs, x) (tail xs)
    else 
        foldr compareValInTuple (x, head xs) (tail xs)
    where compareValInTuple = (\a b -> if a > snd b then (fst b, a) else if a < fst b then (a,snd b) else b) 


-- Problem 2:



gap :: (Eq a) => a -> a -> [a] -> Maybe Int
gap start end lst = snd (foldl switch (Nothing,Nothing) lst) 
    where switch = \b a ->  if fst b == Nothing && a == start then (Just 1, snd b) else if fst b /= Nothing && a == end then (fst b, fst b) else if fst b /= Nothing then ((+1)<$>fst b, snd b)  else b
   

-- Problem 3: 

accumTup :: (Int, Char) -> Char -> (Int, Char)
accumTup acc next  = if next == '+' || next == '-' then ( fst acc, next ) 
    else (if snd acc == '+' then (fst acc + (read [next] :: Int), '+') 
        else (fst acc - (read [next] :: Int), '-'))

evalExpr :: String -> Int
evalExpr [n] = read [n] :: Int
evalExpr xpr  = fst(foldl accumTup (0,'+') xpr)
 

-- Problem 4:

words' :: String -> [String]
words' "" = [[]]
words' (xs)  = fst (foldr(\a b -> if a /= ' ' then (fst b, [a] ++ snd b  ) else ( if snd b == "" then b else ([snd b] ++ fst b  , "")) ) ([],"") ( " " ++ xs))


-- Problem 5:

dropWhile' :: (a -> Bool) -> [a] -> [a]
dropWhile' _ [] = []
dropWhile' f (x:xs) = snd (foldl(\b a-> if fst b == True then  b else (if f a == True then (False, tail (snd b)) else (True, snd b)) ) (False, x:xs)  (x:xs)) 


-- FOLDS MP1 REDUX  -----------------------------------------------------


-- Problem 4:
-- Permitted functions: (++), (:)

join :: a -> [[a]] -> [a]
join sep lst  = tail $ (foldl (\a b -> a ++ [sep] ++ b) [] lst)


-- Problem 5:
-- Permitted functions: (:)

unzip' :: [(a,b)] -> ([a], [b])
unzip'  = foldr (\(a,b) (as,bs) ->  (a:as,b:bs)  ) ([] , [] )  


-- Problem 6:
-- Permitted functions: (:), (==), (+)

runLengthEncode :: String -> [(Int,Char)]
runLengthEncode lst  = foldr(\a b -> if a == snd(head  b) then [(fst(head b)+1 ,a)]++tail b else [(1,a)]++ b) [( 1 , last lst )] (init lst)
    


-- Problem 7:
-- Permitted functions: (++), (:), replicate 

runLengthDecode :: [(Int,Char)] -> String
runLengthDecode lst = foldr (\a b -> (multChar (fst a) (snd a)) ++ b ) "" lst
    where multChar = \n k -> if n == 0 then [] else if n == 1 then [k]  else [k] ++ multChar (n-1) k


-- Problem 8:
-- Permitted functions: (+), (-), (:), (++), (&&), rem, ord, chr, isLetter, toUpper, cycle 

vigenere :: String -> String -> String
vigenere = undefined



