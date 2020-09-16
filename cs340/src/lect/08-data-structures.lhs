% 08 Data Structures
% Michael Saelee
% March 6, 2019


Lists
-----

> data List a = Cons a (List a) | Empty deriving Show
>
> head' :: List a -> a
> head' = undefined
>
> tail' :: List a -> List a
> tail' = undefined
>
> takel :: Int -> List a -> List a
> takel = undefined
>
> repeatl :: a -> List a
> repeatl = undefined
>
> foldrl :: (a -> b -> b) -> b -> List a -> b
> foldrl = undefined
>
> suml :: Num a => List a -> a
> suml = undefined


Binary Trees
------------

> data BinTree a = Node (BinTree a) a (BinTree a) | Leaf a
>   deriving Show
>
> eTree :: BinTree Char
> eTree = Node (Node (Leaf '3') '+' (Leaf '5')) '*' (Leaf '9')
>
> treeElem :: Eq a => a -> BinTree a -> Bool
> treeElem = undefined
>
> flatten :: BinTree a -> [a]
> flatten = undefined
>
> infTree :: BinTree Integer
> infTree = undefined
>
> prune :: Int -> BinTree a -> BinTree a
> prune = undefined
>
> mapT :: (a -> b) -> BinTree a -> BinTree b
> mapT = undefined
>
> foldrT :: (a -> b -> b) -> b -> BinTree a -> b
> foldrT = undefined


N-way Trees
-----------

> data Tree a = T a [Tree a] deriving Show
>
> binTree :: Integer -> Tree Integer
> binTree n = T n [binTree (n*2), binTree (n*2+1)]
>
> prune' :: Int -> Tree a -> Tree a
> prune' = undefined

