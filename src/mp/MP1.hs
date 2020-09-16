import Data.Int
import Data.List
import Data.Char
import Data.Tuple


-- Problem 1:

cycleN :: Int -> [a] -> [a]
cycleN 0 (xs) = []
cycleN n (xs) = (xs) ++ cycleN (n-1) (xs)


--  Problem 2:

countLessThan :: (Ord a)  => a -> [a] -> Int
countLessThan _ [] = 0
countLessThan a (x:xs) =
    if x < a
    then
        1 + countLessThan a (xs)
    else
        0 + countLessThan a (xs)


-- Problem 3:

removeOne :: (Eq a) => a -> [a] -> [a]
removeOne _ [] = []
removeOne n (x:xs) = 
    if n == x then
        removeOne n (xs)
    else
        x : removeOne n (xs)

removeAll :: (Eq a) => [a] -> [a] -> [a]
removeAll [] (xs)  = (xs)
removeAll (xs) [] = []
removeAll (x:xs) (ys) = removeAll (xs) (removeOne x ys) 



-- Problem 4:

join :: a -> [[a]] -> [a]
join _ [[x]] = [x]
join _ [[]] = []
join n ((xs):[]) = (xs) 
join n ((xs):((ys))) = (xs ) ++ (n:join n ((ys)))
 

-- Problem 5:

unzip' :: [(a,b)] -> ([a], [b])
unzip' [] = ([],[])
unzip' ((a,b):xs) = (a:as, b:bs)
    where (as, bs) = unzip' xs

-- Problem 6;
runLengthEncode :: String -> [(Int,Char)]
runLengthEncode [] = []
runLengthEncode (x:xs) = runLengthEncode' 1 x xs where
runLengthEncode' l x [] = [(l, x)]
runLengthEncode' l x (b:bs)
  | x == b = runLengthEncode' (l + 1) x bs
  | otherwise = (l, x) : runLengthEncode' 1 b bs 

-- Problem 7:
decode :: (Int,Char) -> String
decode (0,_) = ""
decode (n,c) = c:decode(n-1,c)

runLengthDecode :: [(Int,Char)] -> String
runLengthDecode [] = []
runLengthDecode (x:xs)  = decode x ++ runLengthDecode xs 
   

-- Problem 8:

validWord :: String -> String
validWord [] = []
validWord (x:xs) = 
 if isLetter x then 
  toUpper x : validWord xs 
 else 
  validWord xs

matchWord :: String -> String -> (String, String)
matchWord [] [_] = ([],[])
matchWord [_] [] = ([],[])
matchWord (x:xs) (y:ys) = (validWord (x:xs), validWord (y:ys)) 



vigenere :: String -> String -> String
vigenere = undefined

