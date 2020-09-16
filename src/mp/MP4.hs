--  Aakef Waris
--  MP4.hs (Sliding Tile A* Algorithim)


import Data.Ord
import Data.List
import Debug.Trace
import Data.Maybe

search :: (Eq a, Show a) => (a -> Bool) -> (a -> [a]) -> ([a] -> [a] -> [a]) -> [a] -> [a] -> Maybe a

search goal succ comb nodes oldNodes
   | null nodes = Nothing
   | goal (head nodes) = Just (head nodes)
   | otherwise = let (n:ns) = nodes
                in traceShow (n,nodes) $ search goal succ comb
                    (comb (removeDups (succ n)) ns)
                    (adjoin n oldNodes)
   where removeDups = filter (not . ((flip elem) (nodes ++ oldNodes)))
         adjoin x lst = if elem x lst then lst else x:lst


bestFirstSearch :: (Eq a, Show a, Ord b) => (a -> Bool) -> (a -> [a])
                -> (a -> b) -> a -> Maybe a

bestFirstSearch goal succ score start = search goal succ comb [start] []
  where comb new old = sortOn score (new ++ old)

type Board = [Maybe Integer]

solved = [Just 1, Just 2, Just 3,
          Just 4, Just 5, Just 6,
          Just 7, Just 8, Nothing]
tc =   [Just 3, Just 1, Just 4,
        Just 5, Just 8, Just 2,
        Just 7, Just 6, Nothing]


swapIDX :: Int -> Int -> Board -> Board
swapIDX i j ls = [get k x | (k, x) <- zip [0..length ls - 1] ls]
          where get k x | k == i = ls !! j
                        | k == j = ls !! i
                        | otherwise = x


findHole :: Board -> Int -> Int
findHole (x:xs) n = if x == Nothing then n else findHole xs (n+1)



getNeighbors :: Int -> [Int]
getNeighbors n = case n of
                      0 -> [1,3]
                      1 -> [0,2,4]
                      2 -> [1,4,5]
                      3 -> [0,4,6]
                      4 -> [1,3,5,7]
                      5 -> [2,4,8]
                      6 -> [3,7]
                      7 -> [4,6,8]
                      8 -> [5,7]

states :: Board -> Int -> [Int] -> [Board]
states board idx [] = []
states board idx (n:ns) = swapIDX idx n board : states board idx ns

ops :: Board -> [Board]
ops board = states board (findHole board 0 ) (getNeighbors $ findHole board 0 )

subMaybe :: Maybe Integer -> Maybe Integer -> Integer
subMaybe (Just a) (Just b) = a-b

subMaybe (Just a) Nothing = a - 9

subMaybe Nothing (Just b) = 9-b

subMaybe Nothing Nothing = 0


manhattanDistance :: Board -> Board -> Integer
manhattanDistance p q = sum $ zipWith  (\ u v -> abs $ subMaybe u v) p q

score :: Board -> Integer
score state = manhattanDistance state solved





goal :: Board -> Bool
goal state = state == solved


