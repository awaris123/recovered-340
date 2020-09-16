% 05 Higher Order Functions
% Michael Saelee
% Feb 13, 2019

HOFs
----

A higher-order function is a function that takes one or more functions as
parameters or returns a function. ("Regular" functions are called first-order
functions).

HOFs enable us to create higher-level abstractions, and are a fundamental
tool in functional programming.

Note: due to currying, *all functions of 2 or more arguments* are HOFs!


Mapping as "Iteration"
----------------------

< map :: (a -> b) -> [a] -> [b]

`map` applies a function to each item of a list, returning the new list.

Try passing map:

- a first-order function
- a lambda function
- a sectioned function
- a higher order function (what happens?)

> -- define map
> map' :: (a -> b) -> [a] -> [b]
> map' = undefined

Filtering
---------

< filter :: (a -> Bool) -> [a] -> [a]

`filter` is another typical HOF. `filter` only keeps values in a list that pass
a given predicate (a function that returns True/False).

Try out:

< filter even [1..10]
< filter (\(a,b,c) -> a^2+b^2==c^2) [(a,b,c) | a<-[1..10], b<-[a..10], c<-[b..10]]
< filter (\s -> reverse s == s) (words "madam I refer to adam")

> -- define filter
> filter' :: (a -> Bool) -> [a] -> [a]
> filter' = undefined


Composition, Application, et al
-------------------------------

< (.) :: (b -> c) -> (a -> b) -> a -> c
< ($) :: (a -> b) -> a -> b
< flip :: (a -> b -> c) -> b -> a -> c

> k2c k = k - 273
> c2f c = c * 9 / 5 + 32
> f2h f
>   | f < 0 = "too cold"
>   | f > 100 = "too hot"
>   | otherwise = "survivable"


Point-free (i.e., argument-free) Style
--------------------------------------

Re-write the following in point-free style (using composition, when possible)

> even' :: Integer -> Bool
> even' = undefined
>
> k2h :: Double -> String
> k2h = undefined
>
> evensOnly :: [Integer] -> [Integer]
> evensOnly = undefined
>
> mapEach :: (a -> b) -> [[a]] -> [[b]]
> mapEach = undefined


Folds
-----

Let's start by implementing the following and looking for a pattern:

> sum' :: (Num a) => [a] -> a
> sum' = undefined
> 
> product' :: (Num a) => [a] -> a
> product' = undefined
>                   
> stringify :: (Show a) => [a] -> String
> stringify = undefined
