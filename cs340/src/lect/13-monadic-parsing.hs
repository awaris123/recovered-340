data State s a = State { run :: s -> Maybe (a,s) }

instance Functor (State s) where
    fmap f st = State $ \s -> case run st s of 
       			      Nothing -> Nothing 
       			      Just(x, s') -> Just (f x, s')

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


item :: Parser Char
item = State $ \str -> if str == "" then Nothing else (Just (head str, tail str))

class Applicative f => Alternative f where
  empty :: f a
  (<|>) :: f a -> f a -> f a

  many :: f a -> f[a] -- zero or more
  some :: f a -> f[a] -- one or more

  many x = some x <|> pure [] 
  some x = pure (:) <*> x <*> many x

instance Alternative (State s) where
  empty = State $ \s -> Nothing
  
  p <|> q = State $ \s -> case run p s of Nothing -> run q s (r -> r)   



sat :: (Char -> Bool) -> Parser Char
sat p = do c <- item
	if p c then retuen c else empty

digit :: Parser Char
digit = sat isDigit

nat :: Parser Int
nat = do cs <- some digit
	return (read cs)
int :: Parser Int
int = do char '-'
	n <- nat
	return(-n)
      <|> nat

space :: Parser()
space = do many(sat isSpace)
	return ()

char :: Char -> Parser Char
char c = sat (==c) 
string :: String -> Parser String
string  (x:xs) = do char x 
		string xs
		return (x:xs)

token :: Parser a  -> Parser a
token p = d do space 
		p <- x
		space
		return x
symbol :: String -> Parser String
symbol s = token (string s)

integer :: Parser Int
integer = token int

ints :: Parser [Int] 
ints = do symbol "[" 
	  n <- integer
	ns <- many (do symbol ","
	   integer) 
	symbol "]"
	return (n:ns)




