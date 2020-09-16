More on Monads
==============

From here on, we'll be defining instances of the built-in Haskell functor
typeclesses (Functor, Applicative, Monad), so that "do" notation can be used
correctly (previously, we lucked out because the instances we defined were
already found in the Haskell library).

Sequencing
----------

In addition to return and bind, the Monad typeclass defined by Haskell includes
an additional method, >>, shown below:

  class Monad m where
    return :: a -> m a
    (>>=)  :: m a -> (a -> m b) -> m b
    (>>)   :: m a -> m b -> m b

How do we interpret this in the context of do notation?

  
A Simple Logging Monad
----------------------

> data Logger a = Logger {
>   logval :: a,
>   logmsg :: String
> } deriving (Show)
>
> instance Functor Logger where
>   fmap f (Logger x l) = undefined
>
> instance Applicative Logger where
>   pure x = undefined
>   (Logger f l1) <*> (Logger x l2) = undefined
>
> instance Monad Logger where
>   (Logger x l) >>= f = undefined
> 

> loggedVal :: Show a => a -> Logger a
> loggedVal x = undefined
> 
> loggedOp :: Show a => String -> a -> Logger a
> loggedOp op x = undefined

> logeg1 = do
>   x <- loggedVal 10
>   y <- loggedVal 5
>   loggedOp "Add" $ x + y

> logAppend :: String -> Logger ()
> logAppend l = Logger () l

> logeg2 = do
>   logAppend "Starting"
>   x <- loggedVal 10
>   logAppend "Doing something crazy"
>   y <- loggedVal 5
>   loggedOp "Add" $ x + y

State Monad
-----------

> data State s a = State { runState :: s -> (a,s) }
>
> instance Functor (State s) where
>   fmap f st = undefined
>
> instance Applicative (State s) where
>   pure x = undefined
>   stf <*> stx = undefined
> 
> instance Monad (State s) where  
>    return x = undefined
>    st >>= f = undefined

> pop :: State [Int] Int  
> pop = undefined
>   
> push :: Int -> State [Int] ()  
> push a = undefined


> stackArith :: State [Int] Int
> stackArith = do
>   push 1
>   push 2
>   push 3
>   a <- pop
>   b <- pop
>   push a
>   push b
>   push $ a * b
>   pop
