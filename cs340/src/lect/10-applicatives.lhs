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

Let's define the `Maybe` instance:

> instance Applicative Maybe where
>   pure = undefined
>   (<*>) = undefined


If we wanted to, we can now easily implement arbitrary arity lifts, e.g.,

> liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
> liftA2 f a1 a2 = undefined
> 
> liftA3 :: Applicative f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
> liftA3 f a1 a2 a3 = undefined


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


Lists as Applicative Functors
-----------------------------

Here's how we make lists applicative functors.

> instance Applicative [] where
>   pure x = undefined
>   fs <*> xs = undefined


The computational context represented by a non-empty list can be thought of as
one where there are many different "answers" to the expression being
evaluated. The applicative machinery automatically combines list functors to
yield all these answers. This is sometimes referred to as *non-deterministic
programming* --- i.e., where we come up with not one, but all possible answers
to a particular problem.

Here's the cartesian product function implemented trivially with lifting:

> cartesianProd :: [a] -> [b] -> [(a,b)]
> cartesianProd = liftA2 (,)


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

Is this correct?


The applicative style is also kind of awkward here:

    binFuncC <$> (binFuncB <$> (binFuncA <$> Just a <*> Just b) <*> Just c) Just d


So ... what we need is another type of functor that accept functions which
produce functors as output --- these outputs must somehow be combined with the
original functors in order to preserve all computational context.
