% 02 Types and Functions
% Michael Saelee
% Jan 25, 2019

Basic Types
-----------

- Bool    - True/False
- Char    - Unicode character
- Int     - 64 bit signed integer
- Integer - arbitrary-precision integer
- Float   - 32-bit IEEE single-precision floating point number
- Double  - 64-bit IEEE double-precision floating point number
- Tuple   - finite (i.e., of a given arity) sequence of different types

Note, all types have capitalized names!

Note: `:t` can be used to ask for the type of any expression

< -- try out
< :t True
< :t False || True
< :t 'a'
< :t 5
< :t sqrt 5


Function Types
--------------

A function is a mapping (->) from one type (the domain) to another type (the
range).  

< -- e.g.,
< not  :: Bool -> Bool
< even :: Int  -> Bool

A function of multiple arguments can be implemented in one of two ways:

1. A function that takes a tuple of the requisite types

< foo :: (Int, Bool, Char) -> Int

2. A *curried* function

< foo :: Int -> Bool -> Char -> Int

   Note: (->) associates right-to-left, so, equivalent to:

< foo :: Int -> (Bool -> (Char -> Int))

   I.e., foo is a function which takes an Int and
         returns a function which takes a Bool ...

   Function application (space) associates left-to-right, so:

< foo 5 True 'a'

   is equivalent to:

< (((foo 5) True) 'a')

Inspect the types of `id`, `const`, `fst`, and `snd`. Discuss.


Polymorhic Types
----------------

In the type `a -> b`, `a` and `b` are *type variables*. Since they are
unqualified, they can be replaced with any type! A type containing a type
variable is a *polymorphic* type.

Since an unqualified type variable says nothing about its actual type,
you can't do much with it (why?)

But this means the type of a polymorphic function is usually very helpful
in determining what it does!

e.g., what do `id`, `const`, `fst`, `snd` do?

Inspect the types of `==`, `+`, `show`, `read`


Overloaded Types and Type Classes
---------------------------------

< (+) :: Num a => a -> a -> a

Above, `Num a` is a *class constraint*, implying that the actual type of
type variable `a` must belong to the *type class* `Num`.

A type that contains a class constraint is called *overloaded*. I.e., (+)

A *class* is a collection of types that support a set of overloaded
functions called *methods*. Each type belonging to a given class is called
an *instance* of that class.

`:i` gives us information on both types and classes.

< -- try out
< :i Int
< :i Integral
< :i Num
< :i Eq
< :i Ord
< :i Show
< :i Read


Function Type Declarations
--------------------------

Though Haskell can infer types for us, it is good practice to always explitly
declare types for all our functions.

> -- declare the types for the following:
>
> 
> nand a b = not (a && b)
>
> 
> sum x y = x + y
>
>
> fst' (x,y) = x
> 
>
> disc (a,b,c) = b^2-4*a*c
>
> 
> quad_roots a b c = ((-b+(sqrt d))/(2*a), (-b-(sqrt d))/(2*a))
>   where d = disc (a,b,c)
>
>
> comp a b c d = if a == b then c else d
>
> 
> sum_or_diff a b = if a > b then a - b else a + b
>


