> import Prelude hiding (Functor, fmap, (<$))
  
% 09 Typeclasses and Functors
% Michael Saelee
% March 8, 2019


Typeclasses and Functors
========================

Typeclasses
-----------

A type class defines a collection of functions to be found in conforming types.

Types that conform to a type class are called *instances* of the class, and the
functions defined by the class are called *methods*.

Consider the built-in class `Eq`:

< class Eq a where
<   (==), (/=) :: a -> a -> Bool
<   x == y = not (x /= y)
<   x /= y = not (x == y)

> data Student = Student {
>   firstName :: String,
>   lastName  :: String,
>   studentId :: Integer,
>   grades    :: [Char]
> } 

> instance Eq Student where
>   (Student _ _ id1 _) == (Student _ _ id2 _) = id1 == id2

> instance Show Student where
>   show (Student f l _ _) = f ++ " " ++ l


Functors
--------

Functors are a class of data types that support a "mapping" operation.

> class Functor f where
>   fmap :: (a -> b) -> f a -> f b

We can make a list a Functor, where fmap is identical to map

> instance Functor [] where
>   fmap = map

We can now do

> _ = fmap (*2) [1..10]

to map the function (*2) over the values in the list.

Because "fmap" is declared in a typeclass, we can define it separately for other
types, too (note we can't do this for "map", as it's a regular function with a
single, unique definition).

Here's the definition of fmap for the Maybe type:

> instance Functor Maybe where
>   fmap f Nothing = Nothing
>   fmap f (Just x) = Just (f x)

I.e., if we have a "Just" Maybe value, we reach inside the Just and apply the
fmap'd function to the value. If we have a "Nothing" Maybe value, there's no
contained value, so we just return Nothing.

Next, we start with definitions for a binary tree type ...

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

And then define fmap for the binary tree:

> instance Functor Tree where
>   fmap f (Leaf x) = Leaf $ f x
>   fmap f (Node l x r) = Node (fmap f l) (f x) (fmap f r)

"Lifting" functions
-------------------

By doing "fmap g", we now have a new version of the function g that can be
applied to any type that is a Functor!

Consider:

> liftedDouble :: (Functor f, Num a) => f a -> f a
> liftedDouble = fmap (*2)

We can do:

< liftedDouble [1..10]
< liftedDouble $ Just 5
< liftedDouble $ treeDepth 3

When we do this, we say that we have "lift"-ed the function -- i.e., made it
more abstract/general -- in this case so that it can be applied to arbitrary
Functors of the function's original input type.

But "fmap" is limited, in that it can only take a function of a single
argument. What if we want to lift functions of two or more arguments, so that we
can easily apply them to multiple functors containing those arguments?

We could achieve this with the following versions of fmap:

> fmap2 :: (a -> b -> c) -> f a -> f b -> f c
> fmap2 = undefined
> 
> fmap3 :: (a -> b -> c -> d) -> f a -> f b -> f c -> f d
> fmap3 = undefined

Etc.
