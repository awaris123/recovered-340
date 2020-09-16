> import Data.Ord
> import Data.List
> import Debug.Trace
  
% 14 Search
% Michael Saelee
% April 17, 2019

Search
======

The search problem is one of the most common problems you'll encounter across
various domains of computer science. Searching amounts to the problem of
looking for information that matches some criteria in a collection of data.
Different search algorithms and problem domains specify the way the data is
collected, represented, and stored, and what the search criteria are.

A reasonably general start to our discussion of search is to consider
how we might search for a value stored somewhere in an N-way tree.

Here are some definitions we previously came up with for generating simple
binary trees:

> data Tree a = Node {
>   rootVal :: a,
>   forest :: [Tree a]
> } deriving (Show)
> 
> instance Functor Tree where
>   fmap f (Node x ts) = Node (f x) $ fmap (fmap f) ts

> binTree :: Tree Integer
> binTree = t 1
>   where t n = Node n [t (2*n), t (2*n+1)]
>
> pruneTree :: Int -> Tree a -> Tree a
> pruneTree 1 (Node x _) = Node x []
> pruneTree n (Node x f) = Node x $ map (pruneTree (n-1)) f

What would our search function look like?

> treeSearch :: (a -> Bool) -> ([Tree a] -> [Tree a] -> [Tree a])
>   -> [Tree a] -> Bool
>
> treeSearch goal combiner [] = False
> treeSearch goal combiner ((Node x forest):ns)
>   | goal x = True
>   | null forest = treeSearch goal combiner ns
>   | otherwise = treeSearch goal combiner (combiner forest ns)

> depthFirstSearch :: (a -> Bool) -> Tree a -> Bool
> depthFirstSearch goal t = treeSearch goal (++) [t]

> breadthFirstSearch :: (a -> Bool) -> Tree a -> Bool
> breadthFirstSearch goal t = treeSearch goal (flip (++)) [t]

> data Maze = Maze Int Int String deriving Show
> type MazeLoc = (Int,Int)
>
> maze1 = Maze 4 3 "####\
>                  \    \
>                  \####" -- exit (3,1)
>
> maze2 = Maze 5 6 "#####\
>                  \    #\
>                  \# # #\
>                  \# # #\
>                  \# #  \
>                  \#####" -- exit (4,4)
> 
> maze3 = Maze 17 7 "#################\
>                   \  #       #     #\
>                   \# ##### # # # # #\
>                   \#     # # # # # #\
>                   \# ### ### # # ###\
>                   \#   #       #    \
>                   \#################" -- exit (16,5)
>
> maze4 = Maze 17 7 "#################\
>                   \                #\
>                   \# # # # # # # # #\
>                   \# # # # # # # # #\
>                   \# ###############\
>                   \#                \
>                   \#################" -- exit (16,5)
>
> maze5 = Maze 16 9 "################\
>                   \               #\
>                   \### ########## #\
>                   \#   #          #\
>                   \# ### ##########\
>                   \# ###          #\
>                   \# ############ #\
>                   \#               \
>                   \################" -- exit (15,7)
>
> mazeChar :: Maze -> MazeLoc -> Char
> mazeChar (Maze w h s) (x,y) = s !! (w*y + x)
>
> mazeMoves :: Maze -> MazeLoc -> [(Int,Int)]
> mazeMoves m@(Maze w h s) (x,y)
>   | mazeChar m (x,y) == ' ' = [(x+dx,y+dy)
>                               | dx <- [-1,0,1], dy <- [-1,0,1],
>                                 (dx == 0 && dy /= 0) || (dx /= 0 && dy == 0),
>                                 x+dx >= 0 && x+dx < w,
>                                 y+dy >= 0 && y+dy < h,
>                                 mazeChar m ((x+dx),(y+dy)) == ' ']
>   | otherwise = []
>
> mazeVisit :: Maze -> MazeLoc -> Maze
> mazeVisit m@(Maze w h s) (x,y) = let offset = w*y + x
>                                  in Maze w h $ (take offset s)
>                                     ++ "X"
>                                     ++ (drop (offset+1) s)
> 
> search :: (Eq a, Show a) => (a -> Bool) -> (a -> [a]) -> ([a] -> [a] -> [a])
>   -> [a] -> [a] -> Maybe a
> search goal succ comb nodes oldNodes
>   | null nodes = Nothing
>   | goal (head nodes) = Just (head nodes)
>   | otherwise = let (n:ns) = nodes
>                 in traceShow (n,nodes) $ search goal succ comb
>                    (comb (removeDups (succ n)) ns)
>                    (adjoin n oldNodes)
>   where removeDups = filter (not . ((flip elem) (nodes ++ oldNodes)))
>         adjoin x lst = if elem x lst then lst else x:lst
>
> dfs :: (Eq a, Show a) => (a -> Bool) -> (a -> [a]) -> a -> Maybe a
> dfs goal succ start = search goal succ (++) [start] []
>
> bfs :: (Eq a, Show a) => (a -> Bool) -> (a -> [a]) -> a -> Maybe a
> bfs goal succ start = search goal succ (flip (++)) [start] []

> mazeSearch :: Maze -> MazeLoc -> MazeLoc -> Bool
> mazeSearch m inloc outloc =
>   case dfs (== outloc) (mazeMoves m) inloc
>   -- case bfs (== outloc) (mazeMoves m) inloc
>   -- case bestFirstSearch (== outloc) (mazeMoves m) (mazeDist outloc) inloc
>   of Nothing -> False
>      otherwise -> True

> bestFirstSearch :: (Eq a, Show a, Ord b) => (a -> Bool) -> (a -> [a])
>                 -> (a -> b) -> a -> Maybe a
> bestFirstSearch goal succ score start = search goal succ comb [start] []
>   where comb new old = sortOn score (new ++ old)

> mazeDist :: MazeLoc -> MazeLoc -> Double
> mazeDist (x1,y1) (x2,y2) = sqrt $ fromIntegral $ (x1-x2)^2 + (y1-y2)^2

> data MazePath = MazePath [MazeLoc] deriving Eq
>
> instance Show MazePath where
>   show (MazePath p) = show (length p) ++ "<" ++ show (reverse p) ++ ">"
>
> mazePathSearch :: Maze -> MazeLoc -> MazeLoc -> Maybe MazePath
> mazePathSearch m inloc outloc =
>   bestFirstSearch (\(MazePath (l:_)) -> l == outloc)
>                   nextPaths scorePath $ MazePath [inloc]
>   where nextPaths (MazePath p@(l:_)) = map (\nl -> MazePath $ nl:p)
>                                        $ filter (not . (flip elem) p)
>                                        $ mazeMoves m l
>         scorePath (MazePath p@(l:_)) = mazeDist l outloc
>                                        + fromIntegral (length p)
