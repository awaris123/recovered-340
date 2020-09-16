% 04 Basic Recursion
% Michael Saelee
% Feb 6, 2019

Designing recursive functions
-----------------------------

Step 1: determine the type
Step 2: list all the patterns
Step 3: define the trivial cases
Step 4: define the hard cases
Step 5: generalize and simplify


Basics
------

> fib :: Integer -> Integer
> fib = undefined
>
> factorial :: Integer -> Integer
> factorial = undefined
>
> pow :: Integer -> Integer -> Integer
> pow = undefined
>
> -- ackermann's function is defined as:
> -- A(x,y) = y+1 if x = 0
> --          A(x-1, 1) if y = 0
> --          A(x-1, A(x, y-1)) otherwise
> ackermann :: Integer -> Integer -> Integer
> ackermann = undefined

  
List Manipulation
-----------------

> last' :: [a] -> a
> last' [] = error "empty list"
> last' (x:[]) = x
> last' (x:xs) = last' xs
>
> (!!!) :: [a] -> Integer -> a
> lst !!! n = undefined
>
> -- elem' :: return True if a given element is found in a list, False otherwise
>
> -- and :: determine if all values in a list are True
> 
> -- sum :: compute sum of a list of numbers


List Construction
-----------------

> (+++) :: [a] -> [a] -> [a] 
> (+++) = undefined
>
> take' :: Int -> [a] -> [a]
> take' = undefined
>
> drop' :: Int -> [a] -> [a]
> drop' = undefined
> 
> -- replicate' :: create a list of N copies of some value
>
> -- repeat' :: create an infinite list of some value
>
> -- concat :: concatenate all lists in a list of lists
>
> -- merge :: merge together two sorted lists to give a single sorted list
>
> -- mergeSort :: sorts a list by recursively merging together two sorted halves of a list
>
> -- zip' :: create a list of tuples drawn from elements of two lists
>
> zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c] -- preview of HOFs
> zipWith' = undefined
>
> fibonacci :: [Integer]
> fibonacci = undefined

