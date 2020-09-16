> import Prelude hiding (Functor, fmap, (<$),
>                        Applicative, pure, (<*>), sequenceA,
>                        Monad, (>>=), (>>), return, fail,
>                        State)
> import qualified Prelude as P
> import Data.List
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
>
> class (Functor f) => Applicative f where
>   pure :: a -> f a
>   (<*>) :: f (a -> b) -> f a -> f b
>   (<$>) :: (a -> b) -> f a -> f b
>   (<$>) = fmap
> 
> instance Applicative Maybe where
>   pure = Just
>   Nothing <*> _ = Nothing
>   Just f <*> Nothing = Nothing
>   Just f <*> Just x = Just $ f x
>
> instance Applicative [] where
>   pure x = [x]
>   fs <*> xs = [f x | f <- fs, x <- xs]

% 11 Monads
% Michael Saelee
% March 15, 2019

  
Monads
======

The Monad typeclass further extends applicatives so that they support a new
operator, >>=, called "bind".

> class Applicative m => Monad m where
>   (>>=) :: m a -> (a -> m b) -> m b
>   return :: a -> m a
>   return = pure -- "default" implementation

The >>= operator takes a monad, applies a function to its contents to produces a
new monad, and combines (binds) the two monads to produce a final result. The
binding operation effectively combines the computational contexts of the
incoming monad and the one produced by the function.

> instance Monad Maybe where
>   Nothing >>= _ = Nothing
>   Just x >>= f = f x
>   return = Just

Let's consider some functions that produce Maybe monads, i.e., which return
values in a context of success or failure.

> censor :: String -> Maybe String
> censor "foobar" = Nothing
> censor s = Just s

> (/!) :: (Fractional a, Eq a) => a -> a -> Maybe a
> _ /! 0 = Nothing
> n /! m = Just $ n/m

Let's use them with the bind operator:

> _ = Just "okay" >>= censor -- => Just "okay"
> _ = Just "foobar" >>= censor -- => Nothing
> _ = Nothing >>= censor -- => Nothing

Note that the first two are equivalent to:

> _ = return "okay" >>= censor -- => Just "okay"
> _ = return "foobar" >>= censor -- => Nothing

A common pattern is to do:

> _ = Just "okay" >>= (\s -> censor s)

The lambda returns the result of "censor", which returns a monad, so it can be
used on the right side of the bind operator.

> _ = Just 20 >>= \x -> Just 10 >>= \y -> x /! y -- => 2.0

Keep in mind that lambdas (starting with '\') extend as far "to the right" as
they can. A parenthesized version clearly revealing the lambda structure is:

> _ = Just 20 >>= \x -> (Just 10 >>= \y -> (x /! y))

We can now chain together multiple (/!) expressions:

> _ = Just 10 >>= \w ->
>     Just 20 >>= \x ->
>     Just 40 >>= \y ->
>     y /! x >>= \z ->
>     w /! z -- => Just 5.0

Which can fail:

> _ = Just 10 >>= \w ->
>     Just 0  >>= \x ->
>     Just 40 >>= \y ->
>     y /! x >>= \z ->
>     w /! z -- => Nothing

This pattern is so common and useful that Haskell provides a special syntax:
"do" notation. The previous examples can be written:

> _ = do
>   s <- Just "okay"
>   censor s
>
> _ = do
>   w <- Just 10
>   x <- Just 20
>   y <- Just 40
>   z <- y /! x
>   w /! z

Each line in a do block represents a monadic value, and "<-" appears to allow us
to "extract" the contents of a monadic value. Behind the scenes, what's really
going on is that the bind operator (>>=) is automatically being invoked
"between" lines!


The List Monad
--------------

Just as with the list applicative, the list monad supports nondeterministic
programming via its bind operator.

> instance Monad [] where
>   xs >>= f = concat [f x | x <- xs]

Consider:

> noun_phrases = do
>   article <- ["The", "A", "This"]
>   adjective <- ["red", "quick", "fuzzy"]
>   noun <- ["fox", "couch", "torpedo"]
>   return $ intercalate " " [article, adjective, noun]
