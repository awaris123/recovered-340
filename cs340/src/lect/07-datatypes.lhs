> import Data.Char
  
% 07 Data Types
% Michael Saelee
% March 1, 2019

Agenda
------

- Type Synonyms: `type` and `newtype`
- Algebraic data types
- Polymorphic types

  
Type Synonyms
-------------

`type` defines *type synonyms*. A type synonym is strictly a compile time
construct, and is used for legibility/documentation. At run-time, the type
synonym is replaced by the actual type in all contexts.

> type Letter = Char
> type Words = [Letter]
>
> caesar :: Words -> Int -> Words
> caesar "" _ = ""
> caesar s 0  = s
> caesar (c:cs) n = encrypt c : caesar cs n
>   where encrypt c
>           | isLetter c = undefined
>           | otherwise  = c
>
> type Point2D = (Double, Double)
> 
> distance :: Point2D -> Double
> distance (x,y) = sqrt $ x^2 + y^2
>
> type Vector3D = (Double, Double, Double)
>
> dot :: Vector3D -> Vector3D -> Double
> dot (a1,b1,c1) (a2,b2,c2) = a1*a2 + b1*b2 + c1*c2
>
> type IntMatrix = [[Int]]
>
> sumAll :: IntMatrix -> Int
> sumAll = sum . map sum


`newtype` defines new types from existing types, giving us a *data constructor*
(aka *value constructor*) we can use to create new values of the new type. We
can also pattern match against the value constructor

> newtype Flags = ListOfBools [Bool]
> 
> or' :: Flags -> Bool
> or' = undefined

Note:
- `Flags` is the type name, and `ListOfBools` is the data constructor.
- the data constructor is just a function that, when called with the field type,
  returns the type associated with the constructor

Because types and functions are in separate namespaces, it is possible (and
typical) to have overlapping names for types and data constructors.

> newtype Point3D = Point3D (Double, Double, Double)
>
> distance3D :: Point3D -> Double
> distance3D = undefined


A type defined using `newtype` is similar to a type synonym in that it is
always based on a single existibng type, but a type defined using `newtype` is
not seen by the compiler as being equivalent to the type it is based on!

E.g., the following `distance3D'` function *will not* accept a Point3D value!

> distance3D' :: (Double, Double, Double) -> Double
> distance3D' (x,y,z) = sqrt $ x^2 + y^2 + z^2


Algebraic Data Types
--------------------

The `data` keyword allows us to create new data types with one or more
data constructors, each specifying any number of constituent types.

> 

Polymorphic Types
-----------------

Polymorphic types allow us to create types that are parameterized.

> 
