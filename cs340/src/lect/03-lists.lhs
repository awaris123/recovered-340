% 03 Lists
% Michael Saelee
% Feb 1, 2019

Agenda
------

- On data structures and immutability
- Lists and list operations
- List comprehensions
- Defining functions on lists: pattern matching & recursion

  
On data structures and immutability
-----------------------------------

Most languages have built-in *aggregate* types -- i.e., data structures -- used
to store, access, and manipulate collections of values. The most common data
structure used in imperative languages is the *array*.

An *array* is a fixed-size structure made up of "slots", each of which can hold
an element.  Depending on the implementation, the elements in an array may be
*homogeneous* (all of the same type) or *heterogeneous* (of different
types). Arrays also typically support *indexing* for both retrieval and
updates.

E.g.,

< int[] arr = new int[100];
< for (int i=0; i<arr.length; i++)
<     arr[i] = 0;

But remember, in a functional language, in-place mutations are *not possible!*

So how might an operation like `arr[N] = X` be carried out?

...

If arrays existed in Haskell, "updating" an index would require making a new
copy of the entire array except for the value at that index (which would be
different from the original). Also, empty "slots" would be pointless, as we
couldn't actually "place" elements there --- they would only be useful if they
served a semantic purpose.

Arrays are *not* part of the standard Haskell repertoire. Instead, we have
*lists*.


Lists and list operations
-------------------------

`:` operator is used for list construction. (It is an example of a
"data/value constructor".)

< (:) :: a -> [a] -> [a]

In the type of `:` (which is polymorphic), `[a]` represents a list of some
homogeneous type `a`. I.e., `:` takes a value of type `a` and a list of `a`s
and returns a list of `a`s.

The empty list, `[]`, is also polymorphic:

< [] :: [t]

So we can construct a list of Booleans like this:

< True : []
< True : False : True : []

(check operator associativity of `:` with `:i (:)`)

There is also syntactic sugar for defining lists:

< [True,False,True]
< [1..10]
< ['a'..'z'] -- works because of `Enum` type class


List comprehensions
-------------------

< -- to try: 
< [2*x | x <- [1..10]]
< [(i,j) | i <- [1..5], j <- ['a'..'e']]
< [p | p <- [1..100], p `mod` 9 == 0]

> integerRightTriangles p = undefined


Basic list operations
_____________________

`length`, `head`, `tail`, `last`, `init`,
`!!`, `null`, `elem`,
`take`, `drop`, `reverse`, `++`


Defining functions on lists: pattern matching & recursion
---------------------------------------------------------

When defining functions, we can provide multiple *patterns* for the function
call to be matched against, so long as the results are all of the same type.
The first pattern to match the actual argument will have its result chosen.

> fib :: Integer -> Integer
> fib 0 = 1
> fib 1 = 1
> fib x = fib (x-1) + fib (x-2)

Any data/value constructor can be used in pattern matches, so:

> empty [] = "empty"
> empty _  = "not empty" -- the variable `_` means "we don't care about this value"

Our own `head` and `tail` implementations:

> head' (x:xs) = x
> tail' (x:xs) = xs

Implement `last` and `init`?

> last' :: [a] -> a
> last' = undefined
> 
> init' :: [a] -> [a]
> init' = undefined


Recursion is a common list programming pattern!

> (!!!) :: [a] -> Integer -> a
> lst !!! n = undefined
>
> elem' :: a -> [a] -> Bool
> elem' = undefined




