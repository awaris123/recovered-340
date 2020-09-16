> import Prelude hiding (Functor, fmap,
>                        Applicative, pure, (<*>), (<$>), sequenceA)
> 
> -- previous definitions
> 
> class Functor f where
>   fmap :: (a -> b) -> f a -> f b
> 
> instance Functor [] where
>   fmap = map
> 
> instance Functor Maybe where
>   fmap f Nothing = Nothing
>   fmap f (Just x) = Just (f x)

% 10 Applicative Functors
% Michael Saelee
% March 13, 2019

Applicative Functors
====================

The Applicative typeclass extends Functors with additional methods. "pure" takes
a value and wraps it in a Functor instance, while "<*>" applies a function found
in one functor to a value in another functor. The "<$>" operator is just an
infix version of fmap (we'll see how that's useful later).

> class (Functor f) => Applicative f where
>   pure :: a -> f a
>   (<*>) :: f (a -> b) -> f a -> f b
>   (<$>) :: (a -> b) -> f a -> f b
>   (<$>) = fmap

Here's how the Maybe type is defined as an Applicative Functor:

> instance Applicative Maybe where
>   pure = Just
>   Nothing <*> _ = Nothing
>   Just f <*> Nothing = Nothing
>   Just f <*> Just x = Just $ f x

This time around, we can only carry out function application if both Maybe
values are Justs. If either is a Nothing, we are either lacking a function to
apply or a value to apply it to!

Now, we can do:

> _ = pure (*2) <*> Just 5

Here, the <*> "operator" is just like function application, except lifted to
functors.

More importantly, due to the currying of functions, we can also do:

> _ = pure (*) <*> Just 2 <*> Just 5

Or, equivalently:

> _ = fmap (*) (Just 2) <*> Just 5

Which allows us to simply write:

> _ = (*) <$> Just 2 <*> Just 5

If we wanted to, we could easily implement arbitrary arity lifts, e.g.,

> liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
> liftA2 f a1 a2 = f <$> a1 <*> a2
> 
> liftA3 :: Applicative f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
> liftA3 f a1 a2 a3 = f <$> a1 <*> a2 <*> a3
>
> _ = let f = liftA3 (\x y z -> x + y - z)
>     in f (Just 1) (Just 3) (Just 5)

But this isn't necessary if we're willing to just write in the "applicative
style", i.e., using <*> for function application.


Functors as Computational Contexts
----------------------------------

We can think of Maybe qua Functor as providing a "computational context" for
values. "Just" represents a successful context, while "Nothing" represents a
failure. "pure" takes a value and gives us an initial (successful) context, and
the <*> operator allows us to combine it with other contexts, while
automatically detecting and propagating failure.

E.g., consider:

> _ = (\x y z -> x++y++z) <$> Just "Hello" <*> Just "Hola" <*> Just "Hi"
> _ = (\x y z -> x++y++z) <$> Just "Hello" <*> Just "Hola" <*> Nothing
> _ = (\x y z -> x++y++z) <$> Just "Hello" <*> Nothing     <*> Just "Hi"
> _ = (\x y z -> x++y++z) <$> Nothing      <*> Just "Hola" <*> Just "Hi"

The first expression is the only to succeed (with the result "HelloHolaHi"),
because all contexts being combined are "Just" values. In subsequent
expressions, the applicative machinery takes care of detecting the "Nothing" and
causing the entire expression to fail. Note that the original function (a
lambda, in this case) knows nothing about the possibility of failure.


Lists as Applicative Functors
-----------------------------

Here's how we make lists applicative functors.

> instance Applicative [] where
>   pure x = [x]
>   fs <*> xs = [f x | f <- fs, x <- xs]

The <*> operator for lists will go through all the different ways of combining
elements from its two arguments. When used as follows:

> _ = pure (+2) <*> [1..5] -- => [3,4,5,6,7]

I.e., where the first list only contains one value, this behaves just like fmap
(and map). When applied to multi-valued lists, however:

> _ = [(*2), (*3)] <*> [1..5] -- => [2,4,6,8,10,3,6,9,12,15]

or, equivalently:

> _ = pure (*) <*> [2,3] <*> [1..5]

We get the results of *all* the combinations of functions and arguments drawn
from the lists in the expression.

The computational context represented by a non-empty list can be thought of as
one where there are many different "answers" to the expression being
evaluated. The applicative machinery automatically combines list functors to
yield all these answers. This is sometimes referred to as *non-deterministic
programming* --- i.e., where we come up with not one, but all possible answers
to a particular problem.

Here's the cartesian product function implemented trivially with lifting:

> cartesianProd :: [a] -> [b] -> [(a,b)]
> cartesianProd = liftA2 (,)

But what happens when we insert an empty list into an applicative application?

> _ = pure (*) <*> [] <*> [1..10] -- => []

Just as with Nothing for the Maybe functor, empty lists represent "failure" ---
i.e., no possible way of computing a result.


The road forward
----------------

Applicatives are useful when we want to apply pure functions to functors, but
what happens when the functions we want to apply can themselves fail (i.e.,
produce some computational context)?

E.g., consider a collection of binary, numeric functions which each may either
fail or compute a result:

> binFuncA :: Num a => a -> a -> Maybe a
> binFuncA = undefined
>
> binFuncB :: Num a => a -> a -> Maybe a
> binFuncB = undefined
>
> binFuncC :: Num a => a -> a -> Maybe a
> binFuncC = undefined

Having used one of the functions, we'd like to use its result in another
function of the collection, and so on --- each time taking into account the
possibility of failure, e.g.,

    let r1 = binFuncA a b
        r2 = binFuncB r1 c
    in binFuncC r2 d

This code is incorrect, of course, because the results (r1, r2) of the functions
are Maybe values, while the inputs are just numbers.

The applicative style doesn't quite work here either, i.e., we can't do
something like:

    let r1 = binFuncA <$> Just a <*> Just b
        r2 = binFuncB <$> r1 <*> Just c
    in binFuncC <$> r2 <*> Just d

because the applicative style expects functions to be pure, while the binFuncs
produce their own context as output.

So ... what we need is another type of functor that accept functions which
produce functors as output --- these outputs must somehow be combined with the
original functors in order to preserve all computational context.
