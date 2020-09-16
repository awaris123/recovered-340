> import Prelude hiding (Functor, fmap, (<$))
  
% 09 Typeclasses and Functors
% Michael Saelee
% March 8, 2019


Typeclasses and Functors
========================

Typeclasses
-----------

Consider the built-in classes `Eq` and `Show`:

< class Eq a where
<   (==), (/=) :: a -> a -> Bool
<   x == y = not (x /= y)
<   x /= y = not (x == y)
<
< class Show a where
<   show :: a -> String

> data Student = Student {
>   firstName :: String,
>   lastName  :: String,
>   studentId :: Integer,
>   grades    :: [Char]
> } 


Functors
--------

Functors are a class of data types that support a "mapping" operation.

> 

> data Tree a = Node (Tree a) a (Tree a) | Leaf a
>
> instance (Show a) => Show (Tree a) where
>   show t = s t 0
>     where s (Leaf x) n = replicate n '.' ++ show x ++ "\n"
>           s (Node l x r) n = replicate n '.'
>                                ++ show x ++ "\n"
>                                ++ s l (n+1) ++ s r (n+1)
> 
> treeDepth :: Int -> Tree Int
> treeDepth d = t 1 d
>   where t n d | d == 1 = Leaf n
>               | otherwise = Node (t (2*n) (d-1)) n (t (2*n+1) (d-1))


"Lifting" functions
-------------------

> liftedDouble :: (Num a) => f a -> f a
> liftedDouble = undefined
