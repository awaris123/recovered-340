% 01 Haskell Language Basics
% Michael Saelee
% Jan 23, 2019

Bindings and Purity
-------------------

* In Haskell, once we bind a value to a variable, we can't change that
  binding (though new bindings may shadow existing ones in containing
  scopes)

* Bindings may be established using `=` or when we call functions with
  parameters (which are bound to local variables)

* Variable names must start with a lowercase letter

> 
>

* Some potentially surprising facts:

  * The order of bindings in a Haskell program is not important

  * The value of a binding is only evaluated when needed (try `undefined`)

  * A symbol being bound is in scope with its own definition

> x = error "Die!"
> y = undefined -- similar as above
> z = z + 1

Simple Types and Operations
---------------------------

* Haskell has predefined types and operators (functions) for numbers, Booleans,
  Chars, Strings, and lots more --- ["Prelude"][1] is the module that Haskell
  imports by default into all programs which defines all the standard
  types/functions

* The type of every expression is known at compile time, so "badly-typed"
  expressions are automatically reported (and don't compile!)

* The `:type` (`:t`) and `:info` (`:i`) ghci commands let us inspect types
  interactively

[1]: http://hackage.haskell.org/package/base-4.12.0.0/docs/Prelude.html

> a = 10
> b = 2^1000 -- Integer type has unlimited precision
> c = (True || False) && True
> d = 1000 == 1001
> e = 1000 /= 1001 -- note: weird not-equal-to
>

* Operators are just functions whose names start with non-letters, and are
  used in infix form (e.g., `+`)

  * Operators can be used in prefix form if we place them in parentheses

* Functions are called in prefix form, where the function name precedes
  arguments being passed to it --- parentheses are not needed (unless
  explicitly controlling precedence or creating tuples)

  * Function can be used in infix form if we place them in backticks (``)

>
>
>

* The type specification for a function looks like this: type1 -> type2 ->
    ... -> typeN

  * Note: `->` associates to the right (how to parenthesize the above?)

  * This tells us that a function of *N* arguments can be viewed as a function
    of *one* argument that returns a function of *N-1* arguments!

>
>
>
  
Defining Functions
------------------

* Functions are typically defined with `=`

* A function definition starts with its name, is followed by its formal
  parameters, then `=`, then an *expression* that is to be evaluated to
  determine the result of the function

* Note that a function is just another type of value that we bind to a
  variable (its name) using `=` --- we can also pass functions as values
  to other functions and return them as results

> 
>
>

