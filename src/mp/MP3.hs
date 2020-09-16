-- Name: Aakef Waris              |
-- Assignment: MP3 Mondic Parsing |
-- Due Date: April 21st 2019      |
-----------------------------------

import Data.Char

data State s a = State { run :: s -> Maybe (a, s) }

instance Functor (State s) where
  fmap f st = State $ \s -> case run st s of
                              Nothing -> Nothing
                              Just (x, s') -> Just (f x, s')

instance Applicative (State s) where
  pure x = State $ \s -> Just (x, s)
  stf <*> stx = State $ \s -> case run stf s of
                                Nothing -> Nothing
                                Just (f, s') -> run (fmap f stx) s'

instance Monad (State s) where
  st >>= f = State $ \s -> case run st s of
                             Nothing -> Nothing
                             Just (x, s') -> run (f x) s'

type Parser a = State String a

class Applicative f => Alternative f where
  empty :: f a
  (<|>) :: f a -> f a -> f a

  many :: f a -> f [a] -- zero or more
  some :: f a -> f [a] -- one or more

  many x = some x <|> pure []
  some x = pure (:) <*> x <*> many x

instance Alternative (State s) where
  empty = State $ \s -> Nothing

  p <|> q = State $ \s -> case run p s of Nothing -> run q s
                                          r -> r

item :: Parser Char
item = State $ \str -> case str of "" -> Nothing
                                   (c:cs) -> Just (c, cs)

sat :: (Char -> Bool) -> Parser Char
sat p = do c <- item
           if p c then return c else empty

digit :: Parser Char
digit = sat isDigit

letter :: Parser Char
letter = sat isAlpha

alphanum :: Parser Char
alphanum = sat isAlphaNum

nat :: Parser Int
nat = do cs <- some digit
         return (read cs)

int :: Parser Int
int = do char '-'
         n <- nat
         return (-n)
      <|> nat

space :: Parser ()
space = do many (sat isSpace)
           return ()

char :: Char -> Parser Char
char c = sat (==c)

string :: String -> Parser String
string "" = return ""
string (x:xs) = do char x
                   string xs
                   return (x:xs)

token :: Parser a -> Parser a
token p = do space
             x <- p
             space
             return x

symbol :: String -> Parser String
symbol s = token (string s)

integer :: Parser Int
integer = token int

ints :: Parser Int
ints = do symbol "["
          n <- integer
          ns <- many (do symbol ","
                         integer)
          symbol "]"
          return $ sum (n:ns)

identifier :: Parser String
identifier = token $ do l <- letter
                        ls <- many alphanum
                        return (l:ls)


paramList :: Parser [String]
paramList = ((do char '('
                 typename
                 name <- identifier
                 names <- many (do symbol ","
                                   typename
                                   identifier)
                 char ')'
                 return (name:names))
               <|>
                  (do symbol "("
                      symbol ")"
                      return [] ))

varDecs :: Parser [String]
varDecs = do typename
             var <- identifier
             char ';'
             return ([var])
            <|>
              (do typename
                  var <- identifier
                  vars <- many (do symbol ","
                                   identifier)
                  char ';'
                  return (var:vars))


retVal :: Parser (String)
retVal = do symbol "return "
            val <- identifier
            symbol ";"
            return  val
            <|>
              do symbol "return "
                 val <- integer
                 symbol ";"
                 return $ show val



assignment :: Parser()
assignment  =  do identifier
                  char '='
                  identifier
                  char ';'
                  return ()
                  <|>
                      do identifier
                         char '='
                         integer
                         char ';'
                         return ()

combineAll :: [[String]] -> [String]
combineAll [] = []
combineAll ([]:vs) = combineAll vs
combineAll ((x:xs):vs) = x:combineAll (xs:vs)


funcBody :: Parser ([String], String)
funcBody = token $ do char '{'
                      decs <- many $ varDecs
                      many $ assignment
                      ret <- retVal
                      char '}'
                      return(combineAll decs,ret)
                   <|>
                      do
                        char '{'
                        many $ string " "
                        char '}'
                        return([""],"")


typename :: Parser()
typename = do (symbol "int" <|> symbol "char")
              return ()


funcDef :: Parser (String, [String],[String],String)
funcDef = do (symbol "int" <|> symbol "char")
             name <- identifier
             params <- paramList
             tup <- funcBody
             return (name, params,fst tup, snd tup)

-- Test Cases --

testCase1 = "int foo1() { }"
testCase2 = "int foo2(char param1) { }"
testCase3 = "char foo3(char param1) { \
           \   return param1; \
           \ }"
testCase4 = "char foo4(char param1) { \
           \   return -1; \
           \ }"
testCase5 = "char foo5(char p1, char p2, int p3) { \
           \   return 0; \
           \ }"
testCase6 = "char foo6(char p1, char p2, int p3) { \
           \   char local1; \
           \   return local1; \
           \ }"
testCase7 = "char foo7(char p1, char p2, int p3) { \
           \   char l1, l2, l3; \
           \   int l4, l5, l6;  \
           \   return -1; \
           \ }"
testCase8 = "char foo8(int p1, int p2, int p3) { \
           \   char buf1; \
           \   int n, m; \
           \   char buf2; \
           \   n = m; \
           \   buf1 = 10; \
           \   buf2 = -20; \
           \   return 100; \
           \ }"

failCase1 = "foo() { }"
failCase2 = "void foo() { }"
failCase3 = "int foo(int) { }"
failCase4 = "int foo(int i,) { }"
failCase5 = "int foo(char i) { \
           \   return i \
           \ }"
failCase6 = "int foo(char i) { \
           \   char l \
           \   return l; \
           \ }"
failCase7 = "int foo(char i) { \
           \   return l; \
           \   char l; \
           \ }"
failCase8 = "int foo(char i) { \
           \   char l; \
           \   return l; \
           \   l = 10; \
           \ }"
failCase9 = "int foo(char i) { \
           \   l = 10; \
           \   char l; \
           \   return l; \
           \ }"
