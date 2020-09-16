> import Data.Ord
> import Data.List
  
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
nn
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

> treeSearch :: undefined
> treeSearch = undefined
