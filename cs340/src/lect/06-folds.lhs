% 06 Folds
% Michael Saelee
% Feb 20, 2019

Primitive Recursion
-------------------

Let's start by implementing the following functions and looking for a pattern:

> sum' :: (Num a) => [a] -> a
> sum' = undefined
>
> product' :: (Num a) => [a] -> a
> product' = undefined
>
> and' :: [Bool] -> Bool
> and' = undefined
>
> or' :: [Bool] -> Bool
> or' = undefined
> 
> stringify :: (Show a) => [a] -> String
> stringify = undefined

Let's design a HOF that encapsulates this notion of primitive list recursion:

> recur :: undefined
> recur = undefined


Fold Right
----------

< foldr :: (a -> b -> b) -> b -> [a] -> b

Let's define the above recursive functions in terms of foldr:

> sum'' :: (Num a) => [a] -> a
> sum'' = undefined
>
> product'' :: (Num a) => [a] -> a
> product'' = undefined
>
> or'' :: [Bool] -> Bool
> or'' = undefined
> 
> and'' :: [Bool] -> Bool
> and'' = undefined
> 
> stringify' :: (Show a) => [a] -> String
> stringify' = undefined

Try a few others:

> (+++) :: [a] -> [a] -> [a]
> l1 +++ l2 = undefined
>
> length' :: [a] -> Int
> length' = undefined

And higher order functions:

> map' :: (a -> b) -> [a] -> [b]
> map' f = undefined
>
> filter' :: (a -> Bool) -> [a] -> [a]
> filter' f = undefined

How about reverse?

> reverse' :: [a] -> [a]
> reverse' = undefined

Reverse is hard (not impossible!) to write, because of the direction of folding.


Fold Left
---------

Determine the type of the left fold function and implement it:

> foldl' :: undefined
> foldl' = undefined

Define reverse:

> reverse'' :: [a] -> [a]
> reverse'' = undefined


On Infinite Lists
-----------------

Which folds (if any) work with infinite lists?

Try:

< take 10 $ foldr (:) [] [1..]
< foldr (||) False $ map even [1..]
< foldl (||) False $ map even [1..]

Why?
